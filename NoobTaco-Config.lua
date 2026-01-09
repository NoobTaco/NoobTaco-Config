--[[
    NoobTaco-Config
    Root entry point for the configuration library.
]]

local MAJOR, MINOR = "NoobTaco-Config-1.0", 1
local Lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not Lib then return end

-- Initialize internal module references on the library object
Lib.Schema = Lib.Schema or {}
Lib.State = Lib.State or {}
Lib.Layout = Lib.Layout or {}
Lib.Renderer = Lib.Renderer or {}
Lib.Theme = Lib.Theme or {}

-- Public API
function Lib:Register(projectName, configSchema, dbTable)
    self.State:Initialize(dbTable)
    -- Registration logic...
end
