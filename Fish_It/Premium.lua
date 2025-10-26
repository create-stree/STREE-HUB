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
    Author = "KirsiaSC | Fish It",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },
})

Window:Tag({
    Title = "v0.0.0.5",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Premium",
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
    TextXAlignment = "Left",
    TextSize = 17,
})

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

Tab1:Button({
    Title = "Telegram",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app/")
        end
    end
})

Tab1:Section({
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

_G.CustomJumpPower = 50

Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = false,
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input)
        local speed = tonumber(input)
        if speed and speed >= 16 then
            Humanoid.WalkSpeed = speed
            print("WalkSpeed set to: " .. speed)
        else
            Humanoid.WalkSpeed = 16
            print("⚠️ Invalid input, set to default (16)")
        end
    end
})

Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = false,
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input)
        local value = tonumber(input)
        if value and value >= 50 then
            _G.CustomJumpPower = value
            local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = value
            end
            print("Jump Power set to: " .. value)
        else
            warn("⚠️ Must be number and minimum 50!")
        end
    end
})

Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "Return Jump Power to normal (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
        print("🔄 Jump Power reset to 50")
    end
})

Player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.UseJumpPower = true
    humanoid.JumpPower = _G.CustomJumpPower or 50
end)

Tab2:Button({
    Title = "Reset Speed",
    Desc = "Return speed to normal (16)",
    Callback = function()
        Humanoid.WalkSpeed = 16
        print("WalkSpeed reset to default (16)")
    end
})

local UserInputService = game:GetService("UserInputService")

Tab2:Toggle({
    Title = "Infinite Jump",
    Desc = "activate to use infinite jump",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
        if state then
            print("✅ Infinite Jump Active")
        else
            print("❌ Infinite Jump Inactive")
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local character = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab2:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        task.spawn(function()
            local Player = game:GetService("Players").LocalPlayer
            while _G.Noclip do
                task.wait(0.1)
                if Player.Character then
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
})

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

Tab3:Section({
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab3:Toggle({
    Title = "Auto Equip Rod",
    Desc = "Selalu equip pancing otomatis",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(value)
        _G.AutoEquipRod = value
    end
})

local player = game.Players.LocalPlayer

spawn(function()
    while task.wait(1) do
        if _G.AutoEquipRod then
            pcall(function()
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    local rod = backpack:FindFirstChild("Rod") or backpack:FindFirstChild("FishingRod") or backpack:FindFirstChild("OldRod") or backpack:FindFirstChild("BasicRod")
                    if rod and not player.Character:FindFirstChild(rod.Name) then
                        player.Character.Humanoid:EquipTool(rod)
                    end
                end
            end)
        end
    end
end)

Tab3:Toggle({
    Title = "Auto Fishing",
    Desc = "Automatic Auto Fishing v1",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(value)
        _G.AutoFishing = value
    end
})

local RepStorage = game:GetService("ReplicatedStorage")

spawn(function()
    while wait() do
        if _G.AutoFishing then
            repeat
                pcall(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    if char:FindFirstChild("!!!FISHING_VIEW_MODEL!!!") then
                        RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]:FireServer(1)
                    end
                    local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
                    if cosmeticFolder and not cosmeticFolder:FindFirstChild(tostring(player.UserId)) then
                        RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]:InvokeServer(2)
                        wait(0.5)
                        RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]:InvokeServer(1,1)
                    end
                end)
                wait(0.2)
            until not _G.AutoFishing
        end
    end
end)

spawn(function()
    while wait() do
        if _G.AutoFishing then
            repeat
                pcall(function()
                    RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]:FireServer()
                end)
                wait(0.2)
            until not _G.AutoFishing
        end
    end
end)

local RunService = game:GetService("RunService")    
local Workspace = game:GetService("Workspace")    
local VirtualInputManager = game:GetService("VirtualInputManager")    
local ReplicatedStorage = game:GetService("ReplicatedStorage")    
local camera = Workspace.CurrentCamera    
    
local REEquipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]    
local REFishingCompleted = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]

local autoHoldEnabled = false
Tab3:Toggle({
    Title = "Auto Fishing",
    Desc = "Automatic Fishing v2",
    Value = false,
    Callback = function(state)
        autoHoldEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Fishing V2",
                Content = "Enabled",
                Duration = 3
            })
            task.spawn(function()
                local holdDuration = 0.4
                local loopDelay = 0.2
                while autoHoldEnabled do
                    pcall(function()
                        REEquipToolFromHotbar:FireServer(1)
                        local clickX = 5
                        local clickY = camera.ViewportSize.Y - 5
                        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                        task.wait(holdDuration)
                        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                    end)
                    task.wait(loopDelay)
                    RunService.Heartbeat:Wait()
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Fishing V2",
                Content = "Disabled",
                Duration = 3
            })
        end
    end
})

local player = game.Players.LocalPlayer
local RepStorage = game:GetService("ReplicatedStorage")
local net = RepStorage.Packages._Index["sleitnick_net@0.2.0"].net

_G.AutoFishing = false
_G.Delay = 0
_G.MaxSpeed = true

Tab3:Toggle({
    Title = "Auto Instant Fishing",
    Desc = "Automic Instant Fishing",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(value)
        _G.AutoFishing = value
        print("Auto Fishing: " .. tostring(value))
    end
})

Tab3:Input({
    Title = "Blast Delay",
    Desc = "Enter delay in seconds",
    Value = "0.01",
    InputIcon = false,
    Type = "Input",
    Placeholder = "Enter delay...",
    Callback = function(input)
        local newDelay = tonumber(input)
        if newDelay and newDelay >= 0 then
            _G.Delay = newDelay
            print("Delay changed to: " .. _G.Delay .. " seconds")
            _G.MaxSpeed = (newDelay == 0)
        else
            print("Invalid input, use number >= 0")
        end
    end
})

local function InstantFish()
    if player.Character then
        if player.Character:FindFirstChild("!!!FISHING_VIEW_MODEL!!!") then
            net["RE/EquipToolFromHotbar"]:FireServer(1)
        end
        net["RF/ChargeFishingRod"]:InvokeServer(2)
        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1, 1)
        net["RE/FishingCompleted"]:FireServer()
    end
end

task.spawn(function()
    while true do
        if _G.AutoFishing then
            InstantFish()
            if not _G.MaxSpeed and _G.Delay > 0 then
                task.wait(_G.Delay)
            elseif _G.MaxSpeed then
                task.wait(0.001)
            end
        else
            task.wait(0.01)
        end
    end
end)

player.CharacterAdded:Connect(function()
    if _G.AutoFishing then
        InstantFish()
    end
end)

Tab3:Toggle({    
    Title = "Auto Sell",    
    Desc = "Automatic fish sales",    
    Icon = false,    
    Type = false,    
    Default = false,    
    Callback = function(state)    
        _G.AutoSell = state    
        task.spawn(function()    
            while _G.AutoSell do    
                task.wait(0.5)    
                local rs = game:GetService("ReplicatedStorage")    
                for _, v in pairs(rs:GetDescendants()) do    
                    if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then    
                        v:FireServer()    
                    elseif v:IsA("RemoteFunction") and v.Name:lower():find("sell") then    
                        pcall(function()    
                            v:InvokeServer()    
                        end)    
                    end    
                end    
            end    
        end)    
    end    
})    

Tab3:Section({     
    Title = "Other",    
    TextXAlignment = "Left",    
    TextSize = 17,    
})

local autoInstantFishEnabled = true
local delayTime = 0.1

local function startAutoFish()
    task.spawn(function()
        while autoInstantFishEnabled do
            pcall(function()
                REFishingCompleted:FireServer()
            end)
            task.wait(delayTime)
        end
    end)
end

Tab3:Toggle({
    Title = "Auto Instant complete Fishing",
    Desc = "Instant Fishing For v2 (It is mandatory to turn it on if you want to use Auto Fishing V2)",
    Value = autoInstantFishEnabled,
    Callback = function(state)
        autoInstantFishEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Instant Fish",
                Content = "Enabled (Delay: " .. delayTime .. "s)",
                Duration = 3
            })
            startAutoFish()
        else
            WindUI:Notify({
                Title = "Auto Instant Fish",
                Content = "Disabled",
                Duration = 3
            })
        end
    end
})
    
Tab3:Toggle({    
    Title = "Instant Catch",    
    Desc = "Get fish straight away",    
    Icon = false,    
    Type = false,    
    Default = false,    
    Callback = function(state)    
        _G.InstantCatch = state    
        if state then    
            print("✅ Instant Catch ON")    
        else    
            print("❌ Instant Catch OFF")    
        end    
    end    
})    
    
Tab3:Toggle({    
    Title = "Radar",    
    Desc = "Toggle fishing radar",    
    Icon = false,    
    Type = false,    
    Default = false,    
    Callback = function(state)    
        local ReplicatedStorage = game:GetService("ReplicatedStorage")    
        local Lighting = game:GetService("Lighting")    
    
        local Replion = require(ReplicatedStorage.Packages.Replion)    
        local Net = require(ReplicatedStorage.Packages.Net)    
        local spr = require(ReplicatedStorage.Packages.spr)    
        local Soundbook = require(ReplicatedStorage.Shared.Soundbook)    
        local ClientTimeController = require(ReplicatedStorage.Controllers.ClientTimeController)    
        local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)    
    
        local RemoteRadar = Net:RemoteFunction("UpdateFishingRadar")    
    
        local Data = Replion.Client:GetReplion("Data")    
        if Data then    
            if RemoteRadar:InvokeServer(state) then    
                Soundbook.Sounds.RadarToggle:Play().PlaybackSpeed = 1 + math.random() * 0.3    
                local effect = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")    
                if effect then    
                    spr.stop(effect)    
                    local profile = ClientTimeController:_getLightingProfile()    
                    local cc = (profile and profile.ColorCorrection) and profile.ColorCorrection or {}    
                    if not cc.Brightness then cc.Brightness = 0.04 end    
                    if not cc.TintColor then cc.TintColor = Color3.fromRGB(255, 255, 255) end    
                    effect.TintColor = Color3.fromRGB(42, 226, 118)    
                    effect.Brightness = 0.4    
                    spr.target(effect, 1, 1, cc)    
                end    
                spr.stop(Lighting)    
                Lighting.ExposureCompensation = 1    
                spr.target(Lighting, 1, 2, {    
                    ["ExposureCompensation"] = 0    
                })    
                TextNotificationController:DeliverNotification({    
                    ["Type"] = "Text",    
                    ["Text"] = ("Radar: %*"):format(state and "Enabled" or "Disabled"),    
                    ["TextColor"] = state and {["R"] = 9,["G"] = 255,["B"] = 0} or {["R"] = 255,["G"] = 0,["B"] = 0}    
                })    
            end
        end
    end   
})

Tab3:Section({     
    Title = "Gameplay",    
    TextXAlignment = "Left",    
    TextSize = 17,    
})

Tab3:Toggle({
    Title = "FPS Boost",
    Desc = "Optimizes performance for smooth gameplay",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.FPSBoost = state
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        if state then
            if not _G.OldSettings then
                _G.OldSettings = {
                    GlobalShadows = Lighting.GlobalShadows,
                    FogEnd = Lighting.FogEnd,
                    Brightness = Lighting.Brightness,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient,
                    WaterReflectance = Lighting.WaterReflectance,
                    WaterTransparency = Lighting.WaterTransparency,
                    WaterWaveSize = Lighting.WaterWaveSize,
                    WaterWaveSpeed = Lighting.WaterWaveSpeed,
                }
            end

            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e10
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.WaterReflectance = 0
            Lighting.WaterTransparency = 1
            Lighting.WaterWaveSize = 0
            Lighting.WaterWaveSpeed = 0

            if Terrain then
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
            end

            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CastShadow = false
                    if v.Material == Enum.Material.Glass or v.Material == Enum.Material.SmoothPlastic then
                        v.Reflectance = 0
                    end
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                elseif v:IsA("Explosion") then
                    v.Visible = false
                    v.BlastPressure = 0
                    v.BlastRadius = 0
                end
            end
        else
            if _G.OldSettings then
                Lighting.GlobalShadows = _G.OldSettings.GlobalShadows
                Lighting.FogEnd = _G.OldSettings.FogEnd
                Lighting.Brightness = _G.OldSettings.Brightness
                Lighting.Ambient = _G.OldSettings.Ambient
                Lighting.OutdoorAmbient = _G.OldSettings.OutdoorAmbient
                Lighting.WaterReflectance = _G.OldSettings.WaterReflectance
                Lighting.WaterTransparency = _G.OldSettings.WaterTransparency
                Lighting.WaterWaveSize = _G.OldSettings.WaterWaveSize
                Lighting.WaterWaveSpeed = _G.OldSettings.WaterWaveSpeed
            end

            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = true
                elseif v:IsA("BasePart") then
                    v.CastShadow = true
                end
            end
        end
    end
})

Tab3:Toggle({
    Title = "Black Screen",
    Desc = "Show STREE HUB black screen",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        if state then
            local ScreenGui = Instance.new("ScreenGui")
            local Frame = Instance.new("Frame")
            local Image = Instance.new("ImageLabel")
            local Text1 = Instance.new("TextLabel")
            local Text2 = Instance.new("TextLabel")

            ScreenGui.Name = "STREE_BlackScreen"
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ResetOnSpawn = false
            ScreenGui.Parent = game.CoreGui

            Frame.Parent = ScreenGui
            Frame.AnchorPoint = Vector2.new(0, 0)
            Frame.Position = UDim2.new(0, 0, 0, 0)
            Frame.Size = UDim2.new(1, 0, 1, 0)
            Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Frame.BorderSizePixel = 0

            Image.Parent = Frame
            Image.AnchorPoint = Vector2.new(0.5, 0.5)
            Image.Position = UDim2.new(0.5, 0, 0.45, 0)
            Image.Size = UDim2.new(0, 180, 0, 180)
            Image.BackgroundTransparency = 1
            Image.Image = "rbxassetid://123032091977400"

            Text1.Parent = Frame
            Text1.AnchorPoint = Vector2.new(0.5, 0)
            Text1.Position = UDim2.new(0.5, 0, 0.7, 0)
            Text1.Size = UDim2.new(0, 400, 0, 50)
            Text1.BackgroundTransparency = 1
            Text1.Text = "STREE HUB | Fish It"
            Text1.TextColor3 = Color3.fromRGB(0, 255, 0)
            Text1.Font = Enum.Font.GothamBold
            Text1.TextSize = 28

            Text2.Parent = Frame
            Text2.AnchorPoint = Vector2.new(0.5, 0)
            Text2.Position = UDim2.new(0.5, 0, 0.78, 0)
            Text2.Size = UDim2.new(0, 400, 0, 30)
            Text2.BackgroundTransparency = 1
            Text2.Text = "discord.gg/jdmX43t5mY"
            Text2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text2.Font = Enum.Font.Gotham
            Text2.TextSize = 20
        else
            if game.CoreGui:FindFirstChild("STREE_BlackScreen") then
                game.CoreGui.STREE_BlackScreen:Destroy()
            end
        end
    end
})

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer

_G.KaitunEnabled = false
_G.KaitunDelay = 1
_G.AutoSellFish = true

local ScreenGui, Background, Saturn, SpaceSound

local function CreateBackground()
    if ScreenGui then ScreenGui:Destroy() end
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Name = "STREE_KAITUN_BACKGROUND"
    ScreenGui.Parent = CoreGui

    Background = Instance.new("Frame")
    Background.BackgroundColor3 = Color3.new(0, 0, 0)
    Background.BackgroundTransparency = 0.5
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.ZIndex = 0
    Background.Parent = ScreenGui

    for i = 1, 80 do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, math.random(3, 5), 0, math.random(3, 5))
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundTransparency = 1
        star.ZIndex = 0
        star.Parent = Background

        local circle = Instance.new("UICorner", star)
        circle.CornerRadius = UDim.new(1, 0)

        local glow = Instance.new("UIStroke", star)
        glow.Thickness = 1
        glow.Color = Color3.fromRGB(0, 255, 0)
        glow.Transparency = math.random(40, 80) / 100

        task.spawn(function()
            local tweenInfo = TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
            TweenService:Create(glow, tweenInfo, {Transparency = math.random(0, 60) / 100}):Play()
        end)
    end

    Saturn = Instance.new("ImageLabel")
    Saturn.Image = "rbxassetid://122683047852451"
    Saturn.BackgroundTransparency = 1
    Saturn.Size = UDim2.new(0, 320, 0, 320)
    Saturn.Position = UDim2.new(0.7, 0, 0.15, 0)
    Saturn.ImageTransparency = 0.05
    Saturn.ZIndex = 0
    Saturn.Parent = Background

    local rotationY = 0
    task.spawn(function()
        while ScreenGui and _G.KaitunEnabled do
            for i = 0, 180, 2 do
                rotationY = i
                Saturn.Rotation = rotationY
                task.wait(0.02)
            end
            for i = 180, 0, -2 do
                rotationY = i
                task.wait(0.02)
            end
        end
    end)

    SpaceSound = Instance.new("Sound")
    SpaceSound.SoundId = "rbxassetid://1846351427"
    SpaceSound.Volume = 0.2
    SpaceSound.Looped = true
    SpaceSound.Parent = SoundService
    SpaceSound:Play()
end

local function RemoveBackground()
    if SpaceSound then
        SpaceSound:Stop()
        SpaceSound:Destroy()
        SpaceSound = nil
    end
    if ScreenGui then
        TweenService:Create(Background, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        task.wait(1)
        ScreenGui:Destroy()
        ScreenGui = nil
    end
end

task.spawn(function()
    while task.wait(10) do
        if not game:IsLoaded() then continue end
        if not Player or not Player.Character then
            pcall(function()
                TeleportService:Teleport(game.PlaceId, Player)
            end)
        end
    end
end)

for _, v in pairs(getconnections(Player.Idled)) do
    v:Disable()
end

task.spawn(function()
    while task.wait(60) do
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

local Tab4 = Window:Tab({
    Title = "Exclusive",
    Icon = "star",
})

Tab4:Section({     
    Title = "Auto Kaitun System",    
    TextXAlignment = "Left",    
    TextSize = 17,    
})

local function StartKaitun()
    task.spawn(function()
        while _G.KaitunEnabled do
            local success, err = pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local backpack = player:WaitForChild("Backpack", 5)
                if backpack then
                    local rod = backpack:FindFirstChild("Rod") or backpack:FindFirstChild("FishingRod")
                    if rod and not character:FindFirstChild(rod.Name) then
                        character:WaitForChild("Humanoid"):EquipTool(rod)
                    end
                end
                local fishingPackage = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0")
                if not fishingPackage then return end
                local netFolder = fishingPackage:FindFirstChild("net")
                if not netFolder then return end
                local chargeRemote = netFolder:FindFirstChild("RF/ChargeFishingRod")
                local completeRemote = netFolder:FindFirstChild("RE/FishingCompleted")
                if chargeRemote and completeRemote then
                    if not character:FindFirstChild("!!!FISHING_VIEW_MODEL!!!") then
                        chargeRemote:InvokeServer(2)
                    end
                    completeRemote:FireServer()
                end
                if _G.AutoSellFish then
                    for _, v in pairs(RepStorage:GetDescendants()) do
                        if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then
                            pcall(function() v:FireServer() end)
                        end
                    end
                end
            end)
            if not success then warn("[Kaitun Error]:", err) end
            task.wait(_G.KaitunDelay)
        end
    end)
end

Tab4:Toggle({
    Title = "Enable Kaitun",
    Desc = "Activate auto farming system",
    Default = false,
    Callback = function(state)
        _G.KaitunEnabled = state
        if state then
            CreateBackground()
            WindUI:Notify({Title = "Kaitun Started", Content = "Auto farming activated!", Duration = 3})
            StartKaitun()
        else
            RemoveBackground()
            WindUI:Notify({Title = "Kaitun Stopped", Content = "Auto farming disabled.", Duration = 3})
        end
    end
})

Tab4:Toggle({
    Title = "Auto Sell Fish",
    Desc = "Automatically sell caught fish",
    Default = true,
    Callback = function(state)
        _G.AutoSellFish = state
        WindUI:Notify({
            Title = "Auto Sell",
            Content = state and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

Tab4:Slider({
    Title = "Kaitun Delay",
    Desc = "Farming speed (seconds)",
    Min = 0.5,
    Max = 5,
    Default = 1,
    Callback = function(value)
        _G.KaitunDelay = value
        WindUI:Notify({
            Title = "Kaitun Delay",
            Content = "Delay set to " .. tostring(value) .. "s",
            Duration = 2
        })
    end
})

local Tab5 = Window:Tab({
    Title = "Shop",
    Icon = "badge-dollar-sign",
})

Tab5:Section({ 
    Title = "Buy Rod",
    TextXAlignment = "Left",
    TextSize = 17,
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]

local rods = {
    ["Luck Rod"] = 79,
    ["Carbon Rod"] = 76,
    ["Grass Rod"] = 85,
    ["Demascus Rod"] = 77,
    ["Ice Rod"] = 78,
    ["Lucky Rod"] = 4,
    ["Midnight Rod"] = 80,
    ["Steampunk Rod"] = 6,
    ["Chrome Rod"] = 7,
    ["Astral Rod"] = 5,
    ["Ares Rod"] = 126,
    ["Angler Rod"] = 168,
    ["Bamboo Rod"] = 258
}

local rodNames = {
    "Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)", "Demascus Rod (3k Coins)",
    "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)", "Midnight Rod (50k Coins)", "Steampunk Rod (215k Coins)",
    "Chrome Rod (437k Coins)", "Astral Rod (1M Coins)", "Ares Rod (3M Coins)", "Angler Rod (8M Coins)",
    "Bamboo Rod (12M Coins)"
}

local rodKeyMap = {
    ["Luck Rod (350 Coins)"] = "Luck Rod",
    ["Carbon Rod (900 Coins)"] = "Carbon Rod",
    ["Grass Rod (1.5k Coins)"] = "Grass Rod",
    ["Demascus Rod (3k Coins)"] = "Demascus Rod",
    ["Ice Rod (5k Coins)"] = "Ice Rod",
    ["Lucky Rod (15k Coins)"] = "Lucky Rod",
    ["Midnight Rod (50k Coins)"] = "Midnight Rod",
    ["Steampunk Rod (215k Coins)"] = "Steampunk Rod",
    ["Chrome Rod (437k Coins)"] = "Chrome Rod",
    ["Astral Rod (1M Coins)"] = "Astral Rod",
    ["Ares Rod (3M Coins)"] = "Ares Rod",
    ["Angler Rod (8M Coins)"] = "Angler Rod",
    ["Bamboo Rod (12M Coins)"] = "Bamboo Rod"
}

local selectedRod = rodNames[1]

Tab5:Dropdown({
    Title = "Select Rod",
    Values = rodNames,
    Value = selectedRod,
    Callback = function(value)
        selectedRod = value
        WindUI:Notify({Title="Rod Selected", Content=value, Duration=3})
    end
})

Tab5:Button({
    Title="Buy Rod",
    Callback=function()
        local key = rodKeyMap[selectedRod]
        if key and rods[key] then
            local success, err = pcall(function()
                RFPurchaseFishingRod:InvokeServer(rods[key])
            end)
            if success then
                WindUI:Notify({Title="Rod Purchase", Content="Purchased "..selectedRod, Duration=3})
            else
                WindUI:Notify({Title="Rod Purchase Error", Content=tostring(err), Duration=5})
            end
        end
    end
})

Tab5:Section({
    Title = "Buy Baits",
    TextXAlignment = "Left",
    TextSize = 17,
})

local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]  

local baits = {
    ["TopWater Bait"] = 10,
    ["Lucky Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Chroma Bait"] = 6,
    ["Dark Mater Bait"] = 8,
    ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16,
    ["Aether Bait"] = 20,
}

local baitNames = {  
    "Luck Bait (1k Coins)", "Midnight Bait (3k Coins)", "Nature Bait (83.5k Coins)",  
    "Chroma Bait (290k Coins)", "Dark Matter Bait (630k Coins)", "Corrupt Bait (1.15M Coins)",  
    "Aether Bait (3.7M Coins)", "Floral Bait (4M Coins)"  
}  

local baitKeyMap = {  
    ["Luck Bait (1k Coins)"] = "Luck Bait",  
    ["Midnight Bait (3k Coins)"] = "Midnight Bait",  
    ["Nature Bait (83.5k Coins)"] = "Nature Bait",  
    ["Chroma Bait (290k Coins)"] = "Chroma Bait",  
    ["Dark Matter Bait (630k Coins)"] = "Dark Matter Bait",  
    ["Corrupt Bait (1.15M Coins)"] = "Corrupt Bait",  
    ["Aether Bait (3.7M Coins)"] = "Aether Bait",  
    ["Floral Bait (4M Coins)"] = "Floral Bait"  
}  

local selectedBait = baitNames[1]  

Tab5:Dropdown({  
    Title = "Select Bait",  
    Values = baitNames,  
    Value = selectedBait,  
    Callback = function(value)  
        selectedBait = value  
    end  
})  

Tab5:Button({  
    Title = "Buy Bait",  
    Callback = function()  
        local key = baitKeyMap[selectedBait]  
        if key and baits[key] then  
            local success, err = pcall(function()  
                RFPurchaseBait:InvokeServer(baits[key])  
            end)  
            if success then  
                WindUI:Notify({Title = "Bait Purchase", Content = "Purchased " .. selectedBait, Duration = 3})  
            else  
                WindUI:Notify({Title = "Bait Purchase Error", Content = tostring(err), Duration = 5})  
            end  
        end  
    end  
})

Tab5:Section({
    Title = "Buy Weather Event",
    TextXAlignment = "Left",
    TextSize = 17,
})

local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]  

local weathers = {
    ["Wind"] = 1,
    ["Cloudy"] = 2,
    ["Snow"] = 3,
    ["Storm"] = 4,
    ["Shine"] = 5,
    ["Shark Hunting"] = 6
}

local weatherNames = {  
    "Windy (10k Coins)", "Cloudy (20k Coins)", "Stormy (35k Coins)", 
    "Shining (50k Coins)", "Shark Hunt (300k Coins)", "Snow (15k Coins)"  
}  

local weatherKeyMap = {  
    ["Windy (10k Coins)"] = "Wind",  
    ["Cloudy (20k Coins)"] = "Cloudy",  
    ["Stormy (35k Coins)"] = "Storm",  
    ["Shining (50k Coins)"] = "Shine",  
    ["Shark Hunt (300k Coins)"] = "Shark Hunting",  
    ["Snow (15k Coins)"] = "Snow"  
}  

local selectedWeather = weatherNames[1]  

Tab5:Dropdown({  
    Title = "Select Weather Event",  
    Values = weatherNames,  
    Value = selectedWeather,  
    Callback = function(value)  
        selectedWeather = value  
    end  
})  

Tab5:Button({  
    Title = "Buy Weather Event",  
    Callback = function()  
        local key = weatherKeyMap[selectedWeather]  
        if key and weathers[key] then  
            local success, err = pcall(function()  
                RFPurchaseWeatherEvent:InvokeServer(weathers[key])  
            end)  
            if success then  
                WindUI:Notify({Title = "Weather Purchase", Content = "Purchased " .. selectedWeather, Duration = 3})  
            else  
                WindUI:Notify({Title = "Weather Purchase Error", Content = tostring(err), Duration = 5})  
            end  
        end  
    end  
})

local Tab6 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

Tab6:Section({ 
    Title = "Island",
    TextXAlignment = "Left",
    TextSize = 17,
})

local IslandLocations = {
    ["Ancient Junggle"] = Vector3.new(1252,7,-153),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
    ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
    ["Konoha"] = Vector3.new(-603, 3, 719),
    ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
    ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
    ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
}

local SelectedIsland = nil

Tab6:Dropdown({
    Title = "Select Island",
    Values = (function()
        local keys = {}
        for name in pairs(IslandLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedIsland = Value
    end
})

Tab6:Button({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(IslandLocations[SelectedIsland])
        end
    end
})

Tab6:Section({ 
    Title = "Fishing Spot",
    TextXAlignment = "Left",
    TextSize = 17,
})

local FishingLocations = {
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Konoha"] = Vector3.new(-603, 3, 719),
    ["Levers 1"] = Vector3.new(1475,4,-847),
    ["Levers 2"] = Vector3.new(882,5,-321),
    ["levers 3"] = Vector3.new(1425,6,126),
    ["levers 4"] = Vector3.new(1837,4,-309),
    ["Sacred Temple"] = Vector3.new(1475,-22,-632),
    ["Spawn"] = Vector3.new(33, 9, 2810),
    ["Sysyphus Statue"] = Vector3.new(-3693,-136,-1045),
    ["Underground Cellar"] = Vector3.new(2135,-92,-695),
    ["Volcano"] = Vector3.new(-632, 55, 197),
}

local SelectedFishing = nil

Tab6:Dropdown({
    Title = "Select Spot",
    Values = (function()
        local keys = {}
        for name in pairs(FishingLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedFishing = Value
    end
})

Tab6:Button({
    Title = "Teleport to Fishing Spot",
    Callback = function()
        if SelectedFishing and FishingLocations[SelectedFishing] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(FishingLocations[SelectedFishing])
        end
    end
})

Tab6:Section({
    Title = "Location NPC",
    TextXAlignment = "Left",
    TextSize = 17,
})

local NPC_Locations = {
    ["Alex"] = Vector3.new(43,17,2876),
    ["Aura kid"] = Vector3.new(70,17,2835),
    ["Billy Bob"] = Vector3.new(84,17,2876),
    ["Boat Expert"] = Vector3.new(32,9,2789),
    ["Esoteric Gatekeeper"] = Vector3.new(2101,-30,1350),
    ["Jeffery"] = Vector3.new(-2771,4,2132),
    ["Joe"] = Vector3.new(144,20,2856),
    ["Jones"] = Vector3.new(-671,16,596),
    ["Lava Fisherman"] = Vector3.new(-593,59,130),
    ["McBoatson"] = Vector3.new(-623,3,719),
    ["Ram"] = Vector3.new(-2838,47,1962),
    ["Ron"] = Vector3.new(-48,17,2856),
    ["Scott"] = Vector3.new(-19,9,2709),
    ["Scientist"] = Vector3.new(-6,17,2881),
    ["Seth"] = Vector3.new(107,17,2877),
    ["Silly Fisherman"] = Vector3.new(97,9,2694),
    ["Tim"] = Vector3.new(-604,16,609),
}

local SelectedNPC = nil

Tab6:Dropdown({
    Title = "Select NPC",
    Values = (function()
        local keys = {}
        for name in pairs(NPC_Locations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedNPC = Value
    end
})

Tab6:Button({
    Title = "Teleport to NPC",
    Callback = function()
        if SelectedNPC and NPC_Locations[SelectedNPC] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(NPC_Locations[SelectedNPC])
        end
    end
})

Tab6:Section({
    Title = "Event Teleporter",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Event_Locations = {
    ["Black Hole"] = Vector3.new(883, -1.4, 2542),
    ["Ghost Shark Hunt"] = Vector3.new(489.559, -1.35, 25.406),
    ["Megalodon Hunt"] = Vector3.new(-1076.3, -1.4, 1676.2),
    ["Meteor Rain"] = Vector3.new(383, -1.4, 2452),
    ["Shark Hunt"] = Vector3.new(1.65, -1.35, 2095.725),
    ["Storm Hunt"] = Vector3.new(1735.85, -1.4, -208.425),
    ["Worm Hunt"] = Vector3.new(1591.55, -1.4, -105.925),
}

local ActiveEvent = nil

Tab6:Dropdown({
    Title = "Select Event",
    Values = (function()
        local keys = {}
        for name in pairs(Event_Locations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        ActiveEvent = Value
    end
})

Tab6:Button({
    Title = "Teleport to Event",
    Callback = function()
        local Char = Player.Character or Player.CharacterAdded:Wait()
        local HRP = Char:FindFirstChild("HumanoidRootPart")
        if not HRP then return end
        if ActiveEvent and Event_Locations[ActiveEvent] then
            HRP.CFrame = CFrame.new(Event_Locations[ActiveEvent])
        end
    end
})

local Tab7 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

Tab7:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")

        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(60)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end)

            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK loaded!",
                Text = "Coded By Kirsiasc",
                Button1 = "Okey",
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK Disabled",
                Text = "Stopped AntiAFK",
                Duration = 3
            })
        end
    end
})

Tab7:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = false,
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)

                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})

Tab7:Section({ 
    Title = "Server",
    Icon = "server",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab7:Button({
    Title = "Rejoin Server",
    Desc = "Reconnect to current server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

Tab7:Button({
    Title = "Server Hop",
    Desc = "Switch to another server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        
        local function GetServers()
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
            local response = HttpService:JSONDecode(game:HttpGet(url))
            return response.data
        end

        local function FindBestServer(servers)
            for _, server in ipairs(servers) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    return server.id
                end
            end
            return nil
        end

        local servers = GetServers()
        local serverId = FindBestServer(servers)

        if serverId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
        else
            warn("⚠️ No suitable server found!")
        end
    end
})

Tab7:Section({ 
    Title = "Config",
    Icon = "folder-open",
    TextXAlignment = "Left",
    TextSize = 17,
})

local ConfigFolder = "STREE_HUB/Configs"
if not isfolder("STREE_HUB") then makefolder("STREE_HUB") end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local ConfigName = "default.json"

local function GetConfig()
    return {
        WalkSpeed = Humanoid.WalkSpeed,
        JumpPower = _G.CustomJumpPower or 50,
        InfiniteJump = _G.InfiniteJump or false,
        AutoSell = _G.AutoSell or false,
        InstantCatch = _G.InstantCatch or false,
        AntiAFK = _G.AntiAFK or false,
        AutoReconnect = _G.AutoReconnect or false,
    }
end

local function ApplyConfig(data)
    if data.WalkSpeed then 
        Humanoid.WalkSpeed = data.WalkSpeed 
    end
    if data.JumpPower then
        _G.CustomJumpPower = data.JumpPower
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = data.JumpPower
        end
    end
    if data.InfiniteJump ~= nil then
        _G.InfiniteJump = data.InfiniteJump
    end
    if data.AutoSell ~= nil then
        _G.AutoSell = data.AutoSell
    end
    if data.InstantCatch ~= nil then
        _G.InstantCatch = data.InstantCatch
    end
    if data.AntiAFK ~= nil then
        _G.AntiAFK = data.AntiAFK
    end
    if data.AutoReconnect ~= nil then
        _G.AutoReconnect = data.AutoReconnect
    end
end

Tab7:Button({
    Title = "Save Config",
    Desc = "Save all settings",
    Callback = function()
        local data = GetConfig()
        writefile(ConfigFolder.."/"..ConfigName, game:GetService("HttpService"):JSONEncode(data))
        print("✅ Config saved!")
    end
})

Tab7:Button({
    Title = "Load Config",
    Desc = "Use saved config",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            local data = readfile(ConfigFolder.."/"..ConfigName)
            local decoded = game:GetService("HttpService"):JSONDecode(data)
            ApplyConfig(decoded)
            print("✅ Config applied!")
        else
            warn("⚠️ Config not found, please Save first.")
        end
    end
})

Tab7:Button({
    Title = "Delete Config",
    Desc = "Delete saved config",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            delfile(ConfigFolder.."/"..ConfigName)
            print("🗑 Config deleted!")
        else
            warn("⚠️ No config to delete.")
        end
    end
})

Tab7:Section({ 
    Title = "Other Scripts",
    Icon = "file-code-2",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab7:Button({
    Title = "FLY",
    Desc = "Scripts Fly Gui",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

Tab7:Button({
    Title = "Simple Shader",
    Desc = "Shader",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua"))()
    end
})

Tab7:Button({
    Title = "Infinite Yield",
    Desc = "Other Scripts",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
    end
})
