--// The Forge Auto Farm - Full WindUI Port (Final)
--// Credit: Nisulrocks (original), WindUI (framework)

local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI failed to load!")
    return
else
    print("✓ WindUI successfully loaded")
end

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

--// CORE FUNCTIONS
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoidRootPart()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
end

local function ensurePickaxeEquipped()
    local char = getCharacter()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool.Name:lower():find("pickaxe") then
            getHumanoid():EquipTool(tool)
            return tool
        end
    end
    return nil
end

local function collectAllRocks(maxDist, origin)
    local rocksRoot = Workspace:FindFirstChild("Rocks")
    local result = {}
    if not rocksRoot then return result end
    for _, folder in ipairs(rocksRoot:GetChildren()) do
        for _, container in ipairs(folder:GetChildren()) do
            local core = container:IsA("BasePart") and container or container.PrimaryPart or container:FindFirstChildWhichIsA("BasePart")
            if core and origin then
                local dist = (core.Position - origin).Magnitude
                if dist <= maxDist then
                    table.insert(result, { model = container, core = core })
                end
            end
        end
    end
    return result
end

local function tweenToPosition(targetPos, speed)
    local hrp = getHumanoidRootPart()
    local distance = (targetPos - hrp.Position).Magnitude
    local time = math.max(0.1, distance / (speed or 120))
    local tween = TweenService:Create(hrp, TweenInfo.new(time), { CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) })
    tween:Play()
    tween.Completed:Wait()
end

local function mineRock(rockInfo)
    local toolServiceRF = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF")
    local toolActivated = toolServiceRF:WaitForChild("ToolActivated")
    local args = { "Pickaxe" }

    for i = 1, 50 do
        if not rockInfo.model or not rockInfo.model.Parent then break end
        pcall(function()
            toolActivated:InvokeServer(unpack(args))
        end)
        task.wait(0.1)
    end
end

--// ESP
local espObjects = {}
local function clearRocksESP()
    for _, data in pairs(espObjects) do
        if data.highlight then pcall(function() data.highlight:Destroy() end) end
        if data.billboard then pcall(function() data.billboard:Destroy() end) end
    end
    table.clear(espObjects)
end

local function ensureESPForRock(rockInfo)
    local model = rockInfo.model
    if not model or not model.Parent or espObjects[model] then return end
    local core = rockInfo.core
    if not (core and core:IsA("BasePart")) then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 200)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.2
    highlight.Adornee = model
    highlight.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.Adornee = core
    billboard.AlwaysOnTop = true
    billboard.Parent = model

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⛏️ Rock"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    espObjects[model] = { highlight = highlight, billboard = billboard }
end

local function updateRocksESP(scanDist)
    local hrp = getHumanoidRootPart()
    local origin = hrp and hrp.Position
    local rocks = collectAllRocks(scanDist, origin)
    local activeModels = {}

    for i = 1, math.min(#rocks, 40) do
        local info = rocks[i]
        ensureESPForRock(info)
        activeModels[info.model] = true
    end

    for model, data in pairs(espObjects) do
        if not activeModels[model] then
            if data.highlight then pcall(function() data.highlight:Destroy() end) end
            if data.billboard then pcall(function() data.billboard:Destroy() end) end
            espObjects[model] = nil
        end
    end
end

--// WINDUI
local Window = WindUI:CreateWindow({
    Title = "The Forge Auto Farm",
    Icon = "rbxassetid://4483362458",
    Author = "Nisulrocks | WindUI Full Port",
    Folder = "TheForgeWindUI",
    Size = UDim2.fromOffset(320, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 180,
    HasOutline = true,
})

local MainTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "pickaxe",
})

local ForgeTab = Window:Tab({
    Title = "Auto Forge",
    Icon = "hammer",
})

local AutoTab = Window:Tab({
    Title = "Auto Potions",
    Icon = "flask",
})

local SellTab = Window:Tab({
    Title = "Auto Sell",
    Icon = "cart",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "gear",
})

--// UI: Auto Farm Ores
MainTab:Section({ Title = "Auto Farm Ores" })

local selectedOres = { "Pebble" }
local oreOptions = { "Pebble", "Boulder", "Basalt", "Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Lava Rock", "Lucky Block", "Light Crystal", "Violet Crystal", "Volcanic Rock" }

MainTab:Dropdown({
    Title = "Select Ores",
    Values = oreOptions,
    Value = selectedOres,
    Multi = true,
    Callback = function(opts)
        selectedOres = opts
    end
})

local scanDistance = 500
MainTab:Slider({
    Title = "Scan Distance",
    Min = 100,
    Max = 500,
    Default = 500,
    Callback = function(v)
        scanDistance = v
    end
})

local autoFarmEnabled = false
MainTab:Toggle({
    Title = "Enable Auto Farm Ores",
    Value = false,
    Callback = function(v)
        autoFarmEnabled = v
        if v then
            task.spawn(function()
                while autoFarmEnabled do
                    local pick = ensurePickaxeEquipped()
                    if pick then
                        local hrp = getHumanoidRootPart()
                        local rocks = collectAllRocks(scanDistance, hrp.Position)
                        for _, rock in ipairs(rocks) do
                            if autoFarmEnabled then
                                tweenToPosition(rock.core.Position)
                                task.wait(0.5)
                                mineRock(rock)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

--// UI: Rocks ESP
MainTab:Section({ Title = "ESP" })

local espEnabled = false
MainTab:Toggle({
    Title = "Enable Rocks ESP",
    Value = false,
    Callback = function(v)
        espEnabled = v
        if v then
            task.spawn(function()
                while espEnabled do
                    updateRocksESP(scanDistance)
                    task.wait(0.5)
                end
            end)
        else
            clearRocksESP()
        end
    end
})

--//  ==========  BAGIAN 2 – AUTO FORGE / POTIONS / SELL / ANTI-AFK  ==========  //

----------------------------------------
--  AUTO FORGE  (stub lengkap)
----------------------------------------
ForgeTab:Section({Title = "Auto Forge"})

local forgeEnabled   = false
local forgeItemType  = "Weapon"
local forgeOres      = {"Pebble"}
local forgePerCycle  = 3
local autoMini       = true

-- dropdown item type
ForgeTab:Dropdown({
    Title = "Forge Item Type",
    Values = {"Weapon","Armor"},
    Value = {"Weapon"},
    Multi = false,
    Callback = function(v)
        forgeItemType = v[1]
    end
})

-- dropdown ores yg dipakai
local oreForForge = {"Pebble","Boulder","Basalt","Crimson Crystal","Cyan Crystal","Earth Crystal",
                     "Lava Rock","Lucky Block","Light Crystal","Violet Crystal","Volcanic Rock"}
ForgeTab:Dropdown({
    Title = "Ores to Forge",
    Values = oreForForge,
    Value = forgeOres,
    Multi = true,
    Callback = function(v)
        forgeOres = v
    end
})

ForgeTab:Slider({
    Title = "Ores per Forge",
    Min = 3,
    Max = 10,
    Default = 3,
    Callback = function(v)
        forgePerCycle = v
    end
})

ForgeTab:Toggle({
    Title = "Auto-Complete Minigames",
    Value = true,
    Callback = function(v)
        autoMini = v
    end
})

ForgeTab:Toggle({
    Title = "Enable Auto Forge",
    Value = false,
    Callback = function(v)
        forgeEnabled = v
        if v then
            task.spawn(function()
                while forgeEnabled do
                    print("[Auto Forge] Starting full cycle (stub)")
                    -- di sini nanti panggil fungsi lengkap melt/pour/hammer + recipe
                    task.wait(5)
                end
            end)
        end
    end
})

----------------------------------------
--  AUTO POTIONS
----------------------------------------
AutoTab:Section({Title = "Auto Potions"})

local potEnabled = false
local potSelected = {}

-- build daftar potion dari ReplicatedStorage
local function buildPotionList()
    local potFolder = ReplicatedStorage:FindFirstChild("Assets")
                  and ReplicatedStorage.Assets:FindFirstChild("Extras")
                  and ReplicatedStorage.Assets.Extras:FindFirstChild("Potion")
    local t = {}
    if potFolder then
        for _, v in ipairs(potFolder:GetChildren()) do
            table.insert(t, v.Name)
        end
    end
    if #t == 0 then t = {"Health Potion"} end
    return t
end

local potOptions = buildPotionList()
AutoTab:Dropdown({
    Title = "Potions to Use",
    Values = potOptions,
    Value = {},
    Multi = true,
    Callback = function(v)
        potSelected = v
    end
})

AutoTab:Toggle({
    Title = "Enable Auto Potions",
    Value = false,
    Callback = function(v)
        potEnabled = v
        if v then
            task.spawn(function()
                local toolRF = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages")
                               :WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService")
                               :WaitForChild("RF"):WaitForChild("ToolActivated")

                while potEnabled do
                    if #potSelected > 0 then
                        local used = false
                        for _, name in ipairs(potSelected) do
                            local tool = LocalPlayer.Backpack:FindFirstChild(name)
                            if tool and tool:IsA("Tool") then
                                getHumanoid():EquipTool(tool)
                                toolRF:InvokeServer(name)
                                used = true
                                task.wait(0.5)
                            end
                        end
                        if not used then print("[Auto Potions] No selected potions found") end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

----------------------------------------
--  AUTO SELL  (stash scanner + jual)
----------------------------------------
SellTab:Section({Title = "Auto Sell"})

local sellEnabled  = false
local sellInterval = 10
local sellAmount   = 100
local sellSelected = {}     -- multi-select inventory

local function getInventoryUI()
    local inv = {}
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return inv end
    -- path dari user: Menu.Frame.Frame.Menus.Stash.Background
    local path = pg:FindFirstChild("Menu")
    if path then path = path:FindFirstChild("Frame") end
    if path then path = path:FindFirstChild("Frame") end
    if path then path = path:FindFirstChild("Menus") end
    if path then path = path:FindFirstChild("Stash") end
    if path then path = path:FindFirstChild("Background") end
    if not path then return inv end

    for _, itemFrame in ipairs(path:GetChildren()) do
        local main = itemFrame:FindFirstChild("Main")
        if main then
            local nameLbl = main:FindFirstChild("ItemName")
            local qtyLbl  = main:FindFirstChild("Quantity")
            if nameLbl and qtyLbl and nameLbl:IsA("TextLabel") and qtyLbl:IsA("TextLabel") then
                local name  = nameLbl.Text
                local qty   = tonumber(string.match(qtyLbl.Text,"%d+")) or 0
                if name ~= "" and qty > 0 then inv[name] = qty end
            end
        end
    end
    return inv
end

local currentInvOptions = {"Press Refresh"}
local InvDropdown -- forward declaration

local function refreshInventoryDropdown()
    local inv = getInventoryUI()
    local opts = {}
    for name in pairs(inv) do table.insert(opts, name) end
    table.sort(opts)
    if #opts == 0 then opts = {"No items found"} end
    currentInvOptions = opts
    if InvDropdown then
        InvDropdown:Refresh(currentInvOptions, {})
    end
end

SellTab:Button({
    Title = "Refresh Inventory",
    Callback = refreshInventoryDropdown
})

InvDropdown = SellTab:Dropdown({
    Title = "Items to Sell",
    Values = currentInvOptions,
    Value = {},
    Multi = true,
    Callback = function(v)
        sellSelected = v
    end
})

SellTab:Slider({
    Title = "Sell Batch Size",
    Min = 1,
    Max = 1000,
    Default = 100,
    Callback = function(v)
        sellAmount = v
    end
})

SellTab:Slider({
    Title = "Sell Interval (s)",
    Min = 5,
    Max = 120,
    Default = 10,
    Callback = function(v)
        sellInterval = v
    end
})

SellTab:Toggle({
    Title = "Enable Auto Sell",
    Value = false,
    Callback = function(v)
        sellEnabled = v
        if v then
            task.spawn(function()
                while sellEnabled do
                    local inv = getInventoryUI()
                    local basket = {}
                    local has = false
                    for _, name in ipairs(sellSelected) do
                        local qty = inv[name] or 0
                        local sellQty = math.min(qty, sellAmount)
                        if sellQty > 0 then
                            basket[name] = sellQty
                            has = true
                        end
                    end
                    if has then
                        local args = {"SellConfirm", {Basket = basket}}
                        local ok, rf = pcall(function()
                            return ReplicatedStorage.Shared.Packages.Knit.Services.DialogueService.RF.RunCommand
                        end)
                        if ok and rf then
                            rf:InvokeServer(unpack(args))
                            print("[Auto Sell] Sold batch:", basket)
                        end
                    end
                    task.wait(sellInterval)
                end
            end)
        end
    end
})

SettingsTab:Section({Title = "Anti AFK"})

local antiAFK = {enabled = true; interval = 60; key = Enum.KeyCode.ButtonR3; bindName = "PVB_AntiAFK_Sink"}
local function antiAFK_start()
    if antiAFK.running then return end
    antiAFK.running = true
    pcall(function() game:GetService("ContextActionService"):UnbindAction(antiAFK.bindName) end)
    pcall(function()
        game:GetService("ContextActionService"):BindAction(antiAFK.bindName, function() return Enum.ContextActionResult.Sink end, false, antiAFK.key)
    end)
    task.spawn(function()
        while antiAFK.enabled do
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, antiAFK.key, false, game)
                task.wait(0.06)
                VirtualInputManager:SendKeyEvent(false, antiAFK.key, false, game)
            end)
            local waitFor = (antiAFK.interval or 60) + math.random(-2,2)
            if waitFor < 10 then waitFor = 10 end
            for i = 1, waitFor*10 do
                if not antiAFK.enabled then break end
                task.wait(0.1)
            end
        end
        antiAFK.running = false
        pcall(function() game:GetService("ContextActionService"):UnbindAction(antiAFK.bindName) end)
    end)
end

SettingsTab:Toggle({
    Title = "Enable Anti AFK",
    Value = true,
    Callback = function(v)
        antiAFK.enabled = v
        if v then antiAFK_start() end
    end
})

SettingsTab:Slider({
    Title = "AFK Tap Interval (sec)",
    Min = 30,
    Max = 180,
    Default = 60,
    Callback = function(v)
        antiAFK.interval = v
    end
})

if antiAFK.enabled then antiAFK_start() end
