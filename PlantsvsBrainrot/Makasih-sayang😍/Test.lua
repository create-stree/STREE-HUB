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
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local AutoEquip = false
local AutoHit = false
local AutoCollect = false

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
        return true
    end
    return false
end

local function GetNearestBrainrot()
    local nearest, dist = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:FindFirstChild("Humanoid") and v.Name:lower():find("brainrot") and v.Humanoid.Health > 0 then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            if hrp then
                local mag = (RootPart.Position - hrp.Position).Magnitude
                if mag < dist then
                    dist = mag
                    nearest = v
                end
            end
        end
    end
    return nearest
end

local function AttackBrainrot()
    if UIS.TouchEnabled then
        VirtualUser:Button1Down(Vector2.new(0, 0))
        task.wait(0.1)
        VirtualUser:Button1Up(Vector2.new(0, 0))
    else
        pcall(function()
            mouse1click()
        end)
    end
end

local function CollectBrains()
    local hrp = RootPart
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Parent and obj.Parent.Name:lower():find("brain") then
            pcall(function()
                firetouchinterest(hrp, obj.Parent, 0)
                firetouchinterest(hrp, obj.Parent, 1)
            end)
        end
    end
end

player.CharacterAdded:Connect(function(char)
    Character = char
    task.wait(2)
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Plants Vs Zombie",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
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
    Title = "Free",
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
    Title = "Auto Hit Brainrot",
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
                task.wait(0.4)
            end
        end)
    end
})

Main:Toggle({
    Title = "Auto Collect",
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
