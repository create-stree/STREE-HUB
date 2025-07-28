local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "STREE HUB | Steal A Brainrot | v0.00.04",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "STREE HUB",
    Icon = "rbxassetid://123032091977400",
    IntroEnabled = true,
    IntroText = "Welcome To Script STREE HUB",
    Theme = "Green",
    CloseCallback = function()
        print("UI Closed!")
    end
})

-- Home Tab
local HomeTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://124242667284964",
    PremiumOnly = false
})

HomeTab:AddSection({ Name = "LINK STREE HUB" })

HomeTab:AddButton({
    Name = "Discord",
    Callback = function()
        setclipboard("https://discord.gg/jdmX43t5mY")
        OrionLib:MakeNotification({
            Name = "Copied!",
            Content = "Link Discord disalin ke clipboard.",
            Time = 4
        })
    end
})

HomeTab:AddButton({
    Name = "WhatsApp",
    Callback = function()
        setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        OrionLib:MakeNotification({
            Name = "Copied!",
            Content = "Link WhatsApp disalin ke clipboard.",
            Time = 4
        })
    end
})

HomeTab:AddSection({ Name = "Website" })

HomeTab:AddButton({
    Name = "Website",
    Callback = function()
        setclipboard("https://streehub.netlify.app")
        OrionLib:MakeNotification({
            Name = "Copied!",
            Content = "Link Website disalin ke clipboard.",
            Time = 4
        })
    end
})


-- Game Tab
local GameTab = Window:MakeTab({
    Name = "Game",
    Icon = "rbxassetid://453473360",
    PremiumOnly = false
})

GameTab:AddSection({ Name = "Main" })

GameTab:AddToggle({
    Name = "Noclip [Bypass]",
    Default = false,
    Callback = function(Value)
        _G.STREE_NOCLIP = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Noclip.lua"))()
        end
    end
})

GameTab:AddToggle({
    Name = "Infinite Jump [Bypass]",
    Default = false,
    Callback = function(Value)
        _G.STREE_INFINITE_JUMP = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/InfiniteJump.lua"))()
        end
    end
})

GameTab:AddToggle({
    Name = "Anti Stun",
    Default = false,
    Callback = function(Value)
        _G.STREE_ANTISTUN = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/AntiStun.lua"))()
        end
    end
})

-- Visual Tab
local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://1137375831",
    PremiumOnly = false
})

VisualTab:AddSection({ Name = "ESP" })

VisualTab:AddToggle({
    Name = "ESP Highlight",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_HIGHLIGHT = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPhighlight.lua"))()
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP Tracer",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_TRACER = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPlinetracer.lua"))()
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP Name",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_NAME = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPnametag.lua"))()
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP Box",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_BOX = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPbox.lua"))()
        end
    end
})

VisualTab:AddSection({ Name = "Base" })

VisualTab:AddToggle({
    Name = "Cooldown Base",
    Default = false,
    Callback = function(Value)
        _G.STREE_COOLDOWN_BASE = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Cooldown_Base.lua"))()
        end
    end
})

-- Settings Tab
local SettingTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://113924094978555",
    PremiumOnly = false
})

SettingTab:AddSection({ Name = "Players" })

SettingTab:AddToggle({
    Name = "Anti lag",
    Default = false,
    Callback = function(Value)
        _G.STREE_ANTILAG = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Antilag.lua"))()
        end
    end
})

SettingTab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(Value)
        _G.STREE_ANTIAFK = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/AntiAFK.lua"))()
        end
    end
})

SettingTab:AddSection({ Name = "Other Script" })

SettingTab:AddButton({
    Name = "Inf Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

OrionLib:Init()
