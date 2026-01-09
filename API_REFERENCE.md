# NoobTaco-Config API Reference

This document provides a quick overview of how to use the `NoobTaco-Config` library within your addon.

## 1. Initialization
The library uses your addon's private table (`AddOn`) to share its modules.

```lua
local Name, AddOn = ...

-- Initialize the state with your SavedVariables table
AddOn.ConfigState:Initialize(MyAddon_SavedVars)
```

## 2. Layout & Workflow
The library is designed for a two-column layout (Sidebar + Content).

```lua
-- Create the main container (usually inside a Blizzard Settings canvas)
local layout = AddOn.ConfigLayout:CreateTwoColumnLayout(parentFrame)

-- Add items to the sidebar
AddOn.ConfigLayout:AddSidebarButton(layout, "general", "General Settings", function()
    -- Render the schema when clicked
    AddOn.ConfigRenderer:Render(MySchema, layout)
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
| `button` | `label`, `onClick` |
| `callout` | `title`, `text`, `buttonText`, `style` ("warning", "error", "success", "info") |

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
AddOn.ConfigTheme:RegisterTheme("MyCustomTheme", themeTable)

-- Apply a theme
AddOn.ConfigTheme:SetTheme("Nord") -- Default, Nord, Catppuccin
```

## 5. Development Sync
If using the symbolic link strategy, any changes you make in the `NoobTaco-Config` project will instantly reflect in `NoobTacoUI`.
