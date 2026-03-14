repeat task.wait() until game.Players.LocalPlayer.Character

local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Garden Horizons",
    Images  = "122683047852451",
    Color   = Color3.fromRGB(57, 255, 20),
    Theme   = 9542022979,
    ThemeTransparency = 0.15,
    ["Tab Width"] = 120,
    Version = 1,
})

local Tabs = {
    Info = Window:AddTab({ Name = "Info", Icon = "info" }),
    Main = Window:AddTab({ Name = "Main", Icon = "landmark" }),
    Bag = Window:AddTab({ Name = "Backpack", Icon = "bag" }),
    Quest = Window:AddTab({ Name = "Quest", Icon = "menu" }),
    Shop = Window:AddTab({ Name = "Shop", Icon = "shop" }),
    Web = Window:AddTab({ Name = "Webhook", Icon = "web" }),
    Teleport = Window:AddTab({ Name = "Teleport", Icon = "gps" }),
    Misc = Window:AddTab({ Name = "Misc", Icon = "settings" }),
}

local y1 = Tabs.Info:AddSection("Information")

y1:AddParagraph({
    Title = "Discord",
    Content = "Join Us!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/jdmX43t5mY"
        if setclipboard then
            setclipboard(link)
        end
    end
})

local x1 = Tabs.Main:AddSection("Play Game")

x1:AddButton({
    Title = "Get Available Plots",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.GetAvailablePlots
        Event:InvokeServer()
    end
})

x1:AddButton({
    Title = "Set Streaming Focus Start",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.SetStreamingFocus
        Event:FireServer("start", Vector3.new(163.88566589355, 245.42060852051, 547.02850341797))
    end
})

x1:AddButton({
    Title = "Set Streaming Focus Update",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.SetStreamingFocus
        Event:FireServer("update", Vector3.new(164.29084777832, 305.36993408203, 378.87240600586))
    end
})

local PlotSection = Tabs.Main:AddSection("Plot")

local v_u = PlotSection:AddDropdown({
    Title = "Select Plot",
    Options = { "Plot1", "Plot2", "Plot3", "Plot4", "Plot5", "Plot6" },
    Default = "Plot1",
    Callback = function(value)
        _G.selectedPlot = value
    end
})

PlotSection:AddButton({
    Title = "Claim Plot",
    Callback = function()
        local plot = _G.selectedPlot or "Plot1"
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.ClaimSelectedPlot
        Event:FireServer(plot)
    end
})

local PlantSection = Tabs.Main:AddSection("Plant Seed")

_G.AutoPlant = false
_G.SelectedPlantSeeds = {}
_G.PlantMode = "Player Position"
_G.PlantSpeed = 0.1

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlantRemote = ReplicatedStorage
    :WaitForChild("RemoteEvents")
    :WaitForChild("PlantSeed")

local u_q1 = PlantSection:AddDropdown({
    Title = "Plant Mode",
    Content = "Select the planting mode.",
    Multi = false,
    Options = {
        "Player Position",
        "Random Around Player"
    },
    Default = "Player Position",
    Callback = function(selected)
        _G.PlantMode = selected
    end
})

local u_q1 = PlantSection:AddDropdown({
    Title = "Select Seeds",
    Content = "Select the seed you want to plant.",
    Multi = true,
    Options = {
        "Carrot",
        "Corn",
        "Onion",
        "Strawberry",
        "Mushroom",
        "Beetroot",
        "Tomato",
        "Apple",
        "Rose",
        "Wheat",
        "Banana",
        "Plum",
        "Potato",
        "Cabbage",
        "Cherry",
        "Birch",
        "Dawnfruit",
        "Bellpepper",
        "Dandelion",
        "Goldenberry",
        "Sunpetal",
        "Garlic",
        "Orange",
        "Amberpine",
        "Emberwood",
    },
    Default = {},
    Callback = function(selected)
        _G.SelectedPlantSeeds = selected
    end
})

local u_q1 = PlantSection:AddSlider({
    Title = "Plant Speed",
    Content = "Adjust planting speed (lower = faster)",
    Min = 0.01,
    Max = 2,
    Increment = 0.01,
    Default = 0.1,
    Callback = function(value)
        _G.PlantSpeed = value
    end
})

local u_q1 = PlantSection:AddToggle({
    Title = "Auto Plant",
    Content = "Activate auto plant seeds",
    Default = false,
    Callback = function(state)
        _G.AutoPlant = state
    end
})

task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoPlant and #_G.SelectedPlantSeeds > 0 then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local basePos = character.HumanoidRootPart.Position
                for _, seedName in ipairs(_G.SelectedPlantSeeds) do
                    local plantPos
                    if _G.PlantMode == "Player Position" then
                        plantPos = basePos
                    else
                        local randomX = math.random(-5,5)
                        local randomZ = math.random(-5,5)
                        plantPos = basePos + Vector3.new(randomX, 0, randomZ)
                    end
                    local args = { seedName, plantPos }
                    PlantRemote:InvokeServer(unpack(args))
                    task.wait(_G.PlantSpeed)
                end
            end
        end
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    hrp = character:WaitForChild("HumanoidRootPart")
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Models = ReplicatedStorage.Plants.Models
local HarvestEvent = ReplicatedStorage.RemoteEvents.HarvestFruit
local PlantData = require(ReplicatedStorage:WaitForChild("Plants"):WaitForChild("Definitions"):WaitForChild("PlantDataDefinitions"))

local ClientPlants = workspace:WaitForChild("ClientPlants")
local PlotsFolder = workspace:WaitForChild("Plots")

local PlantOptions = {"All Plant"}
for _, model in pairs(Models:GetChildren()) do
    table.insert(PlantOptions, model.Name)
end

local SelectedPlants = {}
local ChunkSize = 5
local HarvestLoop = nil

local function FindPlayerPlot()
    for _, plot in pairs(PlotsFolder:GetChildren()) do
        if plot:FindFirstChild("Owner") then
            if plot:GetAttribute("Owner") == LocalPlayer.UserId then
                return plot
            end
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
    if fullyGrown ~= nil then
        return fullyGrown == true
    end
    local growthHealth = target:GetAttribute("GrowthHealth")
    local growthMaxHealth = target:GetAttribute("GrowthMaxHealth")
    if not growthHealth or not growthMaxHealth then return false end
    return math.abs(growthHealth - growthMaxHealth) < 0.001
end

local function IsPlantSelected(plant, hasPlant, allPlant)
    if not hasPlant then return true end
    if allPlant then return true end
    for _, selectedName in pairs(SelectedPlants) do
        if plant.Name:match("^" .. selectedName .. "%d*$") then
            return true
        end
    end
    return false
end

local function FireBatch(batch)
    for i = 1, #batch, ChunkSize do
        local chunk = {}
        for j = i, math.min(i + ChunkSize - 1, #batch) do
            table.insert(chunk, batch[j])
        end
        HarvestEvent:FireServer(chunk)
        task.wait(0.1)
    end
end

local function GetFilterFlags()
    local hasPlant = #SelectedPlants > 0
    local allPlant = false
    for _, v in pairs(SelectedPlants) do
        if v == "All Plant" then allPlant = true break end
    end
    return hasPlant, allPlant
end

local FarmSection = Tabs.Main:AddSection("Harvest")

FarmSection:AddDropdown({
    Title = "Select Plant (Harvest)",
    Content = "Select the plants you want to harvest",
    Options = PlantOptions,
    Multi = true,
    Default = {},
    Callback = function(selectedTable)
        SelectedPlants = selectedTable
    end
})

FarmSection:AddToggle({
    Title = "Auto Harvest",
    Default = false,
    Callback = function(value)
        if value then
            HarvestLoop = task.spawn(function()
                while value do
                    local hasPlant, allPlant = GetFilterFlags()
                    if not hasPlant then
                        task.wait(0.5)
                        continue
                    end

                    local plot = FindPlayerPlot()
                    if not plot then
                        task.wait(3)
                        continue
                    end

                    TeleportTo(plot:GetPivot().Position)
                    task.wait(0.5)

                    local harvestBatch = {}

                    for _, plant in pairs(ClientPlants:GetChildren()) do
                        if plant.Parent ~= plot then continue end
                        if not IsPlantSelected(plant, hasPlant, allPlant) then continue end
                        if plant:GetAttribute("Favorited") == true then continue end

                        local isFruitPlant = IsFruitPlant(plant.Name)
                        if isFruitPlant then
                            for _, fruit in pairs(plant:GetChildren()) do
                                if fruit.Name:match("^Fruit%d+$") and fruit:GetAttribute("Favorited") ~= true and IsReadyToHarvest(fruit) then
                                    local rawUuid = fruit:GetAttribute("Uuid")
                                    if rawUuid then
                                        local cleanUuid = rawUuid:match("^([^:]+)")
                                        local growthIndex = fruit:GetAttribute("GrowthAnchorIndex") or 1
                                        table.insert(harvestBatch, {
                                            Uuid = cleanUuid,
                                            GrowthAnchorIndex = growthIndex
                                        })
                                    end
                                end
                            end
                        else
                            if IsReadyToHarvest(plant) then
                                local rawUuid = plant:GetAttribute("Uuid")
                                if rawUuid then
                                    local cleanUuid = rawUuid:match("^([^:]+)")
                                    table.insert(harvestBatch, {
                                        Uuid = cleanUuid
                                    })
                                end
                            end
                        end
                    end

                    if #harvestBatch > 0 then
                        FireBatch(harvestBatch)
                    end

                    task.wait(0.5)
                end
            end)
        else
            if HarvestLoop then
                task.cancel(HarvestLoop)
                HarvestLoop = nil
            end
        end
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local UseGear = RemoteEvents:WaitForChild("UseGear")
local DataseedsFolder = ReplicatedStorage.Plants.Models

local AutoWateringSection = Tabs.Main:AddSection("Watering")

local waterOptions = {}
for _, seed in ipairs(DataseedsFolder:GetChildren()) do
    table.insert(waterOptions, seed.Name)
end

local _G_Water = {
    AutoWater = false,
    Delay = 1,
    Mode = "Whitelist",
    SelectedSeed = {}
}

local function waterAt(pos)
    local args = {
        "Watering Can",
        { position = pos }
    }
    pcall(function()
        UseGear:FireServer(unpack(args))
    end)
end

local function isPlantSelected(plantName)
    if type(plantName) ~= "string" then return false end
    if type(_G_Water.SelectedSeed) ~= "table" then return false end
    if #_G_Water.SelectedSeed == 0 then return false end

    local cleanName = plantName:gsub("%d+",""):lower()

    for _, seed in ipairs(_G_Water.SelectedSeed) do
        if type(seed) == "string" then
            if cleanName == seed:lower() then
                return true
            end
        end
    end

    return false
end

local function startAutoWater()
    while _G_Water.AutoWater do
        local plot = getOurPlot()
        local plantContainer = workspace:FindFirstChild("ClientPlants") or (plot and plot:FindFirstChild("Plants"))

        if plantContainer then
            for _, plant in ipairs(plantContainer:GetDescendants()) do
                if not _G_Water.AutoWater then break end

                if plant:IsA("Model") then
                    local selected = isPlantSelected(plant.Name)

                    if _G_Water.Mode == "Whitelist" then
                        if not selected then continue end
                    elseif _G_Water.Mode == "Blacklist" then
                        if selected then continue end
                    end

                    waterAt(plant:GetPivot().Position)
                    task.wait(_G_Water.Delay)
                end
            end
        end
        task.wait(0.5)
    end
end

AutoWateringSection:AddDropdown({
    Title = "Water Mode",
    Default = "Whitelist",
    Multi = false,
    Options = {"Whitelist", "Blacklist"},
    Callback = function(state)
        _G_Water.Mode = state
    end
})

AutoWateringSection:AddDropdown({
    Title = "Select Plant To Water",
    Default = {},
    Multi = true,
    Options = waterOptions,
    Callback = function(state)
        _G_Water.SelectedSeed = state
    end
})

AutoWateringSection:AddToggle({
    Title = "Auto Water Plants",
    Default = false,
    Callback = function(state)
        _G_Water.AutoWater = state
        if state then
            task.spawn(startAutoWater)
        end
    end
})

AutoWateringSection:AddInput({
    Title = "Water Delay",
    Default = 1,
    Suffix = "s",
    Callback = function(state)
        local val = tonumber(state)
        if val then
            _G_Water.Delay = val
        end
    end
})

AutoShovelSection = Tabs.Main:AddSection("Shovel")

local RemovePlant = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RemovePlant")

local _G_Shovel = {
    AutoShovel = false,
    SelectedSeed = {}
}

local function isPlantSelected(plantName)
    if type(plantName) ~= "string" then return false end
    if type(_G_Shovel.SelectedSeed) ~= "table" then return false end
    if #_G_Shovel.SelectedSeed == 0 then return false end

    local cleanName = plantName:gsub("%d+",""):lower()

    for _, seed in ipairs(_G_Shovel.SelectedSeed) do
        if type(seed) == "string" then
            if cleanName == seed:lower() then
                return true
            end
        end
    end

    return false
end

local function fireShovel(uuid)
    pcall(function()
        RemovePlant:FireServer(uuid)
    end)
end

local function startAutoShovel()
    local container = workspace:WaitForChild("ClientPlants")

    while _G_Shovel.AutoShovel do

        for _, plant in ipairs(container:GetChildren()) do
            if not _G_Shovel.AutoShovel then break end
            if not plant:IsA("Model") then continue end
            if not isPlantSelected(plant.Name) then continue end

            local uuid = plant:GetAttribute("Uuid")
            if not uuid then continue end

            fireShovel(uuid)
        end

        task.wait(0.1)
    end
end

AutoShovelSection:AddDropdown({
    Title = "Select Plant To Shovel",
    Default = {},
    Multi = true,
    Options = waterOptions,
    Callback = function(state)
        _G_Shovel.SelectedSeed = state
    end
})

AutoShovelSection:AddToggle({
    Title = "Auto Shovel Plants",
    Default = false,
    Callback = function(state)
        _G_Shovel.AutoShovel = state
        if state then
            task.spawn(startAutoShovel)
        end
    end
})

local SellPos = CFrame.new(149.40, 204.01, 672.00)

local function teleport(cf)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CFrame = cf
end

local function sell(mode)
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local old = root.CFrame
    teleport(SellPos)
    task.wait(0.6)
    local Event = game:GetService("ReplicatedStorage").RemoteEvents.SellItems
    Event:InvokeServer(mode)
    task.wait(0.6)
    teleport(old)
end

local SellSection = Tabs.Main:AddSection("Sell")

SellSection:AddToggle({
    Title = "Auto Sell All",
    Content = "Automatically sell all items periodically",
    Default = false,
    Callback = function(state)
        _G.AutoSellAll = state
        if state then
            task.spawn(function()
                while _G.AutoSellAll do
                    task.wait(2)
                    if _G.AutoSellAll then
                        sell("SellAll")
                    end
                end
            end)
        end
    end
})

SellSection:AddButton({
    Title = "Sell Single",
    Callback = function()
        sell("SellSingle")
    end
})

local CodesSection = Tabs.Main:AddSection("Redeem Codes")

local RS = game:GetService("ReplicatedStorage")
local RedeemRemote = RS
    :WaitForChild("RemoteEvents")
    :WaitForChild("RedeemCode")

local CodeList = {
    "RELEASE",
    "DAWN",
    "DAWNFRUIT",
    "THANKYOU",
}

local x5 = CodesSection:AddButton({
    Title = "Redeem All Codes",
    Callback = function()
        for _, code in ipairs(CodeList) do
            pcall(function()
                RedeemRemote:InvokeServer(code)
            end)
            task.wait(0.5)
        end
    end
})

FavoritedSection = Tabs.Bag:AddSection("Bag")

local bcpck = game:GetService("Players").LocalPlayer:WaitForChild("Backpack")
local ToggleFavorite = game:GetService("ReplicatedStorage")
:WaitForChild("RemoteEvents")
:WaitForChild("ToggleFavorite")

local _G_Favorite = {
    AutoFavorite = false,
    SelectedSeed = {}
}

local function cleanName(name)
    return name:gsub("%s*%b()", ""):lower()
end

local function isSelected(itemName)

    if type(_G_Favorite.SelectedSeed) ~= "table" then return false end
    if #_G_Favorite.SelectedSeed == 0 then return false end

    local cleanItem = cleanName(itemName)

    for _,seed in ipairs(_G_Favorite.SelectedSeed) do
        if typeof(seed) == "string" then
            if cleanItem == seed:lower() then
                return true
            end
        end
    end

    return false
end

local function favoriteTool(tool)

    if not _G_Favorite.AutoFavorite then return end
    if not tool:IsA("Tool") then return end
    if not isSelected(tool.Name) then return end
    task.wait(0.1)
    ToggleFavorite:FireServer(tool)
end

bcpck.ChildAdded:Connect(function(tool)
    favoriteTool(tool)
end)

FavoritedSection:AddDropdown({
    Title = "Select Plant To Favorite",
    Default = {},
    Multi = true,
    Options = waterOptions,
    Callback = function(state)
        _G_Favorite.SelectedSeed = state
    end
})

FavoritedSection:AddToggle({
    Title = "Auto Favorite Plants",
    Default = false,
    Callback = function(state)
        _G_Favorite.AutoFavorite = state
        if state then
            for _,tool in ipairs(bcpck:GetChildren()) do
                favoriteTool(tool)
            end
        end
    end
})

local QuestSection = Tabs.Quest:AddSection("Quests")

local yx = QuestSection:AddToggle({
    Title = "Auto Request Quests",
    Content = "Automatically request quests every few seconds",
    Default = false,
    Callback = function(state)
        _G.AutoRequestQuests = state
        if state then
            task.spawn(function()
                while _G.AutoRequestQuests do
                    task.wait(5)
                    if _G.AutoRequestQuests then
                        local Event = game:GetService("ReplicatedStorage").RemoteEvents.RequestQuests
                        Event:FireServer()
                    end
                end
            end)
        end
    end
})

QuestSection:AddButton({
    Title = "Request Quests Now",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.RequestQuests
        Event:FireServer()
    end
})

QuestSection:AddButton({
    Title = "Complete Tutorial",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.UpdateTutorialCompletion
        Event:FireServer(true)
    end
})

local ClaimQuestSection = Tabs.Quest:AddSection("Claim Quest")

local ClaimQuestSettings = {
    QuestType = "Daily",
    QuestTier = "1",
    AutoQuest = false
}

local function ClaimQuest()
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents")
    if remote then
        remote = remote:FindFirstChild("ClaimQuest")
    end
    if not remote then return end
    local args = { ClaimQuestSettings.QuestType, ClaimQuestSettings.QuestTier }
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end

ClaimQuestSection:AddDropdown({
    Title = "Quest Type",
    Content = "Choose the quest type to claim.",
    Options = { "Daily", "Weekly" },
    Default = ClaimQuestSettings.QuestType,
    Callback = function(value)
        ClaimQuestSettings.QuestType = value
    end
})

ClaimQuestSection:AddDropdown({
    Title = "Quest Tier",
    Content = "Choose the quest tier (1-5).",
    Options = { "1", "2", "3", "4", "5" },
    Default = ClaimQuestSettings.QuestTier,
    Callback = function(value)
        ClaimQuestSettings.QuestTier = value
    end
})

ClaimQuestSection:AddButton({
    Title = "Claim Quest Now",
    Content = "Press to claim the quest based on the selections above.",
    Callback = ClaimQuest
})

ClaimQuestSection:AddToggle({
    Title = "Auto Quest",
    Content = "Enable to automatically claim quest.",
    Default = ClaimQuestSettings.AutoQuest,
    Callback = function(state)
        ClaimQuestSettings.AutoQuest = state
    end
})

task.spawn(function()
    while true do
        if ClaimQuestSettings.AutoQuest then
            ClaimQuest()
        end
        task.wait(0.17)
    end
end)

local player = game.Players.LocalPlayer

local SeedPos = CFrame.new(176.70, 204.02, 672.00)
local GearPos = CFrame.new(211.49, 204.01, 608.71)

local function teleport(cf)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CFrame = cf
end

local function buy(shop, item, pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local old = root.CFrame
    teleport(pos)
    task.wait(0.6)
    game:GetService("ReplicatedStorage").RemoteEvents.PurchaseShopItem:InvokeServer(shop, item)
    task.wait(0.6)
    teleport(old)
end

local seedOptions = {
    "Carrot","Corn","Onion","Strawberry","Mushroom","Beetrott",
    "Tomato","Apple","Rose","Wheat","Banana","Plum",
    "Potato","Cabbage","Cherry","Birch","Bellpepper","Dandelion"
}

_G.autoBuySeed = false
_G.autoBuyGear = false
_G.buyDelay = 0.7

local SeedShopSection = Tabs.Shop:AddSection("Seed Shop")

local ReplicatedStorage = game:GetService("ReplicatedStorage") local remoteSeed = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GetShopData") local seedData = require(ReplicatedStorage.Shop.ShopData.SeedShopData)

local RESTOCK_INTERVAL = 300

local SeedStockParagraph = SeedShopSection:AddParagraph({ Title = "LIVE STOCK", Content = "Loading..." })

local SeedTimerParagraph = SeedShopSection:AddParagraph({ Title = "Restock Timer", Content = "00:00" })

local function formatTime(sec) local safe = math.min(sec,300) local m = math.floor(safe / 60) local s = safe % 60 return string.format("%d:%02d", m, s) end

local function buildSeedStock(data) local lines = {}

for _, info in pairs(seedData.ShopData) do local name = info.Name local stock = data.Items[name] local amount = stock and stock.Amount or 0

if amount >= 1 then table.insert(lines,name.." : "..amount.."x") end end

if #lines == 0 then return "All items out of stock" end

return table.concat(lines,"\n") end

local function refreshSeedStock() local ok,data = pcall(function() return remoteSeed:InvokeServer("SeedShop") end)

if ok and data and data.Items then SeedStockParagraph:SetContent(buildSeedStock(data)) end end

workspace:GetAttributeChangedSignal("SeedShop"):Connect(refreshSeedStock)

task.spawn(function() while true do local remain = RESTOCK_INTERVAL - (workspace:GetServerTimeNow() % RESTOCK_INTERVAL) SeedTimerParagraph:SetContent(formatTime(math.ceil(remain))) task.wait(1) end end)

refreshSeedStock()

SeedShopSection:AddDropdown({
    Title = "Select Seed",
    Options = seedOptions,
    Default = "Carrot",
    Callback = function(v)
        _G.ss_selectedSeed = v
    end
})

SeedShopSection:AddButton({
    Title = "Buy Seed Once",
    Callback = function()
        local seed = (_G.ss_selectedSeed or "Carrot") .. " Seed"
        buy("SeedShop", seed, SeedPos)
    end
})

SeedShopSection:AddToggle({
    Title = "Auto Buy Seed",
    Default = false,
    Callback = function(v)
        _G.autoBuySeed = v
        if v then
            task.spawn(function()
                while _G.autoBuySeed do
                    local seed = (_G.ss_selectedSeed or "Carrot").." Seed"
                    buy("SeedShop", seed, SeedPos)
                    task.wait(_G.buyDelay)
                end
            end)
        end
    end
})

local gearOptions = {
    "Watering Can","Basic Sprinkler","Harvest Bell",
    "Turbo Sprinkler","Favorite Tool","Super Sprinkler"
}

local GearShopSection = Tabs.Shop:AddSection("Gear Shop")

local remoteGear = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GetShopData") local gearData = require(ReplicatedStorage.Shop.ShopData.GearShopData)

local GearStockParagraph = GearShopSection:AddParagraph({ Title = "LIVE STOCK", Content = "Loading..." })

local GearTimerParagraph = GearShopSection:AddParagraph({ Title = "Restock Timer", Content = "00:00" })

local function buildGearStock(data) local lines = {}

for _, info in pairs(gearData.ShopData) do local name = info.Name local stock = data.Items[name] local amount = stock and stock.Amount or 0

if amount >= 1 then table.insert(lines,name.." : "..amount.."x") end end

if #lines == 0 then return "All items out of stock" end

return table.concat(lines,"\n") end

local function refreshGearStock() local ok,data = pcall(function() return remoteGear:InvokeServer("GearShop") end)

if ok and data and data.Items then GearStockParagraph:SetContent(buildGearStock(data)) end end

workspace:GetAttributeChangedSignal("GearShop"):Connect(refreshGearStock)

task.spawn(function() while true do local remain = RESTOCK_INTERVAL - (workspace:GetServerTimeNow() % RESTOCK_INTERVAL) GearTimerParagraph:SetContent(formatTime(math.ceil(remain))) task.wait(1) end end)

refreshGearStock()

GearShopSection:AddDropdown({
    Title = "Select Gear",
    Options = gearOptions,
    Default = "Watering Can",
    Callback = function(v)
        _G.gs_selectedGear = v
    end
})

GearShopSection:AddButton({
    Title = "Buy Gear Once",
    Callback = function()
        local gear = _G.gs_selectedGear or "Watering Can"
        buy("GearShop", gear, GearPos)
    end
})

GearShopSection:AddToggle({
    Title = "Auto Buy Gear",
    Default = false,
    Callback = function(v)
        _G.autoBuyGear = v
        if v then
            task.spawn(function()
                while _G.autoBuyGear do
                    local gear = _G.gs_selectedGear or "Watering Can"
                    buy("GearShop", gear, GearPos)
                    task.wait(_G.buyDelay)
                end
            end)
        end
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local ServerID = game.JobId

local remote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("GetShopData")
local shopData = require(ReplicatedStorage.Shop.ShopData.SeedShopData)

local httpRequest = (syn and syn.request)
or (http and http.request)
or http_request
or request
or (fluxus and fluxus.request)
or (getgenv().http and getgenv().http.request)

local webhookURL = ""
local webhookEnabled = false
local rolePing = ""

local RESTOCK_TIME = 300

local rareSeeds = {
    ["Dragon Fruit"] = true,
    ["Soul Fruit"] = true,
    ["Celestial Seed"] = true
}

local function buildStockText(data)
    local lines = {}
    local rareFound = false

    for _,info in pairs(shopData.ShopData) do
        local name = info.Name
        local stock = data.Items[name]
        local amount = stock and stock.Amount or 0

        if amount >= 1 then
            table.insert(lines,"🌱 "..name.." : "..amount.."x")

            if rareSeeds[name] then
                rareFound = true
            end
        end
    end

    if #lines == 0 then
        table.insert(lines,"All items out of stock")
    end

    return table.concat(lines,"\n"), rareFound
end

local function getRestockTimer()
    local serverTime = workspace:GetServerTimeNow()
    local remain = RESTOCK_TIME - (serverTime % RESTOCK_TIME)

    local m = math.floor(remain/60)
    local s = math.floor(remain%60)

    return string.format("%02d:%02d",m,s)
end

local function sendWebhook(msg, rare)
    if webhookURL == "" or not httpRequest then return end

    local ping = ""
    if rare and rolePing ~= "" then
        ping = "<@&"..rolePing..">"
    end

    local body = {
        username = "StreeHub",
        avatar_url = "https://cdn.discordapp.com/attachments/1429845065752117268/1479099416055906334/Tak_berjudul76_20260203000028.png?ex=69ab76ed&is=69aa256d&hm=46c8d3ee9513d608c29cee3cca99a96c92e24f22751b8cde5e4583fb078e9e31",
        content = ping,
        embeds = {
            {
                title = "StreeHub | Seed Shop Restock",
                description = "```"..msg.."```",
                color = 65280,
                fields = {
                    {
                        name = "Server ID",
                        value = "`"..ServerID.."`",
                        inline = false
                    },
                    {
                        name = "Player",
                        value = "||"..Player.Name.."||",
                        inline = true
                    },
                    {
                        name = "Next Restock",
                        value = getRestockTimer(),
                        inline = true
                    }
                },
                footer = {
                    text = "StreeHub Tracker"
                }
            }
        }
    }

    httpRequest({
        Url = webhookURL,
        Method = "POST",
        Headers = {["Content-Type"]="application/json"},
        Body = HttpService:JSONEncode(body)
    })
end

local function sendStock()
    local ok,data = pcall(function()
        return remote:InvokeServer("SeedShop")
    end)

    if ok and data and data.Items then
        local text,rare = buildStockText(data)
        sendWebhook(text,rare)
    end
end

workspace:GetAttributeChangedSignal("SeedShop"):Connect(function()
    task.wait(1)
    if webhookEnabled then
        sendStock()
    end
end)

local Section = Tabs.Web:AddSection("StreeHub Webhook")

Section:AddInput({
    Title = "Webhook URL",
    Default = "",
    Callback = function(v)
        webhookURL = v or ""
    end
})

Section:AddInput({
    Title = "Ping Role ID",
    Default = "",
    Callback = function(v)
        rolePing = v
    end
})

Section:AddToggle({
    Title = "Enable Webhook",
    Default = false,
    Callback = function(v)
        webhookEnabled = v
        if v then
            sendStock()
        end
    end
})

Section:AddButton({
    Title = "Test Send Webhook",
    Callback = function()
        local testMessage = "🌱 Test Seed : 99x\n🌱 Example Seed : 10x"
        sendWebhook(testMessage,false)
    end
})

local teleportCoords = {
    Gear = CFrame.new(211.49, 204.01, 608.71),
    Sell = CFrame.new(149.40, 204.01, 672.00),
    Seed = CFrame.new(176.70, 204.02, 672.00),
    Plot1 = CFrame.new(164.29, 188.51, 348.03),
    Plot2 = CFrame.new(390.36, 211.52, 377.34),
    Plot3 = CFrame.new(382.56, 218.02, 742.65),
    Plot4 = CFrame.new(162.66, 190.00, 934.10),
    Plot5 = CFrame.new(-81.47, 200.00, 870.66),
    Plot6 = CFrame.new(-64.42, 205.00, 375.66),
}

local ShopTeleportSection = Tabs.Teleport:AddSection("Shop Teleport")

local dropdown = ShopTeleportSection:AddDropdown({
    Title = "Select Shop Location",
    Options = { "Gear", "Sell", "Seed" },
    Default = "Gear",
    Callback = function(value)
        _G.selectedShopTP = value
    end
})

ShopTeleportSection:AddButton({
    Title = "Teleport Now",
    Callback = function()
        local loc = _G.selectedShopTP or "Gear"
        local cframe = teleportCoords[loc]
        if cframe and game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end
    end
})

local PlotTeleportSection = Tabs.Teleport:AddSection("Plot Teleport")

local dropdown = PlotTeleportSection:AddDropdown({
    Title = "Select Plot",
    Options = { "Plot1", "Plot2", "Plot3", "Plot4", "Plot5", "Plot6" },
    Default = "Plot1",
    Callback = function(value)
        _G.selectedPlotTP = value
    end
})

PlotTeleportSection:AddButton({
    Title = "Teleport Now",
    Callback = function()
        local plot = _G.selectedPlotTP or "Plot1"
        local cframe = teleportCoords[plot]
        if cframe and game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end
    end
})

local LP         = game.Players.LocalPlayer
local UIS        = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local v_u = Tabs.Misc:AddSection("Player")

local JumpInput = v_u:AddInput({
    Title   = "Jump Power",
    Content = "Set custom jump power value.",
    Default = "50",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            _G.CustomJumpPower = num
        end
    end
})

local JumpPowerToggle = v_u:AddToggle({
    Title   = "Enable Jump Power",
    Content = "Apply custom jump power to your character.",
    Default = false,
    Callback = function(state)
        _G.JumpPowerEnabled = state
        local char = LP.Character or LP.CharacterAdded:Wait()
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = state and (_G.CustomJumpPower or 50) or 50
        end
    end
})

local WalkSpeedToggle = v_u:AddToggle({
    Title   = "Enable Walk Speed",
    Content = "Apply custom walk speed to your character.",
    Default = false,
    Callback = function(state)
        _G.WalkSpeedEnabled = state
        local char = LP.Character or LP.CharacterAdded:Wait()
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state and (_G.CustomWalkSpeed or 20) or 20
        end
    end
})

LP.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    if _G.WalkSpeedEnabled and _G.CustomWalkSpeed then
        hum.WalkSpeed = _G.CustomWalkSpeed
    end
    if _G.JumpPowerEnabled and _G.CustomJumpPower then
        hum.JumpPower = _G.CustomJumpPower
    end
end)

local NoclipToggle = v_u:AddToggle({
    Title   = "Noclip",
    Content = "Walk through walls and solid objects.",
    Default = false,
    Callback = function(state)
        _G.NoclipEnabled = state
        if not state then
            local char = LP.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

RunService.Stepped:Connect(function()
    if _G.NoclipEnabled then
        local char = LP.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local InfiniteJumpToggle = v_u:AddToggle({
    Title   = "Infinite Jump",
    Content = "Jump endlessly while in the air.",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local v_u1 = Tabs.Misc:AddSection("Tutorial")

v_u1:AddParagraph({
    Title = "Get Available Plots",
    Content = "to exit the tutorial from within the game",
    Icon = "info",
})

v_u1:AddParagraph({
    Title = "Set Streaming Focus Update",
    Content = "For Streaming Focus Update, it's better to skip the tutorial for the update only.",
    Icon = "info",
})

v_u1:AddParagraph({
    Title = "Set Streaming Focus Start",
    Content = "Focus on the game and ignore the tutorials in the game.",
    Icon = "info",
})

v_u1:AddParagraph({
    Title = "Configuration",
    Content = "The config has been made automatic so it can be used.",
    Icon = "info",
})

local k9v = Tabs.Misc:AddSection("Visual")

local module_rarity = loadstring(game:HttpGet("https://raw.githubusercontent.com/Walvy666/awdudjsjenen/refs/heads/main/ahhhshit.lua"))()

local directPlants = {
    onion = true,
    carrot = true,
    bamboo = true,
    cabbage = true
}

local espEnabled = false

local function getRarityColor(rarity)
    rarity = string.lower(rarity)

    if rarity == "common" then
        return Color3.fromRGB(0,170,255)
    elseif rarity == "uncommon" then
        return Color3.fromRGB(170,170,170)
    elseif rarity == "rare" then
        return Color3.fromRGB(0,255,0)
    elseif rarity == "epic" then
        return Color3.fromRGB(170,0,255)
    elseif rarity == "legendary" then
        return Color3.fromRGB(255,170,0)
    end

    return Color3.fromRGB(255,255,255)
end

local function createBillboard(part,plantName,mutation,kg)
    if not espEnabled then return end
    if part:FindFirstChild("FruitInfo") then return end

    local rarity = module_rarity[plantName] or "Unknown"

    local gui = Instance.new("BillboardGui")
    gui.Name = "FruitInfo"
    gui.Size = UDim2.new(0,140,0,35)
    gui.StudsOffset = Vector3.new(0,2,0)
    gui.AlwaysOnTop = true
    gui.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextColor3 = getRarityColor(rarity)

    label.Text = plantName.." | "..rarity.." | "..kg.."kg | M: "..mutation
    label.Parent = gui
end

local function getWeight(obj)
    local kg = obj:GetAttribute("FruitWeight")

    if not kg then
        local weightValue = obj:FindFirstChild("FruitWeight")
        if weightValue then
            kg = weightValue.Value
        end
    end

    kg = kg or 0
    return math.floor(kg * 100) / 100
end

local function processPlant(model)
    if not model:IsA("Model") then return end
    if not espEnabled then return end

    local owner = model:GetAttribute("OwnerUserId")
    if owner and owner ~= player.UserId then return end

    local rawName = model.Name
    local plantName = rawName:gsub("%d+","")
    local lower = plantName:lower()

    for name in pairs(directPlants) do
        if string.find(lower,name,1,true) then
            local mutation = model:GetAttribute("Mutation") or "Normal"
            local kg = getWeight(model)

            createBillboard(model,plantName,mutation,kg)
            return
        end
    end

    local fruit = model:FindFirstChild("Fruit1")

    if fruit then
        local mutation = fruit:GetAttribute("Mutation") or "Normal"
        local kg = getWeight(fruit)

        createBillboard(fruit,plantName,mutation,kg)
    end
end

local function scanPlants()
    for _,v in ipairs(container:GetChildren()) do
        processPlant(v)
    end
end

k9v:AddToggle({
    Title = "Plant ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state

        if state then
            scanPlants()
        else
            for _,v in ipairs(workspace:GetDescendants()) do
                if v.Name == "FruitInfo" then
                    v:Destroy()
                end
            end
        end
    end
})

local t1 = Tabs.Misc:AddSection("Server")

local AntiAfkConnection
local AntiAFKToggle = t1:AddToggle({
    Title   = "Anti AFK",
    Content = "Prevent being kicked for inactivity.",
    Default = false,
    Callback = function(state)
        _G.AntiAFKActive = state
        if state then
            AntiAfkConnection = UIS.WindowFocusReleased:Connect(function()
                local vInputInfo = UIS:GetFocusedTextBox()
                if not vInputInfo then
                    local VIM = game:GetService("VirtualInputManager")
                    if VIM then
                        pcall(function()
                            VIM:SendMouseMoveEvent(0, 0, false)
                        end)
                    end
                end
            end)
            _G.AntiAFKLoop = task.spawn(function()
                while _G.AntiAFKActive do
                    task.wait(60)
                    if _G.AntiAFKActive then
                        local char = LP.Character
                        if char then
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum then
                                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end
                end
            end)
        else
            if AntiAfkConnection then
                AntiAfkConnection:Disconnect()
                AntiAfkConnection = nil
            end
        end
    end
})

local AutoReconnectToggle = t1:AddToggle({
    Title   = "Auto Reconnect",
    Content = "Automatically reconnect if disconnected.",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
    end
})

game.Players.LocalPlayer.OnTeleport:Connect(function(teleportState)
    if teleportState == Enum.TeleportState.Failed and _G.AutoReconnect then
        task.wait(3)
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if _G.AutoReconnect and not game:GetService("Players").LocalPlayer then
        task.wait(3)
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

t1:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
    end
})

t1:AddButton({
    Title = "Server Hop",
    Callback = function()
        task.spawn(function()
            local Http = game:GetService("HttpService")
            local TPS  = game:GetService("TeleportService")
            local ok, result = pcall(function()
                return Http:JSONDecode(game:HttpGetAsync(
                    "https://games.roblox.com/v1/games/" ..
                    game.PlaceId ..
                    "/servers/Public?sortOrder=Asc&limit=100"
                ))
            end)
            if ok and result and result.data then
                for _, v in pairs(result.data) do
                    if v.id ~= game.JobId and v.playing < v.maxPlayers then
                        TPS:TeleportToPlaceInstance(game.PlaceId, v.id, LP)
                        return
                    end
                end
            end
        end)
    end
})

local y = Tabs.Misc:AddSection("UI Setting")

y:AddToggle({
    Title = "Show UI Button",
    Content = "Toggle the floating hub button visibility.",
    Default = true,
    Callback = function(state)
        local button = game:GetService("CoreGui"):FindFirstChild("StreeHubButton")
        if button then
            button.Enabled = state
        end
    end
})

y:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
    end
})

y:AddPanel({
    Title = "UI Color",
    Placeholder = "57,255,20",
    ButtonText = "Apply Color",
    ButtonCallback = function(colorText)
        local r, g, b = colorText:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            local color = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
        end
    end,
    SubButtonText = "Reset Color",
    SubButtonCallback = function()
    end
})

local y2 = Tabs.Misc:AddSection("Configuration")

y2:AddButton({
    Title = "Save Configuration",
    Callback = function()
        if SaveManager and SaveManager.Save then
            SaveManager:Save()
        end
    end
})

y2:AddButton({
    Title = "Load Configuration",
    Callback = function()
        if SaveManager and SaveManager.Load then
            SaveManager:Load()
        end
    end
})

y2:AddButton({
    Title = "Reset Configuration",
    Callback = function()
        local Players = game:GetService("Players")
        local TeleportService = game:GetService("TeleportService")
        local LocalPlayer = Players.LocalPlayer
        local configPath = "StreeHub/Config/StreeHub_" .. gameName .. ".json"

        if isfile and isfile(configPath) then
            delfile(configPath)
        end

        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

local Settings = Settings or {}
Settings.Enabled = Settings.Enabled or false
Settings.IgnoreFavorited = Settings.IgnoreFavorited ~= false
Settings.AutoClaimQuests = Settings.AutoClaimQuests or false
Settings.Delay = Settings.Delay or 0.1
Settings.HarvestBatchSize = Settings.HarvestBatchSize or 10
Settings.Range = Settings.Range or 50
Settings.HarvestMode = Settings.HarvestMode or "Manual"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getCharacterRoot()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local HarvestMethods = {}

function HarvestMethods:GetPromptWorldPosition(prompt)
    if not prompt or not prompt.Parent then
        return nil
    end

    local parent = prompt.Parent

    if parent:IsA("BasePart") then
        return parent.Position
    end

    if parent:IsA("Model") then
        if parent.PrimaryPart then
            return parent.PrimaryPart.Position
        end

        local basePart = parent:FindFirstChildWhichIsA("BasePart", true)
        if basePart then
            return basePart.Position
        end
    end

    local anyPart = parent:FindFirstChildWhichIsA("BasePart", true)
    if anyPart then
        return anyPart.Position
    end

    return nil
end

function HarvestMethods:IsHarvestPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end

    local actionText = tostring(prompt.ActionText or ""):lower()
    local objectText = tostring(prompt.ObjectText or ""):lower()

    return actionText:find("harvest") ~= nil or objectText:find("harvest") ~= nil
end

function HarvestMethods:GetHarvestPrompts()
    local root = getCharacterRoot()
    if not root then
        return {}
    end

    local rootPos = root.Position
    local found = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if self:IsHarvestPrompt(obj) then
            local pos = self:GetPromptWorldPosition(obj)
            if pos then
                local dist = (rootPos - pos).Magnitude
                if dist <= Settings.Range then
                    table.insert(found, {
                        prompt = obj,
                        distance = dist
                    })
                end
            end
        end
    end

    table.sort(found, function(a, b)
        return a.distance < b.distance
    end)

    local results = {}
    local limit = math.min(Settings.HarvestBatchSize, #found)

    for i = 1, limit do
        table.insert(results, found[i].prompt)
    end

    return results
end

function HarvestMethods:ShouldTeleport()
    return Settings.HarvestMode == "Teleport"
end

function HarvestMethods:TeleportToPrompt(prompt)
    if not self:ShouldTeleport() then
        return
    end

    local root = getCharacterRoot()
    local pos = self:GetPromptWorldPosition(prompt)

    if root and pos then
        root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

function HarvestMethods:HarvestBatch(prompts)
    for _, prompt in ipairs(prompts) do
        pcall(function()
            if self:ShouldTeleport() then
                self:TeleportToPrompt(prompt)
                task.wait(0.05)
            end

            fireproximityprompt(prompt)
        end)

        task.wait(Settings.Delay)
    end
end

function HarvestMethods:Run()
    if not Settings.Enabled then
        return
    end

    local prompts = self:GetHarvestPrompts()
    if #prompts > 0 then
        self:HarvestBatch(prompts)
    end
end

task.spawn(function()
    while task.wait(Settings.Delay) do
        if Settings.Enabled then
            HarvestMethods:Run()
        end
    end
end)

local Farm1 = Tabs.Main:AddSection("Farm")

Farm1:AddToggle({
    Title = "Enable Auto Harvest",
    Content = "Automatically harvest nearby crops.",
    Default = Settings.Enabled,
    Callback = function(state)
        Settings.Enabled = state
    end
})

Farm1:AddDropdown({
    Title = "Harvest Mode",
    Content = "Choose harvest movement mode.",
    Values = {"Manual", "Teleport"},
    Default = Settings.HarvestMode,
    Multi = false,
    Callback = function(value)
        Settings.HarvestMode = value
    end
})

Farm1:AddToggle({
    Title = "Ignore Favorited",
    Content = "Skip favorited plants while harvesting.",
    Default = Settings.IgnoreFavorited,
    Callback = function(state)
        Settings.IgnoreFavorited = state
    end
})

Farm1:AddToggle({
    Title = "Auto Claim Quests",
    Content = "Automatically claim completed quests.",
    Default = Settings.AutoClaimQuests,
    Callback = function(state)
        Settings.AutoClaimQuests = state
    end
})

Farm1:AddSlider({
    Title = "Harvest Delay",
    Content = "Delay between harvest actions.",
    Min = 0.05,
    Max = 1,
    Default = Settings.Delay,
    Increment = 0.01,
    Callback = function(value)
        Settings.Delay = value
    end
})

Farm1:AddSlider({
    Title = "Harvest Batch Size",
    Content = "How many prompts are harvested each cycle.",
    Min = 1,
    Max = 50,
    Default = Settings.HarvestBatchSize,
    Increment = 1,
    Callback = function(value)
        Settings.HarvestBatchSize = value
    end
})

Farm1:AddSlider({
    Title = "Harvest Range",
    Content = "Maximum distance to detect harvest prompts.",
    Min = 10,
    Max = 200,
    Default = Settings.Range,
    Increment = 1,
    Callback = function(value)
        Settings.Range = value
    end
})

Farm1:AddButton({
    Title = "Harvest Once",
    Callback = function()
        HarvestMethods:Run()
    end
})
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    SaveConfig()
end)

StreeHub:MakeNotify({
    Title = "StreeHub",
    Description = "Notification",
    Content = "Script loaded successfully!",
    Color = Color3.fromRGB(57, 255, 20),
    Delay = 4
})
