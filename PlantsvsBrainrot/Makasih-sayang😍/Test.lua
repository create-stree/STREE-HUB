repeat task.wait() until game:IsLoaded()
if setfpscap then
    setfpscap(1000000)
else
    warn("Your exploit does not support setfpscap.")
end

local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ WindUI loaded successfully!")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Backpack = LocalPlayer:WaitForChild("Backpack")

local AutoCollect = false
local AutoFarm = false
local autoClicking = false
local AutoCollectDelay = 60
local ClickInterval = 0.25
local HeldToolName = "Basic Bat"
local SellPlant = false
local SellBrainrot = false
local serverStartTime = os.time()

local shop = {
    seedList = {
        "Cactus Seed","Strawberry Seed","Pumpkin Seed","Sunflower Seed","Dragon Seed","Eggplant Seed","Watermelon Seed","Cocotank Seed","Carnivorous Plant Seed","Mr Carrot Seed","Tomatrio Seed","Shroombino Seed"
    },
    gearList = {
        "Water Bucket","Frost Grenade","Banana Gun","Frost Blower","Carrot Launcher"
    }
}

local selectedSeeds = {}
local selectedGears = {}
local AutoBuySelectedSeed = false
local AutoBuySelectedGear = false
local AutoBuyAllSeed = false
local AutoBuyAllGear = false

local function GetMyPlot()
    for _, plot in ipairs(Workspace.Plots:GetChildren()) do
        local playerSign = plot:FindFirstChild("PlayerSign")
        if playerSign then
            local bg = playerSign:FindFirstChild("BillboardGui")
            local textLabel = bg and bg:FindFirstChild("TextLabel")
            if textLabel and (textLabel.Text == LocalPlayer.Name or textLabel.Text == LocalPlayer.DisplayName) then
                return plot
            end
        end
    end
    return nil
end

local function GetMyPlotName()
    local plot = GetMyPlot()
    return plot and plot.Name or "No Plot"
end

local function GetMoney()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    return leaderstats and leaderstats:FindFirstChild("Money") and leaderstats.Money.Value or 0
end

local function GetRebirth()
    local gui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
    if gui and gui:FindFirstChild("Rebirth") then
        local text = gui.Rebirth.Frame.Title.Text or "Rebirth 0"
        local n = tonumber(text:match("%d+")) or 0
        return math.max(0, n - 1)
    end
    return 0
end

local function FormatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function GetBridgeNet2()
    return ReplicatedStorage:FindFirstChild("BridgeNet2")
end

local function GetRemotesFolder()
    return ReplicatedStorage:FindFirstChild("Remotes")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Plants Vs Brainrot",
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

Window:EditOpenButton({
    Title = "STREE HUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Main = Window:Tab({Title = "Main", Icon = "house"})
local Sell = Window:Tab({Title = "Sell", Icon = "dollar-sign"})
local Shop = Window:Tab({Title = "Shop", Icon = "shopping-cart"})
local Collect = Window:Tab({Title = "Auto", Icon = "crown"})
Window:Divider()
local InfoTab = Window:Tab({ Title = "Info", Icon = "info"})
Window:SelectTab(1)

Main:Section({ Title = "Auto Farm", Icon = "crown" })
Main:Section({ Title = "Use on PRIVATE SERVERS only!", Icon = "badge-alert" })

local BrainrotsCache = {}
local function UpdateBrainrotsCache()
    local ok, folder = pcall(function()
        return Workspace:WaitForChild("ScriptedMap"):WaitForChild("Brainrots")
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
        if hitbox then
            local dist = (HumanoidRootPart.Position - hitbox.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = b
            end
        end
    end
    return nearest
end

local function EquipBat()
    local tool = Backpack:FindFirstChild(HeldToolName) or Character:FindFirstChild(HeldToolName)
    if tool then tool.Parent = Character end
end

local function InstantWarpToBrainrot(brainrot)
    local hitbox = brainrot and brainrot:FindFirstChild("BrainrotHitbox")
    if hitbox then
        local offset = Vector3.new(0, 1, 3)
        HumanoidRootPart.CFrame = CFrame.new(hitbox.Position + offset, hitbox.Position)
    end
end

local function DoClick()
    pcall(function()
        VirtualUser:Button1Down(Vector2.new(0, 0))
        task.wait(0.03)
        VirtualUser:Button1Up(Vector2.new(0, 0))
    end)
end

Main:Toggle({
    Title = "Auto Farm",
    Desc  = "Automatically Attacks the BRAINROTS",
    Default = false,
    Callback = function(v)
        AutoFarm = v
        autoClicking = v
        if v then
            EquipBat()
            UpdateBrainrotsCache()
            task.spawn(function()
                while autoClicking do
                    if Character and Character:FindFirstChild(HeldToolName) then
                        DoClick()
                    end
                    task.wait(ClickInterval)
                end
            end)
            task.spawn(function()
                while AutoFarm do
                    if Character and not Character:FindFirstChild(HeldToolName) then
                        EquipBat()
                    end
                    task.wait(0.5)
                end
            end)
            task.spawn(function()
                while AutoFarm do
                    UpdateBrainrotsCache()
                    task.wait(1)
                end
            end)
            task.spawn(function()
                while AutoFarm do
                    local currentTarget = GetNearestBrainrot()
                    if not currentTarget then
                        task.wait(0.5)
                        continue
                    end
                    if currentTarget and currentTarget:FindFirstChild("BrainrotHitbox") then
                        InstantWarpToBrainrot(currentTarget)
                        pcall(function()
                            local remotes = GetRemotesFolder()
                            if remotes and remotes:FindFirstChild("AttacksServer") and remotes.AttacksServer:FindFirstChild("WeaponAttack") then
                                remotes.AttacksServer.WeaponAttack:FireServer({ { target = currentTarget.BrainrotHitbox } })
                            else
                                ReplicatedStorage.Remotes.AttacksServer.WeaponAttack:FireServer({ { target = currentTarget.BrainrotHitbox } })
                            end
                        end)
                    end
                    task.wait(ClickInterval)
                end
            end)
        else
            autoClicking = false
        end
    end
})
