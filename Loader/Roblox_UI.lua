-- STREE HUB UI (Inspired by Alchemy Hub and No-Lag Hub, Right-Side Tabs)
-- Author: kirsiasc
-- Version: Alpha v1.0

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI Base
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "STREE_HUB"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Config Table (Save Data)
local Config = {
    AutoStart = false,
    AutoNext = false,
    AutoRetry = false,
    AutoStartDelay = 2,
    NextDelay = 2,
    RetryDelay = 2,
}

-- Save Config (Local)
local HttpService = game:GetService("HttpService")
local SaveFileName = "STREEHUB_Config.json"
local SaveFolder = getcustomasset and "streehub" or nil

local function SaveConfig()
    if writefile then
        local data = HttpService:JSONEncode(Config)
        writefile(SaveFileName, data)
    end
end

local function LoadConfig()
    if isfile and isfile(SaveFileName) then
        local data = readfile(SaveFileName)
        local decoded = HttpService:JSONDecode(data)
        for k, v in pairs(decoded) do
            Config[k] = v
        end
    end
end

LoadConfig()

-- Draggable Function
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(1, -510, 0.5, -175)
MainFrame.AnchorPoint = Vector2.new(0, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
makeDraggable(MainFrame, MainFrame)

-- Glow Border Effect (Optional)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 255, 0)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Transparency = 0

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Minimize and Close Buttons
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -60, 0, 0)
Minimize.Text = "–"
Minimize.TextColor3 = Color3.fromRGB(0, 255, 0)
Minimize.BackgroundTransparency = 1
Minimize.Parent = TopBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 0, 0)
Close.BackgroundTransparency = 1
Close.Parent = TopBar

-- Minimize Function
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    minimized = true
end)

-- Close Function
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Logo Button to Reopen
local LogoButton = Instance.new("ImageButton")
LogoButton.Name = "LogoButton"
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(0, 20, 0.5, -25)
LogoButton.BackgroundTransparency = 1
LogoButton.Image = "rbxassetid://123032091977400"
LogoButton.Parent = ScreenGui

LogoButton.MouseButton1Click:Connect(function()
    if minimized then
        MainFrame.Visible = true
        minimized = false
    end
end)

-- (Next: Add Right Side Tab + Home, Toggles, Sliders etc.)
