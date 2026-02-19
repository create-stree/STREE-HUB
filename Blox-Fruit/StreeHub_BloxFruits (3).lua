local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local TeleportService= game:GetService("TeleportService")
local HttpService    = game:GetService("HttpService")
local Workspace      = game:GetService("Workspace")
local Lighting       = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer    = Players.LocalPlayer

local function GetChar() return LocalPlayer.Character end
local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChild("Humanoid")
end

local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local _lastNotifyTime = 0

local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Blox Fruits",
    Images  = "139538383104637",
    Color   = Color3.fromRGB(255, 50, 50),
    Version = 1,
})

local function notify(msg, delay, color, title)
    local now = tick()
    if now - _lastNotifyTime < 3 then return end
    _lastNotifyTime = now
    StreeHub:MakeNotify({
        Title       = title or "StreeHub",
        Description = "Notification",
        Content     = msg or "...",
        Color       = color or Color3.fromRGB(255, 50, 50),
        Delay       = delay or 4,
    })
end

local function SafeTween(hrp, target, speed)
    if not hrp then return end
    speed = speed or 30
    local dist = (hrp.Position - target).Magnitude
    local t = dist / speed
    local tween = TweenService:Create(hrp, TweenInfo.new(math.max(0.1, t), Enum.EasingStyle.Linear), {CFrame = CFrame.new(target)})
    tween:Play()
    tween.Completed:Wait()
end

local function UseSkill(key)
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    end)
end

local function TeleportTo(pos)
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
    end
end

local function FindMobByName(name)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local h = v:FindFirstChild("Humanoid")
            if h.Health > 0 then return v end
        end
    end
    return nil
end

local function FindNearestMob()
    local hrp = GetHRP()
    if not hrp then return nil end
    local nearest, nearestDist = nil, 9999
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")
            and not Players:GetPlayerFromCharacter(v) and v ~= GetChar() then
            local h = v:FindFirstChild("Humanoid")
            if h.Health > 0 then
                local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < nearestDist then nearestDist = d; nearest = v end
            end
        end
    end
    return nearest
end

local function KillMob(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    local hrp = GetHRP()
    if not hrp then return end
    local dist = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
    if dist > (Settings and Settings.FarmDistance or 15) then
        hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings and Settings.FarmDistance or 15)
    end
    UseSkill(Settings and Settings.SelectedFruitSkill or "Z")
    task.wait(0.2)
    pcall(function()
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        if tool then
            local re = tool:FindFirstChildWhichIsA("RemoteEvent")
            if re then re:FireServer(mob.HumanoidRootPart.CFrame) end
        end
    end)
end

local function FindFruit()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:GetAttribute("Id") and v:FindFirstChild("Handle") then
            return v
        end
    end
    return nil
end

local function AddStat(statName)
    pcall(function()
        for _ = 1, (Settings and Settings.StatPoint or 1) do
            CommF_:InvokeServer("AddStat", statName)
        end
    end)
end

local function ServerHop()
    task.spawn(function()
        local ok, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and servers and servers.data then
            for _, v in pairs(servers.data) do
                if v.id ~= game.JobId and v.playing < v.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    return
                end
            end
        end
        notify("No servers found.")
    end)
end

local Flags = {}
Settings = {
    FarmDistance    = 15,
    TweenSpeed      = 30,
    MasteryHealth   = 20,
    StatPoint       = 1,
    BoatSpeed       = 50,
    SelectedWeapon  = "Sword",
    SelectedFruitSkill = "Z",
    SelectedGunSkill   = "Z",
    SelectedMethod  = "Mob",
    SelectedSword   = "Katana",
    SelectedMon     = "Musketeer",
    SelectedBoss    = "Gorilla King",
    SelectedMaterial= "Magma Ore",
    SelectedChip    = "Smoke",
    SelectedPlace   = "Middle Town",
    SelectedBoat    = "Galleon",
    SelectedZone    = "First Sea",
    SelectedBringMob= "All",
    SelectedUnstoreFruit = "Common - Mythical",
    SelectedStoreFruit   = "Common - Mythical",
    AzureEmberAmount= 0,
    SelectedPlayer  = nil,
    SelectedIsland  = "Middle Town",
    SelectedNpc     = "Sword Dealer",
    BoneMethod      = "Cursed Captain",
    ValentineItem   = nil,
    SeaEventFruit   = "Z",
    SeaEventMelee   = "Z",
}

local IslandCoords = {
    ["Marine Starter Island"] = Vector3.new(-1386, 4, -3000),
    ["Pirate Starter Island"] = Vector3.new(-1386, 4, -3000),
    ["Middle Town"]           = Vector3.new(250, 8, -600),
    ["Jungle"]                = Vector3.new(1717, 8, 882),
    ["Pirate Village"]        = Vector3.new(-1413, 8, 1083),
    ["Desert"]                = Vector3.new(938, 8, 3401),
    ["Navy Headquarters"]     = Vector3.new(1005, 8, -2700),
    ["Skylands"]              = Vector3.new(-4947, 905, -1019),
    ["Colosseum"]             = Vector3.new(-1247, 8, 3987),
    ["Impel Down"]            = Vector3.new(3018, -164, 2980),
    ["Marineford"]            = Vector3.new(-4882, 10, 0),
    ["Enies Lobby"]           = Vector3.new(-5390, 10, -2980),
    ["Fishman Island"]        = Vector3.new(61134, 1, 1851),
    ["Green Zone"]            = Vector3.new(4219, 63, 837),
    ["Kingdom of Rose"]       = Vector3.new(-1025, 14, -2549),
    ["Wedding Island"]        = Vector3.new(-1718, 14, 2244),
    ["Chamber of Time"]       = Vector3.new(-157, 105, -2120),
    ["Wano Country"]          = Vector3.new(-5765, 98, -1055),
    ["Haunted Castle"]        = Vector3.new(-6858, 99, -725),
    ["Hydra Island"]          = Vector3.new(6183, 30, 770),
    ["Sea of Treats"]         = Vector3.new(-7038, 14, -3249),
    ["Floating Turtle"]       = Vector3.new(-12830, 250, -5480),
    ["Demon Island"]          = Vector3.new(-14580, 130, -1920),
    ["Tiki Island"]           = Vector3.new(-11400, 30, 1300),
    ["Peanut Island"]         = Vector3.new(-10500, 30, -3300),
    ["First Sea"]             = Vector3.new(250, 8, -600),
    ["Second Sea"]            = Vector3.new(-1025, 14, -2549),
    ["Third Sea"]             = Vector3.new(-12830, 250, -5480),
}

local EspObjects = {}
local function ClearEspAll()
    for _, bb in pairs(EspObjects) do pcall(function() bb:Destroy() end) end
    EspObjects = {}
end

local function CreateEspBillboard(part, label, color)
    if EspObjects[part] then pcall(function() EspObjects[part]:Destroy() end) end
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 100, 0, 30)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
    bb.Adornee = part
    bb.Parent = LocalPlayer.PlayerGui
    local txt = Instance.new("TextLabel", bb)
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = label
    txt.TextColor3 = color or Color3.fromRGB(255, 255, 0)
    txt.TextStrokeTransparency = 0
    txt.TextScaled = true
    EspObjects[part] = bb
end

local function UpdateESP()
    if Flags.EspPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                CreateEspBillboard(p.Character.HumanoidRootPart, p.Name, Color3.fromRGB(255, 80, 80))
            end
        end
    end
    if Flags.EspChest then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Chest") and v:IsA("BasePart") then
                CreateEspBillboard(v, "Chest", Color3.fromRGB(255, 215, 0))
            end
        end
    end
    if Flags.EspFruit or Flags.EspRealFruit then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:GetAttribute("Id") and v:FindFirstChild("Handle") then
                CreateEspBillboard(v.Handle, v.Name, Color3.fromRGB(128, 0, 255))
            end
        end
    end
    if Flags.EspSeaBeast then
        for _, v in pairs(Workspace:GetDescendants()) do
            if (v.Name:find("Sea Beast") or v.Name:find("SeaBeast")) and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                CreateEspBillboard(v.HumanoidRootPart, v.Name, Color3.fromRGB(0, 200, 255))
            end
        end
    end
    if Flags.EspMonster then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")
                and not Players:GetPlayerFromCharacter(v) and v ~= GetChar() then
                local h = v:FindFirstChild("Humanoid")
                if h and h.Health > 0 then
                    CreateEspBillboard(v.HumanoidRootPart, v.Name, Color3.fromRGB(255, 100, 0))
                end
            end
        end
    end
    if Flags.EspGear then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Gear") and v:IsA("BasePart") then
                CreateEspBillboard(v, v.Name, Color3.fromRGB(0, 150, 255))
            end
        end
    end
    if Flags.EspFlower then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Flower") and v:IsA("BasePart") then
                CreateEspBillboard(v, "Flower", Color3.fromRGB(255, 182, 193))
            end
        end
    end
    if Flags.EspNpc then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")
                and not Players:GetPlayerFromCharacter(v) and v ~= GetChar() then
                local h = v:FindFirstChild("Humanoid")
                if h and h.MaxHealth == math.huge then
                    CreateEspBillboard(v.HumanoidRootPart, v.Name, Color3.fromRGB(0, 255, 100))
                end
            end
        end
    end
end

local NoClipConn, WalkOnWaterConn

local Tabs = {
    Main        = Window:AddTab({ Name = "Main",         Icon = "house" }),
    Others      = Window:AddTab({ Name = "Others",       Icon = "inbox" }),
    Items       = Window:AddTab({ Name = "Items",        Icon = "box" }),
    Settings    = Window:AddTab({ Name = "Settings",     Icon = "settings" }),
    LocalPlayer = Window:AddTab({ Name = "Local Player", Icon = "user" }),
    Stats       = Window:AddTab({ Name = "Stats",        Icon = "bar-chart-2" }),
    SeaEvent    = Window:AddTab({ Name = "Sea Event",    Icon = "anchor" }),
    SeaStack    = Window:AddTab({ Name = "Sea Stack",    Icon = "waves" }),
    DragonDojo  = Window:AddTab({ Name = "Dragon Dojo",  Icon = "shield" }),
    Race        = Window:AddTab({ Name = "Race",         Icon = "bot" }),
    Combat      = Window:AddTab({ Name = "Combat",       Icon = "sword" }),
    Raid        = Window:AddTab({ Name = "Raid",         Icon = "zap" }),
    Esp         = Window:AddTab({ Name = "Esp",          Icon = "eye" }),
    Teleport    = Window:AddTab({ Name = "Teleport",     Icon = "map-pin" }),
    Shop        = Window:AddTab({ Name = "Shop",         Icon = "shopping-cart" }),
    Fruit       = Window:AddTab({ Name = "Fruit",        Icon = "flask-conical" }),
    Misc        = Window:AddTab({ Name = "Misc",         Icon = "layout-grid" }),
    Server      = Window:AddTab({ Name = "Server",       Icon = "server" }),
}

local InfoSection = Tabs.Main:AddSection("StreeHub | Info")
InfoSection:AddParagraph({ Title = "Game Time", Content = "Loading...", Icon = "clock" })
InfoSection:AddParagraph({ Title = "FPS",        Content = "Loading...", Icon = "activity" })
InfoSection:AddParagraph({ Title = "Ping",       Content = "Loading...", Icon = "wifi" })
InfoSection:AddParagraph({ Title = "Discord Server", Content = "discord.gg/streehub", Icon = "discord" })
InfoSection:AddPanel({
    Title = "Join Discord",
    ButtonText = "Copy Link",
    ButtonCallback = function()
        if setclipboard then setclipboard("https://discord.gg/streehub") end
        notify("Discord link copied!")
    end
})

local AutoFarmSection = Tabs.Main:AddSection("StreeHub | Auto Farm")
AutoFarmSection:AddDropdown({
    Title = "Weapon",
    Content = "Choose weapon type for auto farm.",
    Options = { "Sword", "Gun", "Devil Fruit", "Melee" },
    Default = "Sword",
    Callback = function(v) Settings.SelectedWeapon = v end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Level",
    Content = "Automatically farm mobs for level.",
    Default = false,
    Callback = function(s) Flags.AutoFarmLevel = s; notify("Auto Farm Level: " .. (s and "ON" or "OFF")) end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Nearest",
    Content = "Farm nearest enemy automatically.",
    Default = false,
    Callback = function(s) Flags.AutoFarmNearest = s; notify("Auto Farm Nearest: " .. (s and "ON" or "OFF")) end
})

local ValentineSection = Tabs.Main:AddSection("StreeHub | Valentine Event")
ValentineSection:AddToggle({
    Title = "Auto Farm Hearts",
    Content = "Farm hearts for Valentine event.",
    Default = false,
    Callback = function(s) Flags.AutoFarmHearts = s; notify("Auto Farm Hearts: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddParagraph({ Title = "Hearts", Content = "0", Icon = "heart" })
ValentineSection:AddParagraph({ Title = "Cupid Quest", Content = "-", Icon = "info" })
ValentineSection:AddToggle({
    Title = "Auto Cupid Quest",
    Content = "Automatically complete Cupid Quest.",
    Default = false,
    Callback = function(s) Flags.AutoCupidQuest = s; notify("Auto Cupid Quest: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddToggle({
    Title = "Auto Delivery Quest",
    Content = "Automatically complete Delivery Quest.",
    Default = false,
    Callback = function(s) Flags.AutoDeliveryQuest = s; notify("Auto Delivery Quest: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddDivider()
ValentineSection:AddDropdown({
    Title = "Valentine Shop",
    Content = "Select Valentine Event Item.",
    Options = {},
    Default = nil,
    Callback = function(v) Settings.ValentineItem = v end
})
ValentineSection:AddButton({
    Title = "Refresh Shop",
    Callback = function() notify("Refreshing shop...") end
})
ValentineSection:AddParagraph({ Title = "Item Price", Content = "-", Icon = "tag" })
ValentineSection:AddButton({
    Title = "Buy Item",
    Callback = function()
        if Settings.ValentineItem then
            pcall(function() CommF_:InvokeServer("BuyValentineItem", Settings.ValentineItem) end)
            notify("Buying: " .. tostring(Settings.ValentineItem))
        else
            notify("Select an item first.")
        end
    end
})
ValentineSection:AddToggle({
    Title = "Auto Valentines Gacha",
    Content = "Automatically spin Valentines Gacha.",
    Default = false,
    Callback = function(s)
        Flags.AutoVGacha = s
        notify("Auto Valentines Gacha: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoVGacha do
                    pcall(function() CommF_:InvokeServer("ValentineGacha") end)
                    task.wait(2)
                end
            end)
        end
    end
})

local MasterySection = Tabs.Main:AddSection("StreeHub | Mastery Farm")
MasterySection:AddDropdown({
    Title = "Choose Method",
    Content = "Select mastery farming method.",
    Options = { "Mob", "Sea Beast", "Player" },
    Default = "Mob",
    Callback = function(v) Settings.SelectedMethod = v end
})
MasterySection:AddToggle({
    Title = "Auto Fruit Mastery",
    Content = "Automatically farm Devil Fruit mastery.",
    Default = false,
    Callback = function(s) Flags.AutoFruitMastery = s; notify("Auto Fruit Mastery: " .. (s and "ON" or "OFF")) end
})
MasterySection:AddToggle({
    Title = "Auto Gun Mastery",
    Content = "Automatically farm Gun mastery.",
    Default = false,
    Callback = function(s) Flags.AutoGunMastery = s; notify("Auto Gun Mastery: " .. (s and "ON" or "OFF")) end
})
MasterySection:AddDropdown({
    Title = "Choose Sword",
    Content = "Select sword for mastery farming.",
    Options = { "Katana", "Dual Katana", "Triple Katana", "Bisento", "Saber", "Yama", "Tushita", "CDK" },
    Default = "Katana",
    Callback = function(v) Settings.SelectedSword = v end
})
MasterySection:AddToggle({
    Title = "Auto Sword Mastery",
    Content = "Automatically farm Sword mastery.",
    Default = false,
    Callback = function(s) Flags.AutoSwordMastery = s; notify("Auto Sword Mastery: " .. (s and "ON" or "OFF")) end
})

local TyrantSection = Tabs.Main:AddSection("StreeHub | Tyrant Of The Skies")
TyrantSection:AddParagraph({ Title = "Eyes", Content = "0", Icon = "eye" })
TyrantSection:AddToggle({
    Title = "Auto Boss",
    Content = "Automatically fight Tyrant of the Skies boss.",
    Default = false,
    Callback = function(s) Flags.AutoBoss = s; notify("Auto Boss: " .. (s and "ON" or "OFF")) end
})

local MonFarmSection = Tabs.Main:AddSection("StreeHub | Mon Farm")
MonFarmSection:AddDropdown({
    Title = "Choose Mon",
    Content = "Select a Mon to farm.",
    Options = { "Musketeer", "Imp", "Zombie", "Balloon Pirate", "Pirate", "Swordsman", "Fishman Warrior", "Fishman Commando" },
    Default = "Musketeer",
    Callback = function(v) Settings.SelectedMon = v end
})
MonFarmSection:AddToggle({
    Title = "Auto Farm Mon",
    Content = "Automatically farm selected Mon.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmMon = s
        notify("Auto Farm Mon: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmMon do
                    local mob = FindMobByName(Settings.SelectedMon)
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local BerrySection = Tabs.Main:AddSection("StreeHub | Berry")
BerrySection:AddToggle({
    Title = "Auto Collect Berry",
    Content = "Automatically collect berries on the ground.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectBerry = s
        notify("Auto Collect Berry: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoCollectBerry do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if (v.Name == "Money" or v.Name == "Berry" or v.Name:find("Berry")) and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            break
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local BossFarmSection = Tabs.Main:AddSection("StreeHub | Boss Farm")
BossFarmSection:AddParagraph({ Title = "Boss Status", Content = "-", Icon = "shield" })
BossFarmSection:AddDropdown({
    Title = "Choose Boss",
    Content = "Select boss to farm.",
    Options = { "Gorilla King", "Bobby", "Yeti", "Mob Leader", "Snow Lurker", "Franky", "Fishman Lord", "Wysper", "Thunder God", "Drip Mama", "Fajita", "Don Swan", "Smoke Admiral", "Magma Admiral", "Cursed Captain", "Order", "Stone", "Island Empress", "Pharaoh", "Boss Chief", "Longma", "Jack", "Apoo", "Queen", "King" },
    Default = "Gorilla King",
    Callback = function(v) Settings.SelectedBoss = v end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm Boss",
    Content = "Automatically farm selected boss.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmBoss = s
        notify("Auto Farm Boss: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmBoss do
                    local hum = GetHum()
                    if hum and hum.Health < hum.MaxHealth * 0.2 then task.wait(2) end
                    local mob = FindMobByName(Settings.SelectedBoss)
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm All Boss",
    Content = "Automatically cycle through all bosses.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmAllBoss = s
        notify("Auto Farm All Boss: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmAllBoss do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local EliteSection = Tabs.Main:AddSection("StreeHub | Elite Hunter")
EliteSection:AddParagraph({ Title = "Elite Hunter Status", Content = "-", Icon = "user-check" })
EliteSection:AddParagraph({ Title = "Elite Hunter Progress", Content = "-", Icon = "bar-chart-2" })
EliteSection:AddToggle({
    Title = "Auto Elite Hunter",
    Content = "Automatically complete Elite Hunter quests.",
    Default = false,
    Callback = function(s)
        Flags.AutoEliteHunter = s
        notify("Auto Elite Hunter: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoEliteHunter do
                    pcall(function() CommF_:InvokeServer("EliteHunterQuest") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
EliteSection:AddToggle({
    Title = "Auto Elite Hunter Hop",
    Content = "Server hop for Elite Hunter.",
    Default = false,
    Callback = function(s)
        Flags.AutoEliteHunterHop = s
        if s then ServerHop() end
    end
})

local BoneSection = Tabs.Main:AddSection("StreeHub | Bone Farm")
BoneSection:AddDropdown({
    Title = "Choose Method",
    Content = "Select bone farming method.",
    Options = { "Cursed Captain", "Mob", "Boss" },
    Default = "Cursed Captain",
    Callback = function(v) Settings.BoneMethod = v end
})
BoneSection:AddParagraph({ Title = "Bones Owned", Content = "0", Icon = "box" })
BoneSection:AddToggle({
    Title = "Auto Farm Bone",
    Content = "Automatically farm bones.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmBone = s
        notify("Auto Farm Bone: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmBone do
                    local mobName = Settings.BoneMethod == "Cursed Captain" and "Cursed Captain" or Settings.SelectedBoss
                    local mob = FindMobByName(mobName) or FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
BoneSection:AddToggle({
    Title = "Auto Random Surprise",
    Content = "Automatically use Random Surprise Balls.",
    Default = false,
    Callback = function(s)
        Flags.AutoRandomSurprise = s
        notify("Auto Random Surprise: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoRandomSurprise do
                    pcall(function() CommF_:InvokeServer("UseSurpriseBall") end)
                    task.wait(2)
                end
            end)
        end
    end
})

local PirateRaidSection = Tabs.Main:AddSection("StreeHub | Pirate Raid")
PirateRaidSection:AddToggle({
    Title = "Auto Pirate Raid",
    Content = "Automatically complete Pirate Raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoPirateRaid = s
        notify("Auto Pirate Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoPirateRaid do
                    pcall(function() CommF_:InvokeServer("PirateRaid") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local ChestSection = Tabs.Main:AddSection("StreeHub | Chest Farm")
ChestSection:AddToggle({
    Title = "Auto Farm Chest Tween",
    Content = "Tween to chests and open automatically.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmChestTween = s
        notify("Auto Farm Chest Tween: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmChestTween do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name:find("Chest") and v:IsA("BasePart") then
                            local hrp = GetHRP()
                            if hrp then SafeTween(hrp, v.Position, Settings.TweenSpeed) end
                            pcall(function() CommF_:InvokeServer("OpenChest", v) end)
                            break
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
ChestSection:AddToggle({
    Title = "Auto Farm Chest Instant",
    Content = "Teleport to chests instantly.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmChestInst = s
        notify("Auto Farm Chest Instant: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmChestInst do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name:find("Chest") and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            pcall(function() CommF_:InvokeServer("OpenChest", v) end)
                            break
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
ChestSection:AddToggle({
    Title = "Auto Stop Items",
    Content = "Stop picking up items while farming.",
    Default = false,
    Callback = function(s) Flags.AutoStopItems = s end
})

local CakeSection = Tabs.Main:AddSection("StreeHub | Cake Prince")
CakeSection:AddParagraph({ Title = "Cake Prince Status", Content = "-", Icon = "crown" })
CakeSection:AddToggle({
    Title = "Auto Katakuri",
    Content = "Automatically fight Katakuri.",
    Default = false,
    Callback = function(s)
        Flags.AutoKatakuri = s
        notify("Auto Katakuri: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoKatakuri do
                    local mob = FindMobByName("Katakuri")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Spawn Cake Prince",
    Content = "Automatically spawn Cake Prince.",
    Default = false,
    Callback = function(s)
        Flags.AutoSpawnCakePrince = s
        notify("Auto Spawn Cake Prince: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoSpawnCakePrince do
                    pcall(function() CommF_:InvokeServer("SpawnCakePrince") end)
                    task.wait(3)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Kill Cake Prince",
    Content = "Automatically kill Cake Prince.",
    Default = false,
    Callback = function(s)
        Flags.AutoKillCakePrince = s
        notify("Auto Kill Cake Prince: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoKillCakePrince do
                    local mob = FindMobByName("Cake Prince")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Kill Dough King",
    Content = "Automatically kill Dough King.",
    Default = false,
    Callback = function(s)
        Flags.AutoKillDoughKing = s
        notify("Auto Kill Dough King: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoKillDoughKing do
                    local mob = FindMobByName("Dough King")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local MaterialSection = Tabs.Main:AddSection("StreeHub | Materials")
MaterialSection:AddDropdown({
    Title = "Choose Material",
    Content = "Select material to farm.",
    Options = { "Magma Ore", "Dragon Scale", "Fish Tail", "Mystic Droplet", "Scrap Metal", "Leather", "Meteorite", "Radioactive Material", "Demonic Wisp", "Vampire Fang", "Conjured Cocoa", "Wool", "Gunpowder", "Mini Tusk" },
    Default = "Magma Ore",
    Callback = function(v) Settings.SelectedMaterial = v end
})
MaterialSection:AddToggle({
    Title = "Auto Farm Material",
    Content = "Automatically farm selected material.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmMaterial = s
        notify("Auto Farm Material: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmMaterial do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == Settings.SelectedMaterial and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            break
                        end
                    end
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local SettingsMainSection = Tabs.Main:AddSection("StreeHub | Settings")
SettingsMainSection:AddToggle({
    Title = "Spin Position",
    Content = "Spin around target instead of teleporting directly.",
    Default = false,
    Callback = function(s) Flags.SpinPosition = s end
})
SettingsMainSection:AddSlider({
    Title = "Farm Distance",
    Content = "Distance to maintain from enemy.",
    Min = 5, Max = 60, Increment = 1, Default = 15,
    Callback = function(v) Settings.FarmDistance = v end
})
SettingsMainSection:AddSlider({
    Title = "Player Tween Speed",
    Content = "Speed for tween movement.",
    Min = 10, Max = 250, Increment = 5, Default = 30,
    Callback = function(v) Settings.TweenSpeed = v end
})
SettingsMainSection:AddToggle({
    Title = "Bring Mob",
    Content = "Pull mobs to your position.",
    Default = false,
    Callback = function(s) Flags.BringMob = s end
})
SettingsMainSection:AddDropdown({
    Title = "Bring Mob",
    Content = "Which mobs to bring.",
    Options = { "All", "Quest Mob", "Selected Mob" },
    Default = "All",
    Callback = function(v) Settings.SelectedBringMob = v end
})
SettingsMainSection:AddToggle({
    Title = "Attack Aura",
    Content = "Use attack skills continuously.",
    Default = false,
    Callback = function(s)
        Flags.AttackAura = s
        if s then
            task.spawn(function()
                while Flags.AttackAura do
                    local mob = FindNearestMob()
                    if mob then UseSkill(Settings.SelectedFruitSkill or "Z") end
                    task.wait(0.3)
                end
            end)
        end
    end
})

local GraphicSection = Tabs.Main:AddSection("StreeHub | Graphic")
GraphicSection:AddToggle({
    Title = "Hide Notification",
    Content = "Hide in-game kill notifications.",
    Default = false,
    Callback = function(s)
        Flags.HideNotif = s
        pcall(function()
            local gui = LocalPlayer.PlayerGui:FindFirstChild("NotificationUI")
            if gui then gui.Enabled = not s end
        end)
    end
})
GraphicSection:AddToggle({
    Title = "Hide Damage Text",
    Content = "Hide floating damage numbers.",
    Default = false,
    Callback = function(s) Flags.HideDamage = s end
})
GraphicSection:AddToggle({
    Title = "Black Screen",
    Content = "Black screen for performance.",
    Default = false,
    Callback = function(s)
        Flags.BlackScreen = s
        pcall(function()
            local cam = Workspace.CurrentCamera
            if s then
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = CFrame.new(0, -99999, 0)
            else
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
    end
})
GraphicSection:AddToggle({
    Title = "White Screen",
    Content = "White screen for performance.",
    Default = false,
    Callback = function(s)
        Flags.WhiteScreen = s
        pcall(function()
            Lighting.Ambient = s and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70)
            Lighting.Brightness = s and 10 or 2
        end)
    end
})

local MasterySettSection = Tabs.Main:AddSection("StreeHub | Mastery")
MasterySettSection:AddSlider({
    Title = "Mastery Health %",
    Content = "Minimum health % before retreating.",
    Min = 5, Max = 80, Increment = 5, Default = 20,
    Callback = function(v) Settings.MasteryHealth = v end
})

local FruitSkillSection = Tabs.Main:AddSection("StreeHub | Devil Fruit Skill")
FruitSkillSection:AddDropdown({
    Title = "Choose Fruit Skill",
    Content = "Fruit skill key for auto farm.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) Settings.SelectedFruitSkill = v end
})

local GunSkillSection = Tabs.Main:AddSection("StreeHub | Gun Skill")
GunSkillSection:AddDropdown({
    Title = "Choose Gun Skill",
    Content = "Gun skill key for auto farm.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) Settings.SelectedGunSkill = v end
})

local OthersMainSection = Tabs.Main:AddSection("StreeHub | Others")
OthersMainSection:AddToggle({
    Title = "Auto Set Spawn Point",
    Content = "Set spawn point at current location.",
    Default = false,
    Callback = function(s)
        Flags.AutoSetSpawn = s
        if s then pcall(function() CommF_:InvokeServer("SetSpawnPoint") end) end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Observation",
    Content = "Automatically enable Observation Haki.",
    Default = false,
    Callback = function(s)
        Flags.AutoObservation = s
        if s then
            task.spawn(function()
                while Flags.AutoObservation do
                    pcall(function() CommF_:InvokeServer("UseObservation") end)
                    task.wait(10)
                end
            end)
        end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Haki",
    Content = "Automatically enable Buso Haki.",
    Default = false,
    Callback = function(s)
        Flags.AutoHaki = s
        if s then
            task.spawn(function()
                while Flags.AutoHaki do
                    pcall(function() CommF_:InvokeServer("UseHaki") end)
                    task.wait(10)
                end
            end)
        end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Rejoin",
    Content = "Rejoin when character dies.",
    Default = false,
    Callback = function(s)
        Flags.AutoRejoin = s
        if s then
            local hum = GetHum()
            if hum then
                hum.Died:Connect(function()
                    task.wait(3)
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end
        end
    end
})

local SeaEventOthersSection = Tabs.Others:AddSection("StreeHub | Sea Event")
SeaEventOthersSection:AddToggle({
    Title = "Lightning",
    Content = "Auto use ability during sea events.",
    Default = false,
    Callback = function(s)
        Flags.Lightning = s
        if s then
            task.spawn(function()
                while Flags.Lightning do
                    UseSkill(Settings.SeaEventFruit)
                    task.wait(0.5)
                end
            end)
        end
    end
})
SeaEventOthersSection:AddDropdown({
    Title = "Tools",
    Content = "Tool to use during sea events.",
    Options = { "Pipe", "Bazooka", "Flintlock", "Cannon", "Flower Minigame" },
    Default = "Pipe",
    Callback = function(v) Settings.SeaEventTool = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Devil Fruit",
    Content = "Fruit skill for sea events.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) Settings.SeaEventFruit = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Melee",
    Content = "Melee skill for sea events.",
    Options = { "Z", "X", "C", "V" },
    Default = "Z",
    Callback = function(v) Settings.SeaEventMelee = v end
})

local WorldSection = Tabs.Others:AddSection("StreeHub | World")
WorldSection:AddToggle({
    Title = "Auto Second Sea",
    Content = "Farm quests to reach Second Sea.",
    Default = false,
    Callback = function(s)
        Flags.AutoSecondSea = s
        notify("Auto Second Sea: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoSecondSea do
                    pcall(function() CommF_:InvokeServer("GetSecondSea") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
WorldSection:AddToggle({
    Title = "Auto Third Sea",
    Content = "Farm quests to reach Third Sea.",
    Default = false,
    Callback = function(s)
        Flags.AutoThirdSea = s
        notify("Auto Third Sea: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoThirdSea do
                    pcall(function() CommF_:InvokeServer("GetThirdSea") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local FightingStyleSection = Tabs.Others:AddSection("StreeHub | Fighting Style")
local fightingStyles = {
    {n="Auto Super Human",     k="AutoSuperHuman",    s="SuperHuman"},
    {n="Auto Death Step",      k="AutoDeathStep",     s="DeathStep"},
    {n="Auto Sharkman Karate", k="AutoSharkmanKarate",s="SharkmanKarate"},
    {n="Auto Electric Claw",   k="AutoElectricClaw",  s="ElectricClaw"},
    {n="Auto Dragon Talon",    k="AutoDragonTalon",   s="DragonTalon"},
    {n="Auto God Human",       k="AutoGodHuman",      s="GodHuman"},
}
for _, style in ipairs(fightingStyles) do
    FightingStyleSection:AddToggle({
        Title = style.n,
        Content = "Auto obtain " .. style.s .. ".",
        Default = false,
        Callback = function(s)
            Flags[style.k] = s
            if s then
                task.spawn(function()
                    while Flags[style.k] do
                        pcall(function() CommF_:InvokeServer("BuyFightingStyle", style.s) end)
                        task.wait(3)
                    end
                end)
            end
        end
    })
end

local GunSwordSection = Tabs.Others:AddSection("StreeHub | Gun & Sword")
local swordItems = {
    {n="Auto Get Saber",      k="AutoGetSaber",      q="GetSaber"},
    {n="Auto Buddy Sword",    k="AutoBuddySword",    q="BuddySword"},
    {n="Auto Soul Guitar",    k="AutoSoulGuitar",    q="SoulGuitar"},
    {n="Auto Rengoku",        k="AutoRengoku",       q="Rengoku"},
    {n="Auto Hallow Scythe",  k="AutoHallowScythe",  q="HallowScythe"},
    {n="Auto Warden Sword",   k="AutoWardenSword",   q="WardenSword"},
    {n="Auto Get Yama",       k="AutoGetYama",       q="GetYama"},
    {n="Auto Get Yama Hop",   k="AutoGetYamaHop",    q=nil},
    {n="Auto Get Tushita",    k="AutoGetTushita",    q="GetTushita"},
}
for _, item in ipairs(swordItems) do
    GunSwordSection:AddToggle({
        Title = item.n,
        Content = item.n,
        Default = false,
        Callback = function(s)
            Flags[item.k] = s
            if s then
                if item.k == "AutoGetYamaHop" then
                    ServerHop()
                elseif item.q then
                    task.spawn(function()
                        while Flags[item.k] do
                            pcall(function() CommF_:InvokeServer(item.q) end)
                            task.wait(2)
                        end
                    end)
                end
            end
        end
    })
end

local CDKSection = Tabs.Others:AddSection("StreeHub | Cursed Dual Katana")
local cdkItems = {
    {n="Auto Get CDK",               k="AutoGetCDK",          q="GetCDK"},
    {n="Auto Quest CDK [ Yama ]",    k="AutoQuestCDKYama",    q="CDKQuestYama"},
    {n="Auto Quest CDK [ Tushita ]", k="AutoQuestCDKTushita", q="CDKQuestTushita"},
    {n="Auto Dragon Trident",        k="AutoDragonTrident",   q="DragonTrident"},
    {n="Auto Greybeard",             k="AutoGreybeard",       mob="Greybeard"},
    {n="Auto Shark Saw",             k="AutoSharkSaw",        mob="Shark"},
    {n="Auto Pole",                  k="AutoPole",            q="GetPole"},
    {n="Auto Dark Dagger",           k="AutoDarkDagger",      q="GetDarkDagger"},
}
for _, item in ipairs(cdkItems) do
    CDKSection:AddToggle({
        Title = item.n,
        Content = item.n,
        Default = false,
        Callback = function(s)
            Flags[item.k] = s
            if s then
                task.spawn(function()
                    while Flags[item.k] do
                        if item.mob then
                            local mob = FindMobByName(item.mob)
                            if mob then KillMob(mob) end
                        elseif item.q then
                            pcall(function() CommF_:InvokeServer(item.q) end)
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

local StatsSection = Tabs.Stats:AddSection("StreeHub | Stats")
local statMap = {
    {n="Add Melee Stats",       k="AddMeleeStats",   s="Melee"},
    {n="Add Defense Stats",     k="AddDefenseStats", s="Defense"},
    {n="Add Sword Stats",       k="AddSwordStats",   s="Sword"},
    {n="Add Gun Stats",         k="AddGunStats",     s="Gun"},
    {n="Add Devil Fruit Stats", k="AddDFStats",      s="Devil Fruit"},
}
for _, st in ipairs(statMap) do
    StatsSection:AddToggle({
        Title = st.n,
        Content = "Auto distribute points to " .. st.s .. ".",
        Default = false,
        Callback = function(s)
            Flags[st.k] = s
            if s then
                task.spawn(function()
                    while Flags[st.k] do
                        AddStat(st.s)
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end
StatsSection:AddSlider({
    Title = "Point",
    Content = "Points per allocation.",
    Min = 1, Max = 100, Increment = 1, Default = 1,
    Callback = function(v) Settings.StatPoint = v end
})

local RaidSection = Tabs.Raid:AddSection("StreeHub | Raid")
RaidSection:AddParagraph({ Title = "Raid Time", Content = "-", Icon = "clock" })
RaidSection:AddParagraph({ Title = "Island",    Content = "-", Icon = "map-pin" })
RaidSection:AddDropdown({
    Title = "Choose Chip",
    Content = "Select raid chip.",
    Options = { "Smoke", "Magma", "Sand", "Ice", "Light", "Rumble", "String", "Quake", "Dark", "Phoenix", "Flame", "Falcon", "Buddha", "Spider", "Sound", "Blizzard", "Gravity", "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune" },
    Default = "Smoke",
    Callback = function(v) Settings.SelectedChip = v end
})
RaidSection:AddToggle({
    Title = "Auto Raid",
    Content = "Automatically complete raids.",
    Default = false,
    Callback = function(s)
        Flags.AutoRaid = s
        notify("Auto Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoRaid do
                    pcall(function() CommF_:InvokeServer("startRaid", Settings.SelectedChip, false) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
RaidSection:AddToggle({
    Title = "Auto Awaken",
    Content = "Auto awaken devil fruit in raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoAwaken = s
        notify("Auto Awaken: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoAwaken do
                    pcall(function() CommF_:InvokeServer("Awaken") end)
                    task.wait(2)
                end
            end)
        end
    end
})
RaidSection:AddDropdown({
    Title = "Unstore Rarity Fruit",
    Content = "Rarity of fruit to unstore before raid.",
    Options = { "Common - Mythical", "Uncommon - Mythical", "Rare - Mythical", "Legendary - Mythical", "Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) Settings.SelectedUnstoreFruit = v end
})
RaidSection:AddToggle({
    Title = "Auto Unstore Devil Fruit",
    Content = "Unstore devil fruit before raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoUnstoreFruit = s
        if s then
            task.spawn(function()
                while Flags.AutoUnstoreFruit do
                    pcall(function() CommF_:InvokeServer("UnstoreFruit", Settings.SelectedUnstoreFruit) end)
                    task.wait(3)
                end
            end)
        end
    end
})
RaidSection:AddButton({
    Title = "Teleport To Lab",
    Callback = function()
        TeleportTo(Vector3.new(-1384, 128, 4228))
        notify("Teleported to Lab!")
    end
})

local LawRaidSection = Tabs.Raid:AddSection("StreeHub | Law Raid")
LawRaidSection:AddToggle({
    Title = "Auto Law Raid",
    Content = "Automatically complete Law Raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoLawRaid = s
        notify("Auto Law Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoLawRaid do
                    pcall(function() CommF_:InvokeServer("startLawRaid") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local DungeonSection = Tabs.Raid:AddSection("StreeHub | Dungeon")
DungeonSection:AddButton({
    Title = "Teleport To Dungeon Hub",
    Callback = function()
        TeleportTo(Vector3.new(-5765, 98, -1055))
        notify("Teleported to Dungeon Hub!")
    end
})
DungeonSection:AddToggle({
    Title = "Auto Attack Mon",
    Content = "Attack mobs in dungeon.",
    Default = false,
    Callback = function(s)
        Flags.AutoAttackMon = s
        if s then
            task.spawn(function()
                while Flags.AutoAttackMon do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DungeonSection:AddToggle({
    Title = "Auto Next Floor",
    Content = "Proceed to next dungeon floor.",
    Default = false,
    Callback = function(s)
        Flags.AutoNextFloor = s
        if s then
            task.spawn(function()
                while Flags.AutoNextFloor do
                    pcall(function() CommF_:InvokeServer("NextFloor") end)
                    task.wait(2)
                end
            end)
        end
    end
})
DungeonSection:AddToggle({
    Title = "Auto Return To Hub",
    Content = "Return to hub after dungeon.",
    Default = false,
    Callback = function(s)
        Flags.AutoReturnHub = s
        if s then
            task.spawn(function()
                while Flags.AutoReturnHub do
                    pcall(function() CommF_:InvokeServer("ReturnHub") end)
                    task.wait(3)
                end
            end)
        end
    end
})

local RaceSection = Tabs.Race:AddSection("StreeHub | Race")
RaceSection:AddToggle({
    Title = "Auto Buy Gear",
    Content = "Automatically buy gear for race.",
    Default = false,
    Callback = function(s)
        Flags.AutoBuyGear = s
        if s then
            task.spawn(function()
                while Flags.AutoBuyGear do
                    pcall(function() CommF_:InvokeServer("BuyGear") end)
                    task.wait(5)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Tween To Mirage Island",
    Content = "Tween towards Mirage Island.",
    Default = false,
    Callback = function(s)
        Flags.TweenMirageIsland = s
        if s then
            task.spawn(function()
                while Flags.TweenMirageIsland do
                    local hrp = GetHRP()
                    if hrp then SafeTween(hrp, IslandCoords["Floating Turtle"] or Vector3.new(-12830, 250, -5480), Settings.TweenSpeed) end
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Find Blue Gear",
    Content = "Automatically find and collect blue gear.",
    Default = false,
    Callback = function(s)
        Flags.FindBlueGear = s
        if s then
            task.spawn(function()
                while Flags.FindBlueGear do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if (v.Name == "Blue Gear" or v.Name:find("Gear")) and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.5)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Look Moon & use Ability",
    Content = "Look at moon and use race ability.",
    Default = false,
    Callback = function(s)
        Flags.LookMoon = s
        if s then
            task.spawn(function()
                while Flags.LookMoon do
                    pcall(function()
                        local hrp = GetHRP()
                        if hrp then
                            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(0, 1, 0))
                            CommF_:InvokeServer("UseRaceAbility")
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Auto Train",
    Content = "Train for race progression.",
    Default = false,
    Callback = function(s)
        Flags.AutoTrain = s
        if s then
            task.spawn(function()
                while Flags.AutoTrain do
                    pcall(function() CommF_:InvokeServer("TrainRace") end)
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddButton({
    Title = "Teleport To Race Door",
    Callback = function()
        TeleportTo(Vector3.new(-6917, 105, -1143))
        notify("Teleported to Race Door!")
    end
})
RaceSection:AddButton({
    Title = "Buy Acient Quest",
    Callback = function()
        pcall(function() CommF_:InvokeServer("BuyAncientQuest") end)
        notify("Buying Ancient Quest...")
    end
})
RaceSection:AddToggle({
    Title = "Auto Trial",
    Content = "Automatically complete race trials.",
    Default = false,
    Callback = function(s)
        Flags.AutoTrial = s
        if s then
            task.spawn(function()
                while Flags.AutoTrial do
                    pcall(function() CommF_:InvokeServer("StartTrial") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Auto Kill Player After Trial",
    Content = "Kill players after trial.",
    Default = false,
    Callback = function(s) Flags.AutoKillAfterTrial = s end
})

local CombatSection = Tabs.Combat:AddSection("StreeHub | Combat")
CombatSection:AddParagraph({ Title = "Players In Server", Content = tostring(#Players:GetPlayers()), Icon = "users" })
local playerList = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playerList, p.Name) end
end
local CombatPlayerDropdown = CombatSection:AddDropdown({
    Title = "Choose Player",
    Content = "Select a player to target.",
    Options = playerList,
    Default = playerList[1] or nil,
    Callback = function(v) Settings.SelectedPlayer = v end
})
CombatSection:AddButton({
    Title = "Refresh Player",
    Callback = function()
        local newList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newList, p.Name) end
        end
        CombatPlayerDropdown:SetValues(newList, newList[1])
        notify("Player list refreshed!")
    end
})
CombatSection:AddButton({
    Title = "Spectate Player",
    Callback = function()
        if Settings.SelectedPlayer then
            local target = Players:FindFirstChild(Settings.SelectedPlayer)
            if target and target.Character then
                pcall(function()
                    Workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
                end)
                notify("Spectating: " .. Settings.SelectedPlayer)
            end
        else
            notify("Select a player first.")
        end
    end
})
CombatSection:AddButton({
    Title = "Teleport To Player",
    Callback = function()
        if Settings.SelectedPlayer then
            local target = Players:FindFirstChild(Settings.SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = GetHRP()
                if hrp then
                    hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    notify("Teleported to " .. Settings.SelectedPlayer)
                end
            end
        else
            notify("Select a player first.")
        end
    end
})

local IslandCombatSection = Tabs.Combat:AddSection("StreeHub | Island")
local islandList = {}
for k, _ in pairs(IslandCoords) do table.insert(islandList, k) end
IslandCombatSection:AddDropdown({
    Title = "Choose Island",
    Content = "Select island to teleport to.",
    Options = islandList,
    Default = "Middle Town",
    Callback = function(v) Settings.SelectedIsland = v end
})
IslandCombatSection:AddButton({
    Title = "Teleport To Island",
    Callback = function()
        if Settings.SelectedIsland and IslandCoords[Settings.SelectedIsland] then
            TeleportTo(IslandCoords[Settings.SelectedIsland])
            notify("Teleported to " .. Settings.SelectedIsland)
        end
    end
})

local NpcCombatSection = Tabs.Combat:AddSection("StreeHub | Npc")
NpcCombatSection:AddDropdown({
    Title = "Choose Npc",
    Content = "Select NPC to teleport to.",
    Options = { "Sword Dealer", "Blox Fruit Dealer", "Fancy Sword Dealer", "Special Gear", "Master of Auras" },
    Default = "Sword Dealer",
    Callback = function(v) Settings.SelectedNpc = v end
})
NpcCombatSection:AddButton({
    Title = "Teleport To Npc",
    Callback = function()
        if Settings.SelectedNpc then
            local found = false
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == Settings.SelectedNpc and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    TeleportTo(v.HumanoidRootPart.Position)
                    notify("Teleported to " .. Settings.SelectedNpc)
                    found = true
                    break
                end
            end
            if not found then notify(Settings.SelectedNpc .. " not found.") end
        end
    end
})

local EspSection = Tabs.Esp:AddSection("StreeHub | ESP")
local espItems = {
    {n="Esp Player",            k="EspPlayer"},
    {n="Esp Chest",             k="EspChest"},
    {n="Esp Devil Fruit",       k="EspFruit"},
    {n="Esp Real Fruit",        k="EspRealFruit"},
    {n="Esp Flower",            k="EspFlower"},
    {n="Esp Island",            k="EspIsland"},
    {n="Esp Npc",               k="EspNpc"},
    {n="Esp Sea Beast",         k="EspSeaBeast"},
    {n="Esp Monster",           k="EspMonster"},
    {n="Esp Mirage Island",     k="EspMirageIsland"},
    {n="Esp Kitsune Island",    k="EspKitsuneIsland"},
    {n="Esp Frozen Dimension",  k="EspFrozen"},
    {n="Esp Prehistoric Island",k="EspPrehistoric"},
    {n="Esp Gear",              k="EspGear"},
}
for _, item in ipairs(espItems) do
    EspSection:AddToggle({
        Title = item.n,
        Content = item.n .. " visibility.",
        Default = false,
        Callback = function(s)
            Flags[item.k] = s
            if not s then ClearEspAll() end
        end
    })
end

local TeleportSection = Tabs.Teleport:AddSection("StreeHub | Teleport")
TeleportSection:AddDropdown({
    Title = "Selected Place",
    Content = "Choose a place to teleport to.",
    Options = islandList,
    Default = "Middle Town",
    Callback = function(v) Settings.SelectedPlace = v end
})
TeleportSection:AddButton({
    Title = "Teleport To Place",
    Callback = function()
        if Settings.SelectedPlace and IslandCoords[Settings.SelectedPlace] then
            TeleportTo(IslandCoords[Settings.SelectedPlace])
            notify("Teleported to " .. Settings.SelectedPlace)
        end
    end
})

local WorldTeleportSection = Tabs.Teleport:AddSection("StreeHub | World")
WorldTeleportSection:AddButton({
    Title = "Teleport To First Sea",
    Callback = function() TeleportTo(IslandCoords["First Sea"]); notify("Teleported to First Sea!") end
})
WorldTeleportSection:AddButton({
    Title = "Teleport To Second Sea",
    Callback = function() TeleportTo(IslandCoords["Second Sea"]); notify("Teleported to Second Sea!") end
})
WorldTeleportSection:AddButton({
    Title = "Teleport To Third Sea",
    Callback = function() TeleportTo(IslandCoords["Third Sea"]); notify("Teleported to Third Sea!") end
})

local IslandTeleportSection = Tabs.Teleport:AddSection("StreeHub | Island")
IslandTeleportSection:AddDropdown({
    Title = "Choose Island",
    Content = "Select island to teleport to.",
    Options = islandList,
    Default = "Middle Town",
    Callback = function(v) Settings.SelectedIsland = v end
})
IslandTeleportSection:AddButton({
    Title = "Teleport To Island",
    Callback = function()
        if Settings.SelectedIsland and IslandCoords[Settings.SelectedIsland] then
            TeleportTo(IslandCoords[Settings.SelectedIsland])
            notify("Teleported to " .. Settings.SelectedIsland)
        end
    end
})

local NpcTeleportSection = Tabs.Teleport:AddSection("StreeHub | Npc")
NpcTeleportSection:AddDropdown({
    Title = "Choose Npc",
    Content = "Select NPC to teleport to.",
    Options = { "Sword Dealer", "Blox Fruit Dealer", "Fancy Sword Dealer", "Special Gear", "Master of Auras" },
    Default = "Sword Dealer",
    Callback = function(v) Settings.SelectedNpc = v end
})
NpcTeleportSection:AddButton({
    Title = "Teleport To Npc",
    Callback = function()
        if Settings.SelectedNpc then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == Settings.SelectedNpc and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    TeleportTo(v.HumanoidRootPart.Position)
                    notify("Teleported to " .. Settings.SelectedNpc)
                    return
                end
            end
            notify(Settings.SelectedNpc .. " not found.")
        end
    end
})

local ShopSection = Tabs.Shop:AddSection("StreeHub | Shop")
ShopSection:AddToggle({
    Title = "Auto Buy Legendary Sword",
    Content = "Buy legendary swords from shop.",
    Default = false,
    Callback = function(s)
        Flags.AutoBuyLegSword = s
        if s then
            task.spawn(function()
                while Flags.AutoBuyLegSword do
                    pcall(function() CommF_:InvokeServer("BuyItem", "Legendary Sword") end)
                    task.wait(5)
                end
            end)
        end
    end
})
ShopSection:AddToggle({
    Title = "Auto Buy Haki Color",
    Content = "Buy Haki color upgrades.",
    Default = false,
    Callback = function(s)
        Flags.AutoBuyHakiColor = s
        if s then
            task.spawn(function()
                while Flags.AutoBuyHakiColor do
                    pcall(function() CommF_:InvokeServer("BuyHakiColor") end)
                    task.wait(5)
                end
            end)
        end
    end
})

local AbilityShopSection = Tabs.Shop:AddSection("StreeHub | Abilities")
for _, ab in ipairs({ "Geppo", "Buso Haki", "Soru", "Observation Haki" }) do
    AbilityShopSection:AddButton({
        Title = "Buy " .. ab,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyAbility", ab) end)
            notify("Buying " .. ab .. "...")
        end
    })
end

local FightStyleShopSection = Tabs.Shop:AddSection("StreeHub | Fighting Style Shop")
for _, fs in ipairs({ "Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "God Human", "Sanguine Art" }) do
    FightStyleShopSection:AddButton({
        Title = "Buy " .. fs,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyFightingStyle", fs) end)
            notify("Buying " .. fs .. "...")
        end
    })
end

local SwordShopSection = Tabs.Shop:AddSection("StreeHub | Sword Shop")
for _, sw in ipairs({ "Cutlass", "Katana", "Iron Mace", "Dual Katana", "Triple Katana", "Pipe", "Dual Headed Blade", "Bisento", "Soul Cane" }) do
    SwordShopSection:AddButton({
        Title = "Buy " .. sw,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyItem", sw) end)
            notify("Buying " .. sw .. "...")
        end
    })
end

local GunShopSection = Tabs.Shop:AddSection("StreeHub | Gun Shop")
for _, gn in ipairs({ "Slingshot", "Musket", "Flintlock", "Refined Flintlock", "Cannon", "Kabucha" }) do
    GunShopSection:AddButton({
        Title = "Buy " .. gn,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyItem", gn) end)
            notify("Buying " .. gn .. "...")
        end
    })
end

local StatResetSection = Tabs.Shop:AddSection("StreeHub | Stats Reset")
StatResetSection:AddButton({
    Title = "Reset Stats",
    Callback = function()
        pcall(function() CommF_:InvokeServer("ResetStats") end)
        notify("Resetting stats...")
    end
})
StatResetSection:AddButton({
    Title = "Random Race",
    Callback = function()
        pcall(function() CommF_:InvokeServer("RandomRace") end)
        notify("Spinning for random race...")
    end
})

local AccessoriesSection = Tabs.Shop:AddSection("StreeHub | Accessories")
for _, ac in ipairs({ "Black Cape", "Swordsman Hat", "Tomoe Ring" }) do
    AccessoriesSection:AddButton({
        Title = "Buy " .. ac,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyItem", ac) end)
            notify("Buying " .. ac .. "...")
        end
    })
end

local FruitAutoSection = Tabs.Fruit:AddSection("StreeHub | Auto Fruit")
FruitAutoSection:AddToggle({
    Title = "Auto Random Fruit",
    Content = "Spin for random fruits.",
    Default = false,
    Callback = function(s)
        Flags.AutoRandomFruit = s
        if s then
            task.spawn(function()
                while Flags.AutoRandomFruit do
                    pcall(function() CommF_:InvokeServer("SpinFruit") end)
                    task.wait(2)
                end
            end)
        end
    end
})
FruitAutoSection:AddDropdown({
    Title = "Store Rarity Fruit",
    Content = "Minimum rarity of fruit to store.",
    Options = { "Common - Mythical", "Uncommon - Mythical", "Rare - Mythical", "Legendary - Mythical", "Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) Settings.SelectedStoreFruit = v end
})
FruitAutoSection:AddToggle({
    Title = "Auto Store Fruit",
    Content = "Auto store fruits of selected rarity.",
    Default = false,
    Callback = function(s)
        Flags.AutoStoreFruit = s
        if s then
            task.spawn(function()
                while Flags.AutoStoreFruit do
                    pcall(function() CommF_:InvokeServer("StoreFruit", Settings.SelectedStoreFruit) end)
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Fruit Notification",
    Content = "Notify when a fruit spawns.",
    Default = false,
    Callback = function(s)
        Flags.FruitNotif = s
        if s then
            task.spawn(function()
                local last = nil
                while Flags.FruitNotif do
                    local fruit = FindFruit()
                    if fruit and fruit ~= last then
                        last = fruit
                        notify("Fruit: " .. fruit.Name, 6, Color3.fromRGB(128, 0, 255), "Fruit Alert")
                    end
                    if not fruit then last = nil end
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Teleport To Fruit",
    Content = "Teleport to spawned fruits.",
    Default = false,
    Callback = function(s)
        Flags.TeleportToFruit = s
        if s then
            task.spawn(function()
                while Flags.TeleportToFruit do
                    local fruit = FindFruit()
                    if fruit and fruit:FindFirstChild("Handle") then
                        TeleportTo(fruit.Handle.Position)
                    end
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Tween To Fruit",
    Content = "Tween smoothly to spawned fruits.",
    Default = false,
    Callback = function(s)
        Flags.TweenToFruit = s
        if s then
            task.spawn(function()
                while Flags.TweenToFruit do
                    local fruit = FindFruit()
                    if fruit and fruit:FindFirstChild("Handle") then
                        local hrp = GetHRP()
                        if hrp then SafeTween(hrp, fruit.Handle.Position, Settings.TweenSpeed) end
                    end
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddButton({
    Title = "Grab Fruit",
    Callback = function()
        local fruit = FindFruit()
        if fruit and fruit:FindFirstChild("Handle") then
            TeleportTo(fruit.Handle.Position)
            task.wait(0.3)
            pcall(function() CommF_:InvokeServer("GrabFruit", fruit) end)
            notify("Grabbed " .. fruit.Name)
        else
            notify("No fruit found.")
        end
    end
})

local FruitVisualSection = Tabs.Fruit:AddSection("StreeHub | Visual")
FruitVisualSection:AddButton({
    Title = "Rain Fruit",
    Callback = function()
        task.spawn(function()
            for i = 1, 10 do
                pcall(function() CommF_:InvokeServer("SpawnFruit") end)
                task.wait(0.2)
            end
        end)
        notify("Raining fruits!")
    end
})

local TeamSection = Tabs.Misc:AddSection("StreeHub | Teams")
TeamSection:AddButton({
    Title = "Join Pirates Team",
    Callback = function()
        pcall(function() CommF_:InvokeServer("JoinTeam", "Pirates") end)
        notify("Joined Pirates team!")
    end
})
TeamSection:AddButton({
    Title = "Join Marines Team",
    Callback = function()
        pcall(function() CommF_:InvokeServer("JoinTeam", "Marines") end)
        notify("Joined Marines team!")
    end
})

local CodesSection = Tabs.Misc:AddSection("StreeHub | Codes")
CodesSection:AddButton({
    Title = "Redeem All Codes",
    Callback = function()
        notify("Redeeming codes...")
        local codes = { "Sub2Fer999","Sub2NoobMaster123","Sub2Daigrock","Bluxxy","Enyu_is_Pro","Magicbus","JCWK","StrawHatMaine","Sub2Bignews","CHANDLER","Sub2OfficialNoobie","Starcodeheo","Sub2ibemaine","fudd10","fudd10v2","KITT3N","sub2gamerrobot_exp1","sub2gamerrobot_reset1","TantaiGaming","Axiore","StrawHat" }
        task.spawn(function()
            for _, code in ipairs(codes) do
                pcall(function() CommF_:InvokeServer("REDEEM_CODE", code) end)
                task.wait(0.4)
            end
            notify("All codes done!", 4, Color3.fromRGB(0, 255, 0))
        end)
    end
})

local GraphicsMiscSection = Tabs.Misc:AddSection("StreeHub | Graphics")
GraphicsMiscSection:AddButton({
    Title = "Fps Boost",
    Callback = function()
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        for _, v in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end)
        end
        notify("FPS Boost enabled!")
    end
})
GraphicsMiscSection:AddButton({
    Title = "Remove Fog",
    Callback = function()
        Lighting.FogEnd = 1e9
        Lighting.FogStart = 1e8
        notify("Fog removed!")
    end
})
GraphicsMiscSection:AddButton({
    Title = "Remove Lava",
    Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if v.Name == "Lava" and v:IsA("BasePart") then
                    v.Transparency = 1
                    v.CanCollide = false
                end
            end)
        end
        notify("Lava removed!")
    end
})

local LocalPlayerSection = Tabs.LocalPlayer:AddSection("StreeHub | Local Player")
LocalPlayerSection:AddToggle({
    Title = "Active Race V3",
    Content = "Activate Race V3 ability.",
    Default = false,
    Callback = function(s)
        Flags.ActiveRaceV3 = s
        if s then
            task.spawn(function()
                while Flags.ActiveRaceV3 do
                    pcall(function() CommF_:InvokeServer("UseRaceV3") end)
                    task.wait(0.5)
                end
            end)
        end
    end
})
LocalPlayerSection:AddToggle({
    Title = "Active Race V4",
    Content = "Activate Race V4 ability.",
    Default = false,
    Callback = function(s)
        Flags.ActiveRaceV4 = s
        if s then
            task.spawn(function()
                while Flags.ActiveRaceV4 do
                    pcall(function() CommF_:InvokeServer("UseRaceV4") end)
                    task.wait(0.5)
                end
            end)
        end
    end
})
LocalPlayerSection:AddToggle({
    Title = "Walk On Water",
    Content = "Walk on water surface.",
    Default = false,
    Callback = function(s)
        Flags.WalkOnWater = s
        if WalkOnWaterConn then WalkOnWaterConn:Disconnect(); WalkOnWaterConn = nil end
        if s then
            WalkOnWaterConn = RunService.Heartbeat:Connect(function()
                if not Flags.WalkOnWater then return end
                local hrp = GetHRP()
                if hrp and hrp.Position.Y < 3 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, 3, hrp.Position.Z)
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                end
            end)
        end
    end
})
LocalPlayerSection:AddToggle({
    Title = "No Clip",
    Content = "Walk through walls.",
    Default = false,
    Callback = function(s)
        Flags.NoClip = s
        if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
        if s then
            NoClipConn = RunService.Stepped:Connect(function()
                if not Flags.NoClip then return end
                local char = GetChar()
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        else
            local char = GetChar()
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
        end
    end
})

local SeaEventSection = Tabs.SeaEvent:AddSection("StreeHub | Sea Event")
SeaEventSection:AddToggle({
    Title = "Lightning",
    Content = "Auto handle lightning sea events.",
    Default = false,
    Callback = function(s)
        Flags.Lightning = s
        if s then
            task.spawn(function()
                while Flags.Lightning do
                    UseSkill(Settings.SeaEventFruit)
                    task.wait(0.5)
                end
            end)
        end
    end
})

local SeaStackEnemiesSection = Tabs.SeaStack:AddSection("StreeHub | Enemies")
local seaEnemies = {
    {n="Auto Farm Shark",            k="AutoFarmShark",      mob="Shark"},
    {n="Auto Farm Piranha",          k="AutoFarmPiranha",    mob="Piranha"},
    {n="Auto Farm Fish Crew Member", k="AutoFarmFishCrew",   mob="Fish Crew Member"},
}
for _, se in ipairs(seaEnemies) do
    SeaStackEnemiesSection:AddToggle({
        Title = se.n,
        Content = se.n,
        Default = false,
        Callback = function(s)
            Flags[se.k] = s
            if s then
                task.spawn(function()
                    while Flags[se.k] do
                        local mob = FindMobByName(se.mob)
                        if mob then KillMob(mob) end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

local BoatSection = Tabs.SeaStack:AddSection("StreeHub | Boat")
local boatEnemies = {
    {n="Auto Farm Ghost Ship",           k="AutoFarmGhostShip",  mob="Ghost Ship"},
    {n="Auto Farm Pirate Brigade",       k="AutoFarmPirateBrig", mob="Pirate Brigade"},
    {n="Auto Farm Pirate Grand Brigade", k="AutoFarmGrandBrig",  mob="Pirate Grand Brigade"},
}
for _, be in ipairs(boatEnemies) do
    BoatSection:AddToggle({
        Title = be.n,
        Content = be.n,
        Default = false,
        Callback = function(s)
            Flags[be.k] = s
            if s then
                task.spawn(function()
                    while Flags[be.k] do
                        local mob = FindMobByName(be.mob)
                        if mob then KillMob(mob) end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

local BossSeaSection = Tabs.SeaStack:AddSection("StreeHub | Boss")
BossSeaSection:AddToggle({
    Title = "Auto Farm Terrorshark",
    Content = "Auto farm Terrorshark boss.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmTerror = s
        if s then
            task.spawn(function()
                while Flags.AutoFarmTerror do
                    local mob = FindMobByName("Terrorshark")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
BossSeaSection:AddToggle({
    Title = "Auto Farm Seabeasts",
    Content = "Auto farm Seabeasts.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmSeabeast = s
        if s then
            task.spawn(function()
                while Flags.AutoFarmSeabeast do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if (v.Name:find("Sea Beast") or v.Name:find("SeaBeast")) and v:IsA("Model") then
                            KillMob(v)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local SailBoatSection = Tabs.SeaStack:AddSection("StreeHub | Sail Boat")
SailBoatSection:AddDropdown({
    Title = "Choose Boat",
    Content = "Select boat type.",
    Options = { "Raft", "Dinghy", "Caravel", "Galleon" },
    Default = "Galleon",
    Callback = function(v) Settings.SelectedBoat = v end
})
SailBoatSection:AddDropdown({
    Title = "Choose Zone",
    Content = "Select zone for sailing.",
    Options = { "First Sea", "Second Sea", "Third Sea" },
    Default = "First Sea",
    Callback = function(v) Settings.SelectedZone = v end
})
SailBoatSection:AddSlider({
    Title = "Boat Tween Speed",
    Content = "Boat movement speed.",
    Min = 20, Max = 200, Increment = 10, Default = 50,
    Callback = function(v) Settings.BoatSpeed = v end
})
SailBoatSection:AddButton({
    Title = "Sail Boat",
    Callback = function()
        pcall(function() CommF_:InvokeServer("SpawnBoat", Settings.SelectedBoat) end)
        notify("Sailing with " .. Settings.SelectedBoat)
    end
})
SailBoatSection:AddToggle({
    Title = "Auto Attack Seabeasts",
    Content = "Attack seabeasts while sailing.",
    Default = false,
    Callback = function(s)
        Flags.AutoAttackSeabeast = s
        if s then
            task.spawn(function()
                while Flags.AutoAttackSeabeast do
                    local hrp = GetHRP()
                    if hrp then
                        for _, v in pairs(Workspace:GetDescendants()) do
                            if (v.Name:find("Sea Beast") or v.Name:find("SeaBeast")) and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                                if (hrp.Position - v.HumanoidRootPart.Position).Magnitude < 300 then
                                    KillMob(v)
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local BeltSection = Tabs.DragonDojo:AddSection("StreeHub | Belt")
BeltSection:AddToggle({
    Title = "Auto Dojo Trainer",
    Content = "Auto train at Dragon Dojo.",
    Default = false,
    Callback = function(s)
        Flags.AutoDojoBelt = s
        if s then
            task.spawn(function()
                while Flags.AutoDojoBelt do
                    pcall(function() CommF_:InvokeServer("DojoTrain") end)
                    local mob = FindMobByName("Dojo Trainer") or FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local VolcanicSection = Tabs.DragonDojo:AddSection("StreeHub | Volcanic Magnet")
VolcanicSection:AddToggle({
    Title = "Auto Farm Blaze Ember",
    Content = "Farm Blaze Ember from volcano.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmBlazeEmber = s
        if s then
            task.spawn(function()
                while Flags.AutoFarmBlazeEmber do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "Blaze Ember" and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.1)
                            pcall(function() CommF_:InvokeServer("CollectEmber", v) end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
VolcanicSection:AddButton({
    Title = "Craft Volcanic Magnet",
    Callback = function()
        pcall(function() CommF_:InvokeServer("CraftItem", "Volcanic Magnet") end)
        notify("Crafting Volcanic Magnet...")
    end
})

local DracoSection = Tabs.DragonDojo:AddSection("StreeHub | Draco Trial")
DracoSection:AddButton({
    Title = "Upgrade Draco Trial",
    Callback = function()
        pcall(function() CommF_:InvokeServer("UpgradeDracoTrial") end)
        notify("Upgrading Draco Trial...")
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V1",
    Content = "Complete Draco V1.",
    Default = false,
    Callback = function(s)
        Flags.AutoDracoV1 = s
        if s then
            task.spawn(function()
                while Flags.AutoDracoV1 do
                    pcall(function() CommF_:InvokeServer("StartDracoTrial", 1) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V2",
    Content = "Complete Draco V2.",
    Default = false,
    Callback = function(s)
        Flags.AutoDracoV2 = s
        if s then
            task.spawn(function()
                while Flags.AutoDracoV2 do
                    pcall(function() CommF_:InvokeServer("StartDracoTrial", 2) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V3",
    Content = "Complete Draco V3.",
    Default = false,
    Callback = function(s)
        Flags.AutoDracoV3 = s
        if s then
            task.spawn(function()
                while Flags.AutoDracoV3 do
                    pcall(function() CommF_:InvokeServer("StartDracoTrial", 3) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DracoSection:AddButton({
    Title = "Teleport To Draco Trials",
    Callback = function()
        TeleportTo(Vector3.new(-12830, 250, -5480))
        notify("Teleported to Draco Trials!")
    end
})
DracoSection:AddToggle({
    Title = "Swap Draco Race",
    Content = "Swap to Draco race.",
    Default = false,
    Callback = function(s)
        Flags.SwapDraco = s
        if s then pcall(function() CommF_:InvokeServer("SwapRace", "Draco") end) end
    end
})
DracoSection:AddButton({
    Title = "Upgrade Dragon Talon",
    Callback = function()
        pcall(function() CommF_:InvokeServer("UpgradeDragonTalon") end)
        notify("Upgrading Dragon Talon...")
    end
})

local PrehistoricSection = Tabs.Items:AddSection("StreeHub | Prehistoric")
PrehistoricSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "info" })
PrehistoricSection:AddToggle({
    Title = "Auto Prehistoric Island",
    Content = "Auto complete Prehistoric Island.",
    Default = false,
    Callback = function(s)
        Flags.AutoPrehistoric = s
        if s then
            task.spawn(function()
                while Flags.AutoPrehistoric do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Kill Lava Golem",
    Content = "Auto kill Lava Golem.",
    Default = false,
    Callback = function(s)
        Flags.AutoKillLava = s
        if s then
            task.spawn(function()
                while Flags.AutoKillLava do
                    local mob = FindMobByName("Lava Golem")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Collect Bone",
    Content = "Auto collect bones.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectBone = s
        if s then
            task.spawn(function()
                while Flags.AutoCollectBone do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "Bone" and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.05)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Collect Egg",
    Content = "Auto collect eggs.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectEgg = s
        if s then
            task.spawn(function()
                while Flags.AutoCollectEgg do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name:find("Egg") and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.05)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Defend Volcano",
    Content = "Auto defend the volcano.",
    Default = false,
    Callback = function(s)
        Flags.AutoDefendVolcano = s
        if s then
            task.spawn(function()
                while Flags.AutoDefendVolcano do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local FrozenSection = Tabs.Items:AddSection("StreeHub | Frozen Dimension")
FrozenSection:AddParagraph({ Title = "Frozen Status", Content = "-", Icon = "info" })
FrozenSection:AddToggle({
    Title = "Auto Frozen Dimension",
    Content = "Auto complete Frozen Dimension.",
    Default = false,
    Callback = function(s)
        Flags.AutoFrozen = s
        if s then
            task.spawn(function()
                while Flags.AutoFrozen do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
FrozenSection:AddParagraph({ Title = "Leviathan Status", Content = "-", Icon = "info" })
FrozenSection:AddButton({
    Title = "Bribe Leviathan",
    Callback = function()
        pcall(function() CommF_:InvokeServer("BribeLeviathan") end)
        notify("Bribing Leviathan...")
    end
})
FrozenSection:AddToggle({
    Title = "Auto Leviathan",
    Content = "Auto fight Leviathan.",
    Default = false,
    Callback = function(s)
        Flags.AutoLeviathan = s
        if s then
            task.spawn(function()
                while Flags.AutoLeviathan do
                    local mob = FindMobByName("Leviathan")
                    if mob then
                        KillMob(mob)
                    else
                        pcall(function() CommF_:InvokeServer("SummonLeviathan") end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local KitsuneSection = Tabs.Items:AddSection("StreeHub | Kitsune Island")
KitsuneSection:AddParagraph({ Title = "Kitsune Status", Content = "-", Icon = "info" })
KitsuneSection:AddToggle({
    Title = "Auto Kitsune Island",
    Content = "Auto complete Kitsune Island.",
    Default = false,
    Callback = function(s)
        Flags.AutoKitsuneIsland = s
        if s then
            task.spawn(function()
                while Flags.AutoKitsuneIsland do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
KitsuneSection:AddToggle({
    Title = "Auto Collect Azure Ember",
    Content = "Auto collect Azure Ember.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectAzure = s
        if s then
            task.spawn(function()
                while Flags.AutoCollectAzure do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "Azure Ember" and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.1)
                            pcall(function() CommF_:InvokeServer("CollectAzureEmber", v) end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
KitsuneSection:AddPanel({
    Title = "Azure Ember",
    Placeholder = "Amount (e.g. 50)",
    ButtonText = "Set Azure Ember",
    ButtonCallback = function(v)
        Settings.AzureEmberAmount = tonumber(v) or 0
        notify("Azure Ember set: " .. tostring(Settings.AzureEmberAmount))
    end
})
KitsuneSection:AddToggle({
    Title = "Auto Trade Azure Ember",
    Content = "Auto trade Azure Ember.",
    Default = false,
    Callback = function(s)
        Flags.AutoTradeAzure = s
        if s then
            task.spawn(function()
                while Flags.AutoTradeAzure do
                    pcall(function() CommF_:InvokeServer("TradeAzureEmber", Settings.AzureEmberAmount) end)
                    task.wait(3)
                end
            end)
        end
    end
})

local MirageSection = Tabs.Items:AddSection("StreeHub | Mirage Island")
MirageSection:AddParagraph({ Title = "Mirage Status", Content = "-", Icon = "info" })
MirageSection:AddToggle({
    Title = "Auto Mirage Island",
    Content = "Auto complete Mirage Island.",
    Default = false,
    Callback = function(s)
        Flags.AutoMirageIsland = s
        if s then
            task.spawn(function()
                while Flags.AutoMirageIsland do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local SettingsTab = Tabs.Settings:AddSection("StreeHub | Settings", true)
SettingsTab:AddToggle({
    Title = "Show Button",
    Content = "Show open/close GUI button.",
    Default = true,
    Callback = function(state)
        notify("Button: " .. (state and "ON" or "OFF"))
    end
})
SettingsTab:AddPanel({
    Title = "UI Color",
    Placeholder = "255,50,50",
    ButtonText = "Apply Color",
    ButtonCallback = function(colorText)
        local r, g, b = colorText:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            notify("Color: RGB(" .. r .. "," .. g .. "," .. b .. ")")
        else
            notify("Format: R,G,B")
        end
    end,
    SubButtonText = "Reset Color",
    SubButtonCallback = function()
        notify("Color reset.")
    end
})
SettingsTab:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
    end
})

local ServerSection = Tabs.Server:AddSection("StreeHub | Server")
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
        notify("Finding new server...")
        ServerHop()
    end
})
ServerSection:AddParagraph({ Title = "Job ID", Content = tostring(game.JobId), Icon = "server" })
ServerSection:AddButton({
    Title = "Copy Job ID",
    Callback = function()
        if setclipboard then setclipboard(tostring(game.JobId)) end
        notify("Job ID copied!")
    end
})
ServerSection:AddPanel({
    Title = "Join Specific Server",
    Placeholder = "Enter Job ID...",
    ButtonText = "Join Job ID",
    ButtonCallback = function(jobId)
        if jobId and jobId ~= "" then
            notify("Joining: " .. jobId)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        else
            notify("Enter a valid Job ID.")
        end
    end
})

local StatusServerSection = Tabs.Server:AddSection("StreeHub | Status Server")
StatusServerSection:AddParagraph({ Title = "Moon Server",        Content = "-", Icon = "moon" })
StatusServerSection:AddParagraph({ Title = "Kitsune Status",     Content = "-", Icon = "zap" })
StatusServerSection:AddParagraph({ Title = "Frozen Status",      Content = "-", Icon = "info" })
StatusServerSection:AddParagraph({ Title = "Mirage Status",      Content = "-", Icon = "eye" })
StatusServerSection:AddParagraph({ Title = "Haki Dealer Status", Content = "-", Icon = "user" })
StatusServerSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "shield" })

RunService.Heartbeat:Connect(function()
    local anyEsp = Flags.EspPlayer or Flags.EspChest or Flags.EspFruit or Flags.EspRealFruit
        or Flags.EspFlower or Flags.EspIsland or Flags.EspNpc or Flags.EspSeaBeast
        or Flags.EspMonster or Flags.EspGear
    if anyEsp then pcall(UpdateESP) end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Flags.AutoRejoin then
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            task.wait(3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
    if WalkOnWaterConn then WalkOnWaterConn:Disconnect(); WalkOnWaterConn = nil end
end)

RunService.Heartbeat:Connect(function()
    if Flags.AutoFarmLevel or Flags.AutoFarmNearest or Flags.AutoFruitMastery or Flags.AutoGunMastery or Flags.AutoSwordMastery or Flags.AutoBoss then
        pcall(function()
            local hum = GetHum()
            if hum and hum.Health < hum.MaxHealth * (Settings.MasteryHealth / 100) then return end
            local mob = FindNearestMob()
            if mob then KillMob(mob) end
        end)
    end
end)

notify("StreeHub loaded!", 5, Color3.fromRGB(255, 50, 50), "StreeHub")
