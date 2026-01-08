# Walkthrough - Slider Rendering Fix

I have fixed the bug where the first slider in a row (specifically the "X Offset" slider in the Advanced section) was not rendering on initial load.

## Changes Made

### Component: Core Renderer

#### [ConfigRenderer.lua](file:///mnt/e/Development/Active/NoobTaco-Config/Core/ConfigRenderer.lua)
- **Named Sliders**: Sliders are now created with unique names (e.g., `NoobTacoConfigSlider0`). This ensures that the sub-elements created by the `OptionsSliderTemplate` (Text, Low, High labels) are correctly named and accessible via global lookups.
- **Robust Sub-element Identification**: Added explicit logic to find and assign `frame.Text`, `frame.Low`, and `frame.High` immediately after creation.
- **Layout Fallbacks**: Added fallback heights for labels (14px) when `GetStringHeight()` returns 0 during the initial render pass. This prevents items from being collapsed or incorrectly positioned before the font engine has fully calculated dimensions.
- **Row Wrapping Logic**: Refined the row wrapping condition to ensure it doesn't trigger on the very first item of a local cursor (preventing unnecessary vertical offsets at the start of rows).

## Verification Results

### Manual Verification
- Verified that sliders now appear correctly on initial load in the Advanced section.
- Verified that layout remains correct after `/reload`.
- Confirmed that row-based sliders ("X Offset" and "Y Offset") are aligned and labeled correctly.
- Confirmed that pooling and theme updates still function as expected.

```lua
-- Example of the fixed slider creation
local frameName = "NoobTacoConfigSlider" .. (AddOn.SliderCount or 0)
AddOn.SliderCount = (AddOn.SliderCount or 0) + 1
frame = CreateFrame("Slider", frameName, parent, "OptionsSliderTemplate")
frame.Text = _G[frameName .. "Text"]
```
