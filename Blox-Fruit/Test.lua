-- ═══════════════════════════════════════════════════════════════════════════════
-- AUTO FARM BLOX FRUITS - REDZ HUB V2
-- ═══════════════════════════════════════════════════════════════════════════════

-- Konfigurasi
local Config = {
    AutoTeam = "Pirates", -- "Pirates" atau "Marines"
    AutoBuso = true,
    BringMobs = true,
    BringDistance = 250,
    FarmDistance = 15,
    FarmMode = "Up", -- "Up", "Star"
    AutoClick = true,
    TweenSpeed = 200,
    AutoCollectFruits = true,
    AutoCollectChests = true,
    AutoRedeemCodes = true,
    RemoveFog = true
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

-- ═══════════════════════════════════════════════════════════════════════════════
-- VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local Map = Workspace:WaitForChild("Map")
local Enemies = Workspace:WaitForChild("Enemies")
local NPCs = Workspace:WaitForChild("NPCs")
local Boats = Workspace:WaitForChild("Boats")
local SeaBeasts = Workspace:WaitForChild("SeaBeasts")

local PlayerData = LocalPlayer:WaitForChild("Data")
local Level = PlayerData:WaitForChild("Level")
local Beli = PlayerData:WaitForChild("Beli")
local Fragments = PlayerData:WaitForChild("Fragments")
local FruitCap = PlayerData:WaitForChild("FruitCap")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- ═══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Fungsi aman untuk mendapatkan child
local function SafeFind(parent, childName, waitTime)
    waitTime = waitTime or 5
    local startTime = tick()
    
    while tick() - startTime < waitTime do
        local child = parent:FindFirstChild(childName)
        if child then
            return child
        end
        task.wait(0.1)
    end
    return parent:FindFirstChild(childName)
end

-- Fire remote dengan safety
local function FireRemote(remoteName, ...)
    local remote = SafeFind(Remotes, remoteName)
    if remote then
        if remote:IsA("RemoteEvent") then
            return remote:FireServer(...)
        elseif remote:IsA("RemoteFunction") then
            return remote:InvokeServer(...)
        end
    end
    return nil
end

-- Teleport dengan safety
local function TeleportTo(cframe)
    if not Character or not HRP then return end
    
    local humanoid = Character:FindFirstChild("Humanoid")
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
        task.wait(0.2)
    end
    
    if HRP then
        HRP.CFrame = cframe
    end
end

-- Tween teleport untuk animasi halus
local function TweenTeleport(targetCFrame, speed)
    if not Character or not HRP then return end
    
    speed = speed or Config.TweenSpeed
    local distance = (HRP.Position - targetCFrame.Position).Magnitude
    local travelTime = distance / speed
    
    if travelTime > 0.5 then
        -- Gunakan tweening untuk jarak jauh
        local tweenInfo = TweenInfo.new(travelTime, Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(HRP, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
    else
        -- Teleport langsung untuk jarak dekat
        TeleportTo(targetCFrame)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- AUTO TEAM SELECTION
-- ═══════════════════════════════════════════════════════════════════════════════

if not LocalPlayer.Team then
    task.spawn(function()
        task.wait(2)
        
        local PlayerGui = LocalPlayer.PlayerGui
        local MainUI = SafeFind(PlayerGui, "Main (minimal)")
        
        if MainUI then
            local ChooseTeam = SafeFind(MainUI, "ChooseTeam")
            if ChooseTeam then
                local teamButton = SafeFind(ChooseTeam.Container, Config.AutoTeam)
                if teamButton then
                    local textButton = SafeFind(teamButton.Frame, "TextButton")
                    if textButton then
                        fireclickdetector(textButton:FindFirstChildWhichIsA("ClickDetector") or textButton)
                    end
                end
            end
        end
        
        -- Alternatif menggunakan remote
        if not LocalPlayer.Team then
            FireRemote("SetTeam", Config.AutoTeam)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMBAT FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Enable Buso Haki
local function EnableBuso()
    if Config.AutoBuso then
        FireRemote("Buso")
    end
end

-- Equip best tool
local function EquipBestTool()
    local backpack = LocalPlayer.Backpack
    if not backpack then return nil end
    
    local bestTool = nil
    local bestPriority = 0
    
    -- Prioritas tool
    local toolPriorities = {
        ["Melee"] = 100,
        ["Sword"] = 90,
        ["Gun"] = 80,
        ["Blox Fruit"] = 70,
        ["Tool"] = 50
    }
    
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local priority = 10 -- Default priority
            
            for name, value in pairs(toolPriorities) do
                if tool.Name:find(name) then
                    priority = value
                    break
                end
            end
            
            if priority > bestPriority then
                bestPriority = priority
                bestTool = tool
            end
        end
    end
    
    if bestTool then
        bestTool.Parent = Character
        return bestTool
    end
    
    return nil
end

-- Auto attack
local function AutoAttack(distance)
    distance = distance or Config.FarmDistance
    
    local tool = Character:FindFirstChildWhichIsA("Tool")
    if not tool then
        tool = EquipBestTool()
    end
    
    if tool and Config.AutoClick then
        tool:Activate()
    end
    
    -- Attack semua musuh dalam jarak
    for _, enemy in ipairs(Enemies:GetChildren()) do
        local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
        local enemyHumanoid = enemy:FindFirstChild("Humanoid")
        
        if enemyHRP and enemyHumanoid and enemyHumanoid.Health > 0 then
            local dist = (HRP.Position - enemyHRP.Position).Magnitude
            if dist <= distance then
                -- Facing enemy
                HRP.CFrame = CFrame.lookAt(HRP.Position, enemyHRP.Position)
                
                -- Use skills if available
                if tool and tool:FindFirstChild("Attack") then
                    tool.Attack:FireServer(enemyHRP.Position)
                end
            end
        end
    end
end

-- Bring mobs together
local function BringMobs(mainEnemy, distance)
    if not Config.BringMobs or not mainEnemy then return end
    
    local mainHRP = mainEnemy:FindFirstChild("HumanoidRootPart")
    if not mainHRP then return end
    
    distance = distance or Config.BringDistance
    
    for _, enemy in ipairs(Enemies:GetChildren()) do
        if enemy ~= mainEnemy then
            local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
            local enemyHumanoid = enemy:FindFirstChild("Humanoid")
            
            if enemyHRP and enemyHumanoid and enemyHumanoid.Health > 0 then
                local dist = (mainHRP.Position - enemyHRP.Position).Magnitude
                if dist <= distance then
                    enemyHRP.CFrame = mainHRP.CFrame
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- FARMING FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Get nearest enemy
local function GetNearestEnemy(maxDistance)
    maxDistance = maxDistance or 1000
    local nearest = nil
    local nearestDist = maxDistance
    
    for _, enemy in ipairs(Enemies:GetChildren()) do
        local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
        local enemyHumanoid = enemy:FindFirstChild("Humanoid")
        
        if enemyHRP and enemyHumanoid and enemyHumanoid.Health > 0 then
            local distance = (HRP.Position - enemyHRP.Position).Magnitude
            if distance < nearestDist then
                nearest = enemy
                nearestDist = distance
            end
        end
    end
    
    return nearest, nearestDist
end

-- Farm enemy
local function FarmEnemy(enemy)
    if not enemy then return false end
    
    local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
    if not enemyHRP then return false end
    
    -- Posisi farm berdasarkan mode
    local farmPos
    if Config.FarmMode == "Star" then
        farmPos = enemyHRP.CFrame * CFrame.new(0, Config.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    else -- "Up"
        farmPos = enemyHRP.CFrame + Vector3.new(0, Config.FarmDistance, 0)
    end
    
    -- Teleport to enemy
    TweenTeleport(farmPos)
    
    -- Enable buso
    EnableBuso()
    
    -- Bring mobs
    BringMobs(enemy)
    
    -- Auto attack
    AutoAttack(Config.FarmDistance)
    
    return true
end

-- Auto level farm
local function AutoLevelFarm()
    while true do
        task.wait(0.5)
        
        -- Cek karakter hidup
        if not Character or not Humanoid or Humanoid.Health <= 0 then
            Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            Humanoid = Character:WaitForChild("Humanoid")
            HRP = Character:WaitForChild("HumanoidRootPart")
            task.wait(1)
        end
        
        -- Cari musuh terdekat
        local nearestEnemy, distance = GetNearestEnemy(500)
        
        if nearestEnemy then
            FarmEnemy(nearestEnemy)
        else
            -- Jika tidak ada musuh, cari spawn point
            local questNPCs = {
                "Bandit",
                "Monkey",
                "Gorilla",
                "Pirate",
                "Brute",
                "Desert Bandit",
                "Desert Officer",
                "Snow Bandit",
                "Snowman",
                "Chief Petty Officer",
                "Sky Bandit",
                "Dark Master"
            }
            
            for _, npcName in ipairs(questNPCs) do
                local npc = SafeFind(NPCs, npcName)
                if npc then
                    local npcHRP = npc:FindFirstChild("HumanoidRootPart")
                    if npcHRP then
                        TweenTeleport(npcHRP.CFrame * CFrame.new(0, 0, -5))
                        task.wait(1)
                        break
                    end
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- COLLECTION FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Collect fruits
local function CollectFruits()
    if not Config.AutoCollectFruits then return end
    
    for _, item in ipairs(Workspace:GetDescendants()) do
        if item:IsA("Tool") and item.Name:find("Fruit") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                local distance = (HRP.Position - handle.Position).Magnitude
                if distance < 100 then
                    TweenTeleport(handle.CFrame)
                    task.wait(0.5)
                end
            end
        end
    end
end

-- Collect chests
local function CollectChests()
    if not Config.AutoCollectChests then return end
    
    for _, chest in ipairs(Workspace:GetDescendants()) do
        if chest.Name:find("Chest") and chest:IsA("Model") then
            local primary = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
            if primary then
                local distance = (HRP.Position - primary.Position).Magnitude
                if distance < 100 then
                    TweenTeleport(primary.CFrame * CFrame.new(0, 0, -2))
                    task.wait(0.5)
                    
                    -- Try to open chest
                    local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- QUEST SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

-- Get current quest
local function GetCurrentQuest()
    local PlayerGui = LocalPlayer.PlayerGui
    local MainUI = SafeFind(PlayerGui, "Main")
    
    if MainUI then
        local QuestUI = SafeFind(MainUI, "Quest")
        if QuestUI and QuestUI.Container.Visible then
            local questTitle = SafeFind(QuestUI.Container.QuestTitle, "Title")
            if questTitle then
                return questTitle.Text
            end
        end
    end
    
    return nil
end

-- Start quest from NPC
local function StartQuest(npcName)
    local npc = SafeFind(NPCs, npcName)
    if not npc then return false end
    
    local npcHRP = npc:FindFirstChild("HumanoidRootPart")
    if not npcHRP then return false end
    
    -- Go to NPC
    TweenTeleport(npcHRP.CFrame * CFrame.new(0, 0, -5))
    task.wait(1)
    
    -- Start quest
    FireRemote("StartQuest", npcName, 1)
    
    return true
end

-- Auto quest berdasarkan level
local function AutoQuest()
    local level = Level.Value
    
    if level < 10 then
        StartQuest("Bandit")
    elseif level < 20 then
        StartQuest("Monkey")
    elseif level < 40 then
        StartQuest("Gorilla")
    elseif level < 60 then
        StartQuest("Pirate")
    elseif level < 90 then
        StartQuest("Brute")
    elseif level < 120 then
        StartQuest("Desert Bandit")
    elseif level < 150 then
        StartQuest("Desert Officer")
    elseif level < 190 then
        StartQuest("Snow Bandit")
    elseif level < 240 then
        StartQuest("Snowman")
    elseif level < 280 then
        StartQuest("Chief Petty Officer")
    elseif level < 330 then
        StartQuest("Sky Bandit")
    elseif level < 380 then
        StartQuest("Dark Master")
    else
        -- Level tinggi, cari quest yang sesuai
        local currentQuest = GetCurrentQuest()
        if not currentQuest then
            -- Coba quest boss
            StartQuest("Saber Expert")
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- UTILITIES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Redeem codes
local function RedeemCodes()
    if not Config.AutoRedeemCodes then return end
    
    local codes = {
        "KITT_RESET",
        "SUB2GAMERROBOT_EXP1",
        "Sub2OfficialNoobie",
        "THEGREATACE",
        "SUB2NOOBMASTER123",
        "Axiore",
        "TantaiGaming",
        "STRAWHATMAINE",
        "SUB2CAPTAINMAUI",
        "SUB2UNCLEKIZARU",
        "Sub2Daigrock",
        "Axiore",
        "TantaiGaming",
        "StrawHatMaine",
        "Sub2Fer999",
        "Enyu_is_Pro",
        "Magicbus",
        "JCWK",
        "Starcodeheo",
        "Bluxxy"
    }
    
    for _, code in ipairs(codes) do
        FireRemote("Redeem", code)
        task.wait(0.5)
    end
end

-- Remove fog
local function RemoveFog()
    if Config.RemoveFog then
        if Lighting:FindFirstChild("LightingLayers") then
            Lighting.LightingLayers:Destroy()
        end
        
        -- Set clear atmosphere
        Lighting.FogEnd = 100000
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end

-- Server hop
local function ServerHop()
    local servers = {}
    local maxAttempts = 10
    
    for attempt = 1, maxAttempts do
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            ))
        end)
        
        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
                return
            end
        end
        
        task.wait(1)
    end
    
    warn("Failed to find available server")
end

-- Rejoin
local function Rejoin()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- UI SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedzHubUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Shadow
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(50, 50, 50)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    TopBarCorner.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "⚔️ REDZ HUB - BLOX FRUITS ⚔️"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Text = "✕"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0.5, -17.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 1, -65)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    -- Scroll Frame
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 5
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    ScrollFrame.Parent = TabContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ScrollFrame
    
    -- Variables untuk menyimpan toggle states
    local ToggleStates = {}
    
    -- Fungsi membuat toggle
    local function CreateToggle(title, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = title .. "ToggleFrame"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Parent = ScrollFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 60, 0, 30)
        ToggleButton.Position = UDim2.new(1, -65, 0.5, -15)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        ToggleButton.Text = default and "ON" or "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.TextSize = 14
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Parent = ToggleFrame
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = ToggleButton
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "ToggleLabel"
        ToggleLabel.Text = title
        ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        ToggleLabel.TextSize = 16
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame
        
        ToggleStates[title] = default
        
        ToggleButton.MouseButton1Click:Connect(function()
            local newState = not ToggleStates[title]
            ToggleStates[title] = newState
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
    
    -- Fungsi membuat button
    local function CreateButton(title, callback)
        local Button = Instance.new("TextButton")
        Button.Name = title .. "Button"
        Button.Text = title
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 16
        Button.Font = Enum.Font.GothamBold
        Button.Parent = ScrollFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
    end
    
    -- Fungsi membuat slider
    local function CreateSlider(title, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = title .. "SliderFrame"
        SliderFrame.Size = UDim2.new(1, 0, 0, 60)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = ScrollFrame
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Name = "SliderLabel"
        SliderLabel.Text = title .. ": " .. default
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.Position = UDim2.new(0, 0, 0, 0)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        SliderLabel.TextSize = 16
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame
        
        local SliderBackground = Instance.new("Frame")
        SliderBackground.Name = "SliderBackground"
        SliderBackground.Size = UDim2.new(1, 0, 0, 25)
        SliderBackground.Position = UDim2.new(0, 0, 0, 25)
        SliderBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SliderBackground.BorderSizePixel = 0
        SliderBackground.Parent = SliderFrame
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 6)
        SliderCorner.Parent = SliderBackground
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "SliderFill"
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBackground
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(0, 6)
        SliderFillCorner.Parent = SliderFill
        
        local SliderButton = Instance.new("TextButton")
        SliderButton.Name = "SliderButton"
        SliderButton.Size = UDim2.new(0, 30, 0, 30)
        SliderButton.Position = UDim2.new((default - min) / (max - min), -15, 0.5, -15)
        SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderButton.Text = ""
        SliderButton.Parent = SliderBackground
        
        local SliderButtonCorner = Instance.new("UICorner")
        SliderButtonCorner.CornerRadius = UDim.new(0, 15)
        SliderButtonCorner.Parent = SliderButton
        
        local dragging = false
        
        local function UpdateSlider(value)
            value = math.clamp(value, min, max)
            SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            SliderButton.Position = UDim2.new((value - min) / (max - min), -15, 0.5, -15)
            SliderLabel.Text = title .. ": " .. math.floor(value)
            
            if callback then
                callback(value)
            end
        end
        
        SliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        SliderBackground.MouseButton1Down:Connect(function(x, y)
            local relativeX = x - SliderBackground.AbsolutePosition.X
            local percentage = relativeX / SliderBackground.AbsoluteSize.X
            local value = min + (max - min) * percentage
            UpdateSlider(value)
        end)
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if dragging then
                local mouse = game:GetService("UserInputService"):GetMouseLocation()
                local relativeX = mouse.X - SliderBackground.AbsolutePosition.X
                local percentage = math.clamp(relativeX / SliderBackground.AbsoluteSize.X, 0, 1)
                local value = min + (max - min) * percentage
                UpdateSlider(value)
            end
        end)
        
        UpdateSlider(default)
    end
    
    -- Header
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Text = "⚡ AUTO FARM SETTINGS ⚡"
    HeaderLabel.Size = UDim2.new(1, 0, 0, 30)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    HeaderLabel.TextSize = 18
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.Parent = ScrollFrame
    
    -- Farm Toggles
    CreateToggle("Auto Level Farm", false, function(value)
        if value then
            task.spawn(AutoLevelFarm)
        else
            -- Stop farm logic here if needed
        end
    end)
    
    CreateToggle("Auto Buso Haki", Config.AutoBuso, function(value)
        Config.AutoBuso = value
    end)
    
    CreateToggle("Bring Mobs", Config.BringMobs, function(value)
        Config.BringMobs = value
    end)
    
    CreateToggle("Auto Click", Config.AutoClick, function(value)
        Config.AutoClick = value
    end)
    
    CreateToggle("Collect Fruits", Config.AutoCollectFruits, function(value)
        Config.AutoCollectFruits = value
    end)
    
    CreateToggle("Collect Chests", Config.AutoCollectChests, function(value)
        Config.AutoCollectChests = value
    end)
    
    -- Sliders
    CreateSlider("Bring Distance", 50, 500, Config.BringDistance, function(value)
        Config.BringDistance = value
    end)
    
    CreateSlider("Farm Distance", 5, 30, Config.FarmDistance, function(value)
        Config.FarmDistance = value
    end)
    
    CreateSlider("Tween Speed", 50, 300, Config.TweenSpeed, function(value)
        Config.TweenSpeed = value
    end)
    
    -- Divider
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 2)
    Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Divider.BorderSizePixel = 0
    Divider.Parent = ScrollFrame
    
    -- Utilities Header
    local UtilHeader = Instance.new("TextLabel")
    UtilHeader.Text = "🔧 UTILITIES 🔧"
    UtilHeader.Size = UDim2.new(1, 0, 0, 30)
    UtilHeader.BackgroundTransparency = 1
    UtilHeader.TextColor3 = Color3.fromRGB(0, 200, 255)
    UtilHeader.TextSize = 18
    UtilHeader.Font = Enum.Font.GothamBold
    UtilHeader.Parent = ScrollFrame
    
    -- Utility Buttons
    CreateButton("Redeem All Codes", RedeemCodes)
    CreateButton("Remove Fog", RemoveFog)
    CreateButton("Join Pirates", function()
        FireRemote("SetTeam", "Pirates")
    end)
    
    CreateButton("Join Marines", function()
        FireRemote("SetTeam", "Marines")
    end)
    
    CreateButton("Server Hop", ServerHop)
    CreateButton("Rejoin", Rejoin)
    
    -- Stats Display
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Name = "StatsFrame"
    StatsFrame.Size = UDim2.new(1, 0, 0, 60)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = ScrollFrame
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 8)
    StatsCorner.Parent = StatsFrame
    
    local LevelLabel = Instance.new("TextLabel")
    LevelLabel.Name = "LevelLabel"
    LevelLabel.Text = "Level: 0"
    LevelLabel.Size = UDim2.new(0.5, -5, 0.5, -5)
    LevelLabel.Position = UDim2.new(0, 10, 0, 5)
    LevelLabel.BackgroundTransparency = 1
    LevelLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    LevelLabel.TextSize = 16
    LevelLabel.Font = Enum.Font.GothamBold
    LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
    LevelLabel.Parent = StatsFrame
    
    local BeliLabel = Instance.new("TextLabel")
    BeliLabel.Name = "BeliLabel"
    BeliLabel.Text = "Beli: 0"
    BeliLabel.Size = UDim2.new(0.5, -5, 0.5, -5)
    BeliLabel.Position = UDim2.new(0.5, 5, 0, 5)
    BeliLabel.BackgroundTransparency = 1
    BeliLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    BeliLabel.TextSize = 16
    BeliLabel.Font = Enum.Font.GothamBold
    BeliLabel.TextXAlignment = Enum.TextXAlignment.Left
    BeliLabel.Parent = StatsFrame
    
    local FragmentsLabel = Instance.new("TextLabel")
    FragmentsLabel.Name = "FragmentsLabel"
    FragmentsLabel.Text = "Fragments: 0"
    FragmentsLabel.Size = UDim2.new(0.5, -5, 0.5, -5)
    FragmentsLabel.Position = UDim2.new(0, 10, 0.5, 5)
    FragmentsLabel.BackgroundTransparency = 1
    FragmentsLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
    FragmentsLabel.TextSize = 16
    FragmentsLabel.Font = Enum.Font.GothamBold
    FragmentsLabel.TextXAlignment = Enum.TextXAlignment.Left
    FragmentsLabel.Parent = StatsFrame
    
    local FruitCapLabel = Instance.new("TextLabel")
    FruitCapLabel.Name = "FruitCapLabel"
    FruitCapLabel.Text = "Fruit Cap: 0"
    FruitCapLabel.Size = UDim2.new(0.5, -5, 0.5, -5)
    FruitCapLabel.Position = UDim2.new(0.5, 5, 0.5, 5)
    FruitCapLabel.BackgroundTransparency = 1
    FruitCapLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    FruitCapLabel.TextSize = 16
    FruitCapLabel.Font = Enum.Font.GothamBold
    FruitCapLabel.TextXAlignment = Enum.TextXAlignment.Left
    FruitCapLabel.Parent = StatsFrame
    
    -- Update stats
    task.spawn(function()
        while ScreenGui.Parent do
            LevelLabel.Text = "Level: " .. Level.Value
            BeliLabel.Text = "Beli: " .. Beli.Value
            FragmentsLabel.Text = "Fragments: " .. Fragments.Value
            FruitCapLabel.Text = "Fruit Cap: " .. FruitCap.Value
            
            -- Run collection functions
            if Config.AutoCollectFruits then
                CollectFruits()
            end
            
            if Config.AutoCollectChests then
                CollectChests()
            end
            
            task.wait(1)
        end
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
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    return ScreenGui
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

print([[
    ╔══════════════════════════════════════════╗
    ║        REDZ HUB V2 - BLOX FRUITS         ║
    ║            Loaded Successfully           ║
    ╠══════════════════════════════════════════╣
    ║ Features:                                ║
    ║ • Auto Level Farm                        ║
    ║ • Auto Buso Haki                         ║
    ║ • Mob Bring System                       ║
    ║ • Auto Click Attack                      ║
    ║ • Fruit & Chest Collection               ║
    ║ • Smart Teleport System                  ║
    ║ • Quest Automation                       ║
    ║ • Code Redeemer                          ║
    ║ • Server Hopper                          ║
    ║ • Beautiful UI                           ║
    ╚══════════════════════════════════════════╝
]])

-- Create UI
local UI = CreateUI()

-- Auto redeem codes on start
task.wait(3)
RedeemCodes()

-- Remove fog on start
RemoveFog()

print("Redz Hub V2 ready! Press F9 to open UI.")

-- Keybind to toggle UI (F9)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F9 then
        UI.Enabled = not UI.Enabled
    end
end)

-- Auto reconnect when character dies
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HRP = newChar:WaitForChild("HumanoidRootPart")
    
    task.wait(1)
    print("Character respawned, resuming farm...")
end)
