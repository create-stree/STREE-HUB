local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local player = game.Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local AutoEquip = false
local AutoHit = false
local AutoCollect = false
local AutoFollowHit = false
local AttackDelay = 0.3
local FollowDistance = 5
local AttackRange = 10

local function GetBatTool()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("bat") then
            return tool
        end
    end
    return nil
end

local function EquipBat()
    local tool = GetBatTool()
    if tool and not Character:FindFirstChildOfClass("Tool") then
        Humanoid:EquipTool(tool)
    end
end

local function AttackBrainrot()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
    end
end

local function GetNearestBrainrot()
    local nearest, dist = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        local hum = v:FindFirstChild("Humanoid")
        local hrp = v:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 and v.Name:lower():find("brain") then
            local mag = (RootPart.Position - hrp.Position).Magnitude
            if mag < dist then
                dist = mag
                nearest = v
            end
        end
    end
    return nearest
end

local function CollectBrains()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent.Name:lower():find("brain") then
            pcall(function()
                firetouchinterest(RootPart, obj.Parent, 0)
                firetouchinterest(RootPart, obj.Parent, 1)
            end)
        end
    end
end

local ActiveBrainrots = {}
local CurrentTarget = nil

local function UpdateBrainrotCache()
    ActiveBrainrots = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local hum = v:FindFirstChild("Humanoid")
            if hum.Health > 0 and v.Name:lower():find("brain") then
                ActiveBrainrots[v.Name] = v
            end
        end
    end
end

local function GetNearestBrainrotAdvanced()
    local nearest, minDistance = nil, math.huge
    for _, brainrot in pairs(ActiveBrainrots) do
        if brainrot and brainrot.Parent then
            local root = brainrot:FindFirstChild("HumanoidRootPart")
            if root then
                local distance = (RootPart.Position - root.Position).Magnitude
                if distance < minDistance and distance <= 100 then
                    minDistance = distance
                    nearest = brainrot
                end
            end
        end
    end
    return nearest, minDistance
end

local function FollowBrainrot(target)
    if not target or not target.Parent then return end
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local brainrotCFrame = targetRoot.CFrame
    local behindPosition = brainrotCFrame.Position - brainrotCFrame.LookVector * FollowDistance
    RootPart.CFrame = CFrame.new(behindPosition) * CFrame.Angles(0, brainrotCFrame.Rotation.Y, 0)
    RootPart.CFrame = CFrame.new(RootPart.Position, targetRoot.Position)
end

player.CharacterAdded:Connect(function(char)
    Character = char
    task.wait(2)
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

workspace.DescendantAdded:Connect(function(descendant)
    if AutoFollowHit and descendant:IsA("Model") and descendant.Name:lower():find("brain") then
        task.wait(1)
        UpdateBrainrotCache()
    end
end)

workspace.DescendantRemoving:Connect(function(descendant)
    if AutoFollowHit and descendant:IsA("Model") and descendant.Name:lower():find("brain") then
        ActiveBrainrots[descendant.Name] = nil
    end
end)

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | PvB",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(360, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Freemium",
    Color = Color3.fromRGB(205, 127, 50),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Main = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

Main:Toggle({
    Title = "Auto Equip Bat",
    Default = false,
    Callback = function(state)
        AutoEquip = state
        task.spawn(function()
            while AutoEquip do
                EquipBat()
                task.wait(1)
            end
        end)
    end
})

Main:Toggle({
    Title = "Auto Hit Brainrot (Teleport Mode)",
    Default = false,
    Callback = function(state)
        AutoHit = state
        task.spawn(function()
            while AutoHit do
                EquipBat()
                local nearest = GetNearestBrainrot()
                if nearest then
                    local root = nearest:FindFirstChild("HumanoidRootPart")
                    if root then
                        RootPart.CFrame = root.CFrame * CFrame.new(0, 0, 3)
                        AttackBrainrot()
                    end
                end
                task.wait(0.15)
            end
        end)
    end
})

Main:Toggle({
    Title = "Auto Hit Brainrot (Follow Mode)",
    Default = false,
    Callback = function(state)
        AutoFollowHit = state
        task.spawn(function()
            while AutoFollowHit do
                EquipBat()
                UpdateBrainrotCache()
                local nearest, distance = GetNearestBrainrotAdvanced()
                if nearest then
                    CurrentTarget = nearest
                    if distance <= 50 then
                        FollowBrainrot(nearest)
                        if distance <= AttackRange then
                            AttackBrainrot()
                        end
                    end
                else
                    CurrentTarget = nil
                end
                task.wait(AttackDelay)
            end
        end)
    end
})

Main:Toggle({
    Title = "Auto Collect Brain",
    Default = false,
    Callback = function(state)
        AutoCollect = state
        task.spawn(function()
            while AutoCollect do
                CollectBrains()
                task.wait(0.5)
            end
        end)
    end
})

local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

Settings:Slider({
    Title = "Attack Delay",
    Default = 0.3,
    Min = 0.1,
    Max = 2,
    Callback = function(value)
        AttackDelay = value
    end
})

Settings:Slider({
    Title = "Follow Distance",
    Default = 5,
    Min = 3,
    Max = 15,
    Callback = function(value)
        FollowDistance = value
    end
})

Settings:Slider({
    Title = "Attack Range",
    Default = 10,
    Min = 5,
    Max = 20,
    Callback = function(value)
        AttackRange = value
    end
})

Settings:Button({
    Title = "Refresh Brainrot Cache",
    Callback = function()
        UpdateBrainrotCache()
        WindUI:Notify({
            Title = "Cache Refreshed",
            Content = "Brainrot cache updated",
            Duration = 2,
        })
    end
})

local Status = Window:Tab({
    Title = "Status",
    Icon = "info"
})

local statusLabel = Status:Label({
    Title = "Status: Inactive",
    Desc = "Waiting for activation..."
})

task.spawn(function()
    while true do
        if AutoHit then
            statusLabel:Set({
                Title = "Status: Teleport Mode Active",
                Desc = "Teleporting to nearest brainrot"
            })
        elseif AutoFollowHit then
            if CurrentTarget then
                statusLabel:Set({
                    Title = "Status: Following " .. CurrentTarget.Name,
                    Desc = "Follow mode active"
                })
            else
                statusLabel:Set({
                    Title = "Status: Follow Mode - Searching",
                    Desc = "Looking for brainrots"
                })
            end
        else
            statusLabel:Set({
                Title = "Status: Inactive",
                Desc = "Waiting for activation..."
            })
        end
        task.wait(1)
    end
end)

-- PvB Script Tab (Dyumra Open Source Style Integration)
local PvBTab = Window:Tab({
    Title = "PvB Scripts",
    Icon = "sword", -- bisa diganti sesuai ikon yang kamu mau
})

-- Variabel fitur PvB
local PvB_AutoPunch = false
local PvB_SkillSpam = false
local PvB_AutoFarm = false
local PvB_ESP = false
local highlights = {}

-- Konfigurasi
local PvB_Settings = {
    NPC_FOLDER_NAME = "Mobs",
    AUTO_PUNCH_DELAY = 0.12,
    SKILL_SPAM_DELAY = 0.35,
    AUTO_FARM_MOVE_DIST = 3,
}

-- Fungsi umum
local function getNPCList()
    local folder = workspace:FindFirstChild(PvB_Settings.NPC_FOLDER_NAME) or workspace
    local list = {}
    for _, v in pairs(folder:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local owner = game.Players:GetPlayerFromCharacter(v)
            if not owner then
                table.insert(list, v)
            end
        end
    end
    return list
end

-- ESP Helper
local function addESP(model)
    if highlights[model] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "PvBHighlight"
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    highlight.Parent = workspace
    highlights[model] = highlight
end

local function removeAllESP()
    for _, v in pairs(highlights) do
        if v and v.Parent then v:Destroy() end
    end
    highlights = {}
end

-- Attack dan Skill
local lastPunch, lastSkill = 0, 0

local function doPunch()
    if tick() - lastPunch < PvB_Settings.AUTO_PUNCH_DELAY then return end
    lastPunch = tick()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function() tool:Activate() end)
    end
end

local function doSkill()
    if tick() - lastSkill < PvB_Settings.SKILL_SPAM_DELAY then return end
    lastSkill = tick()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function()
            if tool:FindFirstChild("RemoteEvent") then
                tool.RemoteEvent:FireServer("Skill")
            else
                tool:Activate()
            end
        end)
    end
end

-- AutoFarm
local function getNearestNPC()
    local npcs = getNPCList()
    local nearest, dist = nil, math.huge
    for _, npc in pairs(npcs) do
        local hrp = npc:FindFirstChild("HumanoidRootPart")
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local mag = (RootPart.Position - hrp.Position).Magnitude
            if mag < dist then
                nearest = npc
                dist = mag
            end
        end
    end
    return nearest, dist
end

local function farmStep()
    local target, d = getNearestNPC()
    if target and target:FindFirstChild("HumanoidRootPart") then
        local hrp = target.HumanoidRootPart
        if d > PvB_Settings.AUTO_FARM_MOVE_DIST then
            RootPart.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 0, PvB_Settings.AUTO_FARM_MOVE_DIST))
        else
            doPunch()
        end
    end
end

-- Loop
game:GetService("RunService").Heartbeat:Connect(function()
    if PvB_AutoPunch then
        doPunch()
    end
    if PvB_SkillSpam then
        doSkill()
    end
    if PvB_AutoFarm then
        farmStep()
    end
    if PvB_ESP then
        for _, m in pairs(getNPCList()) do
            if not highlights[m] then
                addESP(m)
            end
        end
    end
end)

-- Toggle di WindUI
PvBTab:Toggle({
    Title = "Auto Punch",
    Default = false,
    Callback = function(state)
        PvB_AutoPunch = state
    end
})

PvBTab:Toggle({
    Title = "Skill Spam",
    Default = false,
    Callback = function(state)
        PvB_SkillSpam = state
    end
})

PvBTab:Toggle({
    Title = "Auto Farm (Basic)",
    Default = false,
    Callback = function(state)
        PvB_AutoFarm = state
    end
})

PvBTab:Toggle({
    Title = "ESP Mobs",
    Default = false,
    Callback = function(state)
        PvB_ESP = state
        if not state then
            removeAllESP()
        end
    end
})

PvBTab:Slider({
    Title = "Auto Punch Delay",
    Default = PvB_Settings.AUTO_PUNCH_DELAY,
    Min = 0.05,
    Max = 1,
    Callback = function(value)
        PvB_Settings.AUTO_PUNCH_DELAY = value
    end
})

PvBTab:Slider({
    Title = "Skill Spam Delay",
    Default = PvB_Settings.SKILL_SPAM_DELAY,
    Min = 0.1,
    Max = 1,
    Callback = function(value)
        PvB_Settings.SKILL_SPAM_DELAY = value
    end
})

PvBTab:Slider({
    Title = "Auto Farm Distance",
    Default = PvB_Settings.AUTO_FARM_MOVE_DIST,
    Min = 1,
    Max = 10,
    Callback = function(value)
        PvB_Settings.AUTO_FARM_MOVE_DIST = value
    end
})

PvBTab:Button({
    Title = "Remove All ESP",
    Callback = function()
        removeAllESP()
        WindUI:Notify({
            Title = "ESP Cleared",
            Content = "All highlights removed!",
            Duration = 2,
        })
    end
})
