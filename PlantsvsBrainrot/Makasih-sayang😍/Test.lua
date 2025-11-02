local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Backpack = LocalPlayer:WaitForChild("Backpack")

local NetPkg
pcall(function()
    local packages = ReplicatedStorage:WaitForChild("Packages", 5)
    if packages and packages:FindFirstChild("_Index") then
        for _, v in pairs(packages._Index:GetChildren()) do
            if v:FindFirstChild("net") then
                NetPkg = v.net
                break
            end
        end
    end
end)

if not NetPkg and ReplicatedStorage:FindFirstChild("Remotes") then
    NetPkg = ReplicatedStorage.Remotes
end

local function FireWeaponAttack(payload)
    if NetPkg and NetPkg:FindFirstChild("AttacksServer") and NetPkg.AttacksServer:FindFirstChild("WeaponAttack") then
        NetPkg.AttacksServer.WeaponAttack:FireServer(payload)
    elseif ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("AttacksServer") and ReplicatedStorage.Remotes.AttacksServer:FindFirstChild("WeaponAttack") then
        ReplicatedStorage.Remotes.AttacksServer.WeaponAttack:FireServer(payload)
    end
end

local function FireSimpleRemote(name, ...)
    if NetPkg and NetPkg:FindFirstChild(name) then
        NetPkg[name]:FireServer(...)
    elseif ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild(name) then
        ReplicatedStorage.Remotes[name]:FireServer(...)
    end
end

_G.AutoEquipBat = false
_G.AutoFarm = false
_G.AutoEquipBest = false
_G.Delay = 1

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
        Anonymous = false,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },
})

Window:Tag({
    Title = "Version",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Dev",
    Color = Color3.fromRGB(0, 0, 0),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Info = Window:Tab({ Title = "Info", Icon = "info" })
local Main = Window:Tab({ Title = "Main", Icon = "crown" })
local Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

Window:SelectTab(2)

Info:Section({ Title = "Info" })
Shop:Section({ Title = "Shop" })
Settings:Section({ Title = "Settings" })

local BrainrotsCache = {}
local function UpdateBrainrotsCache()
    local ok, folder = pcall(function()
        return workspace:WaitForChild("ScriptedMap"):WaitForChild("Brainrots")
    end)
    if not ok or not folder then return end
    BrainrotsCache = {}
    for _, b in ipairs(folder:GetChildren()) do
        if b:FindFirstChild("BrainrotHitbox") then
            table.insert(BrainrotsCache, b)
        end
    end
end

local function GetNearestBrainrot()
    local nearest = nil
    local minDist = math.huge
    for _, b in ipairs(BrainrotsCache) do
        local hitbox = b:FindFirstChild("BrainrotHitbox")
        if hitbox and hitbox.Position then
            local dist = (HumanoidRootPart.Position - hitbox.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = b
            end
        end
    end
    return nearest
end

local function EquipBatNow()
    local tool = Backpack:FindFirstChild("Basic Bat") or Character:FindFirstChild("Basic Bat")
    if tool then
        tool.Parent = Character
    end
end

Main:Toggle({
    Title = "Auto Equip Bat",
    Default = false,
    Callback = function(v)
        _G.AutoEquipBat = v
        if v then
            task.spawn(function()
                while _G.AutoEquipBat do
                    EquipBatNow()
                    task.wait(_G.Delay)
                end
            end)
        end
    end
})

Main:Toggle({
    Title = "Auto Farm (Attack)",
    Default = false,
    Callback = function(v)
        _G.AutoFarm = v
        if v then
            task.spawn(function()
                while _G.AutoFarm do
                    UpdateBrainrotsCache()
                    local target = GetNearestBrainrot()
                    if target and target:FindFirstChild("BrainrotHitbox") then
                        local hb = target.BrainrotHitbox
                        pcall(function()
                            FireWeaponAttack({ { target = hb } })
                        end)
                    end
                    task.wait(_G.Delay)
                end
            end)
        end
    end
})

Main:Toggle({
    Title = "Auto Equip Best Brainrot",
    Default = false,
    Callback = function(v)
        _G.AutoEquipBest = v
        if v then
            task.spawn(function()
                while _G.AutoEquipBest do
                    pcall(function()
                        FireSimpleRemote("EquipBestBrainrots")
                    end)
                    task.wait(_G.Delay)
                end
            end)
        end
    end
})

Main:Slider({
    Title = "Delay (seconds)",
    Min = 1,
    Max = 60,
    Default = 1,
    Callback = function(v)
        _G.Delay = v
    end
})
