-- Auto Watering untuk Grow A Garden
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Nama folder tanaman di workspace (ganti sesuai game)
local GardenFolder = workspace:FindFirstChild("GardenPlots")

-- Remote event untuk menyiram (ganti sesuai nama di game)
local waterEvent = ReplicatedStorage:FindFirstChild("WaterPlantEvent")

-- Interval cek (detik)
local checkInterval = 1

local function autoWater()
    if GardenFolder and waterEvent then
        for _, plot in ipairs(GardenFolder:GetChildren()) do
            local plant = plot:FindFirstChild("Plant")
            if plant and plant:FindFirstChild("NeedsWater") then
                if plant.NeedsWater.Value == true then
                    waterEvent:FireServer(plot)
                end
            end
        end
    else
        warn("⚠️ Folder kebun atau event watering tidak ditemukan.")
    end
end

-- Jalankan terus setiap interval
task.spawn(function()
    while task.wait(checkInterval) do
        autoWater()
    end
end)
