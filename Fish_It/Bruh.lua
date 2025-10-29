--====================================================--
--===[ AUTO FISHING - WINDUI LOOP FIXED ]==============--
--====================================================--

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "MyHub",
    Icon = "fish", -- lucide icon. optional
    Author = "Nigga", -- optional
})

local Tab1 = Window:Tab({
Title = "Main",
Icon = "anchor",
})

---------------------------------- Services -----------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local net = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

---------------------------------- Remote References --------------------------
local RF_RequestStart = net:WaitForChild("RF/RequestFishingMinigameStarted")
local RF_ChargeRod = net:WaitForChild("RF/ChargeFishingRod")
local RE_FishingCompleted = net:WaitForChild("RE/FishingCompleted")
local RE_BaitSpawned = net:WaitForChild("RE/BaitSpawned")

---------------------------------- Variables ----------------------------------
_G.Instant = _G.Instant or false
_G.completed_delay = _G.completed_delay or 0.01

---------------------------------- Core Functions -----------------------------
local function startFishing()
    pcall(function()
        RF_ChargeRod:InvokeServer(2)
        RF_RequestStart:InvokeServer(-1.25, 0.2)
    end)
end

local function completeFishing()
    pcall(function()
        RE_FishingCompleted:FireServer(1)
    end)
end

---------------------------------- Auto Instant Logic -------------------------
RE_BaitSpawned.OnClientEvent:Connect(function(_, baitName, position)
    if not _G.Instant then return end

    task.spawn(function()
        startFishing()
        task.wait(_G.completed_delay)
        completeFishing()
    end)
end)

---------------------------------- UI ----------------------------------------
Tab1:Slider({
    Title = "Delay Completed",
    Step = 0.01,
    Value = { Min = 0, Max = 10, Default = _G.completed_delay },
    Callback = function(value)
        _G.completed_delay = value
    end,
})

Tab1:Toggle({
    Title = "Auto Instant Fishing",
    Value = false,
    Callback = function(state)
        _G.Instant = state
    end,
})
