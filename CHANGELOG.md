# Changelog

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

### Fixed
- **Callout Button Hover**: Fixed an issue where custom-colored buttons would revert to default theme colors on mouse leave.
- **Blank Config Page**: Improved `ConfigTest` rendering logic to handle race conditions where `OnShow` fired before layout was ready.
- **Header Visibility**: Increased brightness of Header text in default themes (using Highlight color) for better readability.
- **Layout Padding**: Added internal padding to the configuration container to prevent content from touching window edges.
- **Modern Scrollbar**: Replaced standard scrollbar with a thin, minimal slider-based scrollbar for a cleaner aesthetic.
- **Developer Options Layout**: Fixed an issue where sliders in the Developer Options section would obscure the "Positioning" header and lack sufficient vertical padding.

## [1.0] - 2026-01-08
- Initial Release
