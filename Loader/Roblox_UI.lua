-- STREE HUB Custom UI by kirsiasc

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Create UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "STREE_HUB_UI"
ScreenGui.ResetOnSpawn = false

-- Function: Create glow border
local function createGlow(parent)
	local glow = Instance.new("UIStroke", parent)
	glow.Color = Color3.fromRGB(0, 255, 0)
	glow.Thickness = 2
	glow.Transparency = 0
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	glow.LineJoinMode = Enum.LineJoinMode.Round

	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	TweenService:Create(glow, tweenInfo, {Transparency = 0.2}):Play()
end

-- Main Window
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Glow border
createGlow(MainFrame)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Draggable logo
local Logo = Instance.new("ImageLabel", Header)
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 0, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://YOUR_LOGO_ASSET_ID" -- Ganti dengan ID logomu
Logo.ScaleType = Enum.ScaleType.Fit

-- Drag function
local dragging, dragInput, dragStart, startPos
Logo.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = ScreenGui.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

Logo.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Button: Close (X)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 20
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Button: Minimize (-)
local MinimizeBtn = Instance.new("TextButton", Header)
MinimizeBtn.Text = "-"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.Font = Enum.Font.Gotham
MinimizeBtn.TextSize = 20

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.BackgroundTransparency = 1

MinimizeBtn.MouseButton1Click:Connect(function()
	ContentFrame.Visible = not ContentFrame.Visible
end)

-- Right Side Tab Menu
local Sidebar = Instance.new("Frame", ContentFrame)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.Position = UDim2.new(1, -100, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Tabs = {
	"Home",
	"Game",
	"Macro",
	"Webhook",
	"Settings"
}

local SelectedTab = nil
local TabFrames = {}

for i, name in ipairs(Tabs) do
	local Button = Instance.new("TextButton", Sidebar)
	Button.Size = UDim2.new(1, 0, 0, 30)
	Button.Position = UDim2.new(0, 0, 0, (i - 1) * 35)
	Button.Text = name
	Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14

	local TabFrame = Instance.new("Frame", ContentFrame)
	TabFrame.Name = name .. "Tab"
	TabFrame.Size = UDim2.new(1, -100, 1, 0)
	TabFrame.Position = UDim2.new(0, 0, 0, 0)
	TabFrame.Visible = false
	TabFrame.BackgroundTransparency = 1

	TabFrames[name] = TabFrame

	Button.MouseButton1Click:Connect(function()
		if SelectedTab then TabFrames[SelectedTab].Visible = false end
		TabFrame.Visible = true
		SelectedTab = name
	end)
end

-- Show default tab
TabFrames["Home"].Visible = true
SelectedTab = "Home"

-- Example Components in Home tab
local Label = Instance.new("TextLabel", TabFrames["Home"])
Label.Text = "Welcome to STREE HUB!"
Label.Size = UDim2.new(1, 0, 0, 50)
Label.Position = UDim2.new(0, 0, 0, 0)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(0, 255, 0)
Label.Font = Enum.Font.GothamBold
Label.TextSize = 24

local Toggle = Instance.new("TextButton", TabFrames["Home"])
Toggle.Size = UDim2.new(0, 200, 0, 40)
Toggle.Position = UDim2.new(0, 0, 0, 60)
Toggle.Text = "Toggle Option: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.Gotham
Toggle.TextSize = 16

local state = false
Toggle.MouseButton1Click:Connect(function()
	state = not state
	Toggle.Text = "Toggle Option: " .. (state and "ON" or "OFF")
end)
