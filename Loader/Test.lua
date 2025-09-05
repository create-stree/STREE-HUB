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
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Green"
    SideBarWidth = 170,
    HasOutline = true
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
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
            print("✅ Discord link dicopy ke clipboard")
        else
            warn("❌ Executor kamu tidak support setclipboard")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
            print("✅ WhatsApp link dicopy ke clipboard")
        else
            warn("❌ Executor kamu tidak support setclipboard")
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
            print("✅ Telegram link dicopy ke clipboard")
        else
            warn("❌ Executor kamu tidak support setclipboard")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app")
            print("✅ Website link dicopy ke clipboard")
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
    Title = "Teleport",
    Icon = "telescope",
})

local Tab6 = Window:Tab({
    Title = "PVP",
    Icon = "swords",
})

local Tab7 = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local Tab8 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local Tab9 = Window:Tab({
    Title = "Misc",
    Icon = "list",
})
