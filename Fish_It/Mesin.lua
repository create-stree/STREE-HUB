loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local player = game.Players.LocalPlayer
player:WaitForChild("PlayerGui")

local function GetRemote(folder, name)
    if typeof(folder) ~= "Instance" then return nil end
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj.Name == name then
            return obj
        end
    end
    return nil
end

local RPath = game:GetService("ReplicatedStorage")

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Fish It",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = true,
    },
})

Window:EditOpenButton({Enabled = false})

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local G2L = {}

G2L["ScreenGui_1"] = Instance.new("ScreenGui")
G2L["ScreenGui_1"].Parent = game:GetService("CoreGui")
G2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G2L["ScreenGui_1"].ResetOnSpawn = false
CollectionService:AddTag(G2L["ScreenGui_1"], "main")

G2L["ButtonRezise_2"] = Instance.new("ImageButton")
G2L["ButtonRezise_2"].Parent = G2L["ScreenGui_1"]
G2L["ButtonRezise_2"].BorderSizePixel = 0
G2L["ButtonRezise_2"].Draggable = true
G2L["ButtonRezise_2"].BackgroundColor3 = Color3.fromRGB(0, 255, 120)
G2L["ButtonRezise_2"].Image = "rbxassetid://123032091977400"
G2L["ButtonRezise_2"].Size = UDim2.new(0, 47, 0, 47)
G2L["ButtonRezise_2"].Position = UDim2.new(0.13, 0, 0.03, 0)
G2L["ButtonRezise_2"].Visible = true

local corner = Instance.new("UICorner", G2L["ButtonRezise_2"])
corner.CornerRadius = UDim.new(0, 8)

local neon = Instance.new("UIStroke", G2L["ButtonRezise_2"])
neon.Thickness = 2
neon.Color = Color3.fromRGB(0, 255, 120)
neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local windowVisible = true

G2L["ButtonRezise_2"].MouseButton1Click:Connect(function()
    if windowVisible then
        Window:Close()
    else
        Window:Open()
    end
    windowVisible = not windowVisible
end)

Window:Tag({
    Title = "v0.0.3.5",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Premium",
    Color = Color3.fromRGB(138, 43, 226),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab4 = Window:Tab({
	Title = "Exclusive",
	Icon = "star"
})

Tab4:Section({ 
	Title = "Webhook Fish Caught",
	Icon = "webhook",
	TextXAlignment = "Left",
	TextSize = 17 
})

Tab4:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local httpRequest = syn and syn.request or http and http.request or http_request or (fluxus and fluxus.request) or
    request
if not httpRequest then return end

local ItemUtility, Replion, DataService
local fishDB = {}
local rarityList = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET" }
local tierToRarity = {
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "SECRET"
}
local knownFishUUIDs = {}

pcall(function()
    ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
    Replion = require(ReplicatedStorage.Packages.Replion)
    DataService = Replion.Client:WaitReplion("Data")
end)

function buildFishDatabase()
    local RS = game:GetService("ReplicatedStorage")
    local itemsContainer = RS:WaitForChild("Items")
    if not itemsContainer then return end

    for _, itemModule in ipairs(itemsContainer:GetChildren()) do
        local success, itemData = pcall(require, itemModule)
        if success and type(itemData) == "table" and itemData.Data and itemData.Data.Type == "Fish" then
            local data = itemData.Data
            if data.Id and data.Name then
                fishDB[data.Id] = {
                    Name = data.Name,
                    Tier = data.Tier,
                    Icon = data.Icon,
                    SellPrice = itemData.SellPrice
                }
            end
        end
    end
end
function getInventoryFish()
    if not (DataService and ItemUtility) then return {} end
    local inventoryItems = DataService:GetExpect({ "Inventory", "Items" })
    local fishes = {}
    for _, v in pairs(inventoryItems) do
        local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if itemData and itemData.Data.Type == "Fish" then
            table.insert(fishes, { Id = v.Id, UUID = v.UUID, Metadata = v.Metadata })
        end
    end
    return fishes
end

function getPlayerCoins()
    if not DataService then return "N/A" end
    local success, coins = pcall(function() return DataService:Get("Coins") end)
    if success and coins then return string.format("%d", coins):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") end
    return "N/A"
end

function getThumbnailURL(assetString)
    local assetId = assetString:match("rbxassetid://(%d+)")
    if not assetId then return nil end
    local api = string.format("https://thumbnails.roblox.com/v1/assets?assetIds=%s&type=Asset&size=420x420&format=Png",
        assetId)
    local success, response = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    return success and response and response.data and response.data[1] and response.data[1].imageUrl
end

function sendTestWebhook()
    if not httpRequest or not _G.WebhookURL or not _G.WebhookURL:match("discord.com/api/webhooks") then
        WindUI:Notify({ Title = "Error", Content = "Webhook URL Empty" })
        return
    end

    local payload = {
        username = "StreeHub Webhook",
        avatar_url = "https://cdn.discordapp.com/attachments/1430527420468953159/1450326233844940904/1752815705447-1000034555-1.png?ex=6942210f&is=6940cf8f&hm=582f526e0391329af202628cfbb3d17780626252e107defd4a5421573d3b7b4b",
        embeds = {{
            title = "Test Webhook Connected",
            description = "Webhook connection successful!",
            color = 0x00FF00
        }}
    }

    pcall(function()
        httpRequest({
            Url = _G.WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

function sendNewFishWebhook(newlyCaughtFish)
    if not httpRequest or not _G.WebhookURL or not _G.WebhookURL:match("discord.com/api/webhooks") then return end

    local newFishDetails = fishDB[newlyCaughtFish.Id]
    if not newFishDetails then return end

    local newFishRarity = tierToRarity[newFishDetails.Tier] or "Unknown"
    if #_G.WebhookRarities > 0 and not table.find(_G.WebhookRarities, newFishRarity) then return end

    local fishWeight = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.Weight and string.format("%.2f Kg", newlyCaughtFish.Metadata.Weight)) or "N/A"
    local mutation   = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.VariantId and tostring(newlyCaughtFish.Metadata.VariantId)) or "None"
    local sellPrice  = (newFishDetails.SellPrice and ("$"..string.format("%d", newFishDetails.SellPrice):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "").." Coins")) or "N/A"
    local currentCoins = getPlayerCoins()

    local totalFishInInventory = #getInventoryFish()
    local backpackInfo = string.format("%d/4500", totalFishInInventory)

    local playerName = game.Players.LocalPlayer.Name

    local payload = {
        content = nil,
        embeds = {{
            title = "StreeHub Fish caught!",
            description = string.format("Congrats! **%s** You obtained new **%s** here for full detail fish :", playerName, newFishRarity),
            url = "https://discord.gg/jdmX43t5mY",
            color = 65280,
            fields = {
                { name = "Name Fish :",        value = "```\n"..newFishDetails.Name.."```" },
                { name = "Rarity :",           value = "```"..newFishRarity.."```" },
                { name = "Weight :",           value = "```"..fishWeight.."```" },
                { name = "Mutation :",         value = "```"..mutation.."```" },
                { name = "Sell Price :",       value = "```"..sellPrice.."```" },
                { name = "Backpack Counter :", value = "```"..backpackInfo.."```" },
                { name = "Current Coin :",     value = "```"..currentCoins.."```" },
            },
            footer = {
                text = "StreeHub Webhook",
                icon_url = "https://cdn.discordapp.com/attachments/1430527420468953159/1450326233844940904/1752815705447-1000034555-1.png?ex=6942210f&is=6940cf8f&hm=582f526e0391329af202628cfbb3d17780626252e107defd4a5421573d3b7b4b"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
            thumbnail = {
                url = getThumbnailURL(newFishDetails.Icon)
            }
        }},
        username = "StreeHub Webhook",
        avatar_url = "https://cdn.discordapp.com/attachments/1430527420468953159/1450326233844940904/1752815705447-1000034555-1.png?ex=6942210f&is=6940cf8f&hm=582f526e0391329af202628cfbb3d17780626252e107defd4a5421573d3b7b4b",
        attachments = {}
    }

    pcall(function()
        httpRequest({
            Url = _G.WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

local U = Tab4:Input({
    Title = "URL Webhook",
    Placeholder = "Paste your Discord Webhook URL here",
    Value = _G.WebhookURL or "",
    Callback = function(text)
        _G.WebhookURL = text
    end
})

local V = Tab4:Dropdown({
    Title = "Rarity Filter",
    Values = rarityList,
    Multi = true,
    AllowNone = true,
    Value = _G.WebhookRarities or {},
    Callback = function(selected_options)
        _G.WebhookRarities = selected_options
    end
})

local WU = Tab4:Toggle({
    Title = "Send Webhook",
    Value = _G.DetectNewFishActive or false,
    Callback = function(state)
        _G.DetectNewFishActive = state
    end
})

Tab4:Button({
    Title = "Test Webhook",
    Callback = sendTestWebhook
})

buildFishDatabase()

spawn( LPH_NO_VIRTUALIZE( function()
    local initialFishList = getInventoryFish()
    for _, fish in ipairs(initialFishList) do
        if fish and fish.UUID then
            knownFishUUIDs[fish.UUID] = true
        end
    end
end))

spawn( LPH_NO_VIRTUALIZE( function()
    while wait(0.1) do
        if _G.DetectNewFishActive then
            local currentFishList = getInventoryFish()
            for _, fish in ipairs(currentFishList) do
                if fish and fish.UUID and not knownFishUUIDs[fish.UUID] then
                    knownFishUUIDs[fish.UUID] = true
                    sendNewFishWebhook(fish)
                end
            end
        end
        wait(3)
    end
end))

local Section = Tab4:Section({
	Title = "Blantant Fishing",
	Icon = "fish",
	TextXAlignment = "Left",
	TextSize = 17
})

Tab4:Divider()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Config = {
    blantant = false,
    cancel = 100,
    complete = 100
}

local Net = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local charge
local requestminigame
local fishingcomplete
local equiprod
local cancelinput
local ReplicateTextEffect
local BaitSpawned
local BaitDestroyed

pcall(function()
    charge               = Net:WaitForChild("RF/ChargeFishingRod")
    requestminigame       = Net:WaitForChild("RF/RequestFishingMinigameStarted")
    fishingcomplete       = Net:WaitForChild("RE/FishingCompleted")
    equiprod              = Net:WaitForChild("RE/EquipToolFromHotbar")
    cancelinput           = Net:WaitForChild("RF/CancelFishingInputs")
    ReplicateTextEffect   = Net:WaitForChild("RE/ReplicateTextEffect")
    BaitSpawned           = Net:WaitForChild("RE/BaitSpawned")
    BaitDestroyed         = Net:WaitForChild("RE/BaitDestroyed")
end)

local mainThread
local equipThread

local exclaimDetected = false
local bait = 0

ReplicateTextEffect.OnClientEvent:Connect(function(data)
    local char = LocalPlayer.Character
    if not char or not data.TextData or not data.TextData.AttachTo then return end

    if data.TextData.AttachTo:IsDescendantOf(char)
        and data.TextData.Text == "!" then
        exclaimDetected = true
    end
end)

if BaitSpawned then
    BaitSpawned.OnClientEvent:Connect(function(bobber, position, owner)
        if owner and owner ~= LocalPlayer then return end
        bait = 1
    end)
end

if BaitDestroyed then
    BaitDestroyed.OnClientEvent:Connect(function(bobber)
        bait = 0
    end)
end

local function StartCast()
    task.spawn(function()
        pcall(function()
            local ok = cancelinput:InvokeServer()
            if not ok then
                repeat ok = cancelinput:InvokeServer() until ok
            end

            local charged = charge:InvokeServer(math.huge)
            if not charged then
                repeat charged = charge:InvokeServer(math.huge) until charged
            end

            requestminigame:InvokeServer(1, 0.05, 1731873.1873)
        end)
    end)

    task.spawn(function()
        exclaimDetected = false

        local timeout = 20
        local timer = 0

        while Config.blantant and timer < timeout do
            if exclaimDetected and bait == 0 then
                break
            end
            task.wait(0.01)
            timer += 0.1
        end

        if not Config.blantant then return end
        if not (exclaimDetected and bait == 0) then return end

        task.wait(Config.complete)

        if Config.blantant then
            pcall(fishingcomplete.FireServer, fishingcomplete)
        end
    end)
end

local function MainLoop()
    equipThread = task.spawn(function()
        while Config.blantant do
            pcall(equiprod.FireServer, equiprod, 1)
            task.wait(1.5)
        end
    end)

    while Config.blantant do
        StartCast()
        task.wait(Config.cancel)
        if not Config.blantant then break end
        task.wait(0.1)
    end
end

local function Toggle(state)
    Config.blantant = state

    if state then
        if mainThread then task.cancel(mainThread) end
        if equipThread then task.cancel(equipThread) end
        mainThread = task.spawn(MainLoop)
    else
        if mainThread then task.cancel(mainThread) end
        if equipThread then task.cancel(equipThread) end
        mainThread = nil
        equipThread = nil
        bait = 0
        pcall(cancelinput.InvokeServer, cancelinput)
    end
end

Tab4:Toggle({
    Title = "Blantant",
    Value = Config.blantant,
    Callback = Toggle
})

Tab4:Input({
    Title = "Delay Bait",
    Default = tostring(Config.cancel),
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.cancel = n
        end
    end
})

Tab4:Input({
    Title = "Delay Reel",
    Default = tostring(Config.complete),
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.complete = n
        end
    end
})

local Section = Tab4:Section({
	Title = "Premium",
	Icon = "gem",
	TextXAlignment = "Left",
	TextSize = 17
})

RE = {
    FavoriteItem = Net:FindFirstChild("RE/FavoriteItem"),
    FavoriteStateChanged = Net:FindFirstChild("RE/FavoriteStateChanged"),
}

Tab4:Section({
    Title = "Auto Favorite",
    Icon = "star",
    TextXAlignment = "Left",
    TextSize = 17,
})

local REFishCaught = RE.FishCaught or Net:WaitForChild("RE/FishCaught")
local REFishingCompleted = RE.FishingCompleted or Net:WaitForChild("RE/FishingCompleted")

if REFishCaught then
    REFishCaught.OnClientEvent:Connect(function()
        st.canFish = true
    end)
end

if REFishingCompleted then
    REFishingCompleted.OnClientEvent:Connect(function()
        st.canFish = true
    end)
end

tierToRarity = {
    [1] = "Uncommon",
    [2] = "Common",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "Secret"
}

Items = ReplicatedStorage:WaitForChild("Items")

fishNames = {}
for _, module in ipairs(Items:GetChildren()) do
    if module:IsA("ModuleScript") then
        local ok, data = pcall(require, module)
        if ok and data.Data and data.Data.Type == "Fish" then
            table.insert(fishNames, data.Data.Name)
        end
    end
end
table.sort(fishNames)

local favState, selectedName, selectedRarity = {}, {}, {}

if RE.FavoriteStateChanged then
    RE.FavoriteStateChanged.OnClientEvent:Connect(function(uuid, fav)
        if uuid then favState[uuid] = fav end
    end)
end

local function checkAndFavorite(item)
    if not st.autoFavEnabled then return end
    local info = ItemUtility.GetItemDataFromItemType("Items", item.Id)
    if not info or info.Data.Type ~= "Fish" then return end

    local rarity = tierToRarity[info.Data.Tier]
    local nameMatches = table.find(selectedName, info.Data.Name)
    local rarityMatches = table.find(selectedRarity, rarity)
    local isFav = favState[item.UUID] or item.Favorited or false
    local shouldFav = (nameMatches or rarityMatches) and not isFav

    if shouldFav and RE.FavoriteItem then
        RE.FavoriteItem:FireServer(item.UUID, true)
        favState[item.UUID] = true
    end
end

local function scanInventory()
    if not st.autoFavEnabled then return end
    local inv = Data:GetExpect({ "Inventory", "Items" })
    if not inv then return end
    for _, item in ipairs(inv) do checkAndFavorite(item) end
end

Data:OnChange({ "Inventory", "Items" }, function()
    if st.autoFavEnabled then scanInventory() end
end)

function getPlayerNames()
    local names = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

Tab4:Dropdown({
    Title = "Favorite by Name",
    Values = #fishNames > 0 and fishNames or { "No Data" },
    Multi = true,
    SearchBarEnabled = true,
    AllowNone = true,
    Default = {},
    Callback = function(opts)
        selectedName = opts or {}
        if st.autoFavEnabled then scanInventory() end
    end
})

Tab4:Dropdown({
    Title = "Favorite by Rarity",
    Values = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
    Multi = true,
    SearchBarEnabled = true,
    AllowNone = true,
    Default = {},
    Callback = function(opts)
        selectedRarity = opts or {}
        if st.autoFavEnabled then scanInventory() end
    end
})

Tab4:Toggle({
    Title = "Start Auto Favorite",
    Default = false,
    Callback = function(state)
        st.autoFavEnabled = state
        if st.autoFavEnabled then scanInventory() end
    end
})

Tab4:Button({
    Title = "Unfavorite All",
    Callback = function()
        local inv = Data:GetExpect({ "Inventory", "Items" })
        if not inv then return end
        for _, item in ipairs(inv) do
            if (item.Favorited or favState[item.UUID]) and RE.FavoriteItem then
                RE.FavoriteItem:FireServer(item.UUID, false)
                favState[item.UUID] = false
            end
        end
    end
})

Tab4:Divider()

local VFX = require(game:GetService("ReplicatedStorage").Controllers.VFXController)

local ORI = {
    H = VFX.Handle,
    P = VFX.RenderAtPoint,
    I = VFX.RenderInstance
}

Tab4:Toggle({
    Title = "Remove Skin Effect",
    Desc = "Remove Your Skin Effect",
    Default = false,
    Callback = function(state)
        if state then
            VFX.Handle = function() end
            VFX.RenderAtPoint = function() end
            VFX.RenderInstance = function() end

            local f = workspace:FindFirstChild("CosmeticFolder")
            if f then
                pcall(f.ClearAllChildren, f)
            end

            WindUI:Notify({
                Title = "Skin Effect Disabled",
                Duration = 3,
                Icon = "eye-off"
            })
        else
            VFX.Handle = ORI.H
            VFX.RenderAtPoint = ORI.P
            VFX.RenderInstance = ORI.I

            WindUI:Notify({
                Title = "Skin Effect Enabled",
                Duration = 3,
                Icon = "eye"
            })
        end
    end
})

local Section = Tab4:Section({
	Title = "Gift",
	Icon = "gift",
	TextXAlignment = "Left",
	TextSize = 17
})

Tab4:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GiftingController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("GiftingController"))

Tab4:Button({
    Title = "Gift Skin Soul Scythe",
    Locked = false,
    Callback = function()
        if GiftingController and GiftingController.Open then
            GiftingController:Open("Soul Scythe")

            WindUI:Notify({
                Title = "Gift Open",
                Content = "Soul Scythe Gift Opened Successfully",
                Duration = 3,
                Icon = "check"
            })
        else
            WindUI:Notify({
                Title = "Failed!!",
                Content = "Patched",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

local Section = Tab4:Section({
	Title = "Totem",
	Icon = "atom",
	TextXAlignment = "Left",
	TextSize = 17
})

Tab4:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Net = ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
local EquipItem = Net:FindFirstChild("RE/EquipItem")
local SpawnTotem = Net:FindFirstChild("RE/SpawnTotem")

_G.AutoSpawnTotem = false
_G.SelectedTotem = "Lucky"
_G.TotemUUID = nil

local TotemDisplay = {
	"Lucky",
	"Mutation",
	"Shiny"
}

local function findTotemsFolder()
    for _, v in pairs(LocalPlayer:GetChildren()) do
        if string.lower(v.Name) == "totems" then
            return v
        end
    end
    return nil
end

local function findUUIDFromGame(selected)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") then
            local n = string.lower(v.Name)
            if string.find(n, "lucky") or string.find(n, "mutation") or string.find(n, "shiny") then
                if string.find(n, string.lower(selected)) then
                    local uuid = v:FindFirstChild("ItemId") or v:FindFirstChild("ItemUUID")
                    if uuid and uuid:IsA("ValueBase") then
                        return uuid.Value
                    end
                end
            end
        end
    end
    return nil
end

local function getUUIDFromInventory(selected)
    local folder = findTotemsFolder()
    if not folder then return nil end
    for _, v in pairs(folder:GetDescendants()) do
        if v:IsA("ValueBase") and string.lower(v.Name) == "name" then
            if string.find(string.lower(tostring(v.Value)), string.lower(selected)) then
                local uuid = v.Parent:FindFirstChild("ItemId") or v.Parent:FindFirstChild("ItemUUID")
                if uuid and uuid:IsA("ValueBase") then
                    return uuid.Value
                end
            end
        end
    end
    return nil
end

Tab4:Dropdown({
    Title = "Select Totem",
    Desc = "Choose which totem to spawn",
    Values = TotemDisplay,
    Value = "Lucky",
    Callback = function(option)
        _G.SelectedTotem = option
        _G.TotemUUID = getUUIDFromInventory(option) or findUUIDFromGame(option)
    end
})

Tab4:Toggle({
    Title = "Auto Spawn Totem",
    Desc = "Equip & spawn selected totem",
    Value = false,
    Callback = function(state)
        _G.AutoSpawnTotem = state
        if not state then return end
        task.spawn(function()
            while _G.AutoSpawnTotem do
                task.wait(1)
                local uuid = _G.TotemUUID or getUUIDFromInventory(_G.SelectedTotem) or findUUIDFromGame(_G.SelectedTotem)
                if uuid then
                    _G.TotemUUID = uuid
                    pcall(function()
                        EquipItem:FireServer(uuid, "Totems")
                        task.wait(0.2)
                        SpawnTotem:FireServer(uuid)
                    end)
                end
            end
        end)
    end
})

local Tab5 = Window:Tab({
    Title = "Shop",
    Icon = "badge-dollar-sign",
})

Tab5:Section({ 
    Title = "Buy Rod",
    Icon = "shrimp",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]

local rods = {
    ["Luck Rod"] = 79,
    ["Carbon Rod"] = 76,
    ["Grass Rod"] = 85,
    ["Demascus Rod"] = 77,
    ["Ice Rod"] = 78,
    ["Lucky Rod"] = 4,
    ["Midnight Rod"] = 80,
    ["Steampunk Rod"] = 6,
    ["Chrome Rod"] = 7,
    ["Astral Rod"] = 5,
    ["Ares Rod"] = 126,
    ["Angler Rod"] = 168,
    ["Bamboo Rod"] = 258
}

local rodNames = {
    "Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)", "Demascus Rod (3k Coins)",
    "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)", "Midnight Rod (50k Coins)", "Steampunk Rod (215k Coins)",
    "Chrome Rod (437k Coins)", "Astral Rod (1M Coins)", "Ares Rod (3M Coins)", "Angler Rod (8M Coins)",
    "Bamboo Rod (12M Coins)"
}

local rodKeyMap = {
    ["Luck Rod (350 Coins)"] = "Luck Rod",
    ["Carbon Rod (900 Coins)"] = "Carbon Rod",
    ["Grass Rod (1.5k Coins)"] = "Grass Rod",
    ["Demascus Rod (3k Coins)"] = "Demascus Rod",
    ["Ice Rod (5k Coins)"] = "Ice Rod",
    ["Lucky Rod (15k Coins)"] = "Lucky Rod",
    ["Midnight Rod (50k Coins)"] = "Midnight Rod",
    ["Steampunk Rod (215k Coins)"] = "Steampunk Rod",
    ["Chrome Rod (437k Coins)"] = "Chrome Rod",
    ["Astral Rod (1M Coins)"] = "Astral Rod",
    ["Ares Rod (3M Coins)"] = "Ares Rod",
    ["Angler Rod (8M Coins)"] = "Angler Rod",
    ["Bamboo Rod (12M Coins)"] = "Bamboo Rod"
}

local selectedRod = rodNames[1]

Tab5:Dropdown({
    Title = "Select Rod",
    Values = rodNames,
    Value = selectedRod,
    Callback = function(value)
        selectedRod = value
        WindUI:Notify({Title="Rod Selected", Content=value, Duration=3})
    end
})

Tab5:Button({
    Title="Buy Rod",
    Callback=function()
        local key = rodKeyMap[selectedRod]
        if key and rods[key] then
            local success, err = pcall(function()
                RFPurchaseFishingRod:InvokeServer(rods[key])
            end)
            if success then
                WindUI:Notify({Title="Rod Purchase", Content="Purchased "..selectedRod, Duration=3})
            else
                WindUI:Notify({Title="Rod Purchase Error", Content=tostring(err), Duration=5})
            end
        end
    end
})

Tab5:Section({
    Title = "Buy Baits",
    Icon = "compass",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]  

local baits = {
    ["TopWater Bait"] = 10,
    ["Lucky Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Chroma Bait"] = 6,
    ["Dark Mater Bait"] = 8,
    ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16,
    ["Floral Bait"] = 20,
}

local baitNames = {  
    "Luck Bait (1k Coins)", "Midnight Bait (3k Coins)", "Nature Bait (83.5k Coins)",  
    "Chroma Bait (290k Coins)", "Dark Matter Bait (630k Coins)", "Corrupt Bait (1.15M Coins)",  
    "Aether Bait (3.7M Coins)", "Floral Bait (4M Coins)"  
}  

local baitKeyMap = {  
    ["Luck Bait (1k Coins)"] = "Luck Bait",  
    ["Midnight Bait (3k Coins)"] = "Midnight Bait",  
    ["Nature Bait (83.5k Coins)"] = "Nature Bait",  
    ["Chroma Bait (290k Coins)"] = "Chroma Bait",  
    ["Dark Matter Bait (630k Coins)"] = "Dark Matter Bait",  
    ["Corrupt Bait (1.15M Coins)"] = "Corrupt Bait",  
    ["Aether Bait (3.7M Coins)"] = "Aether Bait",  
    ["Floral Bait (4M Coins)"] = "Floral Bait"  
}  

local selectedBait = baitNames[1]  

Tab5:Dropdown({  
    Title = "Select Bait",  
    Values = baitNames,  
    Value = selectedBait,  
    Callback = function(value)  
        selectedBait = value  
    end  
})  

Tab5:Button({  
    Title = "Buy Bait",  
    Callback = function()  
        local key = baitKeyMap[selectedBait]  
        if key and baits[key] then  
            local success, err = pcall(function()  
                RFPurchaseBait:InvokeServer(baits[key])  
            end)  
            if success then  
                WindUI:Notify({Title = "Bait Purchase", Content = "Purchased " .. selectedBait, Duration = 3})  
            else  
                WindUI:Notify({Title = "Bait Purchase Error", Content = tostring(err), Duration = 5})  
            end  
        end  
    end  
})

Tab5:Section({ 
    Title = "Buy Weathers",
    Icon = "shrimp",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]

local weatherKeyMap = {
    ["Wind (10k Coins)"] = "Wind",
    ["Snow (15k Coins)"] = "Snow",
    ["Cloudy (20k Coins)"] = "Cloudy",
    ["Storm (35k Coins)"] = "Storm",
    ["Radiant (50k Coins)"] = "Radiant",
    ["Shark Hunt (300k Coins)"] = "Shark Hunt"
}

local weatherNames = {
    "Wind (10k Coins)", "Snow (15k Coins)", "Cloudy (20k Coins)",
    "Storm (35k Coins)", "Radiant (50k Coins)", "Shark Hunt (300k Coins)"
}

local selectedWeathers = {}
local autoBuyEnabled = false
local buyDelay = 540

Tab5:Dropdown({
    Title = "Select Weather",
    Values = weatherNames,
    Multi = true,
    Callback = function(values)
        selectedWeathers = values
    end
})

Tab5:Input({
    Title = "Buy Delay (minutes)",
    Placeholder = "9",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            buyDelay = num * 60
        end
    end
})

local function startAutoBuy()
    task.spawn(function()
        while autoBuyEnabled do
            for _, displayName in ipairs(selectedWeathers) do
                local key = weatherKeyMap[displayName]
                if key then
                    local success, err = pcall(function()
                        RFPurchaseWeatherEvent:InvokeServer(key)
                    end)
                    if success then
                        WindUI:Notify({
                            Title = "Weather Purchased",
                            Content = displayName .. " berhasil dibeli",
                            Duration = 2
                        })
                    else
                        warn("Error buying weather:", err)
                    end
                end
            end
            task.wait(buyDelay)
        end
    end)
end

Tab5:Toggle({
    Title = "Buy Weather",
    Value = false,
    Callback = function(state)
        autoBuyEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Buy",
                Content = "Enabled (Beli setiap " .. (buyDelay / 60) .. " menit)",
                Duration = 2
            })
            startAutoBuy()
        else
            WindUI:Notify({
                Title = "Auto Buy",
                Content = "Disabled",
                Duration = 2
            })
        end
    end
})

local Tab6 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

Tab6:Section({ 
    Title = "Island",
    Icon = "tree-palm",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab6:Divider()

local IslandLocations = {
    ["Ancient Jungle"] = Vector3.new(1518, 1, -186),
	["Christmas Island"] = Vector3.new(708.17, 16.08, 1567.35),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Crater Island"] = Vector3.new(997, 1, 5012),
    ["Crystal Cavern"] = Vector3.new(-1841, -456, 7186),
    ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
	["Enchant2"] = Vector3.new(1480, 126, -585),
    ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
    ["Fisherman Island"] = Vector3.new(-175, 3, 2772),
    ["Kohana"] = Vector3.new(-603, 3, 719),
    ["Lost Isle"] = Vector3.new(-3643, 1, -1061),
    ["Sysyphus Statue"] = Vector3.new(-3783.26807, -135.073914, -949.946289),
    ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
    ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
}

local SelectedIsland = nil

local IslandDropdown = Tab6:Dropdown({
    Title = "Select Island",
    Values = (function()
        local keys = {}
        for name in pairs(IslandLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedIsland = Value
    end
})

Tab6:Button({
    Title = "Teleport to Island",
    Callback = function()
        if SelectedIsland and IslandLocations[SelectedIsland] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(IslandLocations[SelectedIsland])
        end
    end
})

Tab6:Section({ 
    Title = "Fishing Spot",
    Icon = "spotlight",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab6:Divider()

local FishingLocations = {
	["Actient Ruin"] = Vector3.new(6046.67, -588.61, 4608.87),
	["Christmas Cave"] = Vector3.new(538.17, -580.58, 8898.02),
	["Christmas Lake"] = Vector3.new(1136.29, 23.72, 1562.07),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Enchant2"] = Vector3.new(1480, 126, -585),
    ["Kohana"] = Vector3.new(-603, 3, 719),
    ["Levers 1"] = Vector3.new(1475, 4, -847),
    ["Levers 2"] = Vector3.new(882, 5, -321),
    ["levers 3"] = Vector3.new(1425, 6,126),
    ["levers 4"] = Vector3.new(1837, 4, -309),
    ["Sacred Temple"] = Vector3.new(1475, -22, -632),
    ["Sysyphus Statue"] = Vector3.new(-3693,-136, -1045),
    ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
    ["Underground Cellar"] = Vector3.new(2135, -92, -695),
    ["Volcano"] = Vector3.new(-632, 55, 197),
}

local SelectedFishing = nil

Tab6:Dropdown({
    Title = "Select Spot",
    Values = (function()
        local keys = {}
        for name in pairs(FishingLocations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedFishing = Value
    end
})

Tab6:Button({
    Title = "Teleport to Fishing Spot",
    Callback = function()
        if SelectedFishing and FishingLocations[SelectedFishing] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(FishingLocations[SelectedFishing])
        end
    end
})

Tab6:Section({
    Title = "Location NPC",
    Icon = "bot",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab6:Divider()

local NPC_Locations = {
    ["Alex"] = Vector3.new(43,17,2876),
    ["Aura kid"] = Vector3.new(70,17,2835),
    ["Billy Bob"] = Vector3.new(84,17,2876),
    ["Boat Expert"] = Vector3.new(32,9,2789),
    ["Esoteric Gatekeeper"] = Vector3.new(2101,-30,1350),
    ["Jeffery"] = Vector3.new(-2771,4,2132),
    ["Joe"] = Vector3.new(144,20,2856),
    ["Jones"] = Vector3.new(-671,16,596),
    ["Lava Fisherman"] = Vector3.new(-593,59,130),
    ["McBoatson"] = Vector3.new(-623,3,719),
    ["Ram"] = Vector3.new(-2838,47,1962),
    ["Ron"] = Vector3.new(-48,17,2856),
    ["Scott"] = Vector3.new(-19,9,2709),
    ["Scientist"] = Vector3.new(-6,17,2881),
    ["Seth"] = Vector3.new(107,17,2877),
    ["Silly Fisherman"] = Vector3.new(97,9,2694),
    ["Tim"] = Vector3.new(-604,16,609),
}

local SelectedNPC = nil

Tab6:Dropdown({
    Title = "Select NPC",
    Values = (function()
        local keys = {}
        for name in pairs(NPC_Locations) do
            table.insert(keys, name)
        end
        table.sort(keys)
        return keys
    end)(),
    Callback = function(Value)
        SelectedNPC = Value
    end
})

Tab6:Button({
    Title = "Teleport to NPC",
    Callback = function()
        if SelectedNPC and NPC_Locations[SelectedNPC] and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(NPC_Locations[SelectedNPC])
        end
    end
})

Tab6:Section({
    Title = "Teleport Player",
    Icon = "person-standing",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab6:Divider()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function GetPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

local SelectedPlayer = nil
local Dropdown

Dropdown = Tab6:Dropdown({
    Title = "List Player",
    Values = GetPlayerList(),
    Value = GetPlayerList()[1],
    Callback = function(option)
        SelectedPlayer = option
    end
})

Tab6:Button({
    Title = "Teleport to Player (Target)",
    Locked = false,
    Callback = function()
        if not SelectedPlayer then
            return
        end
        local target = Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame =
                target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

Tab6:Button({
    Title = "Refresh Player List",
    Locked = false,
    Callback = function()
        local newList = GetPlayerList()

        if Dropdown.SetValues then
            Dropdown:SetValues(newList)
        elseif Dropdown.Refresh then
            Dropdown:Refresh(newList)
        elseif Dropdown.Update then
            Dropdown:Update(newList)
        end

        if newList[1] then
            SelectedPlayer = newList[1]
            if Dropdown.Set then
                Dropdown:Set(newList[1])
            end
        end
    end
})

Tab6:Section({
    Title = "Event Teleporter",
    Icon = "calendar",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab6:Divider()

local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
	character = c
	hrp = c:WaitForChild("HumanoidRootPart")
end)

local megCheckRadius = 150

local autoEventTPEnabled = false
local selectedEvents = {}
local createdEventPlatform = nil

local eventData = {
	["Worm Hunt"] = {
		TargetName = "Model",
		Locations = {
			Vector3.new(2190.85, -1.4, 97.575), 
			Vector3.new(-2450.679, -1.4, 139.731), 
			Vector3.new(-267.479, -1.4, 5188.531),
			Vector3.new(-327, -1.4, 2422)
		},
		PlatformY = 107,
		Priority = 1,
		Icon = "fish"
	},
	["Megalodon Hunt"] = {
		TargetName = "Megalodon Hunt",
		Locations = {
			Vector3.new(-1076.3, -1.4, 1676.2),
			Vector3.new(-1191.8, -1.4, 3597.3),
			Vector3.new(412.7, -1.4, 4134.4),
		},
		PlatformY = 107,
		Priority = 2,
		Icon = "anchor"
	},
	["Ghost Shark Hunt"] = {
		TargetName = "Ghost Shark Hunt",
		Locations = {
			Vector3.new(489.559, -1.35, 25.406), 
			Vector3.new(-1358.216, -1.35, 4100.556), 
			Vector3.new(627.859, -1.35, 3798.081)
		},
		PlatformY = 107,
		Priority = 3,
		Icon = "fish"
	},
	["Shark Hunt"] = {
		TargetName = "Shark Hunt",
		Locations = {
			Vector3.new(1.65, -1.35, 2095.725),
			Vector3.new(1369.95, -1.35, 930.125),
			Vector3.new(-1585.5, -1.35, 1242.875),
			Vector3.new(-1896.8, -1.35, 2634.375)
		},
		PlatformY = 107,
		Priority = 4,
		Icon = "fish"
	},
}

local eventNames = {}
for name in pairs(eventData) do
	table.insert(eventNames, name)
end

local function destroyEventPlatform()
	if createdEventPlatform and createdEventPlatform.Parent then
		createdEventPlatform:Destroy()
		createdEventPlatform = nil
	end
end

local function createAndTeleportToPlatform(targetPos, y)
	destroyEventPlatform()

	local platform = Instance.new("Part")
	platform.Size = Vector3.new(5, 1, 5)
	platform.Position = Vector3.new(targetPos.X, y, targetPos.Z)
	platform.Anchored = true
	platform.Transparency = 1
	platform.CanCollide = true
	platform.Name = "EventPlatform"
	platform.Parent = Workspace
	createdEventPlatform = platform

	hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 3, 0))
end

local function runMultiEventTP()
	while autoEventTPEnabled do
		local sorted = {}
		for _, e in ipairs(selectedEvents) do
			if eventData[e] then
				table.insert(sorted, eventData[e])
			end
		end
		table.sort(sorted, function(a, b) return a.Priority < b.Priority end)

		for _, config in ipairs(sorted) do
			local foundTarget, foundPos = nil, nil

			if config.TargetName == "Model" then
				local menuRings = Workspace:FindFirstChild("!!! MENU RINGS")
				if menuRings then
					for _, props in ipairs(menuRings:GetChildren()) do
						if props.Name == "Props" then
							local model = props:FindFirstChild("Model")
							if model and model.PrimaryPart then
								for _, loc in ipairs(config.Locations) do
									if (model.PrimaryPart.Position - loc).Magnitude <= megCheckRadius then
										foundTarget = model
										foundPos = model.PrimaryPart.Position
										break
									end
								end
							end
						end
						if foundTarget then break end
					end
				end
			else
				for _, loc in ipairs(config.Locations) do
					for _, d in ipairs(Workspace:GetDescendants()) do
						if d.Name == config.TargetName then
							local pos = d:IsA("BasePart") and d.Position or (d.PrimaryPart and d.PrimaryPart.Position)
							if pos and (pos - loc).Magnitude <= megCheckRadius then
								foundTarget = d
								foundPos = pos
								break
							end
						end
					end
					if foundTarget then break end
				end
			end
			if foundTarget and foundPos then
				createAndTeleportToPlatform(foundPos, config.PlatformY)
			end
		end
		task.wait(0.05)
	end
	destroyEventPlatform()
end

Tab6:Dropdown({
	Title = "Select Events",
	Values = eventNames,
	Multi = true,
	AllowNone = true,
	Callback = function(values)
		selectedEvents = values
	end
})

Tab6:Toggle({
	Title = "Auto Event",
	Icon = false,
	Type = false,
	Value = false,
	Callback = function(state)
		autoEventTPEnabled = state
		if state then
			task.spawn(runMultiEventTP)
		end
	end
})

local Tab7 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

Tab7:Section({ 
    Title = "Character",
    Icon = "square-user",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab7:Divider()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local function getOverhead(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    return hrp:WaitForChild("Overhead")
end

local overhead = getOverhead(Character)
local header = overhead.Content.Header
local levelLabel = overhead.LevelContainer.Label

local defaultHeader = header.Text
local defaultLevel = levelLabel.Text
local customHeader = defaultHeader
local customLevel = defaultLevel

local keepHidden = false
local rgbThread = nil

Tab7:Input({
    Title = "Hide Name",
    Placeholder = "Input Name",
    Default = defaultHeader,
    Callback = function(value)
        customHeader = value
        if keepHidden then
            header.Text = customHeader
        end
    end
})

Tab7:Toggle({
    Title = "Hide Identity",
    Default = false,
    Callback = function(state)
        keepHidden = state
        if state then
            header.Text = customHeader
        end
    end
})

Tab7:Section({ 
    Title = "UI",
    Icon = "scan-eye",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab7:Divider()

local stopAnimConnections = {}

local function setGameAnimationsEnabled(state)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    for _, conn in pairs(stopAnimConnections) do
        conn:Disconnect()
    end
    stopAnimConnections = {}
    if state then
        for _, track in ipairs(humanoid:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
        local conn = humanoid:FindFirstChildOfClass("Animator").AnimationPlayed:Connect(function(track)
            task.defer(function()
                track:Stop(0)
            end)
        end)
        table.insert(stopAnimConnections, conn)
        WindUI:Notify({
            Title = "Animation Disabled",
            Content = "All animations from the game have been disabled..",
            Duration = 4,
            Icon = "pause-circle"
        })
    else
        for _, conn in pairs(stopAnimConnections) do
            conn:Disconnect()
        end
        stopAnimConnections = {}
        WindUI:Notify({
            Title = "Animation Enabled",
            Content = "Animations from the game are reactivated.",
            Duration = 4,
            Icon = "play-circle"
        })
    end
end

Tab7:Toggle({
    Title = "No Animation",
    Desc = "Stop all animations from the game.",
    Value = false,
    Callback = function(v)
        setGameAnimationsEnabled(v)
	end
})

local RunService = game:GetService("RunService")
local DisableNotificationConnection

Tab7:Toggle({
    Title = "Disable Notify",
    Value = false,
    Icon = "slash",
    Callback = function(state)
        local PlayerGui = player:WaitForChild("PlayerGui")
        local SmallNotification = PlayerGui:FindFirstChild("Small Notification")

        if not SmallNotification then
            SmallNotification = PlayerGui:WaitForChild("Small Notification", 5)
            if not SmallNotification then
                WindUI:Notify({ Title = "Error", Duration = 3, Icon = "x" })
                return
            end
        end

        if state then
            DisableNotificationConnection = RunService.RenderStepped:Connect(function()
                SmallNotification.Enabled = false
            end)

            WindUI:Notify({
                Title = "Pop-up Diblokir",
                Duration = 3,
                Icon = "check"
            })
        else
            if DisableNotificationConnection then
                DisableNotificationConnection:Disconnect()
                DisableNotificationConnection = nil
            end

            SmallNotification.Enabled = true
				
            WindUI:Notify({
                Title = "Pop-up Diaktifkan",
                Content = "Notifikasi kembali normal.",
                Duration = 3,
                Icon = "x"
            })
        end
    end
})

Tab7:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle 24 hours",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        local Players = game:GetService("Players")

        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(50)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(0,0))
                    end)
                end
            end)

            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(300)
                    pcall(function()
                        Players.LocalPlayer.Idled:Fire()
                    end)
                end
            end)
        else
            _G.AntiAFK = false
        end
    end
})

Tab7:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = false,
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)

                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})

Tab7:Section({ 
    Title = "Server",
    Icon = "server",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab7:Divider()

Tab7:Button({
    Title = "Rejoin Server",
    Desc = "Reconnect to current server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

Tab7:Button({
    Title = "Server Hop",
    Desc = "Switch to another server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local function GetServers()
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
            local response = HttpService:JSONDecode(game:HttpGet(url))
            return response.data
        end
        local function FindBestServer(servers)
            for _, server in ipairs(servers) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    return server.id
                end
            end
            return nil
        end
        local servers = GetServers()
        local serverId = FindBestServer(servers)
        if serverId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
        end
    end
})

Tab7:Section({ 
    Title = "Config",
    Icon = "folder-open",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab7:Divider()

local ConfigFolder = "STREE_HUB/Configs"
if not isfolder("STREE_HUB") then makefolder("STREE_HUB") end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local ConfigName = "default.json"

local function GetConfig()
    return {
        WalkSpeed = Humanoid.WalkSpeed,
        JumpPower = _G.CustomJumpPower or 50,
        InfiniteJump = _G.InfiniteJump or false,
        AutoSell = _G.AutoSell or false,
        InstantCatch = _G.InstantCatch or false,
        AntiAFK = _G.AntiAFK or false,
        AutoReconnect = _G.AutoReconnect or false,
    }
end

local function ApplyConfig(data)
    if data.WalkSpeed then 
        Humanoid.WalkSpeed = data.WalkSpeed 
    end
    if data.JumpPower then
        _G.CustomJumpPower = data.JumpPower
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = data.JumpPower
        end
    end
    if data.InfiniteJump ~= nil then
        _G.InfiniteJump = data.InfiniteJump
    end
    if data.AutoSell ~= nil then
        _G.AutoSell = data.AutoSell
    end
    if data.InstantCatch ~= nil then
        _G.InstantCatch = data.InstantCatch
    end
    if data.AntiAFK ~= nil then
        _G.AntiAFK = data.AntiAFK
    end
    if data.AutoReconnect ~= nil then
        _G.AutoReconnect = data.AutoReconnect
    end
end

Tab7:Button({
    Title = "Save Config",
    Desc = "Save all settings",
    Callback = function()
        local data = GetConfig()
        writefile(ConfigFolder.."/"..ConfigName, game:GetService("HttpService"):JSONEncode(data))
    end
})

Tab7:Button({
    Title = "Load Config",
    Desc = "Use saved config",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            local data = readfile(ConfigFolder.."/"..ConfigName)
            local decoded = game:GetService("HttpService"):JSONDecode(data)
            ApplyConfig(decoded)
        end
    end
})

Tab7:Button({
    Title = "Delete Config",
    Desc = "Delete saved config",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            delfile(ConfigFolder.."/"..ConfigName)
        end
    end
})

Tab7:Section({ 
    Title = "Other Scripts",
    Icon = "file-code-corner",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab7:Divider()

Tab7:Button({
    Title = "FLY",
    Desc = "Scripts Fly Gui",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

Tab7:Button({
    Title = "Simple Shader",
    Desc = "Shader",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua"))()
    end
})

Tab7:Button({
    Title = "Infinite Yield",
    Desc = "Other Scripts",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
    end
})
