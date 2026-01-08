# NoobTacoUI Modular Framework Walkthrough

## Overview
This mission delivered a new modular configuration system for NoobTacoUI, featuring a schema-driven architecture, relative layout engine, and dirty state management.

## Changes Implemented

### 1. New Library: `Core/Libs/NoobTaco-Config/`
-   [ConfigSchema.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigSchema.lua): Defines and validates the Lua table structure for settings. Includes support for "Alerts" and "Rows".
-   [ConfigTheme.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigTheme.lua): Handles theming with presets for **Default**, **Nord**, and **Catppuccin**.
-   [ConfigState.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigState.lua): Manages `ActiveDB` vs `TempConfig` to support "Apply" and "Discard" workflows.
-   [ConfigLayout.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigLayout.lua): Creates the 2-column layout (Sidebar + Content) with `PixelUtil` support. Checks scale on resize.
-   [ConfigRenderer.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigRenderer.lua): The engine that consumes the schema and generates Config Frames using a Relative Flow Layout. Now uses `PixelUtil` for crisp 1px borders and alignment.

### 2. Integration
-   Added `Core/Libs/NoobTaco-Config/Load.xml` to `NoobTacoUI.toc`.
-   This ensures the library is available globally as `AddOn.ConfigRenderer`, `AddOn.ConfigState`, etc.

### 3. Verification Module: `modules/ConfigTest.lua`
-   Created a test module that registers a **"NoobTaco Config Test"** category in the WoW Options menu.
-   **Sidebar**: Populated with "General", "Profiles", and "About" buttons.
-   **Validation**:
    -   CheckBoxes & ColorPickers (bound to a dummy DB).
    -   Sliders in a 2-column Grid Row.
    -   Theme-aware Alert/Callout boxes (Info and Warning).

## How to Verify
1.  **Launch World of Warcraft** (Retail 10.0+ / 11.x).
2.  Open **Options** (Esc -> Options).
3.  Navigate to the **AddOns** tab.
4.  Find **"NoobTaco Config Test"** in the list.
5.  **Verify**:
    -   **Sidebar**: Click buttons, verify console print output.
    -   The entire right pane should resize smoothly if the game window is resized.
    -   The layout is split into two columns (Sidebar placeholder + Content).
    -   Controls stack correctly without overlapping.
    -   Changing "Enable Test Mode" works (state binding).
    -   The "Alerts" appear with distinct background/text colors.
