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
    Author = "KirsiaSC | Plants Vs Brainrot",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },
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

local TabPvB = Window:Tab({
    Title = "PvB",
    Icon = "skull",
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local autoHit = false
local autoCollect = false
local autoEquip = false
local espEnabled = false

local function getBrainrots()
    local list = {}
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "Brainrot" and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            table.insert(list, v)
        end
    end
    return list
end

local function equipBat()
    for _, tool in ipairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), "bat") then
            humanoid:EquipTool(tool)
        end
    end
end

local function autoHitLoop()
    task.spawn(function()
        while autoHit do
            local brainrots = getBrainrots()
            for _, b in ipairs(brainrots) do
                if b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
                    local hrp = b:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        root.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            firetouchinterest(hrp, tool.Handle, 0)
                            firetouchinterest(hrp, tool.Handle, 1)
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

local function autoCollectLoop()
    task.spawn(function()
        while autoCollect do
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("BasePart") and v.Name == "Collectable" then
                    firetouchinterest(root, v, 0)
                    firetouchinterest(root, v, 1)
                end
            end
            task.wait(0.4)
        end
    end)
end

local function espLoop()
    task.spawn(function()
        while espEnabled do
            for _, b in ipairs(getBrainrots()) do
                if not b:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.Parent = b
                end
            end
            task.wait(1)
        end
        for _, b in ipairs(getBrainrots()) do
            if b:FindFirstChild("Highlight") then
                b.Highlight:Destroy()
            end
        end
    end)
end

TabPvB:Toggle({
    Title = "Auto Hit Brainrot",
    Default = false,
    Callback = function(state)
        autoHit = state
        if state then
            autoHitLoop()
        end
    end,
})

TabPvB:Toggle({
    Title = "Auto Collect",
    Default = false,
    Callback = function(state)
        autoCollect = state
        if state then
            autoCollectLoop()
        end
    end,
})

TabPvB:Toggle({
    Title = "Auto Equip Bat",
    Default = false,
    Callback = function(state)
        autoEquip = state
        if state then
            task.spawn(function()
                while autoEquip do
                    equipBat()
                    task.wait(2)
                end
            end)
        end
    end,
})

TabPvB:Toggle({
    Title = "ESP Brainrot",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            espLoop()
        end
    end,
})
