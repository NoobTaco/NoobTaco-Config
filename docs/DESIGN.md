# NoobTaco-Config Design Reference

## Overview
NoobTaco-Config is a modular, schema-driven configuration framework designed to replace absolute positioning with a relative flow layout. It solves DPI/scaling issues and provides a safe "dirty state" buffer for setting changes.

## Architecture

### 1. Schema-Driven UI (`ConfigSchema.lua`)
Settings are defined in a declarative Lua table structure, separating data from presentation.
```lua
{
    type = "group",
    layout = "flow",
    children = {
        { id = "enableFeature", type = "checkbox", label = "Enable Feature", default = true },
        { id = "opacity", type = "slider", label = "Opacity", default = 1.0 },
    }
}
```

### 2. Rendering Engine (`ConfigRenderer.lua`)
- **Flow Layout**: Elements are placed relative to each other using a cursor system (`x`, `y`, `rowHeight`, `maxWidth`).
- **Object Pooling**: Reuses frames to minimize memory churn.
- **Pixel Perfect**: Uses `PixelUtil` to ensure 1px borders remain sharp at any UI scale.

### 3. State Management (`ConfigState.lua`)
- **Transactional State**:
  - `ActiveDB`: The live saved variables.
  - `TempConfig`: A working copy where UI changes are stored.
- **Dirty Tracking**: Compares `TempConfig` vs `ActiveDB`. If different, the "Apply" button is enabled.
- **Commit/Revert**: User can Apply (commit to `ActiveDB`) or Discard (revert `TempConfig` to `ActiveDB`).

### 4. Layout Structure (`ConfigLayout.lua`)
- **Two-Column Design**:
  - **Sidebar**: Fixed width (~200px), scrollable. Lists categories.
  - **Content**: Fills remaining space, scrollable. Displays the active schema group.
- **Scaling**: The entire menu can be scaled independently of the game UI (`MenuScale`).

### 5. Theming (`ConfigTheme.lua`)
- **Presets**: Supports multiple themes (Default, Nord, Catppuccin).
- **Styling**:
  - **Fonts**: Uses "Poppins" for a modern look.
  - **Buttons**: Custom "Flat" style with distinct Normal, Hover, and Selected states.

## Key Components

- **Canvas**: Registered via `Settings.RegisterCanvasLayoutCategory` for native integration.
- **Widgets**:
  - **Checkbox**: Standard toggle.
  - **Slider**: numeric input.
  - **ColorPicker**: RGB/RGBA selector.
  - **Alert/Callout**: Info/Warning boxes with colored backgrounds.
  - **Row**: Layout container for placing multiple items horizontally.
