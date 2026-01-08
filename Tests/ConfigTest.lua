local Name, AddOn = ...
local ConfigTest = {}

-- Only load if Config Lib is present
if not AddOn.ConfigRenderer then return end

function ConfigTest:Initialize()
  local categoryName = "NoobTaco Config Test"

  -- Create the Canvas Frame
  local canvas = CreateFrame("Frame", nil, UIParent)
  canvas:SetSize(800, 600)

  -- Register with WoW Settings API (Dragonflight/WarWithin)
  -- Note: This requires the new Settings API.
  -- If running on vanilla/classic, this might need fallback, but request was for 11.x

  if Settings and Settings.RegisterCanvasLayoutCategory then
    local category, layout = Settings.RegisterCanvasLayoutCategory(canvas, categoryName)
    Settings.RegisterAddOnCategory(category)

    -- On Show, Render the Config
    canvas:SetScript("OnShow", function()
      if not canvas.isRendered then
        self:RenderContent(canvas)
        canvas.isRendered = true
      end
    end)
  end
end

function ConfigTest:RenderContent(parent)
  local GeneralSchema = {
    type = "group",
    children = {
      { type = "header",      label = "General Settings" },
      { type = "description", text = "Here you can configure the general options for NoobTacoUI. These settings affect the overall behavior of the addon." },

      { type = "header",      label = "Interface" },
      { id = "enableMinimap", type = "checkbox",                                                                                                           label = "Show Minimap Icon",          default = true },
      { id = "globalScale",   type = "slider",                                                                                                             label = "Global Scale",               min = 0.5,         max = 2.0, step = 0.1, default = 1.0 },
      { id = "accentColor",   type = "colorpicker",                                                                                                        label = "Accent Color",               default = "00A8FF" },

      { type = "header",      label = "Notifications" },
      { id = "enableToasts",  type = "checkbox",                                                                                                           label = "Enable Toast Notifications", default = true },
      { id = "soundEnabled",  type = "checkbox",                                                                                                           label = "Play Sounds",                default = false },
    }
  }

  local AdvancedSchema = {
    type = "group",
    children = {
      { type = "header", label = "Advanced Configuration 2" },
      { type = "alert",  severity = "warning",              text = "WARNING: Caution: Changing these settings may cause instability." },
      { type = "alert",  severity = "INFO",                 text = "INFO: ALL GOOD: Another warning Box." },
      { type = "alert",  severity = "ERROR",                text = "ERROR: ALL BAD: Another warning Box." },
      { type = "alert",  severity = "SUCCESS",              text = "SUCCESS: ALL GOOD: Another warning Box." },
      {
        type = "callout",
        title = "STEP 1: MANDATORY EDIT MODE SETUP",
        text =
        "To ensure NoobTacoUI works as intended, you MUST import the optimized layout. Click the button, copy the string (CTRL+C), then open WoW Edit Mode and click 'Import'. We recommend naming the profile 'NoobTacoUI', but you can use any name you prefer.",
        buttonText = "GET IMPORT STRING",
        style = "warning",
        onButtonClick = function() print("Get Import String Clicked") end
      },
      {
        type = "callout",
        title = "STEP 2: TESTING",
        text =
        "To ensure NoobTacoUI works as intended, you MUST import the optimized layout. Click the button, copy the string (CTRL+C), then open WoW Edit Mode and click 'Import'. We recommend naming the profile 'NoobTacoUI', but you can use any name you prefer.",
        buttonText = "GET IMPORT STRING",
        style = "Information",
        onButtonClick = function() print("Get Import String Clicked") end
      },

      { type = "header", label = "Developer Options" },
      { id = "apiKey",   type = "editbox",           label = "API Key", default = "" },
      {
        id = "debugLevel",
        type = "dropdown",
        label = "Debug Level",
        default = "INFO",
        options = {
          { label = "Information", value = "INFO" },
          { label = "Warning",     value = "WARN" },
          { label = "Error",       value = "ERROR" },
        }
      },

      { type = "header", label = "Positioning" },
      {
        type = "row",
        children = {
          { id = "posX", type = "slider", label = "X Offset", min = -500, max = 500, default = 0 },
          { id = "posY", type = "slider", label = "Y Offset", min = -500, max = 500, default = 0 },
        }
      }
    }
  }

  -- Initialize State with Dummy DB
  local DummyDB = {
    enableMinimap = true,
    globalScale = 1.0,
    accentColor = "00A8FF",
    enableToasts = true,
    apiKey = "SECRET_KEY",
    debugLevel = "WARN"
  }
  AddOn.ConfigState:Initialize(DummyDB)

  -- Layout Initialization
  local layout = parent.Layout
  if not layout then
    layout = AddOn.ConfigLayout:CreateTwoColumnLayout(parent)
    parent.Layout = layout
    layout:SetScale(1.0)

    -- Populate Sidebar
    AddOn.ConfigLayout:AddSidebarButton(layout, "general", "General Settings", function()
      AddOn.ConfigRenderer:Render(GeneralSchema, layout)
    end)
    AddOn.ConfigLayout:AddSidebarButton(layout, "advanced", "Advanced", function()
      AddOn.ConfigRenderer:Render(AdvancedSchema, layout)
    end)
    AddOn.ConfigLayout:AddSidebarButton(layout, "about", "About", function() print("About Clicked") end)
  end

  -- Initial Render
  AddOn.ConfigRenderer:Render(GeneralSchema, layout)
end

-- Initialize on Login
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function() ConfigTest:Initialize() end)
