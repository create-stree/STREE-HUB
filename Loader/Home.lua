local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({ Name = "STREE HUB | Steal A Brainrot | v0.15.25", HidePremium = true, SaveConfig = true, ConfigFolder = "STREE HUB", Icon = "123032091977400", IntroEnabled = true, IntroText = "Welcome To Script STREE HUB", Theme = "Dark", CloseCallback = function() print("UI Closed!") end })

-- HOME TAB 
local HomeTab = Window:MakeTab({ 
                Name = "Home", 
                Icon = "rbxassetid://124242667284964", 
                PremiumOnly = false 
})

local Section = HomeTab:AddSection({ Name = "LINK STREE HUB" })

HomeTab:AddButton({ Name = "Discord", Callback = function() setclipboard("https://discord.gg/jdmX43t5mY") OrionLib:MakeNotification({ Name = "Discord", Content = "Link Discord berhasil disalin!", Image = "rbxassetid://123032091977400", Time = 4 }) end })

HomeTab:AddButton({ Name = "WhatsApp", Callback = function() setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N") OrionLib:MakeNotification({ Name = "WhatsApp", Content = "Link WhatsApp berhasil disalin!", Image = "rbxassetid://123032091977400", Time = 4 }) end })

-- GAME TAB 
local UniversalTab = Window:MakeTab({ 
                Name = "Game", 
                Icon = "rbxassetid://453473360", 
                PremiumOnly = false 
})

local toggles = { Noclip = false, InfiniteJump = false, ESPHighlight = false, ESPNameTag = false, ESPLineTracer = false, ESPBox = false, AntiAFK = false }

UniversalTab:AddToggle({ Name = "Noclip", Default = false, Callback = function(Value) toggles.Noclip = Value if Value then loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/InfiniteJump.lua"))() else _G.STREE_INFINITEJUMP = false end end })

UniversalTab:AddButton({ Name = "Aktifkan Noclip", Callback = function() toggles.Noclip = true loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/InfiniteJump.lua"))() end })

UniversalTab:AddButton({ Name = "Nonaktifkan Noclip", Callback = function() toggles.Noclip = false _G.STREE_INFINITEJUMP = false end })

UniversalTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) toggles.InfiniteJump = Value if Value then loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/InfiniteJump.lua"))() else _G.STREE_INFINITEJUMP = false end end })

UniversalTab:AddButton({ Name = "Aktifkan Infinite Jump", Callback = function() toggles.InfiniteJump = true loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/InfiniteJump.lua"))() end })

UniversalTab:AddButton({ Name = "Nonaktifkan Infinite Jump", Callback = function() toggles.InfiniteJump = false _G.STREE_INFINITEJUMP = false end })

-- VISUAL TAB 
local VisualTab = Window:MakeTab({ 
                Name = "Visual", 
                Icon = "rbxassetid://139410041229101", 
                PremiumOnly = false 
})

VisualTab:AddToggle({ Name = "ESP Highlight", Default = false, Callback = function(Value) toggles.ESPHighlight = Value loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPhighlight.lua"))() end })

VisualTab:AddButton({ Name = "Aktifkan ESP Highlight", Callback = function() toggles.ESPHighlight = true loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPhighlight.lua"))() end })

VisualTab:AddButton({ Name = "Nonaktifkan ESP Highlight", Callback = function() toggles.ESPHighlight = false end })

VisualTab:AddToggle({ Name = "ESP NameTag", Default = false, Callback = function(Value) toggles.ESPNameTag = Value loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPnametag.lua"))() end })

VisualTab:AddButton({ Name = "Aktifkan ESP NameTag", Callback = function() toggles.ESPNameTag = true loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPnametag.lua"))() end })

VisualTab:AddButton({ Name = "Nonaktifkan ESP NameTag", Callback = function() toggles.ESPNameTag = false end })

VisualTab:AddToggle({ Name = "ESP Line Tracer", Default = false, Callback = function(Value) toggles.ESPLineTracer = Value loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPlinetracer.lua"))() end })

VisualTab:AddButton({ Name = "Aktifkan ESP Line Tracer", Callback = function() toggles.ESPLineTracer = true loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPlinetracer.lua"))() end })

VisualTab:AddButton({ Name = "Nonaktifkan ESP Line Tracer", Callback = function() toggles.ESPLineTracer = false end })

VisualTab:AddToggle({ Name = "ESP Box", Default = false, Callback = function(Value) toggles.ESPBox = Value loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPbox.lua"))() end })

VisualTab:AddButton({ Name = "Aktifkan ESP Box", Callback = function() toggles.ESPBox = true loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPbox.lua"))() end })

VisualTab:AddButton({ Name = "Nonaktifkan ESP Box", Callback = function() toggles.ESPBox = false end })

local SettingsTab = Window:MakeTab({ 
        Name = "Settings", 
        Icon = "rbxassetid://139410041229101", 
        PremiumOnly = false 
})

local PlayerSection = SettingsTab:AddSection({ Name = "Players" })

SettingsTab:AddToggle({ 
        Name = "Anti-AFK", 
        Default = false, 
        Callback = function(Value) 
            toggles.AntiAFK = Value 
            if Value then 
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/AntiAFK.lua"))() 
            else _G.STREE_ANTIAFK = false 
          end 
    end 
})

SettingsTab:AddButton({ 
        Name = "Aktifkan Anti-AFK", 
        Callback = function() 
            toggles.AntiAFK = true 
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/AntiAFK.lua"))() 
     end 
})

SettingsTab:AddButton({ 
    Name = "Nonaktifkan Anti-AFK", 
    Callback = function() 
        toggles.AntiAFK = false 
        _G.STREE_ANTIAFK = false 
    end 
})

-- JANGAN HAPUS INIT 
OrionLib:Init()
