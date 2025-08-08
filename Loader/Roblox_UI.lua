-- STREE HUB Loader + Key System + Save Config
-- Dibuat manual tanpa library eksternal

-- // CONFIG
local ConfigFile = "streehub_config.json"
local ValidKeys = {"STREE-12345", "VIP-ACCESS"} -- Daftar key valid
local Config = {}
local HttpService = game:GetService("HttpService")

-- // LOAD CONFIG
local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        Config = HttpService:JSONDecode(readfile(ConfigFile))
    else
        Config = { Toggle1 = false, Slider1 = 50 }
    end
end

-- // SAVE CONFIG
local function SaveConfig()
    if writefile then
        writefile(ConfigFile, HttpService:JSONEncode(Config))
    end
end

LoadConfig()

-- // GUI UTAMA
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "STREE_HUB"

-- // LOGO HUB
local LogoButton = Instance.new("ImageButton")
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(0, 10, 0, 150) -- samping chat
LogoButton.BackgroundTransparency = 1
LogoButton.Image = "rbxassetid://123032091977400" 
LogoButton.Parent = ScreenGui

-- // WINDOW UTAMA
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Pinggir neon hijau
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(0, 255, 0)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Blur di tab kanan saja
local RightTab = Instance.new("Frame")
RightTab.Size = UDim2.new(0, 120, 1, 0)
RightTab.Position = UDim2.new(1, -120, 0, 0)
RightTab.BackgroundTransparency = 0.4
RightTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
RightTab.Parent = MainFrame

local Blur = Instance.new("UIGradient", RightTab)
Blur.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 180, 0))
Blur.Rotation = 90

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STREE | Grow A Garden | v0.00.01"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- // FUNGSI DRAG
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- // BUTTON, TOGGLE, SLIDER
local HomeTab = Instance.new("Frame")
HomeTab.Size = UDim2.new(1, -120, 1, -30)
HomeTab.Position = UDim2.new(0, 10, 0, 30)
HomeTab.BackgroundTransparency = 1
HomeTab.Parent = MainFrame

-- Section
local SectionLabel = Instance.new("TextLabel")
SectionLabel.Size = UDim2.new(1, 0, 0, 25)
SectionLabel.Text = "Main Features"
SectionLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
SectionLabel.Font = Enum.Font.GothamBold
SectionLabel.TextSize = 14
SectionLabel.BackgroundTransparency = 1
SectionLabel.Parent = HomeTab

-- Button
local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(0, 150, 0, 30)
TestButton.Position = UDim2.new(0, 0, 0, 30)
TestButton.Text = "Run Feature"
TestButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
TestButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TestButton.Parent = HomeTab
TestButton.MouseButton1Click:Connect(function()
    print("Feature executed!")
end)

-- Toggle
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 150, 0, 30)
ToggleButton.Position = UDim2.new(0, 0, 0, 70)
ToggleButton.Text = Config.Toggle1 and "Toggle: ON" or "Toggle: OFF"
ToggleButton.BackgroundColor3 = Config.Toggle1 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.Parent = HomeTab
ToggleButton.MouseButton1Click:Connect(function()
    Config.Toggle1 = not Config.Toggle1
    ToggleButton.Text = Config.Toggle1 and "Toggle: ON" or "Toggle: OFF"
    ToggleButton.BackgroundColor3 = Config.Toggle1 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    SaveConfig()
end)

-- Slider
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0, 150, 0, 30)
SliderFrame.Position = UDim2.new(0, 0, 0, 110)
SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderFrame.Parent = HomeTab

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(Config.Slider1/100, 0, 1, 0)
SliderBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
SliderBar.Parent = SliderFrame

SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local moveConn
        moveConn = game:GetService("UserInputService").InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                local rel = math.clamp((moveInput.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                SliderBar.Size = UDim2.new(rel, 0, 1, 0)
                Config.Slider1 = math.floor(rel * 100)
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                moveConn:Disconnect()
                SaveConfig()
            end
        end)
    end
end)

-- // LOGO TOGGLE
LogoButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- // KEY SYSTEM
local function ShowKeyUI()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 300, 0, 150)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    KeyFrame.BackgroundTransparency = 0.3
    KeyFrame.BorderSizePixel = 0

    local Box = Instance.new("TextBox", KeyFrame)
    Box.Size = UDim2.new(1, -20, 0, 30)
    Box.Position = UDim2.new(0, 10, 0, 20)
    Box.PlaceholderText = "Enter your key..."
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local Btn = Instance.new("TextButton", KeyFrame)
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, 70)
    Btn.Text = "Verify"
    Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

    Btn.MouseButton1Click:Connect(function()
        if table.find(ValidKeys, Box.Text) then
            KeyFrame:Destroy()
            MainFrame.Visible = true
        else
            Btn.Text = "Invalid Key!"
            Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            wait(1)
            Btn.Text = "Verify"
            Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
end

ShowKeyUI()
