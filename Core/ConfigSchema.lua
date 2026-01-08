local _, AddOn = ...
local Schema = {}
AddOn.ConfigSchema = Schema

local VALID_TYPES = {
  ["group"] = true,
  ["checkbox"] = true,
  ["slider"] = true,
  ["colorpicker"] = true,
  ["dropdown"] = true,
  ["button"] = true,
  ["header"] = true,
  ["alert"] = true, -- New alert type
  ["row"] = true,   -- Layout helper
  ["description"] = true,
  ["editbox"] = true,
  ["callout"] = true, -- Complex alert with button
}

function Schema:Validate(definition)
  if type(definition) ~= "table" then
    return false, "Schema definition must be a table."
  end

  if definition.type and not VALID_TYPES[definition.type] then
    return false, "Invalid schema type: " .. tostring(definition.type)
  end

  -- Recursive check for children
  if definition.children then
    for i, child in ipairs(definition.children) do
      local isValid, err = self:Validate(child)
      if not isValid then
        return false, string.format("Child index %d error: %s", i, err)
      end
    end
  end

  return true
end

function Schema:NewNode(type, id, label)
  return {
    type = type,
    id = id,
    label = label
  }
end
