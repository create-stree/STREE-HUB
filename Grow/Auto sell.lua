-- Auto Sell untuk Grow A Garden
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Ganti "SellItemsEvent" dengan nama event yang asli di game
local sellEvent = ReplicatedStorage:FindFirstChild("SellItemsEvent")

-- Interval auto sell (detik)
local sellInterval = 2

if sellEvent then
    task.spawn(function()
        while task.wait(sellInterval) do
            sellEvent:FireServer()
        end
    end)
else
    warn("⚠️ Sell event tidak ditemukan, periksa nama RemoteEvent-nya.")
end
