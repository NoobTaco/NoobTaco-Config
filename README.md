# NoobTaco-Config
[![CI](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/ci.yml/badge.svg)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/ci.yml)
[![Release](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/release.yml/badge.svg)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/release.yml)
 Library

A modular, schema-driven configuration framework for NoobTacoUI.

## Overview

This library provides a way to generate WoW Interface Options panels dynamically using Lua table schemas. It supports:
- **Declarative Schema**: Define UI elements in a simple table structure.
- **Two-Column Layout**: Automatic sidebar navigation and content area.
- **State Management**: Transactional state with commit/revert capabilities.
- **Theming**: Built-in support for switching color themes (Default, Nord, Catppuccin) and fonts (Poppins).
- **Custom Rendering**: "Pixel-perfect" rendering adjustments and custom flat styling for buttons.

## File Structure

- **ConfigSchema.lua**: (WIP) Validators and schema definition helpers.
- **ConfigState.lua**: Manages the configuration data, including a temporary buffer for uncommitted changes.
- **ConfigTheme.lua**: Defines color palettes, fonts, and styling factories (e.g., `CreateThemedButton`).
- **ConfigLayout.lua**: Handles the high-level frame structure (Sidebar vs. Content) and navigation generation.
- **ConfigRenderer.lua**: The core engine that parses the schema and instantiates UI widgets (Checkboxes, Sliders, Buttons).
- **Load.xml**: XML loader to include the library in the TOC.

## Usage

### 1. Define Valid Options
First, ensure your saved variable table is initialized.

```lua
local Defaults = {
    enableFeature = true,
    opacity = 1.0,
    theme = "Default"
}
-- Load defaults into your SavedVariables on ADDON_LOADED
```

### 2. Create a Schema
Define the layout of your settings panel.

```lua
local schema = {
    type = "group",
    label = "General Settings",
    children = {
        {
            type = "checkbox",
            label = "Enable Feature",
            id = "enableFeature", -- Key in your config table
            default = true
        },
        {
            type = "slider",
            label = "Opacity",
            id = "opacity",
            min = 0, max = 1, step = 0.1,
            default = 1.0
        },
        {
            type = "button",
            label = "Reset",
            onClick = function() print("Reset!") end
        },
        {
            type = "callout",
            title = "Import Required",
            text = "You must import a profile to continue.",
            buttonText = "Import Now",
            style = "warning", -- Use "warning", "info", "success", or "error"
            onButtonClick = function() print("Import Clicked") end
        },
        {
            type = "expandable",
            label = "Expandable Section",
            status = "Status Badge", -- Optional
            expanded = false,        -- Initial state
            children = {
                 { type = "description", text = "Nested content goes here." },
                 { type = "button", label = "Action", onClick = function() end }
            }
        }
    }
}
```

### 3. Register the Category
Register the panel with the layout system.

```lua
-- In your initialization code:
local Category = Settings.RegisterCanvasLayoutCategory(MyPanel, "My Addon")
Category.ID = "MyAddonConfig"
Settings.RegisterAddOnCategory(Category)

-- Use the ConfigRenderer to draw the schema
ConfigRenderer:Render(schema, MyPanel)
```

## Theming
Themes are controlled via `ConfigTheme`. NoobTacoUI defaults to a specific aesthetic but you can switch themes programmatically:

```lua
local Theme = AddOn.ConfigTheme
Theme:SetTheme("Nord")
-- Re-render or reload UI to apply
```
