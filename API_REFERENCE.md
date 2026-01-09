# NoobTaco-Config API Reference

This document provides a technical overview of how to use the `NoobTaco-Config` library.

## 1. Initialization
The library should be initialized via `LibStub`.

```lua
local Lib = LibStub("NoobTaco-Config-1.0")
if not Lib then return end

-- Initialize state with your SavedVariables table
Lib.State:Initialize(MyAddon_SavedVars)
```

## 2. Layout & Workflow
The library is designed for a two-column layout (Sidebar + Content).

```lua
-- Create the main container (usually inside a Blizzard Settings canvas)
local layout = Lib.Layout:CreateTwoColumnLayout(parentFrame)

-- Add items to the sidebar
Lib.Layout:AddSidebarButton(layout, "general", "General Settings", function()
    -- Render the schema when clicked
    Lib.Renderer:Render(MySchema, layout)
end)
```

## 3. Schema Definition
Schemas are tables defining your UI components.

| Type | Key Properties |
| :--- | :--- |
| `group` | `children` (table) |
| `header` | `label` |
| `description`| `text` |
| `checkbox` | `id`, `label`, `default` |
| `slider` | `id`, `label`, `min`, `max`, `step`, `default` |
| `dropdown` | `id`, `label`, `options` ({label, value}) |
| `media` | `id`, `label`, `options` (sound paths) |
| `button` | `label`, `onClick`, `style`, `customColors` |
| `callout` | `title`, `text`, `buttonText`, `style` ("warning", "error", "success", "info") |
| `card` | `label`, `children` |
| `about` | `icon`, `title`, `version`, `description`, `links` ({label, url}) |
| `expandable` | `label`, `children` |

### Example Schema
```lua
local GeneralSchema = {
    type = "group",
    children = {
        { type = "header", label = "General Settings" },
        { id = "enableBuffs", type = "checkbox", label = "Enable Buff Tracker", default = true },
        { id = "uiScale", type = "slider", label = "Master Scale", min = 0.5, max = 2.0, step = 0.1, default = 1.0 },
    }
}
```

## 4. Themes
```lua
-- Register a custom theme
Lib.Theme:RegisterTheme("MyCustomTheme", themeTable)

-- Apply a theme
Lib.Theme:SetTheme("NoobTaco") -- NoobTaco, Nord, Catppuccin
```

## 5. Media & Assets
Use `Lib.Media` to get the base path for library assets. This ensures correct paths whether the library is standalone or embedded.

```lua
local fontPath = Lib.Media .. "\\Fonts\\Poppins-Regular.ttf"
```
