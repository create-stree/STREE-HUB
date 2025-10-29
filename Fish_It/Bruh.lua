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
local RF_ChargeRod = net:WaitForChild("RF/ChargeRod") -- Tidak digunakan
local RE_FishingCompleted = net:WaitForChild("RE/FishingCompleted")
local RE_BaitSpawned = net:WaitForChild("RE/BaitSpawned")

---------------------------------- Variables ----------------------------------
_G.Instant = _G.Instant or false

---------------------------------- Core Functions -----------------------------
local function startFishing()
    pcall(function()
        -- HANYA invoke start tanpa charge rod → hindari animasi angin
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

    -- Langsung jalankan tanpa task.wait()
    startFishing()
    completeFishing()
end)

---------------------------------- UI ----------------------------------------
Tab1:Slider({
    Title = "Delay Completed (Tidak Digunakan)",
    Step = 0.01,
    Value = { Min = 0, Max = 1, Default = 0 },
    Callback = function(value)
        -- Tidak digunakan lagi, tapi tetap ada untuk UI
    end,
})

Tab1:Toggle({
    Title = "Auto Instant Fishing (No Delay, No Wind)",
    Value = false,
    Callback = function(state)
        _G.Instant = state
    end,
})
