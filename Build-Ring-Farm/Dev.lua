loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)

local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = (premium and "Premium" or "Build A Ring Farm") .. " - " .. version,
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/Config.json"
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")

local Plots  = workspace:WaitForChild("Map"):WaitForChild("Plots")
local myPlot = nil

for i = 1, 6 do
    local plot = Plots:FindFirstChild("Plot" .. i)
    if plot then
        local att = plot:FindFirstChild("HomeLabelAttachment")
        if att and #att:GetChildren() > 0 then
            myPlot = plot
            break
        end
    end
end

if not myPlot then
    return
end

local seedRoller = myPlot:FindFirstChild("SeedRoller")
local stands     = {}

if seedRoller then
    for i = 1, 6 do
        local stand = seedRoller:FindFirstChild("Stand" .. i)
        if stand then
            stands[i] = { index = i, position = stand:GetPivot().Position }
        end
    end
end

local function getWorldSeeds()
    local seeds = {}
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("BuySeed", true) then
            local seedPos           = model:GetPivot().Position
            local bestStand, bestDist = nil, math.huge
            for _, st in pairs(stands) do
                local d = (Vector3.new(seedPos.X, 0, seedPos.Z) - Vector3.new(st.position.X, 0, st.position.Z)).Magnitude
                if d < bestDist then
                    bestDist  = d
                    bestStand = st
                end
            end
            if bestStand and bestDist < 15 then
                seeds[model.Name] = bestStand.index
            end
        end
    end
    return seeds
end

local function getFarmPlots()
    local out = {}
    for _, name in ipairs({"FarmPlot", "SecondFloor", "ThirdFloor"}) do
        local node = myPlot:FindFirstChild(name)
        if node then
            local fp = name == "FarmPlot" and node or node:FindFirstChild("FarmPlot")
            if fp then
                table.insert(out, fp)
            end
        end
    end
    return out
end

local FERTILIZER_NAMES = {
    "Super Fertilizer",
    "Strong Fertilizer",
    "Normal Fertilizer",
}

local function getFertilizerFromBackpack()
    for _, name in ipairs(FERTILIZER_NAMES) do
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if string.find(tool.Name, name, 1, true) then
                return tool
            end
        end
    end
    return nil
end

local function getUnfertilizedDirt()
    for _, fp in ipairs(getFarmPlots()) do
        for _, plant in ipairs(fp:GetChildren()) do
            local dirt = plant:FindFirstChild("Dirt")
            if dirt and dirt:GetAttribute("PlantLevel") ~= nil then
                if not dirt:GetAttribute("Fertilized") then
                    return dirt
                end
            end
        end
    end
    return nil
end

local seedScrollFrame = player.PlayerGui
    :WaitForChild("MainUI")
    :WaitForChild("Menus")
    :WaitForChild("IndexFrame")
    :WaitForChild("Main")
    :WaitForChild("PlantsFrame")

local rarityOrder = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary",
    "Divine", "Prismatic", "Secret", "Exotic", "Transcended",
}

local seedsByRarity = {}
for _, r in ipairs(rarityOrder) do
    seedsByRarity[r] = {}
end

for _, child in ipairs(seedScrollFrame:GetChildren()) do
    if child:IsA("Frame") then
        local icon   = child:FindFirstChild("Icon")
        local rarity = child:FindFirstChild("RarityName")
        local sname  = child:FindFirstChild("SeedName")
        local name   = (sname and sname.Text ~= "???" and sname.Text) or child.Name
        local rar    = (rarity and rarity.Text) or "Common"
        local bucket = seedsByRarity[rar] or seedsByRarity["Common"]
        table.insert(bucket, { Name = name, Icon = icon and icon.Image or "" })
    end
end

local seedGroups = {}
for _, r in ipairs(rarityOrder) do
    if #seedsByRarity[r] > 0 then
        table.insert(seedGroups, { Label = r, Items = seedsByRarity[r] })
    end
end

local iconByPlantName = {}
for _, child in ipairs(seedScrollFrame:GetChildren()) do
    if child:IsA("Frame") then
        local icon = child:FindFirstChild("Icon")
        if icon then
            iconByPlantName[child.Name] = icon.Image
        end
    end
end

local shopScrollFrame = player.PlayerGui
    :WaitForChild("MainUI")
    :WaitForChild("Menus")
    :WaitForChild("GearShopFrame")
    :WaitForChild("ScrollingFrame")

local function getShopItems()
    local items = {}
    for _, child in ipairs(shopScrollFrame:GetChildren()) do
        if child:IsA("ImageLabel") then
            local gearName  = child:FindFirstChild("GearName")
            local gearImage = child:FindFirstChild("GearImage")
            local imgLabel  = gearImage and gearImage:FindFirstChild("ImageLabel")
            local rarLabel  = gearImage and gearImage:FindFirstChild("Rarity")
            if gearName and imgLabel then
                table.insert(items, {
                    Name       = gearName.Text,
                    Icon       = imgLabel.Image,
                    StockLabel = rarLabel,
                })
            end
        end
    end
    return items
end

local function parseStock(stockLabel)
    if not stockLabel then return 0 end
    local n = tonumber(stockLabel.Text:match("%d+"))
    return n or 0
end

local petMerchant = workspace:WaitForChild("PetMerchant", 10)

local function scanEggs()
    local found = {}
    if not petMerchant then return found end
    for i = 1, 5 do
        local podium = petMerchant:FindFirstChild("Podium" .. i .. "Lever")
        if podium then
            local attachment = podium:FindFirstChild("PromptAttachment")
            local prompt     = attachment and attachment:FindFirstChild("EggShopPrompt")
            if prompt and prompt.ObjectText ~= "" and not prompt.ObjectText:find("Slot") then
                table.insert(found, { podiumIdx = i, name = prompt.ObjectText })
            end
        end
    end
    return found
end

local initialEggs = scanEggs()

local function getPetTeleportCFrame(floorIndex)
    local sign
    if floorIndex == 1 then
        sign = myPlot:FindFirstChild("PlotUpgradeSign")
    elseif floorIndex == 2 then
        local sf = myPlot:FindFirstChild("SecondFloor")
        sign = sf and sf:FindFirstChild("PlotUpgradeSign")
    elseif floorIndex == 3 then
        local tf = myPlot:FindFirstChild("ThirdFloor")
        sign = tf and tf:FindFirstChild("PlotUpgradeSign")
    end
    return sign and sign:GetPivot()
end

local function getUnlockedFloors()
    local floors = {}
    if myPlot:FindFirstChild("FarmPlot")    then table.insert(floors, 1) end
    if myPlot:FindFirstChild("SecondFloor") then table.insert(floors, 2) end
    if myPlot:FindFirstChild("ThirdFloor")  then table.insert(floors, 3) end
    return floors
end

local function getEquippedPets()
    local pets = {}
    for _, obj in ipairs(myPlot:GetChildren()) do
        if obj:IsA("Model") and obj:GetAttribute("PetKey") ~= nil then
            if obj:GetAttribute("PetOwner") == player.Name then
                table.insert(pets, {
                    name       = obj:GetAttribute("PetName"),
                    petKey     = obj:GetAttribute("PetKey"),
                    multiplier = obj:GetAttribute("EarningsMultiplier") or 1,
                    floorIndex = obj:GetAttribute("FloorIndex") or 1,
                })
            end
        end
    end
    return pets
end

local function getInventoryPets()
    local pets = {}
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("InventoryCategory") == "Pets" then
            table.insert(pets, {
                name       = tool:GetAttribute("trueName") or tool.Name,
                petKey     = tool:GetAttribute("petKey"),
                multiplier = tool:GetAttribute("EarningsMultiplier") or 1,
                tool       = tool,
            })
        end
    end
    return pets
end

local function optimizePets()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local unlockedFloors = getUnlockedFloors()

    repeat
        local equippedPets  = getEquippedPets()
        local inventoryPets = getInventoryPets()

        table.sort(equippedPets,  function(a, b) return a.multiplier > b.multiplier end)
        table.sort(inventoryPets, function(a, b) return a.multiplier > b.multiplier end)

        if #inventoryPets == 0 then break end

        local nbSlots = #unlockedFloors
        local allPets = {}

        for _, p in ipairs(equippedPets) do
            table.insert(allPets, { source = "equipped", data = p })
        end
        for _, p in ipairs(inventoryPets) do
            table.insert(allPets, { source = "inventory", data = p })
        end

        table.sort(allPets, function(a, b) return a.data.multiplier > b.data.multiplier end)

        local bestPets = {}
        for i = 1, math.min(nbSlots, #allPets) do
            table.insert(bestPets, allPets[i])
        end

        local bestKeys = {}
        for _, entry in ipairs(bestPets) do
            bestKeys[entry.data.petKey] = true
        end

        local toUnequip = {}
        for _, p in ipairs(equippedPets) do
            if not bestKeys[p.petKey] then
                table.insert(toUnequip, p)
            end
        end

        local toEquip = {}
        for _, entry in ipairs(bestPets) do
            if entry.source == "inventory" then
                table.insert(toEquip, entry.data)
            end
        end

        if #toUnequip == 0 and #toEquip == 0 then break end

        for _, p in ipairs(toUnequip) do
            pcall(function()
                ReplicatedStorage.Remotes.Pets.UnequipPet:FireServer(p.petKey)
            end)
            task.wait(0.5)
        end

        for _, p in ipairs(toEquip) do
            local occupied = {}
            for _, eq in ipairs(getEquippedPets()) do
                occupied[eq.floorIndex] = true
            end

            local targetFloor = nil
            for _, floorIdx in ipairs(unlockedFloors) do
                if not occupied[floorIdx] then
                    targetFloor = floorIdx
                    break
                end
            end

            if not targetFloor then break end

            local cf = getPetTeleportCFrame(targetFloor)
            if cf then
                hrp.CFrame = cf + Vector3.new(0, 3, 0)
                task.wait(0.5)
            end

            local tool = player.Backpack:FindFirstChild(p.tool.Name)
            if not tool then continue end

            humanoid:EquipTool(tool)
            task.wait(0.5)
            pcall(function()
                ReplicatedStorage.Remotes.Pets.EquipPet:FireServer()
            end)
            task.wait(0.3)
            humanoid:UnequipTools()
            task.wait(0.3)
        end

    until false
end

local highlightParts = {}

local function addHighlight(pName, plantModel)
    if highlightParts[pName] then return end
    local cf     = plantModel:GetPivot()
    local sphere = Instance.new("Part")

    sphere.Name        = "StreeHub_Highlight"
    sphere.Shape       = Enum.PartType.Ball
    sphere.Size        = Vector3.new(1.8, 1.8, 1.8)
    sphere.CFrame      = cf + Vector3.new(0, 9, 0)
    sphere.Anchored    = true
    sphere.CanCollide  = false
    sphere.CastShadow  = false
    sphere.Material    = Enum.Material.Neon
    sphere.Color       = Color3.fromRGB(130, 80, 255)
    sphere.Parent      = workspace

    local running = true
    task.spawn(function()
        while running and sphere and sphere.Parent do
            for i = 1, 20 do
                if not running then break end
                local s = 1.5 + 0.75 * math.sin((i / 20) * math.pi)
                sphere.Size = Vector3.new(s, s, s)
                task.wait(0.05)
            end
            for i = 1, 20 do
                if not running then break end
                local s = 2.25 - 0.75 * math.sin((i / 20) * math.pi)
                sphere.Size = Vector3.new(s, s, s)
                task.wait(0.05)
            end
        end
    end)

    highlightParts[pName] = { part = sphere, stop = function() running = false end }
end

local function removeHighlight(pName)
    local entry = highlightParts[pName]
    if entry then
        entry.stop()
        entry.part:Destroy()
        highlightParts[pName] = nil
    end
end

local function clearAllHighlights()
    for pName in pairs(highlightParts) do
        removeHighlight(pName)
    end
end

local selectedPlantsForUpgrade = {}

local plantCardItems  = {}
local dirtByCardName  = {}
local modelByCardName = {}
local pNameByCardName = {}

local function buildCardName(pName, lvl, counter)
    return "[Lv." .. lvl .. "] " .. pName .. " #" .. counter
end

local function fullRescan(keepSelection)
    for i = #plantCardItems, 1, -1 do plantCardItems[i] = nil end
    for k in pairs(dirtByCardName)  do dirtByCardName[k]  = nil end
    for k in pairs(modelByCardName) do modelByCardName[k] = nil end
    for k in pairs(pNameByCardName) do pNameByCardName[k] = nil end

    local prevSelected = {}
    if keepSelection then
        for pName in pairs(selectedPlantsForUpgrade) do
            prevSelected[pName] = true
        end
    end

    clearAllHighlights()
    selectedPlantsForUpgrade = {}

    local counters = {}
    local raw      = {}

    for _, fp in ipairs(getFarmPlots()) do
        for _, plant in ipairs(fp:GetChildren()) do
            local dirt  = plant:FindFirstChild("Dirt")
            local pName = dirt and dirt:GetAttribute("PlantName")
            if dirt and pName then
                local lvl = dirt:GetAttribute("PlantLevel") or 0
                table.insert(raw, { pName = pName, lvl = lvl, dirt = dirt, model = plant })
            end
        end
    end

    table.sort(raw, function(a, b) return a.pName < b.pName end)

    for _, entry in ipairs(raw) do
        counters[entry.pName] = (counters[entry.pName] or 0) + 1
        local cardName = buildCardName(entry.pName, entry.lvl, counters[entry.pName])
        dirtByCardName[cardName]  = entry.dirt
        modelByCardName[cardName] = entry.model
        pNameByCardName[cardName] = entry.pName
        table.insert(plantCardItems, { Name = cardName, Icon = iconByPlantName[entry.pName] or "" })
    end

    if keepSelection then
        local seen = {}
        for _, item in ipairs(plantCardItems) do
            local pName = pNameByCardName[item.Name]
            if pName and prevSelected[pName] then
                selectedPlantsForUpgrade[pName] = true
                if not seen[pName] then
                    seen[pName]  = true
                    local model  = modelByCardName[item.Name]
                    if model then addHighlight(pName, model) end
                end
            end
        end
    end
end

local allSeedNames        = {}
local allSeedNamesByRarity = {}

for _, group in ipairs(seedGroups) do
    allSeedNamesByRarity[group.Label] = {}
    for _, item in ipairs(group.Items) do
        table.insert(allSeedNames, item.Name)
        table.insert(allSeedNamesByRarity[group.Label], item.Name)
    end
end

local Tabs = {
    Home = Window:Tab({ Title = "Home", Icon = "scan-face" }),
    Main = Window:Tab({ Title = "Main", Icon = "landmark" }),
    Auto = Window:Tab({ Title = "Automatically", Icon = "play" }),
    Shop = Window:Tab({ Title = "Shop", Icon = "shopping-bag" }),
    Upgrade = Window:Tab({ Title = "Upgrade", Icon = "chart-column-increasing" }),
    Utility = Window:Tab({ Title = "Utility", Icon = "wrench" }),
    Misc = Window:Tab({ Title = "Miscellaneous", Icon = "layout-grid" }),
    Settings = Window:Tab({ Title = "Settings", Icon = "settings"})
}

local defaultWalk = 16
local defaultJump = 50
local currentWalk = defaultWalk
local currentJump = defaultJump

Tabs.Home:Section({ Title = "Information" })

Tabs.Home:Button({
    Title    = "Discord",
    Desc     = "Copy Discord Link",
    Callback = function()
        local link = "https://discord.gg/jdmX43t5mY"
        if setclipboard then
            setclipboard(link)
        end
    end,
})

Tabs.Home:Paragraph({
    Title = "Join Us",
    Desc  = "Every Update Will Be On Discord",
})

Tabs.Home:Paragraph({
    Title = "Support",
    Desc  = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
})

Tabs.Home:Section({ Title = "Local Player" })

Tabs.Home:Slider({
    Title    = "WalkSpeed",
    Step     = 1,
    Value    = { Min = 0, Max = 100, Default = defaultWalk },
    Callback = function(value)
        currentWalk = value
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end,
})

Tabs.Home:Slider({
    Title    = "JumpPower",
    Step     = 1,
    Value    = { Min = 0, Max = 150, Default = defaultJump },
    Callback = function(value)
        currentJump = value
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end,
})

Tabs.Home:Button({
    Title    = "Reset Default",
    Callback = function()
        currentWalk = defaultWalk
        currentJump = defaultJump
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = defaultWalk
            char.Humanoid.JumpPower = defaultJump
        end
    end,
})


Tabs.Main:Section({ Title = "Roll Seeds" })

Tabs.Main:Toggle({
    Title = "Auto Roll Seeds",
    Default = false,
    Callback = function(Value)
        _G.AutoRollSeeds = Value

        task.spawn(function()
            while _G.AutoRollSeeds do
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.RollSeeds:FireServer()
                end)
                task.wait(1)
            end
        end)
    end
})

Tabs.Main:Button({
    Title = "Roll Seeds",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").Remotes.RollSeeds
        Event:FireServer()
    end
})

local selectedCompostSeeds = {}

local compostSeedsByRarity = {}
for _, r in ipairs(rarityOrder) do
    compostSeedsByRarity[r] = {}
end

for _, child in ipairs(seedScrollFrame:GetChildren()) do
    if child:IsA("Frame") then
        local icon   = child:FindFirstChild("Icon")
        local rarity = child:FindFirstChild("RarityName")
        local sname  = child:FindFirstChild("SeedName")
        local name   = (sname and sname.Text ~= "???" and sname.Text) or child.Name
        local rar    = (rarity and rarity.Text) or "Common"
        local bucket = compostSeedsByRarity[rar] or compostSeedsByRarity["Common"]
        table.insert(bucket, { Name = name, Icon = icon and icon.Image or "" })
    end
end

Tabs.Main:Section({ Title = "Seeds Compost" })

local compostRarityDropdowns = {}

for _, r in ipairs(rarityOrder) do
    if #compostSeedsByRarity[r] > 0 then
        local names = {}
        for _, item in ipairs(compostSeedsByRarity[r]) do
            table.insert(names, item.Name)
        end
        local dd = Tabs.Main:Dropdown({
            Title     = r .. " Seeds",
            Values    = names,
            Value     = {},
            Multi     = true,
            AllowNone = true,
            Callback  = function(selected)
                for _, item in ipairs(compostSeedsByRarity[r]) do
                    selectedCompostSeeds[item.Name] = nil
                end
                if type(selected) == "table" then
                    for _, name in ipairs(selected) do
                        selectedCompostSeeds[name] = true
                    end
                end
            end,
        })
        compostRarityDropdowns[r] = dd
    end
end

Tabs.Main:Button({
    Title    = "Deselect all",
    Callback = function()
        selectedCompostSeeds = {}
        for _, dd in pairs(compostRarityDropdowns) do
            dd:Select({})
        end
    end,
})

local function getSelectedSeedTools()
    local out = {}
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("InventoryCategory") == "Seeds" then
            local plantName = tool:GetAttribute("Plant") or tool.Name
            if selectedCompostSeeds[plantName] then
                local level    = tostring(tool:GetAttribute("Level") or 1)
                local mutation = tostring(tool:GetAttribute("Mutation") or "Normal")
                table.insert(out, {
                    plantName = plantName,
                    level     = level,
                    mutation  = mutation,
                })
            end
        end
    end
    return out
end

local Composter = ReplicatedStorage.Remotes.Composter

local function formatValue(n)
    if n >= 1e12 then
        return string.format("%.2fT", n / 1e12)
    elseif n >= 1e9 then
        return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.2fM", n / 1e6)
    else
        return tostring(n)
    end
end

local composterFloor = 3
local composting     = false
local stopComposting = false

Tabs.Main:Section({ Title = "Floor Selection" })

Tabs.Main:Dropdown({
    Title    = "Composter floor",
    Values   = { "Floor 3", "Floor 2" },
    Value    = "Floor 3",
    Callback = function(v)
        composterFloor = (v == "Floor 2") and 2 or 3
    end,
})

Tabs.Main:Paragraph({
    Title = "Note",
    Desc  = "Uses seeds selected in the 'Seeds to Compost' tab.",
})

local function runCompostLoop()
    while not stopComposting do
        local seedTools = getSelectedSeedTools()
        if #seedTools == 0 then
            task.wait(5)
            continue
        end
        for _, entry in ipairs(seedTools) do
            if stopComposting then break end
            local seedKey = entry.plantName .. "_" .. entry.level .. "_" .. entry.mutation
            local ok, _   = pcall(function()
                Composter.InsertSeed:InvokeServer(composterFloor, seedKey, 1)
            end)
            if not ok then
                task.wait(0.5)
                continue
            end
            task.wait(0.2)
            local state = nil
            pcall(function()
                state = Composter.RequestState:InvokeServer(composterFloor)
            end)
            if not state then
                task.wait(0.3)
                continue
            end
            local shouldPull = false
            if state.TooRich then
                shouldPull = true
            elseif composterFloor == 3 and state.Value >= 25e12 then
                shouldPull = true
            end
            if shouldPull then
                pcall(function() Composter.PullLever:InvokeServer(composterFloor) end)
                task.wait(1)
                break
            end
            task.wait(0.1)
        end
    end
    composting = false
end

Tabs.Main:Section({ Title = "Compost" })

Tabs.Main:Toggle({
    Title    = "Auto Compost",
    Default  = false,
    Callback = function(state)
        if state then
            if composting then return end
            composting = true; stopComposting = false
            task.spawn(runCompostLoop)
        else
            stopComposting = true
        end
    end,
})

Tabs.Main:Button({
    Title    = "Insert once",
    Callback = function()
        task.spawn(function()
            local seedTools = getSelectedSeedTools()
            if #seedTools == 0 then return end
            for _, entry in ipairs(seedTools) do
                local seedKey = entry.plantName .. "_" .. entry.level .. "_" .. entry.mutation
                pcall(function()
                    Composter.InsertSeed:InvokeServer(composterFloor, seedKey, 1)
                end)
                task.wait(0.15)
            end
        end)
    end,
})

Tabs.Main:Section({ Title = "Check State" })

Tabs.Main:Button({
    Title    = "Request State",
    Callback = function()
        task.spawn(function()
            local state = nil
            pcall(function()
                state = Composter.RequestState:InvokeServer(composterFloor)
            end)
        end)
    end,
})

Tabs.Main:Section({ Title = "Rewards" })

Tabs.Main:Button({
    Title = "Claim Playtime Reward",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").Remotes.GetPlaytimeRewardState
        Event:InvokeServer()
    end
})

Tabs.Main:Section({ Title = "Spin Wheel" })

Tabs.Main:Toggle({
    Title = "Auto Spin Wheel",
    Default = false,
    Callback = function(Value)
        _G.AutoSpinWheel = Value

        task.spawn(function()
            while _G.AutoSpinWheel do
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.SpinWheel.RequestSpin:InvokeServer(false)
                end)
                task.wait(5)
            end
        end)
    end
})

Tabs.Main:Section({ Title = "Sell Crates" })

Tabs.Main:Toggle({
    Title = "Auto Sell Crates",
    Default = false,
    Callback = function(Value)
        _G.AutoSellCrates = Value

        task.spawn(function()
            while _G.AutoSellCrates do
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.SellCrates:FireServer()
                end)
                task.wait(2)
            end
        end)
    end
})

Tabs.Main:Button({
    Title = "Sell Crates",
    Callback = function()
        local Event = game:GetService("ReplicatedStorage").Remotes.SellCrates
        Event:FireServer()
    end
})

local selectedPets = {}

local petScrollFrame = player.PlayerGui
    :WaitForChild("MainUI")
    :WaitForChild("Menus")
    :WaitForChild("IndexFrame")
    :WaitForChild("Main")
    :WaitForChild("PetsFrame")

local petItems     = {}
local petItemNames = {}

for _, child in ipairs(petScrollFrame:GetChildren()) do
    if child:IsA("Frame") then
        local sname       = child:FindFirstChild("SeedName")
        local rarity      = child:FindFirstChild("RarityName")
        local name        = (sname and sname.Text ~= "???" and sname.Text) or child.Name
        local rar         = rarity and rarity.Text or ""
        local displayName = (rar ~= "") and (name .. " (" .. rar .. ")") or name
        table.insert(petItems, { Name = name, Display = displayName })
        table.insert(petItemNames, displayName)
    end
end

local displayToRealName = {}
for _, item in ipairs(petItems) do
    displayToRealName[item.Display] = item.Name
end

Tabs.Main:Section({ Title = "Sell Pets" })

local petMultiDD = Tabs.Main:Dropdown({
    Title     = "Select Pets",
    Values    = petItemNames,
    Value     = {},
    Multi     = true,
    AllowNone = true,
    Callback  = function(selected)
        selectedPets = {}
        if type(selected) == "table" then
            for _, display in ipairs(selected) do
                local realName = displayToRealName[display]
                if realName then
                    selectedPets[realName] = true
                end
            end
        end
    end,
})

Tabs.Main:Button({
    Title    = "Deselect all",
    Callback = function()
        selectedPets = {}
        petMultiDD:Select({})
    end,
})

local sellingPets     = false
local stopSellingPets = false

local function getSelectedPetTools()
    local out = {}
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("InventoryCategory") == "Pets" then
            local trueName = tool:GetAttribute("trueName") or tool.Name
            local petKey   = tool:GetAttribute("petKey")
            if selectedPets[trueName] and petKey then
                table.insert(out, { trueName = trueName, petKey = petKey })
            end
        end
    end
    return out
end

Tabs.Main:Toggle({
    Title    = "Auto Sell Pets",
    Default  = false,
    Callback = function(state)
        if state then
            if sellingPets then return end
            sellingPets = true; stopSellingPets = false
            task.spawn(function()
                while not stopSellingPets do
                    local pets = getSelectedPetTools()
                    for _, entry in ipairs(pets) do
                        if stopSellingPets then break end
                        pcall(function()
                            ReplicatedStorage.Remotes.SellPet:InvokeServer(entry.petKey)
                        end)
                        task.wait(0.3)
                    end
                    task.wait(2)
                end
                sellingPets = false
            end)
        else
            stopSellingPets = true
        end
    end,
})

Tabs.Main:Button({
    Title    = "Sell Now",
    Callback = function()
        task.spawn(function()
            local pets = getSelectedPetTools()
            if #pets == 0 then return end
            for _, entry in ipairs(pets) do
                pcall(function()
                    ReplicatedStorage.Remotes.SellPet:InvokeServer(entry.petKey)
                end)
                task.wait(0.3)
            end
        end)
    end,
})

local optimizing     = false
local stopOptimizing = false

Tabs.Main:Section({ Title = "Optimize Pets" })

Tabs.Main:Toggle({
    Title    = "Auto Optimize",
    Default  = false,
    Callback = function(state)
        if state then
            if optimizing then return end
            optimizing = true; stopOptimizing = false
            task.spawn(function()
                while not stopOptimizing do
                    optimizePets()
                    local elapsed = 0
                    while elapsed < 30 and not stopOptimizing do
                        task.wait(1)
                        elapsed += 1
                    end
                end
                optimizing = false
            end)
        else
            stopOptimizing = true
        end
    end,
})

Tabs.Main:Button({
    Title    = "Optimize now",
    Callback = function()
        task.spawn(optimizePets)
    end,
})

local unlockRemote  = ReplicatedStorage.Remotes.UnlockPlot
local autoUnlocking = false
local stopUnlocking = false

local function getLockedDirts()
    local out = {}
    for _, fp in ipairs(getFarmPlots()) do
        for _, plant in ipairs(fp:GetChildren()) do
            local dirt     = plant:FindFirstChild("Dirt")
            local unlocked = plant:GetAttribute("Unlocked")
            if dirt and (unlocked == false or unlocked == nil) then
                table.insert(out, dirt)
            end
        end
    end
    return out
end

Tabs.Main:Section({ Title = "Unlock Plot" })

Tabs.Main:Toggle({
    Title    = "Auto Unlock Plot",
    Default  = false,
    Callback = function(state)
        if state then
            if autoUnlocking then return end
            autoUnlocking = true; stopUnlocking = false
            task.spawn(function()
                while not stopUnlocking do
                    local dirts = getLockedDirts()
                    for _, dirt in ipairs(dirts) do
                        if stopUnlocking then break end
                        pcall(function()
                            unlockRemote:FireServer(dirt)
                        end)
                        task.wait(0.5)
                    end
                    task.wait(3)
                end
                autoUnlocking = false
            end)
        else
            stopUnlocking = true
        end
    end,
})

Tabs.Main:Button({
    Title    = "Unlock All Now",
    Callback = function()
        task.spawn(function()
            local dirts = getLockedDirts()
            for _, dirt in ipairs(dirts) do
                pcall(function()
                    unlockRemote:FireServer(dirt)
                end)
                task.wait(0.5)
            end
        end)
    end,
})


Tabs.Auto:Section({ Title = "Auto Collect" })

local collecting     = false
local stopCollecting = false

Tabs.Auto:Toggle({
    Title    = "Auto Collect",
    Default  = false,
    Callback = function(state)
        if state then
            if collecting then return end
            collecting = true; stopCollecting = false
            task.spawn(function()
                while not stopCollecting do
                    pcall(function()
                        ReplicatedStorage.Remotes.SellCrates:FireServer()
                    end)
                    task.wait(120)
                end
                collecting = false
            end)
        else
            stopCollecting = true
        end
    end,
})

Tabs.Auto:Section({ Title = "Auto Fertilizer" })

local fertilizing     = false
local stopFertilizing = false

Tabs.Auto:Toggle({
    Title    = "Auto Fertilizer",
    Default  = false,
    Callback = function(state)
        if state then
            if fertilizing then return end
            fertilizing = true; stopFertilizing = false
            task.spawn(function()
                while not stopFertilizing do
                    local tool = getFertilizerFromBackpack()
                    if tool then
                        local dirt = getUnfertilizedDirt()
                        if dirt then
                            humanoid:EquipTool(tool)
                            task.wait(0.5)
                            pcall(function()
                                ReplicatedStorage.Remotes.UseFertilizer:FireServer(dirt)
                            end)
                            task.wait(0.5)
                            humanoid:UnequipTools()
                            task.wait(0.1)
                        else
                            task.wait(5)
                        end
                    else
                        task.wait(5)
                    end
                end
                fertilizing = false
            end)
        else
            stopFertilizing = true
        end
    end,
})

local PET_TREAT_NAMES = {
    "Super Pet Treat",
    "Strong Pet Treat",
    "Normal Pet Treat",
}

local function getPetTreatFromBackpack()
    for _, name in ipairs(PET_TREAT_NAMES) do
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if string.find(tool.Name, name, 1, true) then
                return tool
            end
        end
    end
    return nil
end

local function getMyPets()
    local out = {}
    for _, obj in ipairs(myPlot:GetDescendants()) do
        if obj:IsA("Model") and obj:GetAttribute("PetKey") ~= nil then
            if obj:GetAttribute("PetOwner") == player.Name then
                table.insert(out, obj)
            end
        end
    end
    return out
end

Tabs.Auto:Section({ Title = "Auto Pet Treat" })

local treatingPet     = false
local stopTreatingPet = false

Tabs.Auto:Toggle({
    Title    = "Auto Pet Treat",
    Default  = false,
    Callback = function(state)
        if state then
            if treatingPet then return end
            treatingPet = true; stopTreatingPet = false
            task.spawn(function()
                while not stopTreatingPet do
                    local pets = getMyPets()
                    if #pets > 0 then
                        for _, pet in ipairs(pets) do
                            if stopTreatingPet then break end
                            local boosted = pet:GetAttribute("PetBoosted")
                            if not boosted then
                                local tool = getPetTreatFromBackpack()
                                if tool then
                                    humanoid:EquipTool(tool)
                                    task.wait(0.5)
                                    pcall(function()
                                        ReplicatedStorage.Remotes.UsePetTreat:FireServer(pet)
                                    end)
                                    task.wait(0.5)
                                    humanoid:UnequipTools()
                                    task.wait(0.1)
                                else
                                    task.wait(5)
                                    break
                                end
                            end
                        end
                    else
                        task.wait(5)
                    end
                    task.wait(1)
                end
                treatingPet = false
            end)
        else
            stopTreatingPet = true
        end
    end,
})


Tabs.Shop:Section({ Title = "Purchased Shop" })

local shopInterval     = 120
local buyingShop       = false
local stopBuyingShop   = false
local selectedGear     = {}
local stockLabelByName = {}

Tabs.Shop:Slider({
    Title    = "Scan interval",
    Step     = 1,
    Value    = { Min = 10, Max = 300, Default = 120 },
    Callback = function(v) shopInterval = v end,
})

Tabs.Shop:Toggle({
    Title    = "Auto Purchased Shop",
    Default  = false,
    Callback = function(state)
        if state then
            if buyingShop then return end
            buyingShop = true; stopBuyingShop = false
            task.spawn(function()
                while not stopBuyingShop do
                    if next(selectedGear) ~= nil then
                        for itemName in pairs(selectedGear) do
                            if stopBuyingShop then break end
                            local stock = parseStock(stockLabelByName[itemName])
                            if stock > 0 then
                                for i = 1, stock do
                                    if stopBuyingShop then break end
                                    local ok, _ = pcall(function()
                                        ReplicatedStorage.Remotes.Gear.Transaction:InvokeServer(itemName)
                                    end)
                                    if not ok then break end
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                    local elapsed = 0
                    while elapsed < shopInterval and not stopBuyingShop do
                        task.wait(1)
                        elapsed += 1
                    end
                end
                buyingShop = false
            end)
        else
            stopBuyingShop = true
        end
    end,
})

local selectedSeeds = {}
local buying        = false
local stopBuying    = false

Tabs.Shop:Section({ Title = "Seed Selection by Rarity" })

Tabs.Shop:Paragraph({
    Title = "How to use",
    Desc  = "Select a rarity from the dropdown, then pick seeds. Enable Auto-Buy Seeds in the Auto tab.",
})

local currentRarity = rarityOrder[1]
local rarityValues  = {}

for _, r in ipairs(rarityOrder) do
    if #seedsByRarity[r] > 0 then
        table.insert(rarityValues, r)
    end
end

local seed = Tabs.Shop:Dropdown({
    Title    = "Select Rarity",
    Values   = rarityValues,
    Value    = rarityValues[1],
    Callback = function(v)
        currentRarity = v
    end,
})

local rarityDropdowns = {}

for _, r in ipairs(rarityOrder) do
    if #seedsByRarity[r] > 0 then
        local names = {}
        for _, item in ipairs(seedsByRarity[r]) do
            table.insert(names, item.Name)
        end
        local dd = Tabs.Shop:Dropdown({
            Title     = r .. " Seeds",
            Values    = names,
            Value     = {},
            Multi     = true,
            AllowNone = true,
            Callback  = function(selected)
                for _, item in ipairs(seedsByRarity[r]) do
                    selectedSeeds[item.Name] = nil
                end
                if type(selected) == "table" then
                    for _, name in ipairs(selected) do
                        selectedSeeds[name] = true
                    end
                end
            end,
        })
        rarityDropdowns[r] = dd
    end
end

Tabs.Shop:Button({
    Title    = "Deselect all seeds",
    Callback = function()
        selectedSeeds = {}
        for _, dd in pairs(rarityDropdowns) do
            dd:Select({})
        end
    end,
})

Tabs.Shop:Section({ Title = "Gear Shop" })

local shopItems = getShopItems()
local shopItemNames = {}

for _, item in ipairs(shopItems) do
    table.insert(shopItemNames, item.Name)
    stockLabelByName[item.Name] = item.StockLabel
end

local shopMulti = Tabs.Shop:Dropdown({
    Title     = "Select Gear to Buy",
    Values    = shopItemNames,
    Value     = {},
    Multi     = true,
    AllowNone = true,
    Callback  = function(selected)
        selectedGear = {}
        if type(selected) == "table" then
            for _, name in ipairs(selected) do
                selectedGear[name] = true
            end
        end
    end,
})

Tabs.Shop:Button({
    Title    = "Deselect all",
    Callback = function()
        selectedGear = {}
        shopMulti:Select({})
    end,
})

local selectedEggs = {}
local buyingEggs   = false
local stopEggs     = false

local EGG_SLOTS = { "Common Egg", "Rare Egg", "Epic Egg" }

Tabs.Shop:Section({ Title = "Eggs Shop" })

for _, eggName in ipairs(EGG_SLOTS) do
    Tabs.Shop:Toggle({
        Title    = eggName,
        Default  = false,
        Callback = function(state)
            selectedEggs[eggName] = state or nil
        end,
    })
end

Tabs.Shop:Toggle({
    Title    = "Auto Eggs",
    Default  = false,
    Callback = function(state)
        if state then
            if buyingEggs then return end
            buyingEggs = true; stopEggs = false
            task.spawn(function()
                while not stopEggs do
                    local live = scanEggs()
                    for _, egg in ipairs(live) do
                        if stopEggs then break end
                        if selectedEggs[egg.name] then
                            local podium     = petMerchant and petMerchant:FindFirstChild("Podium" .. egg.podiumIdx .. "Lever")
                            local attachment = podium and podium:FindFirstChild("PromptAttachment")
                            local prompt     = attachment and attachment:FindFirstChild("EggShopPrompt")
                            if prompt and not prompt.ObjectText:find("Slot") then
                                fireproximityprompt(prompt)
                            end
                            task.wait(0.3)
                        end
                    end
                    local elapsed = 0
                    while elapsed < 120 and not stopEggs do
                        task.wait(1)
                        elapsed += 1
                    end
                end
                buyingEggs = false
            end)
        else
            stopEggs = true
        end
    end,
})

Tabs.Shop:Button({
    Title    = "Roll Now",
    Callback = function()
        local live = scanEggs()
        for _, egg in ipairs(live) do
            if selectedEggs[egg.name] then
                local podium     = petMerchant and petMerchant:FindFirstChild("Podium" .. egg.podiumIdx .. "Lever")
                local attachment = podium and podium:FindFirstChild("PromptAttachment")
                local prompt     = attachment and attachment:FindFirstChild("EggShopPrompt")
                if prompt and not prompt.ObjectText:find("Slot") then
                    fireproximityprompt(prompt)
                end
                task.wait(0.3)
            end
        end
    end,
})

Tabs.Shop:Section({ Title = "Seeds Shop" })

Tabs.Shop:Toggle({
    Title    = "Auto Buy Seeds",
    Default  = false,
    Callback = function(state)
        if state then
            if buying then return end
            buying = true; stopBuying = false
            task.spawn(function()
                while not stopBuying do
                    if next(selectedSeeds) == nil then
                        task.wait(1)
                        continue
                    end
                    pcall(function()
                        ReplicatedStorage.Remotes.RollSeeds:FireServer()
                    end)
                    task.wait(4)
                    for seedName, standIdx in pairs(getWorldSeeds()) do
                        if stopBuying then break end
                        if selectedSeeds[seedName] then
                            pcall(function()
                                ReplicatedStorage.Remotes.BuySeed:FireServer(standIdx)
                            end)
                            task.wait(0.5)
                        end
                    end
                    task.wait(1)
                end
                buying = false
            end)
        else
            stopBuying = true
        end
    end,
})


local perPlantTargetLevel = 10
local upgrading           = false
local stopUpgrading       = false

Tabs.Upgrade:Section({ Title = "Plant Upgrade" })

Tabs.Upgrade:Input({
    Title       = "Target level",
    Default     = tostring(perPlantTargetLevel),
    Placeholder = "1 - 75",
    MultiLine   = false,
    Callback    = function(v)
        local n = tonumber(v)
        if n then perPlantTargetLevel = math.clamp(math.floor(n), 1, 75) end
    end,
})

Tabs.Upgrade:Toggle({
    Title    = "Auto Upgrade selected plants",
    Default  = false,
    Callback = function(state)
        if state then
            if upgrading then return end
            if next(selectedPlantsForUpgrade) == nil then return end
            upgrading = true; stopUpgrading = false

            task.spawn(function()
                while not stopUpgrading do
                    local allDone      = true
                    local dirtsToUpgrade = {}

                    for _, item in ipairs(plantCardItems) do
                        local pName = pNameByCardName[item.Name]
                        if pName and selectedPlantsForUpgrade[pName] then
                            local dirt = dirtByCardName[item.Name]
                            if dirt then
                                table.insert(dirtsToUpgrade, { dirt = dirt, pName = pName })
                            end
                        end
                    end

                    for _, entry in ipairs(dirtsToUpgrade) do
                        if stopUpgrading then break end
                        local dirt = entry.dirt
                        local lvl  = dirt:GetAttribute("PlantLevel") or 0
                        if lvl >= perPlantTargetLevel then continue end
                        allDone = false

                        local ok, result = pcall(function()
                            return ReplicatedStorage.Remotes.UpgradePlant:InvokeServer(dirt)
                        end)

                        if not ok or (type(result) == "boolean" and result == false) then
                            fullRescan(true)
                            local elapsed = 0
                            while elapsed < 60 and not stopUpgrading do
                                task.wait(1)
                                elapsed += 1
                            end
                        else
                            task.wait(0.1)
                        end
                    end

                    if not stopUpgrading and allDone then
                        stopUpgrading = true
                    end
                end
                upgrading = false
            end)
        else
            stopUpgrading = true
        end
    end,
})

Tabs.Upgrade:Button({
    Title    = "Rescan plants",
    Callback = function()
        fullRescan(false)
    end,
})

Tabs.Upgrade:Section({ Title = "Auto Upgrade Plants" })

local targetLevel = 10

Tabs.Upgrade:Slider({
    Title    = "Target level",
    Step     = 1,
    Value    = { Min = 1, Max = 75, Default = 10 },
    Callback = function(v) targetLevel = tonumber(v) or 10 end,
})

Tabs.Upgrade:Button({
    Title    = "Upgrade all plants",
    Callback = function()
        local farmPlots = getFarmPlots()
        if #farmPlots == 0 then return end
        task.spawn(function()
            local upgraded = 0
            for _, fp in ipairs(farmPlots) do
                for _, plant in ipairs(fp:GetChildren()) do
                    local dirt = plant:FindFirstChild("Dirt")
                    if dirt and dirt:GetAttribute("PlantLevel") ~= nil then
                        local lvl = tonumber(dirt:GetAttribute("PlantLevel")) or 0
                        while lvl < targetLevel do
                            local ok, result = pcall(function()
                                return ReplicatedStorage.Remotes.UpgradePlant:InvokeServer(dirt)
                            end)
                            if not ok or (type(result) == "boolean" and result == false) then
                                task.wait(60)
                            else
                                task.wait(0.1)
                            end
                            lvl = tonumber(dirt:GetAttribute("PlantLevel")) or 0
                        end
                        upgraded += 1
                    end
                end
            end
        end)
    end,
})

fullRescan(false)

local plantNames = {}
for _, item in ipairs(plantCardItems) do
    table.insert(plantNames, item.Name)
end

local plantMultiDD = Tabs.Upgrade:Dropdown({
    Title     = "Select Plants",
    Values    = plantNames,
    Value     = {},
    Multi     = true,
    AllowNone = true,
    Callback  = function(selected)
        clearAllHighlights()
        selectedPlantsForUpgrade = {}
        if type(selected) == "table" then
            for _, cardName in ipairs(selected) do
                local pName = pNameByCardName[cardName]
                if pName then
                    selectedPlantsForUpgrade[pName] = true
                    local model = modelByCardName[cardName]
                    if model and not highlightParts[pName] then
                        addHighlight(pName, model)
                    end
                end
            end
        end
    end,
})

Tabs.Upgrade:Button({
    Title    = "Select all",
    Callback = function()
        local allNames = {}
        local seen     = {}
        for _, item in ipairs(plantCardItems) do
            table.insert(allNames, item.Name)
            local pName = pNameByCardName[item.Name]
            if pName and not seen[pName] then
                seen[pName]                      = true
                selectedPlantsForUpgrade[pName]  = true
                local model = modelByCardName[item.Name]
                if model and not highlightParts[pName] then
                    addHighlight(pName, model)
                end
            end
        end
        plantMultiDD:Select(allNames)
    end,
})

Tabs.Upgrade:Button({
    Title    = "Deselect all",
    Callback = function()
        clearAllHighlights()
        selectedPlantsForUpgrade = {}
        plantMultiDD:Select({})
    end,
})


Tabs.Utility:Section({ Title = "Detected plot" })

Tabs.Utility:Paragraph({
    Title = "Your Plot",
    Desc  = myPlot.Name,
})

Tabs.Utility:Section({ Title = "Eggs on startup" })

for _, egg in ipairs(initialEggs) do
    Tabs.Utility:Paragraph({
        Title = "Podium " .. egg.podiumIdx,
        Desc  = egg.name,
    })
end


Tabs.Misc:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infJump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)


Tabs.Misc:Button({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
})

Tabs.Misc:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        noclip = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

Tabs.Misc:Toggle({
    Title = "Auto Reconnect",
    Default = false,
    Callback = function(state)
        autoReconnect = state

        if autoReconnect then
            local ts = game:GetService("TeleportService")
            local player = game.Players.LocalPlayer

            game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if autoReconnect and child.Name == "ErrorPrompt" then
                    task.wait(2)
                    ts:Teleport(game.PlaceId, player)
                end
            end)
        end
    end
})

Tabs.Misc:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(state)
        antiAFK = state

        if antiAFK then
            local vu = game:GetService("VirtualUser")

            afkConnection = game.Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end
})


Tabs.Settings:Button({
    Title = "Rejoin",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        ts:Teleport(game.PlaceId, player)
    end
})

Tabs.Settings:Button({
    Title = "Server Hop",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        local placeId = game.PlaceId
        local servers = game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
        )
        for _, v in pairs(servers.data) do
            if v.playing < v.maxPlayers then
                ts:TeleportToPlaceInstance(placeId, v.id, player)
                break
            end
        end
    end
})

Tabs.Settings:Paragraph({
    Title = "Current Server",
    Desc = "You are in server: " .. game.JobId
})

Tabs.Settings:Input({
    Title = "Target Server ID",
    Default = "",
    Placeholder = "Enter JobId...",
    MultiLine = false,
    Callback = function(input)
        if input ~= "" then
            local found = false
            for _, id in ipairs(savedServers) do
                if id == input then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(savedServers, 1, input)
                refreshDropdown()
            end
            inputObj = input
        end
    end
})

Tabs.Settings:Button({
    Title = "Teleport",
    Callback = function()
        local target = inputObj
        if target and target ~= "" then
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, target)
            end)
        end
    end
})


StreeHub:Notify({
    Title = "StreeHub",
    Content = "Script loaded successfully",
    Icon = "bell-ring",
    Duration = 4
})
