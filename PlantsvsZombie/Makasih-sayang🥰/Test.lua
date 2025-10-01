local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local AutoHitBrainrot = false
local AutoEquipBatToggle = false
local AutoCollectToggle = false
local autoClicking = false
local player = game.Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local HeldToolName = "Bat"
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local AttackDelayInput = 0.5

local function EquipBat()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        local bat = backpack:FindFirstChild(HeldToolName)
        if bat then
            local humanoid = Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:EquipTool(bat)
                return true
            end
        end
    end
    return false
end

local function AutoEquipBat()
    if AutoEquipBatToggle then
        if not Character:FindFirstChild(HeldToolName) then
            local backpack = player:FindFirstChildOfClass("Backpack")
            if backpack then
                local bat = backpack:FindFirstChild(HeldToolName)
                if bat then
                    local humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:EquipTool(bat)
                        return true
                    end
                end
            end
        else
            return true
        end
    end
    return false
end

local brainrotsCache = {}
local function UpdateBrainrotsCache()
    brainrotsCache = {}
    for _, enemy in ipairs(workspace:GetDescendants()) do
        if enemy.Name:lower():find("brainrot") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            table.insert(brainrotsCache, enemy)
        end
    end
end

local function GetNearestBrainrot()
    local nearest = nil
    local minDistance = math.huge
    local charRoot = Character:FindFirstChild("HumanoidRootPart")
    if not charRoot then return nil end
    for _, enemy in ipairs(brainrotsCache) do
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if root and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (charRoot.Position - root.Position).Magnitude
            if distance < minDistance then
                nearest = enemy
                minDistance = distance
            end
        end
    end
    return nearest
end

local function InstantWarpToBrainrot(target)
    local charRoot = Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if charRoot and targetRoot then
        charRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
    end
end

local function AttackBrainrot(target)
    if Character:FindFirstChild(HeldToolName) then
        if UserInputService.TouchEnabled then
            VirtualUser:Button1Down(Vector2.new(0,0))
            task.wait(0.1)
            VirtualUser:Button1Up(Vector2.new(0,0))
        else
            mouse1click()
        end
    end
end

local function CollectNearestDrops()
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local root = Character.HumanoidRootPart
    for _, drop in ipairs(workspace:GetDescendants()) do
        if drop:IsA("BasePart") and drop.Name:lower():find("coin") or drop.Name:lower():find("drop") then
            if (drop.Position - root.Position).Magnitude < 20 then
                root.CFrame = drop.CFrame
            end
        end
    end
end

player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    task.wait(2)
    if AutoHitBrainrot then
        AutoEquipBat()
        UpdateBrainrotsCache()
    end
    if AutoEquipBatToggle then
        AutoEquipBat()
    end
end)

workspace.ChildAdded:Connect(function(child)
    if AutoHitBrainrot and child.Name:lower():find("brainrot") then
        task.wait(1)
        UpdateBrainrotsCache()
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if AutoHitBrainrot and child.Name:lower():find("brainrot") then
        UpdateBrainrotsCache()
    end
end)

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Plants Vs Zombie",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end,
    },
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0, 255, 0),
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info"
})

local Section = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab1:Button({
    Title = "Discord",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app")
        end
    end
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

Tab2:Toggle({
    Title = "Auto Equip Bat",
    Default = false,
    Callback = function(state)
        AutoEquipBatToggle = state
        if state then
            EquipBat()
            task.spawn(function()
                while AutoEquipBatToggle do
                    AutoEquipBat()
                    task.wait(1)
                end
            end)
        end
    end
})

Tab2:Toggle({
    Title = "Auto Hit Brainrot",
    Default = false,
    Callback = function(state)
        AutoHitBrainrot = state
        autoClicking = state
        if state then
            AutoEquipBat()
            UpdateBrainrotsCache()
            task.spawn(function()
                while autoClicking do
                    if Character:FindFirstChild(HeldToolName) then
                        if UserInputService.TouchEnabled then
                            VirtualUser:Button1Down(Vector2.new(0,0))
                            task.wait(0.1)
                            VirtualUser:Button1Up(Vector2.new(0,0))
                        else
                            mouse1click()
                        end
                    end
                    task.wait(tonumber(AttackDelayInput) or 0.5)
                end
            end)
            task.spawn(function()
                while AutoHitBrainrot do
                    local nearest = GetNearestBrainrot()
                    if nearest then
                        InstantWarpToBrainrot(nearest)
                        task.wait(0.1)
                        AttackBrainrot(nearest)
                    else
                        UpdateBrainrotsCache()
                    end
                    task.wait(tonumber(AttackDelayInput) or 0.5)
                end
                autoClicking = false
            end)
        else
            autoClicking = false
        end
    end
})

local Section = Tab2:Section({
    Title = "Auto Collect",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab2:Toggle({
    Title = "Auto Collect",
    Default = false,
    Callback = function(state)
        AutoCollectToggle = state
        if state then
            task.spawn(function()
                while AutoCollectToggle do
                    CollectNearestDrops()
                    task.wait(0.7)
                end
            end)
        end
    end
})

local Tab3 = Window:Tab({
    Title = "Shop",
    Icon = "shopping-cart"
})

local Tab4 = Window:Tab({
    Title = "Sell",
    Icon = "badge-dollar-sign"
})

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})
