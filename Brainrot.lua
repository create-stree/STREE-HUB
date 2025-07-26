local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "STREE HUB | Steal A Brainrot | v0.00.01",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "STREE HUB",
    Icon = "123032091977400",
    IntroEnabled = true,
    IntroText = "Welcome To Script STREE HUB",
    Theme = "Dark",
    CloseCallback = function()
        print("UI Closed!")
    end
})

-- HOME TAB
local HomeTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://124242667284964",
    PremiumOnly = false
})

local Section = HomeTab:AddSection({ Name = "LINK STREE HUB" })

HomeTab:AddButton({
    Name = "Discord",
    Callback = function()
        setclipboard("https://discord.gg/jdmX43t5mY")
        OrionLib:MakeNotification({
            Name = "Discord",
            Content = "Link Discord berhasil disalin!",
            Image = "rbxassetid://123032091977400",
            Time = 4
        })
    end
})

HomeTab:AddButton({
    Name = "WhatsApp",
    Callback = function()
        setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        OrionLib:MakeNotification({
            Name = "WhatsApp",
            Content = "Link WhatsApp berhasil disalin!",
            Image = "rbxassetid://123032091977400",
            Time = 4
        })
    end
})

-- GAME TAB
local UniversalTab = Window:MakeTab({
    Name = "Game",
    Icon = "rbxassetid://453473360",
    PremiumOnly = false
})

UniversalTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        _G.STREE_NOCLIP = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/Noclip.lua"))()
        else
            _G.STREE_NOCLIP = false
        end
    end
})

UniversalTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.STREE_INFINITEJUMP = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/InfiniteJump.lua"))()
        else
            _G.STREE_INFINITEJUMP = false
        end
    end
})

-- VISUAL TAB
local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://139410041229101",
    PremiumOnly = false
})

VisualTab:AddToggle({
    Name = "ESP Highlight",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_HIGHLIGHT = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPhighlight.lua"))()
        else
            _G.STREE_ESP_HIGHLIGHT = false
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP NameTag",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_NAMETAG = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPnametag.lua"))()
        else
            _G.STREE_ESP_NAMETAG = false
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP Line Tracer",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_LINETRACER = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPlinetracer.lua"))()
        else
            _G.STREE_ESP_LINETRACER = false
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP Box",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_BOX = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPbox.lua"))()
        else
            _G.STREE_ESP_BOX = false
        end
    end
})

-- SETTINGS TAB
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://139410041229101",
    PremiumOnly = false
})

-- INIT WAJIB
OrionLib:Init()
