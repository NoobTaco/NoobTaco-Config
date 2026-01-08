# Changelog

## [1.1] - 2026-01-08
### Added
- **Theme Registration**: Developers can now register custom themes using `AddOn.ConfigTheme:RegisterTheme`.
- **Live Theme Updates**: UI elements now update immediately when the theme is changed.
- **Custom Button Colors**: Buttons can now have `customColors` (normal, hover, selected) defined in their frame properties.
- **Theme Template**: Added `Core/Theme_Template.lua` to assist developers in creating new themes.
- **Success Alert**: Added `success` (Green) color to all default themes (Default, Nord, Catppuccin).

### Fixed
- **Callout Button Hover**: Fixed an issue where custom-colored buttons would revert to default theme colors on mouse leave.
- **Blank Config Page**: Improved `ConfigTest` rendering logic to handle race conditions where `OnShow` fired before layout was ready.

## [1.0] - 2026-01-08
- Initial Release
