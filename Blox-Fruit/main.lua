local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Blox Fruit",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Freemium",
    Color = Color3.fromRGB(138, 43, 226),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info",
})

Tab1:Section({
    Title = "Community Support",
    Icon = "chevrons-left-right-ellipsis",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Divider()

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Divider()

Tab1:Section({
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Divider()

Tab1:Keybind({
    Title = "Close/Open UI",
    Desc = "Keybind to Close/Open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
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

local Seas = {
    First = 2753915549,
    Second = 4442272183,
    Third = 7449423635,
}

Tab5:Button({
    Title = "🌊 Go to First Sea",
    Description = "Teleport ke First Sea",
    Callback = function()
        TeleportService:Teleport(Seas.First, LocalPlayer)
    end
})

Tab5:Button({
    Title = "🌊 Go to Second Sea",
    Description = "Teleport ke Second Sea",
    Callback = function()
        TeleportService:Teleport(Seas.Second, LocalPlayer)
    end
})

Tab5:Button({
    Title = "🌊 Go to Third Sea",
    Description = "Teleport ke Third Sea",
    Callback = function()
        TeleportService:Teleport(Seas.Third, LocalPlayer)
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
