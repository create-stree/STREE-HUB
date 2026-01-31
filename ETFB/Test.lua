local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CurrentCamera = Workspace.CurrentCamera

local CurrentSpeed = Humanoid.WalkSpeed
local FlyEnabled = false
local FlySpeed = 5
local GodModeEnabled = false
local CurrentGap = 1
local AutoUpgradeSpeed = false
local AutoUpgradeCarry = false
local AutoUpgradeBase = false
local AutoRebirth = false
local AutoSellAll = false
local LoopBringEnabled = false
local BringDistance = 5
local SelectedPlayers = {}
local HitboxEnabled = false
local QEFlyEnabled = true
local InstantGrabEnabled = false
local FlyVelocity = nil
local FlyGyro = nil
local FlyConnection = nil
local CharacterConnection = nil
local GodModeConnection = nil
local HealthConnection = nil

local GapPositions = {
    Vector3.new(200, -3, 0),
    Vector3.new(286, -3, -1),
    Vector3.new(393, -3, 5),
    Vector3.new(541, -3, 5),
    Vector3.new(758, -3, 1),
    Vector3.new(1079, -3, 6),
    Vector3.new(1564, -3, -2),
    Vector3.new(2247, -3, -14),
    Vector3.new(2615, -3, 12)
}

local TotalGaps = #GapPositions

local function SafeGetCharacter()
    local char = LocalPlayer.Character
    if not char then
        return nil, nil, nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

local function GetTsunamiDistance()
    local char, hum, hrp = SafeGetCharacter()
    if not hrp then
        return math.huge
    end
    local tsunamisFolder = Workspace:FindFirstChild("ActiveTsunamis")
    if not tsunamisFolder then
        return math.huge
    end
    local closestDistance = math.huge
    for i = 1, 6 do
        local waveName = "Wave" .. tostring(i)
        local wave = tsunamisFolder:FindFirstChild(waveName)
        if wave then
            local hitbox = wave:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("BasePart") then
                local distance = (hitbox.Position - hrp.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                end
            end
        end
    end
    return closestDistance
end

local function FormatTsunamiText(distance)
    if distance == math.huge then
        return "No Tsunami Detected"
    end
    local rounded = math.floor(distance)
    if rounded <= 500 then
        return "Tsunami: " .. tostring(rounded) .. "m (DANGER)"
    else
        return "Tsunami: " .. tostring(rounded) .. "m (SAFE)"
    end
end

local function TweenToPosition(targetPosition, duration)
    local char, hum, hrp = SafeGetCharacter()
    if not hrp then
        return
    end
    duration = duration or 1
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local targetCFrame = CFrame.new(targetPosition)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local function TeleportToGap(gapNumber)
    if gapNumber < 1 or gapNumber > TotalGaps then
        return false
    end
    local targetPos = GapPositions[gapNumber]
    if not targetPos then
        return false
    end
    TweenToPosition(targetPos, 1.5)
    CurrentGap = gapNumber
    return true
end

local function EnableFly()
    local char, hum, hrp = SafeGetCharacter()
    if not hrp or not hum then
        return
    end
    if FlyVelocity then
        FlyVelocity:Destroy()
    end
    if FlyGyro then
        FlyGyro:Destroy()
    end
    local maxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.Name = "FlyVelocity"
    FlyVelocity.MaxForce = maxForce
    FlyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyVelocity.Parent = hrp
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.Name = "FlyGyro"
    FlyGyro.MaxTorque = maxForce
    FlyGyro.P = 1000
    FlyGyro.D = 50
    FlyGyro.Parent = hrp
    hum.PlatformStand = true
    FlyConnection = RunService.RenderStepped:Connect(function()
        local currentChar, currentHum, currentHrp = SafeGetCharacter()
        if not currentHrp or not FlyEnabled then
            return
        end
        local vel = FlyVelocity
        local gyro = FlyGyro
        if not vel or not gyro then
            return
        end
        currentHum.PlatformStand = true
        gyro.CFrame = CurrentCamera.CFrame
        local direction = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + CurrentCamera.CFrame.RightVector
        end
        if QEFlyEnabled then
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                direction = direction - Vector3.new(0, 1, 0)
            end
        end
        if direction.Magnitude > 0 then
            vel.Velocity = direction.Unit * FlySpeed * 10
        else
            vel.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function DisableFly()
    local char, hum, hrp = SafeGetCharacter()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if FlyVelocity then
        FlyVelocity:Destroy()
        FlyVelocity = nil
    end
    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end
    if hum then
        hum.PlatformStand = false
    end
end

local function EnableGodMode()
    local char, hum, hrp = SafeGetCharacter()
    if not hum then
        return
    end
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    HealthConnection = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if GodModeEnabled and hum.Health < 1000000 then
            hum.Health = 1000000
        end
    end)
    CharacterConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        if not GodModeEnabled then
            return
        end
        local newHum = newChar:FindFirstChildOfClass("Humanoid")
        if newHum then
            task.wait(0.5)
            newHum.MaxHealth = math.huge
            newHum.Health = math.huge
            if HealthConnection then
                HealthConnection:Disconnect()
            end
            HealthConnection = newHum:GetPropertyChangedSignal("Health"):Connect(function()
                if GodModeEnabled and newHum.Health < 1000000 then
                    newHum.Health = 1000000
                end
            end)
        end
    end)
end

local function DisableGodMode()
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end
    if CharacterConnection then
        CharacterConnection:Disconnect()
        CharacterConnection = nil
    end
end

local function EnableInstantGrab()
    for _, descendant in pairs(Workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            descendant.HoldDuration = 0
        end
    end
    Workspace.DescendantAdded:Connect(function(descendant)
        if InstantGrabEnabled and descendant:IsA("ProximityPrompt") then
            descendant.HoldDuration = 0
        end
    end)
end

local function GetPlayerList()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

local function BringPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if not targetPlayer then
        return
    end
    local targetChar = targetPlayer.Character
    if not targetChar then
        return
    end
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHrp then
        return
    end
    local char, hum, hrp = SafeGetCharacter()
    if not hrp then
        return
    end
    local offset = hrp.CFrame.LookVector * BringDistance
    targetHrp.CFrame = hrp.CFrame + offset
end

local function BringSelectedPlayers()
    for _, playerName in pairs(SelectedPlayers) do
        BringPlayer(playerName)
    end
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Flash Hub | Leaked He A Bih",
    LoadingTitle = "by moon :)",
    LoadingSubtitle = "skidding...",
    Theme = {
        TextColor = Color3.fromRGB(170, 200, 255),
        Background = Color3.fromRGB(10, 15, 30),
        Topbar = Color3.fromRGB(15, 25, 45),
        Shadow = Color3.fromRGB(5, 10, 20),
        NotificationBackground = Color3.fromRGB(15, 25, 45),
        NotificationActionsBackground = Color3.fromRGB(35, 50, 80),
        TabBackground = Color3.fromRGB(40, 60, 100),
        TabStroke = Color3.fromRGB(50, 70, 120),
        TabBackgroundSelected = Color3.fromRGB(25, 40, 80),
        TabTextColor = Color3.fromRGB(170, 200, 255),
        SelectedTabTextColor = Color3.fromRGB(120, 170, 255),
        ElementBackground = Color3.fromRGB(20, 30, 55),
        ElementBackgroundHover = Color3.fromRGB(30, 45, 80),
        SecondaryElementBackground = Color3.fromRGB(15, 25, 45),
        ElementStroke = Color3.fromRGB(70, 110, 180),
        SecondaryElementStroke = Color3.fromRGB(50, 90, 160),
        SliderBackground = Color3.fromRGB(40, 70, 120),
        SliderProgress = Color3.fromRGB(100, 150, 255),
        SliderStroke = Color3.fromRGB(70, 120, 200),
        ToggleBackground = Color3.fromRGB(20, 25, 45),
        ToggleEnabled = Color3.fromRGB(100, 150, 255),
        ToggleDisabled = Color3.fromRGB(90, 90, 90),
        ToggleEnabledStroke = Color3.fromRGB(70, 120, 200),
        ToggleDisabledStroke = Color3.fromRGB(60, 60, 60),
        ToggleEnabledOuterStroke = Color3.fromRGB(50, 90, 160),
        ToggleDisabledOuterStroke = Color3.fromRGB(40, 40, 40),
        DropdownSelected = Color3.fromRGB(30, 45, 80),
        DropdownUnselected = Color3.fromRGB(20, 30, 55),
        InputBackground = Color3.fromRGB(15, 25, 45),
        InputStroke = Color3.fromRGB(70, 110, 190),
        PlaceholderColor = Color3.fromRGB(140, 180, 255)
    }
})

LocalPlayer:SetAttribute("CurrentSpeed", CurrentSpeed)

local PlayerModsTab = Window:CreateTab("Player Mods", "user")

PlayerModsTab:CreateSection("Speed Modifier")

PlayerModsTab:CreateSlider({
    Name = "Speed Slider",
    Range = {16, 300},
    Increment = 1,
    Suffix = " speed",
    CurrentValue = 16,
    Flag = "SpeedModifierSlider",
    Callback = function(value)
        CurrentSpeed = value
        LocalPlayer:SetAttribute("CurrentSpeed", value)
        Rayfield:Notify({
            Title = "Speed Updated",
            Content = "Walk Speed set to: " .. tostring(value),
            Duration = 2,
            Image = "zap"
        })
    end
})

PlayerModsTab:CreateLabel("Speed changer isn't that so tuff?")

PlayerModsTab:CreateSection("God Mode")

PlayerModsTab:CreateToggle({
    Name = "God Mode (1 Extra Life)",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(value)
        GodModeEnabled = value
        if value then
            EnableGodMode()
            Rayfield:Notify({
                Title = "God Mode",
                Content = "Enabled! Extra hit protection active.",
                Duration = 5,
                Image = "shield"
            })
        else
            DisableGodMode()
        end
    end
})

PlayerModsTab:CreateLabel("You get 1 Extra Hit, and if you die you have to click the toggle it again for Godmode!")

PlayerModsTab:CreateSection("Fly Modifier")

PlayerModsTab:CreateToggle({
    Name = "Enable Fly (100% Works)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        FlyEnabled = value
        if value then
            EnableFly()
        else
            DisableFly()
        end
    end
})

PlayerModsTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 10},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 5,
    Flag = "FlySpeed",
    Callback = function(value)
        FlySpeed = value
    end
})

PlayerModsTab:CreateToggle({
    Name = "QE Fly (Up/Down)",
    CurrentValue = true,
    Flag = "QEFly",
    Callback = function(value)
        QEFlyEnabled = value
    end
})

PlayerModsTab:CreateButton({
    Name = "Open Fly GUI (For Mobile)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scripture2025/Checker/refs/heads/main/FlyGUI"))()
    end
})

PlayerModsTab:CreateLabel("Put the fly speed to 3 if you execute the Fly GUI!")

PlayerModsTab:CreateSection("Easy Grab")

PlayerModsTab:CreateToggle({
    Name = "Instant Grab Brainrot",
    CurrentValue = false,
    Flag = "InstantHold",
    Callback = function(value)
        InstantGrabEnabled = value
        if value then
            EnableInstantGrab()
            Rayfield:Notify({
                Title = "Instant Hold",
                Content = "All ProximityPrompts are now instant!",
                Duration = 3,
                Image = "hand"
            })
        end
    end
})

PlayerModsTab:CreateLabel("It instant grabs the brainrot with no hold time!")

PlayerModsTab:CreateSection("Tsunami Distance Monitor")

local TsunamiLabel = PlayerModsTab:CreateLabel("Checking tsunami distance...")

task.spawn(function()
    while task.wait(1) do
        local distance = GetTsunamiDistance()
        local text = FormatTsunamiText(distance)
        if TsunamiLabel and TsunamiLabel.Set then
            TsunamiLabel:Set(text)
        end
    end
end)

local GapTweenTab = Window:CreateTab("Auto Gap Tween", "map-pin")

GapTweenTab:CreateSection("Gap Navigation")

local GapLabel = GapTweenTab:CreateLabel("Current Gap: Gap #1")

local LandingCFrame = nil
local TweenRunning = false
local AutoGapEnabled = false
local TweenSpeed = 100
local CurrentTween = nil

local function StopCurrentTween()
    TweenRunning = false
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
end

local function TweenToGapWithLanding(gapNumber, callback)
    local char, hum, hrp = SafeGetCharacter()
    if not hrp then
        return nil
    end
    if gapNumber < 1 or gapNumber > TotalGaps then
        return nil
    end
    local targetPos = GapPositions[gapNumber]
    if not targetPos then
        return nil
    end
    StopCurrentTween()
    TweenRunning = true
    local distance = (hrp.Position - targetPos).Magnitude
    local speed = TweenSpeed
    if speed <= 0 then
        speed = 100
    end
    local duration = distance / speed
    if duration < 0.5 then
        duration = 0.5
    end
    if duration > 10 then
        duration = 10
    end
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local targetCFrame = CFrame.new(targetPos)
    CurrentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    CurrentTween.Completed:Connect(function()
        TweenRunning = false
        CurrentTween = nil
        if hrp then
            LandingCFrame = hrp.CFrame
        end
        if callback then
            callback()
        end
    end)
    CurrentTween:Play()
    return CurrentTween
end

GapTweenTab:CreateSlider({
    Name = "Tween Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = " studs/s",
    CurrentValue = 100,
    Flag = "TweenSpeed",
    Callback = function(value)
        TweenSpeed = value
    end
})

GapTweenTab:CreateButton({
    Name = "Gap Up (Next Gap)",
    Callback = function()
        if CurrentGap >= TotalGaps then
            Rayfield:Notify({
                Title = "Already at Last Gap",
                Content = "You're at the final gap (#" .. tostring(TotalGaps) .. ")",
                Duration = 2,
                Image = "alert-circle"
            })
            return
        end
        CurrentGap = CurrentGap + 1
        TweenToGapWithLanding(CurrentGap)
        if GapLabel and GapLabel.Set then
            GapLabel:Set("Current Gap: Gap #" .. tostring(CurrentGap))
        end
        Rayfield:Notify({
            Title = "Gap Navigation",
            Content = "Tweening to Gap #" .. tostring(CurrentGap),
            Duration = 1.5,
            Image = "arrow-up"
        })
    end
})

GapTweenTab:CreateButton({
    Name = "Gap Down (Previous Gap)",
    Callback = function()
        if CurrentGap <= 1 then
            Rayfield:Notify({
                Title = "Already at First Gap",
                Content = "You're at the first gap",
                Duration = 2,
                Image = "alert-circle"
            })
            return
        end
        CurrentGap = CurrentGap - 1
        TweenToGapWithLanding(CurrentGap)
        if GapLabel and GapLabel.Set then
            GapLabel:Set("Current Gap: Gap #" .. tostring(CurrentGap))
        end
        Rayfield:Notify({
            Title = "Gap Navigation",
            Content = "Tweening to Gap #" .. tostring(CurrentGap),
            Duration = 1.5,
            Image = "arrow-down"
        })
    end
})

GapTweenTab:CreateButton({
    Name = "Stop Current Tween",
    Callback = function()
        StopCurrentTween()
        Rayfield:Notify({
            Title = "Tween Stopped",
            Content = "Current tween has been cancelled",
            Duration = 1.5,
            Image = "square"
        })
    end
})

GapTweenTab:CreateButton({
    Name = "Reset Gap Data & Tween to Gap 1 (DO THIS FIRST)",
    Callback = function()
        Rayfield:Notify({
            Title = "Resetting Gap Data",
            Content = "Teleporting to Gap #1...",
            Duration = 1.5,
            Image = "refresh-cw"
        })
        CurrentGap = 1
        LandingCFrame = nil
        TweenToGapWithLanding(1, function()
            local char, hum, hrp = SafeGetCharacter()
            if hrp then
                LandingCFrame = hrp.CFrame
            end
        end)
        if GapLabel and GapLabel.Set then
            GapLabel:Set("Current Gap: Gap #1")
        end
    end
})

GapTweenTab:CreateToggle({
    Name = "Auto Gap (Auto advance when near gap)",
    CurrentValue = false,
    Flag = "AutoGap",
    Callback = function(value)
        AutoGapEnabled = value
        if value then
            Rayfield:Notify({
                Title = "Auto Gap Enabled",
                Content = "Will auto-advance to next gap when close",
                Duration = 2,
                Image = "play"
            })
        end
    end
})

GapTweenTab:CreateButton({
    Name = "Unlock Zoom Limits",
    Callback = function()
        LocalPlayer.CameraMaxZoomDistance = 9999
        LocalPlayer.CameraMinZoomDistance = 0
        Rayfield:Notify({
            Title = "Zoom Unlocked",
            Content = "Camera zoom limits removed!",
            Duration = 2,
            Image = "zoom-in"
        })
    end
})

GapTweenTab:CreateLabel("Click 'Reset Gap Data' first, then use Gap Up/Down!")

GapTweenTab:CreateSection("Direct Gap Teleport")

for i = 1, TotalGaps do
    GapTweenTab:CreateButton({
        Name = "Teleport to Gap #" .. tostring(i),
        Callback = function()
            CurrentGap = i
            TweenToGapWithLanding(i)
            if GapLabel and GapLabel.Set then
                GapLabel:Set("Current Gap: Gap #" .. tostring(i))
            end
            Rayfield:Notify({
                Title = "Direct Teleport",
                Content = "Tweening to Gap #" .. tostring(i),
                Duration = 1.5,
                Image = "navigation"
            })
        end
    })
end

task.spawn(function()
    while task.wait(0.5) do
        if AutoGapEnabled and not TweenRunning then
            local char, hum, hrp = SafeGetCharacter()
            if hrp and CurrentGap <= TotalGaps then
                local currentGapPos = GapPositions[CurrentGap]
                if currentGapPos then
                    local distance = (hrp.Position - currentGapPos).Magnitude
                    if distance < 20 and CurrentGap < TotalGaps then
                        CurrentGap = CurrentGap + 1
                        TweenToGapWithLanding(CurrentGap)
                        if GapLabel and GapLabel.Set then
                            GapLabel:Set("Current Gap: Gap #" .. tostring(CurrentGap))
                        end
                    end
                end
            end
        end
    end
end)

local UpgradesTab = Window:CreateTab("Upgrades", "trending-up")

UpgradesTab:CreateSection("Automations")

local RemoteFunctions = ReplicatedStorage:FindFirstChild("RemoteFunctions")
local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")

local CollectMoneyRemote = nil
local UpgradeSpeedRemote = nil
local RebirthRemote = nil
local UpgradeBaseRemote = nil
local UpgradeCarryRemote = nil
local SellAllRemote = nil

if RemoteEvents then
    CollectMoneyRemote = RemoteEvents:FindFirstChild("CollectMoney")
end

if RemoteFunctions then
    UpgradeSpeedRemote = RemoteFunctions:FindFirstChild("UpgradeSpeed")
    RebirthRemote = RemoteFunctions:FindFirstChild("Rebirth")
    UpgradeBaseRemote = RemoteFunctions:FindFirstChild("UpgradeBase")
    UpgradeCarryRemote = RemoteFunctions:FindFirstChild("UpgradeCarry")
    SellAllRemote = RemoteFunctions:FindFirstChild("SellAll")
end

UpgradesTab:CreateToggle({
    Name = "Auto Upgrade Speed",
    Flag = "AutoUpgradeSpeed",
    Callback = function(value)
        AutoUpgradeSpeed = value
    end
})

UpgradesTab:CreateToggle({
    Name = "Auto Upgrade Carry",
    Flag = "AutoUpgradeCarry",
    Callback = function(value)
        AutoUpgradeCarry = value
    end
})

UpgradesTab:CreateToggle({
    Name = "Auto Upgrade Base",
    Flag = "AutoUpgradeBase",
    Callback = function(value)
        AutoUpgradeBase = value
    end
})

UpgradesTab:CreateToggle({
    Name = "Auto Rebirth",
    Flag = "AutoRebirth",
    Callback = function(value)
        AutoRebirth = value
    end
})

UpgradesTab:CreateToggle({
    Name = "Auto Sell All",
    Flag = "AutoSellAll",
    Callback = function(value)
        AutoSellAll = value
    end
})

UpgradesTab:CreateSection("Manual Upgrades")

UpgradesTab:CreateButton({
    Name = "Upgrade Speed Once",
    Callback = function()
        if UpgradeSpeedRemote then
            UpgradeSpeedRemote:InvokeServer()
        end
    end
})

UpgradesTab:CreateButton({
    Name = "Upgrade Carry Once",
    Callback = function()
        if UpgradeCarryRemote then
            UpgradeCarryRemote:InvokeServer()
        end
    end
})

UpgradesTab:CreateButton({
    Name = "Upgrade Base Once",
    Callback = function()
        if UpgradeBaseRemote then
            UpgradeBaseRemote:InvokeServer()
        end
    end
})

UpgradesTab:CreateButton({
    Name = "Rebirth Once",
    Callback = function()
        if RebirthRemote then
            RebirthRemote:InvokeServer()
        end
    end
})

UpgradesTab:CreateButton({
    Name = "Sell All Once",
    Callback = function()
        if SellAllRemote then
            SellAllRemote:InvokeServer()
        end
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if AutoUpgradeSpeed and UpgradeSpeedRemote then
            pcall(function()
                UpgradeSpeedRemote:InvokeServer()
            end)
        end
        if AutoUpgradeCarry and UpgradeCarryRemote then
            pcall(function()
                UpgradeCarryRemote:InvokeServer()
            end)
        end
        if AutoUpgradeBase and UpgradeBaseRemote then
            pcall(function()
                UpgradeBaseRemote:InvokeServer()
            end)
        end
        if AutoRebirth and RebirthRemote then
            pcall(function()
                RebirthRemote:InvokeServer()
            end)
        end
        if AutoSellAll and SellAllRemote then
            pcall(function()
                SellAllRemote:InvokeServer()
            end)
        end
    end
end)

local CombatTab = Window:CreateTab("Combat", "swords")

CombatTab:CreateSection("Hitbox Expander")

local LimbModifier = nil

pcall(function()
    LimbModifier = loadstring(game:HttpGet("https://raw.githubusercontent.com/scripture2025/Scripts/refs/heads/main/Limb"))()({
        USE_HIGHLIGHT = false,
        LISTEN_FOR_INPUT = false
    })
end)

CombatTab:CreateToggle({
    Name = "Enable Hitbox Expander",
    CurrentValue = false,
    Flag = "ModifyLimbs",
    Callback = function(value)
        HitboxEnabled = value
        if LimbModifier and LimbModifier.Set then
            LimbModifier:Set("ENABLED", value)
        end
    end
})

if LimbModifier and LimbModifier.Get then
    local currentKeybind = LimbModifier:Get("TOGGLE") or "F"
    CombatTab:CreateKeybind({
        Name = "Toggle Keybind",
        CurrentKeybind = currentKeybind,
        HoldToInteract = false,
        Flag = "ToggleKeybind",
        Callback = function(keybind)
            if LimbModifier and LimbModifier.Set then
                LimbModifier:Set("TOGGLE", keybind)
            end
        end
    })
end

CombatTab:CreateDivider()

if LimbModifier and LimbModifier.Get then
    local teamCheck = LimbModifier:Get("TEAM_CHECK") or false
    local forcefieldCheck = LimbModifier:Get("FORCEFIELD_CHECK") or false
    local limbCanCollide = LimbModifier:Get("LIMB_CAN_COLLIDE") or false
    local limbTransparency = LimbModifier:Get("LIMB_TRANSPARENCY") or 0.5
    local limbSize = LimbModifier:Get("LIMB_SIZE") or 5
    
    CombatTab:CreateToggle({
        Name = "Team Check",
        CurrentValue = teamCheck,
        Flag = "TeamCheck",
        Callback = function(value)
            if LimbModifier and LimbModifier.Set then
                LimbModifier:Set("TEAM_CHECK", value)
            end
        end
    })
    
    CombatTab:CreateToggle({
        Name = "Forcefield Check",
        CurrentValue = forcefieldCheck,
        Flag = "ForcefieldCheck",
        Callback = function(value)
            if LimbModifier and LimbModifier.Set then
                LimbModifier:Set("FORCEFIELD_CHECK", value)
            end
        end
    })
    
    CombatTab:CreateToggle({
        Name = "Limb Can Collide",
        CurrentValue = limbCanCollide,
        Flag = "LimbCanCollide",
        Callback = function(value)
            if LimbModifier and LimbModifier.Set then
                LimbModifier:Set("LIMB_CAN_COLLIDE", value)
            end
        end
    })
    
    CombatTab:CreateSlider({
        Name = "Limb Transparency",
        Range = {0, 1},
        Increment = 0.1,
        Suffix = "",
        CurrentValue = limbTransparency,
        Flag = "LimbTransparency",
        Callback = function(value)
            if LimbModifier and LimbModifier.Set then
                LimbModifier:Set("LIMB_TRANSPARENCY", value)
            end
        end
    })
    
    CombatTab:CreateSlider({
        Name = "Limb Size",
        Range = {1, 20},
        Increment = 1,
        Suffix = " studs",
        CurrentValue = limbSize,
        Flag = "LimbSize",
        Callback = function(value)
            if LimbModifier and LimbModifier.Set then
                LimbModifier:Set("LIMB_SIZE", value)
            end
        end
    })
end

CombatTab:CreateDivider()

CombatTab:CreateSection("Body Part Selector")

local bodyParts = {"Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "LeftHand", "RightHand", "LeftFoot", "RightFoot"}

local currentTargetLimb = "HumanoidRootPart"
if LimbModifier and LimbModifier.Get then
    currentTargetLimb = LimbModifier:Get("TARGET_LIMB") or "HumanoidRootPart"
end

CombatTab:CreateDropdown({
    Name = "Target Body Part",
    Options = bodyParts,
    CurrentOption = {currentTargetLimb},
    MultipleOptions = false,
    Flag = "TARGET_LIMB",
    Callback = function(option)
        if LimbModifier and LimbModifier.Set then
            LimbModifier:Set("TARGET_LIMB", option[1] or option)
        end
    end
})

CombatTab:CreateLabel("The body part for the Hitbox to be on!")
CombatTab:CreateLabel("Report any bugs if you find one")

local LoopAttackTab = Window:CreateTab("Loop Attack", "repeat")

LoopAttackTab:CreateSection("Loop Attack User")

local PlayerDropdown = LoopAttackTab:CreateDropdown({
    Name = "Select Players",
    Options = GetPlayerList(),
    CurrentOption = {"None"},
    MultipleOptions = true,
    Flag = "PlayerList",
    Callback = function(options)
        SelectedPlayers = options
    end
})

LoopAttackTab:CreateButton({
    Name = "Refresh Player Dropdown",
    Callback = function()
        if PlayerDropdown and PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(GetPlayerList(), true)
        end
    end
})

LoopAttackTab:CreateToggle({
    Name = "Loop Bring",
    Flag = "LoopBring",
    Callback = function(value)
        LoopBringEnabled = value
    end
})

LoopAttackTab:CreateButton({
    Name = "Bring Selected Players Once",
    Callback = function()
        BringSelectedPlayers()
    end
})

LoopAttackTab:CreateSlider({
    Name = "Bring Distance (Studs)",
    Range = {1, 20},
    Increment = 1,
    Suffix = " Studs",
    CurrentValue = 5,
    Flag = "BringDistance",
    Callback = function(value)
        BringDistance = value
    end
})

LoopAttackTab:CreateButton({
    Name = "Select All Players",
    Callback = function()
        SelectedPlayers = GetPlayerList()
        if PlayerDropdown and PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(GetPlayerList(), true)
        end
    end
})

LoopAttackTab:CreateButton({
    Name = "Clear Selection",
    Callback = function()
        SelectedPlayers = {}
    end
})

LoopAttackTab:CreateSection("BETA")

LoopAttackTab:CreateLabel("More tabs & other stuff will be coming soon!")

Players.PlayerAdded:Connect(function(player)
    if PlayerDropdown and PlayerDropdown.Refresh then
        task.wait(0.5)
        PlayerDropdown:Refresh(GetPlayerList(), true)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if PlayerDropdown and PlayerDropdown.Refresh then
        task.wait(0.5)
        PlayerDropdown:Refresh(GetPlayerList(), true)
    end
    for i, name in pairs(SelectedPlayers) do
        if name == player.Name then
            table.remove(SelectedPlayers, i)
            break
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if LoopBringEnabled then
            BringSelectedPlayers()
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), CurrentCamera.CFrame)
end)

local AutoBrainrotTab = Window:CreateTab("Auto Brainrot", "bot")

AutoBrainrotTab:CreateSection("Coming Soon")

AutoBrainrotTab:CreateLabel("I have a method that 100% works, this is in Development.")

Rayfield:LoadConfiguration()

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if FlyEnabled then
        EnableFly()
    end
    if GodModeEnabled then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    end
end)

RunService.Heartbeat:Connect(function()
    local char, hum, hrp = SafeGetCharacter()
    if hum then
        local targetSpeed = LocalPlayer:GetAttribute("CurrentSpeed") or 16
        hum.WalkSpeed = targetSpeed
    end
end)
