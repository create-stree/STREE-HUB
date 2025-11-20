-- Complete Usage Example
local BlackNeonUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/main.lua"))()
local Tabs = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/tabs.lua"))()
local Button = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/elements/button.lua"))()
local Toggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/elements/toggle.lua"))()
local Slider = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/elements/slider.lua"))()
local Dropdown = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/elements/dropdown.lua"))()
local Textbox = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/elements/textbox.lua"))()
local Keybind = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/elements/keybind.lua"))()
local Label = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/elements/label.lua"))()

-- Create tabs
local mainTab = Tabs:CreateTab(BlackNeonUI, "Main")
local combatTab = Tabs:CreateTab(BlackNeonUI, "Combat")
local settingsTab = Tabs:CreateTab(BlackNeonUI, "Settings")

-- Main Tab Elements
local welcomeLabel = Label:Create(mainTab.Frame, {
    Title = "Welcome to Black Neon UI",
    Description = "A sleek dark UI with neon green accents",
    Compact = false
})

local testButton = Button:Create(mainTab.Frame, {
    Title = "Test Button",
    Description = "Click to test functionality",
    Callback = function()
        print("Button clicked!")
    end
})

local testToggle = Toggle:Create(mainTab.Frame, {
    Title = "Enable Features",
    Description = "Toggle all features on/off",
    Default = true,
    Callback = function(value)
        print("Features:", value)
    end
})

local testSlider = Slider:Create(mainTab.Frame, {
    Title = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Rounding = 0,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        print("WalkSpeed:", value)
    end
})

-- Combat Tab Elements
local combatLabel = Label:Create(combatTab.Frame, {
    Title = "Combat Features",
    Description = "Various combat enhancements",
    Compact = false
})

local aimbotToggle = Toggle:Create(combatTab.Frame, {
    Title = "Aimbot",
    Description = "Automatically aim at enemies",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value)
    end
})

local triggerbotToggle = Toggle:Create(combatTab.Frame, {
    Title = "Triggerbot",
    Description = "Auto-shoot when target is in sight",
    Default = false,
    Callback = function(value)
        print("Triggerbot:", value)
    end
})

local fovSlider = Slider:Create(combatTab.Frame, {
    Title = "Aimbot FOV",
    Min = 1,
    Max = 360,
    Default = 90,
    Rounding = 0,
    Callback = function(value)
        print("FOV:", value)
    end
})

-- Settings Tab Elements
local settingsLabel = Label:Create(settingsTab.Frame, {
    Title = "UI Settings",
    Description = "Customize your experience",
    Compact = false
})

local themeDropdown = Dropdown:Create(settingsTab.Frame, {
    Title = "Theme",
    Description = "Choose UI color theme",
    Options = {"Green", "Blue", "Red", "Purple", "Cyan"},
    Default = "Green",
    Callback = function(value)
        print("Theme:", value)
    end
})

local uiKeybind = Keybind:Create(settingsTab.Frame, {
    Title = "UI Toggle",
    Description = "Key to show/hide interface",
    Default = "RightShift",
    Callback = function(key)
        print("UI Keybind:", key)
    end,
    PressCallback = function()
        BlackNeonUI.MainFrame.Visible = not BlackNeonUI.MainFrame.Visible
    end
})

local usernameTextbox = Textbox:Create(settingsTab.Frame, {
    Title = "Username",
    Description = "Enter your username",
    Placeholder = "PlayerName",
    Default = game.Players.LocalPlayer.Name,
    Callback = function(value)
        print("Username:", value)
    end
})

local saveButton = Button:Create(settingsTab.Frame, {
    Title = "Save Configuration",
    Description = "Save current settings",
    Callback = function()
        print("Settings saved!")
    end
})

print("Black Neon UI Loaded Successfully!")
