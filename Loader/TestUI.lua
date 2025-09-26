local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Neon Green", 
    Accent = "#39ff14",
    Dialog = "#1a1a1a",
    Outline = "#39ff14",
    Text = "#39ff14",
    Placeholder = "#00cc00",
    Background = "#0d0d0d",
    Button = "#262626",
    Icon = "#39ff14",
})

WindUI:SetNotificationLower(true)

local themes = {"Neon Green"}
local currentThemeIndex = 1

getgenv().TransparencyEnabled = true

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://123032091977400", 
    Author = "KirsiaSC | Plants vs Brainrot",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
        end,
    },
})
