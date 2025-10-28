--====================================================--
--===[ AUTO FISHING - WINDUI LOOP FIXED ]==============--
--====================================================--

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "MyHub",
    Icon = "fish", -- lucide icon. optional
    Author = "Nigga", -- optional
})

local Tab = Window:Tab({
Title = "Main",
Icon = "anchor",
})

---------------------------------- Remotes ------------------------------------
local function lempar()
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/RequestFishingMinigameStarted"):InvokeServer(-1.233184814453125, 0.9966885368402592, 1761532005.497536)
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/ChargeFishingRod"):InvokeServer()
end
local function catch()
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/FishingCompleted"):FireServer()
end

local function instant()
    while _G.AutoFarm do
        task.wait(0)
        for i = 1, 10 do
            charge()
            task.wait(0)
            lempar()
            task.wait(0)
        end
        task.wait(delayfishing)
        for i = 1, 10 do
            catch()
            task.wait(0)
        end
        task.wait(0)
    end
end
---------------------------------- AutoFarm Logic -----------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local REBaitSpawned = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/BaitSpawned"]
    REBaitSpawned.OnClientEvent:Connect(function(playerWhoSpawned, baitName, position)
        if _G.Instant then
            wait(0)        
            pcall(function()
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]:InvokeServer(2)
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]:InvokeServer(-1.25, 0.2)
            end)
            task.wait(completed_delay)
            pcall(function()
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]:FireServer(1)
            end)
        end
    end)


---------------------------------- UI ----------------------------------------

Tab:Slider({
Title = "Delay Completed",
Step = 0.01,
Value = { Min = 0, Max = 10, Default = completed_delay },
Callback = function(value)
completed_delay = value
end,
})

Tab:Slider({
Title = "Delay Cancel",
Step = 0.01,
Value = { Min = 0, Max = 10, Default = cancel_delay },
Callback = function(value)
cancel_delay = value
end,
})

Tab:Toggle({
Title = "AutoFarm",
Value = false,
Callback = function(state)
_G.Instant = state
end,
})

local Button = Tab:Button({
    Title = "Completed",
    Desc = "Test Button",
    Locked = false,
    Callback = function()
        catch()
    end
})  
