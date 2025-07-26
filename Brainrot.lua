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

-- Infinite Jump
local InfiniteJumpConn
UniversalTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        if Value then
            InfiniteJumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if humanoid then humanoid:ChangeState("Jumping") end
            end)
        else
            if InfiniteJumpConn then InfiniteJumpConn:Disconnect() InfiniteJumpConn = nil end
        end
    end
})

-- Noclip
local NoclipConn
UniversalTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        if Value then
            NoclipConn = game:GetService("RunService").Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if NoclipConn then NoclipConn:Disconnect() NoclipConn = nil end
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

-- ESP Highlight
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

-- ESP NameTag
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

-- ESP Line Tracer
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

-- ESP Box
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

-- Cooldown Base
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

SettingsTab:AddSection({ Name = "Others" })

-- Anti AFK
local AntiAFKConn
SettingsTab:AddToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(Value)
        if Value then
            AntiAFKConn = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        else
            if AntiAFKConn then AntiAFKConn:Disconnect() AntiAFKConn = nil end
        end
    end
})

-- Explorer (Dex)
SettingsTab:AddToggle({
    Name = "Explorer (Dex)",
    Default = false,
    Callback = function(Value)
        if Value then
            loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Dex%20Explorer.lua"))()
        else
            local dex = game.CoreGui:FindFirstChild("Dex")
            if dex then
                dex.Enabled = false
            end
        end
    end
})

SettingsTab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        OrionLib:Destroy()
        OrionLib:MakeNotification({
            Name = "STREE HUB",
            Content = "GUI berhasil dihancurkan!",
            Image = "rbxassetid://123032091977400",
            Time = 3
        })
    end
})

-- Toggle GUI ON/OFF dengan RightShift
local UIS = game:GetService("UserInputService")
local guiVisible = true

UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        guiVisible = not guiVisible
        for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
            if v:IsA("ScreenGui") and v.Name:find("Orion") then
                v.Enabled = guiVisible
            end
        end
    end
end)

-- WAJIB
OrionLib:Init()
