local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ Windows gagal dimuat!")
    return
else
    print("✓ WindUI berhasil dimuat!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "monitor",
    Author = "KirsiaSC | Blox Fruit v0.00.01 | discord.gg/jdmX43t5mY",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

local Section = Tab1:Section({ 
    Title = "Info community",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Button({
    Title = "Discord",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app")
        end
    end
})

local Section = Tab1:Section({ 
    Title = "Information",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Paragraph = Tab:Paragraph({
    Title = "Paragraph with Image, Thumbnail, Buttons",
    Desc = "Test Paragraph",
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
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


myConfig:Load()
