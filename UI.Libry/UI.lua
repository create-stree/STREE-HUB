local UI_Libry = {}

function UI_Libry:CreateWindow(options)
    -- Function untuk membuat window UI
end

function UI_Libry:ShowKeySystem()
    -- Buat window sederhana untuk key system
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "STREE HUB - KEY SYSTEM"
    title.TextScaled = true
    title.Parent = frame
    
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -20, 0, 40)
    description.Position = UDim2.new(0, 10, 0, 60)
    description.BackgroundTransparency = 1
    description.TextColor3 = Color3.fromRGB(200, 200, 200)
    description.Text = "Enter your premium key below:"
    description.TextScaled = true
    description.Parent = frame
    
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, -40, 0, 40)
    keyBox.Position = UDim2.new(0, 20, 0, 110)
    keyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.PlaceholderText = "Enter key here..."
    keyBox.Text = ""
    keyBox.Parent = frame
    
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(1, -40, 0, 40)
    submitButton.Position = UDim2.new(0, 20, 0, 170)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "SUBMIT KEY"
    submitButton.TextScaled = true
    submitButton.Parent = frame
    
    submitButton.MouseButton1Click:Connect(function()
        local key = keyBox.Text
        if key == "PREMIUM123" or key == "STREEHUB2024" then -- Ganti dengan key valid
            screenGui:Destroy()
            self:ShowMainUI()
        else
            keyBox.Text = ""
            keyBox.PlaceholderText = "Invalid key! Try again..."
        end
    end)
end

function UI_Libry:ShowMainUI()
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

task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    UI_Libry:ShowKeySystem()
end)

return UI_Libry
