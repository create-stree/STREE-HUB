-- Load WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("WindUI gagal dimuat")
    return
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "Planet",
    Author = "KirsiaSC | Blox Fruit v0.00.01 | discord.gg/jdmX43t5mY",
    Folder = "STREE_HUB",
})

-- Buat Tab
local Tab1 = Window:Tab({
    Title = "Main",
    Icon = "bird",
})

local Tab2 = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local Tab3 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

Tab:Button({
    Title = "Test Button",
    Desc = "Klik ini",
    Callback = function()
        print("Button clicked!")
    end
})

-- === Logo bulat toggle (pojok kanan atas)
local logoGui = Instance.new("ScreenGui")
logoGui.Name = "STREEHUB_Logo"
logoGui.Parent = game:GetService("CoreGui")

local logoBtn = Instance.new("ImageButton")
logoBtn.Parent = logoGui
logoBtn.Size = UDim2.new(0, 60, 0, 60)
logoBtn.Position = UDim2.new(1, -80, 0, 150)
logoBtn.Image = "rbxassetid://101447877507131" -- Ganti ke logo kamu
logoBtn.BackgroundTransparency = 1

local uicorner = Instance.new("UICorner", logoBtn)
uicorner.CornerRadius = UDim.new(1,0)

-- Toggle buka/tutup Window
local isOpen = true
logoBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        if Window.Open then
            Window:Open()
        elseif Window.Show then
            Window:Show()
        else
            print("⚠️ WindUI tidak punya :Open() / :Show()")
        end
    else
        if Window.Close then
            Window:Close()
        elseif Window.Hide then
            Window:Hide()
        else
            print("⚠️ WindUI tidak punya :Close() / :Hide()")
        end
    end
end)
