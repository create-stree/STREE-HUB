local success, StreeHub = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()
end)

if not success or not StreeHub then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = StreeHub:Window({
    Title   = "High Hub |",
    Footer  = "Blox Fruits",
    Images  = "139538383104637",
    Color   = Color3.fromRGB(138, 43, 226),
    Theme   = 122376116281975,
    ThemeTransparency = 0.15,
    ["Tab Width"] = 120,
    Version = 1,
})

local function notify(msg, duration, color, title, subtitle)
    pcall(function()
        StreeHub:Notify({
            Title    = title    or "High Hub",
            Content  = msg,
            SubTitle = subtitle or "Blox Fruits",
            Duration = duration or 3,
            Color    = color    or Color3.fromRGB(138, 43, 226),
        })
    end)
end

local Tabs = {
    Main = Window:AddTab({ Name = "Main", Icon = "home" }),
    Others = Window:AddTab({ Name = "Others", Icon = "inbox" }),
    Items = Window:AddTab({ Name = "Items", Icon = "box" }),
    Settings = Window:AddTab({ Name = "Settings", Icon = "settings" }),
    LocalPlayer = Window:AddTab({ Name = "Local Player", Icon = "user" }),
    Stats = Window:AddTab({ Name = "Stats", Icon = "bar-chart" }),
    SeaEvent = Window:AddTab({ Name = "Sea Event", Icon = "anchor" }),
    SeaStack = Window:AddTab({ Name = "Sea Stack", Icon = "waves" }),
    DragonDojo = Window:AddTab({ Name = "Dragon Dojo", Icon = "shield" }),
    Race = Window:AddTab({ Name = "Race", Icon = "bot" }),
    Combat = Window:AddTab({ Name = "Combat", Icon = "sword" }),
    Raid = Window:AddTab({ Name = "Raid", Icon = "zap" }),
    ESP = Window:AddTab({ Name = "ESP", Icon = "eye" }),
    Teleport = Window:AddTab({ Name = "Teleport", Icon = "map" }),
    Shop = Window:AddTab({ Name = "Shop", Icon = "shopping-cart" }),
    Fruit = Window:AddTab({ Name = "Fruit", Icon = "flask-conical" }),
    Misc = Window:AddTab({ Name = "Misc", Icon = "layout-grid" }),
    Server = Window:AddTab({ Name = "Server", Icon = "server" }),
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

_G.Settings = {
    AutoFarm = false,
    AutoFarmLevel = false,
    AutoBoss = false,
    AutoNewWorld = false,
    AutoThirdWorld = false,
    AutoSeaBeast = false,
    AutoPiranha = false,
    AutoShark = false,
    AutoTerrorShark = false,
    AutoMastery = false,
    AutoMasteryDevilFruit = false,
    AutoMasteryGun = false,
    AutoObservationHaki = false,
    AutoEnhancement = false,
    AutoSecondSea = false,
    AutoThirdSea = false,
    AutoFarmMaterial = false,
    AutoBone = false,
    AutoCake = false,
    AutoDough = false,
    AutoRaidBoss = false,
}

local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChild("Humanoid")
end

local MainSection = Tabs.Main:AddSection("High Hub | Main Farm")

MainSection:AddParagraph({
    Title = "Welcome to High Hub",
    Content = "Premium Blox Fruits script with advanced features!",
    Icon = "star",
})

MainSection:AddToggle({
    Title = "Auto Farm Level",
    Content = "Automatically farm mobs for leveling",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoFarmLevel = state
        notify("Auto Farm Level: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.AutoFarmLevel do
                    pcall(function()
                        local root = getRoot()
                        if root then
                            for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                                    if mobRoot then
                                        root.CFrame = mobRoot.CFrame * CFrame.new(0, 30, 0)
                                        pcall(function()
                                            ReplicatedStorage.Remotes.CommF_:InvokeServer("weaponequip")
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

MainSection:AddToggle({
    Title = "Auto Farm Boss",
    Content = "Automatically farm boss enemies",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoBoss = state
        notify("Auto Farm Boss: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.AutoBoss do
                    pcall(function()
                        local root = getRoot()
                        if root then
                            for _, boss in pairs(Workspace.Enemies:GetChildren()) do
                                if boss.Name:find("Boss") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                                    local bossRoot = boss:FindFirstChild("HumanoidRootPart")
                                    if bossRoot then
                                        root.CFrame = bossRoot.CFrame * CFrame.new(0, 30, 0)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local MasterySection = Tabs.Main:AddSection("High Hub | Mastery Farm")

MasterySection:AddToggle({
    Title = "Auto Farm Mastery",
    Content = "Farm mastery for equipped weapon",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoMastery = state
        notify("Auto Mastery: " .. (state and "ON" or "OFF"))
    end
})

MasterySection:AddToggle({
    Title = "Auto Farm Gun Mastery",
    Content = "Farm mastery for guns",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoMasteryGun = state
        notify("Auto Gun Mastery: " .. (state and "ON" or "OFF"))
    end
})

MasterySection:AddToggle({
    Title = "Auto Farm Devil Fruit Mastery",
    Content = "Farm mastery for devil fruits",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoMasteryDevilFruit = state
        notify("Auto Devil Fruit Mastery: " .. (state and "ON" or "OFF"))
    end
})

local SeaSection = Tabs.SeaEvent:AddSection("High Hub | Sea Event")

SeaSection:AddToggle({
    Title = "Auto Farm Sea Beast",
    Content = "Automatically hunt Sea Beasts",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoSeaBeast = state
        notify("Auto Sea Beast: " .. (state and "ON" or "OFF"))
    end
})

SeaSection:AddToggle({
    Title = "Auto Farm Piranha",
    Content = "Farm Piranha enemies",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoPiranha = state
        notify("Auto Piranha: " .. (state and "ON" or "OFF"))
    end
})

SeaSection:AddToggle({
    Title = "Auto Farm Shark",
    Content = "Farm Shark enemies",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoShark = state
        notify("Auto Shark: " .. (state and "ON" or "OFF"))
    end
})

SeaSection:AddToggle({
    Title = "Auto Farm Terror Shark",
    Content = "Farm Terror Shark boss",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoTerrorShark = state
        notify("Auto Terror Shark: " .. (state and "ON" or "OFF"))
    end
})

local MaterialSection = Tabs.Items:AddSection("High Hub | Material Farm")

MaterialSection:AddToggle({
    Title = "Auto Farm Material",
    Content = "Farm materials automatically",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoFarmMaterial = state
        notify("Auto Material: " .. (state and "ON" or "OFF"))
    end
})

MaterialSection:AddToggle({
    Title = "Auto Farm Bone",
    Content = "Farm bones in Third Sea",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoBone = state
        notify("Auto Bone: " .. (state and "ON" or "OFF"))
    end
})

MaterialSection:AddToggle({
    Title = "Auto Farm Cake",
    Content = "Farm Cake Prince",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoCake = state
        notify("Auto Cake: " .. (state and "ON" or "OFF"))
    end
})

local StatsSection = Tabs.Stats:AddSection("High Hub | Auto Stats")

local selectedStat = "Melee"

StatsSection:AddDropdown({
    Title = "Select Stat",
    Content = "Choose which stat to upgrade",
    Options = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Callback = function(value)
        selectedStat = value
        notify("Selected stat: " .. value)
    end
})

StatsSection:AddToggle({
    Title = "Auto Stats",
    Content = "Automatically upgrade selected stat",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoStats = state
        notify("Auto Stats: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.AutoStats do
                    pcall(function()
                        local statMap = {
                            ["Melee"] = "Melee",
                            ["Defense"] = "Defense",
                            ["Sword"] = "Sword",
                            ["Gun"] = "Gun",
                            ["Blox Fruit"] = "Demon Fruit"
                        }
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", statMap[selectedStat], 1)
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local PlayerSection = Tabs.LocalPlayer:AddSection("High Hub | Player")

local walkSpeed = 16
local jumpPower = 50

PlayerSection:AddToggle({
    Title = "Speed Hack",
    Content = "Increase walk speed",
    Default = false,
    Callback = function(state)
        _G.Settings.SpeedHack = state
        notify("Speed Hack: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.SpeedHack do
                    local hum = getHum()
                    if hum then
                        hum.WalkSpeed = walkSpeed
                    end
                    task.wait(0.1)
                end
            end)
        else
            local hum = getHum()
            if hum then hum.WalkSpeed = 16 end
        end
    end
})

PlayerSection:AddSlider({
    Title = "Walk Speed",
    Content = "Set walk speed value",
    Min = 16,
    Max = 500,
    Increment = 1,
    Default = 16,
    Callback = function(value)
        walkSpeed = value
        if _G.Settings.SpeedHack then
            local hum = getHum()
            if hum then hum.WalkSpeed = value end
        end
    end
})

PlayerSection:AddToggle({
    Title = "Infinite Jump",
    Content = "Jump without limits",
    Default = false,
    Callback = function(state)
        _G.Settings.InfiniteJump = state
        notify("Infinite Jump: " .. (state and "ON" or "OFF"))
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.Settings.InfiniteJump then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerSection:AddToggle({
    Title = "No Clip",
    Content = "Walk through walls",
    Default = false,
    Callback = function(state)
        _G.Settings.NoClip = state
        notify("No Clip: " .. (state and "ON" or "OFF"))
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if _G.Settings.NoClip then
        local char = getChar()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local ESPSection = Tabs.ESP:AddSection("High Hub | ESP")

local function applyESP(obj, color)
    if obj and not obj:FindFirstChild("ESP_Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = obj
    end
end

local function clearESP(container)
    for _, obj in pairs(container:GetDescendants()) do
        if obj.Name == "ESP_Highlight" then
            obj:Destroy()
        end
    end
end

ESPSection:AddToggle({
    Title = "ESP Players",
    Content = "Show player ESP",
    Default = false,
    Callback = function(state)
        _G.Settings.ESPPlayers = state
        notify("ESP Players: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.ESPPlayers do
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            applyESP(player.Character, Color3.fromRGB(0, 255, 255))
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    clearESP(player.Character)
                end
            end
        end
    end
})

ESPSection:AddToggle({
    Title = "ESP Mobs",
    Content = "Show mob ESP",
    Default = false,
    Callback = function(state)
        _G.Settings.ESPMobs = state
        notify("ESP Mobs: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.ESPMobs do
                    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
                        applyESP(mob, Color3.fromRGB(255, 0, 0))
                    end
                    task.wait(1)
                end
            end)
        else
            clearESP(Workspace.Enemies)
        end
    end
})

ESPSection:AddToggle({
    Title = "ESP Fruits",
    Content = "Show devil fruit ESP",
    Default = false,
    Callback = function(state)
        _G.Settings.ESPFruits = state
        notify("ESP Fruits: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.ESPFruits do
                    for _, fruit in pairs(Workspace:GetChildren()) do
                        if fruit.Name:find("Fruit") and fruit:IsA("Tool") or fruit:IsA("Model") then
                            applyESP(fruit, Color3.fromRGB(255, 215, 0))
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

local FruitSection = Tabs.Fruit:AddSection("High Hub | Devil Fruit")

FruitSection:AddToggle({
    Title = "Auto Farm Fruit",
    Content = "Automatically collect devil fruits",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoFarmFruit = state
        notify("Auto Farm Fruit: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.AutoFarmFruit do
                    pcall(function()
                        for _, fruit in pairs(Workspace:GetChildren()) do
                            if fruit.Name:find("Fruit") then
                                local root = getRoot()
                                if root and fruit:FindFirstChild("Handle") then
                                    root.CFrame = fruit.Handle.CFrame
                                    task.wait(0.3)
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

FruitSection:AddToggle({
    Title = "Auto Store Fruit",
    Content = "Store collected fruits automatically",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoStoreFruit = state
        notify("Auto Store Fruit: " .. (state and "ON" or "OFF"))
    end
})

FruitSection:AddButton({
    Title = "Random Fruit",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            notify("Bought Random Fruit!")
        end)
    end
})

local RaidSection = Tabs.Raid:AddSection("High Hub | Raid")

RaidSection:AddToggle({
    Title = "Auto Raid",
    Content = "Automatically complete raids",
    Default = false,
    Callback = function(state)
        _G.Settings.AutoRaid = state
        notify("Auto Raid: " .. (state and "ON" or "OFF"))
    end
})

RaidSection:AddButton({
    Title = "Start Raid",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Flame")
            notify("Started Raid!")
        end)
    end
})

local TeleportSection = Tabs.Teleport:AddSection("High Hub | Teleport")

local islands = {
    ["Starter Island"] = CFrame.new(-1175, 42, 1451),
    ["Middle Town"] = CFrame.new(977, 42, 1186),
    ["Jungle"] = CFrame.new(-1601, 105, -200),
    ["Pirate Village"] = CFrame.new(-1034, 42, -2720),
    ["Desert"] = CFrame.new(938, 42, -2924),
    ["Frozen Village"] = CFrame.new(1173, 138, -3197),
    ["Marine Fortress"] = CFrame.new(-4771, 28, -2721),
    ["Skylands"] = CFrame.new(-4771, 872, -2252),
}

for name, cframe in pairs(islands) do
    TeleportSection:AddButton({
        Title = name,
        Callback = function()
            local root = getRoot()
            if root then
                root.CFrame = cframe
                notify("Teleported to " .. name)
            end
        end
    })
end

local ShopSection = Tabs.Shop:AddSection("High Hub | Shop")

ShopSection:AddButton({
    Title = "Buy Combat",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
            notify("Bought Combat!")
        end)
    end
})

ShopSection:AddButton({
    Title = "Buy Observation Haki",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Ken")
            notify("Bought Observation Haki!")
        end)
    end
})

ShopSection:AddButton({
    Title = "Buy Geppo",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
            notify("Bought Geppo!")
        end)
    end
})

local MiscSection = Tabs.Misc:AddSection("High Hub | Misc")

MiscSection:AddToggle({
    Title = "Anti AFK",
    Content = "Prevent AFK kick",
    Default = false,
    Callback = function(state)
        _G.Settings.AntiAFK = state
        notify("Anti AFK: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.Settings.AntiAFK do
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                    task.wait(30)
                end
            end)
        end
    end
})

MiscSection:AddButton({
    Title = "Remove Fog",
    Callback = function()
        pcall(function()
            game.Lighting.FogEnd = 100000
            notify("Fog removed!")
        end)
    end
})

MiscSection:AddButton({
    Title = "Unlock FPS",
    Callback = function()
        setfpscap(999)
        notify("FPS unlocked!")
    end
})

local ServerSection = Tabs.Server:AddSection("High Hub | Server")

ServerSection:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        notify("Rejoining...")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

ServerSection:AddButton({
    Title = "Server Hop",
    Callback = function()
        notify("Server hopping...")
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
        local data = HttpService:JSONDecode(req)
        
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        end
    end
})

ServerSection:AddParagraph({
    Title = "Job ID",
    Content = game.JobId,
    Icon = "server",
    ButtonText = "Copy Job ID",
    ButtonCallback = function()
        if setclipboard then
            setclipboard(game.JobId)
            notify("Job ID copied!")
        end
    end
})

local SettingsSection = Tabs.Settings:AddSection("High Hub | Settings", true)

SettingsSection:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:Destroy()
        notify("GUI destroyed!")
    end
})

notify("High Hub loaded successfully!", 3, Color3.fromRGB(138, 43, 226), "High Hub", "Blox Fruits")
