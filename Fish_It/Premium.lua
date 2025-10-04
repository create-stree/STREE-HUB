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
    Title = "v0.0.0.1",
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

local Section = Tab1:Section({
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

local Section = Tab1:Section({
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

local Input = Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = "bird",
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

local Input = Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = "bird",
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

local Button = Tab2:Button({
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

local Toggle = Tab2:Toggle({
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

local Toggle = Tab2:Toggle({
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

local Section = Tab3:Section({
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
                    local rod = backpack:FindFirstChild("Rod")
                        or backpack:FindFirstChild("FishingRod")
                        or backpack:FindFirstChild("OldRod")
                        or backpack:FindFirstChild("BasicRod")
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

local Players = game:GetService("Players")    
local RepStorage = game:GetService("ReplicatedStorage")    
local player = game.Players.LocalPlayer    
    
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
                          RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]:InvokeServer(1, 1)    
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
Toggle = Tab3:Toggle({
    Title = "Auto Fishing",
    Desc = "Automatic Auto Fishing v2",
    Value = false,
    Callback = function(state)
        autoHoldEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Fishing ",
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
                Title = "Auto Fishing",
                Content = "Disabled",
                Duration = 3
            })
        end
    end
})

local Toggle = Tab3:Toggle({    
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
    
local Section = Tab3:Section({     
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

Toggle = Tab3:Toggle({
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
    
local Toggle = Tab3:Toggle({    
    Title = "Instant Catch",    
    Desc = "Get fish straight away",    
    Icon = false,    
    Type = false,    
    Default = false,    
    Callback = function(state)    
        _G.InstantCatch = state    
    
        if state then    
            print("✅ Instant Catch ON")    
            if _loopRunning then return end    
            _loopRunning = true    
    
            task.spawn(function()    
                while _G.InstantCatch do    
                    local remote = findRemote(REMOTE_CATCH)    
                    if remote then    
                        local success, err = pcall(function()    
                            if remote:IsA("RemoteEvent") then    
                                remote:FireServer()    
                            else    
                                remote:InvokeServer()    
                            end    
                        end)    
                        if not success then    
                            warn("❌ error:", err)    
                        end    
                    end    
                    task.wait(TRY_INTERVAL)    
                end    
                _loopRunning = false    
                print("❌ Instant Catch OFF")    
            end)    
        else    
            print("❌ Instant Catch is turned off")    
        end    
    end    
})    
    
local Toggle = Tab3:Toggle({    
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

local Tab4 = Window:Tab({
    Title = "Shop",
    Icon = "badge-dollar-sign",
})

Tab4:Section({ 
    Title = "Buy Rod",
    TextXAlignment = "Left",
    TextSize = 17,
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]
local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]
local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]
local RFPurchaseBoat = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBoat"]

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
    ["Angler Rod"] = 168
}

local rodNames = {
    "Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)", "Demascus Rod (3k Coins)",
    "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)", "Midnight Rod (50k Coins)", "Steampunk Rod (215k Coins)",
    "Chrome Rod (437k Coins)", "Astral Rod (1M Coins)", "Ares Rod (3M Coins)", "Angler Rod ($8M Coins)"
}

local rodKeyMap = {
    ["Luck Rod (350 Coins)"]="Luck Rod",
    ["Carbon Rod (900 Coins)"]="Carbon Rod",
    ["Grass Rod (1.5k Coins
