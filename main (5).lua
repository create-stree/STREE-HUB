local RunService = game:GetService("RunService")

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local HttpService = game:GetService("HttpService")
local ServerID = game.JobId

local httpRequest =
    (syn and syn.request)
    or (http and http.request)
    or http_request
    or request
    or (fluxus and fluxus.request)
    or (getgenv().http and getgenv().http.request)

local webhookURL = ""
local webhookEnabled = false
local RESTOCK_TIME = 300

local function getUserTime()
    return os.date("%H:%M:%S")
end

local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else
        if cloneref(game:GetService("RunService")):IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
        end
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlantRemote = ReplicatedStorage.RemoteEvents:WaitForChild("PlantSeed")
local PurchaseShopItemRemote = ReplicatedStorage.RemoteEvents:FindFirstChild("PurchaseShopItem")
local GetShopDataRemote = ReplicatedStorage.RemoteEvents:FindFirstChild("GetShopData")
local ClaimQuestRemote = ReplicatedStorage.RemoteEvents:FindFirstChild("ClaimQuest")
local RequestQuestsRemote = ReplicatedStorage.RemoteEvents:FindFirstChild("RequestQuests")
local UpdateQuestsRemote = ReplicatedStorage.RemoteEvents:FindFirstChild("UpdateQuests")
local SellItemsRemote = ReplicatedStorage.RemoteEvents:FindFirstChild("SellItems")

local ItemInventory = nil
pcall(function()
    ItemInventory = require(ReplicatedStorage:WaitForChild("Inventory"):WaitForChild("ItemInventory"))
end)

local SeedShopData = nil
pcall(function()
    SeedShopData = require(ReplicatedStorage:WaitForChild("Shop"):WaitForChild("ShopData"):WaitForChild("SeedShopData"))
end)

local GearShopData = nil
pcall(function()
    GearShopData = require(ReplicatedStorage:WaitForChild("Shop"):WaitForChild("ShopData"):WaitForChild("GearShopData"))
end)

local Settings = {
    Enabled = false,
    AutoHarvestTeleport = false,
    IgnoreFavorited = true,
    AutoPlantAtCharacter = false,
    AutoEquipPlantSeeds = false,
    SavedPlantPosition = nil,
    SelectedSeed = nil,
    TeleportToShopOnBuy = true,
    CheckSeedStockBeforeBuy = true,
    AutoBuyLoop = false,
    AutoBuyDelay = 1.0,
    SeedShopNpcPosition = Vector3.new(177, 204, 672),
    SelectedGear = nil,
    TeleportToGearShopOnBuy = true,
    CheckGearStockBeforeBuy = true,
    AutoBuyGearLoop = false,
    AutoBuyGearDelay = 1.0,
    GearShopNpcPosition = Vector3.new(212, 204, 609),
    AutoSellLoop = false,
    AutoSellDelay = 1.0,
    AutoSellOnlyWhenInventoryFull = false,
    InventoryFullSellCooldown = 1.0,
    SellMode = "Sell All",
    TeleportToSellNpcOnSell = true,
    SellNpcPosition = Vector3.new(150, 204, 674),
    AutoClaimQuests = false,
    AutoClaimQuestDelay = 1.0,
    Range = 50,
    HarvestBatchSize = 10,
    Delay = 0.1,
}

local lastPlantTime = 0
local lastHarvestTeleportTime = 0
local lastAutoBuyTime = 0
local lastAutoBuyGearTime = 0
local lastAutoSellTime = 0
local lastInventoryFullSellTime = 0
local lastAutoClaimQuestTime = 0
local warnedMissingSavedPosition = false
local warnedMissingQuestRemotes = false
local warnedMissingSellRemotes = false
local harvestCooldownByPrompt = {}
local harvestFailCountByPrompt = {}
local harvestBlacklistUntilByPrompt = {}
local HARVEST_PROMPT_SCAN_INTERVAL = 0.35
local harvestPromptScanCache = {}
local harvestPromptScanCacheAt = 0
local latestQuestData = nil
local INVENTORY_FULL_TEXT = "Your inventory is full! Sell or remove items to make space"

if UpdateQuestsRemote and UpdateQuestsRemote:IsA("RemoteEvent") then
    UpdateQuestsRemote.OnClientEvent:Connect(function(data)
        if type(data) == "table" then
            latestQuestData = data
        end
    end)
end

local seedOptions = {}
local seedPriceByName = {}
if SeedShopData and SeedShopData.ShopData then
    local seedEntries = {}
    for _, shopEntry in pairs(SeedShopData.ShopData) do
        if type(shopEntry) == "table" and type(shopEntry.Name) == "string" then
            if shopEntry.DisplayInShop ~= false then
                table.insert(seedEntries, { Name = shopEntry.Name, Price = tonumber(shopEntry.Price) or math.huge })
                seedPriceByName[shopEntry.Name] = tonumber(shopEntry.Price) or nil
            end
        end
    end
    table.sort(seedEntries, function(a, b)
        if a.Price == b.Price then return a.Name < b.Name end
        return a.Price < b.Price
    end)
    for _, entry in ipairs(seedEntries) do
        table.insert(seedOptions, entry.Name)
    end
end
if #seedOptions == 0 then seedOptions = { "Carrot" } end

Settings.SelectedSeed = seedOptions[1]
local selectedAutoPlantSeedsMap = {}
local autoPlantEquipCycleIndex = 1
local selectedBuySeedsMap = {}
local buySeedCycleIndex = 1

local gearOptions = {}
local gearPriceByName = {}
if GearShopData and GearShopData.ShopData then
    local gearEntries = {}
    for _, shopEntry in pairs(GearShopData.ShopData) do
        if type(shopEntry) == "table" and type(shopEntry.Name) == "string" then
            if shopEntry.DisplayInShop ~= false then
                table.insert(gearEntries, { Name = shopEntry.Name, Price = tonumber(shopEntry.Price) or math.huge })
                gearPriceByName[shopEntry.Name] = tonumber(shopEntry.Price) or nil
            end
        end
    end
    table.sort(gearEntries, function(a, b)
        if a.Price == b.Price then return a.Name < b.Name end
        return a.Price < b.Price
    end)
    for _, entry in ipairs(gearEntries) do
        table.insert(gearOptions, entry.Name)
    end
end
if #gearOptions == 0 then gearOptions = { "Recall Wrench" } end

Settings.SelectedGear = gearOptions[1]
local selectedBuyGearsMap = {}
local buyGearCycleIndex = 1

local function pickFirstSelectedValue(selection, valueMap)
    if type(selection) == "table" then
        local labels = {}
        for label, isSelected in pairs(selection) do
            if isSelected then table.insert(labels, label) end
        end
        table.sort(labels)
        local firstLabel = labels[1]
        if not firstLabel then return nil end
        if valueMap then return valueMap[firstLabel] or firstLabel end
        return firstLabel
    end
    if valueMap then return valueMap[selection] or selection end
    return selection
end

local Window = WindUI:CreateWindow({
    Title = "ronix hub",
    Folder = "ronixhub",
    Icon = "rbxassetid://136256350192953",
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Open ronix hub",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 0.5,
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"),
            Color3.fromHex("#e7ff2f")
        )
    },
    Topbar = {
        Height = 44,
        ButtonsType = "Mac",
    },
})

local Green  = Color3.fromHex("#10C550")
local Blue   = Color3.fromHex("#257AF7")
local Yellow = Color3.fromHex("#ECA201")
local Purple = Color3.fromHex("#7775F2")
local Red    = Color3.fromHex("#EF4F1D")
local Grey   = Color3.fromHex("#83889E")

local MainSection = Window:Section({ Title = "Main" })
local ShopSection = Window:Section({ Title = "Shop" })
local SettingsSection = Window:Section({ Title = "Settings" })

local MainTab = MainSection:Tab({
    Title = "Auto Harvest",
    Icon = "solar:home-2-bold",
    IconColor = Green,
    IconShape = "Square",
    Border = true,
})

MainTab:Section({ Title = "Auto Harvest" })

MainTab:Toggle({
    Flag = "AutoHarvestEnabled",
    Title = "Enable Auto Harvest",
    Value = false,
    Callback = function(value)
        Settings.Enabled = value
    end,
})

MainTab:Space()

MainTab:Toggle({
    Flag = "IgnoreFavoritedToggle",
    Title = "Ignore Favorited",
    Value = true,
    Callback = function(value)
        Settings.IgnoreFavorited = value
    end,
})

MainTab:Space()

MainTab:Toggle({
    Flag = "AutoHarvestTeleportToggle",
    Title = "Auto Teleport to Harvest",
    Value = false,
    Callback = function(value)
        Settings.AutoHarvestTeleport = value
    end,
})

MainTab:Space()

MainTab:Slider({
    Flag = "HarvestDelaySlider",
    Title = "Harvest Delay (s)",
    Step = 0.01,
    Value = { Min = 0.05, Max = 1.0, Default = Settings.Delay },
    Callback = function(value)
        Settings.Delay = value
    end,
})

MainTab:Space()

MainTab:Slider({
    Flag = "HarvestBatchSizeSlider",
    Title = "Harvest Batch Size",
    Step = 1,
    Value = { Min = 1, Max = 50, Default = Settings.HarvestBatchSize },
    Callback = function(value)
        Settings.HarvestBatchSize = value
    end,
})

MainTab:Space()

MainTab:Slider({
    Flag = "HarvestRangeSlider",
    Title = "Harvest Range",
    Step = 1,
    Value = { Min = 10, Max = 200, Default = Settings.Range },
    Callback = function(value)
        Settings.Range = value
    end,
})

MainTab:Space()

MainTab:Toggle({
    Flag = "AutoClaimQuestsToggle",
    Title = "Auto Claim Quests",
    Value = false,
    Callback = function(value)
        Settings.AutoClaimQuests = value
        if value and RequestQuestsRemote and RequestQuestsRemote:IsA("RemoteEvent") then
            pcall(function() RequestQuestsRemote:FireServer() end)
        end
    end,
})

local PlantTab = MainSection:Tab({
    Title = "Auto Plant",
    Icon = "solar:check-square-bold",
    IconColor = Green,
    IconShape = "Square",
    Border = true,
})

PlantTab:Section({ Title = "Auto Plant" })

local SavedPositionSection = PlantTab:Section({
    Title = "Saved Position: Not set",
    TextSize = 14,
    TextTransparency = 0.3,
})

PlantTab:Toggle({
    Flag = "AutoPlantAtCharacterToggle",
    Title = "Auto Plant",
    Value = false,
    Callback = function(value)
        if value and not Settings.SavedPlantPosition then
            Settings.AutoPlantAtCharacter = false
            WindUI:Notify({ Title = "ronix hub", Content = "Set a plant position first.", Icon = "solar:info-square-bold" })
            return
        end
        Settings.AutoPlantAtCharacter = value
        warnedMissingSavedPosition = false
    end,
})

PlantTab:Space()

PlantTab:Toggle({
    Flag = "AutoEquipPlantSeedsToggle",
    Title = "Auto Equip Seeds",
    Desc = "If no seeds are selected, it will plant all seeds you have",
    Value = false,
    Callback = function(value)
        Settings.AutoEquipPlantSeeds = value
    end,
})

PlantTab:Space()

PlantTab:Dropdown({
    Flag = "AutoPlantSeedMultiDropdown",
    Title = "Auto Plant Seeds",
    Values = seedOptions,
    Multi = true,
    Callback = function(value)
        selectedAutoPlantSeedsMap = {}
        if type(value) == "table" then
            for seedName, isSelected in pairs(value) do
                if isSelected then
                    selectedAutoPlantSeedsMap[tostring(seedName)] = true
                end
            end
        end
        autoPlantEquipCycleIndex = 1
    end,
})

PlantTab:Space()

PlantTab:Button({
    Title = "Save Current Position",
    Icon = "map-pin",
    Justify = "Center",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then
            WindUI:Notify({ Title = "ronix hub", Content = "No character found.", Icon = "solar:info-square-bold" })
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
        if not root then
            WindUI:Notify({ Title = "ronix hub", Content = "No root part found.", Icon = "solar:info-square-bold" })
            return
        end
        Settings.SavedPlantPosition = root.Position
        warnedMissingSavedPosition = false
        WindUI:Notify({
            Title = "Position Saved",
            Content = string.format("X %.1f | Y %.1f | Z %.1f", root.Position.X, root.Position.Y, root.Position.Z),
            Icon = "solar:check-square-bold",
        })
    end,
})

local SeedShopTab = ShopSection:Tab({
    Title = "Seed Shop",
    Icon = "solar:cursor-square-bold",
    IconColor = Yellow,
    IconShape = "Square",
    Border = true,
})

SeedShopTab:Section({ Title = "Seed Shop" })

SeedShopTab:Dropdown({
    Flag = "SeedToBuyDropdown",
    Title = "Seeds to Buy",
    Values = seedOptions,
    Multi = true,
    Callback = function(value)
        selectedBuySeedsMap = {}
        if type(value) == "table" then
            for key, isSelected in pairs(value) do
                if type(key) == "number" then
                    selectedBuySeedsMap[tostring(isSelected)] = true
                elseif isSelected then
                    selectedBuySeedsMap[tostring(key)] = true
                end
            end
        elseif type(value) == "string" and value ~= "" then
            selectedBuySeedsMap[value] = true
        end
        local selected = pickFirstSelectedValue(value, nil)
        if selected then Settings.SelectedSeed = tostring(selected) end
        buySeedCycleIndex = 1
    end,
})

SeedShopTab:Space()

SeedShopTab:Toggle({
    Flag = "TeleportToShopOnBuyToggle",
    Title = "Teleport To NPC On Buy",
    Value = true,
    Callback = function(value)
        Settings.TeleportToShopOnBuy = value
    end,
})

SeedShopTab:Space()

SeedShopTab:Toggle({
    Flag = "CheckSeedStockBeforeBuyToggle",
    Title = "Check Stock Before Buy",
    Value = Settings.CheckSeedStockBeforeBuy,
    Callback = function(value)
        Settings.CheckSeedStockBeforeBuy = value
    end,
})

SeedShopTab:Space()

SeedShopTab:Toggle({
    Flag = "AutoBuyLoopToggle",
    Title = "Auto Buy Loop",
    Value = false,
    Callback = function(value)
        Settings.AutoBuyLoop = value
    end,
})

SeedShopTab:Space()

SeedShopTab:Slider({
    Flag = "SeedBuyDelaySlider",
    Title = "Seed Buy Delay (s)",
    Step = 0.1,
    Value = { Min = 0.1, Max = 5.0, Default = Settings.AutoBuyDelay },
    Callback = function(value)
        Settings.AutoBuyDelay = value
    end,
})

SeedShopTab:Space()

local SeedBuyGroup = SeedShopTab:Group({})
SeedBuyGroup:Button({
    Title = "Buy Seed Now",
    Icon = "shopping-cart",
    Justify = "Center",
    Color = Green,
    Callback = function()
        tryBuyNextSelectedSeed(false)
    end,
})
SeedBuyGroup:Space()
SeedBuyGroup:Button({
    Title = "Open Seed Shop",
    Icon = "store",
    Justify = "Center",
    Callback = function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        local seedShopGui = playerGui:FindFirstChild("SeedShop")
        if seedShopGui then seedShopGui.Enabled = true end
    end,
})

local GearShopTab = ShopSection:Tab({
    Title = "Gear Shop",
    Icon = "solar:password-minimalistic-input-bold",
    IconColor = Blue,
    IconShape = "Square",
    Border = true,
})

GearShopTab:Section({ Title = "Gear Shop" })

GearShopTab:Dropdown({
    Flag = "GearToBuyDropdown",
    Title = "Gear to Buy",
    Values = gearOptions,
    Multi = true,
    Callback = function(value)
        selectedBuyGearsMap = {}
        if type(value) == "table" then
            for key, isSelected in pairs(value) do
                if type(key) == "number" then
                    selectedBuyGearsMap[tostring(isSelected)] = true
                elseif isSelected then
                    selectedBuyGearsMap[tostring(key)] = true
                end
            end
        elseif type(value) == "string" and value ~= "" then
            selectedBuyGearsMap[value] = true
        end
        local selected = pickFirstSelectedValue(value, nil)
        if selected then Settings.SelectedGear = tostring(selected) end
        buyGearCycleIndex = 1
    end,
})

GearShopTab:Space()

GearShopTab:Toggle({
    Flag = "TeleportToGearShopOnBuyToggle",
    Title = "Teleport To NPC On Buy",
    Value = true,
    Callback = function(value)
        Settings.TeleportToGearShopOnBuy = value
    end,
})

GearShopTab:Space()

GearShopTab:Toggle({
    Flag = "CheckGearStockBeforeBuyToggle",
    Title = "Check Stock Before Buy",
    Value = Settings.CheckGearStockBeforeBuy,
    Callback = function(value)
        Settings.CheckGearStockBeforeBuy = value
    end,
})

GearShopTab:Space()

GearShopTab:Toggle({
    Flag = "AutoBuyGearLoopToggle",
    Title = "Auto Buy Loop",
    Value = false,
    Callback = function(value)
        Settings.AutoBuyGearLoop = value
    end,
})

GearShopTab:Space()

GearShopTab:Slider({
    Flag = "GearBuyDelaySlider",
    Title = "Gear Buy Delay (s)",
    Step = 0.1,
    Value = { Min = 0.1, Max = 5.0, Default = Settings.AutoBuyGearDelay },
    Callback = function(value)
        Settings.AutoBuyGearDelay = value
    end,
})

GearShopTab:Space()

local GearBuyGroup = GearShopTab:Group({})
GearBuyGroup:Button({
    Title = "Buy Gear Now",
    Icon = "wrench",
    Justify = "Center",
    Color = Blue,
    Callback = function()
        tryBuyNextSelectedGear(false)
    end,
})
GearBuyGroup:Space()
GearBuyGroup:Button({
    Title = "Open Gear Shop",
    Icon = "store",
    Justify = "Center",
    Callback = function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        local gearShopGui = playerGui:FindFirstChild("GearShop")
        if gearShopGui then gearShopGui.Enabled = true end
    end,
})

local SellTab = ShopSection:Tab({
    Title = "Auto Sell",
    Icon = "solar:square-transfer-horizontal-bold",
    IconColor = Red,
    IconShape = "Square",
    Border = true,
})

SellTab:Section({ Title = "Auto Sell" })

SellTab:Dropdown({
    Flag = "SellModeDropdown",
    Title = "Sell Mode",
    Values = { "Sell All", "Sell Held Item", "Sell All on Inventory Full" },
    Value = "Sell All",
    Callback = function(value)
        local selected = pickFirstSelectedValue(value, nil)
        if selected == "Sell All" then
            Settings.SellMode = "SellAll"
            Settings.AutoSellOnlyWhenInventoryFull = false
        elseif selected == "Sell Held Item" then
            Settings.SellMode = "Sell Held Item"
            Settings.AutoSellOnlyWhenInventoryFull = false
        elseif selected == "Sell All on Inventory Full" then
            Settings.SellMode = "SellAll"
            Settings.AutoSellOnlyWhenInventoryFull = true
        end
    end,
})

SellTab:Space()

SellTab:Toggle({
    Flag = "TeleportToSellNpcOnSellToggle",
    Title = "Teleport To Sell NPC On Sell",
    Value = true,
    Callback = function(value)
        Settings.TeleportToSellNpcOnSell = value
    end,
})

SellTab:Space()

SellTab:Toggle({
    Flag = "AutoSellLoopToggle",
    Title = "Auto Sell Loop",
    Value = false,
    Callback = function(value)
        Settings.AutoSellLoop = value
    end,
})

SellTab:Space()

SellTab:Slider({
    Flag = "AutoSellDelaySlider",
    Title = "Auto Sell Delay (s)",
    Step = 0.1,
    Value = { Min = 0.1, Max = 10.0, Default = Settings.AutoSellDelay },
    Callback = function(value)
        Settings.AutoSellDelay = value
    end,
})

SellTab:Space()

SellTab:Button({
    Title = "Sell Now",
    Icon = "dollar-sign",
    Justify = "Center",
    Color = Red,
    Callback = function()
        trySell(Settings.SellMode, false)
    end,
})

local UISettingsTab = SettingsSection:Tab({
    Title = "UI Settings",
    Icon = "solar:info-square-bold",
    IconColor = Grey,
    IconShape = "Square",
    Border = true,
})

UISettingsTab:Section({ Title = "UI Settings" })

UISettingsTab:Keybind({
    Flag = "ToggleKeybind",
    Title = "Toggle UI Keybind",
    Desc = "Keybind to open/close the hub",
    Value = "LeftAlt",
    Callback = function(v)
        pcall(function()
            Window:SetToggleKey(Enum.KeyCode[v])
        end)
    end,
})

UISettingsTab:Space()

UISettingsTab:Button({
    Title = "Destroy UI",
    Color = Red,
    Justify = "Center",
    Icon = "x",
    Callback = function()
        Window:Destroy()
    end,
})

local function buildSeedText(data)
    local lines = {}
    if SeedShopData and SeedShopData.ShopData then
        for _, info in pairs(SeedShopData.ShopData) do
            local name = info.Name
            local stock = data.Items[name]
            local amount = stock and stock.Amount or 0
            if amount >= 1 then
                table.insert(lines, "🌱 " .. name .. " : " .. amount .. "x")
            end
        end
    end
    if #lines == 0 then table.insert(lines, "All seeds out of stock") end
    return table.concat(lines, "\n")
end

local function buildGearText(data)
    local lines = {}
    if GearShopData and GearShopData.ShopData then
        for _, info in pairs(GearShopData.ShopData) do
            local name = info.Name
            local stock = data.Items[name]
            local amount = stock and stock.Amount or 0
            if amount >= 1 then
                table.insert(lines, "⚙️ " .. name .. " : " .. amount .. "x")
            end
        end
    end
    if #lines == 0 then table.insert(lines, "All gear out of stock") end
    return table.concat(lines, "\n")
end

local function getRestockTimer()
    local serverTime = workspace:GetServerTimeNow()
    local remain = RESTOCK_TIME - (serverTime % RESTOCK_TIME)
    local m = math.floor(remain / 60)
    local s = math.floor(remain % 60)
    return string.format("%02d:%02d", m, s)
end

local function sendWebhook(seedText, gearText)
    if webhookURL == "" or not httpRequest then return end
    local body = {
        username = "Ronix",
        avatar_url = "https://cdn.discordapp.com/attachments/1457291963626950687/1480782683692073144/2122e8bff6e8fdd084bb94a2d42af5c5.webp",
        embeds = {
            {
                title = "Ronix | Shop Restock",
                color = 5793266,
                fields = {
                    { name = "🌱 Seed Shop", value = "```" .. seedText .. "```", inline = false },
                    { name = "⚙️ Gear Shop", value = "```" .. gearText .. "```", inline = false },
                    { name = "Next Restock", value = getRestockTimer(), inline = false },
                    { name = "Server ID", value = "`" .. ServerID .. "`", inline = false },
                    { name = "Player", value = "||" .. LocalPlayer.Name .. "||", inline = false },
                },
                footer = { text = "Ronix Stock " .. getUserTime() }
            }
        }
    }
    httpRequest({
        Url = webhookURL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(body)
    })
end

local function sendStock()
    if not GetShopDataRemote then return end
    local okSeed, seedServer = pcall(function()
        return GetShopDataRemote:InvokeServer("SeedShop")
    end)
    local okGear, gearServer = pcall(function()
        return GetShopDataRemote:InvokeServer("GearShop")
    end)
    if okSeed and okGear then
        sendWebhook(buildSeedText(seedServer), buildGearText(gearServer))
    end
end

function ToggleWebhook(state)
    webhookEnabled = state
    if state then sendStock() end
end

function TestWebhook()
    sendWebhook("🌱 Test Seed : 99x", "⚙️ Test Gear : 10x")
end

local WebhookTab = MainSection:Tab({
    Title = "Webhook",
    Icon = "solar:bell-bold",
    IconColor = Purple,
    IconShape = "Square",
    Border = true,
})

WebhookTab:Section({ Title = "Discord Webhook" })

WebhookTab:Input({
    Flag = "WebhookURLInput",
    Title = "Webhook URL",
    Desc = "Paste your Discord webhook URL here",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(value)
        webhookURL = tostring(value or "")
    end,
})

WebhookTab:Space()

WebhookTab:Toggle({
    Flag = "WebhookEnabledToggle",
    Title = "Enable Webhook",
    Desc = "Auto-send stock info to Discord on every restock",
    Value = false,
    Callback = function(value)
        if value and webhookURL == "" then
            WindUI:Notify({ Title = "ronix hub", Content = "Set a webhook URL first.", Icon = "solar:info-square-bold" })
            Window:GetFlag("WebhookEnabledToggle"):Set(false)
            return
        end
        ToggleWebhook(value)
    end,
})

WebhookTab:Space()

WebhookTab:Button({
    Title = "Test Webhook",
    Icon = "solar:send-bold",
    Justify = "Center",
    Color = Purple,
    Callback = function()
        if webhookURL == "" then
            WindUI:Notify({ Title = "ronix hub", Content = "Set a webhook URL first.", Icon = "solar:info-square-bold" })
            return
        end
        TestWebhook()
    end,
})

WebhookTab:Space()

WebhookTab:Button({
    Title = "Send Stock Now",
    Icon = "solar:share-bold",
    Justify = "Center",
    Callback = function()
        if webhookURL == "" then
            WindUI:Notify({ Title = "ronix hub", Content = "Set a webhook URL first.", Icon = "solar:info-square-bold" })
            return
        end
        sendStock()
    end,
})

workspace:GetAttributeChangedSignal("SeedShop"):Connect(function()
    task.wait(1)
    if webhookEnabled then
        sendStock()
    end
end)

local function getCharacterRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
end

local function isNearNpc(rootPos, targetPos, horizontalDist, maxYDiff)
    local dx = rootPos.X - targetPos.X
    local dz = rootPos.Z - targetPos.Z
    local horizontal = math.sqrt(dx * dx + dz * dz)
    local yDiff = math.abs(rootPos.Y - targetPos.Y)
    return horizontal <= horizontalDist and yDiff <= maxYDiff
end

local function teleportRootAndWait(root, targetPos, timeoutSec, horizontalDist, maxYDiff, stableFramesRequired)
    local timeout = timeoutSec or 0.75
    local nearHorizontal = horizontalDist or 2.5
    local nearY = maxYDiff or 10
    local stableFrames = stableFramesRequired or 5
    local started = tick()
    local stableCount = 0

    while tick() - started < timeout do
        root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
        task.wait()
        local currentRoot = getCharacterRoot()
        if not currentRoot then return false end
        root = currentRoot
        if isNearNpc(root.Position, targetPos, nearHorizontal, nearY) then
            stableCount = stableCount + 1
            if stableCount >= stableFrames then
                for _ = 1, 3 do
                    root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    task.wait()
                end
                return true
            end
        else
            stableCount = 0
        end
    end

    return isNearNpc(root.Position, targetPos, nearHorizontal, nearY)
end

local function isInventoryFullNotificationText(text)
    if type(text) ~= "string" then return false end
    local normalized = string.gsub(text, "^%s+", "")
    normalized = string.gsub(normalized, "%s+$", "")
    if normalized == INVENTORY_FULL_TEXT then return true end
    if string.sub(normalized, 1, #INVENTORY_FULL_TEXT) ~= INVENTORY_FULL_TEXT then return false end
    local suffix = string.sub(normalized, #INVENTORY_FULL_TEXT + 1)
    suffix = string.gsub(suffix, "^%s+", "")
    if suffix == "" then return true end
    if string.match(suffix, "^%.[%s]*%[X%d+%]$") then return true end
    if string.match(suffix, "^%[X%d+%]$") then return true end
    return false
end

local function shouldSellFromInventoryFullNotification()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return false end
    local notification = playerGui:FindFirstChild("Notification")
    if not notification then return false end
    local frame = notification:FindFirstChild("Frame")
    if not frame then return false end
    local frameChildren = frame:GetChildren()
    local slot = frameChildren[5]
    if slot then
        local content = slot:FindFirstChild("CONTENT")
        local shadow = content and content:FindFirstChild("CONTENT_SHADOW")
        if shadow and shadow:IsA("TextLabel") and isInventoryFullNotificationText(shadow.Text) then
            return true
        end
    end
    for _, node in ipairs(frame:GetDescendants()) do
        if node:IsA("TextLabel") and isInventoryFullNotificationText(node.Text) then
            return true
        end
    end
    return false
end

function trySell(mode, silent)
    if not SellItemsRemote then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "SellItems remote not found." }) end
        return false
    end
    local sellMode = mode
    if sellMode == "Sell Held Item" then
        sellMode = "SellSingle"
    elseif sellMode ~= "SellSingle" and sellMode ~= "SellAll" then
        sellMode = Settings.SellMode == "Sell Held Item" and "SellSingle" or "SellAll"
    end
    local originalPos = nil
    local didTeleport = false
    local root = getCharacterRoot()
    if Settings.TeleportToSellNpcOnSell then
        if not root then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Character root not found." }) end
            return false
        end
        local npcPos = Settings.SellNpcPosition
        if not npcPos then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Sell NPC position not set." }) end
            return false
        end
        originalPos = root.Position
        local reached = teleportRootAndWait(root, npcPos, 1.2, 2.5, 10, 5)
        if not reached then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Could not reach sell NPC." }) end
            return false
        end
        didTeleport = true
        task.wait(0.15)
    end
    local ok, result = pcall(function()
        if SellItemsRemote:IsA("RemoteFunction") then
            return SellItemsRemote:InvokeServer(sellMode)
        end
        SellItemsRemote:FireServer(sellMode)
        return true
    end)
    if didTeleport and originalPos then
        local backRoot = getCharacterRoot()
        if backRoot then backRoot.CFrame = CFrame.new(originalPos) end
    end
    if not ok then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Sell failed (invoke error)." }) end
        return false
    end
    local response = tostring(result or "")
    local responseLower = string.lower(response)
    local sold = result == true
        or string.find(responseLower, "here's", 1, true) ~= nil
        or string.find(responseLower, "sold", 1, true) ~= nil
    if sold then return true end
    if not silent then
        if response ~= "" and response ~= "nil" then
            WindUI:Notify({ Title = "ronix hub", Content = response })
        else
            WindUI:Notify({ Title = "ronix hub", Content = "Nothing to sell." })
        end
    end
    return false
end

local function getSeedStockAmount(seedName)
    if not GetShopDataRemote then return nil, "GetShopData remote not found." end
    local ok, data = pcall(function() return GetShopDataRemote:InvokeServer("SeedShop") end)
    if not ok or type(data) ~= "table" or type(data.Items) ~= "table" then return nil, "Failed to fetch stock." end
    for itemName, itemData in pairs(data.Items) do
        if tostring(itemName):lower() == tostring(seedName):lower() then
            if type(itemData) == "table" then return tonumber(itemData.Amount) or 0, nil end
            return 0, nil
        end
    end
    return 0, nil
end

local function getPlayerShillings()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    local function readNumericStat(container, name)
        if not container then return nil end
        local valueObj = container:FindFirstChild(name)
        if valueObj and (valueObj:IsA("IntValue") or valueObj:IsA("NumberValue")) then
            return tonumber(valueObj.Value)
        end
        return nil
    end
    local amount = readNumericStat(stats, "Shillings")
    if amount ~= nil then return amount end
    amount = readNumericStat(LocalPlayer, "Shillings")
    if amount ~= nil then return amount end
    if stats then
        local numericValues = {}
        for _, child in ipairs(stats:GetChildren()) do
            if child:IsA("IntValue") or child:IsA("NumberValue") then
                table.insert(numericValues, child)
            end
        end
        if #numericValues == 1 then
            local a = tonumber(numericValues[1].Value)
            if a ~= nil then return a end
        end
    end
    return nil
end

local function canAffordPrice(price)
    local numericPrice = tonumber(price)
    if not numericPrice or numericPrice <= 0 then return true end
    local shillings = getPlayerShillings()
    if shillings == nil then return true end
    return shillings >= numericPrice
end

local function tryBuySelectedSeed(silent, forcedSeedName)
    local seedName = forcedSeedName or Settings.SelectedSeed
    if not PurchaseShopItemRemote then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Purchase remote not found." }) end
        return false
    end
    if not seedName then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Select a seed first." }) end
        return false
    end
    if Settings.CheckSeedStockBeforeBuy then
        local stockAmount, stockErr = getSeedStockAmount(seedName)
        if stockAmount == nil then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = stockErr or "Could not check stock." }) end
            return false
        end
        if stockAmount <= 0 then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = seedName .. " is out of stock." }) end
            return false
        end
    end
    local seedPrice = seedPriceByName[seedName]
    if not canAffordPrice(seedPrice) then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Not enough shillings to buy " .. seedName .. "." }) end
        return false
    end
    local originalPos = nil
    local didTeleport = false
    local root = getCharacterRoot()
    if Settings.TeleportToShopOnBuy then
        if not root then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Character root not found." }) end
            return false
        end
        local npcPos = Settings.SeedShopNpcPosition
        if not npcPos then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Seed shop NPC not found." }) end
            return false
        end
        originalPos = root.Position
        local reached = teleportRootAndWait(root, npcPos, 1.2, 2.5, 10, 5)
        if not reached then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Could not reach seed shop NPC." }) end
            return false
        end
        didTeleport = true
        task.wait(0.2)
    end
    local ok, result, reason = pcall(function()
        return PurchaseShopItemRemote:InvokeServer("SeedShop", seedName)
    end)
    if not ok then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Purchase failed (invoke error)." }) end
        return false
    end
    if result then
        if didTeleport and originalPos then
            local backRoot = getCharacterRoot()
            if backRoot then backRoot.CFrame = CFrame.new(originalPos) end
        end
        if not silent then WindUI:Notify({ Title = "Purchased!", Content = "Bought: " .. seedName, Icon = "solar:check-square-bold" }) end
        return true
    else
        if didTeleport and originalPos then
            local backRoot = getCharacterRoot()
            if backRoot then backRoot.CFrame = CFrame.new(originalPos) end
        end
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Purchase failed: " .. tostring(reason or "Unknown") }) end
        return false
    end
end

local function getSelectedBuySeedList()
    local selectedSeedList = {}
    for _, seedName in ipairs(seedOptions) do
        if selectedBuySeedsMap[seedName] then
            table.insert(selectedSeedList, seedName)
        end
    end
    if #selectedSeedList == 0 and Settings.SelectedSeed then
        table.insert(selectedSeedList, Settings.SelectedSeed)
    end
    return selectedSeedList
end

function tryBuyNextSelectedSeed(silent)
    local selectedSeedList = getSelectedBuySeedList()
    if #selectedSeedList == 0 then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Select a seed first." }) end
        return false
    end
    if buySeedCycleIndex < 1 or buySeedCycleIndex > #selectedSeedList then buySeedCycleIndex = 1 end
    local startIndex = buySeedCycleIndex
    for offset = 0, #selectedSeedList - 1 do
        local idx = ((startIndex - 1 + offset) % #selectedSeedList) + 1
        local seedName = selectedSeedList[idx]
        if tryBuySelectedSeed(silent, seedName) then
            buySeedCycleIndex = (idx % #selectedSeedList) + 1
            return true
        end
    end
    buySeedCycleIndex = (startIndex % #selectedSeedList) + 1
    return false
end

local function getGearStockAmount(gearName)
    if not GetShopDataRemote then return nil, "GetShopData remote not found." end
    local ok, data = pcall(function() return GetShopDataRemote:InvokeServer("GearShop") end)
    if not ok or type(data) ~= "table" or type(data.Items) ~= "table" then return nil, "Failed to fetch stock." end
    for itemName, itemData in pairs(data.Items) do
        if tostring(itemName):lower() == tostring(gearName):lower() then
            if type(itemData) == "table" then return tonumber(itemData.Amount) or 0, nil end
            return 0, nil
        end
    end
    return 0, nil
end

local function tryBuySelectedGear(silent, forcedGearName)
    local gearName = forcedGearName or Settings.SelectedGear
    if not PurchaseShopItemRemote then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Purchase remote not found." }) end
        return false
    end
    if not gearName then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Select a gear first." }) end
        return false
    end
    if Settings.CheckGearStockBeforeBuy then
        local stockAmount, stockErr = getGearStockAmount(gearName)
        if stockAmount == nil then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = stockErr or "Could not check stock." }) end
            return false
        end
        if stockAmount <= 0 then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = gearName .. " is out of stock." }) end
            return false
        end
    end
    local gearPrice = gearPriceByName[gearName]
    if not canAffordPrice(gearPrice) then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Not enough shillings to buy " .. gearName .. "." }) end
        return false
    end
    local originalPos = nil
    local didTeleport = false
    local root = getCharacterRoot()
    if Settings.TeleportToGearShopOnBuy then
        if not root then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Character root not found." }) end
            return false
        end
        local npcPos = Settings.GearShopNpcPosition
        if not npcPos then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Gear shop NPC not found." }) end
            return false
        end
        originalPos = root.Position
        local reached = teleportRootAndWait(root, npcPos, 1.2, 2.5, 10, 5)
        if not reached then
            if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Could not reach gear shop NPC." }) end
            return false
        end
        didTeleport = true
        task.wait(0.2)
    end
    local ok, result, reason = pcall(function()
        return PurchaseShopItemRemote:InvokeServer("GearShop", gearName)
    end)
    if not ok then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Purchase failed (invoke error)." }) end
        return false
    end
    if result then
        if didTeleport and originalPos then
            local backRoot = getCharacterRoot()
            if backRoot then backRoot.CFrame = CFrame.new(originalPos) end
        end
        if not silent then WindUI:Notify({ Title = "Purchased!", Content = "Bought: " .. gearName, Icon = "solar:check-square-bold" }) end
        return true
    else
        if didTeleport and originalPos then
            local backRoot = getCharacterRoot()
            if backRoot then backRoot.CFrame = CFrame.new(originalPos) end
        end
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Purchase failed: " .. tostring(reason or "Unknown") }) end
        return false
    end
end

local function getSelectedBuyGearList()
    local selectedGearList = {}
    for _, gearName in ipairs(gearOptions) do
        if selectedBuyGearsMap[gearName] then
            table.insert(selectedGearList, gearName)
        end
    end
    if #selectedGearList == 0 and Settings.SelectedGear then
        table.insert(selectedGearList, Settings.SelectedGear)
    end
    return selectedGearList
end

function tryBuyNextSelectedGear(silent)
    local selectedGearList = getSelectedBuyGearList()
    if #selectedGearList == 0 then
        if not silent then WindUI:Notify({ Title = "ronix hub", Content = "Select a gear first." }) end
        return false
    end
    if buyGearCycleIndex < 1 or buyGearCycleIndex > #selectedGearList then buyGearCycleIndex = 1 end
    local startIndex = buyGearCycleIndex
    for offset = 0, #selectedGearList - 1 do
        local idx = ((startIndex - 1 + offset) % #selectedGearList) + 1
        local gearName = selectedGearList[idx]
        if tryBuySelectedGear(silent, gearName) then
            buyGearCycleIndex = (idx % #selectedGearList) + 1
            return true
        end
    end
    buyGearCycleIndex = (startIndex % #selectedGearList) + 1
    return false
end

local function getPromptWorldPosition(prompt)
    local parent = prompt.Parent
    if not parent then return nil end
    if parent:IsA("BasePart") then return parent.Position end
    local part = parent:FindFirstChildWhichIsA("BasePart", true)
    if part then return part.Position end
    return nil
end

local function getClosestHarvestPrompts(maxCount, maxRange)
    local now = tick()
    maxRange = maxRange or Settings.Range
    local root = getCharacterRoot()
    if not root then return {} end
    local rootPos = root.Position

    if now - harvestPromptScanCacheAt > HARVEST_PROMPT_SCAN_INTERVAL then
        harvestPromptScanCache = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and (v.ActionText == "Harvest" or string.find(string.lower(v.ActionText), "harvest")) then
                table.insert(harvestPromptScanCache, v)
            end
        end
        harvestPromptScanCacheAt = now
    end

    local validPrompts = {}
    for _, prompt in ipairs(harvestPromptScanCache) do
        if not prompt or not prompt.Parent then continue end
        local blacklistUntil = harvestBlacklistUntilByPrompt[prompt]
        if blacklistUntil and now < blacklistUntil then continue end
        local promptPos = getPromptWorldPosition(prompt)
        if not promptPos then continue end
        local dist = (rootPos - promptPos).Magnitude
        if dist <= maxRange then
            table.insert(validPrompts, { prompt = prompt, dist = dist })
        end
    end

    table.sort(validPrompts, function(a, b) return a.dist < b.dist end)

    local result = {}
    for i = 1, math.min(maxCount, #validPrompts) do
        table.insert(result, validPrompts[i].prompt)
    end
    return result
end

local function harvestPromptBatch(prompts)
    for _, prompt in ipairs(prompts) do
        if not prompt or not prompt.Parent then continue end
        local cd = harvestCooldownByPrompt[prompt]
        if cd and tick() < cd then continue end
        local ok, err = pcall(function()
            fireproximityprompt(prompt)
        end)
        if not ok then
            harvestFailCountByPrompt[prompt] = (harvestFailCountByPrompt[prompt] or 0) + 1
            if harvestFailCountByPrompt[prompt] >= 3 then
                harvestBlacklistUntilByPrompt[prompt] = tick() + 10
                harvestFailCountByPrompt[prompt] = 0
            end
        else
            harvestFailCountByPrompt[prompt] = 0
            harvestCooldownByPrompt[prompt] = tick() + Settings.Delay
        end
    end
end

local function normalizeSeedName(name)
    name = tostring(name or ""):lower()
    name = string.match(name, "^[xX]%d+%s+(.+)%s+[Ss]eed$") or string.match(name, "^(.+)%s+[Ss]eed$") or name
    return name
end

local function getEquippedSeedTool()
    local char = LocalPlayer.Character
    if not char then return nil end
    local preferredSeeds = {}
    for seedName, _ in pairs(selectedAutoPlantSeedsMap) do
        table.insert(preferredSeeds, string.lower(seedName))
    end
    local candidateTools = {}
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local toolNameLower = string.lower(tool.Name)
            if string.find(toolNameLower, "seed") then
                table.insert(candidateTools, tool)
            end
        end
    end
    if #candidateTools == 0 then return nil end
    if not Settings.AutoEquipPlantSeeds and #preferredSeeds == 0 then
        return candidateTools[1]
    end
    if #preferredSeeds > 0 then
        local preferredLower = preferredSeeds[autoPlantEquipCycleIndex] or preferredSeeds[1]
        autoPlantEquipCycleIndex = (autoPlantEquipCycleIndex % #preferredSeeds) + 1
        local toolToEquip = nil
        for _, tool in ipairs(candidateTools) do
            local parsed = normalizeSeedName(tool.Name)
            if parsed and normalizeSeedName(parsed) == preferredLower then
                toolToEquip = tool
                break
            end
        end
        if not toolToEquip then toolToEquip = candidateTools[1] end
        if not toolToEquip then return nil end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return nil end
        for _ = 1, 4 do
            pcall(function()
                humanoid:UnequipTools()
                humanoid:EquipTool(toolToEquip)
            end)
            task.wait(0.08)
            if toolToEquip.Parent == char or toolToEquip:IsDescendantOf(char) then
                return toolToEquip
            end
            pcall(function() toolToEquip.Parent = char end)
            task.wait(0.05)
            if toolToEquip.Parent == char or toolToEquip:IsDescendantOf(char) then
                return toolToEquip
            end
        end
        return nil
    end
    return candidateTools[1]
end

local function plantAtCharacterPosition()
    if not Settings.AutoPlantAtCharacter then return end
    local now = tick()
    if now - lastPlantTime < Settings.Delay then return end
    local tool = getEquippedSeedTool()
    if not tool then return end
    local plantType = tool:GetAttribute("PlantType")
    if not plantType then
        local name = tostring(tool.Name or "")
        plantType = string.match(name, "^[xX]%d+%s+(.+)%s+[Ss]eed")
            or string.match(name, "^(.+)%s+[Ss]eed")
    end
    if not plantType then return end
    local plantPos = Settings.SavedPlantPosition
    if not plantPos then
        Settings.AutoPlantAtCharacter = false
        if not warnedMissingSavedPosition then
            warnedMissingSavedPosition = true
            WindUI:Notify({ Title = "ronix hub", Content = "Set a plant position first." })
        end
        return
    end
    lastPlantTime = now
    pcall(function()
        if PlantRemote:IsA("RemoteFunction") then
            PlantRemote:InvokeServer(plantType, plantPos)
        else
            PlantRemote:FireServer(plantType, plantPos)
        end
    end)
end

local function isQuestEntryClaimable(entry)
    if type(entry) ~= "table" then return false end
    if entry.Claimed == true or entry.IsClaimed == true then return false end
    if entry.Completed == true or entry.IsCompleted == true or entry.Done == true then return true end
    local status = tostring(entry.Status or ""):lower()
    if status == "completed" or status == "complete" then return true end
    local progress = tonumber(entry.Progress or entry.Current or entry.Value or entry.Amount or 0) or 0
    local goal = tonumber(entry.Goal or entry.Target or entry.Required or entry.Max or 0) or 0
    return goal > 0 and progress >= goal
end

local function autoClaimQuests()
    if not (ClaimQuestRemote and ClaimQuestRemote:IsA("RemoteEvent")) then return end
    if RequestQuestsRemote and RequestQuestsRemote:IsA("RemoteEvent") then
        pcall(function() RequestQuestsRemote:FireServer() end)
    end
    if type(latestQuestData) ~= "table" then return end
    for _, questType in ipairs({ "Daily", "Weekly" }) do
        local bucket = latestQuestData[questType]
        local active = bucket and bucket.Active
        if type(active) == "table" then
            for i = 1, 5 do
                local questIndex = tostring(i)
                if isQuestEntryClaimable(active[questIndex]) then
                    pcall(function() ClaimQuestRemote:FireServer(questType, questIndex) end)
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(Settings.Delay) do
        local ok, err = pcall(function()
            local now = tick()

            if Settings.Enabled then
                local batchSize = math.max(1, math.floor(tonumber(Settings.HarvestBatchSize) or 5))
                local closestPrompts = getClosestHarvestPrompts(batchSize)
                if Settings.AutoHarvestTeleport and now - lastHarvestTeleportTime >= 0.5 then
                    local teleportPrompts = getClosestHarvestPrompts(1, math.huge)
                    local teleportPrompt = teleportPrompts[1]
                    if teleportPrompt then
                        local root = getCharacterRoot()
                        local promptPos = getPromptWorldPosition(teleportPrompt)
                        if root and promptPos then
                            root.CFrame = CFrame.new(promptPos + Vector3.new(0, 3, 0))
                            lastHarvestTeleportTime = now
                        end
                    end
                    closestPrompts = getClosestHarvestPrompts(batchSize)
                end
                local firstPrompt = closestPrompts[1]
                if firstPrompt then
                    harvestPromptBatch(closestPrompts)
                end
            end

            if Settings.AutoPlantAtCharacter then
                plantAtCharacterPosition()
            end

            if Settings.AutoBuyLoop then
                if now - lastAutoBuyTime >= Settings.AutoBuyDelay then
                    lastAutoBuyTime = now
                    tryBuyNextSelectedSeed(true)
                end
            end

            if Settings.AutoBuyGearLoop then
                if now - lastAutoBuyGearTime >= Settings.AutoBuyGearDelay then
                    lastAutoBuyGearTime = now
                    tryBuyNextSelectedGear(true)
                end
            end

            if Settings.AutoSellLoop then
                if not SellItemsRemote then
                    if not warnedMissingSellRemotes then
                        warnedMissingSellRemotes = true
                        WindUI:Notify({ Title = "ronix hub", Content = "SellItems remote not found." })
                    end
                elseif now - lastAutoSellTime >= Settings.AutoSellDelay then
                    lastAutoSellTime = now
                    if Settings.AutoSellOnlyWhenInventoryFull then
                        if now - lastInventoryFullSellTime >= Settings.InventoryFullSellCooldown
                            and shouldSellFromInventoryFullNotification() then
                            lastInventoryFullSellTime = now
                            trySell(Settings.SellMode, true)
                        end
                    else
                        trySell(Settings.SellMode, true)
                    end
                end
            end

            if Settings.AutoClaimQuests then
                if not (ClaimQuestRemote and RequestQuestsRemote and UpdateQuestsRemote) then
                    if not warnedMissingQuestRemotes then
                        warnedMissingQuestRemotes = true
                        WindUI:Notify({ Title = "ronix hub", Content = "Quest remotes not found." })
                    end
                else
                    if now - lastAutoClaimQuestTime >= Settings.AutoClaimQuestDelay then
                        lastAutoClaimQuestTime = now
                        autoClaimQuests()
                    end
                end
            end
        end)

        if not ok then
            warn("[ronix hub] Main loop recovered from error:", err)
        end
    end
end)
