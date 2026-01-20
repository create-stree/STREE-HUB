local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game.Players.LocalPlayer

local Config = {
    AutoFishInstant = false,
    InstantCancelDelay = 1.7,
    InstantCompleteDelay = 1.4
}

local NetService = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local chargeRod        = NetService:WaitForChild("RF/ChargeFishingRod")
local startMinigame    = NetService:WaitForChild("RF/RequestFishingMinigameStarted")
local completeFishing  = NetService:WaitForChild("RE/FishingCompleted")
local cancelFishing    = NetService:WaitForChild("RF/CancelFishingInputs")

local autoFishThread

-- Thread gabungan: Cast, Complete, dan Cancel
local function fishingThread()
    if autoFishThread then return end
    autoFishThread = task.spawn(function()
        while Config.AutoFishInstant do
           -- Cast fishing
            task.spawn(function()
                pcall(function()
                    chargeRod:InvokeServer(math.huge)
                    startMinigame:InvokeServer(-1, 0.1)
                end)
            end)

            -- Complete fishing
            task.spawn(function()
                task.wait(Config.InstantCompleteDelay)
                if Config.AutoFishInstant then
                    pcall(completeFishing.FireServer, completeFishing)
                end
            end)

            -- Cancel fishing
            task.spawn(function()
                task.wait(Config.InstantCancelDelay)
                if Config.AutoFishInstant then
                    pcall(function()
                        cancelFishing:InvokeServer()
                    end)
                end
            end)      
            task.wait(0.25)
        end

        -- Cancel di akhir thread
        task.spawn(function()
            pcall(function()
                cancelFishing:InvokeServer()
            end)
        end)
        autoFishThread = nil
    end)
end

local function startAutoFish_Instant()
    fishingThread()
end

local player = game.Players.LocalPlayer
player:WaitForChild("PlayerGui")

local function GetRemote(folder, name)
    if typeof(folder) ~= "Instance" then return nil end
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj.Name == name then
            return obj
        end
    end
    return nil
end

local RPath = game:GetService("ReplicatedStorage")

local Window = WindUI:CreateWindow({
    Title = "StreeHub - Blantant",
    Size = UDim2.fromOffset(320, 230),
    ToggleKey = Enum.KeyCode.RightShift
})

local mainTab = Window:Tab({ Title = "Main" })

mainTab:Section({ Title = "Auto Farm" })

mainTab:Toggle({
    Title = "Instant Fishing",
    Value = false,
    Callback = function(state)
        Config.AutoFishInstant = state
        if state then
            startAutoFish_Instant()
        end
    end
})

mainTab:Input({
    Title = "Cancel Delay",
    Default = tostring(Config.InstantCancelDelay),
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.InstantCancelDelay = n
        end
    end
})

mainTab:Input({
    Title = "Complete Delay",
    Default = tostring(Config.InstantCompleteDelay),
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.InstantCompleteDelay = n
        end
    end
})

local stopAnimConnections = {}

local function setAnim(v)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, c in ipairs(stopAnimConnections) do c:Disconnect() end
    stopAnimConnections = {}

    if v then
        for _, t in ipairs(hum:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
            t:Stop(0)
        end
        local c = hum:FindFirstChildOfClass("Animator").AnimationPlayed:Connect(function(t)
            task.defer(function() t:Stop(0) end)
        end)
        table.insert(stopAnimConnections, c)
    else
        for _, c in ipairs(stopAnimConnections) do c:Disconnect() end
        stopAnimConnections = {}
    end
end

mainTab:Toggle({
    Title = "No Animation",
    Desc = "",
    Value = false,
    Callback = setAnim
})

local RunService = game:GetService("RunService")
local DisableNotificationConnection

mainTab:Toggle({
    Title = "Remove Fish Notification Pop-up",
    Value = false,
    Icon = "slash",
    Callback = function(state)
        local PlayerGui = player:WaitForChild("PlayerGui")
        local SmallNotification = PlayerGui:FindFirstChild("Small Notification")

        if not SmallNotification then
            SmallNotification = PlayerGui:WaitForChild("Small Notification", 5)
            if not SmallNotification then
                WindUI:Notify({ Title = "Error", Duration = 3, Icon = "x" })
                return
            end
        end

        if state then
            DisableNotificationConnection = RunService.RenderStepped:Connect(function()
                SmallNotification.Enabled = false
            end)

            WindUI:Notify({
                Title = "Pop-up Diblokir",
                Duration = 3,
                Icon = "check"
            })
        else
            if DisableNotificationConnection then
                DisableNotificationConnection:Disconnect()
                DisableNotificationConnection = nil
            end

            SmallNotification.Enabled = true

            WindUI:Notify({
                Title = "Pop-up Diaktifkan",
                Content = "Notifikasi kembali normal.",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})
