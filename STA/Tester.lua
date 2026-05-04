local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")


local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

local pickUpItemRemote = Remotes and Remotes:FindFirstChild("Interaction") and Remotes.Interaction:FindFirstChild("PickUpItem")
local placeStructureRemote = Remotes and Remotes:FindFirstChild("Building") and Remotes.Building:FindFirstChild("PlaceStructure")
local buyItemRemote = Remotes and Remotes:FindFirstChild("Merchant") and Remotes.Merchant:FindFirstChild("BuyItem")
local addSuppressorRemote = Remotes and Remotes:FindFirstChild("Tools") and Remotes.Tools:FindFirstChild("AddSuppressor")
local adjustBackpackRemote = Remotes and Remotes:FindFirstChild("Tools") and Remotes.Tools:FindFirstChild("AdjustBackpack")
local resetRemote = Remotes and Remotes:FindFirstChild("Misc") and Remotes.Misc:FindFirstChild("Reset")


local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)


local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = (premium and "Premium" or "KALB") .. " - " .. version,
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/Config.json"
})


local Tabs = {
    Home = Window:Tab({ Title = "Home", Icon = "scan-face" }),
    Main = Window:Tab({ Title = "Main", Icon = "landmark" }),
    Exclusive = Window:Tab({ Title = "Exclusive", Icon = "star" }),
    Webhook = Window:Tab({ Title = "Webhook", Icon = "webhook" }),
    Upgrade = Window:Tab({ Title = "Upgrade", Icon = "chart-column-increasing" }),
    Shop = Window:Tab({ Title = "Shop", Icon = "shopping-bag" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "layout-grid" })
}


local connections = {}
local mobESPInstances = {}
local playerESPInstances = {}
local structureESPInstances = {}
local antiAFKConn = nil
local autoSprintActive = false
local killAuraConn = nil
local aimbotConn = nil
local aimbotTarget = nil
local fovCircle = nil
local killAuraIndicatorLine   = nil
local killAuraIndicatorCircle = nil
local repairAuraConn = nil

local originalLighting = { stored = false }
local originalFog = { stored = false }

local mobOptions = { ESP = false, Chams = false, Name = false, Distance = false }
local playerESPVars = { ESP = false, Chams = false, Name = false, Distance = false, Health = false }
local structureESPVars = { ESP = false, Chams = false, Name = false, Distance = false }
local bhopActive = false
local bhopConn = nil
local remoteSpyEnabled = false
local remoteSpyLogs = {}

local mobNames = {"Runner", "Crawler", "Riot", "Zombie", "Brute", "Spitter", "Boss"}

local espConfig = {
    textSize            = 10,
    fillTransparency    = 0.4,
    outlineTransparency = 0.0,
}

local espDefinitions = {
    {
        key = "Gun",
        displayName = "Gun ESP",
        icon = "crosshair",
        items = {
            "AA-12", "AK-47", "Assault Rifle", "Desert Eagle", "Double Barrel",
            "Flamethrower", "Grenade Launcher", "LMG", "MediGun", "Pistol",
            "Ray Gun", "Revolver", "Rifle", "Shotgun", "Sniper", "SVD", "Uzi"
        },
        colors = { fill = Color3.fromRGB(255, 30,  30),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(255, 120, 120) },
    },
    {
        key = "Melee",
        displayName = "Melee ESP",
        icon = "swords",
        items = {
            "Bat", "Chainsaw", "Crowbar", "Fire Axe", "Hatchet", "Katana", "Knife",
            "Riot Shield", "Scythe", "Sledgehammer", "Spear", "Spiked Bat"
        },
        colors = { fill = Color3.fromRGB(255, 140,  0),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(255, 200, 100) },
    },
    {
        key = "Medical",
        displayName = "Medical ESP",
        icon = "heart-pulse",
        items = {
            "Bandage", "Compound H", "Compound I", "Compound R", "Compound S", "Medkit"
        },
        colors = { fill = Color3.fromRGB(  0, 255,  80),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(150, 255, 150) },
    },
    {
        key = "Armor",
        displayName = "Armor ESP",
        icon = "shield",
        items = {
            "Power Armor", "Light Armor", "Medium Armor", "Heavy Armor"
        },
        colors = { fill = Color3.fromRGB(  0, 100, 255),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(160, 200, 255) },
    },
    {
        key = "Food",
        displayName = "Food ESP",
        icon = "utensils",
        items = {
            "Chips", "Carrot", "Bloxiade", "Beans", "MRE", "Bloxy Cola"
        },
        colors = { fill = Color3.fromRGB(190, 255,   0),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(210, 255, 150) },
    },
    {
        key = "Resource",
        displayName = "Resources ESP",
        icon = "box",
        items = {
            "AC", "Battery", "Battery Pack", "Bucket", "Dumbell", "Exhaust Pipe",
            "Reactor Component", "Refined Metal", "Satellite Dish", "Scrap",
            "Screws", "Spatula", "Tray", "TV", "Watch", "Zombie Heart"
        },
        colors = { fill = Color3.fromRGB(  0, 220, 255),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(180, 240, 255) },
    },
    {
        key = "Fuel",
        displayName = "Fuel ESP",
        icon = "zap",
        items = { "Nuclear Fuel", "Refined Fuel", "Fuel" },
        colors = { fill = Color3.fromRGB(255, 220,   0),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(255, 240, 160) },
    },
    {
        key = "Ability",
        displayName = "Abilities ESP",
        icon = "zap-circle",
        items = {
            "Airstrike", "Attack Order", "Call of the Dead",
            "Summon Brute", "Summon Zombies", "Taunt",
            "The Future", "The Past", "The Present"
        },
        colors = { fill = Color3.fromRGB(180,  0, 255),  outline = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(220, 150, 255) },
    },
}

local espSystems = {}

for _, def in ipairs(espDefinitions) do
    local sys = {
        key = def.key,
        displayName = def.displayName,
        colors = def.colors,
        items = def.items,
        itemList = {},
        vars = { ESP = false, Chams = false, Name = false, Distance = false },
        instances = {},
        listenersSetup = false,
    }
    for _, name in ipairs(def.items) do
        sys.itemList[name] = true
    end
    espSystems[def.key] = sys
end

local itemNames = {}
local itemCategoryLookup = {}
for _, def in ipairs(espDefinitions) do
    for _, itemName in ipairs(def.items) do
        table.insert(itemNames, itemName)
        itemCategoryLookup[itemName] = def.key
    end
end

local extraItemCategories = {
    Ammo = { "Ammo Box", "Long Ammo", "Medium Ammo", "Pistol Ammo", "Shells" },
    Structures = {
        "Ammo Crate", "Barbed Wire", "Bear Trap", "Boost Pad", "Electric Fence",
        "Farm Plot", "Fence", "Floodlight", "Gate", "Landmine", "Map",
        "Repair Drone", "Shelf", "Teleporter", "Time Machine", "Turret",
        "Wall", "Watchtower"
    },
    Consumables = { "Grenade", "Molotov" },
    Backpacks = { "Basic Backpack", "Good Backpack", "Great Backpack" },
    MiscItems = {
        "Emerald", "Gas Mask", "Power Armor Arm", "Power Armor Core",
        "Radio Tower Part", "Blueprint", "Military Keycard", "Repair Hammer", "Suppressor"
    },
}
for catName, catItems in pairs(extraItemCategories) do
    for _, itemName in ipairs(catItems) do
        table.insert(itemNames, itemName)
        itemCategoryLookup[itemName] = catName
    end
end
table.sort(itemNames)

local pickupItemSet = {
    ["Ammo Box"]=true,["Long Ammo"]=true,["Medium Ammo"]=true,["Shells"]=true,["Pistol Ammo"]=true,
    ["Power Armor"]=true,["Light Armor"]=true,["Medium Armor"]=true,["Heavy Armor"]=true,
    ["Emerald"]=true,["Gas Mask"]=true,
    ["Ammo Crate"]=true,["Barbed Wire"]=true,["Bear Trap"]=true,["Boost Pad"]=true,
    ["Electric Fence"]=true,["Farm Plot"]=true,["Fence"]=true,["Floodlight"]=true,
    ["Gate"]=true,["Landmine"]=true,["Map"]=true,["Repair Drone"]=true,["Shelf"]=true,
    ["Teleporter"]=true,["Time Machine"]=true,["Turret"]=true,["Wall"]=true,["Watchtower"]=true,
    ["Basic Backpack"]=true,["Good Backpack"]=true,["Great Backpack"]=true,
    ["Grenade"]=true,["Molotov"]=true,
    ["AA-12"]=true,["AK-47"]=true,["Assault Rifle"]=true,["Desert Eagle"]=true,
    ["Double Barrel"]=true,["Flamethrower"]=true,["Grenade Launcher"]=true,["LMG"]=true,
    ["MediGun"]=true,["Pistol"]=true,["Ray Gun"]=true,["Revolver"]=true,["Rifle"]=true,
    ["Shotgun"]=true,["Sniper"]=true,["SVD"]=true,["Uzi"]=true,
    ["Bandage"]=true,["Compound H"]=true,["Compound I"]=true,["Compound R"]=true,
    ["Compound S"]=true,["Medkit"]=true,
    ["Bat"]=true,["Chainsaw"]=true,["Crowbar"]=true,["Fire Axe"]=true,["Hatchet"]=true,
    ["Katana"]=true,["Knife"]=true,["Riot Shield"]=true,["Scythe"]=true,
    ["Sledgehammer"]=true,["Spear"]=true,["Spiked Bat"]=true,
    ["Blueprint"]=true,["Military Keycard"]=true,["Repair Hammer"]=true,["Suppressor"]=true,
}
local pickupItemNames = {}
for k in pairs(pickupItemSet) do table.insert(pickupItemNames, k) end
table.sort(pickupItemNames)

local structureNames = {
    "Ammo Crate", "Barbed Wire", "Bear Trap", "Boost Pad", "Electric Fence",
    "Farm Plot", "Fence", "Floodlight", "Gate", "Landmine", "Map", "Repair Drone",
    "Shelf", "Teleporter", "Time Machine", "Turret", "Wall", "Watchtower"
}


local charactersFolder = nil
local droppedItemsFolder = nil
local structuresFolder = nil
local mobListenersSetup = false
local structureListenersSetup = false

local function discoverFolders()
    charactersFolder = Workspace:FindFirstChild("Characters")
    droppedItemsFolder = Workspace:FindFirstChild("DroppedItems")
    structuresFolder = Workspace:FindFirstChild("Structures")
        or Workspace:FindFirstChild("PlayerStructures")
        or Workspace:FindFirstChild("Buildings")
end
discoverFolders()

task.spawn(function()
    while not Library.Unloaded do
        task.wait(5)
        local prevChars = charactersFolder
        local prevItems = droppedItemsFolder
        local prevStructs = structuresFolder
        discoverFolders()
        if charactersFolder ~= prevChars and charactersFolder then
            refreshMobESP()
            if not mobListenersSetup then setupMobListeners() end
        end
        if droppedItemsFolder ~= prevItems and droppedItemsFolder then
            for _, sys in pairs(espSystems) do
                sys.refresh()
            end
            for _, sys in pairs(espSystems) do
                if not sys.listenersSetup then sys.setupListeners() end
            end
        end
        if structuresFolder ~= prevStructs and structuresFolder then
            refreshStructureESP()
            if not structureListenersSetup then setupStructureListeners() end
        end
    end
end)


local function getItemMainPart(item)
    if item.PrimaryPart then return item.PrimaryPart end
    for _, child in ipairs(item:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    return nil
end


local function getDistanceColor(dist)
    if dist > 250 then return Color3.fromRGB(255, 80, 80)
    elseif dist > 150 then return Color3.fromRGB(255, 180, 80)
    elseif dist > 100 then return Color3.fromRGB(255, 255, 80)
    else return Color3.fromRGB(220, 220, 220) end
end

local function getHealthColor(pct)
    if pct > 0.6 then return Color3.fromRGB(80, 255, 80)
    elseif pct > 0.3 then return Color3.fromRGB(255, 230, 50)
    else return Color3.fromRGB(255, 60, 60) end
end

local function createHealthBar(parent, height, width, position)
    local bg = Instance.new("Frame")
    bg.Name = "HealthBarBG"
    bg.Size = UDim2.new(width, 0, height, 0)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = bg

    local fill = Instance.new("Frame")
    fill.Name = "HealthBarFill"
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    fill.BorderSizePixel = 0
    fill.Parent = bg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill

    return bg, fill
end

local function updateHealthBar(fill, pct, color)
    fill.Size = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = color
end

local function createTextBG(parent, size, position)
    local bg = Instance.new("Frame")
    bg.Name = "TextBG"
    bg.Size = size
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.BorderSizePixel = 0
    bg.ZIndex = -1
    bg.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = bg
    return bg
end

local MOB_RED = { fill = Color3.fromRGB(255, 30, 30), outline = Color3.fromRGB(255, 120, 120) }
local mobTypeColors = {
    Zombie  = MOB_RED, Runner  = MOB_RED, Crawler = MOB_RED,
    Brute   = MOB_RED, Spitter = MOB_RED, Riot    = MOB_RED, Boss = MOB_RED,
}


local function createCategoryESP(sys, item)
    if not item:IsA("Model") then return end
    if sys.instances[item] then return end

    local mainPart = getItemMainPart(item)
    if not mainPart then return end

    local espTable = { MainPart = mainPart }

    if sys.vars.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = sys.key .. "ESP_Highlight"
        highlight.Adornee = item
        highlight.FillColor = sys.colors.fill
        highlight.FillTransparency = espConfig.fillTransparency
        highlight.OutlineColor = sys.colors.outline
        highlight.OutlineTransparency = espConfig.outlineTransparency
        highlight.Parent = item
        espTable.Highlight = highlight
    end

    if sys.vars.Name or sys.vars.Distance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = sys.key .. "ESP_NameDistance"
        billboard.Adornee = mainPart
        billboard.Size = UDim2.new(0, 220, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = item

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "[" .. sys.key .. "] " .. item.Name
        nameLabel.TextColor3 = sys.colors.text
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = espConfig.textSize
        nameLabel.Visible = sys.vars.Name
        nameLabel.Parent = frame

        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distLabel.TextStrokeTransparency = 0.2
        distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distLabel.Font = Enum.Font.GothamBold
        distLabel.TextSize = math.max(espConfig.textSize - 2, 8)
        distLabel.Visible = sys.vars.Distance
        distLabel.Parent = frame

        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel
    end

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not item or not item.Parent then
            connection:Disconnect()
            return
        end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
        if not myRoot then return end
        local dist = (myRoot.Position - mainPart.Position).Magnitude
        local maxDist = Options and Options.ESPMaxDistance and Options.ESPMaxDistance.Value or 99999
        local visible = dist <= maxDist
        if sys.vars.Chams and (not espTable.Highlight or not espTable.Highlight.Parent) then
            local h = Instance.new("Highlight")
            h.Name = sys.key .. "ESP_Highlight"
            h.Adornee = item
            h.FillColor = sys.colors.fill
            h.FillTransparency = espConfig.fillTransparency
            h.OutlineColor = sys.colors.outline
            h.OutlineTransparency = espConfig.outlineTransparency
            h.Enabled = visible
            h.Parent = item
            espTable.Highlight = h
        elseif espTable.Highlight and espTable.Highlight.Parent then
            espTable.Highlight.Enabled = visible
        end
        if espTable.Billboard and espTable.Billboard.Parent then
            espTable.Billboard.Enabled = visible
            if espTable.DistLabel and sys.vars.Distance then
                espTable.DistLabel.Text = math.floor(dist) .. "m"
                espTable.DistLabel.TextColor3 = getDistanceColor(dist)
            end
        end
    end)
    espTable.DistanceConnection = connection

    sys.instances[item] = espTable
end

local function removeCategoryESP(sys, item)
    local esp = sys.instances[item]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then esp.DistanceConnection:Disconnect() end
        sys.instances[item] = nil
    end
end

local function refreshCategoryESP(sys)
    for item, _ in pairs(sys.instances) do
        removeCategoryESP(sys, item)
    end
    if not sys.vars.ESP then return end
    if not droppedItemsFolder then return end
    for _, child in ipairs(droppedItemsFolder:GetChildren()) do
        if sys.itemList[child.Name] then
            createCategoryESP(sys, child)
        end
    end
end

local function setupCategoryListeners(sys)
    if not droppedItemsFolder or sys.listenersSetup then return end
    sys.listenersSetup = true
    local addedConn = droppedItemsFolder.ChildAdded:Connect(function(child)
        if sys.vars.ESP and sys.itemList[child.Name] then
            task.wait(0.2)
            createCategoryESP(sys, child)
        end
    end)
    table.insert(connections, addedConn)
    local removedConn = droppedItemsFolder.ChildRemoved:Connect(function(child)
        removeCategoryESP(sys, child)
    end)
    table.insert(connections, removedConn)
end

for _, sys in pairs(espSystems) do
    sys.create = function(item) createCategoryESP(sys, item) end
    sys.remove = function(item) removeCategoryESP(sys, item) end
    sys.refresh = function() refreshCategoryESP(sys) end
    sys.setupListeners = function() setupCategoryListeners(sys) end
end

for _, sys in pairs(espSystems) do
    setupCategoryListeners(sys)
end

local function removeMobESP(char)
    local esp = mobESPInstances[char]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then esp.DistanceConnection:Disconnect() end
        mobESPInstances[char] = nil
    end
end

local function createMobESP(char)
    if not char:IsA("Model") then return end
    if mobESPInstances[char] then return end

    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return end

    local espTable = { Root = root }
    local mobColors = mobTypeColors[char.Name] or {fill = Color3.fromRGB(220, 0, 0), outline = Color3.fromRGB(255, 185, 185)}

    if mobOptions.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "MobESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = mobColors.fill
        highlight.FillTransparency = espConfig.fillTransparency
        highlight.OutlineColor = mobColors.outline
        highlight.OutlineTransparency = espConfig.outlineTransparency
        highlight.Parent = char
        espTable.Highlight = highlight
    end

    local billboard, nameLabel, distLabel
    if mobOptions.Name or mobOptions.Distance then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "MobESP_NameDistance"
        billboard.Adornee = root
        billboard.Size = UDim2.new(0, 220, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard

        nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = char.Name
        nameLabel.TextColor3 = mobColors.outline
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = espConfig.textSize
        nameLabel.Visible = mobOptions.Name
        nameLabel.Parent = frame

        distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distLabel.TextStrokeTransparency = 0.2
        distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distLabel.Font = Enum.Font.GothamBold
        distLabel.TextSize = math.max(espConfig.textSize - 2, 8)
        distLabel.Visible = mobOptions.Distance
        distLabel.Parent = frame

        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel
    end

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not char or not char.Parent then
            connection:Disconnect()
            return
        end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
        if not myRoot then return end
        local dist = (myRoot.Position - root.Position).Magnitude
        local maxDist = Options and Options.ESPMaxDistance and Options.ESPMaxDistance.Value or 99999
        local visible = dist <= maxDist
        local mc = mobTypeColors[char.Name] or {fill = Color3.fromRGB(220, 0, 0), outline = Color3.fromRGB(255, 185, 185)}
        if mobOptions.Chams and (not espTable.Highlight or not espTable.Highlight.Parent) then
            local h = Instance.new("Highlight")
            h.Name = "MobESP_Highlight"
            h.Adornee = char
            h.FillColor = mc.fill
            h.FillTransparency = espConfig.fillTransparency
            h.OutlineColor = mc.outline
            h.OutlineTransparency = espConfig.outlineTransparency
            h.Enabled = visible
            h.Parent = char
            espTable.Highlight = h
        elseif espTable.Highlight and espTable.Highlight.Parent then
            espTable.Highlight.Enabled = visible
        end
        if billboard and billboard.Parent then
            billboard.Enabled = visible
            if nameLabel and mobOptions.Name then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    nameLabel.Text = char.Name .. " [" .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. "]"
                end
            end
            if distLabel and mobOptions.Distance then
                distLabel.Text = math.floor(dist) .. "m"
                distLabel.TextColor3 = getDistanceColor(dist)
            end
        end
    end)
    espTable.DistanceConnection = connection
    table.insert(connections, connection)

    mobESPInstances[char] = espTable
end

local function refreshMobESP()
    for char, _ in pairs(mobESPInstances) do
        removeMobESP(char)
    end
    if not mobOptions.ESP then return end
    if not charactersFolder then
        StreeHub:Notify({ Title = "Mob ESP", Content = "Characters folder not found (retrying...)", Duration = 3 })
        return
    end
    local playerCharSet = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then playerCharSet[p.Character] = true end
    end
    for _, child in ipairs(charactersFolder:GetChildren()) do
        if child:IsA("Model") and not playerCharSet[child] then
            createMobESP(child)
        end
    end
end

local function removeStructureESP(structure)
    local esp = structureESPInstances[structure]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then esp.DistanceConnection:Disconnect() end
        structureESPInstances[structure] = nil
    end
end

local function createStructureESP(structure)
    if not structure:IsA("Model") then return end
    if structureESPInstances[structure] then return end

    local mainPart = structure.PrimaryPart or getItemMainPart(structure)
    if not mainPart then return end

    local espTable = { MainPart = mainPart }

    if structureESPVars.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "StructESP_Highlight"
        highlight.Adornee = structure
        highlight.FillColor = Color3.fromRGB(0, 200, 150)
        highlight.FillTransparency = espConfig.fillTransparency
        highlight.OutlineColor = Color3.fromRGB(100, 255, 200)
        highlight.OutlineTransparency = espConfig.outlineTransparency
        highlight.Parent = structure
        espTable.Highlight = highlight
    end

    local billboard, nameLabel, distLabel
    if structureESPVars.Name or structureESPVars.Distance then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "StructESP_Info"
        billboard.Adornee = mainPart
        billboard.Size = UDim2.new(0, 250, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = structure

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard

        nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "[STRUCTURE] " .. structure.Name
        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = espConfig.textSize
        nameLabel.Visible = structureESPVars.Name
        nameLabel.Parent = frame

        distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(200, 220, 220)
        distLabel.TextStrokeTransparency = 0.2
        distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distLabel.Font = Enum.Font.GothamBold
        distLabel.TextSize = math.max(espConfig.textSize - 2, 8)
        distLabel.Visible = structureESPVars.Distance
        distLabel.Parent = frame

        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.DistLabel = distLabel
    end

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not structure or not structure.Parent then
            connection:Disconnect()
            return
        end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
        if not myRoot then return end
        local dist = (myRoot.Position - mainPart.Position).Magnitude
        local maxDist = Options and Options.ESPMaxDistance and Options.ESPMaxDistance.Value or 99999
        local visible = dist <= maxDist
        if structureESPVars.Chams and (not espTable.Highlight or not espTable.Highlight.Parent) then
            local h = Instance.new("Highlight")
            h.Name = "StructESP_Highlight"
            h.Adornee = structure
            h.FillColor = Color3.fromRGB(0, 200, 150)
            h.FillTransparency = espConfig.fillTransparency
            h.OutlineColor = Color3.fromRGB(100, 255, 200)
            h.OutlineTransparency = espConfig.outlineTransparency
            h.Enabled = visible
            h.Parent = structure
            espTable.Highlight = h
        elseif espTable.Highlight and espTable.Highlight.Parent then
            espTable.Highlight.Enabled = visible
        end
        if billboard and billboard.Parent then
            billboard.Enabled = visible
            if distLabel and structureESPVars.Distance then
                distLabel.Text = math.floor(dist) .. "m"
                distLabel.TextColor3 = getDistanceColor(dist)
            end
        end
    end)
    espTable.DistanceConnection = connection
    table.insert(connections, connection)

    structureESPInstances[structure] = espTable
end

local function refreshStructureESP()
    for structure, _ in pairs(structureESPInstances) do
        removeStructureESP(structure)
    end
    if not structureESPVars.ESP then return end
    if not structuresFolder then
        StreeHub:Notify({ Title = "Structure ESP", Content = "Structures folder not found (retrying...)", Duration = 3 })
        return
    end
    for _, child in ipairs(structuresFolder:GetDescendants()) do
        if child:IsA("Model") and table.find(structureNames, child.Name) then
            createStructureESP(child)
        end
    end
end

local function removePlayerESP(player)
    local esp = playerESPInstances[player]
    if esp then
        if esp.Highlight then esp.Highlight:Destroy() end
        if esp.Billboard then esp.Billboard:Destroy() end
        if esp.DistanceConnection then esp.DistanceConnection:Disconnect() end
        if esp.CharAddedConn then esp.CharAddedConn:Disconnect() end
        playerESPInstances[player] = nil
    end
end

local function createPlayerESP(player)
    if player == LocalPlayer then return end
    if playerESPInstances[player] then return end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local espTable = {}

    if playerESPVars.Chams then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerESP_Highlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(0, 100, 255)
        highlight.FillTransparency = espConfig.fillTransparency
        highlight.OutlineColor = Color3.fromRGB(100, 180, 255)
        highlight.OutlineTransparency = espConfig.outlineTransparency
        highlight.Parent = char
        espTable.Highlight = highlight
    end
  
    local billboard, nameLabel, toolLabel, healthLabel, distLabel
    if playerESPVars.Name or playerESPVars.Distance or playerESPVars.Health then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerESP_Info"
        billboard.Adornee = root
        billboard.Size = UDim2.new(0, 220, 0, 70)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = char

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard

        nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
        nameLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        nameLabel.TextStrokeTransparency = 0.2
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = espConfig.textSize
        nameLabel.Visible = playerESPVars.Name
        nameLabel.Parent = frame

        toolLabel = Instance.new("TextLabel")
        toolLabel.Name = "ToolLabel"
        toolLabel.Size = UDim2.new(1, 0, 0.25, 0)
        toolLabel.Position = UDim2.new(0, 0, 0.3, 0)
        toolLabel.BackgroundTransparency = 1
        toolLabel.Text = ""
        toolLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
        toolLabel.TextStrokeTransparency = 0.2
        toolLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        toolLabel.Font = Enum.Font.Gotham
        toolLabel.TextSize = math.max(espConfig.textSize - 2, 8)
        toolLabel.Visible = playerESPVars.Name
        toolLabel.Parent = frame

        healthLabel = Instance.new("TextLabel")
        healthLabel.Name = "HealthLabel"
        healthLabel.Size = UDim2.new(1, 0, 0.2, 0)
        healthLabel.Position = UDim2.new(0, 0, 0.55, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = "100 HP"
        healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        healthLabel.TextStrokeTransparency = 0.2
        healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        healthLabel.Font = Enum.Font.GothamBold
        healthLabel.TextSize = math.max(espConfig.textSize - 2, 8)
        healthLabel.Visible = playerESPVars.Health
        healthLabel.Parent = frame

        distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistLabel"
        distLabel.Size = UDim2.new(1, 0, 0.2, 0)
        distLabel.Position = UDim2.new(0, 0, 0.78, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = "0m"
        distLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        distLabel.TextStrokeTransparency = 0.2
        distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distLabel.Font = Enum.Font.GothamBold
        distLabel.TextSize = math.max(espConfig.textSize - 2, 8)
        distLabel.Visible = playerESPVars.Distance
        distLabel.Parent = frame

        espTable.Billboard = billboard
        espTable.NameLabel = nameLabel
        espTable.ToolLabel = toolLabel
        espTable.HealthLabel = healthLabel
        espTable.DistLabel = distLabel
    end

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not player or not player.Parent then
            connection:Disconnect()
            return
        end
        local c = player.Character
        if not c or not c.Parent then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        if not r then return end

        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local dist = (myRoot.Position - r.Position).Magnitude
        local maxDist = Options and Options.ESPMaxDistance and Options.ESPMaxDistance.Value or 99999
        local visible = dist <= maxDist

        if playerESPVars.Chams and (not espTable.Highlight or not espTable.Highlight.Parent) then
            local h = Instance.new("Highlight")
            h.Name = "PlayerESP_Highlight"
            h.Adornee = c
            h.FillColor = Color3.fromRGB(0, 100, 255)
            h.FillTransparency = espConfig.fillTransparency
            h.OutlineColor = Color3.fromRGB(100, 180, 255)
            h.OutlineTransparency = espConfig.outlineTransparency
            h.Parent = c
            espTable.Highlight = h
        elseif espTable.Highlight and espTable.Highlight.Parent then
            espTable.Highlight.Enabled = visible
        end

        if billboard and billboard.Parent then
            billboard.Enabled = visible
            if toolLabel and playerESPVars.Name then
                local tool = c:FindFirstChildOfClass("Tool")
                toolLabel.Text = tool and ("[ " .. tool.Name .. " ]") or ""
            end
            if healthLabel and playerESPVars.Health then
                local humanoid = c:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    healthLabel.Text = math.floor(humanoid.Health) .. " HP"
                    healthLabel.TextColor3 = getHealthColor(humanoid.Health / humanoid.MaxHealth)
                end
            end
            if distLabel and playerESPVars.Distance then
                distLabel.Text = math.floor(dist) .. "m"
                distLabel.TextColor3 = getDistanceColor(dist)
            end
        end
    end)
    espTable.DistanceConnection = connection
    table.insert(connections, connection)

    local charAddedConn = player.CharacterAdded:Connect(function()
        if playerESPVars.ESP then
            task.wait(1)
            removePlayerESP(player)
            createPlayerESP(player)
        end
    end)
    espTable.CharAddedConn = charAddedConn
    table.insert(connections, charAddedConn)

    playerESPInstances[player] = espTable
end

local function refreshPlayerESP()
    for player, _ in pairs(playerESPInstances) do
        removePlayerESP(player)
    end
    if not playerESPVars.ESP then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                createPlayerESP(player)
            else
                local conn = player.CharacterAdded:Connect(function()
                    conn:Disconnect()
                    if playerESPVars.ESP then
                        task.wait(1)
                        createPlayerESP(player)
                    end
                end)
                table.insert(connections, conn)
            end
        end
    end
end

local function setupMobListeners()
    if not charactersFolder or mobListenersSetup then return end
    mobListenersSetup = true
    local childAddedConn = charactersFolder.ChildAdded:Connect(function(child)
        if mobOptions.ESP and child:IsA("Model") then
            local playerCharSet = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then playerCharSet[p.Character] = true end
            end
            if not playerCharSet[child] then
                task.wait(0.2)
                createMobESP(child)
            end
        end
    end)
    table.insert(connections, childAddedConn)

    local childRemovedConn = charactersFolder.ChildRemoved:Connect(function(child)
        removeMobESP(child)
    end)
    table.insert(connections, childRemovedConn)
end
setupMobListeners()

local function setupStructureListeners()
    if not structuresFolder or structureListenersSetup then return end
    structureListenersSetup = true
    local descendantAddedConn = structuresFolder.DescendantAdded:Connect(function(child)
        if structureESPVars.ESP and child:IsA("Model") and table.find(structureNames, child.Name) then
            task.wait(0.2)
            createStructureESP(child)
        end
    end)
    table.insert(connections, descendantAddedConn)

    local descendantRemovingConn = structuresFolder.DescendantRemoving:Connect(function(child)
        removeStructureESP(child)
    end)
    table.insert(connections, descendantRemovingConn)
end
setupStructureListeners()


local noclipLastCFrame = nil

local noclipConn = RunService.Heartbeat:Connect(function()
    if not Toggles.NoClip or not Toggles.NoClip.Value then
        noclipLastCFrame = nil
        return
    end
    local char = LocalPlayer.Character
    if not char then noclipLastCFrame = nil return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then noclipLastCFrame = nil return end

    local currentCF = root.CFrame
    if noclipLastCFrame then
        local delta = (currentCF.Position - noclipLastCFrame.Position).Magnitude
        if delta > 8 then
            root.CFrame = noclipLastCFrame
            currentCF  = noclipLastCFrame
        end
    end
    noclipLastCFrame = currentCF

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end)
table.insert(connections, noclipConn)

local function enableFullbright()
    if not originalLighting.stored then
        originalLighting.Brightness = Lighting.Brightness
        originalLighting.Ambient = Lighting.Ambient
        originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLighting.ClockTime = Lighting.ClockTime
        originalLighting.FogEnd = Lighting.FogEnd
        originalLighting.FogStart = Lighting.FogStart
        originalLighting.GlobalShadows = Lighting.GlobalShadows
        originalLighting.stored = true
    end

    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.GlobalShadows = false
end

local function disableFullbright()
    if originalLighting.stored then
        Lighting.Brightness = originalLighting.Brightness
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.FogStart = originalLighting.FogStart
        Lighting.GlobalShadows = originalLighting.GlobalShadows
    end
end

local function startAutoSprint()
    if autoSprintActive then return end
    autoSprintActive = true
    pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
    end)
end

local function stopAutoSprint()
    if not autoSprintActive then return end
    autoSprintActive = false
    pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
    end)
end


local stopAntiAFK

local function startAntiAFK()
    stopAntiAFK()
    antiAFKConn = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    table.insert(connections, antiAFKConn)
end

stopAntiAFK = function()
    if antiAFKConn then
        antiAFKConn:Disconnect()
        antiAFKConn = nil
    end
end

local killAuraLastSwing = 0
local killAuraCurrentTarget = nil
local killAuraTargetDistance = nil

local weaponSwingSpeeds = {
    ["Knife"] = 0.25,
    ["Katana"] = 0.3,
    ["Crowbar"] = 0.35,
    ["Bat"] = 0.45,
    ["Spiked Bat"] = 0.45,
    ["Hatchet"] = 0.4,
    ["Scythe"] = 0.4,
    ["Spear"] = 0.4,
    ["Fire Axe"] = 0.55,
    ["Sledgehammer"] = 0.6,
    ["Chainsaw"] = 0.35,
    ["Riot Shield"] = 0.5,
}

local function getWeaponSwingSpeed()
    local char = LocalPlayer.Character
    if not char then return 0.5 end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return 0.5 end
    
    local toolName = tool.Name

    if weaponSwingSpeeds[toolName] then
        return weaponSwingSpeeds[toolName]
    end

    for weaponName, speed in pairs(weaponSwingSpeeds) do
        if string.find(toolName:lower(), weaponName:lower()) then
            return speed
        end
    end
    return 0.5
end

local function findTargetsInRange(range)
    local char = LocalPlayer.Character
    if not char then return {} end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    if not charactersFolder then return {} end

    local playerCharSet = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            playerCharSet[p.Character] = true
        end
    end

    local targets = {}
    local myPos   = hrp.Position

    for _, mob in ipairs(charactersFolder:GetChildren()) do
        if mob == char then continue end
        if playerCharSet[mob] then continue end

        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
        local mobHum = mob:FindFirstChildOfClass("Humanoid")
        if not mobHRP or not mobHum then continue end
        if mobHum.Health <= 0 then continue end
        local dist = (mobHRP.Position - myPos).Magnitude
        if dist <= range then
            table.insert(targets, {
                mob       = mob,
                dist      = dist,
                health    = mobHum.Health,
                maxHealth = mobHum.MaxHealth,
            })
        end
    end

    local priority = Options.KillAuraPriority and Options.KillAuraPriority.Value or "Nearest"
    if priority == "Nearest" then
        table.sort(targets, function(a, b) return a.dist < b.dist end)
    elseif priority == "Lowest HP" then
        table.sort(targets, function(a, b) return a.health < b.health end)
    elseif priority == "Highest HP" then
        table.sort(targets, function(a, b) return a.health > b.health end)
    end

    return targets
end

local function findTargetsInRange(range)
    local char = LocalPlayer.Character
    if not char then return {} end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    if not charactersFolder then return {} end

    local playerCharSet = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            playerCharSet[p.Character] = true
        end
    end

    local targets = {}
    local myPos   = hrp.Position

    for _, mob in ipairs(charactersFolder:GetChildren()) do
        if mob == char then continue end
        if playerCharSet[mob] then continue end

        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
        local mobHum = mob:FindFirstChildOfClass("Humanoid")
        if not mobHRP or not mobHum then continue end
        if mobHum.Health <= 0 then continue end
        local dist = (mobHRP.Position - myPos).Magnitude
        if dist <= range then
            table.insert(targets, {
                mob       = mob,
                dist      = dist,
                health    = mobHum.Health,
                maxHealth = mobHum.MaxHealth,
            })
        end
    end

    local priority = Options.KillAuraPriority and Options.KillAuraPriority.Value or "Nearest"
    if priority == "Nearest" then
        table.sort(targets, function(a, b) return a.dist < b.dist end)
    elseif priority == "Lowest HP" then
        table.sort(targets, function(a, b) return a.health < b.health end)
    elseif priority == "Highest HP" then
        table.sort(targets, function(a, b) return a.health > b.health end)
    end

    return targets
end

local function autoEquipWeapon()
    local char = LocalPlayer.Character
    if not char then return false end
    if char:FindFirstChildOfClass("Tool") then return true end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return false end

    local bestTool  = nil
    local bestSpeed = math.huge

    for _, tool in ipairs(backpack:GetChildren()) do
        if not tool:IsA("Tool") then continue end
        if not (tool:FindFirstChild("Swing") or tool:FindFirstChild("HitTargets") or tool:FindFirstChild("RemoteClick")) then continue end
        local speed = weaponSwingSpeeds[tool.Name] or 0.5
        for wName, s in pairs(weaponSwingSpeeds) do
            if string.find(tool.Name:lower(), wName:lower()) then speed = s break end
        end
        if speed < bestSpeed then
            bestSpeed = speed
            bestTool  = tool
        end
    end

    if bestTool then
        pcall(function() bestTool.Parent = char end)
        return true
    end
    return false
end

local function stopKillAura()
    if killAuraConn then
        killAuraConn:Disconnect()
        killAuraConn = nil
    end
    killAuraLastSwing = 0
    killAuraCurrentTarget = nil
    killAuraTargetDistance = nil
    if killAuraIndicatorLine   then killAuraIndicatorLine.Visible   = false end
    if killAuraIndicatorCircle then killAuraIndicatorCircle.Visible = false end
    pcall(function()
        if setsimulationradius then setsimulationradius(50, 300) end
    end)
end

local function startKillAura()
    stopKillAura()

    if not killAuraIndicatorLine then
        killAuraIndicatorLine             = Drawing.new("Line")
        killAuraIndicatorLine.Thickness   = 1.5
        killAuraIndicatorLine.Color       = Color3.fromRGB(255, 55, 55)
        killAuraIndicatorLine.Transparency = 0.65
        killAuraIndicatorLine.Visible     = false
    end
    if not killAuraIndicatorCircle then
        killAuraIndicatorCircle             = Drawing.new("Circle")
        killAuraIndicatorCircle.Thickness   = 1.5
        killAuraIndicatorCircle.Color       = Color3.fromRGB(255, 55, 55)
        killAuraIndicatorCircle.Transparency = 0.55
        killAuraIndicatorCircle.Filled      = false
        killAuraIndicatorCircle.Visible     = false
    end

    pcall(function()
        if setsimulationradius then setsimulationradius(1000, 1000) end
    end)

    killAuraConn = RunService.Heartbeat:Connect(function()
        if not Toggles.KillAura or not Toggles.KillAura.Value then
            killAuraCurrentTarget = nil
            if killAuraIndicatorLine   then killAuraIndicatorLine.Visible   = false end
            if killAuraIndicatorCircle then killAuraIndicatorCircle.Visible = false end
            return
        end

        local success, err = pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local tool = char:FindFirstChildOfClass("Tool")
            if not tool and Toggles.KillAuraAutoEquip and Toggles.KillAuraAutoEquip.Value then
                autoEquipWeapon()
                tool = char:FindFirstChildOfClass("Tool")
            end

            if not tool then
                killAuraCurrentTarget = nil
                if killAuraIndicatorLine   then killAuraIndicatorLine.Visible   = false end
                if killAuraIndicatorCircle then killAuraIndicatorCircle.Visible = false end
                return
            end

            local swing       = tool:FindFirstChild("Swing")
            local hitTargets  = tool:FindFirstChild("HitTargets")
            local remoteClick = tool:FindFirstChild("RemoteClick")

            local baseRange        = Options.KillAuraRange and Options.KillAuraRange.Value or 6
            local useExtendedRange = Toggles.KillAuraExtendedRange and Toggles.KillAuraExtendedRange.Value
            local attackRange      = useExtendedRange and (baseRange + 2) or baseRange

            local targets = findTargetsInRange(attackRange)
            killAuraCurrentTarget  = targets[1] and targets[1].mob  or nil
            killAuraTargetDistance = targets[1] and targets[1].dist or nil

            local showIndicator = Toggles.KillAuraShowIndicator and Toggles.KillAuraShowIndicator.Value
            if showIndicator and killAuraCurrentTarget then
                local camera = Workspace.CurrentCamera
                if camera then
                    local tHRP = killAuraCurrentTarget:FindFirstChild("HumanoidRootPart")
                    if tHRP then
                        local sp, onScreen = camera:WorldToViewportPoint(tHRP.Position)
                        if onScreen and sp.Z > 0 then
                            local vp     = camera.ViewportSize
                            local center = Vector2.new(vp.X / 2, vp.Y)
                            local tgt    = Vector2.new(sp.X, sp.Y)
                            killAuraIndicatorLine.From    = center
                            killAuraIndicatorLine.To      = tgt
                            killAuraIndicatorLine.Visible = true
                            local radius = math.clamp(1200 / math.max(killAuraTargetDistance, 1), 8, 40)
                            killAuraIndicatorCircle.Position = tgt
                            killAuraIndicatorCircle.Radius   = radius
                            killAuraIndicatorCircle.Visible  = true
                        else
                            killAuraIndicatorLine.Visible   = false
                            killAuraIndicatorCircle.Visible = false
                        end
                    end
                end
            else
                if killAuraIndicatorLine   then killAuraIndicatorLine.Visible   = false end
                if killAuraIndicatorCircle then killAuraIndicatorCircle.Visible = false end
            end

            if #targets == 0 then return end

            local weaponSpeed        = getWeaponSwingSpeed()
            local userSwingRate      = Options.KillAuraSwingRate and Options.KillAuraSwingRate.Value or weaponSpeed
            local effectiveSwingRate = math.max(weaponSpeed, userSwingRate)
            local now = tick()
            if now - killAuraLastSwing < effectiveSwingRate then return end

            local mobModels = {}
            for _, t in ipairs(targets) do
                table.insert(mobModels, t.mob)
            end

            local attackSuccess = false

            if swing and hitTargets then
                local s1, e1 = pcall(function() swing:FireServer() end)
                if s1 then
                    killAuraLastSwing = now
                    attackSuccess = true
                    local s2, e2 = pcall(function() hitTargets:FireServer(mobModels) end)
                    if not s2 then warn("[KillAura] HitTargets error: " .. tostring(e2)) end
                else
                    warn("[KillAura] Swing error: " .. tostring(e1))
                end
            elseif remoteClick then
                local s, e = pcall(function() remoteClick:FireServer(targets[1].mob) end)
                attackSuccess = s
                if not s then warn("[KillAura] RemoteClick error: " .. tostring(e)) end
            end

            if attackSuccess and killAuraLastSwing ~= now then
                killAuraLastSwing = now
            end
        end)

        if not success then
            warn("[KillAura] Error: " .. tostring(err))
        end
    end)
end
