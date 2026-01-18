# NoobTaco-Config

[![CI Status](https://img.shields.io/github/actions/workflow/status/NoobTaco/NoobTaco-Config/ci.yml?style=for-the-badge&logo=github&logoColor=white&label=CI%20Status)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/ci.yml) [![Release Status](https://img.shields.io/github/actions/workflow/status/NoobTaco/NoobTaco-Config/release.yml?style=for-the-badge&logo=github&logoColor=white&label=Release%20Status)](https://github.com/NoobTaco/NoobTaco-Config/actions/workflows/release.yml) [![Discord](https://img.shields.io/badge/Discord-Taco%20Labs-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/Mby5KwkCH9) [![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Donate-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/devnoobtaco)

**NoobTaco-Config** is a modular, schema-driven configuration framework for World of Warcraft addons. Designed with a focus on "pixel-perfect" aesthetics and ease of use, it allows developers to build complex, themed options menus using simple Lua tables.

## 📸 Screenshots

| Overview | Theme Support |
| :---: | :---: |
| ![Welcome](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-welcome-ss.png) | ![Themes](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-theme-catppuccin-ss.png) |

> [!TIP]
> Use the [Library Showcase](https://github.com/NoobTaco/NoobTaco-Config/blob/main/Tests/ConfigTest.lua) in-game to see the dynamic theming and all widgets in action.

## ✨ Features

- 🛠️ **Declarative Schemas**: Define your entire UI layout in nested Lua tables.
- 🎨 **Dynamic Theming**: Built-in support for **NoobTaco**, **Nord**, and **Catppuccin** themes.
- 🔡 **Accessible Typography**: Integrated with the **Poppins** font family using optimized weights (**Medium**, **Bold**) for maximum readability.
- ⚡ **Transactional State**: Built-in commit/revert logic for user settings.
- 🌈 **Inline Color Tokens**: Use `|ctoken|` (e.g., `|chighlight|`) to dynamically style text based on the active theme.
- 📁 **Nested Data**: Native support for dot-notation in IDs to map directly to complex SavedVariables.
- 🔊 **Media Previewing**: Specialized media widgets with built-in playback for sounds.

## 🚀 Quick Start

### 1. Initialization
Retrieve the library via LibStub.

```lua
local Lib = LibStub("NoobTaco-Config-1.0")
if not Lib then return end
```

### 2. Create a Schema
Define the layout of your settings panel.

```lua
local schema = {
    type = "group",
    label = "General Settings",
    children = {
        {
            type = "about",
            icon = [[Interface\AddOns\MyAddon\Media\Logo]],
            title = "My Addon",
            version = "1.0.0",
            description = "A powerful configuration suite.",
            links = {
                { 
                    label = "GitHub", 
                    url = "https://github.com/...",
                    onClick = function() print("Custom Click!") end
                }
            }
        },
        {
            type = "card",
            label = "Feature Settings",
            children = {
                 { id = "enableFeature", type = "checkbox", label = "Enable Magic", default = true },
                 { id = "powerLevel", type = "slider", label = "Power Level", min = 0, max = 100, default = 9000 }
            }
        }
    }
}
```

### 3. Rendering
```lua
-- Render directly to a Blizzard category frame
Lib.Renderer:Render(schema, myPanel)
```

## 🖼️ UI Showcase

| Inputs & Widgets | Buttons | Feedback & Alerts |
| :---: | :---: | :---: |
| ![Inputs](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-inputs-ss.png) | ![Buttons](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-button-ss.png) | ![Feedback](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-feedback-ss.png) |

## 🧪 Theme Engine
The library supports instant theme switching. All colors, including inline tokens, update in real-time.

| NoobTaco (Standard) | Nord (Frost) | Catppuccin (Mocha) |
| :---: | :---: | :---: |
| ![NoobTaco](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-theme-noobtaco-ss.png) | ![Nord](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-theme-nord-ss.png) | ![Catppuccin](https://raw.githubusercontent.com/NoobTaco/NoobTaco-Config/main/Media/Screenshots/noobtaco-config-theme-catppuccin-ss.png) |

## 📚 Documentation

- [Configuration Cheat Sheet](https://github.com/NoobTaco/NoobTaco-Config/blob/main/docs/CHEAT_SHEET.md) - All available containers and elements.
- [API Reference](https://github.com/NoobTaco/NoobTaco-Config/blob/main/docs/API_REFERENCE.md) - Detailed technical documentation.

## ❤️ Support

If you're looking for help, have questions, or want to join the community, join us on Discord!

[![Discord](https://img.shields.io/badge/Discord-Taco%20Labs-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/Mby5KwkCH9) [![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Donate-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/devnoobtaco)

## 📄 AI Usage

See [AI_USAGE.md](https://github.com/NoobTaco/NoobTaco-Config/blob/main/AI_USAGE.md) for more information.

## 📄 License

This project is licensed under the GPL-3.0-or-later License - see the [LICENSE](LICENSE) file for details.
