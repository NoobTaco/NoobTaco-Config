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
  local content = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
  content:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 0, 0)
  content:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 0, 0)

  local child = CreateFrame("Frame")
  child:SetSize(1, 1) -- Will auto-grow
  content:SetScrollChild(child)

  -- Content Background
  local contentBg = content:CreateTexture(nil, "BACKGROUND")
  contentBg:SetAllPoints()
  contentBg:SetColorTexture(0, 0, 0, 0.5) -- Placeholder
  content.bg = contentBg

  -- Store refs
  container.Sidebar = sidebar
  container.Content = content
  container.ContentChild = child

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
