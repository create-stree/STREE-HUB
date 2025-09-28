local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Plants Vs Brainrot",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            if not themes then
                themes = {"Dark","Light","Green","Red"}
                currentThemeIndex = 1
            end
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
        end,
    },
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0,255,0),
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

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HeldToolName = "Bat"
local AutoFarm = false
local autoClicking = false
local AttackDelayInput = 0.5

local function EquipBat()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        local tool = backpack:FindFirstChild(HeldToolName)
        if tool then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end

local function GetNearestBrainrot()
    local nearest, dist = nil, math.huge
    local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name == "Brainrot" then
            local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

local function InstantWarpToBrainrot(brainrot)
    local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
    if hrp and brainrot and brainrot:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = brainrot.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
    end
end

local function AttackBrainrot(brainrot)
    if Character and Character:FindFirstChild(HeldToolName) then
        if UserInputService.TouchEnabled then
            VirtualUser:Button1Down(Vector2.new(0,0))
            task.wait(tonumber(AttackDelayInput) or 0.5)
            VirtualUser:Button1Up(Vector2.new(0,0))
        else
            VirtualUser:Button1Down(Vector2.new(0,0))
            task.wait(tonumber(AttackDelayInput) or 0.5)
            VirtualUser:Button1Up(Vector2.new(0,0))
        end
    end
end

Tab2:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        AutoFarm = state
        autoClicking = state
        if state then
            EquipBat()
            task.spawn(function()
                while autoClicking do
                    if Character and Character:FindFirstChild(HeldToolName) then
                        AttackBrainrot()
                    end
                    task.wait(tonumber(AttackDelayInput) or 0.5)
                end
            end)
            task.spawn(function()
                while AutoFarm do
                    if Character and not Character:FindFirstChild(HeldToolName) then
                        EquipBat()
                    end
                    task.wait(1)
                end
            end)
            task.spawn(function()
                while AutoFarm do
                    local nearest = GetNearestBrainrot()
                    if nearest then
                        InstantWarpToBrainrot(nearest)
                        AttackBrainrot(nearest)
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
