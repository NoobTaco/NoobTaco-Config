# Lib: NoobTaco-Config

[![CI](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/ci.yml/badge.svg)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/ci.yml) [![Release](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/release.yml/badge.svg)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/release.yml)

A modular, schema-driven configuration framework for NoobTacoUI.

## Overview

This library provides a way to generate WoW Interface Options panels dynamically using Lua table schemas. It supports:
- **Declarative Schema**: Define UI elements in a simple table structure.
- **Two-Column Layout**: Automatic sidebar navigation and content area.
- **State Management**: Transactional state with commit/revert capabilities.
- **Theming**: Built-in support for switching color themes (NoobTaco, Nord, Catppuccin) and fonts (Poppins).
- **Custom Rendering**: "Pixel-perfect" rendering for all interactive components (EditBox, Dropdown, Slider, Media) with a consistent 1px border aesthetic.

## File Structure

- **ConfigSchema.lua**: (WIP) Validators and schema definition helpers.
- **ConfigState.lua**: Manages the configuration data, including a temporary buffer for uncommitted changes.
- **ConfigTheme.lua**: Defines color palettes, fonts, and styling factories (e.g., `CreateThemedButton`).
- **ConfigLayout.lua**: Handles the high-level frame structure (Sidebar vs. Content) and navigation generation.
- **ConfigRenderer.lua**: The core engine that parses the schema and instantiates UI widgets (Checkboxes, Sliders, Buttons).
- **Load.xml**: XML loader to include the library in the TOC.
- **LibStub.lua**: Standard Discord/WoW library versioning helper.

> **Note**: This library is registered with **LibStub** as `NoobTaco-Config-1.0`. 

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
            type = "card",
            label = "Profile Section",
            children = {
                 { type = "description", text = "Card content with bordered container." },
                 { type = "button", label = "Action", onClick = function() end }
            }
        }
    -- ... other children
        {
             type = "about",
             icon = "Interface\\AddOns\\YourAddOn\\Media\\Logo",
             title = "Your AddOn",
             version = "v1.0.0",
             description = "A short description of your addon.",
             links = {
                { label = "Discord", url = "https://discord.gg/..." },
                { label = "GitHub", url = "https://github.com/..." }
             }
        }
    }
}
```

### 3. Register and Render
Retrieve the library via LibStub and utilize its core modules.

```lua
-- In your initialization code:
local Lib = LibStub("NoobTaco-Config-1.0")
if not Lib then return end

local Category = Settings.RegisterCanvasLayoutCategory(MyPanel, "My Addon")
Category.ID = "MyAddonConfig"
Settings.RegisterAddOnCategory(Category)

-- Use the Renderer to draw the schema
Lib.Renderer:Render(schema, MyPanel)
```

## Theming
Themes are controlled via `Lib.Theme`. NoobTacoUI defaults to a specific aesthetic but you can switch themes programmatically:

```lua
local Lib = LibStub("NoobTaco-Config-1.0")
Lib.Theme:SetTheme("Nord")
-- Re-render or reload UI to apply
```
