local Name, AddOn = ...
local ConfigLayout = {}
AddOn.ConfigLayout = ConfigLayout

local PixelUtil = AddOn.PixelUtil or PixelUtil -- Fallback if global
local CreateFrame = CreateFrame

local Theme = AddOn.ConfigTheme

local function UpdateButtonState(btn)
  local colors = Theme:GetColor("button_" .. (btn.isSelected and "selected" or (btn.isHover and "hover" or "normal")))
  local r, g, b, a = unpack(colors)
  btn.bg:SetColorTexture(r, g, b, a)
end

function ConfigLayout:CreateTwoColumnLayout(parent)
  local container = CreateFrame("Frame", nil, parent)
  container:SetAllPoints()

  -- Sidebar (Left)
  local sidebar = CreateFrame("Frame", nil, container)
  sidebar:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
  sidebar:SetPoint("BOTTOMLEFT", container, "BOTTOMLEFT", 0, 0)
  sidebar:SetWidth(200)

  -- Sidebar Background
  local sidebarBg = sidebar:CreateTexture(nil, "BACKGROUND")
  sidebarBg:SetAllPoints()
  sidebarBg:SetColorTexture(0.1, 0.1, 0.1, 0.5) -- Placeholder
  sidebar.bg = sidebarBg

  -- Content (Right)
  -- Remove UIPanelScrollFrameTemplate to manually control scrollbar
  local content = CreateFrame("ScrollFrame", nil, container)

  -- Padding / Inset adjustment
  content:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 10, -10)
  content:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -30, 10) -- Right padding for scrollbar space

  local child = CreateFrame("Frame")
  child:SetSize(1, 1) -- Will auto-grow
  content:SetScrollChild(child)

  -- Content Background (Optional, maybe specific to content area)
  local contentBg = content:CreateTexture(nil, "BACKGROUND")
  contentBg:SetAllPoints()
  contentBg:SetColorTexture(0, 0, 0, 0.5) -- Placeholder
  content.bg = contentBg

  -- Custom ScrollBar (Thin/Minimal Style using Slider)
  -- Note: MinimalScrollBarTemplate usage caused modern ScrollUtil link errors.
  -- We fallback to a manual slider implementation for maximum compatibility with vanilla/classic/modern.
  local scrollBar = CreateFrame("Slider", nil, container)
  scrollBar:SetPoint("TOPRIGHT", content, "TOPRIGHT", 25, 0) -- Outside content padding
  scrollBar:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 25, 0)
  scrollBar:SetWidth(6)

  -- ScrollBar Visuals
  local thumb = scrollBar:CreateTexture(nil, "OVERLAY")
  thumb:SetColorTexture(0.4, 0.4, 0.4, 0.8)
  thumb:SetSize(6, 30)
  scrollBar:SetThumbTexture(thumb)

  local bg = scrollBar:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints()
  bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

  -- Manual Scroll Wiring to avoid ScrollUtil compatibility issues
  scrollBar:SetObeyStepOnDrag(true)
  scrollBar:SetValueStep(1)

  -- Link: ScrollBar -> ScrollFrame
  scrollBar:SetScript("OnValueChanged", function(self, value)
    content:SetVerticalScroll(value)
  end)

  -- Link: ScrollFrame -> ScrollBar
  content:SetScript("OnScrollRangeChanged", function(self, xrange, yrange)
    scrollBar:SetMinMaxValues(0, yrange)
    if yrange > 0 then
      local thumbHeight = math.max(20, (content:GetHeight() / (content:GetHeight() + yrange)) * content:GetHeight())
      thumb:SetHeight(thumbHeight)
      scrollBar:Show()
    else
      scrollBar:Hide()
      scrollBar:SetValue(0)
    end
  end)

  content:SetScript("OnVerticalScroll", function(self, offset)
    scrollBar:SetValue(offset)
  end)

  content:SetScript("OnMouseWheel", function(self, delta)
    local current = scrollBar:GetValue()
    local step = 40 -- Scroll speed
    scrollBar:SetValue(current - (delta * step))
  end)

  -- Ensure initial state
  scrollBar:Hide()

  -- Store refs
  container.Sidebar = sidebar
  container.Content = content
  container.ContentChild = child
  container.ScrollBar = scrollBar

  return container
end

function ConfigLayout:AddSidebarButton(container, id, label, onClick)
  local sidebar = container.Sidebar
  local count = sidebar.buttonCount or 0

  local btn = Theme:CreateThemedButton(sidebar)
  btn:SetSize(180, 30)
  btn:SetPoint("TOP", sidebar, "TOP", 0, -10 - (count * 35))

  -- Update text for custom fontstring
  btn.Text:SetText(label)

  -- Wrapper for OnClick to handle selection logic if we wanted (managed by parent?)
  btn:SetScript("OnClick", function(self)
    if container.SelectedBtn and container.SelectedBtn ~= self then
      container.SelectedBtn:SetSelected(false)
    end
    self:SetSelected(true)
    container.SelectedBtn = self

    if onClick then onClick() end
  end)

  sidebar.buttonCount = count + 1
  return btn
end

function ConfigLayout:SetScale(container, scale)
  container:SetScale(scale)
  -- PixelUtil:SetSize calls if needed for pixel perfection
end
