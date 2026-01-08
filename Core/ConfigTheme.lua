local Name, AddOn = ...
local Theme = {}
AddOn.ConfigTheme = Theme

Theme.Current = "Default"
local unpack = unpack

Theme.Fonts = {
  Normal = "Interface\\AddOns\\NoobTacoUI\\Media\\Fonts\\Poppins-Regular.ttf",
  Bold = "Interface\\AddOns\\NoobTacoUI\\Media\\Fonts\\Poppins-SemiBold.ttf",
}

Theme.Presets = {
  Default = {
    background = { 0.1, 0.1, 0.1, 0.9 },
    header = { 0.2, 0.2, 0.2, 1 },
    border = { 0.4, 0.4, 0.4, 1 },
    text = { 1, 1, 1, 1 },
    highlight = { 1, 0.82, 0, 1 },
    button = {
      normal = { 0.2, 0.2, 0.2, 1 },
      hover = { 0.3, 0.3, 0.3, 1 },
      selected = { 0.2, 0.6, 1, 1 },
      text = { 1, 1, 1, 1 },
    },
    alert = {
      warning = { 1, 0.6, 0, 1 },
      error = { 1, 0.2, 0.2, 1 },
      info = { 0.2, 0.6, 1, 1 },
    }
  },
  Nord = {
    background = { 0.18, 0.20, 0.25, 0.95 }, -- Polar Night
    header = { 0.23, 0.26, 0.32, 1 },
    border = { 0.37, 0.42, 0.49, 1 },
    text = { 0.93, 0.94, 0.96, 1 },       -- Snow Storm
    highlight = { 0.53, 0.75, 0.82, 1 },  -- Frost
    button = {
      normal = { 0.29, 0.33, 0.41, 1 },   -- Nord3
      hover = { 0.37, 0.42, 0.49, 1 },    -- Nord3 Light
      selected = { 0.53, 0.75, 0.82, 1 }, -- Frost
      text = { 0.93, 0.94, 0.96, 1 },
    },
    alert = {
      warning = { 0.92, 0.80, 0.55, 1 }, -- Aurora Yellow
      error = { 0.75, 0.38, 0.45, 1 },   -- Aurora Red
      info = { 0.56, 0.73, 0.80, 1 },    -- Frost Blue
    }
  },
  Catppuccin = {
    background = { 0.12, 0.12, 0.17, 0.95 }, -- Mocha Base
    header = { 0.19, 0.20, 0.27, 1 },        -- Mantle
    border = { 0.36, 0.38, 0.49, 1 },        -- Surface
    text = { 0.80, 0.84, 0.93, 1 },          -- Text
    highlight = { 0.78, 0.65, 0.94, 1 },     -- Mauve
    button = {
      normal = { 0.19, 0.20, 0.27, 1 },      -- Mantle
      hover = { 0.36, 0.38, 0.49, 1 },       -- Surface1
      selected = { 0.78, 0.65, 0.94, 1 },    -- Mauve
      text = { 0.80, 0.84, 0.93, 1 },
    },
    alert = {
      warning = { 0.98, 0.78, 0.62, 1 }, -- Peach
      error = { 0.96, 0.48, 0.52, 1 },   -- Red
      info = { 0.53, 0.75, 1, 1 },       -- Sapphire
    }
  }
}

function Theme:GetColor(key)
  local preset = self.Presets[self.Current] or self.Presets.Default

  if key == "background" then return unpack(preset.background) end
  if key == "header" then return unpack(preset.header) end
  if key == "border" then return unpack(preset.border) end
  if key == "text" then return unpack(preset.text) end
  if key == "highlight" then return unpack(preset.highlight) end
  if key == "button_normal" then return unpack(preset.button.normal) end
  if key == "button_hover" then return unpack(preset.button.hover) end
  if key == "button_selected" then return unpack(preset.button.selected) end
  if key == "button_text" then return unpack(preset.button.text) end

  return 1, 1, 1, 1
end

function Theme:GetFont(weight)
  return self.Fonts[weight] or self.Fonts.Normal
end

function Theme:GetAlertColor(severity)
  local preset = self.Presets[self.Current] or self.Presets.Default
  local color = preset.alert[severity] or preset.alert.info
  return unpack(color)
end

function Theme:UpdateButtonState(btn)
  local r, g, b, a = self:GetColor("button_" .. (btn.isSelected and "selected" or (btn.isHover and "hover" or "normal")))
  btn.bg:SetColorTexture(r, g, b, a)
end

function Theme:ApplyFont(fontString, weight, size)
  if not fontString then return end
  fontString:SetFont(self:GetFont(weight or "Normal"), size or 12, "")
end

function Theme:CreateThemedButton(parent)
  local btn = CreateFrame("Button", nil, parent)

  -- Background
  local bg = btn:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  btn.bg = bg

  -- Text
  local text = btn:CreateFontString(nil, "OVERLAY")
  text:SetFont(self:GetFont("Normal"), 12)
  text:SetPoint("CENTER")
  text:SetTextColor(self:GetColor("button_text"))
  btn.Text = text

  -- Scripts
  btn:SetScript("OnEnter", function(b)
    b.isHover = true
    self:UpdateButtonState(b)
  end)
  btn:SetScript("OnLeave", function(b)
    b.isHover = false
    self:UpdateButtonState(b)
  end)
  btn:SetScript("OnEnable", function(b)
    self:UpdateButtonState(b)
  end)
  btn:SetScript("OnDisable", function(b)
    -- Optional: dim?
  end)

  -- Methods
  btn.SetSelected = function(b, selected)
    b.isSelected = selected
    self:UpdateButtonState(b)
  end

  -- Init
  self:UpdateButtonState(btn)

  return btn
end

function Theme:SetTheme(themeName)
  if self.Presets[themeName] then
    self.Current = themeName
    -- Trigger refresh callback if needed
    if self.OnThemeChanged then
      self.OnThemeChanged()
    end
  end
end
