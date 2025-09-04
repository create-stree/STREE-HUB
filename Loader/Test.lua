-- Load WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI gagal dimuat")
    return
end

-- Buat Window
local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "monitor",
    Author = "KirsiaSC | Blox Fruit v0.00.01 | discord.gg/jdmX43t5mY",
    Folder = "STREE_HUB",
})

-- ===== Tabs =====
local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Tab1:Button({
    Title = "Discord Server",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
            print("✅ Discord link dicopy ke clipboard")
        else
            warn("❌ Executor kamu tidak support setclipboard")
        end
    end
})

local Tab2 = Window:Tab({
    Title = "Game",
    Icon = "gamepad-2",
})

local Tab3 = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local Tab4 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

-- ===== Logo Bulat Toggle (pojok kanan atas) =====
local logoGui = Instance.new("ScreenGui")
logoGui.Name = "STREEHUB_Logo"
logoGui.Parent = game:GetService("CoreGui")

local logoBtn = Instance.new("ImageButton")
logoBtn.Parent = logoGui
logoBtn.Size = UDim2.new(0, 60, 0, 60)
logoBtn.Position = UDim2.new(1, -80, 0, 150)
logoBtn.Image = "rbxassetid://10144787750"
logoBtn.BackgroundTransparency = 1

local uicorner = Instance.new("UICorner", logoBtn)
uicorner.CornerRadius = UDim.new(1, 0)

-- Toggle buka/tutup Window
local isOpen = true
logoBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        if Window.Open then
            Window:Open()
        elseif Window.Show then
            Window:Show()
        elseif Window.Toggle then
            Window:Toggle(true)
        else
            print("⚠️ WindUI tidak punya fungsi Open/Show/Toggle")
        end
    else
        if Window.Close then
            Window:Close()
        elseif Window.Hide then
            Window:Hide()
        elseif Window.Toggle then
            Window:Toggle(false)
        else
            print("⚠️ WindUI tidak punya fungsi Close/Hide/Toggle")
        end
    end
end)
