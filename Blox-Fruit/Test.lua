local ScriptConfig = select(1, ...) or {
    JoinTeam = "Pirates",
    Translator = true
}

if not game.IsLoaded then
    game.Loaded:Wait()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════

local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalizationService = game:GetService("LocalizationService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- ═══════════════════════════════════════════════════════════════════════════════
-- CORE VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local Camera = workspace.CurrentCamera
local Stepped = RunService.Stepped
local LocalPlayer = Players.LocalPlayer

local PlayerData = LocalPlayer:WaitForChild("Data")
PlayerData:WaitForChild("LastSpawnPoint")
PlayerData:WaitForChild("SpawnPoint")

local Fragments = PlayerData:WaitForChild("Fragments")
local Subclass = PlayerData:WaitForChild("Subclass")
local FruitCap = PlayerData:WaitForChild("FruitCap")
local Level = PlayerData:WaitForChild("Level")
local Beli = PlayerData:WaitForChild("Beli")

local Map = workspace:WaitForChild("Map")
local NPCs = workspace:WaitForChild("NPCs")
local Boats = workspace:WaitForChild("Boats")
local SeaBeasts = workspace:WaitForChild("SeaBeasts")
local Enemies = workspace:WaitForChild("Enemies")
local Characters = workspace:WaitForChild("Characters")
local WorldOrigin = workspace:WaitForChild("_WorldOrigin")
local Locations = WorldOrigin:WaitForChild("Locations")
WorldOrigin:WaitForChild("PlayerSpawns")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local NetModule = Modules:WaitForChild("Net")

local GlobalEnvironment = (getgenv or (getrenv or getfenv))()
local HttpGet = game.HttpGet

-- ═══════════════════════════════════════════════════════════════════════════════
-- SETTINGS & CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════

local FunctionsList = {}
local EnabledOptionsRaw = {}
local Functions = GlobalEnvironment.rz_Functions or {}
local FarmFunctions = GlobalEnvironment.rz_FarmFunctions or {}

local Settings = GlobalEnvironment.rz_Settings or {
    AutoBuso = true,
    BringMobs = true,
    BringDistance = 250,
    FarmMode = "Up",
    FarmTool = "Melee",
    FarmDistance = 15,
    FarmPos = Vector3.new(0, 15, 0),
    SeaSkills = {},
    boatSelected = {},
    fishSelected = {}
}

local EnabledOptions = GlobalEnvironment.rz_EnabledOptions or setmetatable({}, {
    __newindex = function(_, key, value)
        rawset(EnabledOptionsRaw, key, value or nil)
        table.clear(FarmFunctions)
        for _, func in ipairs(Functions) do
            if rawget(EnabledOptionsRaw, func.Name) then
                table.insert(FarmFunctions, func)
            end
        end
    end,
    __index = EnabledOptionsRaw
})

local PlayerGui = LocalPlayer.PlayerGui

-- ═══════════════════════════════════════════════════════════════════════════════
-- TEAM SELECTION
-- ═══════════════════════════════════════════════════════════════════════════════

if not (LocalPlayer.Team or LocalPlayer:FindFirstChild("Main")) then
    local lastAttempt = 0
    
    local function SelectTeam(teamName)
        local chooseTeam = PlayerGui["Main (minimal)"]:WaitForChild("ChooseTeam")
        local team = teamName:find("pirate") and "Pirates" or "Marines"
        local connections = getconnections(chooseTeam.Container[team].Frame.TextButton.Activated)
        for i = 1, #connections do
            connections[i].Function()
        end
    end
    
    while not (LocalPlayer.Team or LocalPlayer:FindFirstChild("Main")) do
        if tick() - lastAttempt >= 0.5 then
            pcall(SelectTeam, string.lower(ScriptConfig.JoinTeam or "Pirates"))
            lastAttempt = tick()
        end
        task.wait()
    end
end

if GlobalEnvironment.redz_hub_error then
    GlobalEnvironment.redz_hub_error:Destroy()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- REPOSITORY CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════

local Repository = {
    Owner = "https://raw.githubusercontent.com/newredz/"
}

-- PERBAIKAN DI SINI: Menggunakan branch yang benar
-- Coba beberapa kemungkinan URL
local PossiblePaths = {
    "main/", -- Branch main biasa
    "master/", -- Branch master
    "bloxfruits/main/", -- Subfolder
    "BloxFruits-Script/main/" -- Nama repo yang berbeda
}

-- Fungsi untuk mencoba berbagai URL
local function TryLoadFromRepository(urlSuffix)
    for _, path in ipairs(PossiblePaths) do
        local testUrl = Repository.Owner .. path .. urlSuffix
        local success, result = pcall(HttpGet, game, testUrl)
        if success and result and #result > 0 then
            Repository.Repository = Repository.Owner .. path
            return result, testUrl
        end
    end
    return nil
end

-- ALTERNATIF: Jika repository sudah tidak ada, gunakan source alternatif
local AlternativeRepositories = {
    "https://raw.githubusercontent.com/REDZ-HUB/BloxFruits/main/",
    "https://raw.githubusercontent.com/redz999/BloxFruits/main/",
    "https://raw.githubusercontent.com/RedzHubOfficial/BloxFruits/main/"
}

local function GetExecutorName()
    return identifyexecutor and identifyexecutor() or "Unknown"
end

local function ThrowError(message)
    GlobalEnvironment.loadedFarm = nil
    GlobalEnvironment.OnFarm = false
    local errorMessage = Instance.new("Message", workspace)
    errorMessage.Text = string.gsub(message, Repository.Owner, "")
    GlobalEnvironment.redz_hub_error = errorMessage
    return error(message, 2)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- HTTP FUNCTIONS (DIPERBAIKI)
-- ═══════════════════════════════════════════════════════════════════════════════

function __httpget(url, _)
    -- Coba repository utama dulu
    for key, value in pairs(Repository) do
        local placeholder = "{" .. key .. "}"
        if url:find(placeholder) then
            url = url:gsub(placeholder, value)
        end
    end
    
    local success, result = pcall(HttpGet, game, url)
    if success then
        return result, url
    end
    
    -- Jika gagal, coba URL alternatif
    if url:find("Functions/Module.lua") then
        for _, altRepo in ipairs(AlternativeRepositories) do
            local altUrl = altRepo .. "Functions/Module.lua"
            success, result = pcall(HttpGet, game, altUrl)
            if success then
                Repository.Repository = altRepo
                return result, altUrl
            end
        end
    end
    
    return ThrowError(("[1] [%s] Failed to load script: %s"):format(GetExecutorName(), url))
end

function __loadstring(url, suffix, args)
    local content, fullUrl = __httpget(url)
    
    if not content then
        return ThrowError(("[2] [%s] No content from: %s"):format(GetExecutorName(), fullUrl or url))
    end
    
    local func, err = loadstring(content .. (suffix or ""))
    
    if type(func) ~= "function" then
        return ThrowError(("[3] [%s] Syntax error: %s\n{{ %s }}"):format(GetExecutorName(), fullUrl or url, err))
    end
    
    local success, result
    if args then
        success, result = pcall(func, unpack(args))
    else
        success, result = pcall(func)
    end
    
    if success then
        return result
    end
    
    if type(result) == "string" then
        warn(("[4] [%s] Execute error: %s\n{{ %s }}"):format(GetExecutorName(), fullUrl or url, result))
    end
    
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- GLOBAL EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

GlobalEnvironment.rz_Functions = Functions
GlobalEnvironment.rz_Settings = Settings
GlobalEnvironment.rz_EnabledOptions = EnabledOptions
GlobalEnvironment.rz_FarmFunctions = FarmFunctions

-- ═══════════════════════════════════════════════════════════════════════════════
-- CONNECTION MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

local Connections = GlobalEnvironment.rz_connections or {}
GlobalEnvironment.rz_connections = Connections

for _, connection in ipairs(Connections) do
    connection:Disconnect()
end
table.clear(Connections)

-- ═══════════════════════════════════════════════════════════════════════════════
-- CORE MODULES (DENGAN FALLBACK)
-- ═══════════════════════════════════════════════════════════════════════════════

local GameModule = nil
local TeleportFunction = nil
local FireRemote = nil

local TeamFunctions = {
    Marines = function()
        if FireRemote then
            FireRemote("SetTeam", "Marines")
        else
            warn("FireRemote belum diinisialisasi")
        end
    end,
    Pirates = function()
        if FireRemote then
            FireRemote("SetTeam", "Pirates")
        else
            warn("FireRemote belum diinisialisasi")
        end
    end
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- BASIC GAME MODULE (FALLBACK JIKA MODULE UTAMA GAGAL)
-- ═══════════════════════════════════════════════════════════════════════════════

local BasicGameModule = {
    IsAlive = function(character)
        if not character then
            character = LocalPlayer.Character
        end
        if not character then return false end
        local humanoid = character:FindFirstChild("Humanoid")
        return humanoid and humanoid.Health > 0
    end,
    
    FireRemote = function(remoteName, ...)
        local remote = Remotes:FindFirstChild(remoteName)
        if remote then
            if remote:IsA("RemoteEvent") then
                return remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                return remote:InvokeServer(...)
            end
        end
        return nil
    end,
    
    EnableBuso = function()
        Remotes:WaitForChild("Buso"):FireServer()
    end,
    
    EquipTool = function(toolType)
        local backpack = LocalPlayer.Backpack
        local character = LocalPlayer.Character
        if not backpack or not character then return nil end
        
        local tools = backpack:GetChildren()
        for _, tool in ipairs(tools) do
            if tool:IsA("Tool") then
                if toolType == "Melee" and (tool.Name:find("Combat") or tool.Name:find("Sword") or tool.Name:find("Katana")) then
                    tool.Parent = character
                    return tool
                elseif toolType == "Sword" and (tool.Name:find("Sword") or tool.Name:find("Katana")) then
                    tool.Parent = character
                    return tool
                end
            end
        end
        
        -- Equip tool pertama jika spesifik tidak ditemukan
        for _, tool in ipairs(tools) do
            if tool:IsA("Tool") then
                tool.Parent = character
                return tool
            end
        end
        return nil
    end,
    
    Rejoin = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
    
    ServerHop = function()
        -- Basic server hop implementation
        local HttpService = game:GetService("HttpService")
        local servers = {}
        
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        
        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
            end
        end
    end
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SIMPLIFIED MANAGER SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local HubCore = {
    Managers = {}
}

local Managers = HubCore.Managers

-- ═══════════════════════════════════════════════════════════════════════════════
-- BASIC TELEPORT FUNCTION
-- ═══════════════════════════════════════════════════════════════════════════════

local function SimpleTeleport(cframe, speed)
    local character = LocalPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = cframe
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION (DIPERBAIKI)
-- ═══════════════════════════════════════════════════════════════════════════════

function HubCore.Initialize(self)
    print("[Redz Hub] Initializing...")
    
    -- Coba load module utama
    local moduleUrl = "{Repository}Functions/Module.lua"
    GameModule = __loadstring(moduleUrl)
    
    -- Jika gagal, gunakan basic module
    if not GameModule then
        warn("[Redz Hub] Failed to load main module, using basic functions")
        GameModule = BasicGameModule
        
        -- Tambahkan beberapa fungsi tambahan
        GameModule.Tween = {
            Velocity = Vector3.zero
        }
        
        GameModule.GameData = {
            Sea = 1 -- Default Sea 1
        }
        
        GameModule.Inventory = {
            Unlocked = {},
            Count = {}
        }
        
        GameModule.EnemyLocations = {}
        GameModule.Enemies = {
            IsSpawned = function(name) return false end,
            GetClosestByTag = function(tag) return nil end,
            GetTagged = function(tag) return {} end
        }
    end
    
    FireRemote = GameModule.FireRemote
    
    -- Initialize basic managers
    Managers.PlayerTeleport = {
        new = SimpleTeleport
    }
    
    TeleportFunction = SimpleTeleport
    
    print("[Redz Hub] Initialization complete")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SIMPLE FARM FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function HubCore.StartFarm(self)
    print("[Redz Hub] Setting up farm functions...")
    
    local function RegisterFunction(name, func)
        ScriptFunctions[name] = func
        table.insert(Functions, {
            Name = name,
            Func = func
        })
    end
    
    -- Basic Level Farm
    RegisterFunction("Level", function()
        local character = LocalPlayer.Character
        if not character then return nil end
        
        -- Find nearest enemy
        local nearestEnemy = nil
        local nearestDistance = math.huge
        
        for _, enemy in ipairs(Enemies:GetChildren()) do
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            if hrp and GameModule.IsAlive(enemy) then
                local distance = (character:GetPivot().Position - hrp.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestEnemy = enemy
                end
            end
        end
        
        if nearestEnemy then
            local hrp = nearestEnemy:FindFirstChild("HumanoidRootPart")
            if hrp then
                SimpleTeleport(hrp.CFrame + Vector3.new(0, 10, 0))
                GameModule.EquipTool("Melee")
                return "Attacking: " .. nearestEnemy.Name
            end
        end
        
        return "Searching for enemies..."
    end)
    
    -- Auto Farm Nearest
    RegisterFunction("Nearest", function()
        return ScriptFunctions.Level()
    end)
    
    -- Auto Haki
    RegisterFunction("AutoHaki", function()
        if Settings.AutoBuso then
            GameModule.EnableBuso()
        end
        return nil
    end)
    
    -- Auto Fruit Collection
    RegisterFunction("Fruits", function()
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Tool") and item.Name:find("Fruit") then
                local handle = item:FindFirstChild("Handle")
                if handle then
                    if LocalPlayer:DistanceFromCharacter(handle.Position) > 5 then
                        SimpleTeleport(handle.CFrame)
                    else
                        -- Pick up the fruit
                        SimpleTeleport(handle.CFrame + Vector3.new(0, 5, 0))
                    end
                    return "Collecting: " .. item.Name
                end
            end
        end
        return "No fruits found"
    end)
    
    -- Chest Collection
    RegisterFunction("Chests", function()
        for _, chest in ipairs(workspace:GetDescendants()) do
            if chest.Name:find("Chest") and chest:IsA("Model") then
                local primary = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                if primary then
                    if LocalPlayer:DistanceFromCharacter(primary.Position) > 5 then
                        SimpleTeleport(primary.CFrame)
                    else
                        SimpleTeleport(primary.CFrame + Vector3.new(0, 5, 0))
                    end
                    return "Opening chest"
                end
            end
        end
        return "No chests found"
    end)
    
    print("[Redz Hub] Farm functions setup complete")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- START FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function HubCore.StartFunctions(self)
    GlobalEnvironment.OnFarm = true
    GlobalEnvironment.loadedFarm = true
    
    print("[Redz Hub] Starting farm loop...")
    
    local lastUpdate = 0
    
    table.insert(Connections, Stepped:Connect(function()
        if not GlobalEnvironment.OnFarm then
            return
        end
        
        if tick() - lastUpdate < 0.2 then
            return
        end
        lastUpdate = tick()
        
        -- Run auto haki first
        if Settings.AutoBuso then
            GameModule.EnableBuso()
        end
        
        -- Run enabled farm functions
        for _, funcData in ipairs(FarmFunctions) do
            if EnabledOptions[funcData.Name] then
                local success, result = pcall(funcData.Func)
                if success and result then
                    break
                end
            end
        end
    end))
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SIMPLE UI BUILDER
-- ═══════════════════════════════════════════════════════════════════════════════

function HubCore.LoadLibrary(self)
    print("[Redz Hub] Creating simple UI...")
    
    -- Buat UI sederhana jika library gagal load
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedzHubUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "Redz Hub - Blox Fruits"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Text = "X"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 0
    ScrollFrame.Parent = TabContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ScrollFrame
    
    -- Fungsi untuk membuat toggle
    local function CreateToggle(title, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = title .. "Toggle"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Parent = ScrollFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "Button"
        ToggleButton.Size = UDim2.new(0, 50, 0, 30)
        ToggleButton.Position = UDim2.new(1, -60, 0, 0)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        ToggleButton.Text = default and "ON" or "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.TextSize = 14
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Parent = ToggleFrame
        
        local ToggleUICorner = Instance.new("UICorner")
        ToggleUICorner.CornerRadius = UDim.new(0, 4)
        ToggleUICorner.Parent = ToggleButton
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "Label"
        ToggleLabel.Text = title
        ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextSize = 16
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        ToggleButton.MouseButton1Click:Connect(function()
            local newState = not (ToggleButton.Text == "ON")
            ToggleButton.Text = newState and "ON" or "OFF"
            ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            
            if callback then
                callback(newState)
            end
        end)
        
        if callback then
            callback(default)
        end
    end
    
    -- Fungsi untuk membuat button
    local function CreateButton(title, callback)
        local Button = Instance.new("TextButton")
        Button.Name = title .. "Button"
        Button.Text = title
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 16
        Button.Font = Enum.Font.GothamBold
        Button.Parent = ScrollFrame
        
        local ButtonUICorner = Instance.new("UICorner")
        ButtonUICorner.CornerRadius = UDim.new(0, 6)
        ButtonUICorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
    end
    
    -- Buat elemen UI
    CreateToggle("Auto Level", false, function(value)
        EnabledOptions.Level = value
    end)
    
    CreateToggle("Auto Farm Nearest", false, function(value)
        EnabledOptions.Nearest = value
    end)
    
    CreateToggle("Auto Buso Haki", true, function(value)
        Settings.AutoBuso = value
    end)
    
    CreateToggle("Auto Collect Fruits", false, function(value)
        EnabledOptions.Fruits = value
    end)
    
    CreateToggle("Auto Collect Chests", false, function(value)
        EnabledOptions.Chests = value
    end)
    
    CreateButton("Join Pirates", TeamFunctions.Pirates)
    CreateButton("Join Marines", TeamFunctions.Marines)
    
    CreateButton("Remove Fog", function()
        if Lighting:FindFirstChild("LightingLayers") then
            Lighting.LightingLayers:Remove()
        end
    end)
    
    CreateButton("Redeem All Codes", function()
        local codes = {
            "KITT_RESET", "SUB2GAMERROBOT_EXP1", "Sub2OfficialNoobie",
            "THEGREATACE", "SUB2NOOBMASTER123", "Axiore",
            "TantaiGaming", "STRAWHATMAINE"
        }
        
        for _, code in ipairs(codes) do
            Remotes.Redeem:InvokeServer(code)
            task.wait(0.5)
        end
    end)
    
    CreateButton("Server Hop", function()
        GameModule.ServerHop()
    end)
    
    CreateButton("Rejoin", function()
        GameModule.Rejoin()
    end)
    
    -- Update UI size
    task.wait()
    local totalHeight = 0
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 10
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    
    print("[Redz Hub] UI created successfully")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- EXECUTION
-- ═══════════════════════════════════════════════════════════════════════════════

-- Fungsi utama yang aman
local function SafeExecute(moduleName, ...)
    local success, err = pcall(function()
        HubCore[moduleName](HubCore, ...)
    end)
    
    if not success then
        warn("[Redz Hub] Error in " .. moduleName .. ": " .. tostring(err))
    else
        print("[Redz Hub] " .. moduleName .. " loaded successfully")
    end
end

-- Eksekusi dengan error handling
SafeExecute("Initialize")
SafeExecute("StartFarm")
SafeExecute("StartFunctions")
SafeExecute("LoadLibrary")

print([[

╔══════════════════════════════════════════╗
║        Redz Hub Loaded Successfully      ║
║              Blox Fruits                 ║
║                                          ║
║  Basic Features Available:               ║
║  • Auto Level Farm                       ║
║  • Auto Buso Haki                        ║
║  • Fruit Collection                      ║
║  • Chest Collection                      ║
║  • Team Selection                        ║
║  • Basic Utilities                       ║
╚══════════════════════════════════════════╝

]])
