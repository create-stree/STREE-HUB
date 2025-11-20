-- Tabs.lua
local TweenService = game:GetService("TweenService")

local module = {}

local tabs = {}
local currentTab = nil

function module:CreateTab(ui, title)
	local tabButton = Instance.new("TextButton")
	local tabFrame = Instance.new("ScrollingFrame")
	
	-- Tab Button
	tabButton.Name = title .. "Tab"
	tabButton.Size = UDim2.new(0.9, 0, 0, 40)
	tabButton.BackgroundColor3 = ui.Colors.Black
	tabButton.Text = title
	tabButton.TextColor3 = ui.Colors.NeonGreen
	tabButton.TextSize = 14
	tabButton.Font = Enum.Font.Gotham
	tabButton.BorderSizePixel = 0
	tabButton.Parent = ui.TabButtons
	
	local buttonGlow = Instance.new("UIStroke")
	buttonGlow.Parent = tabButton
	buttonGlow.Color = ui.Colors.NeonGreen
	buttonGlow.Thickness = 1
	buttonGlow.Transparency = 0.5
	
	-- Tab Content Frame
	tabFrame.Name = title .. "Content"
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.Position = UDim2.new(0, 0, 0, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.ScrollBarThickness = 4
	tabFrame.ScrollBarImageColor3 = ui.Colors.NeonGreen
	tabFrame.Visible = false
	tabFrame.Parent = ui.ContentFrame
	
	local layout = Instance.new("UIListLayout")
	layout.Parent = tabFrame
	layout.Padding = UDim.new(0, 10)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local padding = Instance.new("UIPadding")
	padding.Parent = tabFrame
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	
	local tab = {
		Button = tabButton,
		Frame = tabFrame,
		Title = title,
		Elements = {}
	}
	
	table.insert(tabs, tab)
	
	-- Tab selection
	tabButton.MouseButton1Click:Connect(function()
		module:SelectTab(tab)
	end)
	
	-- Auto-select first tab
	if #tabs == 1 then
		module:SelectTab(tab)
	end
	
	return tab
end

function module:SelectTab(selectedTab)
	-- Deselect all tabs
	for _, tab in pairs(tabs) do
		tab.Frame.Visible = false
		tab.Button.BackgroundColor3 = Color3.new(0, 0, 0)
		tab.Button.TextColor3 = Color3.new(0, 1, 0)
	end
	
	-- Select clicked tab
	selectedTab.Frame.Visible = true
	selectedTab.Button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	selectedTab.Button.TextColor3 = Color3.new(0, 2, 0) -- Brighter green
	
	currentTab = selectedTab
end

return module
