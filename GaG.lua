local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)


local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = (premium and "Premium" or "Grow A Garden") .. " - " .. version,
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/Config.json"
})


local Tabs = {
    Home = Window:Tab({ Title = "Home", Icon = "scan-face" }),
    Main = Window:Tab({ Title = "Main", Icon = "landmark" }),
    Event = Window:Tab({ Title = "Event", Icon = "send" }),
    Shop = Window:Tab({ Title = "Shop", Icon = "shopping-bag" }),
    Misc = Window:Tab({ Title = "Miscellaneous", Icon = "layout-grid" }),
    Setting = Window:Tab({ Title = "Setting", Icon = "settings" }),
}


local defaultWalk = 16
local defaultJump = 50
local currentWalk = defaultWalk
local currentJump = defaultJump

Tabs.Home:Section({ Title = "Information" })

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

Tabs.Home:Paragraph({
    Title = "Join Us",
    Desc = "Every Update Will Be On Discord"
})

Tabs.Home:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tabs.Home:Section({ Title = "Local Player" })

Tabs.Home:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = defaultWalk },
    Callback = function(value)
        currentWalk = value
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

Tabs.Home:Slider({
    Title = "JumpPower",
    Step = 1,
    Value = { Min = 0, Max = 150, Default = defaultJump },
    Callback = function(value)
        currentJump = value
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end
})

Tabs.Home:Button({
    Title = "Reset Default",
    Callback = function()
        currentWalk = defaultWalk
        currentJump = defaultJump

        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = defaultWalk
            char.Humanoid.JumpPower = defaultJump
        end
    end
})


Tabs.Main:Section({ Title = "Plants" })

local PlantEnabled = false
local PlantSeed = "Carrot"

local SeedList = {
    "Carrot", "Strawberry", "Blueberry", "Buttercup", "Tomato",
    "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple",
    "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango",
    "Grape", "Mushroom", "Pepper", "Cacao", "Sunflower",
    "Beantalk", "Ember Lily", "Sugar Apple", "Burning Bud",
    "Elder Strawberry", "Romanesco", "Crimson", "Zebrazinkle",
    "Octobloom", "Alien Apple", "Eggsnapper"
}

local function GetPlayerPosition()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.Position
        end
    end
    return nil
end

Tabs.Main:Dropdown({
    Title = "Select Seed",
    Values = SeedList,
    Default = "Carrot",
    Callback = function(Value)
        PlantSeed = Value
    end
})

Tabs.Main:Toggle({
    Title = "Auto Plant",
    Default = false,
    Callback = function(Value)
        PlantEnabled = Value

        task.spawn(function()
            while PlantEnabled do
                pcall(function()
                    local pos = GetPlayerPosition()
                    if pos then
                        game:GetService("ReplicatedStorage").GameEvents.Plant_RE:FireServer(
                            pos,
                            PlantSeed
                        )
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

Tabs.Main:Button({
    Title = "Plant Once",
    Callback = function()
        pcall(function()
            local pos = GetPlayerPosition()
            if pos then
                game:GetService("ReplicatedStorage").GameEvents.Plant_RE:FireServer(
                    pos,
                    PlantSeed
                )
            end
        end)
    end
})

Tabs.Main:Section({ Title = "Sprinkler" })

local SprinklerEnabled = false
local SelectedSprinkler = "Basic Sprinkler"

local SprinklerList = {
    "Basic Sprinkler",
    "Advanced Sprinkler",
    "Godly Sprinkler",
    "Master Sprinkler",
    "Grandmaster Sprinkler"
}

local function GetPlayerCFrame()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.CFrame
        end
    end
    return nil
end

Tabs.Main:Dropdown({
    Title = "Select Sprinkler",
    Values = SprinklerList,
    Default = "Basic Sprinkler",
    Callback = function(Value)
        SelectedSprinkler = Value
    end
})

Tabs.Main:Toggle({
    Title = "Auto Place Sprinkler",
    Default = false,
    Callback = function(Value)
        SprinklerEnabled = Value

        task.spawn(function()
            while SprinklerEnabled do
                pcall(function()
                    local cf = GetPlayerCFrame()
                    if cf then
                        game:GetService("ReplicatedStorage").GameEvents.SprinklerService:FireServer(
                            "Create",
                            cf
                        )
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

Tabs.Main:Button({
    Title = "Place Sprinkler Once",
    Callback = function()
        pcall(function()
            local cf = GetPlayerCFrame()
            if cf then
                game:GetService("ReplicatedStorage").GameEvents.SprinklerService:FireServer(
                    "Create",
                    cf
                )
            end
        end)
    end
})

Tabs.Main:Section({ Title = "Eggs" })

local EggEnabled = false
local SelectedEgg = "Common Egg"

local EggList = {
    "Common Egg",
    "Uncommon Egg",
    "Rare Egg",
    "Legendary Egg",
    "Mythic Egg",
    "Bug Egg",
    "Jungle Egg"
}

local function GetPlayerPosition()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.Position
        end
    end
    return nil
end

Tabs.Main:Dropdown({
    Title = "Select Egg",
    Values = EggList,
    Default = "Common Egg",
    Callback = function(Value)
        SelectedEgg = Value
    end
})

Tabs.Main:Toggle({
    Title = "Auto Place Egg",
    Default = false,
    Callback = function(Value)
        EggEnabled = Value

        task.spawn(function()
            while EggEnabled do
                pcall(function()
                    local pos = GetPlayerPosition()
                    if pos then
                        game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer(
                            "CreateEgg",
                            pos
                        )
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

Tabs.Main:Button({
    Title = "Place Egg Once",
    Callback = function()
        pcall(function()
            local pos = GetPlayerPosition()
            if pos then
                game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer(
                    "CreateEgg",
                    pos
                )
            end
        end)
    end
})

Tabs.Main:Section({ Title = "Sell" })

local AutoSellEnabled = false

Tabs.Main:Toggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(Value)
        AutoSellEnabled = Value
        task.spawn(function()
            while AutoSellEnabled do
                pcall(function()
                    game:GetService("ReplicatedStorage").GameEvents.Sell_Item:FireServer()
                end)
                task.wait(1)
            end
        end)
    end
})

Tabs.Main:Button({
    Title = "Sell Once",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").GameEvents.Sell_Item:FireServer()
        end)
    end
})

Tabs.Main:Button({
    Title = "Sell All Inventory",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
        end)
    end
})

Tabs.Main:Section({ Title = "Mutation" })

local Event = game:GetService("ReplicatedStorage").GameEvents.PetMutationMachineService_RE
local DataService = require(game:GetService("ReplicatedStorage").Modules.DataService)
local PetsService = require(game:GetService("ReplicatedStorage").Modules.PetServices.PetsService)
local InventoryEnums = require(game:GetService("ReplicatedStorage").Data.EnumRegistry.InventoryServiceEnums)
local ItemTypeEnums = require(game:GetService("ReplicatedStorage").Data.EnumRegistry.ItemTypeEnums)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local autoMutationRunning = false

local function getFirstPetUUID()
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute(InventoryEnums.ITEM_TYPE) == ItemTypeEnums.Pet then
                local uuid = tool:GetAttribute(InventoryEnums.ITEM_UUID)
                if uuid then return uuid end
            end
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute(InventoryEnums.ITEM_TYPE) == ItemTypeEnums.Pet then
                local uuid = tool:GetAttribute(InventoryEnums.ITEM_UUID)
                if uuid then return uuid end
            end
        end
    end
    return nil
end

local function getMachineData()
    local data = DataService:GetData()
    if data then
        return data.PetMutationMachine
    end
end

local function equipPet(uuid)
    PetsService:EquipPet(LocalPlayer, uuid)
end

Tabs.Main:Button({
    Title = "Start Mutation",
    Callback = function()
        local machineData = getMachineData()
        if not machineData then return end
        if machineData.SubmittedPet and not machineData.IsRunning then
            Event:FireServer("StartMachine")
        end
    end
})

Tabs.Main:Button({
    Title = "Cancel Mutation",
    Callback = function()
        Event:FireServer("CancelMachine")
    end
})

Tabs.Main:Button({
    Title = "Claim Pet",
    Callback = function()
        local machineData = getMachineData()
        if machineData and machineData.PetReady then
            Event:FireServer("ClaimMutatedPet")
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Mutation",
    Default = false,
    Callback = function(Value)
        autoMutationRunning = Value
        if Value then
            task.spawn(function()
                while autoMutationRunning do
                    local machineData = getMachineData()
                    if machineData then
                        if machineData.PetReady then
                            Event:FireServer("ClaimMutatedPet")
                            task.wait(1)
                        elseif machineData.IsRunning or machineData.TimeLeft > 0 then
                            task.wait(1)
                        elseif machineData.SubmittedPet and not machineData.IsRunning then
                            Event:FireServer("StartMachine")
                            task.wait(1)
                        elseif not machineData.SubmittedPet then
                            local petUUID = getFirstPetUUID()
                            if petUUID then
                                equipPet(petUUID)
                                task.wait(0.5)
                                Event:FireServer("SubmitHeldPet")
                                task.wait(1)
                            else
                                task.wait(1)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})


Tabs.Event:Section({ Title = "Campfire" })

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SubmitEvent = ReplicatedStorage.GameEvents.SummerFire.Submit

Tabs.Event:Button({
    Title = "Submit Once",
    Callback = function()
        SubmitEvent:FireServer("Submit")
    end
})

Tabs.Event:Button({
    Title = "Submit All Fruits",
    Callback = function()
        SubmitEvent:FireServer("SubmitAll")
    end
})


Tabs.Shop:Section({ Title = "Purchase Seed" })

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BuySeedStockEvent = ReplicatedStorage.GameEvents.BuySeedStock

local usKeyMap = {
    ["Carrot"] = "Carrot",
    ["Strawberry"] = "Strawberry",
    ["Blueberry"] = "Blueberry",
    ["Buttercup"] = "Buttercup",
    ["Tomato"] = "Tomato",
    ["Corn"] = "Corn",
    ["Daffodil"] = "Daffodil",
    ["Watermelon"] = "Watermelon",
    ["Pumpkin"] = "Pumpkin",
    ["Apple"] = "Apple",
    ["Bamboo"] = "Bamboo",
    ["Coconut"] = "Coconut",
    ["Cactus"] = "Cactus",
    ["Dragon Fruit"] = "Dragon Fruit",
    ["Mango"] = "Mango",
    ["Grape"] = "Grape",
    ["Mushroom"] = "Mushroom",
    ["Pepper"] = "Pepper",
    ["Cacao"] = "Cacao",
    ["Sunflower"] = "Sunflower",
    ["Beantalk"] = "Beantalk",
    ["Ember Lily"] = "Ember Lily",
    ["Sugar Apple"] = "Sugar Apple",
    ["Burning Bud"] = "Burning Bud",
    ["Elder Strawberry"] = "Elder Strawberry",
    ["Romanesco"] = "Romanesco",
    ["Crimson"] = "Crimson",
    ["Zebrazinkle"] = "Zebrazinkle",
    ["Octobloom"] = "Octobloom",
    ["Alien Apple"] = "Alien Apple",
    ["Eggsnapper"] = "Eggsnapper"
}

local usNames = {
    "Carrot","Strawberry","Blueberry","Buttercup","Tomato","Corn","Daffodil","Watermelon",
    "Pumpkin","Apple","Bamboo","Coconut","Cactus","Dragon Fruit","Mango","Grape","Mushroom",
    "Pepper","Cacao","Sunflower","Beantalk","Ember Lily","Sugar Apple","Burning Bud",
    "Elder Strawberry","Romanesco","Crimson","Zebrazinkle","Octobloom","Alien Apple","Eggsnapper"
}

local selectedSeed = usNames[1]

Tabs.Shop:Dropdown({
    Title = "Select Seed",
    Values = usNames,
    Value = selectedSeed,
    Callback = function(v)
        selectedSeed = v
    end
})

Tabs.Shop:Button({
    Title = "Buy Seed",
    Callback = function()
        local key = usKeyMap[selectedSeed]
        if key then
            pcall(function()
                BuySeedStockEvent:FireServer("Shop", key)
            end)
        end
    end
})

Tabs.Shop:Section({ Title = "Purchase Gear" })

local BuyGearStockEvent = ReplicatedStorage.GameEvents.BuyGearStock

local ugKeyMap = {
    ["Watering Can"] = "Watering Can",
    ["Basic Sprinkler"] = "Basic Sprinkler",
    ["Advanced Sprinkler"] = "Advanced Sprinkler",
    ["Godly Sprinkler"] = "Godly Sprinkler",
    ["Master Sprinkler"] = "Master Sprinkler",
    ["Grandmaster Sprinkler"] = "Grandmaster Sprinkler",
    ["Trowel"] = "Trowel",
    ["Recall Wrench"] = "Recall Wrench",
    ["Medium Toy"] = "Medium Toy",
    ["Pet Name Reroller"] = "Pet Name Reroller",
    ["Pet Lead"] = "Pet Lead",
    ["Medium Treat"] = "Medium Treat",
    ["Magnifying Glass"] = "Magnifying Glass",
    ["Cleaning Spray"] = "Cleaning Spray",
    ["Cleansing Pet Shard"] = "Cleansing Pet Shard",
    ["Favorite Tool"] = "Favorite Tool",
    ["Harvest Tool"] = "Harvest Tool",
    ["Friendship Pot"] = "Friendship Pot",
    ["Levelup Lollipop"] = "Levelup Lollipop",
    ["Trading Ticket"] = "Trading Ticket"
}

local ugNames = {
    "Watering Can","Basic Sprinkler","Advanced Sprinkler","Godly Sprinkler","Master Sprinkler","Grandmaster Sprinkler","Trowel",
    "Recall Wrench","Medium Toy","Pet Name Reroller","Pet Lead","Medium Treat","Magnifying Glass","Cleaning Spray",
    "Cleansing Pet Shard","Favorite Tool","Harvest Tool","Friendship Pot","Levelup Lollipop","Trading Ticket"
}

local selectedGear = ugNames[1]

Tabs.Shop:Dropdown({
    Title = "Select Gear",
    Values = ugNames,
    Value = selectedGear,
    Callback = function(v)
        selectedGear = v
    end
})

Tabs.Shop:Button({
    Title = "Buy Gear",
    Callback = function()
        local key = ugKeyMap[selectedGear]
        if key then
            pcall(function()
                BuyGearStockEvent:FireServer(key)
            end)
        end
    end
})

Tabs.Shop:Section({ Title = "Purchase Pet" })

local BuyPetEggEvent = ReplicatedStorage.GameEvents.BuyPetEgg

local upKeyMap = {
    ["Common Egg"] = "Common Egg",
    ["Uncommon Egg"] = "Uncommon Egg",
    ["Rare Egg"] = "Rare Egg",
    ["Legendary Egg"] = "Legendary Egg",
    ["Mythic Egg"] = "Mythic Egg",
    ["Bug Egg"] = "Bug Egg",
    ["Jungle Egg"] = "Jungle Egg",
}

local upNames = {
    "Common Egg","Uncommon Egg","Rare Egg",
    "Legendary Egg","Mythic Egg","Bug Egg",
    "Jungle Egg"
}

local selectedPet = upNames[1]

Tabs.Shop:Dropdown({
    Title = "Select Pet Egg",
    Values = upNames,
    Value = selectedPet,
    Callback = function(v)
        selectedPet = v
    end
})

Tabs.Shop:Button({
    Title = "Buy Pet Egg",
    Callback = function()
        local key = upKeyMap[selectedPet]
        if key then
            pcall(function()
                BuyPetEggEvent:FireServer(key)
            end)
        end
    end
})


Tabs.Misc:Section({ Title = "ESP" })

local espFolder = Instance.new("Folder")
espFolder.Name = "PlantESP"
espFolder.Parent = workspace

local highlights = {}
local espEnabled = false
local selectedColor = "Green"
local selectedPlants = {}

local colorMap = {
	["Green"] = Color3.fromRGB(0, 255, 80),
	["Red"] = Color3.fromRGB(255, 50, 50),
	["Blue"] = Color3.fromRGB(50, 150, 255),
	["Yellow"] = Color3.fromRGB(255, 230, 0),
	["White"] = Color3.fromRGB(255, 255, 255),
}

local plantNames = {
	"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Buttercup",
	"Tomato", "Corn", "Daffodil", "Apple", "Chocolate Carrot",
	"Red Lollipop", "Blue Lollipop", "Nightshade", "Glowshroom", "Mint",
	"Rose", "Foxglove", "Crocus", "Delphinium", "Manuka Flower",
	"Lavender", "Nectarshade", "Peace Lily", "Wild Carrot", "Pear",
	"Horsetail", "Monoblooma", "Dezen", "Artichoke", "Spring Onion",
	"Turnip", "Parsley", "Bloodred Mushroom", "Orange Delight",
	"Horned Redrose", "Peppermint Pop"
}

local function isSelected(obj)
	return selectedPlants[obj.Name] == true
end

local function applyColor()
	local c = colorMap[selectedColor] or colorMap["Green"]
	for _, hl in pairs(highlights) do
		hl.FillColor = c
		hl.OutlineColor = c
	end
end

local function addESP(obj)
	if highlights[obj] then return end
	if not obj:IsA("Model") and not obj:IsA("BasePart") then return end

	local c = colorMap[selectedColor] or colorMap["Green"]
	local hl = Instance.new("Highlight")
	hl.FillColor = c
	hl.OutlineColor = c
	hl.FillTransparency = 0.5
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee = obj
	hl.Parent = espFolder

	highlights[obj] = hl

	obj.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			if highlights[obj] then
				highlights[obj]:Destroy()
				highlights[obj] = nil
			end
		end
	end)
end

local function removeESPByName(name)
	for obj, hl in pairs(highlights) do
		if obj.Name == name then
			hl:Destroy()
			highlights[obj] = nil
		end
	end
end

local function removeAllESP()
	for obj, hl in pairs(highlights) do
		hl:Destroy()
		highlights[obj] = nil
	end
end

local function scanWorkspace()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if isSelected(obj) then
			addESP(obj)
		end
	end
end

local function refreshESP()
	removeAllESP()
	if espEnabled then
		scanWorkspace()
	end
end

workspace.DescendantAdded:Connect(function(obj)
	if espEnabled and isSelected(obj) then
		addESP(obj)
	end
end)

Tabs.Misc:Toggle({
	Title = "ESP Plant",
	Default = false,
	Callback = function(value)
		espEnabled = value
		if espEnabled then
			scanWorkspace()
		else
			removeAllESP()
		end
	end
})

Tabs.Misc:Dropdown({
	Title = "ESP Color",
	Values = { "Green", "Red", "Blue", "Yellow", "White" },
	Value = "Green",
	Callback = function(value)
		selectedColor = value
		applyColor()
	end
})

Tabs.Misc:Dropdown({
	Title = "Select Plants",
	Values = plantNames,
	Value = {},
	Multi = true,
	Callback = function(value)
		selectedPlants = {}
		for _, name in ipairs(value) do
			selectedPlants[name] = true
		end
		refreshESP()
	end
})

Tabs.Misc:Section({ Title = "Players" })

local infJump = false
local noclip = false
local antiAFK = false
local afkConnection
local autoReconnect = false

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

Tabs.Misc:Section({ Title = "Performance" })

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

Tabs.Misc:Section({ Title = "Session" })

Tabs.Misc:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(state)
        antiAFK = state
        if antiAFK then
            local vu = game:GetService("VirtualUser")
            afkConnection = game.Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end
})

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


local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game.Players.LocalPlayer
local inputObj = ""

Tabs.Setting:Section({ Title = "Server" })

Tabs.Setting:Paragraph({
    Title = "Current Server",
    Desc = game.JobId
})

Tabs.Setting:Button({
    Title = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Setting:Button({
    Title = "Server Hop",
    Callback = function()
        local success, result = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet(
                    "https://games.roblox.com/v1/games/" ..
                    game.PlaceId ..
                    "/servers/Public?sortOrder=Asc&limit=100"
                )
            )
        end)
        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(
                        game.PlaceId,
                        server.id,
                        LocalPlayer
                    )
                    break
                end
            end
        end
    end
})

Tabs.Setting:Section({ Title = "Teleport" })

Tabs.Setting:Input({
    Title = "Target Server ID",
    Default = "",
    Placeholder = "Enter JobId...",
    MultiLine = false,
    Callback = function(input)
        inputObj = tostring(input)
    end
})

Tabs.Setting:Button({
    Title = "Teleport To JobId",
    Callback = function()
        if inputObj ~= "" then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    inputObj,
                    LocalPlayer
                )
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
