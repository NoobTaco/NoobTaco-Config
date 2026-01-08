std = "lua51"
read_globals = {
    "CreateFrame",
    "UIParent",
    "GameFontNormal",
    "GameFontHighlight",
    "GameFontHighlightSmall",
    "GameFontNormalLarge",
    "GameTooltip",
    "PlaySoundFile",
    "UIDropDownMenu_Initialize",
    "UIDropDownMenu_CreateInfo",
    "UIDropDownMenu_AddButton",
    "UIDropDownMenu_SetSelectedValue",
    "UIDropDownMenu_SetText",
    "UIDropDownMenu_SetWidth",
    "Settings",
    "PixelUtil",
    "C_Timer",
    "wipe",
    "strtrim",
    "strmatch"
}
-- Exclude test files and installed rock dependencies
exclude_files = {
    "Tests/**", 
    ".luarocks/**",
    ".github/**"
}

-- Relax strictness for WoW addon development
max_line_length = 140
ignore = {
    "212/self", -- Unused argument 'self' (common in WoW API)
}
