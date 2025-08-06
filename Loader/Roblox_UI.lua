-- STREE HUB UI Fixed Version by kirsiasc (with drag, minimize, logo restore, config)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- GUI Container
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

-- Blur Effect
local Blur = Instance.new("BlurEffect", game:GetService("Lighting"))
Blur.Size = 5
Blur.Enabled = false

-- Main Window
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
createGlow(MainFrame)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Title Label
local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "STREE | Grow A Garden | v0.00.01"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
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

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton", Header)
MinimizeBtn.Text = "-"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.Font = Enum.Font.Gotham
MinimizeBtn.TextSize = 20

-- Logo Button (restore)
local LogoButton = Instance.new("ImageButton", ScreenGui)
LogoButton.Name = "HubIcon"
LogoButton.Size = UDim2.new(0, 40, 0, 40)
LogoButton.Position = UDim2.new(0, 130, 0, 20)
LogoButton.Image = "rbxassetid://123032091977400"
LogoButton.BackgroundTransparency = 1
LogoButton.Visible = false

LogoButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	LogoButton.Visible = false
	Blur.Enabled = false
end)

MinimizeBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	LogoButton.Visible = true
	Blur.Enabled = true
	Blur.Size = 12
end)

-- Content Frame
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.BackgroundTransparency = 1

-- Sidebar Tabs
local Sidebar = Instance.new("Frame", ContentFrame)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.Position = UDim2.new(1, -100, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Tabs = {"Home", "Game", "Macro", "Webhook", "Settings"}
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
		if SelectedTab then
			TabFrames[SelectedTab].Visible = false
		end
		TabFrame.Visible = true
		SelectedTab = name
	end)
end

-- Default Tab
TabFrames["Home"].Visible = true
SelectedTab = "Home"

-- Toggle Example
local Toggle = Instance.new("TextButton", TabFrames["Home"])
Toggle.Size = UDim2.new(0, 200, 0, 40)
Toggle.Position = UDim2.new(0, 0, 0, 60)
Toggle.Text = "Toggle Option: OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.Gotham
Toggle.TextSize = 16

local state = false
local DataStore = {}

local function saveConfig()
	DataStore["toggle"] = state
	writefile("stree_config.json", HttpService:JSONEncode(DataStore))
end

local function loadConfig()
	if isfile("stree_config.json") then
		local content = readfile("stree_config.json")
		local decoded = HttpService:JSONDecode(content)
		if decoded["toggle"] ~= nil then
			state = decoded["toggle"]
			Toggle.Text = "Toggle Option: " .. (state and "ON" or "OFF")
		end
	end
end

Toggle.MouseButton1Click:Connect(function()
	state = not state
	Toggle.Text = "Toggle Option: " .. (state and "ON" or "OFF")
	saveConfig()
end)

loadConfig()
