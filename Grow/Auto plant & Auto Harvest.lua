-- Contoh sederhana: Auto Plant & Auto Harvest untuk Grow a Garden

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 1⃣ Fungsi mengambil semua plot di kebun
local function getPlots()
    local plots = {}
    if workspace:FindFirstChild("GardenPlots") then
        for _, plot in ipairs(workspace.GardenPlots:GetChildren()) do
            table.insert(plots, plot)
        end
    end
    return plots
end

-- 2⃣ Auto tanam bila kosong
local function autoPlant()
    for _, plot in ipairs(getPlots()) do
        if not plot:FindFirstChild("Plant") then
            local plantEvent = ReplicatedStorage:FindFirstChild("PlantSeedEvent")
            if plantEvent then
                plantEvent:FireServer(plot)
            end
        end
    end
end

-- 3⃣ Auto panen bila sudah siap
local function autoHarvest()
    for _, plot in ipairs(getPlots()) do
        local plant = plot:FindFirstChild("Plant")
        if plant and plant:FindFirstChild("IsReady") and plant.IsReady.Value then
            local harvestEvent = ReplicatedStorage:FindFirstChild("HarvestPlantEvent")
            if harvestEvent then
                harvestEvent:FireServer(plot)
            end
        end
    end
end

-- 4⃣ Loop terus menerus
RunService.Heartbeat:Connect(function()
    autoHarvest()
    autoPlant()
end)
