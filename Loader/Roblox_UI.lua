-- STREE HUB UI by kirsiasc (Final)
-- Tidak pakai external library, bergaya Alchemy, tab kanan, blur sidebar

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Blur sidebar
local blurEffect = Instance.new("BlurEffect", Lighting)
blurEffect.Size = 0

-- GUI utama
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "STREE_HUB"
ScreenGui.ResetOnSpawn = false

-- Logo
local LogoButton = Instance.new("ImageButton")
LogoButton.Name = "LogoButton"
LogoButton.Parent = ScreenGui
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(0, 10, 0, 10)
LogoButton.Image = "rbxassetid://YOUR_LOGO_IMAGE_ID" -- ganti dengan ID logomu
LogoButton.BackgroundTransparency = 1
LogoButton.ZIndex = 10

-- Window utama
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Shadow/Border
local border = Instance.new("UIStroke", MainFrame)
border.Thickness = 2
border.Color = Color3.fromRGB(0, 255, 0)
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Header
local Header = Instance.new("TextLabel")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Text = "STREE | Grow A Garden | v0.00.01"
Header.TextColor3 = Color3.fromRGB(0, 255, 0)
Header.Font = Enum.Font.SourceSansBold
Header.TextSize = 22

-- Minimize dan Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Text = "-"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = MainFrame

-- Sidebar tab kanan (dengan blur)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(1, -120, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sidebar.Parent = MainFrame

-- Blur aktif untuk sidebar
blurEffect.Size = 12

-- UIList untuk tombol tab
local tabList = Instance.new("UIListLayout", Sidebar)
tabList.Padding = UDim.new(0, 6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder

-- Container untuk konten tab
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame

-- Fungsi buat tab
local function createTab(name)
	local button = Instance.new("TextButton")
	button.Text = name
	button.Size = UDim2.new(1, -12, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	button.TextColor3 = Color3.fromRGB(0, 255, 0)
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	button.Parent = Sidebar

	local tabFrame = Instance.new("Frame")
	tabFrame.Name = name .. "Tab"
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = false
	tabFrame.Parent = ContentFrame

	button.MouseButton1Click:Connect(function()
		for _, child in pairs(ContentFrame:GetChildren()) do
			if child:IsA("Frame") then
				child.Visible = false
			end
		end
		tabFrame.Visible = true
	end)

	return tabFrame
end

-- === TAB: HOME ===
local HomeTab = createTab("Home")

local Section = Instance.new("Frame")
Section.Size = UDim2.new(0, 300, 0, 100)
Section.Position = UDim2.new(0, 20, 0, 20)
Section.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Section.BorderSizePixel = 0
Section.Parent = HomeTab

local SectionTitle = Instance.new("TextLabel")
SectionTitle.Size = UDim2.new(1, 0, 0, 30)
SectionTitle.Position = UDim2.new(0, 0, 0, 0)
SectionTitle.Text = "Welcome to STREE HUB!"
SectionTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
SectionTitle.BackgroundTransparency = 1
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextSize = 20
SectionTitle.Parent = Section

-- Default buka tab Home
HomeTab.Visible = true

-- Fungsi drag window
local dragging, dragInput, dragStart, startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Tombol Minimize dan Restore
MinimizeBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

LogoButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Tombol Close
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
