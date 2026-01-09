# Changelog

## [1.1.0] - 2026-01-09
### Added
- **Dynamic Media Pathing**: Introduced `Lib.Media` to automatically detect and resolve asset paths (fonts, icons) whether the library is running standalone or embedded in another addon.
- **New Widgets**:
    - `card`: Bordered container for grouping related settings.
    - `about`: Standardized branding section for addon info and links.
    - `media`: Specialized dropdown with audio preview support.
    - `expandable`: Collapsible sections for complex schemas.
    - `callout`: Alert containers with `success`, `info`, `warning`, and `error` styles.
- **NoobTaco Theme**: New default "NoobTaco" theme based on Digital Taco UI Kit Specs, featuring Charcoal Navy glassmorphism and Burnt Sienna highlights.
- **Improved Theming**: Added support for 4th color channel (alpha) in theme presets.

### Changed
- **Internal Refactor**: Consolidated theme update logic in `Renderer.lua` to remove redundant code and improve maintainability.
- **Documentation**: Overhauled `README.md` and `API_REFERENCE.md` to reflect new architecture and embed patterns.
- **Production Prep**: Disabled test files in `NoobTaco-Config.toc` to prevent them from loading in production environments.

### Fixed
- **Rendering Instability**: Added fallbacks for initial zero-width/height states on fresh load to prevent component clumping.
- **Scrollbar Visibility**: Fixed an issue where the scrollbar was invisible or improperly colored on initial load.
- **Conflicting Anchors**: Resolved an issue in the About component where overlapping anchors pushed content off-screen.
- **Memory Optimization**: Reimplemented About page link management to reuse buttons instead of creating new ones on every render.
- **Header "Cycling"**: Fixed a bug where headers would flicker or disappear when interacting with sidebar buttons.
- **Frame Ghosting**: Fixed a critical issue where frames were not properly detached from their parents when returned to the pool, preventing rendering glitches and disappearing elements.
- **Text Layout Lag**: Improved text height calculation for the "About" component to prevent 0-height rendering on initial load when the layout engine is still initializing.

## [1.0.0] - 2026-01-08
### Added
- **Theme Registration**: Developers can now register custom themes using `AddOn.ConfigTheme:RegisterTheme`.
- **Live Theme Updates**: UI elements now update immediately when the theme is changed.
- **Custom Button Colors**: Buttons can now have `customColors` (normal, hover, selected) defined in their frame properties.
- **Theme Template**: Added `Core/Theme_Template.lua` to assist developers in creating new themes.
- **Success Alert**: Added `success` (Green) color to all default themes (Default, Nord, Catppuccin).
- **Internal Fonts**: Library now includes its own `Media/Fonts` directory (Poppins) and no longer depends on `NoobTacoUI` for fonts.
- **Media Dropdown**: New widget type `media` featuring a custom dropdown with audio preview capabilities.
- **Audio Preview**: Integrated `PlaySoundFile` support in media dropdowns with a custom "Music Note" icon and "Play Sample" tooltip.
- **About Tab**: Integrated schema rendering support for the About tab in `ConfigTest` including text block support.
- **Expandable Lists**: New `expandable` component type for creating collapsible sections (e.g. for Profiles or Plugins). Supports status badges, nested content indentation, and custom sizing.
- **About Container**: New `about` widget type for displaying branding, version info, description, and support links in a standardized layout.
- **Component Skinning**: Refactored `editbox`, `dropdown`, and `slider` components to use a thinner, 1-pixel border aesthetic, matching the media selector.
- **Custom Dropdown**: Implemented a custom button-based dropdown to replace Blizzard's standard template for better styling control.
- **Custom Slider**: Implemented a template-free slider with 1px borders and themed thumb textures.
- **Slider Value Indicator**: Added a real-time value indicator to sliders, positioned to the right of the label. Includes automatic decimal precision formatting based on step size.
- **Audio Icon Fallback**: Implemented version-based fallback for audio component icons. Uses a speaker icon for clients older than 12.0.0.0.

### Fixed
- **Callout Button Hover**: Fixed an issue where custom-colored buttons would revert to default theme colors on mouse leave.
- **Side-by-Side Layout**: Adjusted default component widths to 180px and improved vertical spacing to ensure elements fit comfortably in multi-column rows.
- **Blank Config Page**: Improved `ConfigTest` rendering logic to handle race conditions where `OnShow` fired before layout was ready.
- **Header Visibility**: Increased brightness of Header text in default themes (using Highlight color) for better readability.
- **Layout Padding**: Added internal padding to the configuration container to prevent content from touching window edges.
- **Modern Scrollbar**: Replaced standard scrollbar with a thin, minimal slider-based scrollbar for a cleaner aesthetic.
- **Developer Options Layout**: Fixed an issue where sliders in the Developer Options section would obscure the "Positioning" header and lack sufficient vertical padding.
- **Slider Initial Render**: Fixed a bug where the first slider in a row (e.g., "X Offset") would fail to render on initial load. Added fallback height (14px) when `GetStringHeight()` returns 0 before UI layout completes, ensuring correct `yOffset` positioning.

## [1.0] - 2026-01-08
- Initial Release
