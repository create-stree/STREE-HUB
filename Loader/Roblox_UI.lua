-- STREE HUB Final UI by kirsiasc
-- Full Script Version (Tanpa File)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Main GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "STREE_HUB"
ScreenGui.ResetOnSpawn = false

-- Main Window
local MainWindow = Instance.new("Frame", ScreenGui)
MainWindow.Size = UDim2.new(0, 600, 0, 400)
MainWindow.Position = UDim2.new(0.5, -300, 0.5, -200)
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainWindow.BorderSizePixel = 0
MainWindow.Visible = true
MainWindow.Active = true
MainWindow.Draggable = true

-- Blur (khusus window/tab kanan)
local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Parent = game:GetService("Lighting")

-- Title Bar
local titleBar = Instance.new("Frame", MainWindow)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0

-- Logo Header
local headerLogo = Instance.new("ImageLabel", titleBar)
headerLogo.Size = UDim2.new(0, 30, 0, 30)
headerLogo.Position = UDim2.new(0, 5, 0, 5)
headerLogo.Image = "rbxassetid://123032091977400" -- Ganti dengan ID logomu
headerLogo.BackgroundTransparency = 1

-- Judul
local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 40, 0, 0)
title.Text = "STREE | Grow A Garden | v0.00.01"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.TextSize = 16
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 40, 1, 0)
minimizeBtn.Position = UDim2.new(1, -80, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18

-- Logo (Toggle open/close window)
local logoBtn = Instance.new("ImageButton", ScreenGui)
logoBtn.Size = UDim2.new(0, 50, 0, 50)
logoBtn.Position = UDim2.new(0, 10, 0, 10)
logoBtn.Image = "rbxassetid://123032091977400"
logoBtn.BackgroundTransparency = 1

-- Animasi buka/tutup window
local function toggleWindow()
	if MainWindow.Visible then
		local shrink = TweenService:Create(logoBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 40, 0, 40)})
		shrink:Play()
		MainWindow.Visible = false
	else
		local grow = TweenService:Create(logoBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)})
		grow:Play()
		MainWindow.Visible = true
	end
end

logoBtn.MouseButton1Click:Connect(toggleWindow)

-- Minimize
minimizeBtn.MouseButton1Click:Connect(function()
	MainWindow.Visible = false
end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
	MainWindow.Visible = false
	logoBtn.Visible = false
	blur:Destroy()
end)

-- Sidebar Tab (kanan)
local tabFrame = Instance.new("Frame", MainWindow)
tabFrame.Size = UDim2.new(0, 120, 1, -40)
tabFrame.Position = UDim2.new(1, -120, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabFrame.BorderSizePixel = 0

-- Tab Button (Home)
local tabHome = Instance.new("TextButton", tabFrame)
tabHome.Size = UDim2.new(1, 0, 0, 40)
tabHome.Position = UDim2.new(0, 0, 0, 0)
tabHome.Text = "Home"
tabHome.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
tabHome.TextColor3 = Color3.fromRGB(0, 0, 0)
tabHome.Font = Enum.Font.GothamBold
tabHome.TextSize = 16

-- Home Content Section
local homeSection = Instance.new("Frame", MainWindow)
homeSection.Size = UDim2.new(1, -140, 1, -60)
homeSection.Position = UDim2.new(0, 10, 0, 50)
homeSection.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
homeSection.BorderSizePixel = 0

local homeText = Instance.new("TextLabel", homeSection)
homeText.Size = UDim2.new(1, 0, 0, 30)
homeText.Position = UDim2.new(0, 0, 0, 0)
homeText.Text = "Welcome to STREE HUB!"
homeText.TextColor3 = Color3.fromRGB(0, 255, 0)
homeText.BackgroundTransparency = 1
homeText.Font = Enum.Font.GothamBold
homeText.TextSize = 20

-- Fungsi buka tab Home
tabHome.MouseButton1Click:Connect(function()
	homeSection.Visible = true
	-- Tambahkan nanti jika ada tab lain
end)
