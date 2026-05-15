loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)

local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://136485684668174",
    Author = (premium and "Premium" or "Blox Fruits") .. " - " .. version,
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/config.json",
})

local Tabs = {
    Farm = Window:Tab({ Title = "Farm", Icon = "sword", }),
    Config = Window:Tab({ Title = "Config", Icon = "settings", }),
    Fighting = Window:Tab({ Title = "Fighting Style", Icon = "hand-fist", }),
    Items = Window:Tab({ Title = "Items Farm", Icon = "package", }),
    SeaEvents = Window:Tab({ Title = "Sea Events", Icon = "waves", }),
    Mirage = Window:Tab({ Title = "Mirage + RaceV4", Icon = "moon", }),
    Drago = Window:Tab({ Title = "Drago Dojo", Icon = "egg", }),
    Prehistoric = Window:Tab({ Title = "Prehistoric", Icon = "mountain", }),
    Raid = Window:Tab({ Title = "Raid", Icon = "flame", }),
    PVP = Window:Tab({ Title = "Combat PVP", Icon = "crosshair", }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "map" }),
    Fruits = Window:Tab({ Title = "Fruits", Icon = "apple" }),
    Shop = Window:Tab({ Title = "Shop", Icon = "shopping-bag" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "layout-grid" }),
}

Window:SelectTab(1)

local Y = game.Players
local d = Y.LocalPlayer
local R = d.Character.HumanoidRootPart
local Q = game:GetService("ReplicatedStorage")
local r = d.Data.Level.Value
local a = game:GetService("TeleportService")
local w = game:GetService("TweenService")
local F = game:GetService("Lighting")
local M = workspace.Enemies
local K = game:GetService("VirtualInputManager")
local n = game:GetService("VirtualUser")
local I = d.Team
local W = game:GetService("RunService")
local N = game:GetService("Stats")
local D = d.Character.Energy.Value
local A = game:GetService("Players")
local u = A.LocalPlayer:WaitForChild("PlayerGui")
local g = A.LocalPlayer
local z = g:WaitForChild("Backpack")
local i = g.Character or g.CharacterAdded:Wait()
local U = {}
local C = {}
local v = {}
local m = {}
local y = false
local b = false
local c = true
local H = false
local S = false
local o = false
local Z = false
local T = .1
local L = 0
local P = 25
repeat
    local Y = (d.PlayerGui:WaitForChild("Main")):WaitForChild("Loading") and game:IsLoaded()
    wait()
until Y
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    World1 = true
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    World2 = true
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    World3 = true
end
Marines = function()
    Q.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end
Pirates = function()
    Q.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
end
if World1 then
    U = { "The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard" }
elseif World2 then
    U = { "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Darkbeard", "Cursed Captain", "Order" }
elseif World3 then
    U = { "Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Longma", "Soul Reaper" }
end
if World1 then
    v = { "Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail" }
elseif World2 then
    v = { "Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang" }
elseif World3 then
    v = { "Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk" }
end
local j = { "Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", "Bird: Phoenix", "Dough" }
local G = { "Snow Lurker", "Arctic Warrior", "Hidden Key", "Awakened Ice Admiral" }
local q = { Mob = "Mythological Pirate", Mob2 = "Cursed Skeleton", "Hell's Messenger", Mob3 = "Cursed Skeleton", "Heaven's Guardian" }
local t = { "Part", "SpawnLocation", "Terrain", "WedgePart", "MeshPart" }
local X = { "Swan Pirate", "Jeremy" }
local h = { "Forest Pirate", "Captain Elephant" }
local B = { "Fajita", "Jeremy", "Diamond" }
local l = { "Beast Hunter", "Lantern", "Guardian", "Grand Brigade", "Dinghy", "Sloop", "The Sentinel" }
local p = { "Cookie Crafter" }
local E = { "Reborn Skeleton" }
local e = {
    ["Pirate Millionaire"] = CFrame.new(-712.82727050781, 98.577049255371, 5711.9541015625),
    ["Pistol Billionaire"] = CFrame.new(-723.43316650391, 147.42906188965, 5931.9931640625),
    ["Dragon Crew Warrior"] = CFrame.new(7021.5043945312, 55.762702941895, -730.12908935547),
    ["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),
    ["Female Islander"] = CFrame.new(4692.7939453125, 797.97668457031, 858.84802246094),
    ["Venomous Assailant"] = CFrame.new(4902, 670, 39),
    ["Marine Commodore"] = CFrame.new(2401, 123, -7589),
    ["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),
    ["Fishman Raider"] = CFrame.new(-10941, 332, -8760),
    ["Fishman Captain"] = CFrame.new(-11035, 332, -9087),
    ["Forest Pirate"] = CFrame.new(-13446, 413, -7760),
    ["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),
    ["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),
    ["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),
    ["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),
    ["Living Zombie"] = CFrame.new(-10227, 421, 6161),
    ["Demonic Soul"] = CFrame.new(-9579, 6, 6194),
    ["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),
    ["Peanut Scout"] = CFrame.new(-1993, 187, -10103),
    ["Peanut President"] = CFrame.new(-2215, 159, -10474),
    ["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),
    ["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),
    ["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),
    ["Cake Guard"] = CFrame.new(-2024, 38, -12026),
    ["Baking Staff"] = CFrame.new(-1932, 38, -12848),
    ["Head Baker"] = CFrame.new(-1932, 38, -12848),
    ["Cocoa Warrior"] = CFrame.new(95, 73, -12309),
    ["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),
    ["Sweet Thief"] = CFrame.new(116, 36, -12478),
    ["Candy Rebel"] = CFrame.new(47, 61, -12889),
    Ghost = CFrame.new(5251, 5, 1111),
}
EquipWeapon = function(Y)
    if not Y then return end
    if d.Backpack:FindFirstChild(Y) then
        d.Character.Humanoid:EquipTool(d.Backpack:FindFirstChild(Y))
    end
end
weaponSc = function(Y)
    for d, R in pairs(d.Backpack:GetChildren()) do
        if R:IsA("Tool") then
            if R.ToolTip == Y then
                EquipWeapon(R.Name)
            end
        end
    end
end
hookfunction(require((game:GetService("ReplicatedStorage")).Effect.Container.Death), function() end)
hookfunction((require((game:GetService("ReplicatedStorage")):WaitForChild("GuideModule"))).ChangeDisplayedNPC, function() end)
hookfunction(error, function() end)
hookfunction(warn, function() end)
local O = workspace:FindFirstChild("Rocks")
if O then O:Destroy() end
gay = (function()
    local Y = game:GetService("Lighting")
    local d = Y:FindFirstChild("LightingLayers")
    if d and (game:GetService("Lighting") and game:GetService("Lighting")) then
        local Y = d:FindFirstChild("DarkFog")
        if Y then Y:Destroy() end
    end
    local R = workspace._WorldOrigin["Foam;"]
    if R and workspace._WorldOrigin["Foam;"] then R:Destroy() end
end)()
local f = {}
f.__index = f
f.Alive = function(Y)
    if not Y then return end
    local d = Y:FindFirstChild("Humanoid")
    return d and d.Health > 0
end
f.Pos = function(Y, d)
    return (R.Position - mode.Position).Magnitude <= d
end
f.Dist = function(Y, d)
    return (R.Position - (Y:FindFirstChild("HumanoidRootPart")).Position).Magnitude <= d
end
f.DistH = function(Y, d)
    return (R.Position - (Y:FindFirstChild("HumanoidRootPart")).Position).Magnitude > d
end
f.Kill = function(Y, d)
    if Y and d then
        if not Y:GetAttribute("Locked") then
            Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame)
        end
        PosMon = (Y:GetAttribute("Locked")).Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local d = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local R = d.ToolTip
        if R == "Blox Fruit" then
            _tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(0, math.rad(90), 0))
        else
            _tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)) * CFrame.Angles(0, math.rad(180), 0))
        end
        if RandomCFrame then
            wait(.5)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.5)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
            wait(.5)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
            wait(.5)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.5)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
        end
    end
end
f.Kill2 = function(Y, d)
    if Y and d then
        if not Y:GetAttribute("Locked") then
            Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame)
        end
        PosMon = (Y:GetAttribute("Locked")).Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local d = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local R = d.ToolTip
        if R == "Blox Fruit" then
            _tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(0, math.rad(90), 0))
        else
            _tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 8)) * CFrame.Angles(0, math.rad(180), 0))
        end
        if RandomCFrame then
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
        end
    end
end
f.KillSea = function(Y, d)
    if Y and d then
        if not Y:GetAttribute("Locked") then
            Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame)
        end
        PosMon = (Y:GetAttribute("Locked")).Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local d = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local R = d.ToolTip
        if R == "Blox Fruit" then
            _tp((Y.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(0, math.rad(90), 0))
        else
            notween(Y.HumanoidRootPart.CFrame * CFrame.new(0, 50, 8))
            wait(.85)
            notween(Y.HumanoidRootPart.CFrame * CFrame.new(0, 400, 0))
            wait(1)
        end
    end
end
f.Sword = function(Y, d)
    if Y and d then
        if not Y:GetAttribute("Locked") then
            Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame)
        end
        PosMon = (Y:GetAttribute("Locked")).Position
        BringEnemy()
        weaponSc("Sword")
        _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
        if RandomCFrame then
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
            wait(.1)
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
        end
    end
end
f.Mas = function(Y, d)
    if Y and d then
        if not Y:GetAttribute("Locked") then
            Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame)
        end
        PosMon = (Y:GetAttribute("Locked")).Position
        BringEnemy()
        if Y.Humanoid.Health <= HealthM then
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
            Useskills("Blox Fruit", "Z")
            Useskills("Blox Fruit", "X")
            Useskills("Blox Fruit", "C")
        else
            weaponSc("Melee")
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
        end
    end
end
f.Masgun = function(Y, d)
    if Y and d then
        if not Y:GetAttribute("Locked") then
            Y:SetAttribute("Locked", Y.HumanoidRootPart.CFrame)
        end
        PosMon = (Y:GetAttribute("Locked")).Position
        BringEnemy()
        if Y.Humanoid.Health <= HealthM then
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 35, 8))
            Useskills("Gun", "Z")
            Useskills("Gun", "X")
        else
            weaponSc("Melee")
            _tp(Y.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
        end
    end
end
statsSetings = function(Y, R)
    if Y == "Melee" then
        if d.Data.Points.Value ~= 0 then
            Q.Remotes.CommF_:InvokeServer("AddPoint", "Melee", R)
        end
    elseif Y == "Defense" then
        if d.Data.Points.Value ~= 0 then
            Q.Remotes.CommF_:InvokeServer("AddPoint", "Defense", R)
        end
    elseif Y == "Sword" then
        if d.Data.Points.Value ~= 0 then
            Q.Remotes.CommF_:InvokeServer("AddPoint", "Sword", R)
        end
    elseif Y == "Gun" then
        if d.Data.Points.Value ~= 0 then
            Q.Remotes.CommF_:InvokeServer("AddPoint", "Gun", R)
        end
    elseif Y == "Devil" then
        if d.Data.Points.Value ~= 0 then
            Q.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", R)
        end
    end
end
BringEnemy = function()
    if not _B then return end
    for Y, R in pairs(workspace.Enemies:GetChildren()) do
        if R:FindFirstChild("Humanoid") and R.Humanoid.Health > 0 then
            if (R.PrimaryPart.Position - PosMon).Magnitude <= 300 then
                R.PrimaryPart.CFrame = CFrame.new(PosMon)
                R.PrimaryPart.CanCollide = true
                (R:FindFirstChild("Humanoid")).WalkSpeed = 0
                (R:FindFirstChild("Humanoid")).JumpPower = 0
                if R.Humanoid:FindFirstChild("Animator") then
                    R.Humanoid.Animator:Destroy()
                end
                d.SimulationRadius = math.huge
            end
        end
    end
end
Useskills = function(Y, d)
    if Y == "Melee" then
        weaponSc("Melee")
        if d == "Z" then
            K:SendKeyEvent(true, "Z", false, game)
            K:SendKeyEvent(false, "Z", false, game)
        elseif d == "X" then
            K:SendKeyEvent(true, "X", false, game)
            K:SendKeyEvent(false, "X", false, game)
        elseif d == "C" then
            K:SendKeyEvent(true, "C", false, game)
            K:SendKeyEvent(false, "C", false, game)
        end
    elseif Y == "Sword" then
        weaponSc("Sword")
        if d == "Z" then
            K:SendKeyEvent(true, "Z", false, game)
            K:SendKeyEvent(false, "Z", false, game)
        elseif d == "X" then
            K:SendKeyEvent(true, "X", false, game)
            K:SendKeyEvent(false, "X", false, game)
        end
    elseif Y == "Blox Fruit" then
        weaponSc("Blox Fruit")
        if d == "Z" then
            K:SendKeyEvent(true, "Z", false, game)
            K:SendKeyEvent(false, "Z", false, game)
        elseif d == "X" then
            K:SendKeyEvent(true, "X", false, game)
            K:SendKeyEvent(false, "X", false, game)
        elseif d == "C" then
            K:SendKeyEvent(true, "C", false, game)
            K:SendKeyEvent(false, "C", false, game)
        elseif d == "V" then
            K:SendKeyEvent(true, "V", false, game)
            K:SendKeyEvent(false, "V", false, game)
        end
    elseif Y == "Gun" then
        weaponSc("Gun")
        if d == "Z" then
            K:SendKeyEvent(true, "Z", false, game)
            K:SendKeyEvent(false, "Z", false, game)
        elseif d == "X" then
            K:SendKeyEvent(true, "X", false, game)
            K:SendKeyEvent(false, "X", false, game)
        end
    end
    if Y == "nil" and d == "Y" then
        K:SendKeyEvent(true, "Y", false, game)
        K:SendKeyEvent(false, "Y", false, game)
    end
end
local s = getrawmetatable(game)
local x = s.__namecall
setreadonly(s, false)
s.__namecall = newcclosure(function(...)
    local Y = getnamecallmethod()
    local d = { ... }
    if tostring(Y) == "FireServer" then
        if tostring(d[1]) == "RemoteEvent" then
            if tostring(d[2]) ~= "true" and tostring(d[2]) ~= "false" then
                if _G.FarmMastery_G and not b or _G.FarmMastery_Dev or _G.FarmBlazeEM or _G.Prehis_Skills or _G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials or _G.AimMethod and ABmethod == "AimBots Skill" or _G.AimMethod and ABmethod == "Auto Aimbots" then
                    d[2] = MousePos
                    return x(unpack(d))
                end
            end
        end
    end
    return x(...)
end)
GetConnectionEnemies = function(Y)
    for d, R in pairs(Q:GetChildren()) do
        if R:IsA("Model") and ((typeof(Y) == "table" and table.find(Y, R.Name) or R.Name == Y) and (R:FindFirstChild("Humanoid") and R.Humanoid.Health > 0)) then
            return R
        end
    end
    for d, R in next, game.Workspace.Enemies:GetChildren() do
        if R:IsA("Model") and ((typeof(Y) == "table" and table.find(Y, R.Name) or R.Name == Y) and (R:FindFirstChild("Humanoid") and R.Humanoid.Health > 0)) then
            return R
        end
    end
end
LowCpu = function()
    local Y = true
    local d = game
    local R = d.Workspace
    local Q = d.Lighting
    local r = R.Terrain
    r.WaterWaveSize = 0
    r.WaterWaveSpeed = 0
    r.WaterReflectance = 0
    r.WaterTransparency = 0
    Q.GlobalShadows = false
    Q.FogEnd = 9000000000.0
    Q.Brightness = 0
    (settings()).Rendering.QualityLevel = "Level01"
    for d, R in pairs(d:GetDescendants()) do
        if R:IsA("Part") or R:IsA("Union") or R:IsA("CornerWedgePart") or R:IsA("TrussPart") then
            R.Material = "Plastic"
            R.Reflectance = 0
        elseif R:IsA("Decal") or R:IsA("Texture") and Y then
            R.Transparency = 1
        elseif R:IsA("ParticleEmitter") or R:IsA("Trail") then
            R.Lifetime = NumberRange.new(0)
        elseif R:IsA("Explosion") then
            R.BlastPressure = 1
            R.BlastRadius = 1
        elseif R:IsA("Fire") or R:IsA("SpotLight") or R:IsA("Smoke") or R:IsA("Sparkles") then
            R.Enabled = false
        elseif R:IsA("MeshPart") then
            R.Material = "Plastic"
            R.Reflectance = 0
            R.TextureID = 10385902758728957
        end
    end
    for Y, d in pairs(Q:GetChildren()) do
        if d:IsA("BlurEffect") or d:IsA("SunRaysEffect") or d:IsA("ColorCorrectionEffect") or d:IsA("BloomEffect") or d:IsA("DepthOfFieldEffect") then
            d.Enabled = false
        end
    end
end
CheckF = function()
    if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then
        return true
    end
end
CheckBoat = function()
    for Y, R in pairs(workspace.Boats:GetChildren()) do
        if tostring(R.Owner.Value) == tostring(d.Name) then
            return R
        end
    end
    return false
end
CheckEnemiesBoat = function()
    for Y, d in pairs(workspace.Enemies:GetChildren()) do
        if d.Name == "FishBoat" and (d:FindFirstChild("Health")).Value > 0 then
            return true
        end
    end
    return false
end
CheckPirateGrandBrigade = function()
    for Y, d in pairs(workspace.Enemies:GetChildren()) do
        if (d.Name == "PirateGrandBrigade" or d.Name == "PirateBrigade") and (d:FindFirstChild("Health")).Value > 0 then
            return true
        end
    end
    return false
end
CheckShark = function()
    for Y, d in pairs(workspace.Enemies:GetChildren()) do
        if d.Name == "Shark" and f.Alive(d) then
            return true
        end
    end
    return false
end
CheckTerrorShark = function()
    for Y, d in pairs(workspace.Enemies:GetChildren()) do
        if d.Name == "Terrorshark" and f.Alive(d) then
            return true
        end
    end
    return false
end
CheckPiranha = function()
    for Y, d in pairs(workspace.Enemies:GetChildren()) do
        if d.Name == "Piranha" and f.Alive(d) then
            return true
        end
    end
    return false
end
CheckFishCrew = function()
    for Y, d in pairs(workspace.Enemies:GetChildren()) do
        if (d.Name == "Fish Crew Member" or d.Name == "Haunted Crew Member") and f.Alive(d) then
            return true
        end
    end
    return false
end
CheckHauntedCrew = function()
    for Y, d in pairs(workspace.Enemies:GetChildren()) do
        if d.Name == "Haunted Crew Member" and f.Alive(d) then
            return true
        end
    end
    return false
end
CheckSeaBeast = function()
    if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
        return true
    end
    return false
end
CheckLeviathan = function()
    if workspace.SeaBeasts:FindFirstChild("Leviathan") then
        return true
    end
    return false
end
UpdStFruit = function()
    for Y, R in next, d.Backpack:GetChildren() do
        StoreFruit = R:FindFirstChild("EatRemote", true)
        if StoreFruit then
            Q.Remotes.CommF_:InvokeServer("StoreFruit", StoreFruit.Parent:GetAttribute("OriginalName"), d.Backpack:FindFirstChild(R.Name))
        end
    end
end
collectFruits = function(Y)
    if Y then
        local Y = d.Character
        for d, R in pairs(workspace:GetChildren()) do
            if string.find(R.Name, "Fruit") then
                R.Handle.CFrame = Y.HumanoidRootPart.CFrame
            end
        end
    end
end
Getmoon = function()
    if World1 then
        return F.FantasySky.MoonTextureId
    elseif World2 then
        return F.FantasySky.MoonTextureId
    elseif World3 then
        return F.Sky.MoonTextureId
    end
end
DropFruits = function()
    for Y, R in next, d.Backpack:GetChildren() do
        if string.find(R.Name, "Fruit") then
            EquipWeapon(R.Name)
            wait(.1)
            if d.PlayerGui.Main.Dialogue.Visible == true then
                d.PlayerGui.Main.Dialogue.Visible = false
            end
            EquipWeapon(R.Name)
            (d.Character:FindFirstChild(R.Name)).EatRemote:InvokeServer("Drop")
        end
    end
    for Y, R in pairs(d.Character:GetChildren()) do
        if string.find(R.Name, "Fruit") then
            EquipWeapon(R.Name)
            wait(.1)
            if d.PlayerGui.Main.Dialogue.Visible == true then
                d.PlayerGui.Main.Dialogue.Visible = false
            end
            EquipWeapon(R.Name)
            (d.Character:FindFirstChild(R.Name)).EatRemote:InvokeServer("Drop")
        end
    end
end
GetBP = function(Y)
    return d.Backpack:FindFirstChild(Y) or d.Character:FindFirstChild(Y)
end
GetIn = function(Y)
    for R, Q in pairs(Q.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(Q) == "table" then
            if Q.Name == Y or d.Character:FindFirstChild(Y) or d.Backpack:FindFirstChild(Y) then
                return true
            end
        end
    end
    return false
end
GetM = function(Y)
    for d, R in pairs(Q.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(R) == "table" then
            if R.Type == "Material" then
                if R.Name == Y then
                    return R.Count
                end
            end
        end
    end
    return 0
end
GetWP = function(Y)
    for R, Q in pairs(Q.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(Q) == "table" then
            if Q.Type == "Sword" then
                if Q.Name == Y or d.Character:FindFirstChild(Y) or d.Backpack:FindFirstChild(Y) then
                    return true
                end
            end
        end
    end
    return false
end
getInfinity_Ability = function(Y, Q)
    if not R then return end
    if Y == "Soru" and Q then
        for Y, R in next, getgc() do
            if d.Character.Soru then
                if typeof(R) == "function" and (getfenv(R)).script == d.Character.Soru then
                    for Y, R in next, getupvalues(R) do
                        if typeof(R) == "table" then
                            repeat
                                wait(T)
                                R.LastUse = 0
                            until not Q or d.Character.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end
    elseif Y == "Energy" and Q then
        d.Character.Energy.Changed:connect(function()
            if Q then
                d.Character.Energy.Value = D
            end
        end)
    elseif Y == "Observation" and Q then
        local Y = d.VisionRadius
        Y.Value = math.huge
    end
end
Hop = function()
    pcall(function()
        for Y = math.random(1, math.random(40, 75)), 100, 1 do
            local d = Q.__ServerBrowser:InvokeServer(Y)
            for Y, d in next, d do
                if tonumber(d.Count) < 12 then
                    a:TeleportToPlaceInstance(game.PlaceId, Y)
                end
            end
        end
    end)
end
local J = Instance.new("Part", workspace)
J.Size = Vector3.new(1, 1, 1)
J.Name = "Rip_Indra"
J.Anchored = true
J.CanCollide = false
J.CanTouch = false
J.Transparency = 1
local Yz = workspace:FindFirstChild(J.Name)
if Yz and Yz ~= J then Yz:Destroy() end
task.spawn(function()
    while task.wait() do
        if J and J.Parent == workspace then
            if y then (getgenv()).OnFarm = true else (getgenv()).OnFarm = false end
        else
            (getgenv()).OnFarm = false
        end
    end
end)
task.spawn(function()
    local Y = game.Players.LocalPlayer
    repeat task.wait() until Y.Character and Y.Character.PrimaryPart
    J.CFrame = Y.Character.PrimaryPart.CFrame
    while task.wait() do
        pcall(function()
            if (getgenv()).OnFarm then
                if J and J.Parent == workspace then
                    local d = Y.Character and Y.Character.PrimaryPart
                    if d and (d.Position - J.Position).Magnitude <= 200 then
                        d.CFrame = J.CFrame
                    else
                        J.CFrame = d.CFrame
                    end
                end
                local d = Y.Character
                if d then
                    for Y, d in pairs(d:GetChildren()) do
                        if d:IsA("BasePart") then
                            d.CanCollide = false
                        end
                    end
                end
            else
                local d = Y.Character
                if d then
                    for Y, d in pairs(d:GetChildren()) do
                        if d:IsA("BasePart") then
                            d.CanCollide = true
                        end
                    end
                end
            end
        end)
    end
end)
_tp = function(Y)
    local R = d.Character
    if not R or not R:FindFirstChild("HumanoidRootPart") then return end
    local Q = R.HumanoidRootPart
    local r = (Y.Position - Q.Position).Magnitude
    local a = TweenInfo.new(r / 300, Enum.EasingStyle.Linear)
    local w = (game:GetService("TweenService")):Create(J, a, { CFrame = Y })
    if d.Character.Humanoid.Sit == true then
        J.CFrame = CFrame.new(J.Position.X, Y.Y, J.Position.Z)
    end
    w:Play()
    task.spawn(function()
        while w.PlaybackState == Enum.PlaybackState.Playing do
            if not y then w:Cancel(); break end
            task.wait(.1)
        end
    end)
end
TeleportToTarget = function(Y)
    if (Y.Position - d.Character.HumanoidRootPart.Position).Magnitude > 1000 then
        _tp(Y)
    else
        _tp(Y)
    end
end
notween = function(Y)
    d.Character.HumanoidRootPart.CFrame = Y
end
function BTP(Y)
    local d = game.Players.LocalPlayer
    local R = d.Character.HumanoidRootPart
    local Q = d.Character.Humanoid
    local r = d.PlayerGui.Main
    local a = Y.Position
    local w = R.Position
    repeat
        Q.Health = 0
        R.CFrame = Y
        r.Quest.Visible = false
        if (R.Position - w).Magnitude > 1 then
            w = R.Position
            R.CFrame = Y
        end
        task.wait(.5)
    until (Y.Position - R.Position).Magnitude <= 2000
end
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or (getgenv()).AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S then
                y = true
                if not d.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local Y = Instance.new("BodyVelocity")
                    Y.Name = "BodyClip"
                    Y.Parent = d.Character.HumanoidRootPart
                    Y.MaxForce = Vector3.new(100000, 100000, 100000)
                    Y.Velocity = Vector3.new(0, 0, 0)
                end
                if not d.Character:FindFirstChild("highlight") then
                    local Y = Instance.new("Highlight")
                    Y.Name = "highlight"
                    Y.Enabled = true
                    Y.FillColor = Color3.fromRGB(0, 255, 255)
                    Y.OutlineColor = Color3.fromRGB(255, 255, 255)
                    Y.FillTransparency = .5
                    Y.OutlineTransparency = .2
                    Y.Parent = d.Character
                end
                for Y, d in pairs(d.Character:GetDescendants()) do
                    if d:IsA("BasePart") then
                        d.CanCollide = false
                    end
                end
            else
                y = false
                if d.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    (d.Character.HumanoidRootPart:FindFirstChild("BodyClip")):Destroy()
                end
                if d.Character:FindFirstChild("highlight") then
                    (d.Character:FindFirstChild("highlight")):Destroy()
                end
            end
        end)
    end
end)
MaterialMon = function()
    local Y = game.Players.LocalPlayer
    local d = Y.Character and Y.Character:FindFirstChild("HumanoidRootPart")
    if not d then return end
    shouldRequestEntrance = function(Y, R)
        local r = (d.Position - Y).Magnitude
        if r >= R then
            Q.Remotes.CommF_:InvokeServer("requestEntrance", Y)
        end
    end
    if World1 then
        if SelectMaterial == "Angel Wings" then
            MMon = { "Shanda", "Royal Squad", "Royal Soldier", "Wysper", "Thunder God" }
            MPos = CFrame.new(-4698, 845, -1912)
            SP = "Default"
            local Y = Vector3.new(-4607.82275, 872.54248, -1667.55688)
            shouldRequestEntrance(Y, 10000)
        elseif SelectMaterial == "Leather + Scrap Metal" then
            MMon = { "Brute", "Pirate" }
            MPos = CFrame.new(-1145, 15, 4350)
            SP = "Default"
        elseif SelectMaterial == "Magma Ore" then
            MMon = { "Military Soldier", "Military Spy", "Magma Admiral" }
            MPos = CFrame.new(-5815, 84, 8820)
            SP = "Default"
        elseif SelectMaterial == "Fish Tail" then
            MMon = { "Fishman Warrior", "Fishman Commando", "Fishman Lord" }
            MPos = CFrame.new(61123, 19, 1569)
            SP = "Default"
            local Y = Vector3.new(61163.8515625, 5.342342376709, 1819.7841796875)
            shouldRequestEntrance(Y, 17000)
        end
    elseif World2 then
        if SelectMaterial == "Leather + Scrap Metal" then
            MMon = { "Marine Captain" }
            MPos = CFrame.new(-2010.5059814453, 73.001159667969, -3326.6208496094)
            SP = "Default"
        elseif SelectMaterial == "Magma Ore" then
            MMon = { "Magma Ninja", "Lava Pirate" }
            MPos = CFrame.new(-5428, 78, -5959)
            SP = "Default"
        elseif SelectMaterial == "Ectoplasm" then
            MMon = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer" }
            MPos = CFrame.new(911.35827636719, 125.95812988281, 33159.5390625)
            SP = "Default"
            local Y = Vector3.new(61163.8515625, 5.342342376709, 1819.7841796875)
            shouldRequestEntrance(Y, 18000)
        elseif SelectMaterial == "Mystic Droplet" then
            MMon = { "Water Fighter" }
            MPos = CFrame.new(-3385, 239, -10542)
            SP = "Default"
        elseif SelectMaterial == "Radioactive Material" then
            MMon = { "Factory Staff" }
            MPos = CFrame.new(295, 73, -56)
            SP = "Default"
        elseif SelectMaterial == "Vampire Fang" then
            MMon = { "Vampire" }
            MPos = CFrame.new(-6033, 7, -1317)
            SP = "Default"
        end
    elseif World3 then
        if SelectMaterial == "Scrap Metal" then
            MMon = { "Jungle Pirate", "Forest Pirate" }
            MPos = CFrame.new(-11975.78515625, 331.77340698242, -10620.030273438)
            SP = "Default"
        elseif SelectMaterial == "Fish Tail" then
            MMon = { "Fishman Raider", "Fishman Captain" }
            MPos = CFrame.new(-10993, 332, -8940)
            SP = "Default"
        elseif SelectMaterial == "Conjured Cocoa" then
            MMon = { "Chocolate Bar Battler", "Cocoa Warrior" }
            MPos = CFrame.new(620.63446044922, 78.936447143555, -12581.369140625)
            SP = "Default"
        elseif SelectMaterial == "Dragon Scale" then
            MMon = { "Dragon Crew Archer", "Dragon Crew Warrior" }
            MPos = CFrame.new(6594, 383, 139)
            SP = "Default"
        elseif SelectMaterial == "Gunpowder" then
            MMon = { "Pistol Billionaire" }
            MPos = CFrame.new(-84.855690002441, 85.620613098145, 6132.0087890625)
            SP = "Default"
        elseif SelectMaterial == "Mini Tusk" then
            MMon = { "Mythological Pirate" }
            MPos = CFrame.new(-13545, 470, -6917)
            SP = "Default"
        elseif SelectMaterial == "Demonic Wisp" then
            MMon = { "Demonic Soul" }
            MPos = CFrame.new(-9495.6806640625, 453.58624267578, 5977.3486328125)
            SP = "Default"
        end
    end
end
function CheckQuest()
    MyLevel = (game:GetService("Players")).LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, .939700544, 0, -0.341998369, 0, 1, 0, .341998369, 0, .939700544)
            CFrameMon = CFrame.new(1045.9626464844, 27.002508163452, 1560.8203125)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
            CFrameMon = CFrame.new(-1448.5180664062, 67.853012084961, 11.465796470642)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, 0, -1, 0, 0)
            CFrameMon = CFrame.new(-1129.8836669922, 40.46354675293, -525.42370605469)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, .965929627, 0, -0.258804798, 0, 1, 0, .258804798, 0, .965929627)
            CFrameMon = CFrame.new(-1103.5134277344, 13.752052307129, 3896.0910644531)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, .965929627, 0, -0.258804798, 0, 1, 0, .258804798, 0, .965929627)
            CFrameMon = CFrame.new(-1140.0837402344, 14.809885025024, 4322.9213867188)
        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, .819155693, 0, -0.573571265, 0, 1, 0, .573571265, 0, .819155693)
            CFrameMon = CFrame.new(924.7998046875, 6.4486746788025, 4481.5859375)
        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, .819155693, 0, -0.573571265, 0, 1, 0, .573571265, 0, .819155693)
            CFrameMon = CFrame.new(1608.2822265625, 8.6142244338989, 4371.0073242188)
        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, .939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            CFrameMon = CFrame.new(1354.3479003906, 87.272773742676, -1393.9465332031)
        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, .939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
            CFrameMon = CFrame.new(1201.6412353516, 144.57958984375, -1550.0670166016)
        elseif MyLevel >= 120 and MyLevel <= 149 then
            Mon = "Chief Petty Officer"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-4881.2309570312, 22.652044296265, 4273.7524414062)
        elseif MyLevel >= 150 and MyLevel <= 174 then
            Mon = "Sky Bandit"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, .866007268, 0, .500031412, 0, 1, 0, -0.500031412, 0, .866007268)
            CFrameMon = CFrame.new(-4953.20703125, 295.74420166016, -2899.2290039062)
        elseif MyLevel >= 175 and MyLevel <= 189 then
            Mon = "Dark Master"
            LevelQuest = 2
            NameQuest = "SkyQuest"
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, .866007268, 0, .500031412, 0, 1, 0, -0.500031412, 0, .866007268)
            CFrameMon = CFrame.new(-5259.8447265625, 391.39767456055, -2229.0354003906)
        elseif MyLevel >= 190 and MyLevel <= 209 then
            Mon = "Prisoner"
            LevelQuest = 1
            NameQuest = "PrisonerQuest"
            NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, .995993316, -2.06384709e-09, -0.0894274712)
            CFrameMon = CFrame.new(5098.9736328125, -0.3204058110714, 474.23733520508)
        elseif MyLevel >= 210 and MyLevel <= 249 then
            Mon = "Dangerous Prisoner"
            LevelQuest = 2
            NameQuest = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, .995993316, -2.06384709e-09, -0.0894274712)
            CFrameMon = CFrame.new(5654.5634765625, 15.633401870728, 866.29919433594)
        elseif MyLevel >= 250 and MyLevel <= 274 then
            Mon = "Toga Warrior"
            LevelQuest = 1
            NameQuest = "ColosseumQuest"
            NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, .857167721, 0, -0.515037298)
            CFrameMon = CFrame.new(-1820.21484375, 51.683856964111, -2740.6650390625)
        elseif MyLevel >= 275 and MyLevel <= 299 then
            Mon = "Gladiator"
            LevelQuest = 2
            NameQuest = "ColosseumQuest"
            NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, .857167721, 0, -0.515037298)
            CFrameMon = CFrame.new(-1292.8381347656, 56.380882263184, -3339.0314941406)
        elseif MyLevel >= 300 and MyLevel <= 324 then
            Mon = "Military Soldier"
            LevelQuest = 1
            NameQuest = "MagmaQuest"
            NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, .866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            CFrameMon = CFrame.new(-5411.1645507812, 11.081554412842, 8454.29296875)
        elseif MyLevel >= 325 and MyLevel <= 374 then
            Mon = "Military Spy"
            LevelQuest = 2
            NameQuest = "MagmaQuest"
            NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, .866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            CFrameMon = CFrame.new(-5802.8681640625, 86.262413024902, 8828.859375)
        elseif MyLevel >= 375 and MyLevel <= 399 then
            Mon = "Fishman Warrior"
            LevelQuest = 1
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(60878.30078125, 18.482830047607, 1543.7574462891)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel >= 400 and MyLevel <= 449 then
            Mon = "Fishman Commando"
            LevelQuest = 2
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Commando"
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(61922.6328125, 18.482830047607, 1493.9343261719)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel >= 450 and MyLevel <= 474 then
            Mon = "God's Guard"
            LevelQuest = 1
            NameQuest = "SkyExp1Quest"
            NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, .996191859, 0, -0.0871884301, 0, 1, 0, .0871884301, 0, .996191859)
            CFrameMon = CFrame.new(-4710.04296875, 845.27697753906, -1927.3079833984)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif MyLevel >= 475 and MyLevel <= 524 then
            Mon = "Shanda"
            LevelQuest = 2
            NameQuest = "SkyExp1Quest"
            NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, .906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
            CFrameMon = CFrame.new(-7678.4897460938, 5566.4038085938, -497.21560668945)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif MyLevel >= 525 and MyLevel <= 549 then
            Mon = "Royal Squad"
            LevelQuest = 1
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-7624.2524414062, 5658.1333007812, -1467.3542480469)
        elseif MyLevel >= 550 and MyLevel <= 624 then
            Mon = "Royal Soldier"
            LevelQuest = 2
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-7836.7534179688, 5645.6640625, -1790.6236572266)
        elseif MyLevel >= 625 and MyLevel <= 649 then
            Mon = "Galley Pirate"
            LevelQuest = 1
            NameQuest = "FountainQuest"
            NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, .087131381, 0, .996196866, 0, 1, 0, -0.996196866, 0, .087131381)
            CFrameMon = CFrame.new(5551.0219726562, 78.901351928711, 3930.4128417969)
        elseif MyLevel >= 650 then
            Mon = "Galley Captain"
            LevelQuest = 2
            NameQuest = "FountainQuest"
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, .087131381, 0, .996196866, 0, 1, 0, -0.996196866, 0, .087131381)
            CFrameMon = CFrame.new(5441.9516601562, 42.502059936523, 4950.09375)
        end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then
            Mon = "Raider"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, .974368095, 0, -0.22495985)
            CFrameMon = CFrame.new(-728.32672119141, 52.779319763184, 2345.7705078125)
        elseif MyLevel >= 725 and MyLevel <= 774 then
            Mon = "Mercenary"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, .974368095, 0, -0.22495985)
            CFrameMon = CFrame.new(-1004.3244018555, 80.158866882324, 1424.6193847656)
        elseif MyLevel >= 775 and MyLevel <= 799 then
            Mon = "Swan Pirate"
            LevelQuest = 1
            NameQuest = "Area2Quest"
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, .139203906, 0, .99026376, 0, 1, 0, -0.99026376, 0, .139203906)
            CFrameMon = CFrame.new(1068.6643066406, 137.61428833008, 1322.1060791016)
        elseif MyLevel >= 800 and MyLevel <= 874 then
            Mon = "Factory Staff"
            NameQuest = "Area2Quest"
            LevelQuest = 2
            NameMon = "Factory Staff"
            CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, .999488771, -1.07732087e-10, -0.0319722369)
            CFrameMon = CFrame.new(73.078674316406, 81.863441467285, -27.470672607422)
        elseif MyLevel >= 875 and MyLevel <= 899 then
            Mon = "Marine Lieutenant"
            LevelQuest = 1
            NameQuest = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, .866007268, 0, .500031412, 0, 1, 0, -0.500031412, 0, .866007268)
            CFrameMon = CFrame.new(-2821.3723144531, 75.897277832031, -3070.0891113281)
        elseif MyLevel >= 900 and MyLevel <= 949 then
            Mon = "Marine Captain"
            LevelQuest = 2
            NameQuest = "MarineQuest3"
            NameMon = "Marine Captain"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, .866007268, 0, .500031412, 0, 1, 0, -0.500031412, 0, .866007268)
            CFrameMon = CFrame.new(-1861.2310791016, 80.176582336426, -3254.6975097656)
        elseif MyLevel >= 950 and MyLevel <= 974 then
            Mon = "Zombie"
            LevelQuest = 1
            NameQuest = "ZombieQuest"
            NameMon = "Zombie"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, .95628953, 0, -0.29242146)
            CFrameMon = CFrame.new(-5657.7768554688, 78.969734191895, -928.68701171875)
        elseif MyLevel >= 975 and MyLevel <= 999 then
            Mon = "Vampire"
            LevelQuest = 2
            NameQuest = "ZombieQuest"
            NameMon = "Vampire"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, .95628953, 0, -0.29242146)
            CFrameMon = CFrame.new(-6037.66796875, 32.184638977051, -1340.6597900391)
        elseif MyLevel >= 1000 and MyLevel <= 1049 then
            Mon = "Snow Trooper"
            LevelQuest = 1
            NameQuest = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, .92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            CFrameMon = CFrame.new(549.14733886719, 427.38705444336, -5563.6987304688)
        elseif MyLevel >= 1050 and MyLevel <= 1099 then
            Mon = "Winter Warrior"
            LevelQuest = 2
            NameQuest = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, .92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
            CFrameMon = CFrame.new(1142.7451171875, 475.63980102539, -5199.4165039062)
        elseif MyLevel >= 1100 and MyLevel <= 1124 then
            Mon = "Lab Subordinate"
            LevelQuest = 1
            NameQuest = "IceSideQuest"
            NameMon = "Lab Subordinate"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, .453972578, 0, -0.891015649, 0, 1, 0, .891015649, 0, .453972578)
            CFrameMon = CFrame.new(-5707.4716796875, 15.951709747314, -4513.3920898438)
        elseif MyLevel >= 1125 and MyLevel <= 1174 then
            Mon = "Horned Warrior"
            LevelQuest = 2
            NameQuest = "IceSideQuest"
            NameMon = "Horned Warrior"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, .453972578, 0, -0.891015649, 0, 1, 0, .891015649, 0, .453972578)
            CFrameMon = CFrame.new(-6341.3666992188, 15.951770782471, -5723.162109375)
        elseif MyLevel >= 1175 and MyLevel <= 1199 then
            Mon = "Magma Ninja"
            LevelQuest = 1
            NameQuest = "FireSideQuest"
            NameMon = "Magma Ninja"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, .469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-5449.6728515625, 76.658744812012, -5808.2006835938)
        elseif MyLevel >= 1200 and MyLevel <= 1249 then
            Mon = "Lava Pirate"
            LevelQuest = 2
            NameQuest = "FireSideQuest"
            NameMon = "Lava Pirate"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, .469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-5213.3315429688, 49.737880706787, -4701.451171875)
        elseif MyLevel >= 1250 and MyLevel <= 1274 then
            Mon = "Ship Deckhand"
            LevelQuest = 1
            NameQuest = "ShipQuest1"
            NameMon = "Ship Deckhand"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
            CFrameMon = CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel >= 1275 and MyLevel <= 1299 then
            Mon = "Ship Engineer"
            LevelQuest = 2
            NameQuest = "ShipQuest1"
            NameMon = "Ship Engineer"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
            CFrameMon = CFrame.new(919.47863769531, 43.544013977051, 32779.96875)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel >= 1300 and MyLevel <= 1324 then
            Mon = "Ship Steward"
            LevelQuest = 1
            NameQuest = "ShipQuest2"
            NameMon = "Ship Steward"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
            CFrameMon = CFrame.new(919.43853759766, 129.55599975586, 33436.03515625)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel >= 1325 and MyLevel <= 1349 then
            Mon = "Ship Officer"
            LevelQuest = 2
            NameQuest = "ShipQuest2"
            NameMon = "Ship Officer"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
            CFrameMon = CFrame.new(1036.0179443359, 181.4390411377, 33315.7265625)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel >= 1350 and MyLevel <= 1374 then
            Mon = "Arctic Warrior"
            LevelQuest = 1
            NameQuest = "FrostQuest"
            NameMon = "Arctic Warrior"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, .358349502, 0, -0.933587909)
            CFrameMon = CFrame.new(5966.24609375, 62.970020294189, -6179.3828125)
            if (getgenv()).AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-6508.5581054688, 5000.0349960327, -132.83953857422))
            end
        elseif MyLevel >= 1375 and MyLevel <= 1424 then
            Mon = "Snow Lurker"
            LevelQuest = 2
            NameQuest = "FrostQuest"
            NameMon = "Snow Lurker"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, .358349502, 0, -0.933587909)
            CFrameMon = CFrame.new(5407.0737304688, 69.194374084473, -6880.8803710938)
        elseif MyLevel >= 1425 and MyLevel <= 1449 then
            Mon = "Sea Soldier"
            LevelQuest = 1
            NameQuest = "ForgottenQuest"
            NameMon = "Sea Soldier"
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, .990270376, 0, -0.13915664, 0, 1, 0, .13915664, 0, .990270376)
            CFrameMon = CFrame.new(-3028.2236328125, 64.674514770508, -9775.4267578125)
        elseif MyLevel >= 1450 then
            Mon = "Water Fighter"
            LevelQuest = 2
            NameQuest = "ForgottenQuest"
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3054, 240, -10146)
            CFrameMon = CFrame.new(-3291, 252, -10501)
        end
    elseif World3 then
        if MyLevel >= 1500 and MyLevel <= 1524 then
            Mon = "Pirate Millionaire"
            LevelQuest = 1
            NameQuest = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, .965929627, 0, -0.258804798, 0, 1, 0, .258804798, 0, .965929627)
            CFrameMon = CFrame.new(-245.99638366699, 47.30615234375, 5584.1005859375)
        elseif MyLevel >= 1525 and MyLevel <= 1574 then
            Mon = "Pistol Billionaire"
            LevelQuest = 2
            NameQuest = "PiratePortQuest"
            NameMon = "Pistol Billionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, .965929627, 0, -0.258804798, 0, 1, 0, .258804798, 0, .965929627)
            CFrameMon = CFrame.new(-187.33015441895, 86.239875793457, 6013.513671875)
        elseif MyLevel >= 1575 and MyLevel <= 1599 then
            Mon = "Dragon Crew Warrior"
            LevelQuest = 1
            NameQuest = "DragonCrewQuest"
            NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(6738.9614257812, 127.81645965576, -713.51147460938)
            CFrameMon = CFrame.new(6920.7143554688, 56.1559715271, -942.50445556641)
        elseif MyLevel >= 1600 and MyLevel <= 1624 then
            Mon = "Dragon Crew Archer"
            NameQuest = "DragonCrewQuest"
            LevelQuest = 2
            NameMon = "Dragon Crew Archer"
            CFrameQuest = CFrame.new(6738.9614257812, 127.81645965576, -713.51147460938)
            CFrameMon = CFrame.new(6817.9125976562, 484.80444335938, 513.41412353516)
        elseif MyLevel >= 1625 and MyLevel <= 1649 then
            Mon = "Hydra Enforcer"
            NameQuest = "VenomCrewQuest"
            LevelQuest = 1
            NameMon = "Hydra Enforcer"
            CFrameQuest = CFrame.new(5213.8740234375, 1004.5042724609, 758.69445800781)
            CFrameMon = CFrame.new(4584.6928710938, 1002.6435546875, 705.7958984375)
        elseif MyLevel >= 1650 and MyLevel <= 1699 then
            Mon = "Venomous Assailant"
            NameQuest = "VenomCrewQuest"
            LevelQuest = 2
            NameMon = "Venomous Assailant"
            CFrameQuest = CFrame.new(5213.8740234375, 1004.5042724609, 758.69445800781)
            CFrameMon = CFrame.new(4638.7856445312, 1078.9409179688, 881.80023193359)
        elseif MyLevel >= 1700 and MyLevel <= 1724 then
            Mon = "Marine Commodore"
            LevelQuest = 1
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Commodore"
            CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, .258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
            CFrameMon = CFrame.new(2286.0078125, 73.133918762207, -7159.8090820312)
        elseif MyLevel >= 1725 and MyLevel <= 1774 then
            Mon = "Marine Rear Admiral"
            NameMon = "Marine Rear Admiral"
            NameQuest = "MarineTreeIsland"
            LevelQuest = 2
            CFrameQuest = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
            CFrameMon = CFrame.new(3656.7736816406, 160.52406311035, -7001.5986328125)
        elseif MyLevel >= 1775 and MyLevel <= 1799 then
            Mon = "Fishman Raider"
            LevelQuest = 1
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Raider"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, .469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-10407.526367188, 331.76263427734, -8368.5166015625)
        elseif MyLevel >= 1800 and MyLevel <= 1824 then
            Mon = "Fishman Captain"
            LevelQuest = 2
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Captain"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, .469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
            CFrameMon = CFrame.new(-10994.701171875, 352.38140869141, -9002.1103515625)
        elseif MyLevel >= 1825 and MyLevel <= 1849 then
            Mon = "Forest Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland"
            NameMon = "Forest Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, .707134247, 0, -0.707079291, 0, 1, 0, .707079291, 0, .707134247)
            CFrameMon = CFrame.new(-13274.478515625, 332.37814331055, -7769.5805664062)
        elseif MyLevel >= 1850 and MyLevel <= 1899 then
            Mon = "Mythological Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland"
            NameMon = "Mythological Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, .707134247, 0, -0.707079291, 0, 1, 0, .707079291, 0, .707134247)
            CFrameMon = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
        elseif MyLevel >= 1900 and MyLevel <= 1924 then
            Mon = "Jungle Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland2"
            NameMon = "Jungle Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, .996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
            CFrameMon = CFrame.new(-12256.16015625, 331.73828125, -10485.836914062)
        elseif MyLevel >= 1925 and MyLevel <= 1974 then
            Mon = "Musketeer Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland2"
            NameMon = "Musketeer Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, .996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
            CFrameMon = CFrame.new(-13457.904296875, 391.54565429688, -9859.177734375)
        elseif MyLevel >= 1975 and MyLevel <= 1999 then
            Mon = "Reborn Skeleton"
            LevelQuest = 1
            NameQuest = "HauntedQuest1"
            NameMon = "Reborn Skeleton"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0)
            CFrameMon = CFrame.new(-8763.7236328125, 165.72299194336, 6159.8618164062)
        elseif MyLevel >= 2000 and MyLevel <= 2024 then
            Mon = "Living Zombie"
            LevelQuest = 2
            NameQuest = "HauntedQuest1"
            NameMon = "Living Zombie"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0)
            CFrameMon = CFrame.new(-10144.131835938, 138.6266784668, 5838.0888671875)
        elseif MyLevel >= 2025 and MyLevel <= 2049 then
            Mon = "Demonic Soul"
            LevelQuest = 1
            NameQuest = "HauntedQuest2"
            NameMon = "Demonic Soul"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-9505.8720703125, 172.10482788086, 6158.9931640625)
        elseif MyLevel >= 2050 and MyLevel <= 2074 then
            Mon = "Posessed Mummy"
            LevelQuest = 2
            NameQuest = "HauntedQuest2"
            NameMon = "Posessed Mummy"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-9582.0224609375, 6.2515273094177, 6205.478515625)
        elseif MyLevel >= 2075 and MyLevel <= 2099 then
            Mon = "Peanut Scout"
            LevelQuest = 1
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut Scout"
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-2143.2419433594, 47.721984863281, -10029.995117188)
        elseif MyLevel >= 2100 and MyLevel <= 2124 then
            Mon = "Peanut President"
            LevelQuest = 2
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut President"
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-1859.3540039062, 38.103168487549, -10422.4296875)
        elseif MyLevel >= 2125 and MyLevel <= 2149 then
            Mon = "Ice Cream Chef"
            LevelQuest = 1
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Chef"
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-872.24658203125, 65.81957244873, -10919.95703125)
        elseif MyLevel >= 2150 and MyLevel <= 2199 then
            Mon = "Ice Cream Commander"
            LevelQuest = 2
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Commander"
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            CFrameMon = CFrame.new(-558.06103515625, 112.04895782471, -11290.774414062)
        elseif MyLevel >= 2200 and MyLevel <= 2224 then
            Mon = "Cookie Crafter"
            LevelQuest = 1
            NameQuest = "CakeQuest1"
            NameMon = "Cookie Crafter"
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, .957576931, -8.80302053e-08, .288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, .957576931)
            CFrameMon = CFrame.new(-2374.13671875, 37.798263549805, -12125.30859375)
        elseif MyLevel >= 2225 and MyLevel <= 2249 then
            Mon = "Cake Guard"
            LevelQuest = 2
            NameQuest = "CakeQuest1"
            NameMon = "Cake Guard"
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, .957576931, -8.80302053e-08, .288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, .957576931)
            CFrameMon = CFrame.new(-1598.3070068359, 43.773197174072, -12244.581054688)
        elseif MyLevel >= 2250 and MyLevel <= 2274 then
            Mon = "Baking Staff"
            LevelQuest = 1
            NameQuest = "CakeQuest2"
            NameMon = "Baking Staff"
            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, .250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
            CFrameMon = CFrame.new(-1887.8099365234, 77.618507385254, -12998.350585938)
        elseif MyLevel >= 2275 and MyLevel <= 2299 then
            Mon = "Head Baker"
            LevelQuest = 2
            NameQuest = "CakeQuest2"
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, .250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
            CFrameMon = CFrame.new(-2216.1882324219, 82.884521484375, -12869.293945312)
        elseif MyLevel >= 2300 and MyLevel <= 2324 then
            Mon = "Cocoa Warrior"
            LevelQuest = 1
            NameQuest = "ChocQuest1"
            NameMon = "Cocoa Warrior"
            CFrameQuest = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438)
            CFrameMon = CFrame.new(-21.553283691406, 80.574996948242, -12352.387695312)
        elseif MyLevel >= 2325 and MyLevel <= 2349 then
            Mon = "Chocolate Bar Battler"
            LevelQuest = 2
            NameQuest = "ChocQuest1"
            NameMon = "Chocolate Bar Battler"
            CFrameQuest = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438)
            CFrameMon = CFrame.new(582.59057617188, 77.188095092773, -12463.162109375)
        elseif MyLevel >= 2350 and MyLevel <= 2374 then
            Mon = "Sweet Thief"
            LevelQuest = 1
            NameQuest = "ChocQuest2"
            NameMon = "Sweet Thief"
            CFrameQuest = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688)
            CFrameMon = CFrame.new(165.1884765625, 76.058853149414, -12600.836914062)
        elseif MyLevel >= 2375 and MyLevel <= 2399 then
            Mon = "Candy Rebel"
            LevelQuest = 2
            NameQuest = "ChocQuest2"
            NameMon = "Candy Rebel"
            CFrameQuest = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688)
            CFrameMon = CFrame.new(134.86563110352, 77.247680664062, -12876.547851562)
        elseif MyLevel >= 2400 and MyLevel <= 2424 then
            Mon = "Candy Pirate"
            LevelQuest = 1
            NameQuest = "CandyQuest1"
            NameMon = "Candy Pirate"
            CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229, -14446.334960938)
            CFrameMon = CFrame.new(-1310.5003662109, 26.016523361206, -14562.404296875)
        elseif MyLevel >= 2425 and MyLevel <= 2449 then
            Mon = "Snow Demon"
            LevelQuest = 2
            NameQuest = "CandyQuest1"
            NameMon = "Snow Demon"
            CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229, -14446.334960938)
            CFrameMon = CFrame.new(-880.20062255859, 71.247764587402, -14538.609375)
        elseif MyLevel >= 2450 and MyLevel <= 2474 then
            Mon = "Isle Outlaw"
            LevelQuest = 1
            NameQuest = "TikiQuest1"
            NameMon = "Isle Outlaw"
            CFrameQuest = CFrame.new(-16547.748046875, 61.135334014893, -173.41360473633)
            CFrameMon = CFrame.new(-16442.814453125, 116.13899993896, -264.46377563477)
        elseif MyLevel >= 2475 and MyLevel <= 2524 then
            Mon = "Island Boy"
            LevelQuest = 2
            NameQuest = "TikiQuest1"
            NameMon = "Island Boy"
            CFrameQuest = CFrame.new(-16547.748046875, 61.135334014893, -173.41360473633)
            CFrameMon = CFrame.new(-16901.26171875, 84.067565917969, -192.88906860352)
        elseif MyLevel >= 2525 and MyLevel <= 2550 then
            Mon = "Isle Champion"
            LevelQuest = 2
            NameQuest = "TikiQuest2"
            NameMon = "Isle Champion"
            CFrameQuest = CFrame.new(-16539.078125, 55.686328887939, 1051.5738525391)
            CFrameMon = CFrame.new(-16641.6796875, 235.78254699707, 1031.2829589844)
        elseif MyLevel >= 2550 and MyLevel <= 2574 then
            Mon = "Serpent Hunter"
            LevelQuest = 1
            NameQuest = "TikiQuest3"
            NameMon = "Serpent Hunter"
            CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, .951068401, 0, -0.308980465, 0, 1, 0, .308980465, 0, .951068401)
            CFrameMon = CFrame.new(-16521.0625, 106.09285, 1488.78467, .469467044, 0, .882950008, 0, 1, 0, -0.882950008, 0, .469467044)
        elseif MyLevel >= 2575 and MyLevel <= 2599 then
            Mon = "Skull Slayer"
            LevelQuest = 2
            NameQuest = "TikiQuest3"
            NameMon = "Skull Slayer"
            CFrameQuest = CFrame.new(-16665.1914, 104.596405, 1579.69434, .951068401, 0, -0.308980465, 0, 1, 0, .308980465, 0, .951068401)
            CFrameMon = CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, 0, -0.0348687991, 0, 1, 0, .0348687991, 0, -0.999392271)
        elseif MyLevel >= 2600 and MyLevel <= 2624 then
            Mon = "Reef Bandit"
            LevelQuest = 1
            NameQuest = "SubmergedQuest1"
            NameMon = "Reef Bandit"
            CFrameMon = CFrame.new(10943.0811, -2083.03516, 9177.33691, -0.998713255, -0.0461204648, .021090759, -0.0451571345, .998007238, .0440727882, -0.0230813865, .0430636741, -0.998805642)
            CFrameQuest = CFrame.new(10780.107421875, -2087.7214355469, 9261.865234375)
        elseif MyLevel >= 2625 and MyLevel <= 2649 then
            Mon = "Coral Pirate"
            LevelQuest = 2
            NameQuest = "SubmergedQuest1"
            NameMon = "Coral Pirate"
            CFrameQuest = CFrame.new(10780.107421875, -2087.7214355469, 9261.865234375)
            CFrameMon = CFrame.new(10713.4473, -2093.04517, 9307.14844, .325602472, 7.02769976e-05, .945506752, -7.02769976e-05, 1, -5.01261711e-05, -0.945506752, -5.01261711e-05, .325602472)
        elseif MyLevel >= 2650 and MyLevel <= 2674 then
            Mon = "Sea Chanter"
            LevelQuest = 1
            NameQuest = "SubmergedQuest2"
            NameMon = "Sea Chanter"
            CFrameQuest = CFrame.new(10883.587890625, -2086.1970214844, 10032.196289062)
            CFrameMon = CFrame.new(10647.606445312, -2077.6257324219, 10079.962890625)
        elseif MyLevel >= 2675 and MyLevel <= 2699 then
            Mon = "High Disciple"
            LevelQuest = 1
            NameQuest = "SubmergedQuest3"
            NameMon = "High Disciple"
            CFrameQuest = CFrame.new(9635.8701171875, -1992.4481201172, 9614.3935546875)
            CFrameMon = CFrame.new(9843.578125, -1993.4559326172, 9696.48046875)
        elseif MyLevel >= 2700 then
            Mon = "Grand Devotee"
            LevelQuest = 2
            NameQuest = "SubmergedQuest3"
            NameMon = "Grand Devotee"
            CFrameQuest = CFrame.new(9635.8701171875, -1992.4481201172, 9614.3935546875)
            CFrameMon = CFrame.new(9591.0546875, -1993.4742431641, 9808.705078125)
        end
    end
end

-- Farm Tab
Tabs.Farm:Section({ Title = "Farm" })
Tabs.Farm:Toggle({ Title = "Auto Farm Level", Default = false, Callback = function(v) _G.Level = v end })
Tabs.Farm:Toggle({ Title = "Auto Travel Dressrosa", Default = false, Callback = function(v) _G.TravelDres = v end })
Tabs.Farm:Toggle({ Title = "Auto Zou Quest", Default = false, Callback = function(v) _G.AutoZou = v end })

Tabs.Farm:Section({ Title = "Miscellanea / Quest" })
Tabs.Farm:Toggle({ Title = "Auto Farm Nearest", Default = false, Callback = function(v) _G.AutoFarmNear = v end })
Tabs.Farm:Toggle({ Title = "Auto Factory Raid", Default = false, Callback = function(v) _G.AutoFactory = v end })
Tabs.Farm:Toggle({ Title = "Auto Pirate Raid", Default = false, Callback = function(v) _G.AutoRaidCastle = v end })
Tabs.Farm:Dropdown({ Title = "Choose Material", Values = v, Value = v[1], Callback = function(val) (getgenv()).SelectMaterial = val end })
Tabs.Farm:Toggle({ Title = "Auto Materials", Default = false, Callback = function(v) (getgenv()).AutoMaterial = v end })
Tabs.Farm:Toggle({ Title = "Auto Farm Ectoplasm", Default = false, Callback = function(v) _G.AutoEctoplasm = v end })
Tabs.Farm:Toggle({ Title = "Auto Done Bartilo Quest", Default = false, Callback = function(v) _G.Bartilo_Quest = v end })
Tabs.Farm:Toggle({ Title = "Auto Done Citizen Quest", Default = false, Callback = function(v) _G.CitizenQuest = v end })
Tabs.Farm:Toggle({ Title = "Auto Training Dummy", Default = false, Callback = function(v) _G.DummyMan = v end })
Tabs.Farm:Toggle({ Title = "Auto Collect Berry", Default = false, Callback = function(v) _G.AutoBerry = v end })
Tabs.Farm:Toggle({ Title = "Auto Collect Chest", Default = false, Callback = function(v) _G.AutoFarmChest = v end })

Tabs.Farm:Section({ Title = "Miscellanea / Fishing" })
Tabs.Farm:Dropdown({ Title = "Select Fishing Rod", Values = { "Fishing Rod", "Gold Rod", "Shark Rod", "Shell Rod", "Treasure Rod" }, Value = "Fishing Rod", Callback = function(v) _G.SelectedRod = v end })
Tabs.Farm:Dropdown({ Title = "Select Bait", Values = { "Basic Bait", "Kelp Bait", "Good Bait", "Abyssal Bait", "Frozen Bait", "Epic Bait", "Carnivore Bait" }, Value = "Basic Bait", Callback = function(v) _G.SelectedBait = v end })
Tabs.Farm:Toggle({ Title = "Auto Fishing", Default = false, Callback = function(v) _G.AutoFishing = v end })

Tabs.Farm:Section({ Title = "Miscellanea / Mastery" })
Tabs.Farm:Dropdown({ Title = "Choose Island", Values = { "Cake", "Bone" }, Value = "Cake", Callback = function(v) SelectIsland = v end })
Tabs.Farm:Toggle({ Title = "Auto Mastery Fruits", Default = false, Callback = function(v) _G.FarmMastery_Dev = v end })
Tabs.Farm:Toggle({ Title = "Auto Mastery Gun", Default = false, Callback = function(v) _G.FarmMastery_G = v end })
Tabs.Farm:Toggle({ Title = "Auto Mastery All Sword", Default = false, Callback = function(v) _G.FarmMastery_S = v end })

Tabs.Farm:Section({ Title = "Generals Quests / Items" })
Tabs.Farm:Toggle({ Title = "Auto Cake Prince", Default = false, Callback = function(v) _G.Auto_Cake_Prince = v end })
Tabs.Farm:Toggle({ Title = "Auto Bones", Default = false, Callback = function(v) _G.AutoFarm_Bone = v end })
Tabs.Farm:Toggle({ Title = "Accept Quests", Default = false, Callback = function(v) _G.AcceptQuestC = v end })
Tabs.Farm:Toggle({ Title = "Auto Farm Mirror", Default = false, Callback = function(v) _G.AutoMiror = v end })
Tabs.Farm:Toggle({ Title = "Auto Soul Reaper [Fully]", Default = false, Callback = function(v) _G.AutoHytHallow = v end })
Tabs.Farm:Toggle({ Title = "Auto Random Bones", Default = false, Callback = function(v) _G.Auto_Random_Bone = v end })
Tabs.Farm:Toggle({ Title = "Auto Try Luck Gravestone", Default = false, Callback = function(v) _G.TryLucky = v end })
Tabs.Farm:Toggle({ Title = "Auto Pray Gravestone", Default = false, Callback = function(v) _G.Praying = v end })

Tabs.Farm:Section({ Title = "Unlocked Dungeon" })
Tabs.Farm:Toggle({ Title = "Auto Unlock Dough Dungeon", Default = false, Callback = function(v) _G.Doughv2 = v end })
Tabs.Farm:Toggle({ Title = "Auto Unlock Phoenix Dungeon", Default = false, Callback = function(v) _G.AutoPhoenixF = v end })

Tabs.Farm:Section({ Title = "Buso/Aura Colours" })
Tabs.Farm:Toggle({ Title = "Auto Teleport Barista Cousin", Default = false, Callback = function(v) _G.Tp_MasterA = v end })
Tabs.Farm:Button({ Title = "Buy Buso Colors", Callback = function() Q.Remotes.CommF_:InvokeServer("ColorsDealer", "2") end })
Tabs.Farm:Toggle({ Title = "Auto Rainbow Colors", Default = false, Callback = function(v) _G.Auto_Rainbow_Haki = v end })
Tabs.Farm:Toggle({ Title = "Accept Rainbow Quest Faster", Default = false, Callback = function(v) _G.GetQFast = v end })

Tabs.Farm:Section({ Title = "Instinct / Observation" })
Tabs.Farm:Toggle({ Title = "Auto Farm Observation", Default = false, Callback = function(v) _G.obsFarm = v end })
Tabs.Farm:Toggle({ Title = "Auto Observation V2", Default = false, Callback = function(v) _G.AutoKenVTWO = v end })

Tabs.Farm:Section({ Title = "Upgrade Races V3" })
Tabs.Farm:Toggle({ Title = "Auto Upgrade Mink V3", Default = false, Callback = function(v) _G.Auto_Mink = v end })
Tabs.Farm:Toggle({ Title = "Auto Upgrade Human V3", Default = false, Callback = function(v) _G.Auto_Human = v end })
Tabs.Farm:Toggle({ Title = "Auto Upgrade Skypiea V3", Default = false, Callback = function(v) _G.Auto_Skypiea = v end })
Tabs.Farm:Toggle({ Title = "Auto Upgrade FishMan V3", Default = false, Callback = function(v) _G.Auto_Fish = v end })


Tabs.Config:Section({ Title = "Settings / Configure" })
Tabs.Config:Dropdown({ Title = "Select Weapon", Values = { "Melee", "Sword", "Blox Fruit", "Gun" }, Value = "Melee", Callback = function(v) _G.ChooseWP = v end })
Tabs.Config:Toggle({ Title = "Initialize Attack [M1/Melee/Sword]", Default = true, Callback = function(v) _G.Seriality = v end })
Tabs.Config:Toggle({ Title = "Bring Mobs", Default = true, Callback = function(v) _B = v end })
Tabs.Config:Toggle({ Title = "Auto Turn on Buso", Default = true, Callback = function(v) Boud = v end })
Tabs.Config:Toggle({ Title = "Auto Turn on Race V3", Default = false, Callback = function(v) _G.RaceClickAutov3 = v end })
Tabs.Config:Toggle({ Title = "Auto Turn on Race V4", Default = false, Callback = function(v) _G.RaceClickAutov4 = v end })
Tabs.Config:Toggle({ Title = "Auto Turn on Spin Position", Default = false, Callback = function(v) RandomCFrame = v end })
Tabs.Config:Toggle({ Title = "Turn on Bypass Teleport", Default = false, Callback = function(v) _G.Bypass = v end })
Tabs.Config:Toggle({ Title = "Panic Mode", Default = false, Callback = function(v) _G.Safemode = v end })
Tabs.Config:Toggle({ Title = "Anti AFK", Default = true, Callback = function(v) _G.AntiAFK = v end })
Tabs.Config:Toggle({ Title = "Remove Hit VFX", Default = false, Callback = function(v) _G.DistroyHit = v end })
Tabs.Config:Toggle({ Title = "Remove Death & Respawned VFX", Default = false, Callback = function(v) RDeath = v end })
Tabs.Config:Toggle({ Title = "Disable Notify", Default = false, Callback = function(v) RemoveDamage = v end })

Tabs.Config:Section({ Title = "Stats Upgrade" })
local pSats = 10
Tabs.Config:Slider({ Title = "Stats Value", Value = { Min = 0, Max = 1000, Default = 10 }, Callback = function(v) pSats = v end })
Tabs.Config:Toggle({ Title = "Auto Melee", Default = false, Callback = function(v) _G.Auto_Melee = v end })
Tabs.Config:Toggle({ Title = "Auto Swords", Default = false, Callback = function(v) _G.Auto_Sword = v end })
Tabs.Config:Toggle({ Title = "Auto Gun", Default = false, Callback = function(v) _G.Auto_Gun = v end })
Tabs.Config:Toggle({ Title = "Auto Blox Fruit", Default = false, Callback = function(v) _G.Auto_Blox = v end })
Tabs.Config:Toggle({ Title = "Auto Defense", Default = false, Callback = function(v) _G.Auto_Defense = v end })


Tabs.Fighting:Section({ Title = "Fighting Melee Styles" })
Tabs.Fighting:Toggle({ Title = "Auto Superhuman", Default = false, Callback = function(v) _G.Auto_SuperHuman = v end })
Tabs.Fighting:Toggle({ Title = "Auto DeathStep", Default = false, Callback = function(v) _G.AutoDeathStep = v end })
Tabs.Fighting:Toggle({ Title = "Auto Sharkman Karate", Default = false, Callback = function(v) _G.Auto_SharkMan_Karate = v end })
Tabs.Fighting:Toggle({ Title = "Auto ElectricClaw", Default = false, Callback = function(v) _G.Auto_Electric_Claw = v end })
Tabs.Fighting:Toggle({ Title = "Auto DragonTalon", Default = false, Callback = function(v) _G.AutoDragonTalon = v end })
Tabs.Fighting:Toggle({ Title = "Auto Godhuman", Default = false, Callback = function(v) _G.Auto_God_Human = v end })
Tabs.Fighting:Toggle({ Title = "Auto SanguineArt", Default = false, Callback = function(v) _G.snaguine = v end })


Tabs.Items:Section({ Title = "Tushita + Yama" })
Tabs.Items:Toggle({ Title = "Auto Elite Quest", Default = false, Callback = function(v) _G.FarmEliteHunt = v end })
Tabs.Items:Toggle({ Title = "Stop when got God's Chalice", Default = true, Callback = function(v) _G.StopWhenChalice = v end })
Tabs.Items:Toggle({ Title = "Auto Tushita Sword", Default = false, Callback = function(v) _G.Auto_Tushita = v end })
Tabs.Items:Toggle({ Title = "Auto Yama Sword", Default = false, Callback = function(v) _G.Auto_Yama = v end })

Tabs.Items:Section({ Title = "Cursed Dual Katana" })
Tabs.Items:Toggle({ Title = "Auto Get CDK [ Last Quest ]", Default = false, Callback = function(v) _G.CDK = v end })
Tabs.Items:Toggle({ Title = "Auto Yama CDK", Default = false, Callback = function(v) _G.CDK_YM = v end })
Tabs.Items:Toggle({ Title = "Auto Tushita CDK", Default = false, Callback = function(v) _G.CDK_TS = v end })

Tabs.Items:Section({ Title = "True Triple Katana Sword" })
Tabs.Items:Button({ Title = "Buy Legendary Sword", Callback = function() Q.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1"); Q.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2"); Q.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") end })
Tabs.Items:Button({ Title = "Buy True Triple Katana Sword", Callback = function() Q.Remotes.CommF_:InvokeServer("MysteriousMan", "2") end })
Tabs.Items:Toggle({ Title = "Tween to Legendary Sword Dealer", Default = false, Callback = function(v) _G.Tp_LgS = v end })

Tabs.Items:Section({ Title = "Pole / God Enal's" })
Tabs.Items:Toggle({ Title = "Auto Pole V1", Default = false, Callback = function(v) _G.AutoPole = v end })
Tabs.Items:Toggle({ Title = "Auto Pole V2 [Beta]", Default = false, Callback = function(v) _G.AutoPoleV2 = v end })

Tabs.Items:Section({ Title = "Items Law/Order Sword" })
Tabs.Items:Toggle({ Title = "Auto Law Sword", Default = false, Callback = function(v) _G.AutoLawKak = v end })
Tabs.Items:Button({ Title = "Buy Microchip Law", Callback = function() Q.Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2") end })
Tabs.Items:Button({ Title = "Start Law Raids", Callback = function() fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector) end })

Tabs.Items:Section({ Title = "East Blue Misc" })
Tabs.Items:Toggle({ Title = "Auto Saw Sword", Default = false, Callback = function(v) _G.AutoSaw = v end })
Tabs.Items:Toggle({ Title = "Auto Saber Sword", Default = false, Callback = function(v) _G.AutoSaber = v end })
Tabs.Items:Toggle({ Title = "Auto Cybrog", Default = false, Callback = function(v) _G.AutoColShad = v end })
Tabs.Items:Toggle({ Title = "Auto Usoap's Hat", Default = false, Callback = function(v) _G.AutoGetUsoap = v end })
Tabs.Items:Toggle({ Title = "Auto Bisento V2", Default = false, Callback = function(v) _G.Greybeard = v end })
Tabs.Items:Toggle({ Title = "Auto Warden Sword", Default = false, Callback = function(v) _G.WardenBoss = v end })
Tabs.Items:Toggle({ Title = "Auto Marine Coat", Default = false, Callback = function(v) _G.MarinesCoat = v end })
Tabs.Items:Toggle({ Title = "Auto Swan Coat", Default = false, Callback = function(v) _G.SwanCoat = v end })

Tabs.Items:Section({ Title = "Rengoku Sword" })
Tabs.Items:Toggle({ Title = "Auto Rengoku Sword", Default = false, Callback = function(v) _G.IceBossRen = v end })
Tabs.Items:Toggle({ Title = "Auto Key Rengoku", Default = false, Callback = function(v) _G.KeysRen = v end })
Tabs.Items:Toggle({ Title = "Auto Dragon Trident", Default = false, Callback = function(v) _G.AutoTridentW2 = v end })
Tabs.Items:Toggle({ Title = "Auto Long Sword", Default = false, Callback = function(v) _G.LongsWord = v end })
Tabs.Items:Toggle({ Title = "Auto Black Spikey", Default = false, Callback = function(v) _G.BlackSpikey = v end })
Tabs.Items:Toggle({ Title = "Auto Dark Blade V3", Default = false, Callback = function(v) _G.DarkBladev3 = v end })
Tabs.Items:Toggle({ Title = "Auto Midnight Blade", Default = false, Callback = function(v) _G.AutoEcBoss = v end })
Tabs.Items:Toggle({ Title = "Auto Darkbeard", Default = false, Callback = function(v) _G.Auto_Def_DarkCoat = v end })
Tabs.Items:Toggle({ Title = "Auto Unlocked DonSwan", Default = false, Callback = function(v) _G.Auto_DonAcces = v end })
Tabs.Items:Toggle({ Title = "Auto Swan Glasses", Default = false, Callback = function(v) _G.Auto_SwanGG = v end })

Tabs.Items:Section({ Title = "Cavender + Twin Hooks + Bigmom" })
Tabs.Items:Toggle({ Title = "Auto Bigmom", Default = false, Callback = function(v) _G.AutoBigmom = v end })
Tabs.Items:Toggle({ Title = "Auto Canvendish Sword", Default = false, Callback = function(v) _G.Auto_Cavender = v end })
Tabs.Items:Toggle({ Title = "Auto Twin Hooks", Default = false, Callback = function(v) _G.TwinHook = v end })
Tabs.Items:Toggle({ Title = "Auto Serpent Bow", Default = false, Callback = function(v) _G.AutoSerpentBow = v end })
Tabs.Items:Toggle({ Title = "Auto Lei Accessory", Default = false, Callback = function(v) _G.AutoKilo = v end })


Tabs.SeaEvents:Section({ Title = "Sea Event / Setting Sail" })
Tabs.SeaEvents:Button({ Title = "Buy Fracments with Spy", Callback = function() ((Q:WaitForChild("Remotes")):WaitForChild("CommF_")):InvokeServer("InfoLeviathan", "2") end })
Tabs.SeaEvents:Toggle({ Title = "Auto Teleport Frozen Dimension", Default = false, Callback = function(v) _G.FrozenTP = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Drive To Hydra Island", Default = false, Callback = function(v) _G.SailBoat_Hydra = v end })
Tabs.SeaEvents:Dropdown({ Title = "Choose Boats", Values = { "Guardian", "PirateGrandBrigade", "MarineGrandBrigade", "PirateBrigade", "MarineBrigade", "PirateSloop", "MarineSloop", "Beast Hunter" }, Value = "Guardian", Callback = function(v) _G.SelectedBoat = v end })
Tabs.SeaEvents:Button({ Title = "Buy Boats", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end })
Tabs.SeaEvents:Dropdown({ Title = "Choose Sea Level", Values = { "Lv 1", "Lv 2", "Lv 3", "Lv 4", "Lv 5", "Lv 6", "Lv Infinite" }, Value = "Lv 1", Callback = function(v) _G.DangerSc = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Sail Boat", Default = false, Callback = function(v) _G.SailBoats = v end })

Tabs.SeaEvents:Section({ Title = "Entity Sea Event" })
Tabs.SeaEvents:Toggle({ Title = "Auto Shark", Default = false, Callback = function(v) _G.Shark = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Piranha", Default = false, Callback = function(v) _G.Piranha = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Terror Shark", Default = false, Callback = function(v) _G.TerrorShark = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Fish Crew Member", Default = false, Callback = function(v) _G.MobCrew = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Haunted Crew Member", Default = false, Callback = function(v) _G.HCM = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Attack PirateGrandBrigade", Default = false, Callback = function(v) _G.PGB = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Attack Fish Boat", Default = false, Callback = function(v) _G.FishBoat = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Attack Sea Beast", Default = false, Callback = function(v) _G.SeaBeast1 = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Attack Leviathan", Default = false, Callback = function(v) _G.Leviathan1 = v end })

Tabs.SeaEvents:Section({ Title = "Kitsune Island / Event" })
Tabs.SeaEvents:Toggle({ Title = "Auto Find Kitsune Island", Default = false, Callback = function(v) _G.AutofindKitIs = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Teleport to Shrine Actived", Default = false, Callback = function(v) _G.tweenShrine = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Collect Azure Ember", Default = false, Callback = function(v) _G.Collect_Ember = v end })
Tabs.SeaEvents:Toggle({ Title = "Auto Trade Azure Ember", Default = false, Callback = function(v) _G.Trade_Ember = v end })
Tabs.SeaEvents:Button({ Title = "Trade Items Azure", Callback = function() (Q.Modules.Net:FindFirstChild("RF/KitsuneStatuePray")):InvokeServer() end })
Tabs.SeaEvents:Button({ Title = "Talk with kitsune statue", Callback = function() (Q.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue")):FireServer() end })


Tabs.Mirage:Section({ Title = "Mystic Island / Full Moon" })
Tabs.Mirage:Toggle({ Title = "Auto Find Mirage Island", Default = false, Callback = function(v) _G.FindMirage = v end })
Tabs.Mirage:Toggle({ Title = "Auto Tween To Highest Point", Default = false, Callback = function(v) _G.HighestMirage = v end })
Tabs.Mirage:Toggle({ Title = "Auto Collect Gear", Default = false, Callback = function(v) _G.TPGEAR = v end })
Tabs.Mirage:Toggle({ Title = "Change Transparency can see", Default = false, Callback = function(v) _G.can = v end })
Tabs.Mirage:Toggle({ Title = "Auto Tween Advanced Fruit Dealer", Default = false, Callback = function(v) _G.Addealer = v end })
Tabs.Mirage:Toggle({ Title = "Auto Collect Mirage Chest", Default = false, Callback = function(v) _G.FarmChestM = v end })

Tabs.Mirage:Section({ Title = "Skull Guitars / Misc" })
Tabs.Mirage:Toggle({ Title = "Auto Skull Guitar", Default = false, Callback = function(v) _G.Auto_Soul_Guitar = v end })
Tabs.Mirage:Toggle({ Title = "Auto Farm Material Skull Guitar", Default = false, Callback = function(v) _G.AutoMatSoul = v end })
Tabs.Mirage:Button({ Title = "Talk With Stone", Callback = function() ((Q:WaitForChild("Remotes")):WaitForChild("CommF_")):InvokeServer("RaceV4Progress", "Begin"); ((Q:WaitForChild("Remotes")):WaitForChild("CommF_")):InvokeServer("RaceV4Progress", "Check"); ((Q:WaitForChild("Remotes")):WaitForChild("CommF_")):InvokeServer("RaceV4Progress", "Teleport"); ((Q:WaitForChild("Remotes")):WaitForChild("CommF_")):InvokeServer("RaceV4Progress", "Continue") end })
Tabs.Mirage:Toggle({ Title = "Auto Look At Moon", Default = false, Callback = function(v) LookM = v end })

Tabs.Mirage:Section({ Title = "Trials Quests / Misc V4" })
Tabs.Mirage:Toggle({ Title = "Auto Pull Lever", Default = false, Callback = function(v) _G.Lver = v end })
Tabs.Mirage:Toggle({ Title = "Auto Train V4", Default = false, Callback = function(v) _G.AcientOne = v end })
Tabs.Mirage:Button({ Title = "Teleport to Temple of Time", Callback = function() TpTemple() end })
Tabs.Mirage:Button({ Title = "Teleport to Ancient One", Callback = function() TpTemple(); notween(CFrame.new(28981.552734375, 14888.426757812, -120.24584960938)) end })
Tabs.Mirage:Button({ Title = "Teleport to Ancient Clock", Callback = function() TpTemple(); notween(CFrame.new(29549, 15069, -88)) end })
Tabs.Mirage:Toggle({ Title = "Auto Teleport to Race Doors", Default = false, Callback = function(v) _G.TPDoor = v end })
Tabs.Mirage:Toggle({ Title = "Auto Complete Trial Race", Default = false, Callback = function(v) _G.Complete_Trials = v end })
Tabs.Mirage:Toggle({ Title = "Auto Kill Player After Trial", Default = false, Callback = function(v) _G.Defeating = v end })


Tabs.Drago:Section({ Title = "Dojo Quest & Drago Race" })
Tabs.Drago:Toggle({ Title = "Auto Dojo Trainer", Default = false, Callback = function(v) _G.Dojoo = v end })
Tabs.Drago:Toggle({ Title = "Auto Dragon Hunter", Default = false, Callback = function(v) _G.FarmBlazeEM = v end })

Tabs.Drago:Section({ Title = "Drago Trial" })
Tabs.Drago:Toggle({ Title = "Tween To Upgrade Droco Trial", Default = false, Callback = function(v) _G.UPGDrago = v end })
Tabs.Drago:Toggle({ Title = "Auto Drago (V1)", Default = false, Callback = function(v) _G.DragoV1 = v end })
Tabs.Drago:Toggle({ Title = "Auto Drago (V2)", Default = false, Callback = function(v) _G.AutoFireFlowers = v end })
Tabs.Drago:Toggle({ Title = "Auto Drago (V3)", Default = false, Callback = function(v) _G.DragoV3 = v end })
Tabs.Drago:Toggle({ Title = "Auto Relic Drago Trial [Beta]", Default = false, Callback = function(v) _G.Relic123 = v end })
Tabs.Drago:Toggle({ Title = "Auto Train Drago v4", Default = false, Callback = function(v) _G.TrainDrago = v end })
Tabs.Drago:Toggle({ Title = "Tween to Drago Trials", Default = false, Callback = function(v) _G.TpDrago_Prehis = v end })
Tabs.Drago:Toggle({ Title = "Swap Drago Race", Default = false, Callback = function(v) _G.BuyDrago = v end })
Tabs.Drago:Toggle({ Title = "Upgrade Dragon Talon With Uzoth", Default = false, Callback = function(v) _G.DT_Uzoth = v end })


Tabs.Prehistoric:Section({ Title = "Volcanic Magnet" })
Tabs.Prehistoric:Toggle({ Title = "Auto Craft Volcanic Magnet", Default = false, Callback = function(v) _G.CraftVM = v end })
Tabs.Prehistoric:Button({ Title = "Craft Volcanic Magnet", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Volcanic Magnet") end })

Tabs.Prehistoric:Section({ Title = "Prehistoric Island" })
Tabs.Prehistoric:Toggle({ Title = "Auto Find Prehistoric Island", Default = false, Callback = function(v) _G.Prehis_Find = v end })
Tabs.Prehistoric:Toggle({ Title = "Auto Patch Prehistoric Event", Default = false, Callback = function(v) _G.Prehis_Skills = v end })
Tabs.Prehistoric:Toggle({ Title = "Auto Collect Dino Bones", Default = false, Callback = function(v) _G.Prehis_DB = v end })
Tabs.Prehistoric:Toggle({ Title = "Auto Collect Dragon Eggs", Default = false, Callback = function(v) _G.Prehis_DE = v end })
Tabs.Prehistoric:Toggle({ Title = "Auto Reset When Complete Volcano", Default = false, Callback = function(v) _G.ResetPH = v end })


Tabs.Raid:Section({ Title = "Dungeon Event / Raiding" })
Tabs.Raid:Dropdown({ Title = "Select Chip", Values = j, Value = "Flame", Callback = function(v) _G.SelectChip = v end })
Tabs.Raid:Toggle({ Title = "Auto Select Dungeon Chip", Default = false, Callback = function(v) _G.AutoSelectDungeon = v end })
Tabs.Raid:Button({ Title = "Buy Dungeon Chips [Beli]", Callback = function() if not GetBP("Special Microchip") then Q.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip) end end })
Tabs.Raid:Button({ Title = "Buy Dungeon Chips [Devil Fruit]", Callback = function() if GetBP("Special Microchip") then return end; local Y = {}; for d, R in next, (Q:WaitForChild("Remotes")).CommF_:InvokeServer("GetFruits") do if R.Price <= 490000 then table.insert(Y, R.Name) end end; for Y, d in pairs(Y) do for Y, R in pairs(j) do if not GetBP("Special Microchip") then Q.Remotes.CommF_:InvokeServer("LoadFruit", tostring(d)); Q.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip) end end end end })

Tabs.Raid:Section({ Title = "Raiding Menu" })
Tabs.Raid:Toggle({ Title = "Auto Start Raid", Default = false, Callback = function(v) _G.Auto_StartRaid = v end })
Tabs.Raid:Toggle({ Title = "Teleport To Lab", Default = false, Callback = function(v) _G.TpLab = v end })
Tabs.Raid:Toggle({ Title = "Auto Complete Raid [Safety]", Default = false, Callback = function(v) _G.Raiding = v end })
Tabs.Raid:Toggle({ Title = "Kill Aura", Default = false, Callback = function(v) _G.KillH = v end })
Tabs.Raid:Toggle({ Title = "Auto Next Island", Default = false, Callback = function(v) NextIs = v end })
Tabs.Raid:Toggle({ Title = "Auto Awakening", Default = false, Callback = function(v) _G.Auto_Awakener = v end })


Tabs.PVP:Section({ Title = "Combat / Aimbot" })
local playersList = {}
for _, p in pairs(game:GetService("Players"):GetChildren()) do table.insert(playersList, p.Name) end
Tabs.PVP:Dropdown({ Title = "Choose Players", Values = playersList, Value = playersList[1], Callback = function(v) _G.PlayersList = v end })
Tabs.PVP:Toggle({ Title = "Teleport to choose players", Default = false, Callback = function(v) _G.TpPly = v end })
Tabs.PVP:Toggle({ Title = "Spectate Choose Players", Default = false, Callback = function(v) SpectatePlys = v end })
Tabs.PVP:Dropdown({ Title = "Choose Aim Method", Values = { "AimBots Skill", "Auto Aimbots" }, Value = "AimBots Skill", Callback = function(v) ABmethod = v end })
Tabs.PVP:Toggle({ Title = "Aimbot Method Skills", Default = false, Callback = function(v) _G.AimMethod = v end })
Tabs.PVP:Toggle({ Title = "Aimbot Camera Closet Players", Default = false, Callback = function(v) _G.AimCam = v end })

Tabs.PVP:Section({ Title = "LocalPlayer Settings / Misc" })
Tabs.PVP:Toggle({ Title = "Instance Mink V3 [ INF ]", Default = false, Callback = function(v) InfAblities = v end })
Tabs.PVP:Toggle({ Title = "Instance Energy [ INF ]", Default = false, Callback = function(v) infEnergy = v if v then getInfinity_Ability("Energy", infEnergy) end end })
Tabs.PVP:Toggle({ Title = "Instance Soru [ INF ]", Default = false, Callback = function(v) _G.InfSoru = v if v then getInfinity_Ability("Soru", _G.InfSoru) end end })
Tabs.PVP:Toggle({ Title = "Instance Observation Range [ INF ]", Default = false, Callback = function(v) _G.InfiniteObRange = v if v then getInfinity_Ability("Observation", _G.InfiniteObRange) end end })

Tabs.PVP:Section({ Title = "Settings Combat / Aimbot Settings" })
Tabs.PVP:Toggle({ Title = "Ignore Same Teams", Default = false, Callback = function(v) _G.NoAimTeam = v end })
Tabs.PVP:Toggle({ Title = "Accept Allies", Default = false, Callback = function(v) _G.AcceptAlly = v end })

Tabs.PVP:Section({ Title = "Esp Items / Entity / Island" })
Tabs.PVP:Toggle({ Title = "Esp Berries", Default = false, Callback = function(v) BerryEsp = v end })
Tabs.PVP:Toggle({ Title = "Esp Players", Default = false, Callback = function(v) PlayerEsp = v end })
Tabs.PVP:Toggle({ Title = "Esp Chests", Default = false, Callback = function(v) ChestESP = v end })
Tabs.PVP:Toggle({ Title = "Esp Fruits", Default = false, Callback = function(v) DevilFruitESP = v end })
Tabs.PVP:Toggle({ Title = "Esp Island Location", Default = false, Callback = function(v) IslandESP = v end })
if World2 then
    Tabs.PVP:Toggle({ Title = "Esp Flower", Default = false, Callback = function(v) FlowerESP = v end })
    Tabs.PVP:Toggle({ Title = "Esp Legendary Sword", Default = false, Callback = function(v) LegenS = v end })
end
if World2 or World3 then
    Tabs.PVP:Toggle({ Title = "Esp Aura Colour Dealers", Default = false, Callback = function(v) ColorEsp = v end })
end
if World3 then
    Tabs.PVP:Toggle({ Title = "Esp Gears", Default = false, Callback = function(v) ESPGear = v end })
    Tabs.PVP:Toggle({ Title = "Esp SeaEvent Island", Default = false, Callback = function(v) EspEventIsland = v end })
    Tabs.PVP:Toggle({ Title = "Esp Advanced Fruits Dealer", Default = false, Callback = function(v) advanEsp = v end })
end


Tabs.Teleport:Section({ Title = "Travel - Worlds" })
Tabs.Teleport:Button({ Title = "Travel East Blue (World 1)", Callback = function() Q.Remotes.CommF_:InvokeServer("TravelMain") end })
Tabs.Teleport:Button({ Title = "Travel Dressrosa (World 2)", Callback = function() Q.Remotes.CommF_:InvokeServer("TravelDressrosa") end })
Tabs.Teleport:Button({ Title = "Travel Zou (World 3)", Callback = function() Q.Remotes.CommF_:InvokeServer("TravelZou") end })

Tabs.Teleport:Section({ Title = "Travel - Island" })
local locs = {}
for _, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do table.insert(locs, v.Name) end
Tabs.Teleport:Dropdown({ Title = "Select Travelling", Values = locs, Value = locs[1], Callback = function(v) _G.Island = v end })
Tabs.Teleport:Toggle({ Title = "Auto Travel", Default = false, Callback = function(v) _G.Teleport = v end })

Tabs.Teleport:Section({ Title = "Travel - Portal" })
local portals = {}
if World1 then portals = { "Sky", "UnderWater" } elseif World2 then portals = { "SwanRoom", "Cursed Ship" } else portals = { "Castle On The Sea", "Mansion Cafe", "Hydra Teleport", "Canvendish Room", "Temple of Time" } end
Tabs.Teleport:Dropdown({ Title = "Select Portal", Values = portals, Value = portals[1], Callback = function(v) _G.Island_PT = v end })
Tabs.Teleport:Button({ Title = "requestEntrance", Callback = function() if _G.Island_PT == "Sky" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894, 5547, -380)) elseif _G.Island_PT == "UnderWater" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163, 11, 1819)) elseif _G.Island_PT == "SwanRoom" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(2285, 15, 905)) elseif _G.Island_PT == "Cursed Ship" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923, 126, 32852)) elseif _G.Island_PT == "Castle On The Sea" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, .914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899)) elseif _G.Island_PT == "Mansion Cafe" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)) elseif _G.Island_PT == "Hydra Teleport" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5643.4526367188, 1013.0858154297, -340.51025390625)) elseif _G.Island_PT == "Canvendish Room" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5314.5463867188, 22.562219619751, -127.06755065918)) elseif _G.Island_PT == "Temple of Time" then Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741, -0.469690144, -2.85620132e-08, -0.882831335, -3.23509219e-08, 1, -1.51411736e-08, .882831335, 2.14487486e-08, -0.469690144)) end end })

Tabs.Teleport:Section({ Title = "Travel - NPCs" })
local npcNames = {}
for _, v in pairs(Q.NPCs:GetChildren()) do table.insert(npcNames, v.Name) end
Tabs.Teleport:Dropdown({ Title = "Select NPCs", Values = npcNames, Value = npcNames[1], Callback = function(v) NPClist = v end })
Tabs.Teleport:Toggle({ Title = "Auto Tween to NPCs", Default = false, Callback = function(v) _G.TPNpc = v end })


Tabs.Fruits:Section({ Title = "Fruits Options" })
local fruitsAdv = {}
for _, v in pairs(Q.Remotes.CommF_:InvokeServer("GetFruits", true)) do if v.OnSale then table.insert(fruitsAdv, v.Name) end end
Tabs.Teleport:Dropdown({ Title = "Select Mirage Fruit", Values = fruitsAdv, Value = fruitsAdv[1], Callback = function(v) SelectF_Adv = v end })
Tabs.Teleport:Button({ Title = "Buy Mirage Stock", Callback = function() Q.Remotes.CommF_:InvokeServer("PurchaseRawFruit", SelectF_Adv) end })
local fruitsBasic = {}
for _, v in pairs(Q.Remotes.CommF_:InvokeServer("GetFruits", false)) do if v.OnSale then table.insert(fruitsBasic, v.Name) end end
Tabs.Teleport:Dropdown({ Title = "Select Fruit Stock", Values = fruitsBasic, Value = fruitsBasic[1], Callback = function(v) _G.SelectFruit = v end })
Tabs.Teleport:Button({ Title = "Buy Basic Stock", Callback = function() Q.Remotes.CommF_:InvokeServer("PurchaseRawFruit", _G.SelectFruit) end })
Tabs.Teleport:Toggle({ Title = "Auto Random Fruit", Default = false, Callback = function(v) _G.Random_Auto = v end })
Tabs.Teleport:Toggle({ Title = "Auto Drop Fruit", Default = false, Callback = function(v) _G.DropFruit = v end })
Tabs.Teleport:Toggle({ Title = "Auto Store Fruit", Default = false, Callback = function(v) _G.StoreF = v end })
Tabs.Teleport:Toggle({ Title = "Auto Tween to Fruit", Default = false, Callback = function(v) _G.TwFruits = v end })
Tabs.Teleport:Toggle({ Title = "Auto Collect Fruit", Default = false, Callback = function(v) _G.InstanceF = v end })


Tabs.Shop:Section({ Title = "Shop Options" })
Tabs.Shop:Button({ Title = "Buy Buso", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyHaki", "Buso") end })
Tabs.Shop:Button({ Title = "Buy Geppo", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo") end })
Tabs.Shop:Button({ Title = "Buy Soru", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyHaki", "Soru") end })
Tabs.Shop:Button({ Title = "Buy Ken", Callback = function() Q.Remotes.CommF_:InvokeServer("KenTalk", "Buy") end })

Tabs.Shop:Section({ Title = "Fighting - Style" })
Tabs.Shop:Button({ Title = "Buy Black Leg", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyBlackLeg") end })
Tabs.Shop:Button({ Title = "Buy Electro", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyElectro") end })
Tabs.Shop:Button({ Title = "Buy Fishman Karate", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end })
Tabs.Shop:Button({ Title = "Buy DragonClaw", Callback = function() Q.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2") end })
Tabs.Shop:Button({ Title = "Buy Superhuman", Callback = function() Q.Remotes.CommF_:InvokeServer("BuySuperhuman") end })
Tabs.Shop:Button({ Title = "Buy Death Step", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyDeathStep") end })
Tabs.Shop:Button({ Title = "Buy Sharkman Karate", Callback = function() Q.Remotes.CommF_:InvokeServer("BuySharkmanKarate") end })
Tabs.Shop:Button({ Title = "Buy ElectricClaw", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyElectricClaw") end })
Tabs.Shop:Button({ Title = "Buy DragonTalon", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyDragonTalon") end })
Tabs.Shop:Button({ Title = "Buy Godhuman", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyGodhuman") end })
Tabs.Shop:Button({ Title = "Buy SanguineArt", Callback = function() Q.Remotes.CommF_:InvokeServer("BuySanguineArt") end })

Tabs.Shop:Section({ Title = "Accessory" })
Tabs.Shop:Button({ Title = "Buy Tomoe Ring", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Tomoe Ring") end })
Tabs.Shop:Button({ Title = "Buy Black Cape", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Black Cape") end })
Tabs.Shop:Button({ Title = "Buy Swordsman Hat", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Swordsman Hat") end })
Tabs.Shop:Button({ Title = "Buy Bizarre Rifle", Callback = function() Q.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1) end })
Tabs.Shop:Button({ Title = "Buy Ghoul Mask", Callback = function() Q.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 2) end })

Tabs.Shop:Section({ Title = "Accessory SeaEvent" })
Tabs.Shop:Button({ Title = "Craft Dragonheart", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonheart") end })
Tabs.Shop:Button({ Title = "Craft Dragonstorm", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonstorm") end })
Tabs.Shop:Button({ Title = "Craft DinoHood", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "DinoHood") end })
Tabs.Shop:Button({ Title = "Craft SharkTooth", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkTooth") end })
Tabs.Shop:Button({ Title = "Craft TerrorJaw", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TerrorJaw") end })
Tabs.Shop:Button({ Title = "Craft SharkAnchor", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkAnchor") end })
Tabs.Shop:Button({ Title = "Craft LeviathanCrown", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanCrown") end })
Tabs.Shop:Button({ Title = "Craft LeviathanShield", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanShield") end })
Tabs.Shop:Button({ Title = "Craft LeviathanBoat", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanBoat") end })
Tabs.Shop:Button({ Title = "Craft LegendaryScroll", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LegendaryScroll") end })
Tabs.Shop:Button({ Title = "Craft MythicalScroll", Callback = function() Q.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "MythicalScroll") end })

Tabs.Shop:Section({ Title = "Weapon World1" })
Tabs.Shop:Button({ Title = "Buy Cutlass", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Cutlass") end })
Tabs.Shop:Button({ Title = "Buy Katana", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Katana") end })
Tabs.Shop:Button({ Title = "Buy Iron Mace", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace") end })
Tabs.Shop:Button({ Title = "Buy Duel Katana", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana") end })
Tabs.Shop:Button({ Title = "Buy Triple Katana", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana") end })
Tabs.Shop:Button({ Title = "Buy Pipe", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Pipe") end })
Tabs.Shop:Button({ Title = "Buy Dual-Headed Blade", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade") end })
Tabs.Shop:Button({ Title = "Buy Bisento", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Bisento") end })
Tabs.Shop:Button({ Title = "Buy Soul Cane", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane") end })
Tabs.Shop:Button({ Title = "Buy Slingshot", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Slingshot") end })
Tabs.Shop:Button({ Title = "Buy Musket", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Musket") end })
Tabs.Shop:Button({ Title = "Buy Dual Flintlock", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock") end })
Tabs.Shop:Button({ Title = "Buy Flintlock", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Flintlock") end })
Tabs.Shop:Button({ Title = "Buy Refined Flintlock", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock") end })
Tabs.Shop:Button({ Title = "Buy Cannon", Callback = function() Q.Remotes.CommF_:InvokeServer("BuyItem", "Cannon") end })
Tabs.Shop:Button({ Title = "Buy Kabucha", Callback = function() Q.Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2") end })

Tabs.Shop:Section({ Title = "Fragments shop" })
Tabs.Shop:Button({ Title = "Buy Refund Stats", Callback = function() Q.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2") end })
Tabs.Shop:Button({ Title = "Buy Reroll Race", Callback = function() Q.Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2") end })
Tabs.Shop:Button({ Title = "Buy Ghoul Race (2.5k)", Callback = function() Q.Remotes.CommF_:InvokeServer("Ectoplasm", " Change", 4) end })
Tabs.Shop:Button({ Title = "Buy Cyborg Race (2.5k)", Callback = function() Q.Remotes.CommF_:InvokeServer("CyborgTrainer", " Buy") end })


Tabs.Misc:Section({ Title = "Server - Function" })
Tabs.Misc:Button({ Title = "Rejoin Server", Callback = function() (game:GetService("TeleportService")):Teleport(game.PlaceId, game.Players.LocalPlayer) end })
Tabs.Misc:Button({ Title = "Hop Server", Callback = function() Hop() end })
Tabs.Misc:Button({ Title = "Hop to Lowest Players", Callback = function() local Y = game:GetService("HttpService"); local R = game:GetService("TeleportService"); local Q = "https://games.roblox.com/v1/games/"; local r = game.PlaceId; local a = Q .. (r .. "/servers/Public?sortOrder=Asc&limit=100"); function ListServers(d) local R = game:HttpGet(a .. (d and "&cursor=" .. d or "")); return Y:JSONDecode(R) end; local w, F; repeat local Y = ListServers(F); w = Y.data[1]; F = Y.nextPageCursor until w; R:TeleportToPlaceInstance(r, w.id, d) end })
Tabs.Misc:Button({ Title = "Hop to Lowest Pings Server", Callback = function() local Y = game:GetService("HttpService"); local d = game:GetService("TeleportService"); local R = game:GetService("Stats"); local function Q(d, R) local Q = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=%d", d, R); local r, a = pcall(function() return Y:JSONDecode(game:HttpGet(Q)) end); if r and (a and a.data) then return a.data end; return nil end; local r = game.PlaceId; local a = 100; local w = Q(r, a); if not w then return end; local F = w[1]; for Y, d in pairs(w) do if d.ping < F.ping and d.maxPlayers > d.playing then F = d end end; task.wait(.5); local K = 100; local n = R.Network.ServerStatsItem; local I = n["Data Ping"]:GetValueString(); local W = tonumber(I:match("(%d+)")); if W >= K then d:TeleportToPlaceInstance(r, F.id) end end })
Tabs.Misc:Input({ Title = "JobID", Default = "", Placeholder = "Type something...", Callback = function(v) _G.JobId = v end })
Tabs.Misc:Button({ Title = "Teleport [Job ID]", Callback = function() Q.__ServerBrowser:InvokeServer("teleport", _G.JobId) end })
Tabs.Misc:Button({ Title = "Copy JobID", Callback = function() setclipboard(tostring(game.JobId)) end })

Tabs.Misc:Section({ Title = "Player Gui / Others" })
Tabs.Misc:Button({ Title = "Open Awakenings Expert", Callback = function() d.PlayerGui.Main.AwakeningToggler.Visible = true end })
Tabs.Misc:Button({ Title = "Open Title Selection", Callback = function() Q.Remotes.CommF_:InvokeServer("getTitles", true); d.PlayerGui.Main.Titles.Visible = true end })
Tabs.Misc:Toggle({ Title = "Disable Chat GUI", Default = false, Callback = function(v) _G.Rechat = v; local d = game:GetService("StarterGui"); if _G.Rechat then d:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) else d:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end end })
Tabs.Misc:Toggle({ Title = "Disable Leader Board GUI", Default = false, Callback = function(v) ReLeader = v; local d = game:GetService("StarterGui"); if ReLeader then d:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false) else d:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true) end end })
Tabs.Misc:Button({ Title = "Set Pirate Team", Callback = function() Pirates() end })
Tabs.Misc:Button({ Title = "Set Marine Team", Callback = function() Marines() end })
Tabs.Misc:Toggle({ Title = "Unlock All Portals", Default = false, Callback = function(v) _G.PortalUnLock = v end })

Tabs.Misc:Section({ Title = "Graphics / Haki Stats" })
Tabs.Misc:Dropdown({ Title = "Select Haki States", Values = { "State 0", "State 1", "State 2", "State 3", "State 4", "State 5" }, Value = "State 0", Callback = function(v) _G.SelectStateHaki = v end })
Tabs.Misc:Button({ Title = "ChangeBusoStage", Callback = function() if _G.SelectStateHaki == "State 0" then Q.Remotes.CommF_:InvokeServer("ChangeBusoStage", 0) elseif _G.SelectStateHaki == "State 1" then Q.Remotes.CommF_:InvokeServer("ChangeBusoStage", 1) elseif _G.SelectStateHaki == "State 2" then Q.Remotes.CommF_:InvokeServer("ChangeBusoStage", 2) elseif _G.SelectStateHaki == "State 3" then Q.Remotes.CommF_:InvokeServer("ChangeBusoStage", 3) elseif _G.SelectStateHaki == "State 4" then Q.Remotes.CommF_:InvokeServer("ChangeBusoStage", 4) elseif _G.SelectStateHaki == "State 5" then Q.Remotes.CommF_:InvokeServer("ChangeBusoStage", 5) end end })
Tabs.Misc:Toggle({ Title = "Turn on RTX Mode", Default = false, Callback = function(v) _G.RTXMode = v end })
Tabs.Misc:Button({ Title = "Turn on Fast Mode", Callback = function() for Y, d in next, workspace:GetDescendants() do if table.find(t, d.ClassName) then d.Material = "Plastic" end end end })
Tabs.Misc:Button({ Title = "Turn on Low CPU", Callback = function() LowCpu() end })
Tabs.Misc:Button({ Title = "Turn on increase Boats", Callback = function() for Y, R in pairs(workspace.Boats:GetDescendants()) do if table.find(l, R.Name) and tostring(R.Owner.Value) == tostring(d.Name) then R.VehicleSeat.MaxSpeed = 350; R.VehicleSeat.Torque = .2; R.VehicleSeat.TurnSpeed = 5; R.VehicleSeat.HeadsUpDisplay = true end end end })
Tabs.Misc:Button({ Title = "Remove Sky Fog", Callback = function() if F:FindFirstChild("LightingLayers") then F.LightingLayers:Destroy() end; if F:FindFirstChild("SeaTerrorCC") then F.SeaTerrorCC:Destroy() end; if F:FindFirstChild("FantasySky") then F.FantasySky:Destroy() end end })

Tabs.Misc:Section({ Title = "Configure - God" })
Tabs.Misc:Button({ Title = "Rain Fruits (Client)", Callback = function() for Y, R in pairs((game:GetObjects("rbxassetid://14759368201"))[1]:GetChildren()) do R.Parent = game.Workspace.Map; R:MoveTo(d.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50))); if R.Fruit:FindFirstChild("AnimationController") then ((R.Fruit:FindFirstChild("AnimationController")):LoadAnimation(R.Fruit:FindFirstChild("Idle"))):Play() end; R.Handle.Touched:Connect(function(Y) if Y.Parent == d.Character then R.Parent = d.Backpack; d.Character.Humanoid:EquipTool(R) end end) end end })
Tabs.Misc:Toggle({ Title = "Turn on Full Bright", Default = false, Callback = function(v) bright = v; if v then F.Ambient = Color3.new(1,1,1); F.ColorShift_Bottom = Color3.new(1,1,1); F.ColorShift_Top = Color3.new(1,1,1) else F.Ambient = Color3.new(0,0,0); F.ColorShift_Bottom = Color3.new(0,0,0); F.ColorShift_Top = Color3.new(0,0,0) end end })
Tabs.Misc:Dropdown({ Title = "Select Time", Values = { "Day", "Night" }, Value = "Day", Callback = function(v) _G.SelectDN = v end })
Tabs.Misc:Toggle({ Title = "Turn on Time", Default = false, Callback = function(v) _G.daylightN = v end })
Tabs.Misc:Toggle({ Title = "Turn on Walk on Water", Default = true, Callback = function(v) _G.WalkWater_Part = v; local d = (game:GetService("Workspace")).Map["WaterBase-Plane"]; if _G.WalkWater_Part then d.Size = Vector3.new(1000,112,1000) else d.Size = Vector3.new(1000,80,1000) end end })
Tabs.Misc:Toggle({ Title = "Turn on Ice Walk", Default = false, Callback = function(v) _G.WalkWater = v end })


spawn(function()
    while task.wait(.1) do
        if _G.Level then
            pcall(function()
                HRP = i and i:FindFirstChild("HumanoidRootPart")
                if not HRP then return end
                if (game:GetService("Players")).LocalPlayer.Data.Level.Value <= 2599 then
                    if not CheckHasQuest(NameMon) then
                        (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("AbandonQuest")
                        wait(1)
                        CheckQuest()
                        _tp(CFrameQuest)
                        if (HRP.Position - CFrameQuest.Position).Magnitude <= 2 then
                            task.wait(2)
                            (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                            task.wait(1)
                            _tp(CFrameMon)
                        end
                    else
                        CheckQuest()
                        if game.Workspace.Enemies:FindFirstChild(Mon) then
                            for Y, d in pairs(game.Workspace.Enemies:GetChildren()) do
                                if d:FindFirstChild("HumanoidRootPart") and (d:FindFirstChild("Humanoid") and (d.Humanoid.Health > 0 and d.Name == Mon)) then
                                    if CheckHasQuest(NameMon) then
                                        repeat task.wait()
                                            f.Kill(d, _G.Level)
                                        until not _G.Level or d.Humanoid.Health <= 0 or not d.Parent or not CheckHasQuest(NameMon)
                                    else
                                        (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        else
                            _tp(CFrameMon)
                        end
                    end
                elseif (game:GetService("Players")).LocalPlayer.Data.Level.Value >= 2600 then
                    if g:GetAttribute("CurrentLocation") == "Submerged Island" or g:GetAttribute("CurrentLocation") == "Sealed Cavern" then
                        if not CheckHasQuest(NameMon) then
                            (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("AbandonQuest")
                            wait(1)
                            CheckQuest()
                            _tp(CFrameQuest)
                            if (HRP.Position - CFrameQuest.Position).Magnitude <= 2 then
                                task.wait(2)
                                (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                                task.wait(1)
                                _tp(CFrameMon)
                            end
                        else
                            CheckQuest()
                            if game.Workspace.Enemies:FindFirstChild(Mon) then
                                for Y, d in pairs(game.Workspace.Enemies:GetChildren()) do
                                    if d:FindFirstChild("HumanoidRootPart") and (d:FindFirstChild("Humanoid") and (d.Humanoid.Health > 0 and d.Name == Mon)) then
                                        if CheckHasQuest(NameMon) then
                                            repeat task.wait()
                                                f.Kill(d, _G.Level)
                                            until not _G.Level or d.Humanoid.Health <= 0 or not d.Parent or not CheckHasQuest(NameMon)
                                        else
                                            (game:GetService("ReplicatedStorage")).Remotes.CommF_:InvokeServer("AbandonQuest")
                                        end
                                    end
                                end
                            else
                                _tp(CFrameMon)
                            end
                        end
                    elseif g:GetAttribute("CurrentLocation") ~= "Submerged Island" and g:GetAttribute("CurrentLocation") ~= "Sealed Cavern" then
                        if World3 then
                            submarineCF = CFrame.new(-16269.4121, 24.7584076, 1371.70752, -0.999348342, -0.00479344372, .0357791297, -0.00262145093, .998164296, .0605080314, -0.036003489, .0603748076, -0.997526407)
                            _tp(submarineCF)
                            if (HRP.Position - submarineCF.Position).Magnitude <= 5 then
                                local Y = { "TravelToSubmergedIsland" }
                                ((game:GetService("ReplicatedStorage")).Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak")):InvokeServer(unpack(Y))
                            end
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(T) do
        pcall(function()
            if _G.TravelDres then
                if d.Data.Level.Value >= 700 then
                    if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
                        Q.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                        EquipWeapon("Key")
                        repeat wait() _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488)) until not _G.TravelDres or R.Position == (CFrame.new(1347.7124, 37.3751602, -1325.6488)).Position
                    elseif workspace.Map.Ice.Door.CanCollide == false and workspace.Map.Ice.Door.Transparency == 1 then
                        if M:FindFirstChild("Ice Admiral") then
                            for Y, d in pairs(M:GetChildren()) do
                                if d.Name == "Ice Admiral" and f.Alive(d) then
                                    repeat task.wait() f.Kill(d, _G.TravelDres) until _G.TravelDres == false or d.Humanoid.Health <= 0
                                    Q.Remotes.CommF_:InvokeServer("TravelDressrosa")
                                end
                            end
                        else _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488)) end
                    else Q.Remotes.CommF_:InvokeServer("TravelDressrosa") end
                end
            end
        end)
    end
end)

spawn(function()
    while wait(T) do
        pcall(function()
            if _G.AutoZou then
                if d.Data.Level.Value >= 1500 then
                    if Q.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 3 then
                        if (Q.Remotes.CommF_:InvokeServer("GetUnlockables")).FlamingoAccess ~= nil then
                            Q.Remotes.CommF_:InvokeServer("F_", "TravelZou")
                            if Q.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
                                local Y = GetConnectionEnemies("rip_indra")
                                if Y then repeat wait() f.Kill(Y, _G.AutoZou) until not _G.AutoZou or not Y.Parent or Y.Humanoid.Health <= 0
                                    Check = 2
                                    repeat wait() Q.Remotes.CommF_:InvokeServer("F_", "TravelZou") until Check == 1
                                else Q.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Check"); wait(.1); Q.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Begin") end
                            elseif Q.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then Q.Remotes.CommF_:InvokeServer("F_", "TravelZou")
                            else local Y = GetConnectionEnemies("Don Swan")
                                if Y then repeat wait() f.Kill(Y, _G.AutoZou) until not _G.AutoZou or not Y.Parent or Y.Humanoid.Health <= 0
                                else repeat wait() _tp(CFrame.new(2288.802, 15.1870775, 863.034607)) until not _G.AutoZou or R.Position == (CFrame.new(2288.802, 15.1870775, 863.034607)).Position
                                    if R.CFrame == CFrame.new(2288.802, 15.1870775, 863.034607) then notween(CFrame.new(2288.802, 15.1870775, 863.034607)) end end
                            end
                        else
                            if (Q.Remotes.CommF_:InvokeServer("GetUnlockables")).FlamingoAccess == nil then
                                TabelDevilFruitStore = {}; TabelDevilFruitOpen = {}
                                for Y, d in pairs(Q.Remotes.CommF_:InvokeServer("getInventoryFruits")) do for Y, d in pairs(d) do if Y == "Name" then table.insert(TabelDevilFruitStore, d) end end end
                                for Y, d in next, (game.ReplicatedStorage:WaitForChild("Remotes")).CommF_:InvokeServer("GetFruits") do if d.Price >= 1000000 then table.insert(TabelDevilFruitOpen, d.Name) end end
                                for Y, R in pairs(TabelDevilFruitOpen) do for Y, r in pairs(TabelDevilFruitStore) do if R == r and (Q.Remotes.CommF_:InvokeServer("GetUnlockables")).FlamingoAccess == nil then
                                    if not d.Backpack:FindFirstChild(r) then Q.Remotes.CommF_:InvokeServer("F_", "LoadFruit", r) else Q.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1"); Q.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2"); Q.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3") end end end end
                                Q.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1"); Q.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2"); Q.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3")
                            end
                        end
                    else
                        if Q.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
                            if string.find(d.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and (string.find(d.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and d.PlayerGui.Main.Quest.Visible == true) then
                                local Y = GetConnectionEnemies("Swan Pirate")
                                if Y then pcall(function() repeat wait() f.Kill(Y, _G.AutoZou) until not Y.Parent or Y.Humanoid.Health <= 0 or _G.AutoZou == false or d.PlayerGui.Main.Quest.Visible == false end) else _tp(CFrame.new(1057.92761, 137.614319, 1242.08069)) end
                            else _tp(CFrame.new(-456.28952, 73.0200958, 299.895966)) end
                        elseif Q.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
                            local Y = GetConnectionEnemies("Jeremy")
                            if Y then repeat wait() f.Kill(Y, _G.AutoZou) until not Y.Parent or Y.Humanoid.Health <= 0 or _G.AutoZou == false else _tp(CFrame.new(2099.88159, 448.931, 648.997375)) end
                        elseif Q.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
                            repeat wait() _tp(CFrame.new(-1836, 11, 1714)) until not _G.AutoZou or R.Position == (CFrame.new(-1836, 11, 1714)).Position
                            if R.CFrame == CFrame.new(-1836, 11, 1714) then notween(CFrame.new(-1836, 11, 1714)) end
                            notween(CFrame.new(-1850.49329, 13.1789551, 1750.89685)); wait(.1); notween(CFrame.new(-1858.87305, 19.3777466, 1712.01807)); wait(.1); notween(CFrame.new(-1803.94324, 16.5789185, 1750.89685)); wait(.1); notween(CFrame.new(-1858.55835, 16.8604317, 1724.79541)); wait(.1); notween(CFrame.new(-1869.54224, 15.987854, 1681.00659)); wait(.1); notween(CFrame.new(-1800.0979, 16.4978027, 1684.52368)); wait(.1); notween(CFrame.new(-1819.26343, 14.795166, 1717.90625)); wait(.1); notween(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
                        end
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoFarmNear then
                for Y, d in pairs(workspace.Enemies:GetChildren()) do
                    if d:FindFirstChild("Humanoid") or d:FindFirstChild("HumanoidRootPart") then
                        if d.Humanoid.Health > 0 then
                            repeat wait() f.Kill(d, _G.AutoFarmNear) until not _G.AutoFarmNear or not d.Parent or d.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while wait(T) do
        pcall(function()
            if _G.AutoFactory then
                local Y = GetConnectionEnemies("Core")
                if Y then repeat wait() EquipWeapon(_G.SelectWeapon); _tp(CFrame.new(448.46756, 199.356781, -441.389252)) until Y.Humanoid.Health <= 0 or _G.AutoFactory == false else _tp(CFrame.new(448.46756, 199.356781, -441.389252)) end
            end
        end)
    end
end)

spawn(function()
    while wait(T) do
        if _G.AutoRaidCastle then
            pcall(function()
                local Y = CFrame.new(-5496.17432, 313.768921, -2841.53027, .924894512, 7.37058015e-09, .380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, .924894512)
                if ((CFrame.new(-5539.3115234375, 313.80053710938, -2972.3723144531)).Position - R.Position).Magnitude <= 500 then
                    for Y, d in pairs(workspace.Enemies:GetChildren()) do
                        if d:FindFirstChild("HumanoidRootPart") and (d:FindFirstChild("Humanoid") and d.Humanoid.Health > 0) then
                            if d.Name then
                                if (d.HumanoidRootPart.Position - R.Position).Magnitude <= 2000 then
                                    repeat wait() f.Kill(d, _G.AutoRaidCastle) until not _G.AutoRaidCastle or not d.Parent or d.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(d.Name)
                                end
                            end
                        end
                    end
                else
                    local d = { "Galley Pirate", "Galley Captain", "Raider", "Mercenary", "Vampire", "Zombie", "Snow Trooper", "Winter Warrior", "Lab Subordinate", "Horned Warrior", "Magma Ninja", "Lava Pirate", "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter" }
                    for R = 1, #d, 1 do
                        if Q:FindFirstChild(d[R]) then
                            for R, Q in pairs(Q:GetChildren()) do
                                if table.find(d, Q.Name) then _tp(Y) end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    local function Y(Y, d)
        if Y:FindFirstChild("Humanoid") and (Y:FindFirstChild("HumanoidRootPart") and Y.Humanoid.Health > 0) then
            if Y.Name == d then
                repeat wait() f.Kill(Y, (getgenv()).AutoMaterial) until not (getgenv()).AutoMaterial or not Y.Parent or Y.Humanoid.Health <= 0
            end
        end
    end
    local function d()
        for Y, d in pairs((game:GetService("Workspace"))._WorldOrigin.EnemySpawns:GetChildren()) do
            for Y, R in ipairs(MMon) do
                if string.find(d.Name, R) then
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - d.Position).Magnitude >= 10 then _tp(d.CFrame * Pos) end
                end
            end
        end
    end
    while wait() do
        if (getgenv()).AutoMaterial then
            pcall(function()
                if (getgenv()).SelectMaterial then MaterialMon((getgenv()).SelectMaterial); _tp(MPos) end
                for d, R in ipairs(MMon) do for d, Q in pairs(workspace.Enemies:GetChildren()) do Y(Q, R) end end
                d()
            end)
        end
    end
end)

spawn(function()
    while wait(T) do
        pcall(function()
            if _G.AutoEctoplasm then
                local Y = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Arctic Warrior" }
                local d = GetConnectionEnemies(Y)
                if f.Alive(d) then repeat wait() f.Kill(d, _G.AutoEctoplasm) until not _G.AutoEctoplasm or not d.Parent or d.Humanoid.Health <= 0
                else Q.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125)) end
            end
        end)
    end
end)

spawn(function()
    while wait(.1) do
        pcall(function()
            if _G.Bartilo_Quest and r >= 850 then
                local Y = d.PlayerGui.Main.Quest
                if Q.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
                    _G.Level = false
                    if Y.Visible == true then
                        local R = GetConnectionEnemies("Swan Pirate")
                        if R then
                            local R = GetConnectionEnemies(X)
                            if R then
                                repeat task.wait()
                                    if not string.find(d.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirate") then Q.Remotes.CommF_:InvokeServer("AbandonQuest")
                                    else f.Kill(R, _G.Bartilo_Quest) end
                                until _G.Bartilo_Quest == false or not R.Parent or R.Humanoid.Health <= 0 or Y.Visible == false or not R:FindFirstChild("HumanoidRootPart")
                            end
                        else _tp(CFrame.nee(970.369446, 142.653198, 1217.3667, .162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, .986777723, -2.50063148e-09, .162079468)) end
                    else
                        repeat wait() _tp(CFrame.new(-461.533203, 72.3478546, 300.311096, .050853312, 0, -0.998706102, 0, 1, 0, .998706102, 0, .050853312)) until ((CFrame.new(-461.533203, 72.3478546, 300.311096, .050853312, 0, -0.998706102, 0, 1, 0, .998706102, 0, .050853312)).Position - d.Character.HumanoidRootPart.Position).Magnitude <= 20 or _G.Bartilo_Quest == false
                        if ((CFrame.new(-461.533203, 72.3478546, 300.311096, .050853312, 0, -0.998706102, 0, 1, 0, .998706102, 0, .050853312)).Position - d.Character.HumanoidRootPart.Position).Magnitude <= 1 then Q.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1) end
                    end
                elseif Q.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
                    _G.Level = false
                    local d = GetConnectionEnemies("Jeremy")
                    if d then repeat task.wait() f.Kill(d, _G.Bartilo_Quest) until _G.Bartilo_Quest == false or not d.Parent or d.Humanoid.Health <= 0 or Y.Visible == false or not d:FindFirstChild("HumanoidRootPart") else _tp(CFrame.new(2158.97412, 449.056244, 705.411682, -0.754199564, -4.17389057e-09, -0.656645238, -4.47752875e-08, 1, 4.50709301e-08, .656645238, 6.3393955e-08, -0.754199564)) end
                elseif Q.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
                    repeat wait() _tp(CFrame.new(-1830.83972, 10.5578213, 1680.60229, .979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, .199054286, -1.13962431e-08, .979988456)) until ((CFrame.new(-1830.83972, 10.5578213, 1680.60229, .979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, .199054286, -1.13962431e-08, .979988456)).Position - d.Character.HumanoidRootPart.Position).Magnitude <= 1 or _G.Bartilo_Quest == false
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
                    wait(.5); d.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
                    wait(2.5)
                end
            end
        end)
    end
end)

spawn(function()
    while wait(T) do
        pcall(function()
            if _G.CitizenQuest then
                if r >= 1800 and (Q.Remotes.CommF_:InvokeServer("CitizenQuestProgress")).KilledBandits == false then
                    if string.find(d.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and (string.find(d.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and d.PlayerGui.Main.Quest.Visible == true) then
                        local Y = GetConnectionEnemies("Forest Pirate")
                        if Y then repeat task.wait() f.Kill(Y, _G.CitizenQuest) until _G.CitizenQuest == false or not Y.Parent or Y.Humanoid.Health <= 0 or d.PlayerGui.Main.Quest.Visible == false else _tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375)) end
                    else
                        _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                        if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - d.Character.HumanoidRootPart.Position).Magnitude <= 30 then wait(1.5); Q.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1) end
                    end
                elseif r >= 1800 and (Q.Remotes.CommF_:InvokeServer("CitizenQuestProgress")).KilledBoss == false then
                    local Y = GetConnectionEnemies("Captain Elephant")
                    if d.PlayerGui.Main.Quest.Visible and (string.find(d.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and d.PlayerGui.Main.Quest.Visible == true) then
                        if Y then repeat task.wait() f.Kill(Y, _G.CitizenQuest) until _G.CitizenQuest == false or Y.Humanoid.Health <= 0 or not Y.Parent or d.PlayerGui.Main.Quest.Visible == false else _tp(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375)) end
                    else
                        _tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                        if ((CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125)).Position - d.Character.HumanoidRootPart.Position).Magnitude <= 4 then wait(1.5); Q.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") end
                    end
                elseif r >= 1800 and Q.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then _tp(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125)) end
            end
        end)
    end
end)

spawn(function()
    while wait(T) do
        if _G.DummyMan then
            pcall(function()
                if d.PlayerGui.Main.Quest.Visible == false then
                    local Y = { [1] = "ArenaTrainer" }
                    ((Q:WaitForChild("Remotes")):WaitForChild("CommF_")):InvokeServer(unpack(Y))
                else
                    local Y = GetConnectionEnemies("Training Dummy")
                    if Y then repeat wait() f.Kill(Y, _G.DummyMan) until not _G.DummyMan or not Y.Parent or Y.Humanoid.Health <= 0 else _tp(CFrame.new(3688.0051269531, 12.746943473816, 170.20953369141)) end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(T) do
        if _G.AutoBerry then
            local Y = game:GetService("CollectionService")
            local d = game:GetService("Players")
            local R = d.LocalPlayer
            local Q = Y:GetTagged("BerryBush")
            local r, a = math.huge
            for Y = 1, #Q, 1 do
                local d = Q[Y]
                for Y, R in pairs(d:GetAttributes()) do
                    if not BerryArray or table.find(BerryArray, R) then
                        _tp(d.Parent:GetPivot())
                        for Y = 1, #Q, 1 do
                            local d = Q[Y]
                            for Y, d in pairs(d:GetChildren()) do
                                if not BerryArray or table.find(BerryArray, d) then
                                    _tp(d.WorldPivot)
                                    fireproximityprompt(d.ProximityPrompt, math.huge)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

spawn(function()
    while wait(T) do
        if _G.AutoFarmChest then
            pcall(function()
                local Y = game:GetService("CollectionService")
                local d = game:GetService("Players")
                local R = d.LocalPlayer
                local Q = R.Character or R.CharacterAdded:Wait()
                if not Q then return end
                local r = (Q:GetPivot()).Position
                local a = Y:GetTagged("_ChestTagged")
                local w, F = math.huge, nil
                for Y = 1, #a, 1 do
                    local d = a[Y]
                    local R = ((d:GetPivot()).Position - r).Magnitude
                    if not SelectedIsland or d:IsDescendantOf(SelectedIsland) then
                        if not d:GetAttribute("IsDisabled") and R < w then w = R; F = d end
                    end
                end
                if F then _tp(F:GetPivot()) end
            end)
        end
    end
end)
