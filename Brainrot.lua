local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "STREE HUB | Steal A Brainrot | v0.00.01",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "STREE HUB",
    Icon = "rbxassetid://123032091977400",
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

HomeTab:AddSection({ Name = "LINK STREE HUB" })

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

UniversalTab:AddSection({ Name = "Gameplay" })

local NoclipConn
UniversalTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Noclip.lua"))()
        else
            if NoclipConn then NoclipConn:Disconnect() end
            OrionLib:MakeNotification({
                Name = "Noclip",
                Content = "Noclip dimatikan!",
                Image = "rbxassetid://123032091977400",
                Time = 4
            })
        end
    end
})

UniversalTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.STREE_INFINITEJUMP = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/InfiniteJump.lua"))()
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

VisualTab:AddSection({ Name = "ESP" })

VisualTab:AddToggle({
    Name = "ESP Highlight",
    Default = false,
    Callback = function(Value)
        _G.STREE_ESP_HIGHLIGHT = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPhighlight.lua"))()
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
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPnametag.lua"))()
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
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPlinetracer.lua"))()
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
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPbox.lua"))()
        else
            _G.STREE_ESP_BOX = false
        end
    end
})

VisualTab:AddSection({ Name = "Others" })

VisualTab:AddToggle({
    Name = "Cooldown Base",
    Default = false,
    Callback = function(Value)
        _G.STREE_COOLDOWN_BASE = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Cooldown%20base.lua"))()
        else
            _G.STREE_COOLDOWN_BASE = false
        end
    end
})

-- SETTINGS TAB
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://139410041229101",
    PremiumOnly = false
})

SettingsTab:AddSection({ Name = "PlayerStats" })

SettingsTab:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Callback = function(Value)
        _G.STREE_ANTILAG = Value
        if Value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/Antilag.lua"))()
        else
            _G.STREE_ANTILAG = false
            OrionLib:MakeNotification({
                Name = "Anti Lag",
                Content = "Restart game untuk mengembalikan efek visual.",
                Image = "rbxassetid://123032091977400",
                Time = 5
            })
        end
    end
})

SettingsTab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(Value)
        ToggleAntiAFK(Value)
        OrionLib:MakeNotification({
            Name = "Anti AFK",
            Content = Value and "Anti AFK Aktif!" or "Anti AFK Dimatikan!",
            Image = "rbxassetid://123032091977400",
            Time = 4
        })
    end
})

SettingsTab:AddSection({ Name = "Other Script" })

SettingsTab:AddButton({
    Name = "Inf yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- WAJIB INISIALISASI
OrionLib:Init()
