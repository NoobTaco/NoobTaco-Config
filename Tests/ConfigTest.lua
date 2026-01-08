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
    local function TryRender()
      local width = canvas:GetWidth()
      -- Only render if width is valid and changed
      if width > 10 and (not canvas.lastRenderedWidth or math.abs(canvas.lastRenderedWidth - width) > 5) then
        self:RenderContent(canvas)
        canvas.lastRenderedWidth = width
      end
    end

    canvas:SetScript("OnShow", TryRender)
    canvas:SetScript("OnSizeChanged", TryRender)
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
        style = "INFO",
        onButtonClick = function() print("Get Import String Clicked") end
      },
      {
        type = "callout",
        title = "STEP 3: SUCCESS EXAMPLE",
        text = "This is a success callout. It should be green.",
        buttonText = "SUCCESS BUTTON",
        style = "success",
        onButtonClick = function() print("Success Clicked") end
      },
      {
        type = "callout",
        title = "STEP 4: ERROR EXAMPLE",
        text = "This is an error callout. It should be red.",
        buttonText = "ERROR BUTTON",
        style = "error",
        onButtonClick = function() print("Error Clicked") end
      },

      { type = "header", label = "Theme Testing" },
      {
        type = "button",
        label = "Apply Custom Theme",
        onClick = function()
          -- Create a deep copy of Default to avoid mutating it
          local function deepCopy(orig)
            local orig_type = type(orig)
            local copy
            if orig_type == 'table' then
              copy = {}
              for orig_key, orig_value in next, orig, nil do
                copy[deepCopy(orig_key)] = deepCopy(orig_value)
              end
              setmetatable(copy, deepCopy(getmetatable(orig)))
            else -- number, string, boolean, etc
              copy = orig
            end
            return copy
          end

          local testTheme = deepCopy(AddOn.ConfigTheme.Presets.Default)
          testTheme.alert.success = { 0, 1, 1, 1 }     -- Cyan for success
          testTheme.button.normal = { 0.5, 0, 0.5, 1 } -- Purple Buttons

          AddOn.ConfigTheme:RegisterTheme("TestTheme", testTheme)
          AddOn.ConfigTheme:SetTheme("TestTheme")
          print("Applied TestTheme (Cyan Success, Purple Buttons)")
        end
      },
      {
        type = "button",
        label = "Reset Theme",
        onClick = function()
          AddOn.ConfigTheme:SetTheme("Default")
          print("Reset to Default Theme")
        end
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

  local AboutSchema = {
    type = "group",
    children = {
      {
        type = "about",
        icon = "Interface\\AddOns\\NoobTacoUI\\Media\\Logo", -- Placeholder
        title = "NoobTaco Config",
        version = "v1.0.0",
        description =
        "This is a demo configuration library for NoobTacoUI. It provides a standardized way to build settings menus with a consistent look and feel.\n\nCreated by NoobTaco Development Team.",
        links = {
          { label = "Discord", url = "https://discord.gg/noobtaco" },
          { label = "Patreon", url = "https://patreon.com/noobtaco" },
          { label = "GitHub",  url = "https://github.com/noobtaco/config" },
        }
      },
      { type = "header", label = "Media Test" },
      {
        id = "selectedSound",
        type = "media",
        label = "Notification Sound",
        default = "Sound\\Interface\\RaidWarning.ogg", -- Default Sound
        options = {
          { label = "Raid Warning",        value = "Sound\\Interface\\RaidWarning.ogg" },
          { label = "Level Up",            value = "Sound\\Interface\\LevelUp.ogg" },
          { label = "Auction Window Open", value = "Sound\\Interface\\AuctionWindowOpen.ogg" },
          { label = "Murloc",              value = "Sound\\Creature\\Murloc\\mMurlocAggroOld.ogg" },
        }
      }
    }
  }

  local ProfilesSchema = {
    type = "group",
    children = {
      { type = "header", label = "INDIVIDUAL ADDON PROFILES" },
      {
        type = "expandable",
        label = "BetterBlizzFrames",
        expanded = false,
        children = {
          { type = "description", text = "Profile content for BetterBlizzFrames would go here." }
        }
      },
      {
        type = "expandable",
        label = "Cooldown Manager Tweaks",
        status = "NOT LOADED",
        expanded = true,
        children = {
          {
            type = "description",
            text =
            "Import a pre-configured profile for Cooldown Manager Tweaks that complements the NoobTacoUI aesthetic. This profile includes optimized tracker styling and positioning."
          },
          {
            type = "description",
            text =
            "|cff80ff00Instructions:|r\n1. Click the button below to copy the profile string\n2. Type |cffffcc00/cmt|r in chat to open Cooldown Manager Tweaks config\n3. Navigate to the |cffffcc00Profiles|r section..."
          },
          {
            type = "row",
            children = {
              {
                type = "button",
                label = "Copy Profile String",
                width = 200,
                customColors = {
                  normal = { 0.3, 0.6, 0.7, 1 }, -- Lighter Blue/Teal
                  hover = { 0.4, 0.7, 0.8, 1 },
                  selected = { 0.2, 0.5, 0.6, 1 },
                  text = { 1, 1, 1, 1 }
                },
                onClick = function() print("Copied CMT Profile") end
              },
              {
                type = "button",
                label = "Get Addon Link",
                width = 200,
                customColors = {
                  normal = { 0.3, 0.3, 0.35, 1 }, -- Lighter Grey/Blue
                  hover = { 0.4, 0.4, 0.45, 1 },
                  selected = { 0.2, 0.2, 0.25, 1 },
                  text = { 1, 1, 1, 1 }
                },
                onClick = function() print("Link: https://curseforge.com/...") end
              }
            }
          }
        }
      },
      {
        type = "expandable",
        label = "Details! Damage Meter",
        status = "NOT LOADED",
        expanded = false,
        children = {}
      },
      {
        type = "expandable",
        label = "Platynator",
        expanded = false,
        children = {}
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
    debugLevel = "WARN",
    selectedSound = "Sound\\Interface\\RaidWarning.ogg"
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
    AddOn.ConfigLayout:AddSidebarButton(layout, "profiles", "Profiles", function()
      AddOn.ConfigRenderer:Render(ProfilesSchema, layout)
    end)
    AddOn.ConfigLayout:AddSidebarButton(layout, "advanced", "Advanced", function()
      AddOn.ConfigRenderer:Render(AdvancedSchema, layout)
    end)
    AddOn.ConfigLayout:AddSidebarButton(layout, "about", "About", function()
      AddOn.ConfigRenderer:Render(AboutSchema, layout)
    end)
  end

  -- Initial Render
  AddOn.ConfigRenderer:Render(GeneralSchema, layout)
end

-- Initialize on Login
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function() ConfigTest:Initialize() end)
