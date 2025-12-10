local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI gagal dimuat!")
    return
else
    print("✓ WindUI berhasil dimuat!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | The Forge",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(300, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
})

local Tab = Window:Tab({
    Title = "Auto Farm Orc",
    Icon = "sword",
})

-- STATE
local mobFarm = {
    enabled = false,
    selectedMobs = {"Orc"},
    attackInterval = 0.1,
    safeHealthPercent = 30,
    mobsESPEnabled = false,
}

-- SERVICES
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- UTILS
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid")
end

local function getHumanoidRootPart()
    local char = getCharacter()
    return char:FindFirstChild("HumanoidRootPart")
end

local function listToSet(list)
    local set = {}
    for _, v in ipairs(list) do
        set[tostring(v)] = true
    end
    return set
end

-- MOB COLLECTION
local function normalizeMobName(name)
    return tostring(name):gsub("%d+$", "")
end

local function isMobDead(model)
    if not model then return false end
    local dead = model:FindFirstChild("Dead", true)
    return dead and dead:IsA("BoolValue") and dead.Value == true
end

local function collectMobs(selectedSet)
    local living = Workspace:FindFirstChild("Living")
    local result = {}
    if not living then return result end
    for _, model in ipairs(living:GetChildren()) do
        if model:IsA("Model") and not isMobDead(model) then
            local baseName = normalizeMobName(model.Name)
            if selectedSet[baseName] then
                local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("HRP")
                if hrp and hrp:IsA("BasePart") then
                    table.insert(result, {
                        model = model,
                        hrp = hrp,
                        mobType = baseName,
                    })
                end
            end
        end
    end
    return result
end

local function getNearestMob(selectedSet)
    local mobs = collectMobs(selectedSet)
    if #mobs == 0 then return nil end
    local hrp = getHumanoidRootPart()
    if not hrp then return nil end
    local best, bestDist
    for _, info in ipairs(mobs) do
        local dist = (info.hrp.Position - hrp.Position).Magnitude
        if not bestDist or dist < bestDist then
            bestDist = dist
            best = info
        end
    end
    return best
end

-- WEAPON
local function ensureWeaponEquipped()
    local char = getCharacter()
    local hum = getHumanoid()
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name == "Weapon" then
            return t
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end
    local weapon = backpack:FindFirstChild("Weapon")
    if weapon and weapon:IsA("Tool") then
        pcall(function() hum:EquipTool(weapon) end)
        task.wait(0.1)
        return weapon
    end
    return nil
end

-- ATTACK
local function attackMob(mobInfo)
    local toolServiceRF = ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Packages")
        :WaitForChild("Knit")
        :WaitForChild("Services")
        :WaitForChild("ToolService")
        :WaitForChild("RF")
        :WaitForChild("ToolActivated")
    pcall(function()
        toolServiceRF:InvokeServer("Weapon")
    end)
end

-- LOW HP RETREAT
local function isLowHealth()
    local hum = getHumanoid()
    if not hum or hum.MaxHealth <= 0 then return false end
    return (hum.Health / hum.MaxHealth) * 100 <= (mobFarm.safeHealthPercent or 30)
end

local function retreatToSafety()
    local hrp = getHumanoidRootPart()
    if not hrp then return end
    local safePos = hrp.Position + Vector3.new(0, 60, 0)
    local tween = TweenService:Create(hrp, TweenInfo.new(1.5), {CFrame = CFrame.new(safePos)})
    tween:Play()
    tween.Completed:Wait()
    local hum = getHumanoid()
    while mobFarm.enabled and hum and hum.Health < hum.MaxHealth do
        task.wait(0.5)
    end
end

-- ESP
local mobEspObjects = {}

local function clearMobsESP()
    for _, data in pairs(mobEspObjects) do
        for _, obj in pairs({"highlight", "billboard", "beam", "attachment"}) do
            if data[obj] then pcall(function() data[obj]:Destroy() end) end
        end
    end
    table.clear(mobEspObjects)
end

local function ensureESPForMob(mobInfo)
    local model = mobInfo.model
    local hrp = mobInfo.hrp
    if not model or not hrp or mobEspObjects[model] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.Adornee = model
    highlight.Parent = Workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.Parent = model

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = tostring(mobInfo.mobType)
    label.TextColor3 = Color3.white
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard

    mobEspObjects[model] = {
        highlight = highlight,
        billboard = billboard,
    }
end

local function updateMobsESP()
    if not mobFarm.mobsESPEnabled then
        clearMobsESP()
        return
    end
    local mobs = collectMobs(listToSet(mobFarm.selectedMobs))
    for _, info in ipairs(mobs) do
        ensureESPForMob(info)
    end
end

-- UI
Tab:Dropdown({
    Title = "Pilih Orc Type",
    Values = {"Orc", "Orc Warrior", "Orc Berserker", "Orc Shaman"},
    Value = mobFarm.selectedMobs,
    Multi = true,
    Callback = function(opts)
        mobFarm.selectedMobs = opts
    end,
})

Tab:Slider({
    Title = "Safe HP %",
    Value = mobFarm.safeHealthPercent,
    Min = 0,
    Max = 100,
    Callback = function(v)
        mobFarm.safeHealthPercent = v
    end,
})

Tab:Toggle({
    Title = "Mobs ESP",
    Value = false,
    Callback = function(v)
        mobFarm.mobsESPEnabled = v
        updateMobsESP()
    end,
})

Tab:Toggle({
    Title = "Auto Farm Orc",
    Value = false,
    Callback = function(state)
        mobFarm.enabled = state
        if not state then return end

        task.spawn(function()
            while mobFarm.enabled do
                if isLowHealth() then
                    retreatToSafety()
                    continue
                end

                local weapon = ensureWeaponEquipped()
                if not weapon then
                    task.wait(0.2)
                    continue
                end

                local selectedSet = listToSet(mobFarm.selectedMobs)
                local target = getNearestMob(selectedSet)
                if not target then
                    task.wait(0.2)
                    continue
                end

                local hrp = getHumanoidRootPart()
                if hrp and target.hrp then
                    local tween = TweenService:Create(hrp, TweenInfo.new(1), {
                        CFrame = CFrame.new(target.hrp.Position + Vector3.new(0, 3, 0))
                    })
                    tween:Play()
                    tween.Completed:Wait()
                end

                if not target.model or not target.model.Parent or isMobDead(target.model) then
                    continue
                end

                attackMob(target)
                task.wait(mobFarm.attackInterval or 0.1)
            end
        end)
    end,
})

-- ESP UPDATE LOOP
task.spawn(function()
    while true do
        if mobFarm.mobsESPEnabled then
            updateMobsESP()
        end
        task.wait(0.5)
    end
end)
