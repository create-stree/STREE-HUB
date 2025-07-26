local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "STREE HUB | Steal A Brainrot | v0.00.01",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "STREE HUB",
    Icon = "rbxassetid://123032091977400",
    IntroEnabled = true,
    IntroText = "Welcome To Script STREE HUB",
    Theme = "Dark"
})

-- Global Table untuk simpan koneksi dan state
local Connections = {}

-- FUNGSI GENERAL UNTUK TOGGLE SCRIPT
local function toggleScript(flag, enableFunc, disableFunc)
    if _G[flag] then
        if enableFunc then enableFunc() end
    else
        if disableFunc then disableFunc() end
    end
end

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

-- GAME TAB
local GameTab = Window:MakeTab({
    Name = "Game",
    Icon = "rbxassetid://453473360",
    PremiumOnly = false
})

-- Infinite Jump
GameTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.STREE_INFINITEJUMP = Value
        toggleScript("STREE_INFINITEJUMP",
            function() -- Enable
                Connections.InfiniteJump = game:GetService("UserInputService").JumpRequest:Connect(function()
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end)
            end,
            function() -- Disable
                if Connections.InfiniteJump then
                    Connections.InfiniteJump:Disconnect()
                    Connections.InfiniteJump = nil
                end
            end
        )
    end
})

-- Noclip
GameTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        _G.STREE_NOCLIP = Value
        toggleScript("STREE_NOCLIP",
            function()
                Connections.Noclip = game:GetService("RunService").Stepped:Connect(function()
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end)
            end,
            function()
                if Connections.Noclip then
                    Connections.Noclip:Disconnect()
                    Connections.Noclip = nil
                end
            end
        )
    end
})

-- SETTINGS TAB
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://139410041229101",
    PremiumOnly = false
})

SettingsTab:AddSection({ Name = "System Settings" })

-- Anti-AFK
SettingsTab:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(Value)
        _G.STREE_ANTIAFK = Value
        toggleScript("STREE_ANTIAFK",
            function()
                Connections.AntiAFK = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                    game.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                end)
            end,
            function()
                if Connections.AntiAFK then
                    Connections.AntiAFK:Disconnect()
                    Connections.AntiAFK = nil
                end
            end
        )
    end
})

-- Anti-Lag
SettingsTab:AddToggle({
    Name = "Anti-Lag (FPS Boost)",
    Default = false,
    Callback = function(Value)
        _G.STREE_ANTILAG = Value
        toggleScript("STREE_ANTILAG",
            function()
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("Decal") or v:IsA("Texture") then
                        v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        v.Enabled = false
                    elseif v:IsA("Explosion") then
                        v:Destroy()
                    end
                end

                local Lighting = game:GetService("Lighting")
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 1e10
                Lighting.Brightness = 0
            end,
            function()
                -- Tidak dikembalikan secara otomatis karena bersifat satu arah
                OrionLib:MakeNotification({
                    Name = "Anti-Lag Dimatikan",
                    Content = "Efek tidak otomatis dikembalikan.",
                    Image = "rbxassetid://123032091977400",
                    Time = 4
                })
            end
        )
    end
})

OrionLib:Init()
