repeat task.wait() until game.Players.LocalPlayer.Character

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local PlantRemote = RemoteEvents:WaitForChild("PlantSeed")
local HarvestEvent = RemoteEvents:WaitForChild("HarvestFruit")
local UseGear = RemoteEvents:WaitForChild("UseGear")
local RemovePlant = RemoteEvents:WaitForChild("RemovePlant")
local SellItems = RemoteEvents:WaitForChild("SellItems")

local Models = ReplicatedStorage.Plants.Models
local ClientPlants = Workspace:WaitForChild("ClientPlants")
local PlotsFolder = Workspace:WaitForChild("Plots")

local State = {
    AutoPlant = false,
    SelectedPlantSeeds = {},
    PlantMode = "Player Position",
    PlantSpeed = 0.1,
    AutoHarvest = false,
    HarvestSelected = {},
    AutoWater = false,
    WaterDelay = 1,
    WaterMode = "Whitelist",
    WaterSelected = {},
    AutoShovel = false,
    ShovelSelected = {},
    AutoSellAll = false,
}

local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/4mVaA8QEMe/refs/heads/main/.lua"))()

local Window = Chloex:Window({
    Title = "NatHub |",
    Footer = "Version Dev | Garden Horizons",
    Image = "99764942615873",
    Color = Color3.fromRGB(0,208,255),
    Theme = 9542022979,
    Version = 1
})

local Tabs = {
    Main = Window:AddTab({ Name = "Main", Icon = "menu" }),
    Automatic = Window:AddTab({ Name = "Automatic", Icon = "star" }),
    Farm = Window:AddTab({ Name = "Farm", Icon = "compas"}),
    Shop = Window:AddTab({ Name = "Shop", Icon = "shop" }),
    Web = Window:AddTab({ Name = "Webhook", Icon = "web" }),
    Misc = Window:AddTab({ Name = "Misc", Icon = "settings" })
}

local x1 = Tabs.Main:AddSection("Information")

x1:AddParagraph({
    Title = "NatHub Discord",
    Content = "Join our discord server!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then 
            setclipboard("https://discord.gg/nathub") 
        end
    end
})

x1:AddParagraph({
    Title = "Information",
    Content = "This game script is still in beta. If you encounter any issues or problems with it, please report them immediately on Discord.",
    Icon = "star",
})

local x2 = Tabs.Automatic:AddSection("Auto Plant")

local seedOptions = {}
for _, model in pairs(Models:GetChildren()) do
    table.insert(seedOptions, model.Name)
end

x2:AddDropdown({
    Title = "Plant Mode",
    Content = "Select the planting mode.",
    Multi = false,
    Options = {"Player Position", "Random Around Player"},
    Default = "Player Position",
    Callback = function(selected)
        State.PlantMode = selected 
    end
})

x2:AddDropdown({
    Title = "Select Seeds",
    Content = "Select the seed you want to plant.",
    Multi = true,
    Options = seedOptions,
    Default = {},
    Callback = function(selected) 
        State.SelectedPlantSeeds = selected 
    end
})

x2:AddSlider({
    Title = "Plant Speed",
    Content = "Adjust planting speed (lower = faster)",
    Min = 0.01, Max = 2, Increment = 0.01, Default = 0.1,
    Callback = function(value)
        State.PlantSpeed = value 
    end
})

x2:AddToggle({
    Title = "Auto Plant",
    Content = "Activate auto plant seeds",
    Default = false,
    Callback = function(state) 
        State.AutoPlant = state 
    end
})

task.spawn(function()
    while true do
        task.wait(0.01)
        if State.AutoPlant and #State.SelectedPlantSeeds > 0 then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local basePos = character.HumanoidRootPart.Position
                for _, seedName in ipairs(State.SelectedPlantSeeds) do
                    local plantPos
                    if State.PlantMode == "Player Position" then
                        plantPos = basePos
                    else
                        local randomX = math.random(-5,5)
                        local randomZ = math.random(-5,5)
                        plantPos = basePos + Vector3.new(randomX, 0, randomZ)
                    end
                    local args = { seedName, plantPos }
                    PlantRemote:InvokeServer(unpack(args))
                    task.wait(State.PlantSpeed)
                end
            end
        end
    end
end)

local x3 = Tabs.Automatic:AddSection("Auto Harvest")

local plantOptions = {"All Plant"}
for _, model in pairs(Models:GetChildren()) do
    table.insert(plantOptions, model.Name)
end

x3:AddDropdown({
    Title = "Select Harvest",
    Content = "Select the plants you want to harvest",
    Options = plantOptions,
    Multi = true,
    Default = {},
    Callback = function(selected) 
        State.HarvestSelected = selected 
    end
})

local function FindPlayerPlot()
    for _, plot in pairs(PlotsFolder:GetChildren()) do
        if plot:FindFirstChild("Owner") then
            if plot:GetAttribute("Owner") == LocalPlayer.UserId then return plot end
        end
    end
    return nil
end

local function TeleportTo(position)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
    end
end

local function GetPlantBaseName(plantName)
    return plantName:match("^(%a+)%d*$")
end

local function IsFruitPlant(plantName)
    local baseName = GetPlantBaseName(plantName)
    local model = Models:FindFirstChild(baseName)
    return model and model:FindFirstChild("FruitFolder") ~= nil
end

local function IsReadyToHarvest(target)
    local fullyGrown = target:GetAttribute("FullyGrown")
    if fullyGrown ~= nil then return fullyGrown end
    local growthHealth = target:GetAttribute("GrowthHealth")
    local growthMaxHealth = target:GetAttribute("GrowthMaxHealth")
    if not growthHealth or not growthMaxHealth then return false end
    return math.abs(growthHealth - growthMaxHealth) < 0.001
end

local function IsPlantSelected(plant, hasPlant, allPlant)
    if not hasPlant then return true end
    if allPlant then return true end
    for _, selectedName in pairs(State.HarvestSelected) do
        if plant.Name:match("^" .. selectedName .. "%d*$") then return true end
    end
    return false
end

local function FireBatch(batch)
    local ChunkSize = 5
    for i = 1, #batch, ChunkSize do
        local chunk = {}
        for j = i, math.min(i + ChunkSize - 1, #batch) do
            table.insert(chunk, batch[j])
        end
        HarvestEvent:FireServer(chunk)
        task.wait(0.1)
    end
end

x3:AddToggle({
    Title = "Auto Harvest",
    Default = false,
    Callback = function(value)
        State.AutoHarvest = value
        if value then
            task.spawn(function()
                while State.AutoHarvest do
                    local hasPlant = #State.HarvestSelected > 0
                    local allPlant = false
                    for _, v in pairs(State.HarvestSelected) do
                        if v == "All Plant" then allPlant = true break end
                    end
                    if not hasPlant then task.wait(0.5) continue end
                    local plot = FindPlayerPlot()
                    if not plot then task.wait(3) continue end
                    TeleportTo(plot:GetPivot().Position)
                    task.wait(0.5)
                    local harvestBatch = {}
                    for _, plant in pairs(ClientPlants:GetChildren()) do
                        if plant.Parent ~= plot then continue end
                        if not IsPlantSelected(plant, hasPlant, allPlant) then continue end
                        if plant:GetAttribute("Favorited") == true then continue end
                        if IsFruitPlant(plant.Name) then
                            for _, fruit in pairs(plant:GetChildren()) do
                                if fruit.Name:match("^Fruit%d+$") and fruit:GetAttribute("Favorited") ~= true and IsReadyToHarvest(fruit) then
                                    local rawUuid = fruit:GetAttribute("Uuid")
                                    if rawUuid then
                                        local cleanUuid = rawUuid:match("^([^:]+)")
                                        local growthIndex = fruit:GetAttribute("GrowthAnchorIndex") or 1
                                        table.insert(harvestBatch, { Uuid = cleanUuid, GrowthAnchorIndex = growthIndex })
                                    end
                                end
                            end
                        else
                            if IsReadyToHarvest(plant) then
                                local rawUuid = plant:GetAttribute("Uuid")
                                if rawUuid then
                                    local cleanUuid = rawUuid:match("^([^:]+)")
                                    table.insert(harvestBatch, { Uuid = cleanUuid })
                                end
                            end
                        end
                    end
                    if #harvestBatch > 0 then FireBatch(harvestBatch) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local x4 = Tabs.Automatic:AddSection("Auto Watering")

x4:AddDropdown({
    Title = "Water Mode",
    Default = "Whitelist",
    Multi = false,
    Options = {"Whitelist", "Blacklist"},
    Callback = function(selected) 
        aState.WaterMode = selected 
    end
})

x4:AddDropdown({
    Title = "Select Plant To Water",
    Default = {},
    Multi = true,
    Options = seedOptions,
    Callback = function(selected) 
      State.WaterSelected = selected 
  end
})

x4:AddToggle({
    Title = "Auto Water Plants",
    Default = false,
    Callback = function(state)
        State.AutoWater = state
        if state then
            task.spawn(function()
                while State.AutoWater do
                    local plot = FindPlayerPlot()
                    if plot then
                        for _, plant in pairs(ClientPlants:GetChildren()) do
                            if not State.AutoWater then break end
                            if plant.Parent ~= plot then continue end
                            local selected = false
                            local cleanName = plant.Name:gsub("%d+",""):lower()
                            for _, seed in ipairs(State.WaterSelected) do
                                if cleanName == seed:lower() then selected = true break end
                            end
                            if State.WaterMode == "Whitelist" and not selected then continue end
                            if State.WaterMode == "Blacklist" and selected then continue end
                            local args = { "Watering Can", { position = plant:GetPivot().Position } }
                            pcall(function() UseGear:FireServer(unpack(args)) end)
                            task.wait(State.WaterDelay)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

x4:AddInput({
    Title = "Water Delay",
    Default = 1,
    Suffix = "s",
    Callback = function(value) 
        local val = tonumber(value)
            if val then State.WaterDelay = val 
        end
    end
})

local x5 = Tabs.Automatic:AddSection("Auto Shovel")

x5:AddDropdown({
    Title = "Select Plant To Shovel",
    Default = {},
    Multi = true,
    Options = seedOptions,
    Callback = function(selected) 
      State.ShovelSelected = selected 
    end
})

x5:AddToggle({
    Title = "Auto Shovel Plants",
    Default = false,
    Callback = function(state)
        State.AutoShovel = state
        if state then
            task.spawn(function()
                while State.AutoShovel do
                    for _, plant in ipairs(ClientPlants:GetChildren()) do
                        if not State.AutoShovel then break end
                        local selected = false
                        local cleanName = plant.Name:gsub("%d+",""):lower()
                        for _, seed in ipairs(State.ShovelSelected) do
                            if cleanName == seed:lower() then selected = true break end
                        end
                        if not selected then continue end
                        local uuid = plant:GetAttribute("Uuid")
                        if uuid then
                            pcall(function() RemovePlant:FireServer(uuid) end)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

local x6 = Tabs.Main:AddSection("Auto Sell")

local SellPos = CFrame.new(149.40, 204.01, 672.00)
local function teleport(cf)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CFrame = cf
end

local function sell(mode)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local old = root.CFrame
    teleport(SellPos)
    task.wait(0.6)
    SellItems:InvokeServer(mode)
    task.wait(0.6)
    teleport(old)
end

x6:AddToggle({
    Title = "Auto Sell All",
    Content = "Automatically sell all items periodically",
    Default = false,
    Callback = function(state)
        State.AutoSellAll = state
        if state then
            task.spawn(function()
                while State.AutoSellAll do
                    task.wait(2)
                    if State.AutoSellAll then sell("SellAll") end
                end
            end)
        end
    end
})

x6:AddButton({
    Title = "Sell Single",
    Callback = function() 
      sell("SellSingle") 
  end
})
