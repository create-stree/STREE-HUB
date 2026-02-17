local success, StreeHub = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()
end)

if not success or not StreeHub then
    warn("UI failed to load!")
    return
end

local Window = StreeHub:Window({
    Title             = "APPLE HUB |",
    Footer            = "Blox Fruit",
    Images            = "128806139932217",
    Color             = Color3.fromRGB(88, 101, 242),
    Theme             = 122376116281975,
    ThemeTransparency = 0.15,
    ["Tab Width"]     = 120,
    Version           = 1,
})

local function notify(msg, delay, color, title, desc)
    return StreeHub:MakeNotify({
        Title       = title or "APPLE HUB",
        Description = desc or "Notification",
        Content     = msg or "Content",
        Color       = color or Color3.fromRGB(88, 101, 242),
        Delay       = delay or 4
    })
end

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TeleportSvc    = game:GetService("TeleportService")
local HttpSvc        = game:GetService("HttpService")
local GuiSvc         = game:GetService("GuiService")
local VirtualUser    = game:GetService("VirtualUser")
local ReplicatedStor = game:GetService("ReplicatedStorage")
local LocalPlayer    = Players.LocalPlayer
local Character      = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid       = Character:WaitForChild("Humanoid")
local RootPart       = Character:WaitForChild("HumanoidRootPart")

_G.AutoFarmEnemy   = false
_G.AutoFarmBoss    = false
_G.AutoFarmSea     = false
_G.AutoFarmFruit   = false
_G.AutoFarmMastery = false
_G.AutoQuest       = false
_G.AutoChest       = false
_G.AutoRaid        = false
_G.AutoHeal        = false
_G.NoClip          = false
_G.AntiAFK         = false
_G.SpeedHack       = false
_G.SpeedValue      = 16
_G.ESP             = false
_G.FruitSniper     = false
_G.AutoStats       = false
_G.StatsChoice     = "Melee"

LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid  = c:WaitForChild("Humanoid")
    RootPart  = c:WaitForChild("HumanoidRootPart")
end)

local function getNearest(filter)
    local nearest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
            local hum = v:FindFirstChild("Humanoid")
            if hum.Health > 0 then
                local match = filter == nil or (type(filter) == "function" and filter(v))
                if match then
                    local d = (RootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        nearest = v
                    end
                end
            end
        end
    end
    return nearest
end

local function attackNearest(target)
    if target and target:FindFirstChild("HumanoidRootPart") then
        RootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then pcall(function() tool:Activate() end) end
    end
end

local Bosses = {
    "Gorilla King", "Bobby", "Yeti", "Snowman", "Chief Pirate",
    "Greybeard", "Wysper", "Thunder God", "Magma Admiral",
    "Fishman Lord", "Awakened Ice Admiral", "Dragon", "Tide Keeper",
    "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant",
    "Beautiful Pirate", "Longma", "Cake Queen", "Dough King",
    "Rip_Indra", "Order", "Darkbeard", "Hydra",
}

local Islands = {
    ["Starter Island"]    = Vector3.new(-1175.9, 41.2,   1451.8),
    ["Middle Town"]       = Vector3.new(977.8,   42.3,   1186.1),
    ["Jungle"]            = Vector3.new(-1600.9, 105.2,  -200.1),
    ["Pirate Village"]    = Vector3.new(-1034.1, 42.3,  -2719.8),
    ["Desert"]            = Vector3.new(938.5,   41.5,  -2923.9),
    ["Snowy Village"]     = Vector3.new(1173.9,  138.9, -3196.5),
    ["Marine Fortress"]   = Vector3.new(-4771.3, 27.8,  -2720.5),
    ["Skylands"]          = Vector3.new(-4770.8, 872.2, -2252.4),
    ["Colosseum"]         = Vector3.new(1040.4,  97.4,  -2804.3),
    ["Magma Village"]     = Vector3.new(-5001.4, 46.2,  -3685.7),
    ["Upper Skylands"]    = Vector3.new(-4752.2, 1274.1,-2256.8),
    ["Fountain City"]     = Vector3.new(-4779.9, 17.8,  -4786.4),
    ["Underwater City"]   = Vector3.new(-5130.7, -400.0,-5205.9),
    ["Sea of Treats"]     = Vector3.new(61000.2, 200.0,  1750.0),
    ["Cafe"]              = Vector3.new(-91.3,   73.9,  -2083.0),
    ["Mini Sky Island"]   = Vector3.new(-5113.5, 614.9, -5016.2),
    ["Castle on the Sea"] = Vector3.new(6540.9,  25.9,  -3497.1),
    ["Port Town"]         = Vector3.new(-5408.0, 14.6,  -5483.7),
    ["Great Tree"]        = Vector3.new(-8069.8, 345.3, -7498.7),
    ["Floating Turtle"]   = Vector3.new(-14256.4,176.7, -12100.0),
}

local espHighlights = {}

local function clearESP()
    for _, h in pairs(espHighlights) do
        pcall(function() h:Destroy() end)
    end
    espHighlights = {}
end

local Tabs = {
    Info     = Window:AddTab({ Name = "Info",     Icon = "info"     }),
    Farm     = Window:AddTab({ Name = "Farm",     Icon = "sword"    }),
    Boss     = Window:AddTab({ Name = "Boss",     Icon = "crown"    }),
    Player   = Window:AddTab({ Name = "Player",   Icon = "user"     }),
    ESP      = Window:AddTab({ Name = "ESP",      Icon = "eye"      }),
    Teleport = Window:AddTab({ Name = "Teleport", Icon = "map"      }),
    Misc     = Window:AddTab({ Name = "Misc",     Icon = "star"     }),
    Settings = Window:AddTab({ Name = "Settings", Icon = "settings" }),
}

local InfoSection = Tabs.Info:AddSection("APPLE HUB | Information")

InfoSection:AddParagraph({
    Title   = "Welcome to APPLE HUB",
    Content = "Script Blox Fruit terlengkap. Gunakan dengan bijak!",
    Icon    = "star",
})

InfoSection:AddParagraph({
    Title          = "Join Our Discord",
    Content        = "Join Us!",
    Icon           = "discord",
    ButtonText     = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/jdmX43t5mY"
        if setclipboard then
            setclipboard(link)
            notify("Discord link copied!")
        end
    end
})

InfoSection:AddDivider()

InfoSection:AddParagraph({
    Title   = "Script Info",
    Content = "Version: 1.0 | Game: Blox Fruit | Dev: APPLE HUB",
    Icon    = "info",
})

local FarmSection = Tabs.Farm:AddSection("APPLE HUB | Auto Farm")

FarmSection:AddToggle({
    Title   = "Auto Farm Enemy",
    Content = "Otomatis menyerang musuh terdekat.",
    Default = false,
    Callback = function(state)
        _G.AutoFarmEnemy = state
        notify("Auto Farm Enemy: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoFarmEnemy do
                    pcall(function() attackNearest(getNearest()) end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

FarmSection:AddToggle({
    Title   = "Auto Farm Mastery",
    Content = "Otomatis farm untuk meningkatkan mastery senjata.",
    Default = false,
    Callback = function(state)
        _G.AutoFarmMastery = state
        notify("Auto Farm Mastery: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoFarmMastery do
                    pcall(function()
                        local target = getNearest()
                        if target then
                            RootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                            for _, tool in pairs(Character:GetChildren()) do
                                if tool:IsA("Tool") then
                                    pcall(function() tool:Activate() end)
                                end
                            end
                        end
                    end)
                    task.wait(0.15)
                end
            end)
        end
    end
})

FarmSection:AddToggle({
    Title   = "Auto Farm Fruit",
    Content = "Otomatis mengambil devil fruit yang muncul di map.",
    Default = false,
    Callback = function(state)
        _G.AutoFarmFruit = state
        notify("Auto Farm Fruit: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoFarmFruit do
                    pcall(function()
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v.Name == "Fruit" or v.Name == "Devil_Fruit" or (v:IsA("Model") and v.Name:find("Fruit")) then
                                local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    RootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
                                    task.wait(0.3)
                                    pcall(function()
                                        ReplicatedStor.Remotes.CommF_:InvokeServer("PickUpFruit", v)
                                    end)
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

FarmSection:AddToggle({
    Title   = "Auto Quest",
    Content = "Otomatis ambil dan selesaikan quest.",
    Default = false,
    Callback = function(state)
        _G.AutoQuest = state
        notify("Auto Quest: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoQuest do
                    pcall(function()
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v.Name == "QuestGiver" or v.Name == "Quest_Giver" then
                                pcall(function()
                                    ReplicatedStor.Remotes.CommF_:InvokeServer("StartQuest", v.Name)
                                end)
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

FarmSection:AddToggle({
    Title   = "Auto Collect Chest",
    Content = "Otomatis mengambil chest yang muncul di map.",
    Default = false,
    Callback = function(state)
        _G.AutoChest = state
        notify("Auto Collect Chest: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoChest do
                    pcall(function()
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v.Name == "Chest" or v.Name == "chest" then
                                local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    RootPart.CFrame = CFrame.new(part.Position)
                                    task.wait(0.3)
                                    pcall(function()
                                        ReplicatedStor.Remotes.CommF_:InvokeServer("ChestGet", v)
                                    end)
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

local BossSection = Tabs.Boss:AddSection("APPLE HUB | Auto Farm Boss")

BossSection:AddToggle({
    Title   = "Auto Farm Boss",
    Content = "Otomatis menyerang boss terdekat.",
    Default = false,
    Callback = function(state)
        _G.AutoFarmBoss = state
        notify("Auto Farm Boss: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoFarmBoss do
                    pcall(function()
                        local target = getNearest(function(v)
                            for _, name in pairs(Bosses) do
                                if v.Name == name then return true end
                            end
                            return false
                        end)
                        if target then
                            attackNearest(target)
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end
})

BossSection:AddDivider()
BossSection:AddSubSection("Teleport to Boss")

for _, bossName in pairs(Bosses) do
    BossSection:AddButton({
        Title    = bossName,
        Callback = function()
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name == bossName and v:FindFirstChild("HumanoidRootPart") then
                        RootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        notify("Teleported to " .. bossName)
                        return
                    end
                end
                notify(bossName .. " tidak ditemukan.", 3, Color3.fromRGB(255, 80, 80))
            end)
        end
    })
end

local SeaSection = Tabs.Boss:AddSection("APPLE HUB | Auto Farm Sea Beast")

SeaSection:AddToggle({
    Title   = "Auto Farm Sea Beast",
    Content = "Otomatis menyerang Sea Beast terdekat.",
    Default = false,
    Callback = function(state)
        _G.AutoFarmSea = state
        notify("Auto Farm Sea Beast: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoFarmSea do
                    pcall(function()
                        local target = getNearest(function(v)
                            return v.Name == "SeaBeast" or v.Name == "Sea_Beast" or v.Name:find("SeaBeast") or v.Name:find("Sea Beast")
                        end)
                        if target then
                            attackNearest(target)
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end
})

local RaidSection = Tabs.Boss:AddSection("APPLE HUB | Auto Raid")

RaidSection:AddToggle({
    Title   = "Auto Raid",
    Content = "Otomatis menyelesaikan semua musuh di raid.",
    Default = false,
    Callback = function(state)
        _G.AutoRaid = state
        notify("Auto Raid: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoRaid do
                    pcall(function() attackNearest(getNearest()) end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local PlayerSection = Tabs.Player:AddSection("APPLE HUB | Player")

PlayerSection:AddToggle({
    Title   = "Auto Heal",
    Content = "Otomatis makan makanan saat HP rendah.",
    Default = false,
    Callback = function(state)
        _G.AutoHeal = state
        notify("Auto Heal: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AutoHeal do
                    pcall(function()
                        if Humanoid.Health < Humanoid.MaxHealth * 0.4 then
                            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                                if tool:IsA("Tool") and (tool.Name:find("Food") or tool.Name:find("Heal") or tool.Name:find("Meat")) then
                                    tool.Parent = Character
                                    task.wait(0.1)
                                    pcall(function() tool:Activate() end)
                                    task.wait(0.5)
                                    tool.Parent = LocalPlayer.Backpack
                                    break
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

PlayerSection:AddToggle({
    Title   = "No Clip",
    Content = "Karakter dapat menembus objek.",
    Default = false,
    Callback = function(state)
        _G.NoClip = state
        notify("No Clip: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.NoClip do
                    pcall(function()
                        for _, part in pairs(Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end)
                    task.wait()
                end
            end)
        else
            pcall(function()
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
})

PlayerSection:AddDivider()

PlayerSection:AddToggle({
    Title   = "Speed Hack",
    Content = "Meningkatkan kecepatan karakter.",
    Default = false,
    Callback = function(state)
        _G.SpeedHack = state
        notify("Speed Hack: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.SpeedHack do
                    pcall(function() Humanoid.WalkSpeed = _G.SpeedValue end)
                    task.wait(0.1)
                end
            end)
        else
            pcall(function() Humanoid.WalkSpeed = 16 end)
        end
    end
})

PlayerSection:AddSlider({
    Title     = "Speed Value",
    Content   = "Atur kecepatan Speed Hack.",
    Min       = 16,
    Max       = 500,
    Increment = 1,
    Default   = 16,
    Callback  = function(value)
        _G.SpeedValue = value
        if _G.SpeedHack then
            pcall(function() Humanoid.WalkSpeed = value end)
        end
    end
})

PlayerSection:AddDivider()

local StatsSection = Tabs.Player:AddSection("APPLE HUB | Auto Stats")

StatsSection:AddDropdown({
    Title   = "Stats Type",
    Content = "Pilih tipe stats yang akan di-auto distribute.",
    Options = { "Melee", "Defense", "Sword", "Gun", "Blox Fruit" },
    Default = "Melee",
    Callback = function(value)
        _G.StatsChoice = value
        notify("Stats diset ke: " .. value)
    end
})

StatsSection:AddToggle({
    Title   = "Auto Stats",
    Content = "Otomatis mendistribusikan stat points.",
    Default = false,
    Callback = function(state)
        _G.AutoStats = state
        notify("Auto Stats: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                local statMap = {
                    ["Melee"]      = "Strength",
                    ["Defense"]    = "Defense",
                    ["Sword"]      = "Sword",
                    ["Gun"]        = "Gun",
                    ["Blox Fruit"] = "Devil_Fruit",
                }
                while _G.AutoStats do
                    pcall(function()
                        ReplicatedStor.Remotes.CommF_:InvokeServer("AddStat", statMap[_G.StatsChoice] or "Strength")
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local ESPSection = Tabs.ESP:AddSection("APPLE HUB | ESP")

ESPSection:AddToggle({
    Title   = "ESP Enemy",
    Content = "Menampilkan highlight pada semua musuh.",
    Default = false,
    Callback = function(state)
        _G.ESP = state
        notify("ESP Enemy: " .. (state and "ON" or "OFF"))
        if not state then clearESP() return end
        task.spawn(function()
            while _G.ESP do
                clearESP()
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= Character then
                            local hum = v:FindFirstChild("Humanoid")
                            if hum and hum.Health > 0 then
                                local h = Instance.new("Highlight")
                                h.FillColor         = Color3.fromRGB(255, 0, 0)
                                h.OutlineColor      = Color3.fromRGB(255, 255, 255)
                                h.FillTransparency  = 0.5
                                h.Parent            = v
                                table.insert(espHighlights, h)
                            end
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end
})

ESPSection:AddToggle({
    Title   = "ESP Fruit",
    Content = "Menampilkan highlight pada devil fruit di map.",
    Default = false,
    Callback = function(state)
        notify("ESP Fruit: " .. (state and "ON" or "OFF"))
        if not state then return end
        task.spawn(function()
            while state do
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name == "Fruit" or v.Name == "Devil_Fruit" or (v:IsA("Model") and v.Name:find("Fruit")) then
                            if not v:FindFirstChildOfClass("Highlight") then
                                local h = Instance.new("Highlight")
                                h.FillColor        = Color3.fromRGB(255, 200, 0)
                                h.OutlineColor     = Color3.fromRGB(255, 255, 255)
                                h.FillTransparency = 0.4
                                h.Parent           = v
                            end
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end
})

ESPSection:AddToggle({
    Title   = "ESP Player",
    Content = "Menampilkan highlight pada semua player.",
    Default = false,
    Callback = function(state)
        notify("ESP Player: " .. (state and "ON" or "OFF"))
        if not state then return end
        task.spawn(function()
            while state do
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            if not p.Character:FindFirstChildOfClass("Highlight") then
                                local h = Instance.new("Highlight")
                                h.FillColor        = Color3.fromRGB(0, 100, 255)
                                h.OutlineColor     = Color3.fromRGB(255, 255, 255)
                                h.FillTransparency = 0.5
                                h.Parent           = p.Character
                            end
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end
})

local FruitSniperSection = Tabs.ESP:AddSection("APPLE HUB | Fruit Sniper")

FruitSniperSection:AddToggle({
    Title   = "Fruit Sniper",
    Content = "Otomatis teleport dan ambil devil fruit di manapun.",
    Default = false,
    Callback = function(state)
        _G.FruitSniper = state
        notify("Fruit Sniper: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.FruitSniper do
                    pcall(function()
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v.Name == "Fruit" or v.Name == "Devil_Fruit" or (v:IsA("Model") and v.Name:find("Fruit")) then
                                local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    RootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                                    task.wait(0.3)
                                    pcall(function()
                                        ReplicatedStor.Remotes.CommF_:InvokeServer("PickUpFruit", v)
                                    end)
                                    notify("Fruit ditemukan dan diambil!", 2, Color3.fromRGB(255, 200, 0))
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

local TpSection = Tabs.Teleport:AddSection("APPLE HUB | Teleport Island")

for name, pos in pairs(Islands) do
    TpSection:AddButton({
        Title    = name,
        Callback = function()
            pcall(function()
                RootPart.CFrame = CFrame.new(pos)
                notify("Teleported to " .. name)
            end)
        end
    })
end

local TpPlayerSection = Tabs.Teleport:AddSection("APPLE HUB | Teleport to Player")

TpPlayerSection:AddDropdown({
    Title   = "Select Player",
    Content = "Pilih player untuk diteleport.",
    Options = (function()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(list, p.Name) end
        end
        return list
    end)(),
    Default  = nil,
    Callback = function(value)
        pcall(function()
            local target = Players:FindFirstChild(value)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                RootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                notify("Teleported to " .. value)
            else
                notify("Player tidak ditemukan.", 3, Color3.fromRGB(255, 80, 80))
            end
        end)
    end
})

local MiscSection = Tabs.Misc:AddSection("APPLE HUB | Misc")

MiscSection:AddToggle({
    Title   = "Anti AFK",
    Content = "Mencegah kick karena AFK.",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        notify("Anti AFK: " .. (state and "ON" or "OFF"))
        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    task.wait(20)
                end
            end)
        end
    end
})

MiscSection:AddButton({
    Title    = "Rejoin",
    SubTitle = "Server Hop",
    Callback = function()
        notify("Rejoining...")
        task.wait(1)
        TeleportSvc:Teleport(game.PlaceId, LocalPlayer)
    end,
    SubCallback = function()
        notify("Finding new server...")
        local ok, result = pcall(function()
            return HttpSvc:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and result then
            for _, v in pairs(result.data) do
                if v.playing < v.maxPlayers then
                    TeleportSvc:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    return
                end
            end
        end
        notify("No available server found.")
    end
})

MiscSection:AddPanel({
    Title             = "APPLE HUB | Discord",
    ButtonText        = "Copy Discord Link",
    ButtonCallback    = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
            notify("Discord link copied!")
        else
            notify("Clipboard not supported.")
        end
    end,
    SubButtonText     = "Open Discord",
    SubButtonCallback = function()
        task.spawn(function()
            GuiSvc:OpenBrowserWindow("https://discord.gg/jdmX43t5mY")
        end)
    end
})

local SettingsSection = Tabs.Settings:AddSection("APPLE HUB | Settings", true)

SettingsSection:AddButton({
    Title    = "Destroy GUI",
    Callback = function()
        _G.AutoFarmEnemy   = false
        _G.AutoFarmBoss    = false
        _G.AutoFarmSea     = false
        _G.AutoFarmFruit   = false
        _G.AutoFarmMastery = false
        _G.AutoQuest       = false
        _G.AutoChest       = false
        _G.AutoRaid        = false
        _G.AutoHeal        = false
        _G.NoClip          = false
        _G.AntiAFK         = false
        _G.SpeedHack       = false
        _G.ESP             = false
        _G.FruitSniper     = false
        _G.AutoStats       = false
        pcall(function() Humanoid.WalkSpeed = 16 end)
        clearESP()
        Window:DestroyGui()
    end
})

pcall(function()
    for _, name in pairs({"ThunderScreen", "NotifySystem", "ZENHUB"}) do
        local old = game.CoreGui:FindFirstChild(name)
        if old then old:Destroy() end
    end
end)

notify("APPLE HUB loaded!", 3, Color3.fromRGB(88, 101, 242), "APPLE HUB", "Blox Fruit Edition")
