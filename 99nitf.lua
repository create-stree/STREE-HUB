local VoraLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/juansyahrz17-prog/vorahub/refs/heads/main/lib.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local AutoKillEnabled = false
local AutoFarmEnabled = false
local FarmRange = 50
local ToolCounter = 0

local ToolIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    Chainsaw = "647_8992824875",
    Spear = "196_8999010016"
}

local AutoFoodEnabled = false
local SelectedFood = "Carrot"
local FoodThreshold = 75
local CollectingItems = {}

local ItemList = {
    "Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Carrot",
    "Chair", "Coal", "Coin Stack", "Cooked Morsel", "Cooked Steak",
    "Fuel Canister", "Iron Body", "Leather Armor", "Log", "MadKit",
    "Metal Chair", "MedKit", "Old Car Engine", "Old Flashlight", "Old Radio",
    "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo", "Morsel",
    "Sheet Metal", "Steak", "Tyre", "Washing Machine"
}

local EntityList = {
    "Bunny", "Wolf", "Alpha Wolf", "Bear", "Cultist", "Crossbow Cultist", "Alien"
}

local CraftingItems = {}
local TeleportLocations = {}
local FuelItems = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
local TeleportOffset = Vector3.new(0, 19, 0)
local MeatItems = {"Morsel", "Steak"}
local AutoCookItems = {}
local AutoCookEnabled = false

local ESPItemsSelected = {}
local ESPEntitiesSelected = {}
local ESPItemsEnabled = false
local ESPEntitiesEnabled = false
local ESPConnections = {}

local InstantInteractEnabled = false
local InstantInteractTask = nil
local ProximityPromptCache = {}

local AutoStunDeerEnabled = false
local AutoStunDeerConnection = nil

local function FindTool(axesOnly)
    for toolName, toolID in pairs(ToolIDs) do
        if not axesOnly or toolName == "Old Axe" or toolName == "Good Axe" or toolName == "Strong Axe" then
            local tool = LocalPlayer:FindFirstChild("Inventory")
            if tool then
                tool = LocalPlayer.Inventory:FindFirstChild(toolName)
            end
            if tool then
                return tool, toolID
            end
        end
    end
    return nil, nil
end

local function EquipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function UnequipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function AutoKillLoop()
    while AutoKillEnabled do
        local rootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")
        if rootPart then
            local tool, toolID = FindTool(false)
            if tool and toolID then
                EquipTool(tool)
                for _, entity in ipairs(Workspace.Characters:GetChildren()) do
                    if entity:IsA("Model") then
                        local entityPart = entity:FindFirstChildWhichIsA("BasePart")
                        if entityPart and (entityPart.Position - rootPart.Position).Magnitude <= FarmRange then
                            pcall(function()
                                ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                    entity, tool, toolID, CFrame.new(entityPart.Position)
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

local function AutoFarmLoop()
    while AutoFarmEnabled do
        local rootPart = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart")
        if rootPart then
            local tool, _ = FindTool(true)
            if tool then
                EquipTool(tool)
                ToolCounter = ToolCounter + 1
                local trees = {}
                local map = Workspace:FindFirstChild("Map")
                
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
                    if trunk and trunk:IsA("BasePart") and (trunk.Position - rootPart.Position).Magnitude <= FarmRange then
                        local cutting = false
                        task.spawn(function()
                            while AutoFarmEnabled and tree and tree.Parent and not cutting do
                                cutting = true
                                ToolCounter = ToolCounter + 1
                                pcall(function()
                                    ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                        tree, tool, tostring(ToolCounter) .. "_7367831688",
                                        CFrame.new(-2.962610244751, 4.5547881126404, -75.950843811035, 
                                        0.89621275663376, -1.3894891459643e-8, 0.44362446665764,
                                        -7.994568895775e-10, 1, 3.293635941759e-8,
                                        -0.44362446665764, -2.9872644802253e-8, 0.89621275663376)
                                    )
                                end)
                                task.wait(0.5)
                            end
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

function CountItem(itemName)
    local count = 0
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == itemName then
            count = count + 1
        end
    end
    return count
end

function GetHunger()
    return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

function FeedPlayer(foodItem)
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == foodItem then
            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

function NotifyNoFood()
    Window:Notify({
        Title = "Auto Food Paused",
        Content = "The food is gone",
        Duration = 3
    })
end

local function TeleportItem(item, useTween)
    if item and item:IsDescendantOf(workspace) and (item:IsA("BasePart") or item:IsA("Model")) then
        local targetPart
        if item:IsA("Model") then
            targetPart = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle") or item
        else
            targetPart = item
        end
        
        if targetPart and targetPart:IsA("BasePart") then
            if item:IsA("Model") and not item.PrimaryPart then
                pcall(function()
                    item.PrimaryPart = targetPart
                end)
            end
            
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local targetPos = rootPart.CFrame * CFrame.new(0, 3, -3)
                        
                        if useTween then
                            local TweenService = game:GetService("TweenService")
                            local tween = TweenService:Create(targetPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = targetPos})
                            tween:Play()
                        else
                            if item:IsA("Model") then
                                item:SetPrimaryPartCFrame(targetPos)
                            else
                                targetPart.CFrame = targetPos
                            end
                        end
                    end
                end
            end)
        end
    end
end

function createESP(part, label, color)
    if not part or not part:IsA("BasePart") then return end
    
    local existingESP = part:FindFirstChild("ESPTexto")
    if existingESP then
        existingESP:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESPTexto"
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.Parent = part
    
    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = label
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboardGui
end

local function EnableESP(itemName, espType)
    local container = espType == "item" and Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("Characters")
    if not container then return end
    
    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == itemName then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local color = espType == "item" and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)
                createESP(part, itemName, color)
            end
        end
    end
end

local function DisableESP(itemName, espType)
    local container = espType == "item" and Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("Characters")
    if not container then return end
    
    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == itemName then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local esp = part:FindFirstChild("ESPTexto")
                if esp then
                    esp:Destroy()
                end
            end
        end
    end
end

local Window = VoraLib:CreateWindow({
    Name = "VoraHub | 99 Nights In The Forest",
    Intro = true,
    Theme = {
        Background = Color3.fromRGB(10, 12, 25),
        Accent = Color3.fromRGB(0, 140, 210)
    }
})

local Tabs = {
    Info = Window:CreateTab({ Name = "Info", Icon = "alert" }),
    Main = Window:CreateTab({ Name = "Main", Icon = "next" }),
    Player = Window:CreateTab({ Name = "Player", Icon = "player" }),
    Shop = Window:CreateTab({ Name = "Shop", Icon = "cart" }),
    Map = Window:CreateTab({ Name = "Teleport", Icon = "gps" }),
    Misc = Window:CreateTab({ Name = "Misc", Icon = "settings" })
}

Tabs.Info:CreateSection({ Name = "Community Support" })

Tabs.Info:CreateButton({
    Name = "Discord Server",
    SubText = "Click to copy link",
    Callback = function()
        setclipboard("https://discord.gg/vorahub")
        Window:Notify({
            Title = "Copied!",
            Content = "Discord link copied to clipboard",
            Duration = 3
        })
    end
})

Tabs.Info:CreateParagraph({
    Title = "Support",
    Content = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tabs.Info:CreateSection({ Name = "Credits" })

Tabs.Info:CreateLabel({
    Text = "Script converted to VoraLib"
})

Tabs.Info:CreateButton({
    Name = "Script Made By TheVex0n",
    Callback = function()
        setclipboard("https://discord.gg/Xm5sThnfsP")
        Window:Notify({
            Title = "Copied!",
            Content = "Original author Discord copied",
            Duration = 3
        })
    end
})

Tabs.Main:CreateSection({ Name = "Combat" })

Tabs.Main:CreateToggle({
    Name = "Auto Kill Entities",
    SubText = "Automatically attacks nearby entities",
    Default = false,
    Callback = function(value)
        AutoKillEnabled = value
        if value then
            task.spawn(AutoKillLoop)
        end
    end
})

Tabs.Main:CreateSlider({
    Name = "Kill Range",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(value)
        FarmRange = value
    end
})

Tabs.Main:CreateSection({ Name = "Tree Farming" })

Tabs.Main:CreateToggle({
    Name = "Auto Farm Trees",
    SubText = "Automatically chops nearby trees",
    Default = false,
    Callback = function(value)
        AutoFarmEnabled = value
        if value then
            task.spawn(AutoFarmLoop)
        end
    end
})

Tabs.Main:CreateSection({ Name = "Auto Food" })

Tabs.Main:CreateDropdown({
    Name = "Select Food",
    Items = {"Carrot", "Cake", "Cooked Morsel", "Cooked Steak"},
    Default = "Carrot",
    Callback = function(value)
        SelectedFood = value
    end
})

Tabs.Main:CreateSlider({
    Name = "Food Threshold",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        FoodThreshold = value
    end
})

Tabs.Main:CreateToggle({
    Name = "Auto Eat",
    SubText = "Eats food when hunger is low",
    Default = false,
    Callback = function(value)
        AutoFoodEnabled = value
        if value then
            task.spawn(function()
                while AutoFoodEnabled do
                    if GetHunger() <= FoodThreshold then
                        if CountItem(SelectedFood) > 0 then
                            FeedPlayer(SelectedFood)
                        else
                            NotifyNoFood()
                            AutoFoodEnabled = false
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Player:CreateSection({ Name = "Item Collection" })

Tabs.Player:CreateMultiDropdown({
    Name = "Collect Items",
    Items = ItemList,
    Default = {},
    Callback = function(values)
        CollectingItems = values
    end
})

Tabs.Player:CreateToggle({
    Name = "Auto Collect Items",
    SubText = "Teleports selected items to you",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while value do
                    for _, itemName in ipairs(CollectingItems) do
                        for _, item in ipairs(Workspace.Items:GetChildren()) do
                            if item.Name == itemName then
                                TeleportItem(item, false)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

Tabs.Player:CreateSection({ Name = "Auto Cook" })

Tabs.Player:CreateMultiDropdown({
    Name = "Cook Items",
    Items = MeatItems,
    Default = {},
    Callback = function(values)
        AutoCookItems = values
    end
})

Tabs.Player:CreateToggle({
    Name = "Auto Cook Meat",
    SubText = "Automatically cooks selected meat",
    Default = false,
    Callback = function(value)
        AutoCookEnabled = value
        if value then
            task.spawn(function()
                while AutoCookEnabled do
                    for _, meatName in ipairs(AutoCookItems) do
                        for _, item in ipairs(Workspace.Items:GetChildren()) do
                            if item.Name == meatName then
                                pcall(function()
                                    ReplicatedStorage.RemoteEvents.RequestCookItem:InvokeServer(item)
                                end)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Map:CreateSection({ Name = "Locations" })

Tabs.Map:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(0, 20, 0)
        end
    end
})

Tabs.Shop:CreateSection({ Name = "ESP Items" })

Tabs.Shop:CreateMultiDropdown({
    Name = "ESP Items",
    Items = ItemList,
    Default = {},
    Callback = function(values)
        ESPItemsSelected = values
        if ESPItemsEnabled then
            for _, itemName in ipairs(ItemList) do
                if table.find(ESPItemsSelected, itemName) then
                    EnableESP(itemName, "item")
                else
                    DisableESP(itemName, "item")
                end
            end
        else
            for _, itemName in ipairs(ItemList) do
                DisableESP(itemName, "item")
            end
        end
    end
})

Tabs.Shop:CreateToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(value)
        ESPItemsEnabled = value
        for _, itemName in ipairs(ItemList) do
            if value and table.find(ESPItemsSelected, itemName) then
                EnableESP(itemName, "item")
            else
                DisableESP(itemName, "item")
            end
        end
        
        if value then
            local itemsFolder = Workspace:FindFirstChild("Items")
            if itemsFolder and not ESPConnections.Items then
                ESPConnections.Items = itemsFolder.ChildAdded:Connect(function(item)
                    if table.find(ESPItemsSelected, item.Name) then
                        local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
                        if part then
                            createESP(part, item.Name, Color3.fromRGB(0, 255, 0))
                        end
                    end
                end)
            end
        elseif ESPConnections.Items then
            ESPConnections.Items:Disconnect()
            ESPConnections.Items = nil
        end
    end
})

Tabs.Shop:CreateSection({ Name = "ESP Entity" })

Tabs.Shop:CreateMultiDropdown({
    Name = "ESP Entity",
    Items = EntityList,
    Default = {},
    Callback = function(values)
        ESPEntitiesSelected = values
        if ESPEntitiesEnabled then
            for _, entityName in ipairs(EntityList) do
                if table.find(ESPEntitiesSelected, entityName) then
                    EnableESP(entityName, "mob")
                else
                    DisableESP(entityName, "mob")
                end
            end
        else
            for _, entityName in ipairs(EntityList) do
                DisableESP(entityName, "mob")
            end
        end
    end
})

Tabs.Shop:CreateToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(value)
        ESPEntitiesEnabled = value
        for _, entityName in ipairs(EntityList) do
            if value and table.find(ESPEntitiesSelected, entityName) then
                EnableESP(entityName, "mob")
            else
                DisableESP(entityName, "mob")
            end
        end
        
        if value then
            local charactersFolder = Workspace:FindFirstChild("Characters")
            if charactersFolder and not ESPConnections.Mobs then
                ESPConnections.Mobs = charactersFolder.ChildAdded:Connect(function(entity)
                    if table.find(ESPEntitiesSelected, entity.Name) then
                        local part = entity:IsA("BasePart") and entity or entity:FindFirstChildWhichIsA("BasePart")
                        if part then
                            createESP(part, entity.Name, Color3.fromRGB(255, 255, 0))
                        end
                    end
                end)
            end
        elseif ESPConnections.Mobs then
            ESPConnections.Mobs:Disconnect()
            ESPConnections.Mobs = nil
        end
    end
})

Tabs.Misc:CreateSection({ Name = "Misc" })

Tabs.Misc:CreateToggle({
    Name = "Instant Interact",
    SubText = "Makes ProximityPrompts instant",
    Default = false,
    Callback = function(value)
        InstantInteractEnabled = value
        if value then
            ProximityPromptCache = {}
            InstantInteractTask = task.spawn(function()
                while InstantInteractEnabled do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if ProximityPromptCache[obj] == nil then
                                ProximityPromptCache[obj] = obj.HoldDuration
                            end
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if InstantInteractTask then
                InstantInteractEnabled = false
            end
            for prompt, originalDuration in pairs(ProximityPromptCache) do
                if prompt and prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = originalDuration
                end
            end
            ProximityPromptCache = {}
        end
    end
})

Tabs.Misc:CreateToggle({
    Name = "Auto Stun Deer",
    SubText = "Automatically stuns deer",
    Default = false,
    Callback = function(value)
        if value then
            AutoStunDeerConnection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local deerEvent = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if deerEvent then
                        deerEvent = ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    end
                    local deer = Workspace:FindFirstChild("Characters")
                    if deer then
                        deer = Workspace.Characters:FindFirstChild("Deer")
                    end
                    if deerEvent and deer then
                        deerEvent:InvokeServer(deer)
                    end
                end)
                task.wait(0.1)
            end)
        elseif AutoStunDeerConnection then
            AutoStunDeerConnection:Disconnect()
            AutoStunDeerConnection = nil
        end
    end
})

Window:Notify({
    Title = "VoraHub Loaded",
    Content = "99 Nights In The Forest script loaded successfully!",
    Duration = 5
})
