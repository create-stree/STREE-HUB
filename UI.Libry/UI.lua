-- ====== IMPROVED KEY SYSTEM UI ======
function UI_Libry:ShowKeySystem()
    local window = self:CreateWindow({
        Title = "STREE HUB - PREMIUM ACCESS",
        Size = UDim2.new(0, 500, 0, 600)
    })
    
    local mainTab = window:CreateTab("Verification")
    
    -- Header Section
    local headerFrame = self:CreateElement("Frame", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 80),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = self.Config.Colors.DarkGray,
        BackgroundTransparency = 0.1
    })
    self:RoundedCorner(headerFrame, 10)
    self:NeonStroke(headerFrame, 2, 0.3)

    local logo = self:CreateElement("TextLabel", {
        Parent = headerFrame,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1,
        Text = "🔑",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 30,
        Font = Enum.Font.GothamBold
    })

    local title = self:CreateElement("TextLabel", {
        Parent = headerFrame,
        Size = UDim2.new(1, -80, 0, 30),
        Position = UDim2.new(0, 80, 0, 15),
        BackgroundTransparency = 1,
        Text = "PREMIUM ACCESS REQUIRED",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 18,
        Font = self.Config.Fonts.Header,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local subtitle = self:CreateElement("TextLabel", {
        Parent = headerFrame,
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 80, 0, 40),
        BackgroundTransparency = 1,
        Text = "Enter your license key to continue",
        TextColor3 = self.Config.Colors.White,
        TextSize = 12,
        Font = self.Config.Fonts.Body,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Key Input Section
    local inputFrame = self:CreateElement("Frame", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 120),
        Position = UDim2.new(0, 10, 0, 100),
        BackgroundColor3 = self.Config.Colors.DarkGray,
        BackgroundTransparency = 0.1
    })
    self:RoundedCorner(inputFrame, 10)
    self:NeonStroke(inputFrame, 2, 0.3)

    local keyLabel = self:CreateElement("TextLabel", {
        Parent = inputFrame,
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = "LICENSE KEY",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 14,
        Font = self.Config.Fonts.Header,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local keyInput = self:CreateElement("TextBox", {
        Parent = inputFrame,
        Size = UDim2.new(1, -20, 0, 45),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        TextColor3 = self.Config.Colors.White,
        PlaceholderText = "Enter your license key here...",
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        TextSize = 16,
        Font = self.Config.Fonts.Body,
        ClearTextOnFocus = false,
        Text = ""
    })
    self:RoundedCorner(keyInput, 8)
    self:NeonStroke(keyInput, 2, 0.5)

    local statusLabel = self:CreateElement("TextLabel", {
        Parent = inputFrame,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 85),
        BackgroundTransparency = 1,
        Text = "Status: Waiting for input...",
        TextColor3 = Color3.fromRGB(255, 165, 0),
        TextSize = 12,
        Font = self.Config.Fonts.Body,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Buttons Section
    local buttonsFrame = self:CreateElement("Frame", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 230),
        BackgroundTransparency = 1
    })

    local submitButton = self:CreateElement("TextButton", {
        Parent = buttonsFrame,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Config.Colors.BrightGreen,
        Text = "VERIFY KEY",
        TextColor3 = self.Config.Colors.White,
        TextSize = 14,
        Font = self.Config.Fonts.Header,
        BorderSizePixel = 0
    })
    self:RoundedCorner(submitButton, 8)
    self:NeonStroke(submitButton, 2, 0.5)

    local getKeyButton = self:CreateElement("TextButton", {
        Parent = buttonsFrame,
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0.52, 0, 0, 0),
        BackgroundColor3 = self.Config.Colors.DarkGray,
        Text = "GET KEY",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 14,
        Font = self.Config.Fonts.Header,
        BorderSizePixel = 0
    })
    self:RoundedCorner(getKeyButton, 8)
    self:NeonStroke(getKeyButton, 2, 0.5)

    -- Features Section (Like in your screenshot)
    local featuresFrame = self:CreateElement("Frame", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 200),
        Position = UDim2.new(0, 10, 0, 290),
        BackgroundColor3 = self.Config.Colors.DarkGray,
        BackgroundTransparency = 0.1
    })
    self:RoundedCorner(featuresFrame, 10)
    self:NeonStroke(featuresFrame, 2, 0.3)

    local featuresTitle = self:CreateElement("TextLabel", {
        Parent = featuresFrame,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = "PREMIUM FEATURES",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 16,
        Font = self.Config.Fonts.Header,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Features List
    local features = {
        "🎯 Advanced Aimbot System",
        "⚡ Auto-Farm & Grinding",
        "🛡️ Anti-Ban Protection", 
        "🔧 Custom Script Injector",
        "🎮 ESP & Visual Enhancements",
        "📊 Real-time Statistics",
        "🔄 Auto-Update System",
        "💬 Premium Support"
    }

    for i, feature in ipairs(features) do
        local featureLabel = self:CreateElement("TextLabel", {
            Parent = featuresFrame,
            Size = UDim2.new(0.45, -5, 0, 20),
            Position = UDim2.new((i-1)%2 * 0.5, 10, 0, 45 + math.floor((i-1)/2) * 25),
            BackgroundTransparency = 1,
            Text = feature,
            TextColor3 = self.Config.Colors.White,
            TextSize = 12,
            Font = self.Config.Fonts.Body,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end

    -- Footer
    local footerFrame = self:CreateElement("Frame", {
        Parent = mainTab.Content,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 500),
        BackgroundTransparency = 1
    })

    local discordButton = self:CreateElement("TextButton", {
        Parent = footerFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Config.Colors.DiscordBlue,
        Text = "💬 JOIN OUR DISCORD FOR SUPPORT",
        TextColor3 = self.Config.Colors.White,
        TextSize = 12,
        Font = self.Config.Fonts.Header,
        BorderSizePixel = 0
    })
    self:RoundedCorner(discordButton, 6)

    -- Button Functionality
    local function SubmitKey()
        local key = keyInput.Text:gsub("%s+", ""):upper()
        
        if key == "" then
            statusLabel.Text = "Status: Please enter a license key"
            statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            return
        end
        
        -- Show loading state
        statusLabel.Text = "Status: Verifying key..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitButton.Text = "VERIFYING..."
        
        -- Simulate verification process
        task.wait(1)
        
        if self:IsKeyValid(key) then
            statusLabel.Text = "Status: ✅ Key Verified! Loading premium features..."
            statusLabel.TextColor3 = self.Config.Colors.NeonGreen
            
            TweenService:Create(submitButton, TweenInfo.new(0.5), {
                BackgroundColor3 = self.Config.Colors.NeonGreen
            }):Play()
            
            submitButton.Text = "SUCCESS!"
            
            task.wait(1.5)
            window:Destroy()
            self:ShowMainUI()
        else
            statusLabel.Text = "Status: ❌ Invalid license key"
            statusLabel.TextColor3 = self.Config.Colors.Red
            
            TweenService:Create(submitButton, TweenInfo.new(0.3), {
                BackgroundColor3 = self.Config.Colors.Red
            }):Play()
            submitButton.Text = "INVALID KEY"
            
            task.wait(1)
            TweenService:Create(submitButton, TweenInfo.new(0.3), {
                BackgroundColor3 = self.Config.Colors.BrightGreen
            }):Play()
            submitButton.Text = "VERIFY KEY"
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
        local originalText = discordButton.Text
        discordButton.Text = "✅ DISCORD LINK COPIED!"
        task.wait(1.5)
        discordButton.Text = originalText
    end)

    -- Button hover effects
    self:SetupButtonHover(submitButton, self.Config.Colors.BrightGreen, self.Config.Colors.NeonGreen)
    self:SetupButtonHover(getKeyButton, self.Config.Colors.DarkGray, self.Config.Colors.Gray)
    self:SetupButtonHover(discordButton, self.Config.Colors.DiscordBlue, Color3.fromRGB(114, 137, 218))

    return window
end

function UI_Libry:ShowKeyLinksUI()
    local window = self:CreateWindow({
        Title = "GET PREMIUM ACCESS",
        Size = UDim2.new(0, 500, 0, 500)
    })
    
    local linksTab = window:CreateTab("Key Links")
    
    local header = self:CreateElement("TextLabel", {
        Parent = linksTab.Content,
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = "Complete any link below to get your premium key",
        TextColor3 = self.Config.Colors.NeonGreen,
        TextSize = 16,
        Font = self.Config.Fonts.Header,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    local keyLinks = {
        {"🌟 Rekonise", "https://rkns.link/2vbo0", "Complete short verification"},
        {"🔗 Linkvertise", "https://link-hub.net/1365203/NqhrZrvoQhoi", "Watch advertisement"},
        {"🎁 Lootlabs", "https://lootdest.org/s?VooVvLbJ", "Complete survey"},
        {"⚡ Work.Ink", "https://link-hub.net/1365203/NqhrZrvoQhoi", "Quick verification"}
    }

    for i, linkData in ipairs(keyLinks) do
        local name, url, description = linkData[1], linkData[2], linkData[3]
        
        local linkCard = self:CreateElement("TextButton", {
            Parent = linksTab.Content,
            Size = UDim2.new(1, -20, 0, 70),
            Position = UDim2.new(0, 10, 0, 80 + (i-1)*80),
            BackgroundColor3 = self.Config.Colors.DarkGray,
            Text = "",
            BorderSizePixel = 0
        })
        self:RoundedCorner(linkCard, 10)
        self:NeonStroke(linkCard, 2, 0.5)

        local linkIcon = self:CreateElement("TextLabel", {
            Parent = linkCard,
            Size = UDim2.new(0, 40, 0, 40),
            Position = UDim2.new(0, 15, 0, 15),
            BackgroundTransparency = 1,
            Text = "🔗",
            TextColor3 = self.Config.Colors.NeonGreen,
            TextSize = 20,
            Font = Enum.Font.GothamBold
        })

        local linkTitle = self:CreateElement("TextLabel", {
            Parent = linkCard,
            Size = UDim2.new(1, -80, 0, 25),
            Position = UDim2.new(0, 65, 0, 15),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = self.Config.Colors.White,
            TextSize = 14,
            Font = self.Config.Fonts.Header,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local linkDesc = self:CreateElement("TextLabel", {
            Parent = linkCard,
            Size = UDim2.new(1, -80, 0, 20),
            Position = UDim2.new(0, 65, 0, 35),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 11,
            Font = self.Config.Fonts.Body,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        self:SetupButtonHover(linkCard, self.Config.Colors.DarkGray, self.Config.Colors.Gray)

        linkCard.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(url)
            end
            linkTitle.Text = "✅ " .. name:sub(4)
            linkDesc.Text = "Link copied to clipboard!"
            linkTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            task.wait(2)
            linkTitle.Text = name
            linkDesc.Text = description
            linkTitle.TextColor3 = self.Config.Colors.White
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
        Callback = function(value)
            print("Triggerbot:", value)
        end
    })

    local fovSlider = Slider:Create(combatTab.Content, {
        Title = "Aimbot FOV",
        Min = 1,
        Max = 360,
        Default = 90,
        Rounding = 0,
        Callback = function(value)
            print("FOV:", value)
        end
    })

    -- Settings Tab
    local settingsLabel = Label:Create(settingsTab.Content, {
        Title = "UI Settings",
        Description = "Customize your experience",
        Compact = false
    })

    local themeDropdown = Dropdown:Create(settingsTab.Content, {
        Title = "Theme",
        Description = "Choose UI color theme",
        Options = {"Green", "Blue", "Red", "Purple", "Cyan"},
        Default = "Green",
        Callback = function(value)
            print("Theme:", value)
        end
    })

    local uiKeybind = Keybind:Create(settingsTab.Content, {
        Title = "UI Toggle",
        Description = "Key to show/hide interface",
        Default = "RightShift",
        Callback = function(key)
            print("UI Keybind:", key)
        end,
        PressCallback = function()
            window.MainFrame.Visible = not window.MainFrame.Visible
        end
    })

    local usernameTextbox = Textbox:Create(settingsTab.Content, {
        Title = "Username",
        Description = "Enter your username",
        Placeholder = "PlayerName",
        Default = game.Players.LocalPlayer.Name,
        Callback = function(value)
            print("Username:", value)
        end
    })

    local saveButton = Button:Create(settingsTab.Content, {
        Title = "Save Configuration",
        Description = "Save current settings",
        Callback = function()
            print("Settings saved!")
        end
    })

    return window
end

-- ====== AUTO INITIALIZE ======
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    UI_Libry:ShowKeySystem()
end)

return UI_Libry
