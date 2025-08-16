--// STREE HUB - Loader UI (Final Version)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI Parent
local success, result = pcall(function()
	return game:GetService("CoreGui")
end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "STREE_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

-- Variabel Windows
local KeyWindow = Instance.new("Frame")
local MainWindow = Instance.new("Frame")

-- CONFIG KEY
local validKeys = {
	"STREE-12345",
	"FREE-ACCESS"
}

-- Fungsi drag
local function makeDraggable(gui)
	local dragging, dragInput, dragStart, startPos
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

--// ========== KEY WINDOW ==========
KeyWindow.Name = "KeyWindow"
KeyWindow.Size = UDim2.new(0, 350, 0, 200)
KeyWindow.Position = UDim2.new(0.5, -175, 0.5, -100)
KeyWindow.BackgroundColor3 = Color3.fromRGB(25,25,25)
KeyWindow.Visible = true
KeyWindow.Parent = ScreenGui
makeDraggable(KeyWindow)

local KeyTitle = Instance.new("TextLabel", KeyWindow)
KeyTitle.Size = UDim2.new(1,0,0,30)
KeyTitle.BackgroundColor3 = Color3.fromRGB(0,200,0)
KeyTitle.Text = "🔑 STREE HUB - Key System"
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.TextSize = 18

local KeyBox = Instance.new("TextBox", KeyWindow)
KeyBox.PlaceholderText = "Enter your key here"
KeyBox.Size = UDim2.new(0.9,0,0,30)
KeyBox.Position = UDim2.new(0.05,0,0,50)
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.ClearTextOnFocus = false

local EnterButton = Instance.new("TextButton", KeyWindow)
EnterButton.Size = UDim2.new(0.4,0,0,30)
EnterButton.Position = UDim2.new(0.05,0,0,100)
EnterButton.BackgroundColor3 = Color3.fromRGB(0,150,0)
EnterButton.Text = "Enter"
EnterButton.TextColor3 = Color3.new(1,1,1)

local DiscordButton = Instance.new("TextButton", KeyWindow)
DiscordButton.Size = UDim2.new(0.4,0,0,30)
DiscordButton.Position = UDim2.new(0.55,0,0,100)
DiscordButton.BackgroundColor3 = Color3.fromRGB(60,60,150)
DiscordButton.Text = "Join Discord"
DiscordButton.TextColor3 = Color3.new(1,1,1)

local GetKeyButton = Instance.new("TextButton", KeyWindow)
GetKeyButton.Size = UDim2.new(0.9,0,0,30)
GetKeyButton.Position = UDim2.new(0.05,0,0,140)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(150,150,0)
GetKeyButton.Text = "🌐 Get Key (LootLabs / Linkvertise / Rekonise)"
GetKeyButton.TextColor3 = Color3.new(1,1,1)

--// ========== MAIN WINDOW ==========
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0,500,0,300)
MainWindow.Position = UDim2.new(0.5,-250,0.5,-150)
MainWindow.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainWindow.Visible = false
MainWindow.Parent = ScreenGui
makeDraggable(MainWindow)

local Header = Instance.new("Frame", MainWindow)
Header.Size = UDim2.new(1,0,0,30)
Header.BackgroundColor3 = Color3.fromRGB(0,200,0)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "🌟 STREE HUB Main UI"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Tombol Header
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-30,0,0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
CloseBtn.TextColor3 = Color3.new(1,1,1)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-60,0,0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
MinBtn.TextColor3 = Color3.new(1,1,1)

local XKeyBtn = Instance.new("TextButton", Header)
XKeyBtn.Size = UDim2.new(0,50,0,30)
XKeyBtn.Position = UDim2.new(1,-110,0,0)
XKeyBtn.Text = "X KEY"
XKeyBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
XKeyBtn.TextColor3 = Color3.new(1,1,1)

-- Search Bar
local SearchBox = Instance.new("TextBox", MainWindow)
SearchBox.PlaceholderText = "🔍 Search feature..."
SearchBox.Size = UDim2.new(0.9,0,0,30)
SearchBox.Position = UDim2.new(0.05,0,0,50)
SearchBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
SearchBox.TextColor3 = Color3.new(1,1,1)

-- Section Dummy
local HomeLabel = Instance.new("TextLabel", MainWindow)
HomeLabel.Text = "🏠 Home Tab (isi toggle & fitur disini)"
HomeLabel.Size = UDim2.new(1,0,0,30)
HomeLabel.Position = UDim2.new(0,0,0,100)
HomeLabel.BackgroundColor3 = Color3.fromRGB(30,30,30)
HomeLabel.TextColor3 = Color3.new(1,1,1)

local CreditsLabel = Instance.new("TextLabel", MainWindow)
CreditsLabel.Text = "💡 Credits Tab"
CreditsLabel.Size = UDim2.new(1,0,0,30)
CreditsLabel.Position = UDim2.new(0,0,0,140)
CreditsLabel.BackgroundColor3 = Color3.fromRGB(30,30,30)
CreditsLabel.TextColor3 = Color3.new(1,1,1)

-- Logo (buat restore kalau minimize)
local LogoBtn = Instance.new("TextButton", ScreenGui)
LogoBtn.Size = UDim2.new(0,80,0,30)
LogoBtn.Position = UDim2.new(0,10,0,200)
LogoBtn.Text = "STREE HUB"
LogoBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
LogoBtn.TextColor3 = Color3.new(1,1,1)
LogoBtn.Visible = false

--// ========== FUNCTIONS ==========
EnterButton.MouseButton1Click:Connect(function()
	local key = KeyBox.Text
	for _,v in pairs(validKeys) do
		if key == v then
			KeyWindow.Visible = false
			MainWindow.Visible = true
			return
		end
	end
	KeyBox.Text = "❌ Invalid Key!"
end)

DiscordButton.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/your-server")
end)

GetKeyButton.MouseButton1Click:Connect(function()
	setclipboard("https://lootlabs.gg/getkey")
end)

GetKeyButton.MouseButton1Click:Connect(function()
	setclipboard("https://lootlabs.gg/getkey")
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
	MainWindow.Visible = false
	LogoBtn.Visible = true
end)

LogoBtn.MouseButton1Click:Connect(function()
	MainWindow.Visible = true
	LogoBtn.Visible = false
end)

XKeyBtn.MouseButton1Click:Connect(function()
	MainWindow.Visible = false
	KeyWindow.Visible = true
end)
