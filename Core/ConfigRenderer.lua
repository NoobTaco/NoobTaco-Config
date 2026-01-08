local _, AddOn = ...
local ConfigRenderer = {}
AddOn.ConfigRenderer = ConfigRenderer

local Theme = AddOn.ConfigTheme
local State = AddOn.ConfigState
local PixelUtil = AddOn.PixelUtil or PixelUtil

-- Simple Object Pool
local FramePool = {}
local function GetFrame(type, parent)
  if not FramePool[type] then FramePool[type] = {} end
  local pool = FramePool[type]
  local frame = table.remove(pool)

  if not frame then
    -- Create new frame based on type
    if type == "checkbox" then
      frame = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
      if frame.Text then Theme:ApplyFont(frame.Text, "Normal", 12) end
    elseif type == "slider" then
      frame = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
      if frame.Text then Theme:ApplyFont(frame.Text, "Normal", 12) end
      if frame.Low then Theme:ApplyFont(frame.Low, "Normal", 10) end
      if frame.High then Theme:ApplyFont(frame.High, "Normal", 10) end
    elseif type == "button" then
      frame = Theme:CreateThemedButton(parent)
    elseif type == "alert" then
      frame = CreateFrame("Frame", nil, parent)
      frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      Theme:ApplyFont(frame.text, "Normal", 12)
      frame.text:SetAllPoints()
      frame.bg = frame:CreateTexture(nil, "BACKGROUND")
      frame.bg:SetAllPoints()
    elseif type == "description" then
      frame = CreateFrame("Frame", nil, parent)
      frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      Theme:ApplyFont(frame.text, "Normal", 12)
      frame.text:SetAllPoints()
      frame.text:SetJustifyH("LEFT")
      frame.text:SetJustifyV("TOP")
    elseif type == "header" then
      frame = CreateFrame("Frame", nil, parent)
      frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      Theme:ApplyFont(frame.text, "Bold", 14)
      frame.text:SetPoint("TOPLEFT", 0, 0)
      frame.line = frame:CreateTexture(nil, "ARTWORK")
      frame.line:SetHeight(1)
      frame.line:SetColorTexture(1, 1, 1, 0.2)
      frame.line:SetPoint("TOPLEFT", frame.text, "BOTTOMLEFT", 0, -5)
      frame.line:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
    elseif type == "editbox" then
      frame = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
      frame:SetAutoFocus(false)
      frame.Label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      Theme:ApplyFont(frame.Label, "Normal", 12)
      -- EditBox is a FontInstance, apply directly
      Theme:ApplyFont(frame, "Normal", 12)
      frame.Label:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 5)
    elseif type == "dropdown" then
      frame = CreateFrame("Frame", nil, parent, "UIDropDownMenuTemplate")
      UIDropDownMenu_SetWidth(frame, 150)
      frame.Label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      Theme:ApplyFont(frame.Label, "Normal", 12)
      -- Note: Dropdown text is managed by internal buttons, hard to skin without hooks
      -- But we can try to hook standard template/helpers if needed later.
      frame.Label:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 16, 5)
    elseif type == "colorpicker" then
      frame = CreateFrame("Button", nil, parent)
      frame:SetSize(20, 20)
      frame.swatch = frame:CreateTexture(nil, "OVERLAY")
      frame.swatch:SetAllPoints()
      frame.swatch:SetColorTexture(1, 1, 1)
      frame.Label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      Theme:ApplyFont(frame.Label, "Normal", 12)
      frame.Label:SetPoint("LEFT", frame, "RIGHT", 10, 0)

      -- Border
      frame.border = frame:CreateTexture(nil, "BACKGROUND")
      frame.border:SetPoint("TOPLEFT", -1, 1)
      frame.border:SetPoint("BOTTOMRIGHT", 1, -1)
      frame.border:SetColorTexture(0.5, 0.5, 0.5)
      frame.border:SetColorTexture(0.5, 0.5, 0.5)
    elseif type == "media" then
      frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
      -- Basic Dropdown-like appearance
      frame:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8X8",
        edgeFile = "Interface/Buttons/WHITE8X8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
      })
      frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
      frame:SetBackdropColor(0.1, 0.1, 0.1, 1)

      frame.Text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      Theme:ApplyFont(frame.Text, "Normal", 12)
      frame.Text:SetPoint("LEFT", 8, 0)
      frame.Text:SetPoint("RIGHT", -24, 0)
      frame.Text:SetJustifyH("LEFT")

      -- Chevron/Arrow
      frame.Arrow = frame:CreateTexture(nil, "ARTWORK")
      frame.Arrow:SetPoint("RIGHT", -6, 0)
      frame.Arrow:SetSize(12, 12)
      frame.Arrow:SetTexture("Interface/ChatFrame/ChatFrameExpandArrow")

      frame.Label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      Theme:ApplyFont(frame.Label, "Normal", 12)
      frame.Label:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 5)

      -- Popup Frame (Lazy created per instance for now)
      frame.Popup = CreateFrame("Frame", nil, frame, "BackdropTemplate")
      frame.Popup:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -2)
      frame.Popup:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -2)
      frame.Popup:SetHeight(200) -- Max height
      frame.Popup:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
      })
      frame.Popup:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
      frame.Popup:SetFrameStrata("DIALOG")
      frame.Popup:Hide()

      -- ScrollFrame for Popup
      frame.Popup.ScrollFrame = CreateFrame("ScrollFrame", nil, frame.Popup, "UIPanelScrollFrameTemplate")
      frame.Popup.ScrollFrame:SetPoint("TOPLEFT", 5, -5)
      frame.Popup.ScrollFrame:SetPoint("BOTTOMRIGHT", -26, 5)

      frame.Popup.Content = CreateFrame("Frame", nil, frame.Popup.ScrollFrame)
      frame.Popup.Content:SetSize(1, 1)
      frame.Popup.ScrollFrame:SetScrollChild(frame.Popup.Content)
    elseif type == "callout" then
      frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
      frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
      })
      frame:SetBackdropBorderColor(1, 0.82, 0, 1) -- Default Gold (Handled in UpdateTheme)
      frame:SetBackdropColor(0.2, 0.2, 0.2, 0.9)  -- Dark BG

      frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      Theme:ApplyFont(frame.Title, "Bold", 14)
      frame.Title:SetPoint("TOPLEFT", 10, -10)
      -- frame.Title:SetTextColor(1, 0.82, 0) -- Gold Title (Handled in UpdateTheme)

      frame.Text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      Theme:ApplyFont(frame.Text, "Normal", 12)
      frame.Text:SetPoint("TOPLEFT", frame.Title, "BOTTOMLEFT", 0, -5)
      frame.Text:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
      frame.Text:SetJustifyH("LEFT")

      frame.Button = Theme:CreateThemedButton(frame)
      frame.Button:SetPoint("BOTTOMLEFT", 10, 10)
      frame.Button:SetSize(200, 30)

      -- Custom button style for callout
      -- frame.Button.customColors = { ... } -- Handled in UpdateTheme
      Theme:UpdateButtonState(frame.Button) -- Apply immediately

      -- Force Text Color to Black always (since gold button needs black text)
      frame.Button.Text:SetTextColor(0, 0, 0, 1)

      -- Override UpdateTheme to maintain black text
      frame.Button.UpdateTheme = function(b)
        Theme:UpdateButtonState(b)
        b.Text:SetTextColor(0, 0, 0, 1)
      end

      frame.UpdateTheme = function(self)
        Theme:ApplyFont(self.Title, "Bold", 14)
        Theme:ApplyFont(self.Text, "Normal", 12)

        -- Apply colors based on severity
        local severity = self.severity or "info"
        local r, g, b = Theme:GetAlertColor(severity)

        self:SetBackdropBorderColor(r, g, b, 1)
        self.Title:SetTextColor(r, g, b)

        -- Button
        self.Button.customColors = Theme:GetButtonColorsForAlert(severity)
        Theme:UpdateButtonState(self.Button)
      end
      Theme:RegisterT(frame)
    elseif type == "expandable" then
      frame = CreateFrame("Button", nil, parent, "BackdropTemplate")
      frame:SetBackdrop({
        bgFile = "Interface/Buttons/WHITE8X8",
        edgeFile = "Interface/Buttons/WHITE8X8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
      })
      frame:SetBackdropColor(0.15, 0.15, 0.2, 1) -- Slightly lighter/bluish dark
      frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

      frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
      Theme:ApplyFont(frame.Title, "Bold", 13)
      frame.Title:SetPoint("LEFT", 10, 0)
      frame.Title:SetTextColor(0.6, 0.7, 0.8) -- Blue/Grey

      -- Expand/Collapse Icon
      frame.Icon = frame:CreateTexture(nil, "ARTWORK")
      frame.Icon:SetSize(16, 16)
      frame.Icon:SetPoint("RIGHT", -10, 0)
      frame.Icon:SetTexture("Interface/Buttons/UI-PlusButton-Up")

      -- Status Badge
      frame.Status = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      Theme:ApplyFont(frame.Status, "Bold", 10)
      frame.Status:SetPoint("RIGHT", frame.Icon, "LEFT", -10, 0)
      frame.Status:SetTextColor(0.5, 0.5, 0.5)

      -- Highlight
      frame.hl = frame:CreateTexture(nil, "HIGHLIGHT")
      frame.hl:SetAllPoints()
      frame.hl:SetColorTexture(1, 1, 1, 0.05)

      -- Theme Update for Expandable
      frame.UpdateTheme = function(self)
        Theme:ApplyFont(self.Title, "Bold", 13)
        Theme:ApplyFont(self.Status, "Bold", 10)
      end
    else
      frame = CreateFrame("Frame", nil, parent)
    end
  end

  -- Initial Registration / UpdateTheme definition for other types
  if not frame.UpdateTheme then
    if type == "alert" then
      frame.UpdateTheme = function(self)
        local severity = self.severity or "info"
        local r, g, b = Theme:GetAlertColor(severity)
        self.bg:SetColorTexture(r, g, b, 0.2)
        self.text:SetTextColor(r, g, b, 1)
        Theme:ApplyFont(self.text, "Normal", 12)
      end
    elseif type == "header" then
      frame.UpdateTheme = function(self)
        Theme:ApplyFont(self.text, "Bold", 14)
        self.text:SetTextColor(Theme:GetColor("header"))
      end
    elseif type == "description" then
      frame.UpdateTheme = function(self)
        Theme:ApplyFont(self.text, "Normal", 12)
        self.text:SetTextColor(Theme:GetColor("text"))
      end
    elseif type == "checkbox" then
      frame.UpdateTheme = function(self)
        if self.Text then
          Theme:ApplyFont(self.Text, "Normal", 12)
          self.Text:SetTextColor(Theme:GetColor("text"))
        end
      end
    elseif type == "slider" then
      frame.UpdateTheme = function(self)
        if self.Text then
          Theme:ApplyFont(self.Text, "Normal", 12); self.Text:SetTextColor(Theme:GetColor("text"))
        end
        if self.Low then
          Theme:ApplyFont(self.Low, "Normal", 10); self.Low:SetTextColor(Theme:GetColor("text"))
        end
        if self.High then
          Theme:ApplyFont(self.High, "Normal", 10); self.High:SetTextColor(Theme:GetColor("text"))
        end
      end
    elseif type == "media" then
      frame.UpdateTheme = function(self)
        Theme:ApplyFont(self.Label, "Normal", 12)
        self.Label:SetTextColor(Theme:GetColor("text"))
        Theme:ApplyFont(self.Text, "Normal", 12)
        self.Text:SetTextColor(1, 1, 1)
      end
    end
  end

  if frame.UpdateTheme then
    Theme:RegisterT(frame)
  end

  frame.type = type
  frame:SetParent(parent)
  frame:Show()
  return frame
end

function ConfigRenderer:Clear(container)
  local content = container.ContentChild
  if not content then return end

  -- Actually GetChildren returns varargs.
  local childs = { content:GetChildren() }
  for _, child in ipairs(childs) do
    child:Hide()
    child:ClearAllPoints()
    if child.type and FramePool[child.type] then
      table.insert(FramePool[child.type], child)
    end
  end

  -- Reset scroll child size?
  content:SetSize(1, 1)
end

function ConfigRenderer:Render(schema, container)
  self.currentSchema = schema
  self.currentContainer = container
  self:Clear(container)

  local content = container.ContentChild
  local width = container.Content:GetWidth()

  local cursor = {
    x = 10,
    y = -10,
    rowHeight = 0,
    maxWidth = width - 20
  }

  self:RenderGroup(schema, content, cursor)
end

function ConfigRenderer:RenderGroup(groupSchema, parent, cursor)
  if not groupSchema or not groupSchema.children then return end

  for _, item in ipairs(groupSchema.children) do
    self:RenderItem(item, parent, cursor)
  end
end

function ConfigRenderer:RenderItem(item, parent, cursor)
  local frame = GetFrame(item.type, parent)

  -- Setup basic props
  if item.label then
    if item.type == "checkbox" or item.type == "slider" then
      if frame.Text then frame.Text:SetText(item.label) end
    elseif item.type == "editbox" or item.type == "dropdown" or item.type == "colorpicker" or item.type == "media" then
      if frame.Label then frame.Label:SetText(item.label) end
    elseif item.type == "header" then
      frame.text:SetText(item.label)
    elseif item.type == "description" then
      frame.text:SetText(item.label)
    elseif item.type == "button" then
      frame.Text:SetText(item.label)
      if item.customColors then
        frame.customColors = item.customColors
        Theme:UpdateButtonState(frame)
      end
    end
  end

  if item.type == "callout" then
    frame.Title:SetText(item.title)
    frame.Text:SetText(item.text)
    frame.Button.Text:SetText(item.buttonText or "Click Me")
  end

  if item.type == "expandable" then
    frame.Title:SetText(item.label)
    if item.status then
      frame.Status:SetText(item.status)
      frame.Status:Show()
    else
      frame.Status:Hide()
    end

    if item.expanded then
      frame.Icon:SetTexture("Interface/Buttons/UI-MinusButton-Up")
      -- Lighter background for expanded
      local r, g, b = 0.25, 0.25, 0.25 -- Manual lighten
      if Theme then
        local tr, tg, tb = Theme:GetColor("button_hover")
        r, g, b = tr, tg, tb
      end
      frame:SetBackdropColor(r, g, b, 1)
    else
      frame.Icon:SetTexture("Interface/Buttons/UI-PlusButton-Up")
      -- Standard background for collapsed
      local r, g, b = 0.2, 0.2, 0.2
      if Theme then
        local tr, tg, tb = Theme:GetColor("button_normal")
        r, g, b = tr, tg, tb
      end
      frame:SetBackdropColor(r, g, b, 1)
    end
  end

  -- State Binding & Actions
  local currentVal = nil
  if item.id then
    currentVal = State:GetValue(item.id)
    if currentVal == nil then currentVal = item.default end
  end

  if item.type == "checkbox" then
    frame:SetChecked(currentVal == true)
    frame:SetScript("OnClick", function(chk)
      State:SetValue(item.id, chk:GetChecked())
    end)
  elseif item.type == "slider" then
    frame:SetMinMaxValues(item.min or 0, item.max or 100)
    frame:SetValueStep(item.step or 1)
    frame:SetValue(currentVal or (item.min or 0))
    frame:SetScript("OnValueChanged", function(_, value)
      State:SetValue(item.id, value)
    end)
  elseif item.type == "editbox" then
    frame:SetText(currentVal or "")
    frame:SetScript("OnEnterPressed", function(eb)
      State:SetValue(item.id, eb:GetText())
      eb:ClearFocus()
    end)
    frame:SetScript("OnEscapePressed", function(eb)
      eb:ClearFocus()
      eb:SetText(State:GetValue(item.id) or item.default or "")
    end)
  elseif item.type == "dropdown" and item.options then
    UIDropDownMenu_Initialize(frame, function(_, _, _)
      local info = UIDropDownMenu_CreateInfo()
      for _, opt in ipairs(item.options) do
        info.text = opt.label
        info.value = opt.value
        info.func = function(b)
          State:SetValue(item.id, b.value)
          UIDropDownMenu_SetSelectedValue(frame, b.value)
          UIDropDownMenu_SetText(frame, opt.label)
        end
        info.checked = (currentVal == opt.value)
        UIDropDownMenu_AddButton(info)
      end
    end)
    UIDropDownMenu_SetSelectedValue(frame, currentVal)
    UIDropDownMenu_SetText(frame, "Select...") -- Init text logic needed
    -- Find label for current val
    for _, opt in ipairs(item.options) do
      if opt.value == currentVal then
        UIDropDownMenu_SetText(frame, opt.label)
        break
      end
    end
  elseif item.type == "media" and item.options then
    -- Initial Text
    local found = false
    for _, opt in ipairs(item.options) do
      if opt.value == currentVal then
        frame.Text:SetText(opt.label)
        found = true
        break
      end
    end
    if not found then frame.Text:SetText(item.placeholder or "Select Media...") end

    frame:SetScript("OnClick", function()
      if frame.Popup:IsShown() then
        frame.Popup:Hide()
      else
        -- Populate Popup
        local popupContent = frame.Popup.Content
        -- Clear existing children (simple way)
        local kids = { popupContent:GetChildren() }
        for _, k in ipairs(kids) do
          k:Hide(); k:ClearAllPoints()
        end

        local yOff = 0
        local itemHeight = 20

        for _, opt in ipairs(item.options) do
          local btn = CreateFrame("Button", nil, popupContent)
          btn:SetSize(frame.Popup:GetWidth() - 25, itemHeight)
          btn:SetPoint("TOPLEFT", 5, yOff)

          -- Highlight
          local hl = btn:CreateTexture(nil, "HIGHLIGHT")
          hl:SetAllPoints()
          hl:SetColorTexture(1, 0.82, 0, 0.2)

          -- Text
          local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
          txt:SetPoint("LEFT", 5, 0)
          txt:SetText(opt.label)

          -- Select Action
          btn:SetScript("OnClick", function()
            State:SetValue(item.id, opt.value)
            frame.Text:SetText(opt.label)
            frame.Popup:Hide()
          end)

          -- Play Button (Music Note)
          local playBtn = CreateFrame("Button", nil, btn)
          playBtn:SetSize(16, 16)
          playBtn:SetPoint("RIGHT", -10, 0)

          local icon = playBtn:CreateTexture(nil, "ARTWORK")
          icon:SetAllPoints()
          -- "Midnight" style note icon using Atlas identified by user
          icon:SetAtlas("common-icon-sound")

          playBtn:SetScript("OnClick", function()
            if opt.value then
              PlaySoundFile(opt.value, "Master")
            end
          end)

          playBtn:SetScript("OnEnter", function(b)
            GameTooltip:SetOwner(b, "ANCHOR_RIGHT")
            GameTooltip:SetText("Play Sample")
            GameTooltip:Show()
          end)

          playBtn:SetScript("OnLeave", function()
            GameTooltip:Hide()
          end)

          yOff = yOff - itemHeight
        end

        popupContent:SetSize(frame.Popup:GetWidth(), math.abs(yOff))
        frame.Popup:Show()
      end
    end)
    -- Close popup when clicking elsewhere (simplified: just on hide parent or something?
    -- For strict focus loss, we need a FullScreen catch frame, but for now simple toggle is ok)
  elseif item.type == "colorpicker" then
    -- Hex to RGB conversion
    local function hex2rgb(hex)
      hex = hex:gsub("#", "")
      return tonumber("0x" .. hex:sub(1, 2)) / 255, tonumber("0x" .. hex:sub(3, 4)) / 255,
          tonumber("0x" .. hex:sub(5, 6)) / 255
    end
    if currentVal and type(currentVal) == "string" then
      local r, g, b = hex2rgb(currentVal)
      frame.swatch:SetColorTexture(r, g, b)
    end

    frame:SetScript("OnClick", function()
      -- Open Color Picker (mock)
      print("Opening ColorPicker for", item.id)
    end)
  elseif item.type == "button" and item.onClick then
    frame:SetScript("OnClick", item.onClick)
  elseif item.type == "callout" then
    frame.Button:SetScript("OnClick", item.onButtonClick)
    -- Styling overrides from item?
    if item.style or item.severity then
      frame.severity = item.style or item.severity
    else
      frame.severity = "info" -- default
    end

    -- Force update to apply severity colors
    if frame.UpdateTheme then frame:UpdateTheme() end
  elseif item.type == "expandable" then
    frame:SetScript("OnClick", function()
      item.expanded = not item.expanded
      self:Render(self.currentSchema, self.currentContainer)
    end)
  end


  -- Size & Layout
  local padding = 10

  if item.type == "alert" then
    frame.severity = item.severity
    if item.text then frame.text:SetText(item.text) end
    if frame.UpdateTheme then frame:UpdateTheme() end
    if PixelUtil then PixelUtil.SetSize(frame, cursor.maxWidth, 30) else frame:SetSize(cursor.maxWidth, 30) end
  elseif item.type == "header" then
    if PixelUtil then PixelUtil.SetSize(frame, cursor.maxWidth, 30) else frame:SetSize(cursor.maxWidth, 30) end
  elseif item.type == "description" then
    frame.text:SetWidth(cursor.maxWidth)                -- Fix width for wrap
    if item.text then frame.text:SetText(item.text) end -- Prioritize text prop or label
    local height = frame.text:GetStringHeight()
    if PixelUtil then
      PixelUtil.SetSize(frame, cursor.maxWidth, height + 10)
    else
      frame:SetSize(cursor.maxWidth,
        height + 10)
    end
  elseif item.type == "row" then
    -- Handle Row Layout
    -- Force new row if we are not at the start
    if cursor.x > 10 then
      cursor.x = 10
      cursor.y = cursor.y - cursor.rowHeight - padding
      cursor.rowHeight = 0
    end

    if item.children then
      local rowCursor = { x = cursor.x, y = cursor.y, rowHeight = 0, maxWidth = cursor.maxWidth }
      for _, child in ipairs(item.children) do
        self:RenderItem(child, parent, rowCursor)
      end
      -- Update main cursor y to account for the row's total height consumption
      -- If the row wrapped locally, rowCursor.y is already lower.
      -- We must also consume the height of the current/last row line.
      cursor.y = rowCursor.y - rowCursor.rowHeight - 10 -- Add padding
      cursor.rowHeight = 0
      cursor.x = 10                                     -- Reset X for next main item
      return                                            -- Skip default layout logic for row container itself
    end
  elseif item.type == "callout" then
    frame.Text:SetWidth(cursor.maxWidth - 20)
    local textHeight = frame.Text:GetStringHeight()
    local totalHeight = 10 + 20 + 5 + textHeight + 10 + 30 + 10 -- Padding + Title + pad + Text + pad + Button + pad
    if PixelUtil then
      PixelUtil.SetSize(frame, cursor.maxWidth, totalHeight)
    else
      frame:SetSize(cursor.maxWidth,
        totalHeight)
    end
  elseif item.type == "media" then
    local w, h = 200, 26
    if item.width then w = item.width end
    if PixelUtil then
      PixelUtil.SetSize(frame, w, h)
    else
      frame:SetSize(w, h)
    end
  elseif item.type == "expandable" then
    if PixelUtil then
      PixelUtil.SetSize(frame, cursor.maxWidth, 30)
    else
      frame:SetSize(cursor.maxWidth, 30)
    end
  else
    -- Basic sizing
    local w, h = 150, 26
    if item.type == "checkbox" or item.type == "colorpicker" then w, h = 30, 30 end
    if item.type == "editbox" then w = 200 end
    if item.width then w = item.width end

    if PixelUtil then
      PixelUtil.SetSize(frame, w, h)
    else
      frame:SetSize(w, h)
    end
  end

  -- Measure effective width for layout
  -- Measure effective width/height for layout
  local frameWidth, frameHeight = frame:GetSize()
  local effectiveWidth = frameWidth
  local effectiveHeight = frameHeight

  if item.type == "checkbox" and frame.Text then
    local textWidth = frame.Text:GetStringWidth() or 100
    effectiveWidth = frameWidth + textWidth + 5
  elseif item.type == "slider" then
    -- Sliders have labels outside their frame bounds
    local topHeight = 0
    local bottomHeight = 0

    if frame.Text and frame.Text:GetText() then
      topHeight = frame.Text:GetStringHeight() + 5
    end

    if (frame.Low and frame.Low:GetText()) or (frame.High and frame.High:GetText()) then
      bottomHeight = 14 -- Approx for small font
    end

    effectiveHeight = frameHeight + topHeight + bottomHeight
  end

  if cursor.x + effectiveWidth > cursor.maxWidth then
    -- New Row
    cursor.x = 10
    cursor.y = cursor.y - cursor.rowHeight - padding
    cursor.rowHeight = 0
  end

  frame:ClearAllPoints()

  -- Calculate Top Offset for Sliders (applies to PixelUtil too)
  local yOffset = 0
  if item.type == "slider" and frame.Text and frame.Text:GetText() then
    yOffset = -(frame.Text:GetStringHeight() + 5)
  end

  if PixelUtil then
    PixelUtil.SetPoint(frame, "TOPLEFT", parent, "TOPLEFT", cursor.x, cursor.y + yOffset)
  else
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", cursor.x, cursor.y + yOffset)
  end

  -- Update Cursor
  cursor.x = cursor.x + effectiveWidth + padding
  cursor.rowHeight = math.max(cursor.rowHeight, effectiveHeight)

  -- Specific Logic for Expandable Children
  if item.type == "expandable" and item.expanded and item.children then
    -- Force new row for children
    cursor.x = 10
    cursor.y = cursor.y - cursor.rowHeight - 5
    cursor.rowHeight = 0

    -- Indent
    local indent = 30
    local childCursor = {
      x = cursor.x + indent,
      y = cursor.y,
      rowHeight = 0,
      maxWidth = cursor.maxWidth - indent
    }

    -- Background for content?
    -- Currently just rendering in flow.
    for _, child in ipairs(item.children) do
      self:RenderItem(child, parent, childCursor)
    end

    -- Recover cursor for next sibling item
    cursor.y = childCursor.y - 10 -- Add Buffer Padding after children
    cursor.rowHeight = 0
    cursor.x = 10
  end
end
