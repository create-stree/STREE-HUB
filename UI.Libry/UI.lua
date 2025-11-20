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
