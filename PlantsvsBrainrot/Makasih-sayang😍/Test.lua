local success, MacLib = pcall(function()
    return loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
end)
if not success or not MacLib then
    warn("⚠️ Maclib UI failed to load!")
    return
else
    print("✓ Maclib UI loaded successfully!")
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

-- Create Maclib UI Window
local Window = MacLib:Window({
    Title = "STREE HUB",
    Subtitle = "Plants Vs Brainrot",
    Size = UDim2.fromOffset(500, 400),
    DragStyle = 1,
    ShowUserInfo = true,
    AcrylicBlur = false
})

-- Create notification
Window:Notify({
    Title = "STREE HUB Loaded",
    Description = "UI loaded successfully!",
    Lifetime = 3
})

-- Create Tab Group
local TabGroup = Window:TabGroup()

-- Create Tabs
local MainTab = TabGroup:Tab({
    Name = "Main",
    Image = "rbxassetid://122683047852451"
})

local SellTab = TabGroup:Tab({
    Name = "Sell",
    Image = "rbxassetid://122683047852451"
})

local ShopTab = TabGroup:Tab({
    Name = "Shop", 
    Image = "rbxassetid://122683047852451"
})

local CollectTab = TabGroup:Tab({
    Name = "Auto",
    Image = "rbxassetid://122683047852451"
})

local InfoTab = TabGroup:Tab({
    Name = "Info",
    Image = "rbxassetid://122683047852451"
})

-- Create Sections for Main Tab
local MainSection1 = MainTab:Section({
    Side = "Left"
})

local MainSection2 = MainTab:Section({
    Side = "Right"
})

-- Create Sections for other tabs
local SellSection = SellTab:Section({
    Side = "Left"
})

local ShopSection1 = ShopTab:Section({
    Side = "Left"
})

local ShopSection2 = ShopTab:Section({
    Side = "Right"
})

local CollectSection = CollectTab:Section({
    Side = "Left"
})

local InfoSection = InfoTab:Section({
    Side = "Left"
})

-- Brainrots Cache and Functions
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

-- Main Tab Elements
MainSection1:Label("Auto Farm Features")
MainSection1:Label("Use on PRIVATE SERVERS only!")

MainSection1:Toggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        AutoFarm = value
        autoClicking = value
        if value then
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
            Window:Notify({
                Title = "STREE HUB",
                Description = "Auto Farm Enabled"
            })
        else
            autoClicking = false
            Window:Notify({
                Title = "STREE HUB",
                Description = "Auto Farm Disabled"
            })
        end
    end
}, "AutoFarmToggle")

MainSection1:Slider({
    Name = "Click Interval",
    Default = 0.25,
    Minimum = 0.1,
    Maximum = 1,
    Callback = function(value)
        ClickInterval = value
    end
}, "ClickIntervalSlider")

-- Collect Tab Elements
CollectSection:Toggle({
    Name = "Auto Collect",
    Default = false,
    Callback = function(value)
        AutoCollect = value
        if value then
            task.spawn(function()
                while AutoCollect do
                    pcall(function()
                        local plot = GetMyPlot()
                        if plot then
                            -- Add your auto collect logic here
                            print("Auto collecting from plot...")
                        end
                    end)
                    task.wait(AutoCollectDelay)
                end
            end)
            Window:Notify({
                Title = "STREE HUB",
                Description = "Auto Collect Enabled"
            })
        else
            Window:Notify({
                Title = "STREE HUB",
                Description = "Auto Collect Disabled"
            })
        end
    end
}, "AutoCollectToggle")

CollectSection:Slider({
    Name = "Collect Delay",
    Default = 60,
    Minimum = 10,
    Maximum = 300,
    Callback = function(value)
        AutoCollectDelay = value
    end
}, "CollectDelaySlider")

-- Sell Tab Elements
SellSection:Toggle({
    Name = "Sell Plants",
    Default = false,
    Callback = function(value)
        SellPlant = value
        Window:Notify({
            Title = "STREE HUB",
            Description = (value and "Enabled " or "Disabled ") .. "Sell Plants"
        })
    end
}, "SellPlantsToggle")

SellSection:Toggle({
    Name = "Sell Brainrots",
    Default = false,
    Callback = function(value)
        SellBrainrot = value
        Window:Notify({
            Title = "STREE HUB",
            Description = (value and "Enabled " or "Disabled ") .. "Sell Brainrots"
        })
    end
}, "SellBrainrotsToggle")

-- Shop Tab Elements
ShopSection1:Label("Auto Buy Seeds")

ShopSection1:Dropdown({
    Name = "Select Seed",
    Search = true,
    Multi = false,
    Required = true,
    Options = shop.seedList,
    Default = "Cactus Seed",
    Callback = function(value)
        selectedSeed = value
    end
}, "SeedDropdown")

ShopSection1:Toggle({
    Name = "Auto Buy Selected Seed",
    Default = false,
    Callback = function(value)
        AutoBuySelectedSeed = value
        Window:Notify({
            Title = "STREE HUB",
            Description = (value and "Enabled " or "Disabled ") .. "Auto Buy Selected Seed"
        })
    end
}, "AutoBuySeedToggle")

ShopSection1:Toggle({
    Name = "Auto Buy All Seeds", 
    Default = false,
    Callback = function(value)
        AutoBuyAllSeed = value
        Window:Notify({
            Title = "STREE HUB",
            Description = (value and "Enabled " or "Disabled ") .. "Auto Buy All Seeds"
        })
    end
}, "AutoBuyAllSeedsToggle")

ShopSection2:Label("Auto Buy Gears")

ShopSection2:Dropdown({
    Name = "Select Gear",
    Search = true,
    Multi = false,
    Required = true,
    Options = shop.gearList,
    Default = "Water Bucket",
    Callback = function(value)
        selectedGear = value
    end
}, "GearDropdown")

ShopSection2:Toggle({
    Name = "Auto Buy Selected Gear",
    Default = false,
    Callback = function(value)
        AutoBuySelectedGear = value
        Window:Notify({
            Title = "STREE HUB",
            Description = (value and "Enabled " or "Disabled ") .. "Auto Buy Selected Gear"
        })
    end
}, "AutoBuyGearToggle")

ShopSection2:Toggle({
    Name = "Auto Buy All Gears",
    Default = false,
    Callback = function(value)
        AutoBuyAllGear = value
        Window:Notify({
            Title = "STREE HUB",
            Description = (value and "Enabled " or "Disabled ") .. "Auto Buy All Gears"
        })
    end
}, "AutoBuyAllGearsToggle")

-- Info Tab Elements
InfoSection:Label("Player Information:")
InfoSection:Label("Money: " .. GetMoney())
InfoSection:Label("Rebirth: " .. GetRebirth())
InfoSection:Label("Plot: " .. GetMyPlotName())
InfoSection:Label("Server Time: " .. FormatTime(os.time() - serverStartTime))

InfoSection:Divider()

InfoSection:Button({
    Name = "Refresh Info",
    Callback = function()
        Window:Notify({
            Title = "STREE HUB",
            Description = "Information Refreshed",
            Lifetime = 2
        })
        -- Note: In Maclib, you might need to recreate the labels to update them
    end
})

-- Update info periodically (you'll need to handle label updates differently in Maclib)
task.spawn(function()
    while true do
        task.wait(10)
        -- Maclib doesn't have direct label updating, so this is for internal state only
        local currentMoney = GetMoney()
        local currentRebirth = GetRebirth()
        local currentPlot = GetMyPlotName()
        local currentTime = FormatTime(os.time() - serverStartTime)
        
        -- You can store these values for display if needed
    end
end)

print("✓ STREE HUB fully loaded!")
