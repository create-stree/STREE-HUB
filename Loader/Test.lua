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
    Title = "Main",
    Icon = "gamepad-2",
})

local Tab3 = Window:Tab({
    Title = "Raid",
    Icon = "shield",
})

local Tab4 = Window:Tab({
    Title = "Shop",
    Icon = "landmark",
})

local Tab5 = Window:Tab({
    Title = "PVP",
    Icon = "swords",
})

local Tab6 = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local Tab7 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local Tab8 = Window:Tab({
    Title = "Misc",
    Icon = "settings",
})
