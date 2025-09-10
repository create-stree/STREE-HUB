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
    Title = "Teleport",
    Icon = "telescope",
})

local function teleportToSea(sea)
    local Player = game.Players.LocalPlayer
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = Player.Character.HumanoidRootPart

    if sea == 1 then

        HRP.CFrame = CFrame.new(973, 125, 3325)
    elseif sea == 2 then

        HRP.CFrame = CFrame.new(-266, 8, 5314)
    elseif sea == 3 then

        HRP.CFrame = CFrame.new(-5076, 315, -3150)
    end
end

Tab5:Button({
    Title = "Go to First Sea",
    Description = "Teleport langsung ke First Sea",
    Callback = function()
        teleportToSea(1)
    end
})

Tab5:Button({
    Title = "Go to Second Sea",
    Description = "Teleport langsung ke Second Sea",
    Callback = function()
        teleportToSea(2)
    end
})

Tab5:Button({
    Title = "Go to Third Sea",
    Description = "Teleport langsung ke Third Sea",
    Callback = function()
        teleportToSea(3)
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


myConfig:Load()
