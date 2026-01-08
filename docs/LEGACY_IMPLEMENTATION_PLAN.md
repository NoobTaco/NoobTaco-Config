# NoobTacoUI Modular Framework Implementation Plan

## Goal Description
Architect and implement a modular, schema-driven configuration menu system for NoobTacoUI. This system will replace absolute positioning with a Relative Flow Layout to solve DPI/scaling issues and introduce a "Dirty State" configuration buffer for safer setting changes.

## User Review Required
> [!IMPORTANT]
> This is a major architectural change. The "Schema" design and "Relative Anchor Engine" logic need to be approved before any UI frame implementation begins.

## Proposed Changes

### Core/Libs/NoobTaco-Config
#### [MODIFY] [ConfigTheme.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigTheme.lua)
- Add Font support (Poppins).
- Add Button color definitions (Normal, Hover, Selected).

#### [MODIFY] [ConfigLayout.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigLayout.lua)
- Update `AddSidebarButton` to use custom "Flat" look instead of `UIPanelButtonTemplate`.
- Implement `OnEnter`/`OnLeave` hover effects.
- Implement `Selected` state logic for navigation tabs.

#### [MODIFY] [ConfigRenderer.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigRenderer.lua)
- Update button rendering to use the same "Flat" look.

#### [NEW] [ConfigSchema.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigSchema.lua)
- Defines the Lua table structure for settings.
- **Schema Example**:
  ```lua
  {
      type = "group",
      layout = "flow",
      children = {
          { id = "enableFeature", type = "checkbox", label = "Enable Feature", default = true },
          { id = "featureColor", type = "colorpicker", label = "Color", default = "00FF00" },
          -- Alert/Callout Example
          { type = "alert", severity = "warning", text = "Changing this requires a Reload." },
          -- Grid Example: 2 items in one row
          { type = "row", children = {
              { id = "width", type = "slider", label = "Width", width = 0.5 }, -- 50% width
              { id = "height", type = "slider", label = "Height", width = 0.5 },
          }}
      }
  }
  ```

#### [NEW] [ConfigRenderer.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigRenderer.lua)
- **Top-Level**: Creates a `Canvas` frame to be used with `Settings.RegisterCanvasLayoutCategory`.
- **Render Loop**:
    1.  Recursive function `RenderGroup(groupSchema, parentFrame)`.
    2.  Maintains a `Cursor` object: `{ x = 0, y = 0, rowHeight = 0, maxWidth = parentWidth }`.
    3.  For each child:
        - Check `availableWidth`. If config `newRow` or `width` exceeds space, call `NewLine(cursor)`.
        - Create/Get Frame (Object Pool).
        - `PixelUtil.SetPoint(frame, "TOPLEFT", parent, "TOPLEFT", cursor.x, cursor.y)`.
        - Update `cursor.x += frameWidth + padding`.
        - Update `cursor.rowHeight = max(cursor.rowHeight, frameHeight)`.

#### [NEW] [ConfigState.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigState.lua)
- **TempConfig**: A deep copy of the active DB for the current category.
- **Proxy**: UI elements read/write to `TempConfig`.
- **Dirty Flag**: Checked on every write. if `TempConfig[key] ~= ActiveDB[key]`, set `IsDirty = true`.
- **Apply Action**: Copies `TempConfig` -> `ActiveDB`, calls `OnCommit` callbacks (for ReloadUI or live updates).
- **Discard Action**: Re-clones `ActiveDB` -> `TempConfig`, calls `RefreshUI()`.

#### [NEW] [ConfigLayout.lua](file:///mnt/e/Development/Active/NoobTacoUI/Core/Libs/NoobTaco-Config/ConfigLayout.lua)
- **Two-Column Container**:
    - **Sidebar**: `ScrollFrame` (Left, fixed width ~200px). Lists Categories.
    - **Content**: `ScrollFrame` (Right, fills rest). Contains the configuration controls.
- **Scaling**:
    - `frame:SetScale(MenuScale)` applied to the main container.
    - `PixelUtil` ensures 1px borders remain 1px even at non-integer scales.

## Verification Plan

### Automated Tests
- None at this stage (Lua unit testing is limited).

### Manual Verification
1.  **Schema Validation**: Create a dummy config table with various element types and verify the "Renderer" prints correct anchor layout logic to the chat/console.
2.  **Dirty State**: Change a setting in the dummy schema, verify `IsDirty` becomes true, and the "Apply" button appears.
3.  **Layout**: Resize the game window/frame and ensure the Relative Flow Layout adapts without overlapping elements.
4.  **Scaling**: Adjust `MenuScale` and verify elements resize while maintaining relative positioning and border sharpness.
