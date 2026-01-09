local Name, _ = ...
local Lib = LibStub("NoobTaco-Config-1.0")
local ConfigTest = {}

-- Only load if Config Lib is present
if not Lib then return end

-- ============================================================================
-- PERSISTENT SCHEMAS
-- These are defined once and persist across reloads/re-renders.
-- This prevents closures from capturing stale local references.
-- ============================================================================
ConfigTest.Schemas = {}

local function BuildSchemas()
  if ConfigTest.Schemas.General then return end -- Already built

  ConfigTest.Schemas.General = {
    type = "group",
    children = {
      { type = "header",      label = "General Settings" },
      { type = "description", text = "Here you can configure the general options for NoobTacoUI. These settings affect the overall behavior of the addon." },

      { type = "header",      label = "Interface" },
      { id = "enableMinimap", type = "checkbox",                                                                                                           label = "Show Minimap Icon", default = true },
      { id = "globalScale",   type = "slider",                                                                                                             label = "Global Scale",      min = 0.5,         max = 2.0, step = 0.1, default = 1.0 },
      { id = "accentColor",   type = "colorpicker",                                                                                                        label = "Accent Color",      default = "00A8FF" },

      { type = "header",      label = "Theme" },
      {
        id = "activeTheme",
        type = "dropdown",
        label = "UI Theme",
        default = "NoobTaco",
        options = {
          { label = "NoobTaco",   value = "NoobTaco" },
          { label = "Default",    value = "Default" },
          { label = "Nord",       value = "Nord" },
          { label = "Catppuccin", value = "Catppuccin" },
        },
        onChange = function(value)
          Lib.Theme:SetTheme(value)
        end
      },

      { type = "header",     label = "Notifications" },
      { id = "enableToasts", type = "checkbox",      label = "Enable Toast Notifications", default = true },
      { id = "soundEnabled", type = "checkbox",      label = "Play Sounds",                default = false },
    }
  }

  ConfigTest.Schemas.Advanced = {
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

          local testTheme = deepCopy(Lib.Theme.Presets.Default)
          testTheme.alert.success = { 0, 1, 1, 1 }     -- Cyan for success
          testTheme.button.normal = { 0.5, 0, 0.5, 1 } -- Purple Buttons

          Lib.Theme:RegisterTheme("TestTheme", testTheme)
          Lib.Theme:SetTheme("TestTheme")
          print("Applied TestTheme (Cyan Success, Purple Buttons)")
        end
      },
      {
        type = "button",
        label = "Reset Theme",
        onClick = function()
          Lib.Theme:SetTheme("Default")
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

  ConfigTest.Schemas.About = {
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

  ConfigTest.Schemas.Profiles = {
    type = "group",
    children = {
      { type = "header",      label = "ADDON PROFILES" },
      { type = "description", text = "Configure profiles for compatible addons. Each addon section shows import/export options and customization settings." },

      {
        type = "card",
        label = "BetterBlizzFrames",
        children = {
          { type = "description", text = "Profile content for BetterBlizzFrames would go here." },
        }
      },

      {
        type = "card",
        label = "Cooldown Manager Tweaks",
        children = {
          { type = "alert", severity = "info", text = "NOT LOADED - This addon is not currently installed." },
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
                style = "primary",
                width = 150,
                onClick = function() print("Copied CMT Profile") end
              },
              {
                type = "button",
                label = "Get Addon Link",
                width = 150,
                onClick = function() print("Link: https://curseforge.com/...") end
              }
            }
          },
        }
      },

      {
        type = "card",
        label = "Details! Damage Meter",
        children = {
          { type = "alert",       severity = "info",                                                                               text = "NOT LOADED - This addon is not currently installed." },
          { type = "description", text = "Profile content for Details! Damage Meter will appear here when the addon is installed." },
        }
      },

      {
        type = "card",
        label = "Platynator",
        children = {
          { type = "description", text = "Profile content for Platynator will appear here." },
        }
      },
    }
  }

  ConfigTest.Schemas.Buttons = {
    type = "group",
    children = {
      { type = "header",      label = "Button Style Variations" },
      { type = "description", text = "This section showcases the different button styles available in the NoobTaco-Config library." },

      { type = "header",      label = "Functional Styles" },
      {
        type = "row",
        children = {
          {
            type = "button",
            label = "Primary Button",
            style = "primary",
            width = 150,
            onClick = function()
              print(
                "Primary Clicked")
            end
          },
          {
            type = "button",
            label = "Secondary Button",
            style = "secondary",
            width = 150,
            onClick = function()
              print(
                "Secondary Clicked")
            end
          },
        }
      },

      { type = "header", label = "Semantic Alert Styles" },
      {
        type = "row",
        children = {
          {
            type = "button",
            label = "Success Button",
            style = "success",
            width = 150,
            onClick = function()
              print(
                "Success Clicked")
            end
          },
          {
            type = "button",
            label = "Info Button",
            style = "info",
            width = 150,
            onClick = function()
              print(
                "Info Clicked")
            end
          },
        }
      },
      {
        type = "row",
        children = {
          {
            type = "button",
            label = "Warning Button",
            style = "warning",
            width = 150,
            onClick = function()
              print(
                "Warning Clicked")
            end
          },
          {
            type = "button",
            label = "Error Button",
            style = "error",
            width = 150,
            onClick = function()
              print(
                "Error Clicked")
            end
          },
        }
      },

      { type = "header", label = "Custom Overrides" },
      {
        type = "row",
        children = {
          {
            type = "button",
            label = "Style + Custom Text",
            style = "primary",
            width = 180,
            customColors = { text = { 1, 0, 0, 1 } }, -- Red text on Gold button
            onClick = function() print("Custom Text Clicked") end
          },
          {
            type = "button",
            label = "Fully Custom",
            width = 180,
            customColors = {
              normal = { 0.5, 0, 0.5, 1 },
              hover = { 0.7, 0, 0.7, 1 },
              text = { 1, 1, 1, 1 }
            },
            onClick = function() print("Fully Custom Clicked") end
          },
        }
      },

      { type = "header", label = "Truncation Test" },
      {
        type = "row",
        children = {
          {
            type = "button",
            label = "This is a very long button label that should definitely truncate",
            style = "primary",
            width = 200,
            onClick = function() print("Long button clicked") end
          },
          {
            type = "button",
            label = "Another long label for a small button",
            style = "secondary",
            width = 100,
            onClick = function() print("Small long button clicked") end
          },
        }
      },
    }
  }
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
function ConfigTest:Initialize()
  local categoryName = "NoobTaco Config Test"

  -- Build schemas once
  BuildSchemas()

  -- Create the Canvas Frame
  local canvas = CreateFrame("Frame", nil, UIParent)
  canvas:SetSize(800, 600)

  -- Register with WoW Settings API (Dragonflight/WarWithin)
  if Settings and Settings.RegisterCanvasLayoutCategory then
    local category = Settings.RegisterCanvasLayoutCategory(canvas, categoryName)
    Settings.RegisterAddOnCategory(category)

    -- Deferred first render to allow WoW layout to stabilize
    local hasRenderedOnce = false

    local function TryRender()
      local width = canvas:GetWidth()
      -- Only render if width is valid and changed significantly
      if width > 10 and (not canvas.lastRenderedWidth or math.abs(canvas.lastRenderedWidth - width) > 5) then
        self:RenderContent(canvas)
        canvas.lastRenderedWidth = width
      end
    end

    canvas:SetScript("OnShow", function()
      if not hasRenderedOnce then
        -- Double-pass rendering to ensure WoW layout engine has calculated dimensions
        -- First pass: creates frames and triggers layout
        TryRender()
        -- Second pass after WoW has done a layout tick: uses correct dimensions
        C_Timer.After(0, function()
          TryRender()
          hasRenderedOnce = true
        end)
      else
        TryRender()
      end
    end)

    canvas:SetScript("OnSizeChanged", TryRender)
  end
end

function ConfigTest:RenderContent(parent)
  local Schemas = ConfigTest.Schemas

  -- Initialize State with Dummy DB (idempotent)
  local DummyDB = {
    enableMinimap = true,
    globalScale = 1.0,
    accentColor = "00A8FF",
    activeTheme = "NoobTaco",
    enableToasts = true,
    apiKey = "SECRET_KEY",
    debugLevel = "WARN",
    selectedSound = "Sound\\Interface\\RaidWarning.ogg"
  }
  Lib.State:Initialize(DummyDB)

  -- Layout Initialization (only once)
  local layout = parent.Layout
  if not layout then
    layout = Lib.Layout:CreateTwoColumnLayout(parent)
    parent.Layout = layout
    layout:SetScale(1.0)

    -- Populate Sidebar using PERSISTENT schema references
    Lib.Layout:AddSidebarButton(layout, "about", "About", function()
      Lib.State:SetValue("lastSection", "about")
      Lib.Renderer:Render(Schemas.About, layout)
    end)
    Lib.Layout:AddSidebarButton(layout, "general", "General Settings", function()
      Lib.State:SetValue("lastSection", "general")
      Lib.Renderer:Render(Schemas.General, layout)
    end)
    Lib.Layout:AddSidebarButton(layout, "profiles", "Profiles", function()
      Lib.State:SetValue("lastSection", "profiles")
      Lib.Renderer:Render(Schemas.Profiles, layout)
    end)
    Lib.Layout:AddSidebarButton(layout, "buttons", "Experiments", function()
      Lib.State:SetValue("lastSection", "buttons")
      Lib.Renderer:Render(Schemas.Buttons, layout)
    end)
    Lib.Layout:AddSidebarButton(layout, "advanced", "Advanced", function()
      Lib.State:SetValue("lastSection", "advanced")
      Lib.Renderer:Render(Schemas.Advanced, layout)
    end)
  end

  -- Initial Render (Restore last section)
  local lastSection = Lib.State:GetValue("lastSection") or "about"
  local sectionSchemas = {
    about = Schemas.About,
    general = Schemas.General,
    profiles = Schemas.Profiles,
    advanced = Schemas.Advanced,
    buttons = Schemas.Buttons
  }

  Lib.Layout:SelectSidebarButton(layout, lastSection)
  Lib.Renderer:Render(sectionSchemas[lastSection] or Schemas.About, layout)
end

-- Initialize on Login
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function() ConfigTest:Initialize() end)
