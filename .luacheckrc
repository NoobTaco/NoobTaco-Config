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

-- Disable line length check (formatting choice)
max_line_length = false

-- Suppress specific warnings
ignore = {
    "212/self",       -- Unused argument 'self' (common in frameworks)
    "4",              -- Shadowing variables (often self, or reused local names)
    "211/Name",       -- Standard Addon Namespace boilerplate often unused in some files
    "211/PixelUtil",  -- Import often unused in specific files
    "211/_",          -- Allow underscore as unused
    "212/_",          -- Allow underscore as unused argument
    "212/event",      -- Unused event arg
    "212/msg",        -- Unused msg arg
    "211/isNowDirty", -- Specific unused var in ConfigState
}
