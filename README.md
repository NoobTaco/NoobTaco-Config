# Lib: NoobTaco-Config

[![CI](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/ci.yml/badge.svg)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/ci.yml) [![Release](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/release.yml/badge.svg)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/release.yml)

A modular, schema-driven configuration framework for NoobTacoUI.

## Overview

This library provides a way to generate WoW Interface Options panels dynamically using Lua table schemas. It supports:
- **Declarative Schema**: Define UI elements in a simple table structure.
- **Two-Column Layout**: Automatic sidebar navigation and content area.
- **State Management**: Transactional state with commit/revert capabilities.
- **Theming**: Built-in support for switching color themes (NoobTaco, Nord, Catppuccin) and fonts (Poppins).
- **Custom Rendering**: "Pixel-perfect" rendering for all interactive components with a consistent 1px border aesthetic.
- **Embedded vs Standalone**: Automatic path detection for assets when embedded in other addons.

## File Structure

- **NoobTaco-Config.lua**: Root entry point and dynamic media path helper.
- **NoobTaco-Config.toc**: Addon manifest.
- **Internal/**: Core engine modules.
  - **Schema.lua**: Validators and schema definition helpers.
  - **State.lua**: Manages configuration data and transaction buffers.
  - **Layout.lua**: Handles frame structure and navigation.
  - **Renderer.lua**: The core engine that parses schemas and instantiates UI widgets.
- **Themes/Theme.lua**: Defines color palettes, fonts, and styling factories.
- **Media/**: Icons and Poppins fonts.
- **LibStub.lua**: Standard library versioning helper.

> **Note**: This library is registered with **LibStub** as `NoobTaco-Config-1.0`. 

## Usage

### 1. Initialization
Retrieve the library via LibStub.

```lua
local Lib = LibStub("NoobTaco-Config-1.0")
if not Lib then return end
```

### 2. Create a Schema
Define the layout of your settings panel. The renderer supports a wide variety of widgets:

#### Basic Widgets
- `checkbox`: Boolean toggles.
- `slider`: Range selection with real-time value indicators.
- `editbox`: Text input.
- `dropdown`: Selection from a list.
- `button`: Custom actions.
- `header` & `description`: Text content and separators.

#### Advanced Widgets
- `media`: Specialized dropdown for sound/media paths with audio preview.
- `callout`: Alert-style containers for important information (warning, error, success, info).
- `card`: Bordered containers for grouping related settings.
- `about`: Standardized branding section with logo, version, description, and links.
- `expandable`: Collapsible sections for complex layouts.

### Example Schema
```lua
local schema = {
    type = "group",
    label = "General Settings",
    children = {
        {
            type = "checkbox",
            label = "Enable Feature",
            id = "enableFeature",
            default = true
        },
        {
            type = "card",
            label = "Profile Management",
            children = {
                 { type = "description", text = "Manage your active profiles here." },
                 { type = "button", label = "Reset Profile", onClick = function() end }
            }
        },
        {
             type = "about",
             icon = "Interface\\AddOns\\MyAddon\\Media\\Logo",
             title = "My Addon",
             version = "1.1.0",
             description = "Full configuration suite.",
             links = {
                { label = "Discord", url = "https://discord.gg/..." },
                { label = "GitHub", url = "https://github.com/..." }
             }
        }
    }
}
```

### 3. Rendering
```lua
-- Register within Blizzard Settings
local category = Settings.RegisterCanvasLayoutCategory(myPanel, "My Addon")
Settings.RegisterAddOnCategory(category)

-- Render the schema
Lib.Renderer:Render(schema, myPanel)
```

## Embedding & Dynamic Media

When embedding `NoobTaco-Config` in your own addon, use the `Lib.Media` constant to reference fonts and textures. It automatically detects if the library is running standalone or as a sub-library and returns the correct interface path.

```lua
local Lib = LibStub("NoobTaco-Config-1.0")
local fontPath = Lib.Media .. "\\Fonts\\Poppins-Regular.ttf"
```

## Theming
Switch themes programmatically:

```lua
Lib.Theme:SetTheme("Catppuccin") -- NoobTaco (Default), Nord, Catppuccin
```
