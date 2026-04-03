local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(620, 370)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local killAuraToggle = false
local chopAuraToggle = false
local auraRadius = 50
local currentammount = 0

local toolsDamageIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

local autoFeedToggle = false
local selectedFood = {}
local hungerThreshold = 75
local alwaysFeedEnabledItems = {}
local alimentos = {
    "Apple",
    "Berry",
    "Carrot",
    "Cake",
    "Chili",
    "Cooked Morsel",
    "Cooked Steak"
}

local ie = {
    "Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Carrot", "Chair", "Coal", "Coin Stack",
    "Cooked Morsel", "Cooked Steak", "Fuel Canister", "Iron Body", "Leather Armor", "Log", "MadKit", "Metal Chair",
    "MedKit", "Old Car Engine", "Old Flashlight", "Old Radio", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo",
    "Morsel", "Sheet Metal", "Steak", "Tyre", "Washing Machine"
}
local me = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Cultist", "Crossbow Cultist", "Alien"}

local junkItems = {"Tyre", "Bolt", "Broken Fan", "Broken Microwave", "Sheet Metal", "Old Radio", "Washing Machine", "Old Car Engine"}
local selectedJunkItems = {}
local fuelItems = {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel"}
local selectedFuelItems = {}
local foodItems = {"Cake", "Cooked Steak", "Cooked Morsel", "Steak", "Morsel", "Berry", "Carrot"}
local selectedFoodItems = {}
local medicalItems = {"Bandage", "MedKit"}
local selectedMedicalItems = {}
local equipmentItems = {"Revolver", "Rifle", "Leather Body", "Iron Body", "Revolver Ammo", "Rifle Ammo", "Giant Sack", "Good Sack", "Strong Axe", "Good Axe"}
local selectedEquipmentItems = {}

local isCollecting = false
local originalPosition = nil
local autoBringEnabled = false

local junkToggleEnabled = false
local fuelToggleEnabled = false
local foodToggleEnabled = false
local medicalToggleEnabled = false
local equipmentToggleEnabled = false

local junkLoopRunning = false
local fuelLoopRunning = false
local foodLoopRunning = false
local medicalLoopRunning = false
local equipmentLoopRunning = false

local chopAuraEnabled = false
local chopAuraRadius = 50

local killAuraEnabled = false
local killAuraRadius = 50

local autoCookEnabled = false
local autoCookEnabledItems = {}
local autocookItems = {"Morsel", "Steak"}
local autoUpgradeCampfireEnabled = false
local selectedCampfireItem = nil
local campfireFuelItems = {"Log", "Chair", "Coal"}
local campfireDropPos = Vector3.new(-15.5, 8.12, -82.6)

local espItemsEnabled = false
local espMobsEnabled = false
local selectedItems = {}
local selectedMobs = {}
local espConnections = {}

local currentChests = {}
local currentChestNames = {}
local currentMobs = {}
local currentMobNames = {}
local selectedChest = nil
local selectedMob = nil

local function smoothPullToItem(startPos, endPos, duration)
    local player = game.Players.LocalPlayer
    local hrp = player.Character.HumanoidRootPart
    
    local startTime = tick()
    local distance = (endPos.Position - startPos.Position).Magnitude
    local direction = (endPos.Position - startPos.Position).Unit
    
    spawn(function()
        while tick() - startTime < duration do
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            
            local easedProgress = progress < 0.5 
                and 2 * progress * progress 
                or 1 - math.pow(-2 * progress + 2, 2) / 2
            
            local currentPos = startPos.Position:lerp(endPos.Position, easedProgress)
            local lookDirection = endPos.Position - currentPos
            
            if lookDirection.Magnitude > 0 then
                hrp.CFrame = CFrame.lookAt(currentPos, currentPos + lookDirection.Unit)
            else
                hrp.CFrame = CFrame.new(currentPos)
            end
            
            wait()
        end
        
        hrp.CFrame = endPos
    end)
    
    wait(duration)
end

local function createItemPullEffect(itemPart, targetPos, duration)
    if not itemPart or not itemPart.Parent then return end
    
    local startPos = itemPart.Position
    local startTime = tick()
    
    spawn(function()
        while tick() - startTime < duration do
            if not itemPart or not itemPart.Parent then break end
            
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            
            local easedProgress = 1 - math.pow(1 - progress, 3)
            
            local currentPos = Vector3.new(
                startPos.X + (targetPos.X - startPos.X) * easedProgress,
                startPos.Y + (targetPos.Y - startPos.Y) * easedProgress,
                startPos.Z + (targetPos.Z - startPos.Z) * easedProgress
            )
            
            pcall(function()
                itemPart.CFrame = CFrame.new(currentPos)
                itemPart.Velocity = Vector3.new(0, 0, 0)
                itemPart.AngularVelocity = Vector3.new(0, 0, 0)
            end)
            
            wait()
        end
        
        pcall(function()
            itemPart.CFrame = CFrame.new(targetPos)
            itemPart.Velocity = Vector3.new(0, 0, 0)
            itemPart.AngularVelocity = Vector3.new(0, 0, 0)
        end)
    end)
    
    wait(duration)
end

local function bypassBringSystem(items, stopFlag)
    if isCollecting then 
        return 
    end
    
    isCollecting = true
    local player = game.Players.LocalPlayer
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
        isCollecting = false
        return 
    end
    
    local hrp = player.Character.HumanoidRootPart
    originalPosition = hrp.CFrame
    
    for _, itemName in ipairs(items) do
        if stopFlag and not stopFlag() then
            break
        end
        
        local itemsFound = {}
        
        for _, item in ipairs(workspace:GetDescendants()) do
            if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                local itemPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                if itemPart and itemPart.Parent ~= player.Character then
                    table.insert(itemsFound, {item = item, part = itemPart})
                end
            end
        end
        
        for _, itemData in ipairs(itemsFound) do
            if stopFlag and not stopFlag() then
                break
            end
            
            local item = itemData.item
            local itemPart = itemData.part
            
            if itemPart and itemPart.Parent then
                local itemPos = itemPart.CFrame + Vector3.new(0, 5, 0)
                smoothPullToItem(hrp.CFrame, itemPos, 1.2)
                
                local playerPos = hrp.Position + Vector3.new(0, -1, 0)
                createItemPullEffect(itemPart, playerPos, 0.8)
                
                local keepAttached = true
                spawn(function()
                    while keepAttached do
                        if stopFlag and not stopFlag() then
                            keepAttached = false
                            break
                        end
                        
                        if not itemPart or not itemPart.Parent then
                            keepAttached = false
                            break
                        end
                        
                        local currentHrpPos = hrp.Position
                        local targetItemPos = currentHrpPos + Vector3.new(0, -1, 0)
                        
                        pcall(function()
                            itemPart.CFrame = CFrame.new(targetItemPos)
                            itemPart.Velocity = Vector3.new(0, 0, 0)
                            itemPart.AngularVelocity = Vector3.new(0, 0, 0)
                        end)
                        
                        wait()
                    end
                end)
                
                smoothPullToItem(hrp.CFrame, originalPosition, 1.2)
                keepAttached = false
                
                wait(0.5)
            end
        end
    end
    
    if hrp and originalPosition then
        smoothPullToItem(hrp.CFrame, originalPosition, 1.0)
    end
    
    isCollecting = false
end

local function stopJunkLoop()
    junkToggleEnabled = false
    junkLoopRunning = false
end

local function stopFuelLoop()
    fuelToggleEnabled = false
    fuelLoopRunning = false
end

local function stopFoodLoop()
    foodToggleEnabled = false
    foodLoopRunning = false
end

local function stopMedicalLoop()
    medicalToggleEnabled = false
    medicalLoopRunning = false
end

local function stopEquipmentLoop()
    equipmentToggleEnabled = false
    equipmentLoopRunning = false
end

local function runAutoBring(items, loopControl, stopFlagFunc)
    loopControl.running = true
    while loopControl.enabled do
        if #items > 0 then
            bypassBringSystem(items, stopFlagFunc)
        end
        task.wait(5)
    end
    loopControl.running = false
end

local junkControl = {enabled = false, running = false}
local fuelControl = {enabled = false, running = false}
local foodControl = {enabled = false, running = false}
local medicalControl = {enabled = false, running = false}
local equipmentControl = {enabled = false, running = false}

local function equipTool(tool)
    if tool then
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("EquipItemHandle")
        remote:FireServer("FireAllClients", tool)
    end
end

local function unequipTool(tool)
    if tool then
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UnequipItemHandle")
        remote:FireServer("FireAllClients", tool)
    end
end

local function findTool()
    for toolName, toolID in pairs(toolsDamageIDs) do
        local tool = LocalPlayer.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, toolID
        end
    end
    return nil, nil
end

local function chopAuraLoop()
    while chopAuraEnabled do
        local rootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")
        if rootPart then
            local tool, toolID = findTool()
            if tool and (toolID == "3_7367831688" or toolID == "112_7367831688" or toolID == "116_7367831688") then
                equipTool(tool)
                currentammount = currentammount + 1
                
                local trees = {}
                local map = workspace:FindFirstChild("Map")
                
                if map then
                    if map:FindFirstChild("Foliage") then
                        for _, obj in ipairs(map.Foliage:GetChildren()) do
                            if obj:IsA("Model") and obj.Name == "Small Tree" then
                                table.insert(trees, obj)
                            end
                        end
                    end
                    if map:FindFirstChild("Landmarks") then
                        for _, obj in ipairs(map.Landmarks:GetChildren()) do
                            if obj:IsA("Model") and obj.Name == "Small Tree" then
                                table.insert(trees, obj)
                            end
                        end
                    end
                end
                
                for _, tree in ipairs(trees) do
                    local trunk = tree:FindFirstChild("Trunk")
                    if trunk and trunk:IsA("BasePart") and (trunk.Position - rootPart.Position).Magnitude <= chopAuraRadius then
                        currentammount = currentammount + 1
                        pcall(function()
                            ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                tree, 
                                tool, 
                                tostring(currentammount) .. "_7367831688",
                                CFrame.new(-2.962610244751, 4.5547881126404, -75.950843811035, 
                                0.89621275663376, -1.3894891459643e-8, 0.44362446665764,
                                -7.994568895775e-10, 1, 3.293635941759e-8,
                                -0.44362446665764, -2.9872644802253e-8, 0.89621275663376)
                            )
                        end)
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

local function killAuraLoop()
    while killAuraEnabled do
        local rootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")
        if rootPart then
            local tool, toolID = findTool()
            if tool and toolID then
                equipTool(tool)
                for _, entity in ipairs(workspace.Characters:GetChildren()) do
                    if entity:IsA("Model") then
                        local entityPart = entity:FindFirstChildWhichIsA("BasePart")
                        if entityPart and (entityPart.Position - rootPart.Position).Magnitude <= killAuraRadius then
                            pcall(function()
                                ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                    entity, 
                                    tool, 
                                    toolID, 
                                    CFrame.new(entityPart.Position)
                                )
                            end)
                        end
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

local function getHunger()
    return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

local function feedPlayer(foodItem)
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name == foodItem then
            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

local function autoFeedLoop()
    while autoFeedToggle do
        if getHunger() < hungerThreshold then
            for _, foodName in ipairs(selectedFood) do
                feedPlayer(foodName)
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
end

local function moveItemToPos(item, targetPos)
    if not item or not item:IsA("BasePart") then return end
    
    pcall(function()
        item.CFrame = CFrame.new(targetPos)
        item.Velocity = Vector3.new(0, 0, 0)
        item.AngularVelocity = Vector3.new(0, 0, 0)
    end)
end

local espFolder = Instance.new("Folder")
espFolder.Name = "ESP"
espFolder.Parent = game.CoreGui

local function createESP(part, name, color)
    if part and part:IsA("BasePart") then
        local existingESP = espFolder:FindFirstChild(name .. "_" .. part:GetFullName())
        if existingESP then return end
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = name .. "_" .. part:GetFullName()
        billboardGui.Adornee = part
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 2, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = espFolder
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = name
        textLabel.TextColor3 = color
        textLabel.TextStrokeTransparency = 0
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 14
        textLabel.Parent = billboardGui
    end
end

local function removeESP(name, espType)
    for _, esp in ipairs(espFolder:GetChildren()) do
        if esp.Name:find(name) then
            esp:Destroy()
        end
    end
end

local function Aesp(name, espType)
    local container = espType == "item" and workspace:FindFirstChild("Items") or workspace:FindFirstChild("Characters")
    if not container then return end
    
    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == name then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local color = espType == "item" and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)
                createESP(part, name, color)
            end
        end
    end
end

local function Desp(name, espType)
    removeESP(name, espType)
end

local function getChests()
    local chests = {}
    local chestNames = {}
    local container = workspace:FindFirstChild("Items")
    if container then
        for _, obj in ipairs(container:GetChildren()) do
            if obj.Name == "Chest" or obj.Name:find("Chest") then
                table.insert(chests, obj)
                table.insert(chestNames, obj.Name)
            end
        end
    end
    return chests, chestNames
end

local function getMobs()
    local mobs = {}
    local mobNames = {}
    local container = workspace:FindFirstChild("Characters")
    
    if container then
        for _, obj in ipairs(container:GetChildren()) do
            table.insert(mobs, obj)
            table.insert(mobNames, obj.Name)
        end
    end
    
    return mobs, mobNames
end

local function tp1()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(-15.5, 8.12, -82.6)
    end
end

currentChests, currentChestNames = getChests()
currentMobs, currentMobNames = getMobs()
selectedChest = currentChestNames[1]
selectedMob = currentMobNames[1]

local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = (premium and "Premium" or "99 Night In The Forest") .. " | " .. version,
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/99NITF.json"
})

local Tabs = {
    Home    = Window:Tab({ Title = "Home",      Icon = "scan-face",  }),
    Combat  = Window:Tab({ Title = "Combat",    Icon = "swords",     }),
    next    = Window:Tab({ Title = "Auto",      Icon = "play",       }),
    esp     = Window:Tab({ Title = "ESP",       Icon = "eye",        }),
    tp      = Window:Tab({ Title = "Teleport",  Icon = "map",        })
}

Tabs.Home:Section({
    Title = "Infomation",
})

Tabs.Home:Button({
    Title = "Discord",
    Desc = "Copy Discord Link",
    Callback = function()
        local link = "https://discord.gg/jdmX43t5mY"
        if setclipboard then
            setclipboard(link)
        end
    end
})

Tabs.Home:Paragraph{
    Title = "Join Us",
    Desc = "Every Update Will Be On Discord"
}

Tabs.Home:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tabs.Combat:Section({ Title = "Kill Aura" })

Tabs.Combat:Slider({
    Title = "Kill Aura Radius",
    Value = {
        Min = 10,
        Max = 100,
        Default = 50,
    },
    Callback = function(value)
        killAuraRadius = value
    end
})

Tabs.Combat:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(value)
        killAuraEnabled = value
        if value then
            task.spawn(killAuraLoop)
        end
    end
})

Tabs.Combat:Section({ Title = "Chop Aura" })

Tabs.Combat:Slider({
    Title = "Chop Aura Radius",
    Value = {
        Min = 10,
        Max = 100,
        Default = 50,
    },
    Callback = function(value)
        chopAuraRadius = value
    end
})

Tabs.Combat:Toggle({
    Title = "Chop Aura",
    Default = false,
    Callback = function(value)
        chopAuraEnabled = value
        if value then
            task.spawn(chopAuraLoop)
        end
    end
})

Tabs.next:Section({ Title = "Junk Items" })

Tabs.next:Dropdown({
    Title = "Select Junk Items",
    Values = junkItems,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedJunkItems = values
    end
})

Tabs.next:Toggle({
    Title = "Auto Bring Junk",
    Default = false,
    Callback = function(value)
        junkControl.enabled = value
        if value and not junkControl.running then
            task.spawn(function()
                runAutoBring(selectedJunkItems, junkControl, function() return junkControl.enabled end)
            end)
        end
    end
})

Tabs.next:Section({ Title = "Fuel Items" })

Tabs.next:Dropdown({
    Title = "Select Fuel Items",
    Values = fuelItems,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedFuelItems = values
    end
})

Tabs.next:Toggle({
    Title = "Auto Bring Fuel",
    Default = false,
    Callback = function(value)
        fuelControl.enabled = value
        if value and not fuelControl.running then
            task.spawn(function()
                runAutoBring(selectedFuelItems, fuelControl, function() return fuelControl.enabled end)
            end)
        end
    end
})

Tabs.next:Section({ Title = "Food Items" })

Tabs.next:Dropdown({
    Title = "Select Food Items",
    Values = foodItems,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedFoodItems = values
    end
})

Tabs.next:Toggle({
    Title = "Auto Bring Food",
    Default = false,
    Callback = function(value)
        foodControl.enabled = value
        if value and not foodControl.running then
            task.spawn(function()
                runAutoBring(selectedFoodItems, foodControl, function() return foodControl.enabled end)
            end)
        end
    end
})

Tabs.next:Section({ Title = "Medical Items" })

Tabs.next:Dropdown({
    Title = "Select Medical Items",
    Values = medicalItems,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedMedicalItems = values
    end
})

Tabs.next:Toggle({
    Title = "Auto Bring Medical",
    Default = false,
    Callback = function(value)
        medicalControl.enabled = value
        if value and not medicalControl.running then
            task.spawn(function()
                runAutoBring(selectedMedicalItems, medicalControl, function() return medicalControl.enabled end)
            end)
        end
    end
})

Tabs.next:Section({ Title = "Equipment Items" })

Tabs.next:Dropdown({
    Title = "Select Equipment Items",
    Values = equipmentItems,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedEquipmentItems = values
    end
})

Tabs.next:Toggle({
    Title = "Auto Bring Equipment",
    Default = false,
    Callback = function(value)
        equipmentControl.enabled = value
        if value and not equipmentControl.running then
            task.spawn(function()
                runAutoBring(selectedEquipmentItems, equipmentControl, function() return equipmentControl.enabled end)
            end)
        end
    end
})

Tabs.next:Section({ Title = "Auto Feed" })

Tabs.next:Dropdown({
    Title = "Select Food",
    Values = alimentos,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedFood = values
    end
})

Tabs.next:Slider({
    Title = "Hunger Threshold",
    Value = {
        Min = 0,
        Max = 100,
        Default = 75,
    },
    Callback = function(value)
        hungerThreshold = value
    end
})

Tabs.next:Toggle({
    Title = "Auto Feed",
    Default = false,
    Callback = function(value)
        autoFeedToggle = value
        if value then
            task.spawn(autoFeedLoop)
        end
    end
})

Tabs.next:Section({ Title = "Auto Cook Food" })

Tabs.next:Dropdown({
    Title = "Auto Cook Food",
    Values = autocookItems,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        for _, itemName in ipairs(autocookItems) do
            autoCookEnabledItems[itemName] = table.find(values, itemName) ~= nil
        end
    end
})

Tabs.next:Toggle({
    Title = "Auto Cook Food",
    Default = false,
    Callback = function(value)
        autoCookEnabled = value
    end
})

coroutine.wrap(function()
    while true do
        if autoCookEnabled then
            for itemName, enabled in pairs(autoCookEnabledItems) do
                if enabled then
                    for _, item in ipairs(Workspace:WaitForChild("Items"):GetChildren()) do
                        if item.Name == itemName then
                            moveItemToPos(item, campfireDropPos)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)()

Tabs.next:Section({ Title = "Auto Upgrade" })

Tabs.next:Dropdown({
    Title = "Choose The Items",
    Values = campfireFuelItems,
    Value = campfireFuelItems[1],
    Callback = function(value)
        selectedCampfireItem = value
    end
})

Tabs.next:Toggle({
    Title = "Auto Upgrade",
    Default = false,
    Callback = function(value)
        autoUpgradeCampfireEnabled = value
        if value then
            task.spawn(function()
                while autoUpgradeCampfireEnabled do
                    if selectedCampfireItem then
                        for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                            if item.Name == selectedCampfireItem then
                                moveItemToPos(item, campfireDropPos)
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

Tabs.esp:Section({ Title = "ESP Items" })

Tabs.esp:Dropdown({
    Title = "Select Items",
    Values = ie,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedItems = values
        if espItemsEnabled then
            for _, name in ipairs(ie) do
                if table.find(selectedItems, name) then
                    Aesp(name, "item")
                else
                    Desp(name, "item")
                end
            end
        else
            for _, name in ipairs(ie) do
                Desp(name, "item")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "Enable ESP",
    Default = false,
    Callback = function(value)
        espItemsEnabled = value
        for _, name in ipairs(ie) do
            if value and table.find(selectedItems, name) then
                Aesp(name, "item")
            else
                Desp(name, "item")
            end
        end

        if value then
            if not espConnections["Items"] then
                local container = workspace:FindFirstChild("Items")
                if container then
                    espConnections["Items"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedItems, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESP(part, obj.Name, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Items"] then
                espConnections["Items"]:Disconnect()
                espConnections["Items"] = nil
            end
        end
    end
})

Tabs.esp:Section({ Title = "Mobs ESP" })

Tabs.esp:Dropdown({
    Title = "Select Mobs",
    Values = me,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedMobs = values
        if espMobsEnabled then
            for _, name in ipairs(me) do
                if table.find(values, name) then
                    Aesp(name, "mob")
                else
                    Desp(name, "mob")
                end
            end
        else
            for _, name in ipairs(me) do
                Desp(name, "mob")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "Enable ESP",
    Default = false,
    Callback = function(value)
        espMobsEnabled = value
        for _, name in ipairs(me) do
            if value and table.find(selectedMobs, name) then
                Aesp(name, "mob")
            else
                Desp(name, "mob")
            end
        end

        if value then
            if not espConnections["Mobs"] then
                local container = workspace:FindFirstChild("Characters")
                if container then
                    espConnections["Mobs"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedMobs, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESP(part, obj.Name, Color3.fromRGB(255, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Mobs"] then
                espConnections["Mobs"]:Disconnect()
                espConnections["Mobs"] = nil
            end
        end
    end
})

Tabs.tp:Section({ Title = "Chest" })

Tabs.tp:Dropdown({
    Title = "Select Chest",
    Values = currentChestNames,
    Value = currentChestNames[1],
    Callback = function(value)
        selectedChest = value
    end
})

Tabs.tp:Button({
    Title = "Teleport to Chest",
    Callback = function()
        if selectedChest and currentChests then
            local chestIndex = 1
            for i, name in ipairs(currentChestNames) do
                if name == selectedChest then
                    chestIndex = i
                    break
                end
            end
            local targetChest = currentChests[chestIndex]
            if targetChest then
                local part = targetChest.PrimaryPart or targetChest:FindFirstChildWhichIsA("BasePart")
                if part and game.Players.LocalPlayer.Character then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end
})

Tabs.tp:Button({
    Title = "Refresh List",
    Desc = "Refresh chest list",
    Callback = function()
        currentChests, currentChestNames = getChests()

        if #currentChestNames > 0 then
            selectedChest = currentChestNames[1]
            StreeHub:Notify({
                Title = "Refresh Berhasil",
                Content = "Ditemukan " .. #currentChestNames .. " chest",
                Icon = "check-circle",
                Duration = 3,
            })
        else
            selectedChest = nil
            StreeHub:Notify({
                Title = "Tidak Ada Chest",
                Content = "Tidak ditemukan chest di workspace",
                Icon = "x-circle",
                Duration = 3,
            })
        end

        if ChestDropdown then
            ChestDropdown:Refresh(currentChestNames)
            if #currentChestNames > 0 then
                ChestDropdown:Select(currentChestNames[1])
            end
        end
    end
})

Tabs.tp:Section({ Title = "Children" })

Tabs.tp:Dropdown({
    Title = "Select Child",
    Values = currentMobNames,
    Value = currentMobNames[1],
    Callback = function(value)
        selectedMob = value
    end
})

Tabs.tp:Button({
    Title = "Teleport to Child",
    Callback = function()
        if selectedMob and currentMobs then
            for i, name in ipairs(currentMobNames) do
                if name == selectedMob then
                    local targetMob = currentMobs[i]
                    if targetMob then
                        local part = targetMob.PrimaryPart or targetMob:FindFirstChildWhichIsA("BasePart")
                        if part and game.Players.LocalPlayer.Character then
                            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                            end
                        end
                    end
                    break
                end
            end
        end
    end
})

Tabs.tp:Button({
    Title = "Refresh List",
    Desc = "Refresh children list",
    Callback = function()
        currentMobs, currentMobNames = getMobs()
        if #currentMobNames > 0 then
            selectedMob = currentMobNames[1]
        else
            selectedMob = nil
        end

        if MobDropdown then
            MobDropdown:Refresh(currentMobNames)
            if #currentMobNames > 0 then
                MobDropdown:Select(currentMobNames[1])
            end
        end
    end
})

Tabs.tp:Section({ Title = "Teleport" })

Tabs.tp:Button({
    Title = "Teleport to Fire",
    Callback = function()
        tp1()
    end
})

StreeHub:Notify({
    Title = "StreeHub",
    Content = "Script loaded successfully!",
    Icon = "bell-ring",
    Duration = 5,
})
