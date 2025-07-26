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
local HomeTab = Window:MakeTab({ Name = "Home", Icon = "rbxassetid://124242667284964", PremiumOnly = false })
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
local UniversalTab = Window:MakeTab({ Name = "Game", Icon = "rbxassetid://453473360", PremiumOnly = false })
UniversalTab:AddSection({ Name = "Gameplay" })

-- Toggle template
local function createToggle(tab, name, globalVar, scriptURL)
    tab:AddToggle({
        Name = name,
        Default = false,
        Callback = function(Value)
            _G[globalVar] = Value
            if Value then
                loadstring(game:HttpGet(scriptURL))()
            else
                OrionLib:MakeNotification({
                    Name = "STREE HUB",
                    Content = name .. " dimatikan!",
                    Image = "rbxassetid://123032091977400",
                    Time = 3
                })
            end
        end
    })
end

-- Gameplay Features
createToggle(UniversalTab, "Noclip", "STREE_NOCLIP", "https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Noclip.lua")
createToggle(UniversalTab, "Infinite Jump", "STREE_INFINITEJUMP", "https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/InfiniteJump.lua")

-- VISUAL TAB
local VisualTab = Window:MakeTab({ Name = "Visual", Icon = "rbxassetid://139410041229101", PremiumOnly = false })
VisualTab:AddSection({ Name = "ESP" })

createToggle(VisualTab, "ESP Highlight", "STREE_ESP_HIGHLIGHT", "https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPhighlight.lua")
createToggle(VisualTab, "ESP NameTag", "STREE_ESP_NAMETAG", "https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPnametag.lua")
createToggle(VisualTab, "ESP Line Tracer", "STREE_ESP_LINETRACER", "https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPlinetracer.lua")
createToggle(VisualTab, "ESP Box", "STREE_ESP_BOX", "https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/ESPbox.lua")

VisualTab:AddSection({ Name = "Others" })
createToggle(VisualTab, "Cooldown Base", "STREE_COOLDOWN_BASE", "https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Cooldown%20base.lua")

-- SETTINGS TAB
local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://139410041229101", PremiumOnly = false })
SettingsTab:AddSection({ Name = "Others" })

createToggle(SettingsTab, "Anti AFK", "STREE_ANTI_AFK", "https://obj.wearedevs.net/175531/scripts/Anti%20Afk%20Kick%20Script.lua")
createToggle(SettingsTab, "Explorer", "STREE_EXPLORER", "https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua")

-- FINAL INIT
OrionLib:Init()
