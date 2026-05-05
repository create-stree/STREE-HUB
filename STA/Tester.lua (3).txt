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


local function stopAimbot()
    if aimbotConn then
        aimbotConn:Disconnect()
        aimbotConn = nil
    end
    aimbotTarget = nil
    if fovCircle then fovCircle.Visible = false end
end

local function getAimbotTarget()
    local char = LocalPlayer.Character
    if not char then return nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local camera = Workspace.CurrentCamera
    if not camera then return nil end

    local viewportSize = camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    local fov = Options.AimbotFOV and Options.AimbotFOV.Value or 100
    local maxRange = Options.AimbotRange and Options.AimbotRange.Value or 500
    local targetMode = Options.AimbotTarget and Options.AimbotTarget.Value or "Mobs"
    local aimPart = Options.AimbotPart and Options.AimbotPart.Value or "Head"

    local bestTarget = nil
    local bestScore = math.huge

    local function isValidTarget(targetChar, targetRoot)
        if not targetChar or not targetRoot then return false end
        if targetChar == char then return false end

        local dist = (targetRoot.Position - myRoot.Position).Magnitude
        if dist > maxRange then return false end

        local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then return false end

        local screenPos, onScreen = camera:WorldToViewportPoint(targetRoot.Position)
        if not onScreen then return false end

        local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
        if fovDist > fov then return false end

        return true, dist, fovDist, screenPos
    end

    if targetMode == "Mobs" or targetMode == "Both" then
        if charactersFolder then
            for _, mob in ipairs(charactersFolder:GetChildren()) do
                if table.find(mobNames, mob.Name) then
                    local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob:FindFirstChild("UpperTorso")
                    local valid, dist, fovDist = isValidTarget(mob, mobRoot)
                    if valid then
                        local score = Options.AimbotPriority and Options.AimbotPriority.Value == "FOV" and fovDist or dist
                        if score < bestScore then
                            bestScore = score
                            bestTarget = {character = mob, rootPart = mobRoot}
                        end
                    end
                end
            end
        end
    end

    if targetMode == "Players" or targetMode == "Both" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local pChar = player.Character
                if pChar then
                    local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                    local valid, dist, fovDist = isValidTarget(pChar, pRoot)
                    if valid then
                        local score = Options.AimbotPriority and Options.AimbotPriority.Value == "FOV" and fovDist or dist
                        if score < bestScore then
                            bestScore = score
                            bestTarget = {character = pChar, rootPart = pRoot}
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

local function startAimbot()
    stopAimbot()
    aimbotConn = RunService.RenderStepped:Connect(function()
        if not Toggles.Aimbot or not Toggles.Aimbot.Value then
            if fovCircle then fovCircle.Visible = false end
            return
        end

        local char = LocalPlayer.Character
        if not char then return end

        local camera = Workspace.CurrentCamera
        if not camera then return end

        local target = getAimbotTarget()
        aimbotTarget = target

        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Filled = false
            fovCircle.NumSides = 64
            fovCircle.Thickness = 1.5
            fovCircle.Transparency = 1
        end
        if Toggles.AimbotFOVCircle and Toggles.AimbotFOVCircle.Value then
            local vp = camera.ViewportSize
            fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
            fovCircle.Radius = Options.AimbotFOV and Options.AimbotFOV.Value or 100
            fovCircle.Color = Color3.fromRGB(255, 255, 255)
            fovCircle.Visible = true
        else
            fovCircle.Visible = false
        end

        if not target then return end

        local aimPartName = Options.AimbotPart and Options.AimbotPart.Value or "Head"
        local targetPart = target.character:FindFirstChild(aimPartName)

        if not targetPart or not targetPart:IsA("BasePart") then
            targetPart = target.rootPart
        end

        if not targetPart then return end

        local targetPos = targetPart.Position
        if Toggles.AimbotPrediction and Toggles.AimbotPrediction.Value then
            local velocity = targetPart.AssemblyLinearVelocity
            local predictionAmount = Options.AimbotPredictionAmount and Options.AimbotPredictionAmount.Value or 0.1
            targetPos = targetPos + (velocity * predictionAmount)
        end

        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local myHead = char:FindFirstChild("Head")
        if not myHead then return end

        local aimPos = targetPos
        if aimPartName == "Head" then

            aimPos = targetPos + Vector3.new(0, 0.5, 0)
        end

        local smoothness = Options.AimbotSmoothness and Options.AimbotSmoothness.Value or 0.5
        local smoothFactor = 1 - (smoothness * 0.95)

        local targetCFrame = CFrame.lookAt(myHead.Position, aimPos)

        if smoothness > 0 then
            targetCFrame = camera.CFrame:Lerp(targetCFrame, smoothFactor)
        end

        camera.CFrame = targetCFrame
    end)
end


local fogOriginalStates = {}
local fogObjects = {}
local fogFEConns  = {}

local function makeFogObjectInvisible(obj)
    local success, err = pcall(function()
        local originalState = {}
        
        if obj:IsA("BasePart") then
            originalState.Transparency = obj.Transparency
            originalState.Material = obj.Material
            obj.Transparency = 1
            obj.Material = Enum.Material.Air
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("ParticleEmitter") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Beam") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Trail") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Smoke") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Fire") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Sparkles") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Explosion") then
            originalState.Visible = obj.Visible
            obj.Visible = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            originalState.Transparency = obj.Transparency
            obj.Transparency = 1
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Light") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Highlight") then
            originalState.Enabled = obj.Enabled
            obj.Enabled = false
            fogOriginalStates[obj] = originalState
        elseif obj:IsA("Folder") or obj:IsA("Model") then
            for _, child in ipairs(obj:GetDescendants()) do
                makeFogObjectInvisible(child)
            end
        end
    end)
    if not success then
        warn("[RemoveFog] Failed to process object: " .. tostring(err))
    end
end

local function restoreFogObjectVisibility(obj)
    if fogOriginalStates[obj] then
        pcall(function()
            local state = fogOriginalStates[obj]
            if obj:IsA("BasePart") then
                obj.Transparency = state.Transparency
                obj.Material = state.Material
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") 
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") 
                or obj:IsA("Light") or obj:IsA("Highlight") then
                obj.Enabled = state.Enabled
            elseif obj:IsA("Explosion") then
                obj.Visible = state.Visible
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = state.Transparency
            end
        end)
    end
end

local function enableRemoveFog()
    if not originalFog.stored then
        originalFog.FogEnd   = Lighting.FogEnd
        originalFog.FogStart = Lighting.FogStart
        originalFog.stored   = true
    end
    Lighting.FogEnd   = 100000
    Lighting.FogStart = 0

    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if atm then
        if originalFog.AtmDensity == nil then
            originalFog.AtmDensity = atm.Density
            originalFog.AtmHaze    = atm.Haze
            originalFog.AtmGlare   = atm.Glare
        end
        atm.Density = 0
        atm.Haze    = 0
        atm.Glare   = 0
    end

    for _, conn in ipairs(fogFEConns) do pcall(function() conn:Disconnect() end) end
    fogFEConns = {}

    table.insert(fogFEConns, Lighting.Changed:Connect(function(prop)
        if not (Toggles.RemoveFog and Toggles.RemoveFog.Value) then return end
        if prop == "FogEnd"   then Lighting.FogEnd   = 100000 end
        if prop == "FogStart" then Lighting.FogStart = 0      end
    end))

    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmosphere then
        table.insert(fogFEConns, atmosphere.Changed:Connect(function(prop)
            if not (Toggles.RemoveFog and Toggles.RemoveFog.Value) then return end
            if prop == "Density" then atmosphere.Density = 0 end
            if prop == "Haze"    then atmosphere.Haze    = 0 end
            if prop == "Glare"   then atmosphere.Glare   = 0 end
        end))
    end

    local fogFolder = Workspace:FindFirstChild("Fog")
    if fogFolder then
        fogOriginalStates = {}
        fogObjects = {}

        for _, child in ipairs(fogFolder:GetChildren()) do
            table.insert(fogObjects, child)
            makeFogObjectInvisible(child)
        end
        for _, descendant in ipairs(fogFolder:GetDescendants()) do
            if not fogOriginalStates[descendant] then
                makeFogObjectInvisible(descendant)
            end
        end

        table.insert(fogFEConns, fogFolder.ChildAdded:Connect(function(child)
            if not (Toggles.RemoveFog and Toggles.RemoveFog.Value) then return end
            makeFogObjectInvisible(child)
            for _, desc in ipairs(child:GetDescendants()) do
                makeFogObjectInvisible(desc)
            end
        end))

        StreeHub:Notify({ Title = "Remove Fog", Content = "Enabled – " .. #fogObjects .. " fog objects hidden", Duration = 2 })
    else
        StreeHub:Notify({ Title = "Remove Fog", Content = "Enabled – Lighting fog cleared (no Fog folder found)", Duration = 2 })
    end
end

local function disableRemoveFog()
    for _, conn in ipairs(fogFEConns) do pcall(function() conn:Disconnect() end) end
    fogFEConns = {}

    if originalFog.stored then
        Lighting.FogEnd   = originalFog.FogEnd
        Lighting.FogStart = originalFog.FogStart
    end

    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if atm and originalFog.AtmDensity ~= nil then
        atm.Density = originalFog.AtmDensity
        atm.Haze    = originalFog.AtmHaze
        atm.Glare   = originalFog.AtmGlare
        originalFog.AtmDensity = nil
        originalFog.AtmHaze    = nil
        originalFog.AtmGlare   = nil
    end

    for obj, _ in pairs(fogOriginalStates) do
        restoreFogObjectVisibility(obj)
    end

    fogOriginalStates = {}
    fogObjects = {}

    StreeHub:Notify({ Title = "Remove Fog", Content = "Disabled – fog restored", Duration = 2 })
end


local function stopBhop()
    if bhopConn then
        bhopConn:Disconnect()
        bhopConn = nil
    end
    bhopActive = false
end

local function startBhop()
    stopBhop()
    bhopActive = true
    
    bhopConn = RunService.RenderStepped:Connect(function()
        if not Toggles.BunnyHop or not Toggles.BunnyHop.Value then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not root then return end
        
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0.1 then
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local funnyDanceTrack = nil
local funnyDanceConn  = nil

local DANCE_ANIM_IDS = {
    507770723,
    507772104,
    507771281,
}

local function stopFunnyDance()
    if funnyDanceConn then
        funnyDanceConn:Disconnect()
        funnyDanceConn = nil
    end
    if funnyDanceTrack then
        if funnyDanceTrack ~= "PHYS" then
            pcall(function() funnyDanceTrack:Stop(0.3) end)
        end
        funnyDanceTrack = nil
    end
end

local function startFunnyDance()
    stopFunnyDance()

    local selectedIdx = Options.DanceStyle and Options.DanceStyle.Value or 1
    local selectedId  = DANCE_ANIM_IDS[selectedIdx] or DANCE_ANIM_IDS[1]

    local physDanceConn = nil

    local function stopPhysDance()
        if physDanceConn then
            physDanceConn:Disconnect()
            physDanceConn = nil
        end
    end

    local function startPhysDance(char)
        stopPhysDance()
        local t = 0
        local spinDir = (selectedIdx % 2 == 0) and 1 or -1
        physDanceConn = RunService.Heartbeat:Connect(function(dt)
            if not Toggles.FunnyDance or not Toggles.FunnyDance.Value then
                stopPhysDance()
                return
            end
            local c = char or LocalPlayer.Character
            if not c then return end
            local root = c:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            t = t + dt
            local spin = CFrame.Angles(0, spinDir * dt * (2.5 + selectedIdx * 0.4), 0)
            local bob  = Vector3.new(0, math.sin(t * 4) * 0.08, 0)
            root.CFrame = CFrame.new(root.Position + bob) * (root.CFrame - root.CFrame.Position) * spin
        end)
        funnyDanceTrack = "PHYS"
    end

    local function applyDance(char)
        char = char or LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end
        if funnyDanceTrack then
            if funnyDanceTrack == "PHYS" then
                stopPhysDance()
            else
                pcall(function() funnyDanceTrack:Stop(0) end)
            end
            funnyDanceTrack = nil
        end

        local function findNativeAnim()
            local animateScript = char:FindFirstChild("Animate")
            if not animateScript then return nil end
            local danceVariants = {
                { "dance",  "dance2", "dance3"  },
                { "Dance",  "Dance2", "Dance3"  },
                { "emote",  "emote2", "emote3"  },
                { "Emote",  "Emote2", "Emote3"  },
            }
            for _, variants in ipairs(danceVariants) do
                local folderName = variants[selectedIdx] or variants[1]
                local folder = animateScript:FindFirstChild(folderName)
                if folder then
                    local anim = folder:FindFirstChildOfClass("Animation")
                    if anim then return anim end
                end
            end
            for _, desc in ipairs(animateScript:GetDescendants()) do
                if desc:IsA("Animation") then return desc end
            end
            return nil
        end

        local nativeAnim = findNativeAnim()
        if nativeAnim then
            local ok, track = pcall(function() return animator:LoadAnimation(nativeAnim) end)
            if ok and track then
                track.Priority = Enum.AnimationPriority.Action4
                track.Looped   = true
                track:Play(0.15)
                funnyDanceTrack = track
                return
            end
        end

        local ok2, results = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(selectedId))
        end)
        if ok2 and results and results[1] and results[1]:IsA("Animation") then
            local ok3, track = pcall(function() return animator:LoadAnimation(results[1]) end)
            if ok3 and track then
                track.Priority = Enum.AnimationPriority.Action4
                track.Looped   = true
                track:Play(0.15)
                funnyDanceTrack = track
                return
            end
        end

        StreeHub:Notify({ Title = "Funny Dance", Content = "Animation blocked by game – using physics dance instead.", Duration = 3 })
        startPhysDance(char)
    end

    applyDance()

    funnyDanceConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.delay(0.5, function()
            if Toggles.FunnyDance and Toggles.FunnyDance.Value then
                selectedIdx = Options.DanceStyle and Options.DanceStyle.Value or 1
                selectedId  = DANCE_ANIM_IDS[selectedIdx] or DANCE_ANIM_IDS[1]
                if physDanceConn then stopPhysDance() end
                applyDance(newChar)
            end
        end)
    end)
end


local function serverHop()
    local placeId = game.PlaceId
    local servers = {}
    local req = syn and syn.request or http_request or request or httprequest

    if req then
        local sortOrder = math.random(0, 1) == 0 and "Asc" or "Desc"
        local cursor = ""
        local maxPages = 3

        for _ = 1, maxPages do
            local url = "https://games.roblox.com/v1/games/" .. placeId
                .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100"
                .. (cursor ~= "" and ("&cursor=" .. cursor) or "")

            local ok, response = pcall(req, { Url = url, Method = "GET" })
            if not ok or not response or not response.Body then break end

            local ok2, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response.Body)
            end)
            if not ok2 or not data or not data.data then break end

            for _, server in ipairs(data.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end

            local nextCursor = data.nextPageCursor
            if not nextCursor or nextCursor == "" or nextCursor == "null" then break end
            cursor = tostring(nextCursor)
        end
    end

    if #servers > 0 then
        for i = #servers, 2, -1 do
            local j = math.random(1, i)
            servers[i], servers[j] = servers[j], servers[i]
        end
        TeleportService:TeleportToPlaceInstance(placeId, servers[1], LocalPlayer)
        StreeHub:Notify({ Title = "Server Hop", Content = "Joining 1 of " .. #servers .. " servers found...", Duration = 3 })
    else
        TeleportService:Teleport(placeId, LocalPlayer)
        StreeHub:Notify({ Title = "Server Hop", Content = "No other servers found, re-matchmaking...", Duration = 3 })
    end
end


local function rejoinServer()
    local placeId = game.PlaceId
    local jobId   = game.JobId

    if not jobId or jobId == "" then
        pcall(function() TeleportService:Teleport(placeId, LocalPlayer) end)
        StreeHub:Notify({ Title = "Rejoin", Content = "No JobId – rejoining via matchmaking...", Duratiom = 3 })
        return
    end

    StreeHubNotify({ Title = "Rejoin", Comtent = "Rejoining server...", Duration = 2 })

    local ok1, err1 = pcall(function()
        local opts = Instance.new("TeleportOptions")
        opts.ServerInstanceId = jobId
        TeleportService:TeleportAsync(placeId, { LocalPlayer }, opts)
    end)
    if ok1 then return end
    warn("[Rejoin] TeleportAsync failed: " .. tostring(err1))

    local ok2, err2 = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
    end)
    if ok2 then return end
    warn("[Rejoin] TeleportToPlaceInstance failed: " .. tostring(err2))

    pcall(function() TeleportService:Teleport(placeId, LocalPlayer) end)
    StreeHub:Notify({ Title = "Rejoin", Content = "Server unavailable – rejoining via matchmaking...", Duration = 3 })
end


local remoteSpyConnections = {}
local oldFireServer = nil
local oldInvokeServer = nil

local function stopRemoteSpy()
    remoteSpyEnabled = false

    oldFireServer = nil
    oldInvokeServer = nil

    for _, conn in ipairs(remoteSpyConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    remoteSpyConnections = {}
    
    StreeHub:Notify({ Title = "Remote Spy", Content = "Disabled", Duration = 2 })
end

local function startRemoteSpy()
    stopRemoteSpy()
    remoteSpyEnabled = true
    remoteSpyLogs = {}
    
    StreeHub:Notify({ Title = "Remote Spy", Content = "Enabled - Check console for remote calls", Duration = 3 })

    local function logRemoteCall(remote, method, args)
        if not remoteSpyEnabled then return end

        local success, name = pcall(function() return remote.Name end)
        local success2, path = pcall(function() return remote:GetFullName() end)
        local success3, className = pcall(function() return remote.ClassName end)
        
        local logEntry = {
            Type = success3 and className or "Unknown",
            Method = method,
            Name = success and name or "Unknown",
            Path = success2 and path or "Unknown",
            Args = args,
            Time = os.date("%H:%M:%S")
        }
        table.insert(remoteSpyLogs, logEntry)
        if #remoteSpyLogs > 100 then table.remove(remoteSpyLogs, 1) end

        local argCount = args and #args or 0
        print(string.format("[RemoteSpy] %s.%s(%s) - %s", 
            success and name or "Unknown", method, 
            argCount > 0 and tostring(argCount) .. " args" or "no args",
            os.date("%H:%M:%S")))
    end

    if hookmetamethod then
        local success, err = pcall(function()
            local originalNamecall
            originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if remoteSpyEnabled and (method == "FireServer" or method == "InvokeServer") then
                    logRemoteCall(self, method, {...})
                end
                return originalNamecall(self, ...)
            end))
            oldFireServer = originalNamecall
        end)
        if success then
            StreeHub:Notify({ Title = "Remote Spy", Content = "Hooked via hookmetamethod (Potassium)", Duration = 2 })
            return
        else
            warn("[RemoteSpy] hookmetamethod failed: " .. tostring(err))
        end
    end

    if hookfunction then
        local success, err = pcall(function()
            local tempRemote = Instance.new("RemoteEvent")
            local tempFunc = Instance.new("RemoteFunction")

            oldFireServer = hookfunction(tempRemote.FireServer, function(self, ...)
                if remoteSpyEnabled then logRemoteCall(self, "FireServer", {...}) end
                return oldFireServer(self, ...)
            end)

            oldInvokeServer = hookfunction(tempFunc.InvokeServer, function(self, ...)
                if remoteSpyEnabled then logRemoteCall(self, "InvokeServer", {...}) end
                return oldInvokeServer(self, ...)
            end)

            tempRemote:Destroy()
            tempFunc:Destroy()
        end)
        if success then
            StreeHub:Notify({ Title = "Remote Spy", Content = "Hooked via hookfunction", Duration = 2 })
            return
        else
            warn("[RemoteSpy] hookfunction failed: " .. tostring(err))
        end
    end

    if getrawmetatable and setreadonly then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        local success, err = pcall(function()
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if remoteSpyEnabled and (method == "FireServer" or method == "InvokeServer") then
                    logRemoteCall(self, method, {...})
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end)
        if success then
            StreeHub:Notify({ Title = "Remote Spy", Content = "Hooked via namecall", Duration = 2 })
            return
        else
            warn("[RemoteSpy] namecall hook failed: " .. tostring(err))
            pcall(function()
                setreadonly(mt, false)
                mt.__namecall = oldNamecall
                setreadonly(mt, true)
            end)
        end
    end

    StreeHub:Notify({ Title = "Remote Spy", Content= "Running in passive mode (no hooks available)", Duration= 4 })

    if Remotes then
        print("[RemoteSpy] === Available Remotes ===")
        for _, folder in ipairs(Remotes:GetChildren()) do
            for _, remote in ipairs(folder:GetChildren()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    print(string.format("[RemoteSpy] %s: %s", remote.ClassName, remote:GetFullName()))
                    table.insert(remoteSpyLogs, {
                        Type = remote.ClassName,
                        Method = "Discovered",
                        Name = remote.Name,
                        Path = remote:GetFullName(),
                        Args = {},
                        Time = os.date("%H:%M:%S")
                    })
                end
            end
        end
        print("[RemoteSpy] === End of Remote List ===")
    end
end

local autoPickupActive  = false
local autoPickupThread  = nil
local autoPickupAttempts = {}

local function stopAutoPickup()
    autoPickupActive = false
    if autoPickupThread then
        pcall(function() task.cancel(autoPickupThread) end)
        autoPickupThread = nil
    end
    pcall(function() if setsimulationradius then setsimulationradius(50, 300) end end)
    autoPickupAttempts = {}
end

local function startAutoPickup()
    stopAutoPickup()
    autoPickupActive = true

    pcall(function() if setsimulationradius then setsimulationradius(2048, 2048) end end)

    autoPickupThread = task.spawn(function()
        while autoPickupActive and Toggles.AutoPickup and Toggles.AutoPickup.Value do
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not droppedItemsFolder then task.wait(0.5) continue end

            local myPos    = hrp.Position
            local radius   = Options.AutoPickupRadius  and Options.AutoPickupRadius.Value  or 20
            local allItems = Toggles.AutoPickupAll     and Toggles.AutoPickupAll.Value
            local whitelist  = Options.AutoPickupWhitelist and Options.AutoPickupWhitelist.Value or {}
            local blacklist  = Options.AutoPickupBlacklist and Options.AutoPickupBlacklist.Value or {}

            local centerTile = Workspace:FindFirstChild("Map")
                and Workspace.Map:FindFirstChild("Tiles")
                and Workspace.Map.Tiles:FindFirstChild("Center")
            if centerTile then
                local ok, cf, size = pcall(function() return centerTile:GetBoundingBox() end)
                if ok and cf and size then
                    local localPos = cf:PointToObjectSpace(myPos)
                    if math.abs(localPos.X) <= size.X / 2 and math.abs(localPos.Z) <= size.Z / 2 then
                        task.wait(0.5) continue
                    end
                end
            end

            local useRemote = not Toggles.AutoPickupMethodRemote or Toggles.AutoPickupMethodRemote.Value
            local useTouch  = not Toggles.AutoPickupMethodTouch  or Toggles.AutoPickupMethodTouch.Value
            local usePrompt = not Toggles.AutoPickupMethodPrompt or Toggles.AutoPickupMethodPrompt.Value

            for _, item in ipairs(droppedItemsFolder:GetChildren()) do
                if not autoPickupActive then break end
                if not item.Parent then continue end

                if not allItems and not whitelist[item.Name] then continue end

                local mainPart = item.PrimaryPart or getItemMainPart(item)
                if not mainPart then continue end

                local dist = (mainPart.Position - myPos).Magnitude
                if dist > radius then continue end

                local now = tick()
                if autoPickupAttempts[item] and (now - autoPickupAttempts[item]) < 0.35 then continue end
                autoPickupAttempts[item] = now

                if useRemote then
                    if not blacklist[item.Name] then
                        pcall(function()
                            if pickUpItemRemote then pickUpItemRemote:FireServer(item) end
                        end)
                    end
                    pcall(function()
                        if adjustBackpackRemote then adjustBackpackRemote:FireServer(item) end
                    end)
                end

                if useTouch then
                    pcall(function()
                        if firetouchinterest then
                            firetouchinterest(hrp, mainPart, 0)
                            firetouchinterest(hrp, mainPart, 1)
                        end
                    end)
                end

                if usePrompt then
                    pcall(function()
                        if fireproximityprompt then
                            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then fireproximityprompt(prompt) end
                        end
                    end)
                end

                task.wait()
            end

            for itemRef in pairs(autoPickupAttempts) do
                if not itemRef.Parent then
                    autoPickupAttempts[itemRef] = nil
                end
            end

            task.wait(0.1)
        end

        autoPickupActive = false
        pcall(function() if setsimulationradius then setsimulationradius(50, 300) end end)
    end)
end

local function stopRepairAura()
    if repairAuraConn then
        repairAuraConn:Disconnect()
        repairAuraConn = nil
    end
end

local function startRepairAura()
    stopRepairAura()
    local lastFire = 0

    repairAuraConn = RunService.Heartbeat:Connect(function()
        if not Toggles.RepairAura or not Toggles.RepairAura.Value then return end

        local rate     = Options.RepairAuraRate and Options.RepairAuraRate.Value or 1
        local interval = 1 / rate
        local now      = tick()
        if now - lastFire < interval then return end

        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool or tool.Name ~= "Repair Hammer" then return end

        local repairRemote = tool:FindFirstChild("Repair")
        if not repairRemote then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local myPos   = hrp.Position
        local maxDist = Options.RepairAuraRange and Options.RepairAuraRange.Value or 30

        if not structuresFolder then return end
        local nearest     = nil
        local nearestDist = math.huge
        for _, child in ipairs(structuresFolder:GetDescendants()) do
            if child:IsA("Model") then
                local part = child.PrimaryPart or getItemMainPart(child)
                if part then
                    local dist = (myPos - part.Position).Magnitude
                    if dist <= maxDist and dist < nearestDist then
                        nearestDist = dist
                        nearest     = child
                    end
                end
            end
        end

        if nearest then
            lastFire = now
            pcall(function()
                repairRemote:FireServer(nearest)
            end)
        end
    end)
end


local playerAddedConn = Players.PlayerAdded:Connect(function(player)
    if playerESPVars.ESP then
        task.wait(2)
        createPlayerESP(player)
    end
end)
table.insert(connections, playerAddedConn)

local playerRemovingConn = Players.PlayerRemoving:Connect(function(player)
    removePlayerESP(player)
end)
table.insert(connections, playerRemovingConn)


LocalPlayer.CharacterRemoving:Connect(function()
    if autoSprintActive then stopAutoSprint() end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 10)
    task.wait(0.5)
    if Toggles.AutoSprint and Toggles.AutoSprint.Value then startAutoSprint() end
    if Toggles.AutoPickup and Toggles.AutoPickup.Value then startAutoPickup() end
end)


local function applyESPTextSize(size)
    espConfig.textSize = size
    local small = math.max(size - 2, 8)
    for _, sys in pairs(espSystems) do
        for _, esp in pairs(sys.instances) do
            if esp.NameLabel then esp.NameLabel.TextSize = size end
            if esp.DistLabel  then esp.DistLabel.TextSize  = small end
        end
    end
    for _, esp in pairs(mobESPInstances) do
        if esp.NameLabel then esp.NameLabel.TextSize = size end
        if esp.DistLabel  then esp.DistLabel.TextSize  = small end
    end
    for _, esp in pairs(structureESPInstances) do
        if esp.NameLabel then esp.NameLabel.TextSize = size end
        if esp.DistLabel  then esp.DistLabel.TextSize  = small end
    end
    for _, esp in pairs(playerESPInstances) do
        if esp.NameLabel   then esp.NameLabel.TextSize   = size  end
        if esp.ToolLabel   then esp.ToolLabel.TextSize   = small end
        if esp.HealthLabel then esp.HealthLabel.TextSize = small end
        if esp.DistLabel   then esp.DistLabel.TextSize   = small end
    end
end

local function applyESPTransparency()
    local fillT    = espConfig.fillTransparency
    local outlineT = espConfig.outlineTransparency
    local function updateH(esp)
        if esp.Highlight and esp.Highlight.Parent then
            esp.Highlight.FillTransparency    = fillT
            esp.Highlight.OutlineTransparency = outlineT
        end
    end
    for _, sys in pairs(espSystems) do
        for _, esp in pairs(sys.instances) do updateH(esp) end
    end
    for _, esp in pairs(mobESPInstances)       do updateH(esp) end
    for _, esp in pairs(structureESPInstances) do updateH(esp) end
    for _, esp in pairs(playerESPInstances)    do updateH(esp) end
end
