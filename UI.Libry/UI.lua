-- UI.Libry - Main Library
-- GitHub: https://github.com/STREE-HUB/UI.Libry

local UI_Libry = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuration
UI_Libry.Config = {
    Colors = {
        Black = Color3.fromRGB(10, 10, 10),
        DarkGray = Color3.fromRGB(20, 20, 20),
        Gray = Color3.fromRGB(40, 40, 40),
        NeonGreen = Color3.fromRGB(0, 255, 0),
        BrightGreen = Color3.fromRGB(0, 200, 0),
        White = Color3.fromRGB(255, 255, 255),
        Red = Color3.fromRGB(255, 80, 80),
        DiscordBlue = Color3.fromRGB(88, 101, 242),
        Orange = Color3.fromRGB(255, 165, 0)
    },
    Fonts = {
        Title = Enum.Font.GothamBold,
        Header = Enum.Font.GothamBold,
        Body = Enum.Font.Gotham,
        Label = Enum.Font.Gotham
    }
}

-- Valid Keys for Key System
UI_Libry.ValidKeys = {
    "STREEHUB-INDONESIA-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM", 
    "StreeCommunity-7g81ht7NO22",
    "STREE-PREMIUM-ACCESS-KEY",
    "STREEHUB-VIP-MEMBER"
}

-- ====== UTILITY FUNCTIONS ======
function UI_Libry:CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

function UI_Libry:RoundedCorner(parent, radius)
    local corner = self:CreateElement("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius or 8)
    })
    return corner
end

function UI_Libry:NeonStroke(parent, thickness, transparency)
    local stroke = self:CreateElement("UIStroke", {
        Parent = parent,
        Color = self.Config.Colors.NeonGreen,
        Thickness = thickness or 2,
        Transparency = transparency or 0.3
    })
    return stroke
end

function UI_Libry:MakeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function UI_Libry:SetupButtonHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = normalColor
        }):Play()
    end)
end

-- ====== KEY SYSTEM ======
function UI_Libry:IsKeyValid(keyInput)
    local key = keyInput:gsub("%s+", ""):upper()
    for _, validKey in ipairs(self.ValidKeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- ====== MAIN WINDOW ======
function UI_Libry:CreateWindow(config)
    local parentGui = game:GetService("CoreGui") or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    if parentGui:FindFirstChild("UI_Libry_Window") then
        parentGui.UI_Libry_Window:Destroy()
    end

    local gui = self:CreateElement("ScreenGui", {
        Parent = parentGui,
        Name = "UI_Libry_Window",
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    local mainFrame = self:CreateElement("Frame", {
        Parent = gui,
        Size = config.Size or UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = self.Config.Colors.Black,
        BorderSizePixel = 0
    })
    self:RoundedCorner(mainFrame, 12)
    self:NeonStroke(mainFrame, 3, 0.2)

    -- Title Bar
    local titleBar = self:CreateElement("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1
    })

    local titleLabel = self:CreateElement("TextLabel", {
        Parent = titleBar,
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "UI Libry",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 18,
        Font = self.Config.Fonts.Title,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local closeButton = self:CreateElement("TextButton", {
        Parent = titleBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 5),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = self.Config.Colors.Red,
        TextSize = 20,
        Font = Enum.Font.GothamBold
    })

    -- Tab Buttons Container
    local tabButtonsContainer = self:CreateElement("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(0, 120, 1, -60),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1
    })

    local tabButtonsLayout = self:CreateElement("UIListLayout", {
        Parent = tabButtonsContainer,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    -- Content Frame
    local contentFrame = self:CreateElement("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -120, 1, -60),
        Position = UDim2.new(0, 120, 0, 50),
        BackgroundColor3 = self.Config.Colors.DarkGray,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true
    })
    self:RoundedCorner(contentFrame, 8)
    self:NeonStroke(contentFrame, 1, 0.5)

    self:MakeDraggable(mainFrame, titleBar)

    local window = {
        GUI = gui,
        MainFrame = mainFrame,
        TitleBar = titleBar,
        CloseButton = closeButton,
        TabButtons = tabButtonsContainer,
        ContentFrame = contentFrame,
        Tabs = {},
        CurrentTab = nil
    }

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    function window:CreateTab(name)
        local tabButton = self:CreateElement("TextButton", {
            Parent = self.TabButtons,
            Size = UDim2.new(0.9, 0, 0, 40),
            BackgroundColor3 = UI_Libry.Config.Colors.DarkGray,
            Text = name,
            TextColor3 = UI_Libry.Config.Colors.NeonGreen,
            TextSize = 14,
            Font = UI_Libry.Config.Fonts.Header,
            BorderSizePixel = 0
        })
        UI_Libry:RoundedCorner(tabButton, 6)
        UI_Libry:NeonStroke(tabButton, 1, 0.5)

        local tabContent = self:CreateElement("ScrollingFrame", {
            Parent = self.ContentFrame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = UI_Libry.Config.Colors.NeonGreen,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        })

        local contentLayout = self:CreateElement("UIListLayout", {
            Parent = tabContent,
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        local tab = {
            Name = name,
            Button = tabButton,
            Content = tabContent,
            Frame = tabContent
        }

        UI_Libry:SetupButtonHover(tabButton, UI_Libry.Config.Colors.DarkGray, UI_Libry.Config.Colors.Gray)

        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, otherTab in pairs(self.Tabs) do
                otherTab.Content.Visible = false
                otherTab.Button.BackgroundColor3 = UI_Libry.Config.Colors.DarkGray
            end
            
            -- Show selected tab
            tabContent.Visible = true
            tabButton.BackgroundColor3 = UI_Libry.Config.Colors.Gray
            self.CurrentTab = tab
        end)

        table.insert(self.Tabs, tab)

        -- Auto-select first tab
        if #self.Tabs == 1 then
            tabButton.MouseButton1Click:Wait()
        end

        return tab
    end

    function window:Destroy()
        self.GUI:Destroy()
    end

    return window
end

-- ====== KEY SYSTEM UI ======
function UI_Libry:ShowKeySystem()
    local window = self:CreateWindow({
        Title = "STREE HUB - KEY SYSTEM",
        Size = UDim2.new(0, 400, 0, 350)
    })
    
    local mainTab = window:CreateTab("Key Verification")
    
    local statusLabel = self:CreateElement("TextLabel", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = "Status: Enter your key and click SUBMIT",
        TextColor3 = Color3.fromRGB(255, 165, 0),
        TextSize = 14,
        Font = self.Config.Fonts.Body,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local keyInput = self:CreateElement("TextBox", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = self.Config.Colors.DarkGray,
        TextColor3 = self.Config.Colors.White,
        PlaceholderText = "Enter your key here...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Font = self.Config.Fonts.Body,
        ClearTextOnFocus = false
    })
    self:RoundedCorner(keyInput, 8)
    self:NeonStroke(keyInput, 2, 0.5)

    local submitButton = self:CreateElement("TextButton", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 95),
        BackgroundColor3 = self.Config.Colors.BrightGreen,
        Text = "SUBMIT KEY",
        TextColor3 = self.Config.Colors.White,
        TextSize = 14,
        Font = self.Config.Fonts.Header,
        BorderSizePixel = 0
    })
    self:RoundedCorner(submitButton, 8)
    self:NeonStroke(submitButton, 2, 0.5)

    local getKeyButton = self:CreateElement("TextButton", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 145),
        BackgroundColor3 = self.Config.Colors.DarkGray,
        Text = "GET KEY",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 14,
        Font = self.Config.Fonts.Header,
        BorderSizePixel = 0
    })
    self:RoundedCorner(getKeyButton, 8)
    self:NeonStroke(getKeyButton, 2, 0.5)

    local discordButton = self:CreateElement("TextButton", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 195),
        BackgroundColor3 = self.Config.Colors.DiscordBlue,
        Text = "DISCORD SERVER",
        TextColor3 = self.Config.Colors.White,
        TextSize = 14,
        Font = self.Config.Fonts.Header,
        BorderSizePixel = 0
    })
    self:RoundedCorner(discordButton, 8)

    local function SubmitKey()
        local key = keyInput.Text:gsub("%s+", ""):upper()
        
        if key == "" then
            statusLabel.Text = "Status: Please enter a key before submitting"
            statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            return
        end
        
        if self:IsKeyValid(key) then
            statusLabel.Text = "Status: ✅ Key Accepted! Loading..."
            statusLabel.TextColor3 = self.Config.Colors.NeonGreen
            
            TweenService:Create(submitButton, TweenInfo.new(0.5), {
                BackgroundColor3 = self.Config.Colors.NeonGreen
            }):Play()
            
            task.wait(1.5)
            window:Destroy()
            self:ShowMainUI()
        else
            statusLabel.Text = "Status: ❌ Invalid Key - Please try again"
            statusLabel.TextColor3 = self.Config.Colors.Red
            
            TweenService:Create(submitButton, TweenInfo.new(0.3), {
                BackgroundColor3 = self.Config.Colors.Red
            }):Play()
            
            task.wait(0.8)
            TweenService:Create(submitButton, TweenInfo.new(0.3), {
                BackgroundColor3 = self.Config.Colors.BrightGreen
            }):Play()
        end
    end

    submitButton.MouseButton1Click:Connect(SubmitKey)
    
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitKey()
        end
    end)

    getKeyButton.MouseButton1Click:Connect(function()
        window:Destroy()
        self:ShowKeyLinksUI()
    end)

    discordButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/streehub")
        end
        discordButton.Text = "DISCORD COPIED!"
        task.wait(1)
        discordButton.Text = "DISCORD SERVER"
    end)

    self:SetupButtonHover(submitButton, self.Config.Colors.BrightGreen, self.Config.Colors.NeonGreen)
    self:SetupButtonHover(getKeyButton, self.Config.Colors.DarkGray, self.Config.Colors.Gray)
    self:SetupButtonHover(discordButton, self.Config.Colors.DiscordBlue, Color3.fromRGB(114, 137, 218))

    return window
end

function UI_Libry:ShowKeyLinksUI()
    local window = self:CreateWindow({
        Title = "GET YOUR KEY",
        Size = UDim2.new(0, 450, 0, 400)
    })
    
    local linksTab = window:CreateTab("Key Links")
    
    local instructionLabel = self:CreateElement("TextLabel", {
        Parent = linksTab.Content,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = "Complete any link below to get your key:",
        TextColor3 = self.Config.Colors.White,
        TextSize = 14,
        Font = self.Config.Fonts.Header,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    local keyLinks = {
        {"Rekonise", "https://rkns.link/2vbo0"},
        {"Linkvertise", "https://link-hub.net/1365203/NqhrZrvoQhoi"},
        {"Lootlabs", "https://lootdest.org/s?VooVvLbJ"},
        {"Work.Ink", "https://link-hub.net/1365203/NqhrZrvoQhoi"}
    }

    for i, linkData in ipairs(keyLinks) do
        local name, url = linkData[1], linkData[2]
        
        local linkButton = self:CreateElement("TextButton", {
            Parent = linksTab.Content,
            Size = UDim2.new(1, -20, 0, 50),
            Position = UDim2.new(0, 10, 0, 60 + (i-1)*60),
            BackgroundColor3 = self.Config.Colors.DarkGray,
            Text = "",
            BorderSizePixel = 0
        })
        self:RoundedCorner(linkButton, 8)
        self:NeonStroke(linkButton, 2, 0.5)

        local linkTitle = self:CreateElement("TextLabel", {
            Parent = linkButton,
            Size = UDim2.new(1, -20, 0.6, 0),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Text = "🔗 " .. name,
            TextColor3 = Color3.fromRGB(0, 255, 150),
            TextSize = 14,
            Font = self.Config.Fonts.Header,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local linkDesc = self:CreateElement("TextLabel", {
            Parent = linkButton,
            Size = UDim2.new(1, -20, 0.4, 0),
            Position = UDim2.new(0, 10, 0.6, 0),
            BackgroundTransparency = 1,
            Text = "Click to copy link",
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 11,
            Font = self.Config.Fonts.Body,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        self:SetupButtonHover(linkButton, self.Config.Colors.DarkGray, self.Config.Colors.Gray)

        linkButton.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(url)
            end
            linkTitle.Text = "✅ " .. name
            linkDesc.Text = "Link copied to clipboard!"
            linkTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            task.wait(1.5)
            linkTitle.Text = "🔗 " .. name
            linkDesc.Text = "Click to copy link"
            linkTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
        end)
    end

    return window
end

function UI_Libry:ShowMainUI()
    -- Load semua components
    local Button = loadstring(game:HttpGet("https://raw.githubusercontent.com/STREE-HUB/UI.Libry/Button.lua"))()
    local Toggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/STREE-HUB/UI.Libry/Toggle.lua"))()
    local Slider = loadstring(game:HttpGet("https://raw.githubusercontent.com/STREE-HUB/UI.Libry/Slider.lua"))()
    local Dropdown = loadstring(game:HttpGet("https://raw.githubusercontent.com/STREE-HUB/UI.Libry/Dropdown.lua"))()
    local Textbox = loadstring(game:HttpGet("https://raw.githubusercontent.com/STREE-HUB/UI.Libry/Textbox.lua"))()
    local Keybind = loadstring(game:HttpGet("https://raw.githubusercontent.com/STREE-HUB/UI.Libry/Keybind.lua"))()
    local Label = loadstring(game:HttpGet("https://raw.githubusercontent.com/STREE-HUB/UI.Libry/Label.lua"))()

    local window = self:CreateWindow({
        Title = "STREE HUB - PREMIUM",
        Size = UDim2.new(0, 500, 0, 500)
    })
    
    local mainTab = window:CreateTab("Main")
    local combatTab = window:CreateTab("Combat")
    local settingsTab = window:CreateTab("Settings")

    -- Main Tab
    local welcomeLabel = Label:Create(mainTab.Content, {
        Title = "Welcome to STREE HUB!",
        Description = "Premium access activated • Enjoy your stay!",
        Compact = false
    })

    local testButton = Button:Create(mainTab.Content, {
        Title = "Test Button",
        Description = "Click to test functionality",
        Callback = function()
            print("Button clicked!")
        end
    })

    local testToggle = Toggle:Create(mainTab.Content, {
        Title = "Enable Features",
        Description = "Toggle all features on/off",
        Default = true,
        Callback = function(value)
            print("Features:", value)
        end
    })

    local testSlider = Slider:Create(mainTab.Content, {
        Title = "Walk Speed",
        Min = 16,
        Max = 100,
        Default = 16,
        Rounding = 0,
        Callback = function(value)
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
            end
            print("WalkSpeed:", value)
        end
    })

    -- Combat Tab
    local combatLabel = Label:Create(combatTab.Content, {
        Title = "Combat Features",
        Description = "Various combat enhancements",
        Compact = false
    })

    local aimbotToggle = Toggle:Create(combatTab.Content, {
        Title = "Aimbot",
        Description = "Automatically aim at enemies",
        Default = false,
        Callback = function(value)
            print("Aimbot:", value)
        end
    })

    local triggerbotToggle = Toggle:Create(combatTab.Content, {
        Title = "Triggerbot",
        Description = "Auto-shoot when target is in sight",
        Default = false,
        Callback = fun
