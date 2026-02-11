local VoraLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/juansyahrz17-prog/vorahub/refs/heads/main/lib.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- combat

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

-- auto food

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

-- esp

local ie = {
    "Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Carrot", "Chair", "Coal", "Coin Stack",
    "Cooked Morsel", "Cooked Steak", "Fuel Canister", "Iron Body", "Leather Armor", "Log", "MadKit", "Metal Chair",
    "MedKit", "Old Car Engine", "Old Flashlight", "Old Radio", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo",
    "Morsel", "Sheet Metal", "Steak", "Tyre", "Washing Machine"
}
local me = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Cultist", "Crossbow Cultist", "Alien"}

-- bring

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

-- Toggle states for each category
local junkToggleEnabled = false
local fuelToggleEnabled = false
local foodToggleEnabled = false
local medicalToggleEnabled = false
local equipmentToggleEnabled = false

-- Loop control variables to properly stop threads
local junkLoopRunning = false
local fuelLoopRunning = false
local foodLoopRunning = false
local medicalLoopRunning = false
local equipmentLoopRunning = false

-- Variables yang diperlukan untuk Auto Cook dan Upgrade
local autoCookEnabled = false
local autoCookEnabledItems = {}
local autocookItems = {"Morsel", "Steak"}
local autoUpgradeCampfireEnabled = false
local selectedCampfireItem = nil
local campfireFuelItems = {"Log", "Chair", "Coal"}
local campfireDropPos = Vector3.new(0, 0, 0) -- Sesuaikan dengan posisi campfire

-- Variables yang diperlukan untuk ESP
local espMobsEnabled = false
local selectedMobs = {}
local espConnections = {}

-- Variables yang diperlukan untuk Teleport
local currentChests = {}
local currentChestNames = {}
local currentMobs = {}
local currentMobNames = {}
local selectedChest = nil
local selectedMob = nil

-- Enhanced smooth pulling movement with easing
local function smoothPullToItem(startPos, endPos, duration)
    local player = game.Players.LocalPlayer
    local hrp = player.Character.HumanoidRootPart
    
    local startTime = tick()
    local distance = (endPos.Position - startPos.Position).Magnitude
    local direction = (endPos.Position - startPos.Position).Unit
    
    -- Create smooth pulling effect with easing
    spawn(function()
        while tick() - startTime < duration do
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            
            -- Ease-in-out function for smooth acceleration and deceleration
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
        
        -- Ensure exact final position
        hrp.CFrame = endPos
    end)
    
    wait(duration)
end

-- Enhanced item pulling effect
local function createItemPullEffect(itemPart, targetPos, duration)
    if not itemPart or not itemPart.Parent then return end
    
    local startPos = itemPart.Position
    local startTime = tick()
    
    spawn(function()
        while tick() - startTime < duration do
            if not itemPart or not itemPart.Parent then break end
            
            local elapsed = tick() - startTime
            local progress = elapsed / duration
            
            -- Ease-out effect for item pulling
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
        
        -- Final position
        pcall(function()
            itemPart.CFrame = CFrame.new(targetPos)
            itemPart.Velocity = Vector3.new(0, 0, 0)
            itemPart.AngularVelocity = Vector3.new(0, 0, 0)
        end)
    end)
    
    wait(duration)
end

-- Enhanced bypass system with smooth pulling (no noclip)
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
        -- Check if we should stop
        if stopFlag and not stopFlag() then
            break
        end
        
        local itemsFound = {}
        
        -- Find all items with this name
        for _, item in ipairs(workspace:GetDescendants()) do
            if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                local itemPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                if itemPart and itemPart.Parent ~= player.Character then
                    table.insert(itemsFound, {item = item, part = itemPart})
                end
            end
        end
        
        -- Process each found item
        for _, itemData in ipairs(itemsFound) do
            -- Check if we should stop again
            if stopFlag and not stopFlag() then
                break
            end
            
            local item = itemData.item
            local itemPart = itemData.part
            
            if itemPart and itemPart.Parent then
                -- Step 1: Smooth pull to item location with anticipation
                local itemPos = itemPart.CFrame + Vector3.new(0, 5, 0)
                smoothPullToItem(hrp.CFrame, itemPos, 1.2) -- Smooth 1.2 second pull
                
                -- Step 2: Create magnetic pull effect for item
                local playerPos = hrp.Position + Vector3.new(0, -1, 0)
                createItemPullEffect(itemPart, playerPos, 0.8)
                
                -- Step 3: Smooth return journey with item following
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
    
    -- Final return to original position
    if hrp and originalPosition then
        smoothPullToItem(hrp.CFrame, originalPosition, 1.0)
    end
    
    isCollecting = false
end

-- Function untuk move item ke posisi tertentu (untuk auto cook/upgrade)
local function moveItemToPos(item, targetPos)
    if not item or not item:IsA("BasePart") then return end
    
    pcall(function()
        item.CFrame = CFrame.new(targetPos)
        item.Velocity = Vector3.new(0, 0, 0)
        item.AngularVelocity = Vector3.new(0, 0, 0)
    end)
end

-- Function untuk ESP
local function createESP(part, name, color)
    if not part or not part:IsA("BasePart") then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP_" .. name
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = name
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    
    billboardGui.Parent = part
end

local function Aesp(name, espType)
    local container = espType == "mob" and workspace:FindFirstChild("Characters") or workspace:FindFirstChild("Items")
    if not container then return end
    
    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == name then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local color = espType == "mob" and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 255, 0)
                createESP(part, name, color)
            end
        end
    end
end

local function Desp(name, espType)
    local container = espType == "mob" and workspace:FindFirstChild("Characters") or workspace:FindFirstChild("Items")
    if not container then return end
    
    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == name then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local esp = part:FindFirstChild("ESP_" .. name)
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end

-- Function untuk get chests
local function getChests()
    local chests = {}
    local chestNames = {}
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("chest") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            table.insert(chests, obj)
            table.insert(chestNames, obj.Name .. " #" .. #chests)
        end
    end
    
    return chests, chestNames
end

-- Function untuk get mobs/children
local function getMobs()
    local mobs = {}
    local mobNames = {}
    local container = workspace:FindFirstChild("Characters")
    
    if container then
        for _, obj in ipairs(container:GetChildren()) do
            if table.find(me, obj.Name) then
                table.insert(mobs, obj)
                table.insert(mobNames, obj.Name .. " #" .. #mobs)
            end
        end
    end
    
    return mobs, mobNames
end

-- Function untuk teleport ke fire
local function tp1()
    local player = game.Players.LocalPlayer
    if not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Cari campfire atau fire di workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("fire") or obj.Name:lower():find("campfire") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                return
            end
        end
    end
end

-- Inisialisasi data
currentChests, currentChestNames = getChests()
currentMobs, currentMobNames = getMobs()
if #currentChestNames > 0 then
    selectedChest = currentChestNames[1]
end
if #currentMobNames > 0 then
    selectedMob = currentMobNames[1]
end

-- UI Setup
local Library = VoraLib
local Window = Library:CreateWindow({
    Title = "99 Night In The Forest",
    SubTitle = "by VoraHub",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    combat = Window:CreateTab({ Title = "Combat", Icon = "rbxassetid://4483345998" }),
    bring = Window:CreateTab({ Title = "Bring", Icon = "rbxassetid://4483345998" }),
    AutoFood = Window:CreateTab({ Title = "Auto Food", Icon = "rbxassetid://4483345998" }),
    esp = Window:CreateTab({ Title = "ESP", Icon = "rbxassetid://4483345998" }),
    tp = Window:CreateTab({ Title = "Teleport", Icon = "rbxassetid://4483345998" }),
    Auto = Window:CreateTab({ Title = "Auto", Icon = "rbxassetid://4483345998" })
}

-- ESP Tab
Tabs.esp:CreateSection({ Name = "Mobs ESP" })

Tabs.esp:CreateMultiDropdown({
    Name = "Select Mobs",
    Items = me,
    Default = {},
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
        end
    end
})

Tabs.esp:CreateToggle({
    Name = "Enable ESP",
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

-- Teleport Tab - Chest
Tabs.tp:CreateSection({ Name = "Chest" })

local ChestDropdown = Tabs.tp:CreateDropdown({
    Name = "Select Chest",
    Items = currentChestNames,
    Default = currentChestNames[1],
    Callback = function(value)
        selectedChest = value
    end
})

Tabs.tp:CreateButton({
    Name = "Teleport to Chest",
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

Tabs.tp:CreateButton({
    Name = "Refresh List",
    Callback = function()
        currentChests, currentChestNames = getChests()
        
        if #currentChestNames > 0 then
            selectedChest = currentChestNames[1]
            
            Library:Notification({
                Title = "Refresh Berhasil",
                Content = "Ditemukan " .. #currentChestNames .. " chest",
                Duration = 3,
                Image = "rbxassetid://4483345998"
            })
        else
            selectedChest = nil
            
            Library:Notification({
                Title = "Tidak Ada Chest",
                Content = "Tidak ditemukan chest di workspace",
                Duration = 3,
                Image = "rbxassetid://4483345998"
            })
        end
        
        -- PERBAIKAN: Menggunakan ChestDropdown dengan huruf kapital
        if ChestDropdown then
            ChestDropdown:UpdateList(currentChestNames)
            if #currentChestNames > 0 then
                ChestDropdown:SetValue(currentChestNames[1])
            end
        end
    end
})

-- Teleport Tab - Children
Tabs.tp:CreateSection({ Name = "Children" })

local MobDropdown = Tabs.tp:CreateDropdown({
    Name = "Select Child",
    Items = currentMobNames,
    Default = currentMobNames[1],
    Callback = function(value)
        selectedMob = value
    end
})

Tabs.tp:CreateButton({
    Name = "Teleport to Child",
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

Tabs.tp:CreateButton({
    Name = "Refresh List",
    Callback = function()
        currentMobs, currentMobNames = getMobs()
        if #currentMobNames > 0 then
            selectedMob = currentMobNames[1]
        else
            selectedMob = nil
        end
        
        -- Update dropdown jika ada
        if MobDropdown then
            MobDropdown:UpdateList(currentMobNames)
            if #currentMobNames > 0 then
                MobDropdown:SetValue(currentMobNames[1])
            end
        end
    end
})

-- Teleport Tab - Teleport
Tabs.tp:CreateSection({ Name = "Teleport" })

Tabs.tp:CreateButton({
    Name = "Teleport to Fire",
    Callback = function()
        tp1()
    end
})

-- Auto Tab - Auto Cook Food
Tabs.Auto:CreateSection({ Name = "Auto Cook Food" })

Tabs.Auto:CreateMultiDropdown({
    Name = "Auto Cook Food",
    Items = autocookItems,
    Default = {},
    Callback = function(values)
        for _, itemName in ipairs(autocookItems) do
            autoCookEnabledItems[itemName] = table.find(values, itemName) ~= nil
        end
    end
})

Tabs.Auto:CreateToggle({
    Name = "Auto Cook Food",
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

-- Auto Tab - Auto Upgrade
Tabs.Auto:CreateSection({ Name = "Auto Upgrade" })

Tabs.Auto:CreateDropdown({
    Name = "Choose The Items",
    Items = campfireFuelItems,
    Default = campfireFuelItems[1],
    Callback = function(value)
        selectedCampfireItem = value
    end
})

Tabs.Auto:CreateToggle({
    Name = "Auto Upgrade",
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

Window:Notify({
    Title = "VoraHub",
    Content = "99 Night In The Forest Script loaded successfully!",
    Duration = 5
})
