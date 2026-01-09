local _, AddOn = ...

-- Lua Globals
local pairs = pairs

-- Blizzard Globals
local wipe = wipe

local ConfigState = {}
AddOn.ConfigState = ConfigState

ConfigState.ActiveDB = nil
ConfigState.TempConfig = {}
ConfigState.IsDirty = false
ConfigState.OnDirtyChanged = nil -- Callback function

function ConfigState:Initialize(dbTable)
  self.ActiveDB = dbTable
  self.TempConfig = {}
  self.IsDirty = false

  -- Deep copy ActiveDB to TempConfig
  self:Revert()
end

function ConfigState:SetValue(key, value)
  if not self.ActiveDB then return end

  self.TempConfig[key] = value

  -- Check against ActiveDB to determine dirty state
  -- Simple comparison for now, might need deep compare for tables

  -- We need to check GLOBAL dirty state, not just this key
  -- This is a simplified check. Ideally iterate all keys if needed.
  -- For performance, we can just assume if ANY set happens and it's different, we might be dirty.
  -- But if we revert a single value back to original, we might still be dirty from others.
  -- Let's just do a full check or track dirty count?

  self:CheckDirtyState()
end

function ConfigState:GetValue(key)
  if self.TempConfig then
    return self.TempConfig[key]
  end
  return self.ActiveDB and self.ActiveDB[key]
end

function ConfigState:CheckDirtyState()
  local wasDirty = self.IsDirty
  self.IsDirty = false

  for k, v in pairs(self.TempConfig) do
    if self.ActiveDB[k] ~= v then
      self.IsDirty = true
      break
    end
  end

  if self.IsDirty ~= wasDirty and self.OnDirtyChanged then
    self.OnDirtyChanged(self.IsDirty)
  end
end

function ConfigState:Commit()
  if not self.ActiveDB then return end

  for k, v in pairs(self.TempConfig) do
    self.ActiveDB[k] = v
  end

  self.IsDirty = false
  if self.OnDirtyChanged then self.OnDirtyChanged(false) end

  -- Trigger global update event if needed
  if AddOn.OnConfigChanged then
    AddOn.OnConfigChanged()
  end
end

function ConfigState:Revert()
  if not self.ActiveDB then return end

  -- Wipe Temp
  wipe(self.TempConfig)

  -- Copy Active -> Temp
  for k, v in pairs(self.ActiveDB) do
    self.TempConfig[k] = v
  end

  self.IsDirty = false
  if self.OnDirtyChanged then self.OnDirtyChanged(false) end
end
