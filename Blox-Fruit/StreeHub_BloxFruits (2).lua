local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

local Players        = game:GetService("Players")
local LocalPlayer    = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService    = game:GetService("HttpService")
local Workspace      = game:GetService("Workspace")
local CoreGui        = game:GetService("CoreGui")
local Lighting       = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Stats          = game:GetService("Stats")

local Character, Humanoid, HRP
local function UpdateCharacter(char)
    Character = char or LocalPlayer.Character
    if not Character then return end
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    HRP      = Character:FindFirstChild("HumanoidRootPart")
end
UpdateCharacter()
LocalPlayer.CharacterAdded:Connect(function(c) UpdateCharacter(c) end)

local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local _lastNotifyTime = 0
local function notify(msg, delay, color, title)
    local now = tick()
    if now - _lastNotifyTime < 3 then return end
    _lastNotifyTime = now
    StreeHub:MakeNotify({
        Title       = title or "StreeHub",
        Description = "Blox Fruits",
        Content     = msg or "...",
        Color       = color or Color3.fromRGB(255, 50, 50),
        Delay       = delay or 4,
    })
end

local function tweenTo(pos)
    if not HRP then return end
    local goal = { CFrame = CFrame.new(pos) }
    local info = TweenInfo.new(1 / (_G.TweenSpeed / 30), Enum.EasingStyle.Linear)
    TweenService:Create(HRP, info, goal):Play()
end

local function getClosestEnemy(range)
    range = range or _G.FarmDistance or 15
    local closest, closestDist = nil, math.huge
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model ~= Character then
            local hum = model:FindFirstChildOfClass("Humanoid")
            local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Root") or model.PrimaryPart
            if hum and hum.Health > 0 and root and HRP then
                local dist = (root.Position - HRP.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = model
                end
            end
        end
    end
    return closest
end

local function attackEnemy(model)
    if not model or not HRP then return end
    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Root") or model.PrimaryPart
    if not root then return end
    local dist = (root.Position - HRP.Position).Magnitude
    if dist > (_G.FarmDistance or 15) then
        HRP.CFrame = CFrame.new(root.Position + Vector3.new(5, 2, 5))
    end
    local skill = _G.SelectedWeapon
    if skill == "Devil Fruit" then
        local key = _G.SelectedFruitSkill or "Z"
        local vk = key == "Z" and Enum.KeyCode.Z or key == "X" and Enum.KeyCode.X or key == "C" and Enum.KeyCode.C or key == "V" and Enum.KeyCode.V or Enum.KeyCode.F
        pcall(function() fireclickdetector(root) end)
        UserInputService:SetRobloxGuiFocused(false)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, vk, false, game) end)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, vk, false, game) end)
    elseif skill == "Gun" then
        local key = _G.SelectedGunSkill or "Z"
        local vk = key == "Z" and Enum.KeyCode.Z or key == "X" and Enum.KeyCode.X or Enum.KeyCode.C
        pcall(function() fireclickdetector(root) end)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, vk, false, game) end)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, vk, false, game) end)
    else
        pcall(function() fireclickdetector(root) end)
        HRP.CFrame = CFrame.new(root.Position + Vector3.new(3, 1, 3))
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game) end)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game) end)
    end
end

local function invokeServer(...)
    local ok, result = pcall(function() return CommF_:InvokeServer(...) end)
    if ok then return result end
    return nil
end

local function findNearestNPC(name)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == name and (obj:IsA("Model") or obj:IsA("BasePart")) then
            return obj
        end
    end
    return nil
end

local function teleportTo(pos)
    if HRP then
        HRP.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    end
end

local function serverHop()
    notify("Mencari server...")
    task.spawn(function()
        local ok, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGetAsync(
                "https://games.roblox.com/v1/games/" .. game.PlaceId ..
                "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and servers and servers.data then
            for _, v in pairs(servers.data) do
                if v.id ~= game.JobId and v.playing < v.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    return
                end
            end
        end
        notify("Tidak ada server kosong.")
    end)
end

local function getPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local EspObjects = {}
local function clearEsp()
    for _, v in pairs(EspObjects) do pcall(function() v:Destroy() end) end
    EspObjects = {}
end
local function makeEspBox(part, label, color)
    if not part then return end
    local box = Instance.new("SelectionBox")
    box.Color3 = color or Color3.fromRGB(255, 50, 50)
    box.LineThickness = 0.04
    box.Adornee = part
    box.Parent = CoreGui
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 100, 0, 25)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Adornee = part
    bb.AlwaysOnTop = true
    bb.Parent = CoreGui
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = label or ""
    txt.TextColor3 = color or Color3.fromRGB(255, 50, 50)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12
    txt.Parent = bb
    table.insert(EspObjects, box)
    table.insert(EspObjects, bb)
end

local function updateEsp()
    clearEsp()
    if _G.EspPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                makeEspBox(p.Character.HumanoidRootPart, p.Name, Color3.fromRGB(255, 50, 50))
            end
        end
    end
    if _G.EspChest or _G.EspFruit or _G.EspFlower or _G.EspMonster or _G.EspSeaBeast or _G.EspGear then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if _G.EspChest and obj.Name:lower():find("chest") and obj:IsA("BasePart") then
                makeEspBox(obj, "Chest", Color3.fromRGB(255, 215, 0))
            end
            if (_G.EspFruit or _G.EspRealFruit) and obj.Name:lower():find("fruit") and obj:IsA("Model") then
                makeEspBox(obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart"), obj.Name, Color3.fromRGB(0, 200, 100))
            end
            if _G.EspFlower and obj.Name:lower():find("flower") and obj:IsA("BasePart") then
                makeEspBox(obj, "Flower", Color3.fromRGB(255, 150, 200))
            end
            if _G.EspSeaBeast and obj.Name:lower():find("seabeast") and obj:IsA("Model") then
                local r = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                makeEspBox(r, obj.Name, Color3.fromRGB(0, 100, 255))
            end
            if _G.EspMonster and obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= Character then
                local r = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if r then makeEspBox(r, obj.Name, Color3.fromRGB(200, 0, 200)) end
            end
            if _G.EspGear and obj.Name:lower():find("gear") and obj:IsA("BasePart") then
                makeEspBox(obj, "Gear", Color3.fromRGB(100, 200, 255))
            end
        end
    end
end

local function buyStats(statType, amount)
    pcall(function()
        invokeServer("AddStat", statType, amount or _G.StatPoint or 1)
    end)
end

local function addBillboard(model, text, color)
    if not model or not (model:IsA("Model") or model:IsA("BasePart")) then return end
    local part = model:IsA("Model") and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart) or model
    if not part then return end
    local existing = part:FindFirstChild("StreeHubEsp")
    if existing then existing:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "StreeHubEsp"
    bb.Size = UDim2.new(0, 120, 0, 30)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = part
    bb.Parent = part
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or model.Name
    lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.Parent = bb
    table.insert(EspObjects, bb)
end

local _walkOnWaterConn
local _noClipConn
local _espConn

local function setupLoops()
    _espConn = RunService.Heartbeat:Connect(function()
        if _G.EspPlayer or _G.EspChest or _G.EspFruit or _G.EspRealFruit or _G.EspFlower
            or _G.EspSeaBeast or _G.EspMonster or _G.EspGear then
            updateEsp()
        else
            clearEsp()
        end
    end)

    RunService.Heartbeat:Connect(function()
        if not Character or not Humanoid or not HRP then return end

        if _G.NoClip then
            for _, p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end

        if _G.WalkOnWater then
            local below = workspace:Raycast(HRP.Position, Vector3.new(0, -5, 0))
            if below and below.Instance and below.Instance.Material == Enum.Material.Water then
                HRP.CFrame = CFrame.new(HRP.Position.X, below.Position.Y + 3, HRP.Position.Z)
            end
        end

        if _G.AutoSetSpawn then
            pcall(function() invokeServer("SetSpawn") end)
        end

        if _G.AutoObservation then
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            end)
        end

        if _G.AutoHaki then
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, game)
            end)
        end
    end)
end
setupLoops()

local _farmConn
RunService.Heartbeat:Connect(function()
    if not Character or not Humanoid or not HRP then return end
    if Humanoid.Health <= 0 then
        if _G.AutoRejoin then
            task.wait(3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end
        return
    end

    if _G.AutoFarmLevel or _G.AutoFarmNearest then
        local enemy = getClosestEnemy(60)
        if enemy then attackEnemy(enemy) end
    end

    if _G.AutoFarmBoss and _G.SelectedBoss then
        local boss = findNearestNPC(_G.SelectedBoss)
        if boss then
            local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
            if r then
                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                pcall(function()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                end)
            end
        end
    end

    if _G.AutoCollectBerry then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "Berry" or obj.Name == "Money" and obj:IsA("BasePart") then
                HRP.CFrame = CFrame.new(obj.Position)
                break
            end
        end
    end

    if _G.AutoFarmChestTween or _G.AutoFarmChestInst then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("chest") and obj:IsA("BasePart") then
                if _G.AutoFarmChestInst then
                    HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                else
                    tweenTo(obj.Position + Vector3.new(0, 2, 0))
                end
                task.wait(0.5)
                pcall(function() fireclickdetector(obj) end)
                break
            end
        end
    end
end)

local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Blox Fruits",
    Images  = "139538383104637",
    Color   = Color3.fromRGB(255, 50, 50),
    Version = 1,
})

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

-- ===================== MAIN TAB =====================

local InfoSection = Tabs.Main:AddSection("StreeHub | Info")
InfoSection:AddParagraph({ Title = "Game Time", Content = tostring(os.date("%H:%M:%S")), Icon = "clock" })
local FpsPara = InfoSection:AddParagraph({ Title = "FPS", Content = "0", Icon = "activity" })
local PingPara = InfoSection:AddParagraph({ Title = "Ping", Content = "0 ms", Icon = "wifi" })
InfoSection:AddParagraph({ Title = "Discord Server", Content = "discord.gg/streehub", Icon = "discord" })
InfoSection:AddPanel({
    Title = "Join Discord",
    ButtonText = "Copy Link",
    ButtonCallback = function()
        if setclipboard then setclipboard("https://discord.gg/streehub") end
        notify("Discord link copied!")
    end
})

task.spawn(function()
    local fps = 0
    RunService.RenderStepped:Connect(function(dt) fps = math.floor(1/dt) end)
    while task.wait(1) do
        pcall(function()
            if FpsPara and FpsPara.SetContent then FpsPara:SetContent(tostring(fps)) end
        end)
        pcall(function()
            local ping = math.floor(Stats.NetworkStats.ServerStatsItem["Data Ping"].Value)
            if PingPara and PingPara.SetContent then PingPara:SetContent(tostring(ping) .. " ms") end
        end)
    end
end)

local AutoFarmSection = Tabs.Main:AddSection("StreeHub | Auto Farm")
AutoFarmSection:AddDropdown({
    Title = "Weapon",
    Content = "Pilih senjata untuk auto farm.",
    Options = { "Sword", "Gun", "Devil Fruit", "Melee" },
    Default = "Sword",
    Callback = function(v) _G.SelectedWeapon = v end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Level",
    Content = "Otomatis farm mob untuk naik level.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmLevel = s
        notify("Auto Farm Level: " .. (s and "ON" or "OFF"))
    end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Nearest",
    Content = "Farm musuh terdekat secara otomatis.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmNearest = s
        notify("Auto Farm Nearest: " .. (s and "ON" or "OFF"))
    end
})

local ValentineSection = Tabs.Main:AddSection("StreeHub | Valentine Event")
ValentineSection:AddToggle({
    Title = "Auto Farm Hearts",
    Content = "Otomatis farm hati untuk event Valentine.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmHearts = s
        notify("Auto Farm Hearts: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFarmHearts do
                    pcall(function() invokeServer("FarmHearts") end)
                    task.wait(1)
                end
            end)
        end
    end
})
ValentineSection:AddParagraph({ Title = "Hearts", Content = "0", Icon = "heart" })
ValentineSection:AddParagraph({ Title = "Cupid Quest", Content = "-", Icon = "info" })
ValentineSection:AddToggle({
    Title = "Auto Cupid Quest",
    Content = "Otomatis selesaikan Cupid Quest.",
    Default = false,
    Callback = function(s)
        _G.AutoCupidQuest = s
        notify("Auto Cupid Quest: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoCupidQuest do
                    pcall(function() invokeServer("CupidQuest") end)
                    task.wait(2)
                end
            end)
        end
    end
})
ValentineSection:AddToggle({
    Title = "Auto Delivery Quest",
    Content = "Otomatis selesaikan Delivery Quest.",
    Default = false,
    Callback = function(s)
        _G.AutoDeliveryQuest = s
        notify("Auto Delivery Quest: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoDeliveryQuest do
                    pcall(function() invokeServer("DeliveryQuest") end)
                    task.wait(2)
                end
            end)
        end
    end
})
ValentineSection:AddDivider()
ValentineSection:AddDropdown({
    Title = "Valentine Shop",
    Content = "Pilih item Valentine.",
    Options = {},
    Default = nil,
    Callback = function(v) _G.ValentineItem = v end
})
ValentineSection:AddButton({
    Title = "Refresh Shop",
    Callback = function()
        notify("Refreshing shop...")
        pcall(function() invokeServer("RefreshValentineShop") end)
    end
})
ValentineSection:AddParagraph({ Title = "Item Price", Content = "-", Icon = "tag" })
ValentineSection:AddButton({
    Title = "Buy Item",
    Callback = function()
        if _G.ValentineItem then
            pcall(function() invokeServer("BuyValentineItem", _G.ValentineItem) end)
            notify("Membeli: " .. tostring(_G.ValentineItem))
        else
            notify("Pilih item terlebih dahulu.")
        end
    end
})
ValentineSection:AddToggle({
    Title = "Auto Valentines Gacha",
    Content = "Otomatis spin Valentine Gacha.",
    Default = false,
    Callback = function(s)
        _G.AutoVGacha = s
        notify("Auto Valentines Gacha: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoVGacha do
                    pcall(function() invokeServer("ValentineGacha") end)
                    task.wait(1.5)
                end
            end)
        end
    end
})

local MasterySection = Tabs.Main:AddSection("StreeHub | Mastery Farm")
MasterySection:AddDropdown({
    Title = "Choose Method",
    Content = "Pilih metode mastery farming.",
    Options = { "Mob", "Sea Beast", "Player" },
    Default = "Mob",
    Callback = function(v) _G.SelectedMethod = v end
})
MasterySection:AddToggle({
    Title = "Auto Fruit Mastery",
    Content = "Otomatis farm Devil Fruit mastery.",
    Default = false,
    Callback = function(s)
        _G.AutoFruitMastery = s
        notify("Auto Fruit Mastery: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFruitMastery do
                    local enemy = getClosestEnemy(60)
                    if enemy then
                        local r = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
                        if r and HRP then
                            local hp = Humanoid and Humanoid.Health or 100
                            local maxhp = Humanoid and Humanoid.MaxHealth or 100
                            if hp / maxhp * 100 > (_G.MasteryHealth or 20) then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                                local key = _G.SelectedFruitSkill or "Z"
                                local vk = key == "Z" and Enum.KeyCode.Z or key == "X" and Enum.KeyCode.X or key == "C" and Enum.KeyCode.C or key == "V" and Enum.KeyCode.V or Enum.KeyCode.F
                                pcall(function()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, vk, false, game)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, vk, false, game)
                                end)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
MasterySection:AddToggle({
    Title = "Auto Gun Mastery",
    Content = "Otomatis farm Gun mastery.",
    Default = false,
    Callback = function(s)
        _G.AutoGunMastery = s
        notify("Auto Gun Mastery: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoGunMastery do
                    local enemy = getClosestEnemy(60)
                    if enemy then
                        local r = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            local key = _G.SelectedGunSkill or "Z"
                            local vk = key == "Z" and Enum.KeyCode.Z or key == "X" and Enum.KeyCode.X or Enum.KeyCode.C
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, vk, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, vk, false, game)
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
MasterySection:AddDropdown({
    Title = "Choose Sword",
    Content = "Pilih pedang untuk mastery farming.",
    Options = { "Katana", "Dual Katana", "Triple Katana", "Bisento", "Saber", "Yama", "Tushita", "CDK" },
    Default = "Katana",
    Callback = function(v) _G.SelectedSword = v end
})
MasterySection:AddToggle({
    Title = "Auto Sword Mastery",
    Content = "Otomatis farm Sword mastery.",
    Default = false,
    Callback = function(s)
        _G.AutoSwordMastery = s
        notify("Auto Sword Mastery: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoSwordMastery do
                    local enemy = getClosestEnemy(60)
                    if enemy then
                        local r = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(3, 1, 3))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local TyrantSection = Tabs.Main:AddSection("StreeHub | Tyrant Of The Skies")
TyrantSection:AddParagraph({ Title = "Eyes", Content = "0", Icon = "eye" })
TyrantSection:AddToggle({
    Title = "Auto Boss",
    Content = "Otomatis lawan boss Tyrant of the Skies.",
    Default = false,
    Callback = function(s)
        _G.AutoBoss = s
        notify("Auto Boss: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoBoss do
                    local boss = findNearestNPC("Tyrant")
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function() invokeServer("AttackBoss", "Tyrant") end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local MonFarmSection = Tabs.Main:AddSection("StreeHub | Mon Farm")
MonFarmSection:AddDropdown({
    Title = "Choose Mon",
    Content = "Pilih Mon untuk di-farm.",
    Options = { "Chimera", "Hydra", "Leviathan", "Sea Monster" },
    Default = "Chimera",
    Callback = function(v) _G.SelectedMon = v end
})
MonFarmSection:AddToggle({
    Title = "Auto Farm Mon",
    Content = "Otomatis farm Mon yang dipilih.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmMon = s
        notify("Auto Farm Mon: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFarmMon do
                    if _G.SelectedMon then
                        local mon = findNearestNPC(_G.SelectedMon)
                        if mon then
                            local r = mon:FindFirstChild("HumanoidRootPart") or mon.PrimaryPart
                            if r and HRP then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                                pcall(function()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                end)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local BerrySection = Tabs.Main:AddSection("StreeHub | Berry")
BerrySection:AddToggle({
    Title = "Auto Collect Berry",
    Content = "Otomatis kumpulkan berry.",
    Default = false,
    Callback = function(s)
        _G.AutoCollectBerry = s
        notify("Auto Collect Berry: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoCollectBerry do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not _G.AutoCollectBerry then break end
                        if (obj.Name == "Berry" or obj.Name == "Money") and obj:IsA("BasePart") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                            task.wait(0.1)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local BossFarmSection = Tabs.Main:AddSection("StreeHub | Boss Farm")
local BossStatusPara = BossFarmSection:AddParagraph({ Title = "Boss Status", Content = "-", Icon = "shield" })
BossFarmSection:AddDropdown({
    Title = "Choose Boss",
    Content = "Pilih boss untuk di-farm.",
    Options = { "Gorilla King", "Bobby", "Yeti", "Mob Leader", "Snow Lurker", "Franky",
        "Fishman Lord", "Wysper", "Thunder God", "Drip Mama", "Fajita", "Don Swan",
        "Smoke Admiral", "Magma Admiral", "Cursed Captain", "Order", "Stone",
        "Island Empress", "Pharaoh", "Boss Chief", "Longma", "Jack", "Apoo", "Queen", "King" },
    Default = "Gorilla King",
    Callback = function(v) _G.SelectedBoss = v end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm Boss",
    Content = "Otomatis farm boss yang dipilih.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmBoss = s
        notify("Auto Farm Boss: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFarmBoss do
                    if _G.SelectedBoss and HRP then
                        local boss = findNearestNPC(_G.SelectedBoss)
                        if boss then
                            local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                            if r then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                                pcall(function()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                end)
                            end
                        else
                            pcall(function() invokeServer("TeleportToBoss", _G.SelectedBoss) end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm All Boss",
    Content = "Otomatis farm semua boss secara bergantian.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmAllBoss = s
        notify("Auto Farm All Boss: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                local bossList = { "Gorilla King", "Bobby", "Yeti", "Mob Leader", "Snow Lurker", "Franky",
                    "Fishman Lord", "Wysper", "Thunder God", "Drip Mama", "Fajita", "Don Swan" }
                local idx = 1
                while _G.AutoFarmAllBoss do
                    local bossName = bossList[idx]
                    local boss = findNearestNPC(bossName)
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(2)
                    idx = idx % #bossList + 1
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
    Content = "Otomatis selesaikan Elite Hunter quest.",
    Default = false,
    Callback = function(s)
        _G.AutoEliteHunter = s
        notify("Auto Elite Hunter: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoEliteHunter do
                    pcall(function() invokeServer("EliteHunterQuest") end)
                    local enemy = getClosestEnemy(100)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
EliteSection:AddToggle({
    Title = "Auto Elite Hunter Hop",
    Content = "Server hop untuk Elite Hunter.",
    Default = false,
    Callback = function(s)
        _G.AutoEliteHunterHop = s
        notify("Auto Elite Hunter Hop: " .. (s and "ON" or "OFF"))
        if s then serverHop() end
    end
})

local BoneSection = Tabs.Main:AddSection("StreeHub | Bone Farm")
BoneSection:AddDropdown({
    Title = "Choose Method",
    Content = "Pilih metode bone farming.",
    Options = { "Cursed Captain", "Mob", "Boss" },
    Default = "Cursed Captain",
    Callback = function(v) _G.BoneMethod = v end
})
BoneSection:AddParagraph({ Title = "Bones Owned", Content = "0", Icon = "box" })
BoneSection:AddToggle({
    Title = "Auto Farm Bone",
    Content = "Otomatis farm tulang.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmBone = s
        notify("Auto Farm Bone: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFarmBone do
                    local target = findNearestNPC(_G.BoneMethod or "Cursed Captain")
                    if target then
                        local r = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
BoneSection:AddToggle({
    Title = "Auto Random Surprise",
    Content = "Otomatis gunakan Random Surprise Balls.",
    Default = false,
    Callback = function(s)
        _G.AutoRandomSurprise = s
        notify("Auto Random Surprise: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoRandomSurprise do
                    pcall(function() invokeServer("UseRandomSurprise") end)
                    task.wait(3)
                end
            end)
        end
    end
})

local PirateRaidSection = Tabs.Main:AddSection("StreeHub | Pirate Raid")
PirateRaidSection:AddToggle({
    Title = "Auto Pirate Raid",
    Content = "Otomatis selesaikan Pirate Raid.",
    Default = false,
    Callback = function(s)
        _G.AutoPirateRaid = s
        notify("Auto Pirate Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoPirateRaid do
                    pcall(function() invokeServer("StartPirateRaid") end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})

local ChestSection = Tabs.Main:AddSection("StreeHub | Chest Farm")
ChestSection:AddToggle({
    Title = "Auto Farm Chest Tween",
    Content = "Tween ke chest dan buka otomatis.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmChestTween = s
        notify("Auto Farm Chest Tween: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFarmChestTween do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not _G.AutoFarmChestTween then break end
                        if obj.Name:lower():find("chest") and obj:IsA("BasePart") then
                            tweenTo(obj.Position + Vector3.new(0, 2, 0))
                            task.wait(1)
                            pcall(function() fireclickdetector(obj) end)
                            task.wait(0.5)
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
    Content = "Teleport ke chest secara instan.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmChestInst = s
        notify("Auto Farm Chest Instant: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFarmChestInst do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not _G.AutoFarmChestInst then break end
                        if obj.Name:lower():find("chest") and obj:IsA("BasePart") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                            task.wait(0.3)
                            pcall(function() fireclickdetector(obj) end)
                            task.wait(0.2)
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
    Content = "Otomatis stop pickup item saat chest farming.",
    Default = false,
    Callback = function(s)
        _G.AutoStopItems = s
        notify("Auto Stop Items: " .. (s and "ON" or "OFF"))
    end
})

local CakeSection = Tabs.Main:AddSection("StreeHub | Cake Prince")
CakeSection:AddParagraph({ Title = "Cake Prince Status", Content = "-", Icon = "crown" })
CakeSection:AddToggle({
    Title = "Auto Katakuri",
    Content = "Otomatis lawan Katakuri.",
    Default = false,
    Callback = function(s)
        _G.AutoKatakuri = s
        notify("Auto Katakuri: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoKatakuri do
                    local boss = findNearestNPC("Katakuri")
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    else
                        pcall(function() invokeServer("TeleportToBoss", "Katakuri") end)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Spawn Cake Prince",
    Content = "Otomatis spawn Cake Prince.",
    Default = false,
    Callback = function(s)
        _G.AutoSpawnCakePrince = s
        notify("Auto Spawn Cake Prince: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoSpawnCakePrince do
                    pcall(function() invokeServer("SpawnCakePrince") end)
                    task.wait(5)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Kill Cake Prince",
    Content = "Otomatis bunuh Cake Prince.",
    Default = false,
    Callback = function(s)
        _G.AutoKillCakePrince = s
        notify("Auto Kill Cake Prince: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoKillCakePrince do
                    local boss = findNearestNPC("Cake Prince")
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Kill Dough King",
    Content = "Otomatis bunuh Dough King.",
    Default = false,
    Callback = function(s)
        _G.AutoKillDoughKing = s
        notify("Auto Kill Dough King: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoKillDoughKing do
                    local boss = findNearestNPC("Dough King")
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local MaterialSection = Tabs.Main:AddSection("StreeHub | Materials")
MaterialSection:AddDropdown({
    Title = "Choose Material",
    Content = "Pilih material untuk di-farm.",
    Options = { "Magma Ore", "Dragon Scale", "Fish Tail", "Mystic Droplet", "Scrap Metal",
        "Leather", "Meteorite", "Radioactive Material", "Demonic Wisp", "Vampire Fang",
        "Conjured Cocoa", "Wool", "Gunpowder", "Mini Tusk" },
    Default = "Magma Ore",
    Callback = function(v) _G.SelectedMaterial = v end
})
MaterialSection:AddToggle({
    Title = "Auto Farm Material",
    Content = "Otomatis farm material yang dipilih.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmMaterial = s
        notify("Auto Farm Material: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoFarmMaterial do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not _G.AutoFarmMaterial then break end
                        if obj.Name == (_G.SelectedMaterial or "Magma Ore") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                            task.wait(0.5)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Settings (in Main)
local SettingsMainSection = Tabs.Main:AddSection("StreeHub | Settings")
SettingsMainSection:AddToggle({
    Title = "Spin Position",
    Content = "Berputar di sekitar posisi target.",
    Default = false,
    Callback = function(s) _G.SpinPosition = s end
})
SettingsMainSection:AddSlider({
    Title = "Farm Distance",
    Content = "Jarak ke enemy saat farming.",
    Min = 5, Max = 60, Increment = 1, Default = 15,
    Callback = function(v) _G.FarmDistance = v end
})
SettingsMainSection:AddSlider({
    Title = "Player Tween Speed",
    Content = "Kecepatan tween player ke target.",
    Min = 10, Max = 250, Increment = 5, Default = 30,
    Callback = function(v) _G.TweenSpeed = v end
})
SettingsMainSection:AddToggle({
    Title = "Bring Mob",
    Content = "Tarik mob ke kamu sebelum menyerang.",
    Default = false,
    Callback = function(s)
        _G.BringMob = s
        if s then
            task.spawn(function()
                while _G.BringMob do
                    local mob = findNearestNPC(_G.SelectedBringMob or "")
                    if mob and HRP then
                        local r = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
                        if r then r.CFrame = HRP.CFrame * CFrame.new(5, 0, 0) end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
SettingsMainSection:AddDropdown({
    Title = "Bring Mob",
    Content = "Pilih mob yang akan ditarik.",
    Options = { "All", "Quest Mob", "Selected Mob" },
    Default = "All",
    Callback = function(v) _G.SelectedBringMob = v end
})
SettingsMainSection:AddToggle({
    Title = "Attack Aura",
    Content = "Aktifkan attack aura saat auto farm.",
    Default = false,
    Callback = function(s)
        _G.AttackAura = s
        if s then
            task.spawn(function()
                while _G.AttackAura do
                    pcall(function()
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end)
                    task.wait(0.3)
                end
            end)
        end
    end
})

local GraphicSection = Tabs.Main:AddSection("StreeHub | Graphic")
GraphicSection:AddToggle({
    Title = "Hide Notification",
    Content = "Sembunyikan notifikasi kill in-game.",
    Default = false,
    Callback = function(s)
        _G.HideNotif = s
        pcall(function()
            local notifGui = CoreGui:FindFirstChild("RobloxGui")
            if notifGui then notifGui.Enabled = not s end
        end)
    end
})
GraphicSection:AddToggle({
    Title = "Hide Damage Text",
    Content = "Sembunyikan floating damage text.",
    Default = false,
    Callback = function(s)
        _G.HideDamage = s
        if s then
            task.spawn(function()
                while _G.HideDamage do
                    for _, gui in pairs(Workspace:GetDescendants()) do
                        if gui:IsA("BillboardGui") and gui.Name:find("Damage") then
                            gui.Enabled = false
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
GraphicSection:AddToggle({
    Title = "Black Screen",
    Content = "Layar hitam untuk performa.",
    Default = false,
    Callback = function(s)
        _G.BlackScreen = s
        Lighting.Brightness = s and 0 or 2
        Lighting.Ambient = s and Color3.fromRGB(0,0,0) or Color3.fromRGB(70,70,70)
    end
})
GraphicSection:AddToggle({
    Title = "White Screen",
    Content = "Layar putih untuk performa.",
    Default = false,
    Callback = function(s)
        _G.WhiteScreen = s
        Lighting.Brightness = s and 10 or 2
        Lighting.Ambient = s and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70)
    end
})

local MasterySettSection = Tabs.Main:AddSection("StreeHub | Mastery")
MasterySettSection:AddSlider({
    Title = "Mastery Health %",
    Content = "Minimum HP % sebelum mundur saat mastery farm.",
    Min = 5, Max = 80, Increment = 5, Default = 20,
    Callback = function(v) _G.MasteryHealth = v end
})

local FruitSkillSection = Tabs.Main:AddSection("StreeHub | Devil Fruit Skill")
FruitSkillSection:AddDropdown({
    Title = "Choose Fruit Skill",
    Content = "Pilih skill buah yang digunakan.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) _G.SelectedFruitSkill = v end
})

local GunSkillSection = Tabs.Main:AddSection("StreeHub | Gun Skill")
GunSkillSection:AddDropdown({
    Title = "Choose Gun Skill",
    Content = "Pilih skill gun yang digunakan.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) _G.SelectedGunSkill = v end
})

local OthersMainSection = Tabs.Main:AddSection("StreeHub | Others")
OthersMainSection:AddToggle({
    Title = "Auto Set Spawn Point",
    Content = "Otomatis set spawn point.",
    Default = false,
    Callback = function(s)
        _G.AutoSetSpawn = s
        if s then pcall(function() invokeServer("SetSpawn") end) end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Observation",
    Content = "Otomatis aktifkan Observation Haki.",
    Default = false,
    Callback = function(s)
        _G.AutoObservation = s
        if s then
            task.spawn(function()
                while _G.AutoObservation do
                    pcall(function()
                        invokeServer("Observation", true)
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Haki",
    Content = "Otomatis aktifkan Buso Haki.",
    Default = false,
    Callback = function(s)
        _G.AutoHaki = s
        if s then
            task.spawn(function()
                while _G.AutoHaki do
                    pcall(function() invokeServer("Haki", true) end)
                    task.wait(5)
                end
            end)
        end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Rejoin",
    Content = "Otomatis rejoin saat karakter mati.",
    Default = false,
    Callback = function(s)
        _G.AutoRejoin = s
        notify("Auto Rejoin: " .. (s and "ON" or "OFF"))
    end
})

-- ===================== OTHERS TAB =====================

local SeaEventOthersSection = Tabs.Others:AddSection("StreeHub | Sea Event")
SeaEventOthersSection:AddToggle({
    Title = "Lightning",
    Content = "Auto dodge lightning saat sea event.",
    Default = false,
    Callback = function(s)
        _G.Lightning = s
        if s then
            task.spawn(function()
                while _G.Lightning do
                    pcall(function() invokeServer("LightningDodge") end)
                    task.wait(0.5)
                end
            end)
        end
    end
})
SeaEventOthersSection:AddDropdown({
    Title = "Tools",
    Content = "Pilih tool untuk sea event.",
    Options = { "Pipe", "Bazooka", "Flintlock", "Cannon", "Flower Minigame" },
    Default = "Pipe",
    Callback = function(v) _G.SeaEventTool = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Devil Fruit",
    Content = "Pilih skill buah untuk sea event.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) _G.SeaEventFruit = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Melee",
    Content = "Pilih skill melee untuk sea event.",
    Options = { "Z", "X", "C", "V" },
    Default = "Z",
    Callback = function(v) _G.SeaEventMelee = v end
})

local WorldSection = Tabs.Others:AddSection("StreeHub | World")
WorldSection:AddToggle({
    Title = "Auto Second Sea",
    Content = "Otomatis selesaikan quest ke Second Sea.",
    Default = false,
    Callback = function(s)
        _G.AutoSecondSea = s
        notify("Auto Second Sea: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoSecondSea do
                    pcall(function() invokeServer("SecondSeaQuest") end)
                    task.wait(2)
                end
            end)
        end
    end
})
WorldSection:AddToggle({
    Title = "Auto Third Sea",
    Content = "Otomatis selesaikan quest ke Third Sea.",
    Default = false,
    Callback = function(s)
        _G.AutoThirdSea = s
        notify("Auto Third Sea: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoThirdSea do
                    pcall(function() invokeServer("ThirdSeaQuest") end)
                    task.wait(2)
                end
            end)
        end
    end
})

local FightingStyleSection = Tabs.Others:AddSection("StreeHub | Fighting Style")
local fightStyles = {
    { "Auto Super Human",    "AutoSuperHuman",    "SuperHuman" },
    { "Auto Death Step",     "AutoDeathStep",     "DeathStep" },
    { "Auto Sharkman Karate","AutoSharkmanKarate","SharkmanKarate" },
    { "Auto Electric Claw",  "AutoElectricClaw",  "ElectricClaw" },
    { "Auto Dragon Talon",   "AutoDragonTalon",   "DragonTalon" },
    { "Auto God Human",      "AutoGodHuman",      "GodHuman" },
}
for _, fs in ipairs(fightStyles) do
    FightingStyleSection:AddToggle({
        Title = fs[1],
        Content = "Otomatis dapatkan " .. fs[3] .. ".",
        Default = false,
        Callback = function(s)
            _G[fs[2]] = s
            if s then
                task.spawn(function()
                    while _G[fs[2]] do
                        pcall(function() invokeServer("GetFightingStyle", fs[3]) end)
                        task.wait(3)
                    end
                end)
            end
        end
    })
end

local GunSwordSection = Tabs.Others:AddSection("StreeHub | Gun & Sword")
local swordList = {
    { "Auto Get Saber",     "AutoGetSaber",     "Saber" },
    { "Auto Buddy Sword",   "AutoBuddySword",   "BuddySword" },
    { "Auto Soul Guitar",   "AutoSoulGuitar",   "SoulGuitar" },
    { "Auto Rengoku",       "AutoRengoku",       "Rengoku" },
    { "Auto Hallow Scythe", "AutoHallowScythe", "HallowScythe" },
    { "Auto Warden Sword",  "AutoWardenSword",  "WardenSword" },
    { "Auto Get Yama",      "AutoGetYama",      "Yama" },
    { "Auto Get Yama Hop",  "AutoGetYamaHop",   "YamaHop" },
    { "Auto Get Tushita",   "AutoGetTushita",   "Tushita" },
}
for _, sw in ipairs(swordList) do
    GunSwordSection:AddToggle({
        Title = sw[1],
        Content = "Otomatis dapatkan " .. sw[3] .. ".",
        Default = false,
        Callback = function(s)
            _G[sw[2]] = s
            if s then
                task.spawn(function()
                    while _G[sw[2]] do
                        pcall(function() invokeServer("GetSword", sw[3]) end)
                        task.wait(3)
                    end
                end)
            end
        end
    })
end

local CDKSection = Tabs.Others:AddSection("StreeHub | Cursed Dual Katana")
local cdkList = {
    { "Auto Get CDK",               "AutoGetCDK",          "CDK" },
    { "Auto Quest CDK [ Yama ]",    "AutoQuestCDKYama",    "CDKYama" },
    { "Auto Quest CDK [ Tushita ]", "AutoQuestCDKTushita", "CDKTushita" },
    { "Auto Dragon Trident",        "AutoDragonTrident",   "DragonTrident" },
    { "Auto Greybeard",             "AutoGreybeard",       "Greybeard" },
    { "Auto Shark Saw",             "AutoSharkSaw",        "SharkSaw" },
    { "Auto Pole",                  "AutoPole",            "Pole" },
    { "Auto Dark Dagger",           "AutoDarkDagger",      "DarkDagger" },
}
for _, cd in ipairs(cdkList) do
    CDKSection:AddToggle({
        Title = cd[1],
        Content = "Otomatis dapatkan " .. cd[3] .. ".",
        Default = false,
        Callback = function(s)
            _G[cd[2]] = s
            if s then
                task.spawn(function()
                    while _G[cd[2]] do
                        pcall(function() invokeServer("GetSword", cd[3]) end)
                        task.wait(3)
                    end
                end)
            end
        end
    })
end

-- ===================== STATS TAB =====================

local StatsSection = Tabs.Stats:AddSection("StreeHub | Stats")
local statList = {
    { "Add Melee Stats",       "AddMeleeStats",   "Melee" },
    { "Add Defense Stats",     "AddDefenseStats", "Defense" },
    { "Add Sword Stats",       "AddSwordStats",   "Sword" },
    { "Add Gun Stats",         "AddGunStats",     "Gun" },
    { "Add Devil Fruit Stats", "AddDFStats",      "Devil_Fruit" },
}
for _, st in ipairs(statList) do
    StatsSection:AddToggle({
        Title = st[1],
        Content = "Otomatis distribusikan point ke " .. st[3] .. ".",
        Default = false,
        Callback = function(s)
            _G[st[2]] = s
            if s then
                task.spawn(function()
                    while _G[st[2]] do
                        buyStats(st[3], _G.StatPoint or 1)
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end
StatsSection:AddSlider({
    Title = "Point",
    Content = "Jumlah point per alokasi.",
    Min = 1, Max = 100, Increment = 1, Default = 1,
    Callback = function(v) _G.StatPoint = v end
})

-- ===================== RAID TAB =====================

local RaidSection = Tabs.Raid:AddSection("StreeHub | Raid")
RaidSection:AddParagraph({ Title = "Raid Time", Content = "-", Icon = "clock" })
RaidSection:AddParagraph({ Title = "Island", Content = "-", Icon = "map-pin" })
RaidSection:AddDropdown({
    Title = "Choose Chip",
    Content = "Pilih raid chip.",
    Options = { "Smoke","Magma","Sand","Ice","Light","Rumble","String","Quake","Dark",
        "Phoenix","Flame","Falcon","Buddha","Spider","Sound","Blizzard","Gravity",
        "Dough","Shadow","Venom","Control","Spirit","Dragon","Leopard","Kitsune" },
    Default = "Smoke",
    Callback = function(v) _G.SelectedChip = v end
})
RaidSection:AddToggle({
    Title = "Auto Raid",
    Content = "Otomatis selesaikan raid.",
    Default = false,
    Callback = function(s)
        _G.AutoRaid = s
        notify("Auto Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoRaid do
                    pcall(function() invokeServer("StartRaid", _G.SelectedChip or "Smoke") end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
RaidSection:AddToggle({
    Title = "Auto Awaken",
    Content = "Otomatis awaken devil fruit saat raid.",
    Default = false,
    Callback = function(s)
        _G.AutoAwaken = s
        notify("Auto Awaken: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoAwaken do
                    pcall(function() invokeServer("AwakenFruit") end)
                    task.wait(2)
                end
            end)
        end
    end
})
RaidSection:AddDropdown({
    Title = "Unstore Rarity Fruit",
    Content = "Rarity buah yang akan di-unstore sebelum raid.",
    Options = { "Common - Mythical","Uncommon - Mythical","Rare - Mythical","Legendary - Mythical","Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) _G.SelectedUnstoreFruit = v end
})
RaidSection:AddToggle({
    Title = "Auto Unstore Devil Fruit",
    Content = "Otomatis unstore devil fruit sebelum raid.",
    Default = false,
    Callback = function(s)
        _G.AutoUnstoreFruit = s
        if s then
            task.spawn(function()
                while _G.AutoUnstoreFruit do
                    pcall(function() invokeServer("UnstoreFruit", _G.SelectedUnstoreFruit) end)
                    task.wait(2)
                end
            end)
        end
    end
})
RaidSection:AddPanel({
    Title = "Raid Lab",
    ButtonText = "Teleport To Lab",
    ButtonCallback = function()
        notify("Teleporting to Lab...")
        pcall(function() invokeServer("TeleportToLab") end)
        teleportTo(Vector3.new(-1413.87, 190.2, -3263.92))
    end
})

local LawRaidSection = Tabs.Raid:AddSection("StreeHub | Law Raid")
LawRaidSection:AddToggle({
    Title = "Auto Law Raid",
    Content = "Otomatis selesaikan Law Raid.",
    Default = false,
    Callback = function(s)
        _G.AutoLawRaid = s
        notify("Auto Law Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while _G.AutoLawRaid do
                    pcall(function() invokeServer("LawRaid") end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})

local DungeonSection = Tabs.Raid:AddSection("StreeHub | Dungeon")
DungeonSection:AddPanel({
    Title = "Dungeon Hub",
    ButtonText = "Teleport To Dungeon Hub",
    ButtonCallback = function()
        notify("Teleporting to Dungeon Hub...")
        pcall(function() invokeServer("TeleportToDungeonHub") end)
        teleportTo(Vector3.new(996, 87.2, -1204))
    end
})
DungeonSection:AddToggle({
    Title = "Auto Attack Mon",
    Content = "Otomatis serang mob di dungeon.",
    Default = false,
    Callback = function(s)
        _G.AutoAttackMon = s
        if s then
            task.spawn(function()
                while _G.AutoAttackMon do
                    local enemy = getClosestEnemy(60)
                    if enemy then attackEnemy(enemy) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DungeonSection:AddToggle({
    Title = "Auto Next Floor",
    Content = "Otomatis lanjut ke lantai berikutnya.",
    Default = false,
    Callback = function(s)
        _G.AutoNextFloor = s
        if s then
            task.spawn(function()
                while _G.AutoNextFloor do
                    pcall(function() invokeServer("NextDungeonFloor") end)
                    task.wait(3)
                end
            end)
        end
    end
})
DungeonSection:AddToggle({
    Title = "Auto Return To Hub",
    Content = "Otomatis kembali ke hub setelah dungeon.",
    Default = false,
    Callback = function(s)
        _G.AutoReturnHub = s
        if s then
            task.spawn(function()
                while _G.AutoReturnHub do
                    pcall(function() invokeServer("ReturnToDungeonHub") end)
                    task.wait(5)
                end
            end)
        end
    end
})

-- ===================== RACE TAB =====================

local RaceSection = Tabs.Race:AddSection("StreeHub | Race")
RaceSection:AddToggle({
    Title = "Auto Buy Gear",
    Content = "Otomatis beli gear untuk race.",
    Default = false,
    Callback = function(s)
        _G.AutoBuyGear = s
        if s then
            task.spawn(function()
                while _G.AutoBuyGear do
                    pcall(function() invokeServer("BuyRaceGear") end)
                    task.wait(2)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Tween To Mirage Island",
    Content = "Tween ke lokasi Mirage Island.",
    Default = false,
    Callback = function(s)
        _G.TweenMirageIsland = s
        if s and HRP then
            tweenTo(Vector3.new(-1663, 170, -327))
        end
    end
})
RaceSection:AddToggle({
    Title = "Find Blue Gear",
    Content = "Otomatis temukan dan kumpulkan blue gear.",
    Default = false,
    Callback = function(s)
        _G.FindBlueGear = s
        if s then
            task.spawn(function()
                while _G.FindBlueGear do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("gear") and obj:IsA("BasePart") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
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
    Content = "Lihat bulan dan gunakan ability race.",
    Default = false,
    Callback = function(s)
        _G.LookMoon = s
        if s then
            task.spawn(function()
                while _G.LookMoon do
                    pcall(function()
                        local moon = Workspace:FindFirstChild("Moon")
                        if moon and HRP then
                            HRP.CFrame = CFrame.new(HRP.Position, Vector3.new(moon.Position.X, HRP.Position.Y, moon.Position.Z))
                        end
                        invokeServer("UseRaceAbility")
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Auto Train",
    Content = "Otomatis latih untuk race.",
    Default = false,
    Callback = function(s)
        _G.AutoTrain = s
        if s then
            task.spawn(function()
                while _G.AutoTrain do
                    pcall(function() invokeServer("RaceTrain") end)
                    task.wait(2)
                end
            end)
        end
    end
})
RaceSection:AddPanel({
    Title = "Race Actions",
    ButtonText = "Teleport To Race Door",
    ButtonCallback = function()
        notify("Teleporting to Race Door...")
        teleportTo(Vector3.new(-1434.9, 196.2, -3283.7))
    end,
    SubButtonText = "Buy Ancient Quest",
    SubButtonCallback = function()
        notify("Buying Ancient Quest...")
        pcall(function() invokeServer("BuyAncientQuest") end)
    end
})
RaceSection:AddToggle({
    Title = "Auto Trial",
    Content = "Otomatis selesaikan race trials.",
    Default = false,
    Callback = function(s)
        _G.AutoTrial = s
        if s then
            task.spawn(function()
                while _G.AutoTrial do
                    pcall(function() invokeServer("RaceTrial") end)
                    local enemy = getClosestEnemy(60)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Auto Kill Player After Trial",
    Content = "Bunuh player setelah trial selesai.",
    Default = false,
    Callback = function(s)
        _G.AutoKillAfterTrial = s
        if s then
            task.spawn(function()
                while _G.AutoKillAfterTrial do
                    pcall(function() invokeServer("KillPlayerAfterTrial") end)
                    task.wait(1)
                end
            end)
        end
    end
})

-- ===================== COMBAT TAB =====================

local CombatSection = Tabs.Combat:AddSection("StreeHub | Combat")
local PlayerListDropdown
CombatSection:AddParagraph({ Title = "Players In Server", Content = tostring(#Players:GetPlayers()-1), Icon = "users" })
PlayerListDropdown = CombatSection:AddDropdown({
    Title = "Choose Player",
    Content = "Pilih player untuk ditarget.",
    Options = getPlayerList(),
    Default = nil,
    Callback = function(v) _G.SelectedPlayer = v end
})
CombatSection:AddPanel({
    Title = "Player Actions",
    ButtonText = "Refresh Player",
    ButtonCallback = function()
        local list = getPlayerList()
        if PlayerListDropdown and PlayerListDropdown.SetValues then
            PlayerListDropdown:SetValues(list, list[1])
        end
        notify("Player list refreshed.")
    end,
    SubButtonText = "Spectate Player",
    SubButtonCallback = function()
        if _G.SelectedPlayer then
            local target = Players:FindFirstChild(_G.SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                teleportTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                notify("Spectating: " .. _G.SelectedPlayer)
            end
        end
    end
})
CombatSection:AddPanel({
    Title = "Teleport",
    ButtonText = "Teleport To Player",
    ButtonCallback = function()
        if _G.SelectedPlayer then
            local target = Players:FindFirstChild(_G.SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and HRP then
                HRP.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 3)
                notify("Teleported to " .. _G.SelectedPlayer)
            end
        else
            notify("Pilih player dulu.")
        end
    end
})

local IslandCombatSection = Tabs.Combat:AddSection("StreeHub | Island")
local IslandDropdown
IslandDropdown = IslandCombatSection:AddDropdown({
    Title = "Choose Island",
    Content = "Pilih island.",
    Options = { "Marine Starter", "Pirate Starter", "Middle Town", "Jungle", "Colosseum",
        "Marineford", "Skylands", "Fishman Island", "Wano", "Flower Hill",
        "Ice Castle", "Haunted Castle" },
    Default = "Middle Town",
    Callback = function(v) _G.SelectedIsland = v end
})
IslandCombatSection:AddPanel({
    Title = "Island Teleport",
    ButtonText = "Teleport To Island",
    ButtonCallback = function()
        if _G.SelectedIsland then
            notify("Teleporting to " .. _G.SelectedIsland)
            pcall(function() invokeServer("TeleportToIsland", _G.SelectedIsland) end)
        end
    end
})

local NpcCombatSection = Tabs.Combat:AddSection("StreeHub | Npc")
NpcCombatSection:AddDropdown({
    Title = "Choose Npc",
    Content = "Pilih NPC.",
    Options = { "Sword Dealer", "Arowe", "Terraformer", "Darkbeard", "Ice Admiral",
        "Swan", "Prison Chief", "Boss Chief", "Blackbeard" },
    Default = nil,
    Callback = function(v) _G.SelectedNpc = v end
})
NpcCombatSection:AddPanel({
    Title = "NPC Teleport",
    ButtonText = "Teleport To Npc",
    ButtonCallback = function()
        if _G.SelectedNpc and HRP then
            notify("Teleporting to " .. _G.SelectedNpc)
            local npc = findNearestNPC(_G.SelectedNpc)
            if npc then
                local r = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                if r then teleportTo(r.Position) end
            else
                pcall(function() invokeServer("TeleportToNPC", _G.SelectedNpc) end)
            end
        end
    end
})

-- ===================== ESP TAB =====================

local EspSection = Tabs.Esp:AddSection("StreeHub | ESP")
local espList = {
    { "Esp Player",            "EspPlayer" },
    { "Esp Chest",             "EspChest" },
    { "Esp Devil Fruit",       "EspFruit" },
    { "Esp Real Fruit",        "EspRealFruit" },
    { "Esp Flower",            "EspFlower" },
    { "Esp Island",            "EspIsland" },
    { "Esp Npc",               "EspNpc" },
    { "Esp Sea Beast",         "EspSeaBeast" },
    { "Esp Monster",           "EspMonster" },
    { "Esp Mirage Island",     "EspMirageIsland" },
    { "Esp Kitsune Island",    "EspKitsuneIsland" },
    { "Esp Frozen Dimension",  "EspFrozen" },
    { "Esp Prehistoric Island","EspPrehistoric" },
    { "Esp Gear",              "EspGear" },
}
for _, esp in ipairs(espList) do
    EspSection:AddToggle({
        Title = esp[1],
        Content = "Tampilkan ESP untuk " .. esp[1]:sub(5) .. ".",
        Default = false,
        Callback = function(s)
            _G[esp[2]] = s
            if not s then clearEsp() end
        end
    })
end

-- ===================== TELEPORT TAB =====================

local TeleportSection = Tabs.Teleport:AddSection("StreeHub | Teleport")
TeleportSection:AddDropdown({
    Title = "Selected Place",
    Content = "Pilih tempat untuk teleport.",
    Options = { "Marine Starter Island","Pirate Starter Island","Middle Town","Jungle",
        "Pirate Village","Desert","Navy Headquarters","Skylands","Colosseum",
        "Impel Down","Marineford","Enies Lobby","Fishman Island","Green Zone",
        "Kingdom of Rose","Wedding Island","Chamber of Time","Wano Country",
        "Haunted Castle","Hydra Island","Sea of Treats","Floating Turtle",
        "Demon Island","Tiki Island","Peanut Island" },
    Default = "Middle Town",
    Callback = function(v) _G.SelectedPlace = v end
})
TeleportSection:AddToggle({
    Title = "Teleport To Place",
    Content = "Teleport ke tempat yang dipilih.",
    Default = false,
    Callback = function(s)
        _G.TeleportToPlace = s
        if s and _G.SelectedPlace then
            notify("Teleporting to " .. _G.SelectedPlace)
            pcall(function() invokeServer("TeleportToIsland", _G.SelectedPlace) end)
        end
    end
})

local WorldTeleSection = Tabs.Teleport:AddSection("StreeHub | World")
WorldTeleSection:AddPanel({
    Title = "First Sea",
    ButtonText = "Teleport To First Sea",
    ButtonCallback = function()
        notify("Teleporting to First Sea...")
        pcall(function() invokeServer("TeleportToSea", 1) end)
        teleportTo(Vector3.new(-1276.2, 129.4, 4197.4))
    end
})
WorldTeleSection:AddPanel({
    Title = "Second Sea",
    ButtonText = "Teleport To Second Sea",
    ButtonCallback = function()
        notify("Teleporting to Second Sea...")
        pcall(function() invokeServer("TeleportToSea", 2) end)
        teleportTo(Vector3.new(-2.2, 15.4, -1410.7))
    end
})
WorldTeleSection:AddPanel({
    Title = "Third Sea",
    ButtonText = "Teleport To Third Sea",
    ButtonCallback = function()
        notify("Teleporting to Third Sea...")
        pcall(function() invokeServer("TeleportToSea", 3) end)
        teleportTo(Vector3.new(-7829.5, 5.4, -374.9))
    end
})

local IslandTeleSection = Tabs.Teleport:AddSection("StreeHub | Island")
IslandTeleSection:AddDropdown({
    Title = "Choose Island",
    Content = "Pilih island untuk teleport.",
    Options = { "Marine Starter","Pirate Starter","Middle Town","Jungle","Colosseum",
        "Marineford","Skylands","Fishman Island","Wano","Flower Hill","Ice Castle","Haunted Castle" },
    Default = "Middle Town",
    Callback = function(v) _G.SelectedIsland = v end
})
IslandTeleSection:AddPanel({
    Title = "Island Teleport",
    ButtonText = "Teleport To Island",
    ButtonCallback = function()
        if _G.SelectedIsland then
            notify("Teleporting to " .. _G.SelectedIsland)
            pcall(function() invokeServer("TeleportToIsland", _G.SelectedIsland) end)
        end
    end
})

local NpcTeleSection = Tabs.Teleport:AddSection("StreeHub | Npc")
NpcTeleSection:AddDropdown({
    Title = "Choose Npc",
    Content = "Pilih NPC untuk teleport.",
    Options = { "Sword Dealer","Arowe","Terraformer","Darkbeard","Ice Admiral","Swan","Prison Chief" },
    Default = nil,
    Callback = function(v) _G.SelectedNpc = v end
})
NpcTeleSection:AddPanel({
    Title = "NPC Teleport",
    ButtonText = "Teleport To Npc",
    ButtonCallback = function()
        if _G.SelectedNpc then
            notify("Teleporting to " .. _G.SelectedNpc)
            local npc = findNearestNPC(_G.SelectedNpc)
            if npc then
                local r = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
                if r and HRP then teleportTo(r.Position) end
            else
                pcall(function() invokeServer("TeleportToNPC", _G.SelectedNpc) end)
            end
        end
    end
})

-- ===================== SHOP TAB =====================

local ShopSection = Tabs.Shop:AddSection("StreeHub | Shop")
ShopSection:AddToggle({
    Title = "Auto Buy Legendary Sword",
    Content = "Otomatis beli legendary sword dari toko.",
    Default = false,
    Callback = function(s)
        _G.AutoBuyLegSword = s
        if s then
            task.spawn(function()
                while _G.AutoBuyLegSword do
                    pcall(function() invokeServer("BuyLegendarySword") end)
                    task.wait(2)
                end
            end)
        end
    end
})
ShopSection:AddToggle({
    Title = "Auto Buy Haki Color",
    Content = "Otomatis beli warna Haki.",
    Default = false,
    Callback = function(s)
        _G.AutoBuyHakiColor = s
        if s then
            task.spawn(function()
                while _G.AutoBuyHakiColor do
                    pcall(function() invokeServer("BuyHakiColor") end)
                    task.wait(2)
                end
            end)
        end
    end
})

local AbilityShopSection = Tabs.Shop:AddSection("StreeHub | Abilities")
local abilityList = { "Geppo", "Buso Haki", "Soru", "Observation Haki" }
for _, ab in ipairs(abilityList) do
    AbilityShopSection:AddPanel({
        Title = "Buy " .. ab,
        ButtonText = "Buy",
        ButtonCallback = function()
            notify("Buying " .. ab .. "...")
            pcall(function() invokeServer("BuyAbility", ab) end)
        end
    })
end

local FightStyleShopSection = Tabs.Shop:AddSection("StreeHub | Fighting Style Shop")
local fsShopList = { "Black Leg","Electro","Fishman Karate","Dragon Claw","Superhuman",
    "Death Step","Sharkman Karate","Electric Claw","Dragon Talon","God Human","Sanguine Art" }
for _, fs in ipairs(fsShopList) do
    FightStyleShopSection:AddPanel({
        Title = "Buy " .. fs,
        ButtonText = "Buy",
        ButtonCallback = function()
            notify("Buying " .. fs .. "...")
            pcall(function() invokeServer("BuyFightingStyle", fs) end)
        end
    })
end

local SwordShopSection = Tabs.Shop:AddSection("StreeHub | Sword Shop")
local swordShopList = { "Cutlass","Katana","Iron Mace","Dual Katana","Triple Katana","Pipe","Dual Headed Blade","Bisento","Soul Cane" }
for _, sw in ipairs(swordShopList) do
    SwordShopSection:AddPanel({
        Title = "Buy " .. sw,
        ButtonText = "Buy",
        ButtonCallback = function()
            notify("Buying " .. sw .. "...")
            pcall(function() invokeServer("BuySword", sw) end)
        end
    })
end

local GunShopSection = Tabs.Shop:AddSection("StreeHub | Gun Shop")
local gunShopList = { "Slingshot","Musket","Flintlock","Refined Flintlock","Cannon","Kabucha" }
for _, gn in ipairs(gunShopList) do
    GunShopSection:AddPanel({
        Title = "Buy " .. gn,
        ButtonText = "Buy",
        ButtonCallback = function()
            notify("Buying " .. gn .. "...")
            pcall(function() invokeServer("BuyGun", gn) end)
        end
    })
end

local StatResetSection = Tabs.Shop:AddSection("StreeHub | Stats Reset")
StatResetSection:AddPanel({
    Title = "Stats",
    ButtonText = "Reset Stats",
    ButtonCallback = function()
        notify("Resetting stats...")
        pcall(function() invokeServer("ResetStats") end)
    end,
    SubButtonText = "Random Race",
    SubButtonCallback = function()
        notify("Spinning for random race...")
        pcall(function() invokeServer("RandomRace") end)
    end
})

local AccessoriesSection = Tabs.Shop:AddSection("StreeHub | Accessories")
local accList = { "Black Cape","Swordsman Hat","Tomoe Ring" }
for _, ac in ipairs(accList) do
    AccessoriesSection:AddPanel({
        Title = "Buy " .. ac,
        ButtonText = "Buy",
        ButtonCallback = function()
            notify("Buying " .. ac .. "...")
            pcall(function() invokeServer("BuyAccessory", ac) end)
        end
    })
end

-- ===================== FRUIT TAB =====================

local FruitAutoSection = Tabs.Fruit:AddSection("StreeHub | Auto Fruit")
FruitAutoSection:AddToggle({
    Title = "Auto Random Fruit",
    Content = "Otomatis spin untuk random fruit.",
    Default = false,
    Callback = function(s)
        _G.AutoRandomFruit = s
        if s then
            task.spawn(function()
                while _G.AutoRandomFruit do
                    pcall(function() invokeServer("GetRandomFruit") end)
                    task.wait(2)
                end
            end)
        end
    end
})
FruitAutoSection:AddDropdown({
    Title = "Store Rarity Fruit",
    Content = "Pilih minimum rarity buah untuk disimpan.",
    Options = { "Common - Mythical","Uncommon - Mythical","Rare - Mythical","Legendary - Mythical","Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) _G.SelectedStoreFruit = v end
})
FruitAutoSection:AddToggle({
    Title = "Auto Store Fruit",
    Content = "Otomatis simpan buah sesuai rarity.",
    Default = false,
    Callback = function(s)
        _G.AutoStoreFruit = s
        if s then
            task.spawn(function()
                while _G.AutoStoreFruit do
                    pcall(function() invokeServer("StoreFruit", _G.SelectedStoreFruit) end)
                    task.wait(2)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Fruit Notification",
    Content = "Notifikasi saat buah spawn.",
    Default = false,
    Callback = function(s)
        _G.FruitNotif = s
        if s then
            task.spawn(function()
                while _G.FruitNotif do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:lower():find("fruit") then
                            notify("Buah ditemukan: " .. obj.Name, 5)
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Teleport To Fruit",
    Content = "Teleport instan ke buah yang spawn.",
    Default = false,
    Callback = function(s)
        _G.TeleportToFruit = s
        if s then
            task.spawn(function()
                while _G.TeleportToFruit do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:lower():find("fruit") then
                            local r = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                            if r and HRP then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(0, 3, 0))
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Tween To Fruit",
    Content = "Tween halus ke buah yang spawn.",
    Default = false,
    Callback = function(s)
        _G.TweenToFruit = s
        if s then
            task.spawn(function()
                while _G.TweenToFruit do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:lower():find("fruit") then
                            local r = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                            if r then tweenTo(r.Position + Vector3.new(0, 3, 0)) end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
FruitAutoSection:AddPanel({
    Title = "Grab Fruit",
    ButtonText = "Grab Fruit",
    ButtonCallback = function()
        notify("Grabbing nearest fruit...")
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("fruit") then
                local r = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                if r and HRP then
                    HRP.CFrame = CFrame.new(r.Position + Vector3.new(0, 2, 0))
                    pcall(function() fireclickdetector(r) end)
                    return
                end
            end
        end
    end
})

local FruitVisualSection = Tabs.Fruit:AddSection("StreeHub | Visual")
FruitVisualSection:AddPanel({
    Title = "Rain Fruit",
    ButtonText = "Rain Fruit",
    ButtonCallback = function()
        notify("Raining fruits...")
        pcall(function() invokeServer("RainFruits") end)
    end
})

-- ===================== MISC TAB =====================

local TeamSection = Tabs.Misc:AddSection("StreeHub | Teams")
TeamSection:AddPanel({
    Title = "Teams",
    ButtonText = "Join Pirates Team",
    ButtonCallback = function()
        notify("Joining Pirates...")
        pcall(function() invokeServer("JoinTeam", "Pirates") end)
    end,
    SubButtonText = "Join Marines Team",
    SubButtonCallback = function()
        notify("Joining Marines...")
        pcall(function() invokeServer("JoinTeam", "Marines") end)
    end
})

local CodesSection = Tabs.Misc:AddSection("StreeHub | Codes")
CodesSection:AddPanel({
    Title = "Codes",
    ButtonText = "Redeem All Codes",
    ButtonCallback = function()
        notify("Redeeming all codes...")
        local codes = { "Sub2Fer999","Sub2NoobMaster123","Sub2Daigrock","Bluxxy",
            "Enyu_is_Pro","Magicbus","JCWK","StrawHatMaine","Sub2Bignews",
            "CHANDLER","Sub2OfficialNoobie","fudd10","fudd10v2","starcodeheo",
            "Sub2UncleKizaru","SUB2GAMERROBOT_EXP1","Sub2GamerRobot",
            "TantaiGaming","EXP_BOOST_100","kittgaming" }
        task.spawn(function()
            for _, code in ipairs(codes) do
                pcall(function() invokeServer("REDEEM_CODE", code) end)
                task.wait(0.5)
            end
            notify("Semua kode sudah di-redeem!", 4, Color3.fromRGB(0, 255, 0))
        end)
    end
})

local GraphicsMiscSection = Tabs.Misc:AddSection("StreeHub | Graphics")
GraphicsMiscSection:AddPanel({
    Title = "Performance",
    ButtonText = "Fps Boost",
    ButtonCallback = function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        notify("FPS Boost aktif!")
    end,
    SubButtonText = "Remove Fog",
    SubButtonCallback = function()
        Lighting.FogEnd = 1e9
        Lighting.FogStart = 1e9
        notify("Fog dihapus!")
    end
})
GraphicsMiscSection:AddPanel({
    Title = "Remove Lava",
    ButtonText = "Remove Lava",
    ButtonCallback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Material == Enum.Material.Neon and v.Name:lower():find("lava") then
                v.Transparency = 1
                v.CanCollide = false
            end
        end
        notify("Lava dihapus!")
    end
})

-- ===================== LOCAL PLAYER TAB =====================

local LocalPlayerSection = Tabs.LocalPlayer:AddSection("StreeHub | Local Player")
LocalPlayerSection:AddToggle({
    Title = "Active Race V3",
    Content = "Aktifkan Race V3 ability.",
    Default = false,
    Callback = function(s)
        _G.ActiveRaceV3 = s
        pcall(function() invokeServer("ActivateRaceV3", s) end)
    end
})
LocalPlayerSection:AddToggle({
    Title = "Active Race V4",
    Content = "Aktifkan Race V4 ability.",
    Default = false,
    Callback = function(s)
        _G.ActiveRaceV4 = s
        pcall(function() invokeServer("ActivateRaceV4", s) end)
    end
})
LocalPlayerSection:AddToggle({
    Title = "Walk On Water",
    Content = "Berjalan di atas air.",
    Default = false,
    Callback = function(s)
        _G.WalkOnWater = s
        notify("Walk On Water: " .. (s and "ON" or "OFF"))
    end
})
LocalPlayerSection:AddToggle({
    Title = "No Clip",
    Content = "Berjalan menembus dinding.",
    Default = false,
    Callback = function(s)
        _G.NoClip = s
        notify("No Clip: " .. (s and "ON" or "OFF"))
    end
})

-- ===================== SEA EVENT TAB =====================

local SeaEventSection = Tabs.SeaEvent:AddSection("StreeHub | Sea Event")
SeaEventSection:AddToggle({
    Title = "Lightning",
    Content = "Auto dodge lightning saat sea event.",
    Default = false,
    Callback = function(s)
        _G.Lightning = s
        if s then
            task.spawn(function()
                while _G.Lightning do
                    pcall(function() invokeServer("LightningDodge") end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- ===================== SEA STACK TAB =====================

local SeaStackSection = Tabs.SeaStack:AddSection("StreeHub | Sea Stack")
local seaEnemies = {
    { "Auto Farm Shark",           "AutoFarmShark",     "Shark" },
    { "Auto Farm Piranha",         "AutoFarmPiranha",   "Piranha" },
    { "Auto Farm Fish Crew Member","AutoFarmFishCrew",  "FishCrewMember" },
}
for _, se in ipairs(seaEnemies) do
    SeaStackSection:AddToggle({
        Title = se[1],
        Content = "Otomatis farm " .. se[3] .. ".",
        Default = false,
        Callback = function(s)
            _G[se[2]] = s
            if s then
                task.spawn(function()
                    while _G[se[2]] do
                        local enemy = findNearestNPC(se[3])
                        if enemy then
                            local r = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
                            if r and HRP then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                                pcall(function()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                end)
                            end
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    })
end

local BoatSeaSection = Tabs.SeaStack:AddSection("StreeHub | Boat")
local boatEnemies = {
    { "Auto Farm Ghost Ship",           "AutoFarmGhostShip",  "GhostShip" },
    { "Auto Farm Pirate Brigade",       "AutoFarmPirateBrig", "PirateBrigade" },
    { "Auto Farm Pirate Grand Brigade", "AutoFarmGrandBrig",  "PirateGrandBrigade" },
}
for _, be in ipairs(boatEnemies) do
    BoatSeaSection:AddToggle({
        Title = be[1],
        Content = "Otomatis farm " .. be[3] .. ".",
        Default = false,
        Callback = function(s)
            _G[be[2]] = s
            if s then
                task.spawn(function()
                    while _G[be[2]] do
                        local enemy = findNearestNPC(be[3])
                        if enemy then
                            local r = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
                            if r and HRP then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                                pcall(function()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                end)
                            end
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    })
end

local BossSeaSection = Tabs.SeaStack:AddSection("StreeHub | Boss")
BossSeaSection:AddToggle({
    Title = "Auto Farm Terrorshark",
    Content = "Otomatis farm Terrorshark.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmTerror = s
        if s then
            task.spawn(function()
                while _G.AutoFarmTerror do
                    local boss = findNearestNPC("Terrorshark")
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
BossSeaSection:AddToggle({
    Title = "Auto Farm Seabeasts",
    Content = "Otomatis farm Sea Beasts.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmSeabeast = s
        if s then
            task.spawn(function()
                while _G.AutoFarmSeabeast do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:lower():find("seabeast") then
                            local r = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                            if r and HRP then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                                pcall(function()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                end)
                            end
                            break
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local SailBoatSection = Tabs.SeaStack:AddSection("StreeHub | Sail Boat")
SailBoatSection:AddDropdown({
    Title = "Choose Boat",
    Content = "Pilih jenis perahu.",
    Options = { "Raft", "Dinghy", "Caravel", "Galleon" },
    Default = "Galleon",
    Callback = function(v) _G.SelectedBoat = v end
})
SailBoatSection:AddDropdown({
    Title = "Choose Zone",
    Content = "Pilih zona untuk berlayar.",
    Options = { "First Sea", "Second Sea", "Third Sea" },
    Default = "First Sea",
    Callback = function(v) _G.SelectedZone = v end
})
SailBoatSection:AddSlider({
    Title = "Boat Tween Speed",
    Content = "Kecepatan pergerakan perahu.",
    Min = 20, Max = 200, Increment = 10, Default = 50,
    Callback = function(v) _G.BoatSpeed = v end
})
SailBoatSection:AddPanel({
    Title = "Sail Boat",
    ButtonText = "Sail Boat",
    ButtonCallback = function()
        notify("Mulai berlayar...")
        pcall(function() invokeServer("SailBoat", _G.SelectedBoat, _G.SelectedZone) end)
    end
})
SailBoatSection:AddToggle({
    Title = "Auto Attack Seabeasts",
    Content = "Otomatis serang seabeast saat berlayar.",
    Default = false,
    Callback = function(s)
        _G.AutoAttackSeabeast = s
        if s then
            task.spawn(function()
                while _G.AutoAttackSeabeast do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and (obj.Name:lower():find("seabeast") or obj.Name:lower():find("sea beast")) then
                            local r = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                            if r and HRP then
                                HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                                pcall(function()
                                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                end)
                            end
                            break
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- ===================== DRAGON DOJO TAB =====================

local BeltSection = Tabs.DragonDojo:AddSection("StreeHub | Belt")
BeltSection:AddToggle({
    Title = "Auto Dojo Trainer",
    Content = "Otomatis latih di Dragon Dojo.",
    Default = false,
    Callback = function(s)
        _G.AutoDojoBelt = s
        if s then
            task.spawn(function()
                while _G.AutoDojoBelt do
                    pcall(function() invokeServer("DojoTrain") end)
                    task.wait(2)
                end
            end)
        end
    end
})

local VolcanicSection = Tabs.DragonDojo:AddSection("StreeHub | Volcanic Magnet")
VolcanicSection:AddToggle({
    Title = "Auto Farm Blaze Ember",
    Content = "Otomatis farm Blaze Ember dari gunung berapi.",
    Default = false,
    Callback = function(s)
        _G.AutoFarmBlazeEmber = s
        if s then
            task.spawn(function()
                while _G.AutoFarmBlazeEmber do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name == "BlazeEmber" and obj:IsA("BasePart") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                            pcall(function() fireclickdetector(obj) end)
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
VolcanicSection:AddPanel({
    Title = "Craft Volcanic Magnet",
    ButtonText = "Craft",
    ButtonCallback = function()
        notify("Crafting Volcanic Magnet...")
        pcall(function() invokeServer("CraftVolcanicMagnet") end)
    end
})

local DracoSection = Tabs.DragonDojo:AddSection("StreeHub | Draco Trial")
DracoSection:AddPanel({
    Title = "Upgrade Draco",
    ButtonText = "Upgrade Draco Trial",
    ButtonCallback = function()
        notify("Upgrading Draco Trial...")
        pcall(function() invokeServer("UpgradeDraco") end)
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V1",
    Content = "Otomatis selesaikan Draco V1.",
    Default = false,
    Callback = function(s)
        _G.AutoDracoV1 = s
        if s then
            task.spawn(function()
                while _G.AutoDracoV1 do
                    pcall(function() invokeServer("DracoTrial", 1) end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V2",
    Content = "Otomatis selesaikan Draco V2.",
    Default = false,
    Callback = function(s)
        _G.AutoDracoV2 = s
        if s then
            task.spawn(function()
                while _G.AutoDracoV2 do
                    pcall(function() invokeServer("DracoTrial", 2) end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V3",
    Content = "Otomatis selesaikan Draco V3.",
    Default = false,
    Callback = function(s)
        _G.AutoDracoV3 = s
        if s then
            task.spawn(function()
                while _G.AutoDracoV3 do
                    pcall(function() invokeServer("DracoTrial", 3) end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
DracoSection:AddPanel({
    Title = "Teleport",
    ButtonText = "Teleport To Draco Trials",
    ButtonCallback = function()
        notify("Teleporting to Draco Trials...")
        teleportTo(Vector3.new(-7811.8, 6.5, -355.3))
    end
})
DracoSection:AddToggle({
    Title = "Swap Draco Race",
    Content = "Swap ke ras Draco.",
    Default = false,
    Callback = function(s)
        _G.SwapDraco = s
        if s then pcall(function() invokeServer("SwapRace", "Draco") end) end
    end
})
DracoSection:AddPanel({
    Title = "Dragon Talon",
    ButtonText = "Upgrade Dragon Talon",
    ButtonCallback = function()
        notify("Upgrading Dragon Talon...")
        pcall(function() invokeServer("UpgradeDragonTalon") end)
    end
})

-- ===================== ITEMS TAB =====================

local PrehistoricSection = Tabs.Items:AddSection("StreeHub | Prehistoric")
PrehistoricSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "info" })
PrehistoricSection:AddToggle({
    Title = "Auto Prehistoric Island",
    Content = "Otomatis selesaikan Prehistoric Island.",
    Default = false,
    Callback = function(s)
        _G.AutoPrehistoric = s
        if s then
            task.spawn(function()
                while _G.AutoPrehistoric do
                    pcall(function() invokeServer("PrehistoricIsland") end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Kill Lava Golem",
    Content = "Otomatis bunuh Lava Golem.",
    Default = false,
    Callback = function(s)
        _G.AutoKillLava = s
        if s then
            task.spawn(function()
                while _G.AutoKillLava do
                    local boss = findNearestNPC("LavaGolem")
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Collect Bone",
    Content = "Otomatis kumpulkan tulang dari Prehistoric.",
    Default = false,
    Callback = function(s)
        _G.AutoCollectBone = s
        if s then
            task.spawn(function()
                while _G.AutoCollectBone do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("bone") and obj:IsA("BasePart") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Collect Egg",
    Content = "Otomatis kumpulkan telur dari Prehistoric.",
    Default = false,
    Callback = function(s)
        _G.AutoCollectEgg = s
        if s then
            task.spawn(function()
                while _G.AutoCollectEgg do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name:lower():find("egg") and obj:IsA("BasePart") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Defend Volcano",
    Content = "Otomatis pertahankan volcano.",
    Default = false,
    Callback = function(s)
        _G.AutoDefendVolcano = s
        if s then
            task.spawn(function()
                while _G.AutoDefendVolcano do
                    pcall(function() invokeServer("DefendVolcano") end)
                    local enemy = getClosestEnemy(60)
                    if enemy then attackEnemy(enemy) end
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
    Content = "Otomatis selesaikan Frozen Dimension.",
    Default = false,
    Callback = function(s)
        _G.AutoFrozen = s
        if s then
            task.spawn(function()
                while _G.AutoFrozen do
                    pcall(function() invokeServer("FrozenDimension") end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
FrozenSection:AddParagraph({ Title = "Leviathan Status", Content = "-", Icon = "info" })
FrozenSection:AddPanel({
    Title = "Leviathan",
    ButtonText = "Bribe Leviathan",
    ButtonCallback = function()
        notify("Bribing Leviathan...")
        pcall(function() invokeServer("BribeLeviathan") end)
    end
})
FrozenSection:AddToggle({
    Title = "Auto Leviathan",
    Content = "Otomatis lawan Leviathan.",
    Default = false,
    Callback = function(s)
        _G.AutoLeviathan = s
        if s then
            task.spawn(function()
                while _G.AutoLeviathan do
                    local boss = findNearestNPC("Leviathan")
                    if boss then
                        local r = boss:FindFirstChild("HumanoidRootPart") or boss.PrimaryPart
                        if r and HRP then
                            HRP.CFrame = CFrame.new(r.Position + Vector3.new(5, 2, 5))
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local KitsuneSection = Tabs.Items:AddSection("StreeHub | Kitsune Island")
KitsuneSection:AddParagraph({ Title = "Kitsune Status", Content = "-", Icon = "info" })
KitsuneSection:AddToggle({
    Title = "Auto Kitsune Island",
    Content = "Otomatis selesaikan Kitsune Island.",
    Default = false,
    Callback = function(s)
        _G.AutoKitsuneIsland = s
        if s then
            task.spawn(function()
                while _G.AutoKitsuneIsland do
                    pcall(function() invokeServer("KitsuneIsland") end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})
KitsuneSection:AddToggle({
    Title = "Auto Collect Azure Ember",
    Content = "Otomatis kumpulkan Azure Ember.",
    Default = false,
    Callback = function(s)
        _G.AutoCollectAzure = s
        if s then
            task.spawn(function()
                while _G.AutoCollectAzure do
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj.Name == "AzureEmber" and obj:IsA("BasePart") and HRP then
                            HRP.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                            pcall(function() fireclickdetector(obj) end)
                            task.wait(0.3)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
KitsuneSection:AddPanel({
    Title = "Azure Ember",
    Placeholder = "Jumlah (misal: 50)",
    ButtonText = "Set Azure Ember",
    ButtonCallback = function(v)
        _G.AzureEmberAmount = tonumber(v) or 0
        notify("Azure Ember diset ke: " .. tostring(_G.AzureEmberAmount))
        pcall(function() invokeServer("SetAzureEmber", _G.AzureEmberAmount) end)
    end
})
KitsuneSection:AddToggle({
    Title = "Auto Trade Azure Ember",
    Content = "Otomatis trade Azure Ember.",
    Default = false,
    Callback = function(s)
        _G.AutoTradeAzure = s
        if s then
            task.spawn(function()
                while _G.AutoTradeAzure do
                    pcall(function() invokeServer("TradeAzureEmber", _G.AzureEmberAmount) end)
                    task.wait(2)
                end
            end)
        end
    end
})

local MirageSection = Tabs.Items:AddSection("StreeHub | Mirage Island")
MirageSection:AddParagraph({ Title = "Mirage Status", Content = "-", Icon = "info" })
MirageSection:AddToggle({
    Title = "Auto Mirage Island",
    Content = "Otomatis selesaikan Mirage Island.",
    Default = false,
    Callback = function(s)
        _G.AutoMirageIsland = s
        if s then
            task.spawn(function()
                while _G.AutoMirageIsland do
                    pcall(function() invokeServer("MirageIsland") end)
                    local enemy = getClosestEnemy(80)
                    if enemy then attackEnemy(enemy) end
                    task.wait(1)
                end
            end)
        end
    end
})

-- ===================== SETTINGS TAB =====================

local SettingsTab = Tabs.Settings:AddSection("StreeHub | Settings", true)
SettingsTab:AddToggle({
    Title = "Show Button",
    Content = "Tampilkan tombol buka/tutup GUI.",
    Default = true,
    Callback = function(s)
        notify("Button: " .. (s and "ON" or "OFF"))
    end
})
SettingsTab:AddPanel({
    Title = "UI Color",
    Placeholder = "255,50,50",
    ButtonText = "Apply Color",
    ButtonCallback = function(colorText)
        local r, g, b = colorText:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            notify("Color changed to RGB(" .. r .. "," .. g .. "," .. b .. ")")
        else
            notify("Format salah! Gunakan: R,G,B")
        end
    end,
    SubButtonText = "Reset Color",
    SubButtonCallback = function()
        notify("Color reset ke default.")
    end
})
SettingsTab:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
    end
})

-- ===================== SERVER TAB =====================

local ServerSection = Tabs.Server:AddSection("StreeHub | Server")
ServerSection:AddPanel({
    Title = "Server Actions",
    ButtonText = "Rejoin Server",
    ButtonCallback = function()
        notify("Rejoining server...")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
    SubButtonText = "Server Hop",
    SubButtonCallback = function()
        serverHop()
    end
})
ServerSection:AddParagraph({ Title = "Job ID", Content = tostring(game.JobId), Icon = "server" })
ServerSection:AddPanel({
    Title = "Job ID",
    ButtonText = "Copy Job ID",
    ButtonCallback = function()
        if setclipboard then setclipboard(tostring(game.JobId)) end
        notify("Job ID disalin!")
    end
})
ServerSection:AddPanel({
    Title = "Join Specific Server",
    Placeholder = "Masukkan Job ID...",
    ButtonText = "Join Job ID",
    ButtonCallback = function(jobId)
        if jobId and jobId ~= "" then
            notify("Joining: " .. jobId)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
            end)
        else
            notify("Masukkan Job ID yang valid.")
        end
    end
})

local StatusServerSection = Tabs.Server:AddSection("StreeHub | Status Server")
local statusParagraphs = {
    MoonPara       = StatusServerSection:AddParagraph({ Title = "Moon Server",        Content = "-", Icon = "moon" }),
    KitsunePara    = StatusServerSection:AddParagraph({ Title = "Kitsune Status",     Content = "-", Icon = "zap" }),
    FrozenPara     = StatusServerSection:AddParagraph({ Title = "Frozen Status",      Content = "-", Icon = "snowflake" }),
    MiragePara     = StatusServerSection:AddParagraph({ Title = "Mirage Status",      Content = "-", Icon = "eye" }),
    HakiPara       = StatusServerSection:AddParagraph({ Title = "Haki Dealer Status", Content = "-", Icon = "user" }),
    PrehistoricPara = StatusServerSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "shield" }),
}

task.spawn(function()
    while task.wait(10) do
        pcall(function()
            local status = invokeServer("GetServerStatus")
            if status then
                if statusParagraphs.MoonPara and statusParagraphs.MoonPara.SetContent then
                    statusParagraphs.MoonPara:SetContent(status.Moon or "-")
                end
                if statusParagraphs.KitsunePara and statusParagraphs.KitsunePara.SetContent then
                    statusParagraphs.KitsunePara:SetContent(status.Kitsune or "-")
                end
                if statusParagraphs.FrozenPara and statusParagraphs.FrozenPara.SetContent then
                    statusParagraphs.FrozenPara:SetContent(status.Frozen or "-")
                end
                if statusParagraphs.MiragePara and statusParagraphs.MiragePara.SetContent then
                    statusParagraphs.MiragePara:SetContent(status.Mirage or "-")
                end
                if statusParagraphs.HakiPara and statusParagraphs.HakiPara.SetContent then
                    statusParagraphs.HakiPara:SetContent(status.Haki or "-")
                end
                if statusParagraphs.PrehistoricPara and statusParagraphs.PrehistoricPara.SetContent then
                    statusParagraphs.PrehistoricPara:SetContent(status.Prehistoric or "-")
                end
            end
        end)
    end
end)

-- ===================== CHARACTER ADDED =====================

LocalPlayer.CharacterAdded:Connect(function(char)
    UpdateCharacter(char)
    if _G.AutoRejoin then
        char:WaitForChild("Humanoid").Died:Connect(function()
            task.wait(3)
            pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
        end)
    end
end)

notify("StreeHub loaded!", 5, Color3.fromRGB(255, 50, 50), "StreeHub")
