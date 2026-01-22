local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/Source.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
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
    
local chargeRod = NetService:WaitForChild("RF/ChargeFishingRod")
local startMinigame = NetService:WaitForChild("RF/RequestFishingMinigameStarted")
local completeFishing = NetService:WaitForChild("RE/FishingCompleted")
local cancelFishing = NetService:WaitForChild("RF/CancelFishingInputs")

local autoFishThread

local function fishingThread()
    if autoFishThread then return end
    autoFishThread = task.spawn(function()
        while Config.AutoFishInstant do
            task.spawn(function()
                pcall(function()
                    chargeRod:InvokeServer(math.huge)
                    startMinigame:InvokeServer(-1, 0.1)
                end)
            end)
            
            task.spawn(function()
                task.wait(Config.InstantCompleteDelay)
                if Config.AutoFishInstant then
                    pcall(completeFishing.FireServer, completeFishing)
                end
            end)
            
            task.spawn(function()
                task.wait(Config.InstantCancelDelay)
                if Config.AutoFishInstant then
                    pcall(function()
                        cancelFishing:InvokeServer()
                    end)
                end
            end)
            
            task.wait(0.75)
        end
        
        task.spawn(function()
            pcall(function()
                cancelFishing:InvokeServer()
            end)
        end)
        
        autoFishThread = nil
    end)
end

local function startAutoFish()
    if Config.AutoFishInstant then
        fishingThread()
    end
end

local Window = Library:MakeGui({
    NameHub = "StreeHub",
    Description = "| Blatant",
    Color = Color3.fromRGB(57, 255, 20)
})

local mainTab = Window:CreateTab({ Name = "Main" })
local Section = mainTab:AddSection("Auto Farm")

Section:AddToggle({
    Title = "Instant Fishing",
    Default = false,
    Callback = function(state)
        Config.AutoFishInstant = state
        if state then
            startAutoFish()
        else
            if autoFishThread then
                task.cancel(autoFishThread)
                autoFishThread = nil
            end
        end
    end
})

Section:AddInput({
    Title = "Reel Delay",
    Content = "Cancel Delay",
    Placeholder = "write number"
    Default = tostring(Config.InstantCancelDelay),
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.InstantCancelDelay = n
        end
    end
})

Section:AddInput({
    Title = "Bait Delay",
    Content = "Completed Delay",
    Placeholder = "write number"
    Default = tostring(Config.InstantCompleteDelay),
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.InstantCompleteDelay = n
        end
    end
})

local animConnections = {}

local function setNoAnim(state)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    for _, c in ipairs(animConnections) do
        c:Disconnect()
    end
    table.clear(animConnections)

    if state then
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            t:Stop(0)
        end

        table.insert(animConnections,
            animator.AnimationPlayed:Connect(function(track)
                task.defer(function()
                    track:Stop(0)
                end)
            end)
        )
    end
end

Section:AddToggle({
    Title = "No Animation",
    Value = false,
    Callback = setNoAnim
})

local notifConn
Section:AddToggle({
    Title = "Remove Fish Notification Pop-up",
    Value = false,
    Callback = function(state)
        local gui = LocalPlayer:WaitForChild("PlayerGui")
        local notif = gui:FindFirstChild("Small Notification")
        if not notif then return end

        if state then
            notifConn = RunService.RenderStepped:Connect(function()
                notif.Enabled = false
            end)
        else
            if notifConn then
                notifConn:Disconnect()
                notifConn = nil
            end
            notif.Enabled = true
        end
    end
})
