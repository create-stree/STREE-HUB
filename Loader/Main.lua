-- STREE HUB Orion UI Script (Simplified Toggle Version) 
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

function loadFeature(url, flagName, state) _G[flagName] = state if state then loadstring(game:HttpGet(url))() end end

-- HOME TAB local HomeTab = Window:MakeTab({ Name = "Home", Icon = "rbxassetid://124242667284964", PremiumOnly = false })

local Section = HomeTab:AddSection({ Name = "LINK STREE HUB" })

HomeTab:AddButton({ Name = "Discord", Callback = function() setclipboard("https://discord.gg/jdmX43t5mY") OrionLib:MakeNotification({ Name = "Discord", Content = "Link Discord berhasil disalin!", Image = "rbxassetid://123032091977400", Time = 4 }) end })

HomeTab:AddButton({ Name = "WhatsApp", Callback = function() setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N") OrionLib:MakeNotification({ Name = "WhatsApp", Content = "Link WhatsApp berhasil disalin!", Image = "rbxassetid://123032091977400", Time = 4 }) end })

-- GAME TAB local UniversalTab = Window:MakeTab({ Name = "Game", Icon = "rbxassetid://453473360", PremiumOnly = false })

UniversalTab:AddToggle({ Name = "Noclip", Default = false, Callback = function(Value) loadFeature("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/Noclip.lua", "STREE_NOCLIP", Value) end })

UniversalTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) loadFeature("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/InfiniteJump.lua", "STREE_INFINITEJUMP", Value) end })

-- VISUAL TAB local VisualTab = Window:MakeTab({ Name = "Visual", Icon = "rbxassetid://139410041229101", PremiumOnly = false })

VisualTab:AddToggle({ Name = "ESP Highlight", Default = false, Callback = function(Value) loadFeature("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPhighlight.lua", "STREE_ESP_HIGHLIGHT", Value) end })

VisualTab:AddToggle({ Name = "ESP NameTag", Default = false, Callback = function(Value) loadFeature("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPnametag.lua", "STREE_ESP_NAMETAG", Value) end })

VisualTab:AddToggle({ Name = "ESP Line Tracer", Default = false, Callback = function(Value) loadFeature("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPlinetracer.lua", "STREE_ESP_LINETRACER", Value) end })

VisualTab:AddToggle({ Name = "ESP Box", Default = false, Callback = function(Value) loadFeature("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/ESPbox.lua", "STREE_ESP_BOX", Value) end })

-- SETTINGS TAB local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://139410041229101", PremiumOnly = false })

local SettingsSection = SettingsTab:AddSection({ Name = "Players" })

SettingsTab:AddToggle({ Name = "Anti-AFK", Default = false, Callback = function(Value) loadFeature("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/refs/heads/main/AntiAFK.lua", "STREE_ANTIAFK", Value) end })

-- INIT OrionLib:Init()
