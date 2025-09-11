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
    Author = "KirsiaSC | Blox Fruit | v0.00.01",
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

local Section = Tab1:Section({ 
    Title = "I will update this script. Sorry if there are any blank tabs because we are still updating.",
    TextXAlignment = "Left",
    TextSize = 17,
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
    Title = "Teleport Sea",
    Icon = "telescope",
})

local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local Seas = {
    First = 2753915549,
    Second = 4442272183,
    Third = 7449423635,
}

local function teleportToSea(placeId, seaName)
    local notification = Tab5:Notification({
        Title = "🌊 Teleportasi",
        Description = "Sedang membawa Anda ke " .. seaName .. "...",
        Duration = 3
    })

    task.wait(1.5)

    local success, errorMsg = pcall(function()
        TeleportService:Teleport(placeId, LocalPlayer)
    end)
    
    if not success then
        Tab5:Notification({
            Title = "❌ Gagal Teleport",
            Description = "Error: " .. errorMsg,
            Duration = 5
        })
    end
end

Tab5:Button({
    Title = "🌊 Pergi ke First Sea",
    Description = "Teleport ke First Sea",
    Callback = function()
        teleportToSea(Seas.First, "First Sea")
    end
})

Tab5:Button({
    Title = "🌊 Pergi ke Second Sea",
    Description = "Teleport ke Second Sea",
    Callback = function()
        teleportToSea(Seas.Second, "Second Sea")
    end
})

Tab5:Button({
    Title = "🌊 Pergi ke Third Sea",
    Description = "Teleport ke Third Sea",
    Callback = function()
        teleportToSea(Seas.Third, "Third Sea")
    end
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

local Section = Tab9:Section({ 
    Title = "games that are still active or frequently change logs",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Section = Tab9:Section({ 
    Title = "Game Status :",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Section = Tab9:Section({ 
    Title = "Blox Fruit : 🟢",
    TextXAlignment = "Left",
    TextSize = 17,
})


myConfig:Load()
