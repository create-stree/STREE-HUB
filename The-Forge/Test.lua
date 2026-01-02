local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Packages = Shared:WaitForChild("Packages")
local Knit = require(Packages.Knit)
local Utils = require(Shared:WaitForChild("Utils"))
local Data = Shared:WaitForChild("Data")
local Ore = require(Data:WaitForChild("Ore"))

local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/Fluriore-UI/main/source.lua"))()
end)

if not success or not Library then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = Library:MakeGui({
    NameHub = "The Forge Automation",
    Description = "By Nisulrocks | V1.0",
    Color = Color3.fromRGB(0, 255, 200)
})

local Tab1 = Window:CreateTab({
    Name = "Main Farm",
    Icon = "rbxassetid://16932740082"
})

local Array = {}
local RocksFolder = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Rocks")
if RocksFolder then
    for _, v in ipairs(RocksFolder:GetChildren()) do
        if v.Name and v.Name ~= "" then
            table.insert(Array, v.Name)
        end
    end
end

if #Array == 0 then
    warn("[Forge] No rock templates found in ReplicatedStorage.Assets.Rocks")
    table.insert(Array, "Boulder")
end

local OresArray = {"Any"}
local Success, OreList = pcall(function()
    return Utils.FormArrayFromNames(Ore)
end)

if Success and typeof(OreList) == "table" then
    for _, v in ipairs(OreList) do
        if typeof(v) == "string" then
            table.insert(OresArray, v)
        end
    end
end

local Forge_ScanDistance = 300
local Forge_TweenSpeed = 40
local Forge_RockTypes = {"Boulder"}
local Forge_OreTypes = {"Any"}
local Forge_MaxRockTime = 4
local Forge_MineInterval = 0.1
local Forge_RocksESP = false
local Forge_AutoFarmOres = false
local Forge_MobTypes = {"Zombie"}
local Forge_MobSafeHP = 30
local Forge_AutoFarmMobs = false
local Forge_MobsESP = false

local Section1 = Tab1:AddSection("Movement Settings")

Section1:AddSlider({
    Title = "Scan Distance",
    Content = "Distance to scan for rocks and ores",
    Min = 100,
    Max = 500,
    Default = 300,
    Callback = function(value)
        Forge_ScanDistance = value
    end
})

Section1:AddSlider({
    Title = "Tween Speed",
    Content = "Movement speed between targets",
    Min = 30,
    Max = 100,
    Default = 40,
    Callback = function(value)
        Forge_TweenSpeed = value
    end
})

local Section2 = Tab1:AddSection("Auto Farm Ores")

local RockDropdown = Section2:AddDropdown({
    Title = "Rock Types to Farm",
    Content = "Select which rock types to target",
    Multi = true,
    Options = Array,
    Default = {"Boulder"},
    Callback = function(selected)
        Forge_RockTypes = selected
    end
})

Section2:AddButton({
    Title = "Refresh Rock Types",
    Content = "Refresh available rock types",
    Callback = function()
        local NewArray = {}
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local Rocks = Assets and Assets:FindFirstChild("Rocks")
        if Rocks then
            for _, v in ipairs(Rocks:GetChildren()) do
                if v.Name and v.Name ~= "" then
                    table.insert(NewArray, v.Name)
                end
            end
        end
        if #NewArray == 0 then
            table.insert(NewArray, "Boulder")
        end
        RockDropdown:UpdateOptions(NewArray)
    end
})

Section2:AddDropdown({
    Title = "Ore Types to Farm",
    Content = "Select which ore types to collect",
    Multi = true,
    Options = OresArray,
    Default = {"Any"},
    Callback = function(selected)
        Forge_OreTypes = selected
    end
})

Section2:AddSlider({
    Title = "Max Time Per Rock (s)",
    Content = "Maximum time to spend on each rock",
    Min = 1,
    Max = 20,
    Default = 4,
    Callback = function(value)
        Forge_MaxRockTime = value
    end
})

Section2:AddSlider({
    Title = "Mine Interval (s)",
    Content = "Delay between mining actions",
    Min = 0.02,
    Max = 0.5,
    Default = 0.1,
    Callback = function(value)
        Forge_MineInterval = value
    end
})

Section2:AddToggle({
    Title = "Rocks ESP",
    Content = "Show visual indicators for rocks",
    Default = false,
    Callback = function(value)
        Forge_RocksESP = value
        if value then
            spawn(function()
                local Character = LocalPlayer.Character
                if not Character then return end
                local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                
                local RocksFolder = workspace:FindFirstChild("Rocks")
                if not RocksFolder then return end
                
                for _, rock in ipairs(RocksFolder:GetChildren()) do
                    for _, part in ipairs(rock:GetChildren()) do
                        if part:IsA("BasePart") and part:GetAttribute("Health") then
                            local Boulder = part:FindFirstChild("Boulder")
                            if Boulder then
                                local Highlight = Instance.new("Highlight")
                                Highlight.FillColor = Color3.fromRGB(0, 255, 200)
                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                                Highlight.FillTransparency = 0.2
                                Highlight.OutlineTransparency = 0
                                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                Highlight.Enabled = true
                                Highlight.Adornee = Boulder
                                Highlight.Parent = workspace
                                
                                local BillboardGui = Instance.new("BillboardGui")
                                BillboardGui.Size = UDim2.new(0, 150, 0, 50)
                                BillboardGui.Adornee = part
                                BillboardGui.AlwaysOnTop = true
                                BillboardGui.MaxDistance = 1000
                                BillboardGui.StudsOffset = Vector3.new(0, 5, 0)
                                BillboardGui.Parent = part
                                
                                local Frame = Instance.new("Frame")
                                Frame.Size = UDim2.new(1, 0, 1, 0)
                                Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                                Frame.BackgroundTransparency = 0.3
                                Frame.BorderSizePixel = 0
                                Frame.Parent = BillboardGui
                                
                                local UICorner = Instance.new("UICorner")
                                UICorner.CornerRadius = UDim.new(0, 8)
                                UICorner.Parent = Frame
                                
                                local TextLabel = Instance.new("TextLabel")
                                TextLabel.Size = UDim2.new(1, -10, 0.6, 0)
                                TextLabel.Position = UDim2.new(0, 5, 0.1, 0)
                                TextLabel.BackgroundTransparency = 1
                                TextLabel.Text = "⛏️ " .. tostring(part:GetAttribute("RockType") or "Rock")
                                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                TextLabel.TextStrokeTransparency = 0.5
                                TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                TextLabel.TextScaled = true
                                TextLabel.Font = Enum.Font.GothamBold
                                TextLabel.Parent = Frame
                                
                                local TextLabel2 = Instance.new("TextLabel")
                                TextLabel2.Size = UDim2.new(1, -10, 0.3, 0)
                                TextLabel2.Position = UDim2.new(0, 5, 0.65, 0)
                                TextLabel2.BackgroundTransparency = 1
                                TextLabel2.TextColor3 = Color3.fromRGB(100, 255, 200)
                                TextLabel2.TextStrokeTransparency = 0.5
                                TextLabel2.TextScaled = true
                                TextLabel2.Font = Enum.Font.Gotham
                                TextLabel2.Parent = Frame
                                
                                local function UpdateDistance()
                                    if not HumanoidRootPart or not part then return end
                                    local distance = (part.Position - HumanoidRootPart.Position).Magnitude
                                    TextLabel2.Text = string.format("%.0f studs", distance)
                                end
                                
                                game:GetService("RunService").Heartbeat:Connect(UpdateDistance)
                            end
                        end
                    end
                end
            end)
        else
            for _, highlight in ipairs(workspace:GetChildren()) do
                if highlight:IsA("Highlight") then
                    highlight:Destroy()
                end
            end
            for _, billboard in ipairs(workspace:GetDescendants()) do
                if billboard:IsA("BillboardGui") then
                    billboard:Destroy()
                end
            end
        end
    end
})

local PickaxeParagraph = Section2:AddParagraph({
    Title = "Pickaxe Info",
    Content = "Name: None\nDamage: 0"
})

Section2:AddToggle({
    Title = "Auto Farm Ores",
    Content = "Enable automatic ore farming",
    Default = false,
    Callback = function(value)
        Forge_AutoFarmOres = value
        if value then
            spawn(function()
                while Forge_AutoFarmOres do
                    local Character = LocalPlayer.Character
                    if not Character then 
                        task.wait(1)
                        continue 
                    end
                    
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                    if not HumanoidRootPart then 
                        task.wait(1)
                        continue 
                    end
                    
                    local RocksFolder = workspace:FindFirstChild("Rocks")
                    if not RocksFolder then 
                        task.wait(1)
                        continue 
                    end
                    
                    local TargetRock = nil
                    local ShortestDistance = Forge_ScanDistance
                    
                    for _, rock in ipairs(RocksFolder:GetChildren()) do
                        for _, part in ipairs(rock:GetChildren()) do
                            if part:IsA("BasePart") and part:GetAttribute("Health") then
                                local Boulder = part:FindFirstChild("Boulder")
                                if Boulder then
                                    local RockType = part:GetAttribute("RockType")
                                    local Health = part:GetAttribute("Health")
                                    
                                    local shouldFarm = false
                                    if #Forge_RockTypes > 0 then
                                        for _, selectedType in ipairs(Forge_RockTypes) do
                                            if tostring(RockType) == selectedType then
                                                shouldFarm = true
                                                break
                                            end
                                        end
                                    end
                                    
                                    if shouldFarm and Health and Health > 0 then
                                        local distance = (part.Position - HumanoidRootPart.Position).Magnitude
                                        if distance < ShortestDistance then
                                            ShortestDistance = distance
                                            TargetRock = part
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    if TargetRock then
                        local TweenInfo = TweenInfo.new(ShortestDistance / Forge_TweenSpeed, Enum.EasingStyle.Linear)
                        local Goal = {CFrame = CFrame.new(TargetRock.Position + Vector3.new(0, 3, 0))}
                        local Tween = TweenService:Create(HumanoidRootPart, TweenInfo, Goal)
                        Tween:Play()
                        Tween.Completed:Wait()
                        
                        local startTime = tick()
                        while Forge_AutoFarmOres and TargetRock and TargetRock:GetAttribute("Health") and TargetRock:GetAttribute("Health") > 0 do
                            if tick() - startTime > Forge_MaxRockTime then
                                break
                            end
                            
                            local Tool = nil
                            for _, item in ipairs(Character:GetChildren()) do
                                if item:IsA("Tool") then
                                    local ItemName = item:GetAttribute("ItemName") or item.Name
                                    if string.lower(tostring(ItemName)):find("pickaxe") then
                                        Tool = item
                                        break
                                    end
                                end
                            end
                            
                            if Tool then
                                Tool.Parent = Character
                                task.wait(Forge_MineInterval)
                                
                                local RequiredDamage = TargetRock:GetAttribute("RequiredDamage") or 1
                                local CurrentHealth = TargetRock:GetAttribute("Health") or 0
                                TargetRock:SetAttribute("Health", math.max(0, CurrentHealth - RequiredDamage))
                            end
                            
                            task.wait(0.1)
                        end
                    end
                    
                    task.wait(0.5)
                end
            end)
        end
    end
})

local Section3 = Tab1:AddSection("Auto Farm Mobs")

Section3:AddDropdown({
    Title = "Mobs to Farm",
    Content = "Select which mobs to target",
    Multi = true,
    Options = {"Zombie", "Skeleton", "Goblin", "Dragon"},
    Default = {"Zombie"},
    Callback = function(selected)
        Forge_MobTypes = selected
    end
})

Section3:AddSlider({
    Title = "Safe HP % (Mobs)",
    Content = "Health percentage to retreat",
    Min = 0,
    Max = 100,
    Default = 30,
    Callback = function(value)
        Forge_MobSafeHP = value
    end
})

Section3:AddToggle({
    Title = "Auto Farm Mobs",
    Content = "Enable automatic mob farming",
    Default = false,
    Callback = function(value)
        Forge_AutoFarmMobs = value
        if value then
            spawn(function()
                while Forge_AutoFarmMobs do
                    local Character = LocalPlayer.Character
                    if not Character then 
                        task.wait(1)
                        continue 
                    end
                    
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if not Humanoid then 
                        task.wait(1)
                        continue 
                    end
                    
                    local HealthPercent = (Humanoid.Health / Humanoid.MaxHealth) * 100
                    if HealthPercent <= Forge_MobSafeHP then
                        task.wait(1)
                        continue
                    end
                    
                    local Weapon = nil
                    for _, item in ipairs(Character:GetChildren()) do
                        if item:IsA("Tool") and item.Name == "Weapon" then
                            Weapon = item
                            break
                        end
                    end
                    
                    if not Weapon then
                        local Backpack = LocalPlayer:FindFirstChild("Backpack")
                        if Backpack then
                            Weapon = Backpack:FindFirstChild("Weapon")
                        end
                    end
                    
                    if Weapon then
                        Weapon.Parent = Character
                    end
                    
                    task.wait(0.1)
                end
            end)
        end
    end
})

Section3:AddToggle({
    Title = "Mobs ESP",
    Content = "Show visual indicators for mobs",
    Default = false,
    Callback = function(value)
        Forge_MobsESP = value
        if value then
            spawn(function()
                while Forge_MobsESP do
                    local Living = workspace:FindFirstChild("Living")
                    if Living then
                        for _, mob in ipairs(Living:GetChildren()) do
                            if mob:IsA("Model") then
                                local Dead = mob:FindFirstChild("Dead", true)
                                if Dead and Dead:IsA("BoolValue") and not Dead.Value then
                                    local Head = mob:FindFirstChild("Head")
                                    if Head then
                                        local Highlight = Instance.new("Highlight")
                                        Highlight.FillColor = Color3.fromRGB(255, 50, 50)
                                        Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                                        Highlight.FillTransparency = 0.3
                                        Highlight.OutlineTransparency = 0
                                        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                        Highlight.Enabled = true
                                        Highlight.Adornee = Head
                                        Highlight.Parent = workspace
                                        
                                        task.wait(0.1)
                                        Highlight:Destroy()
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local Tab2 = Window:CreateTab({
    Name = "Auto Forge",
    Icon = "rbxassetid://16932740082"
})

local Section4 = Tab2:AddSection("Status")

local ForgeStatus = Section4:AddParagraph({
    Title = "Status",
    Content = "Idle"
})

local AutoForge_ItemType = "Weapon"
local AutoForge_Ores = {}
local AutoForge_OresPerForge = 3
local AutoForge_AutoMinigames = true
local AutoForge_Enable = false

Section4:AddDropdown({
    Title = "Item Type",
    Content = "Select type of item to forge",
    Multi = false,
    Options = {"Weapon", "Armor"},
    Default = {"Weapon"},
    Callback = function(selected)
        AutoForge_ItemType = selected
    end
})

Section4:AddDropdown({
    Title = "Ores to Use",
    Content = "Select ores for forging",
    Multi = true,
    Options = OresArray,
    Default = {},
    Callback = function(selected)
        AutoForge_Ores = selected
    end
})

Section4:AddSlider({
    Title = "Ores Per Forge",
    Content = "Number of ores to use per forging",
    Min = 3,
    Max = 10,
    Default = 3,
    Callback = function(value)
        AutoForge_OresPerForge = math.floor(value)
    end
})

Section4:AddToggle({
    Title = "Auto Complete Minigames",
    Content = "Automatically complete forging minigames",
    Default = true,
    Callback = function(value)
        AutoForge_AutoMinigames = value
    end
})

Section4:AddToggle({
    Title = "Enable Auto Forge",
    Content = "Start automatic forging process",
    Default = false,
    Callback = function(value)
        AutoForge_Enable = value
        if value then
            ForgeStatus:Update({
                Title = "Status",
                Content = "Starting auto forge..."
            })
            
            spawn(function()
                local cycle = 1
                while AutoForge_Enable do
                    ForgeStatus:Update({
                        Title = "Status",
                        Content = "Starting cycle #" .. cycle .. "..."
                    })
                    
                    local UIController = Knit.GetController("UIController")
                    local ForgeController = Knit.GetController("ForgeController")
                    local PlayerController = Knit.GetController("PlayerController")
                    
                    if UIController and ForgeController and PlayerController then
                        local Replica = PlayerController.Replica
                        local PlayerGui = UIController.PlayerGui
                        local ForgeUI = PlayerGui:WaitForChild("Forge", 5)
                        
                        if Replica and ForgeUI and ForgeController.ForgeActive then
                            local Data = Replica.Data
                            local Inventory = Data and Data.Inventory or {}
                            
                            if #AutoForge_Ores == 0 then
                                ForgeStatus:Update({
                                    Title = "Status",
                                    Content = "Error: No ores selected"
                                })
                                task.wait(5)
                            else
                                ForgeStatus:Update({
                                    Title = "Status",
                                    Content = "Forging items..."
                                })
                                
                                if AutoForge_ItemType == "Weapon" then
                                    ForgeController:StartForgeWeapon(AutoForge_Ores[1], AutoForge_OresPerForge)
                                elseif AutoForge_ItemType == "Armor" then
                                    ForgeController:StartForgeArmor(AutoForge_Ores[1], AutoForge_OresPerForge)
                                end
                                
                                if AutoForge_AutoMinigames then
                                    task.wait(2)
                                    ForgeController:CompleteMinigame()
                                end
                                
                                task.wait(3)
                                ForgeStatus:Update({
                                    Title = "Status",
                                    Content = "Cycle #" .. cycle .. " completed"
                                })
                            end
                        else
                            ForgeStatus:Update({
                                Title = "Status",
                                Content = "Error: Forge not available"
                            })
                        end
                    else
                        ForgeStatus:Update({
                            Title = "Status",
                            Content = "Error: Controllers not found"
                        })
                    end
                    
                    cycle = cycle + 1
                    task.wait(5)
                end
                ForgeStatus:Update({
                    Title = "Status",
                    Content = "Idle"
                })
            end)
        end
    end
})

local Tab3 = Window:CreateTab({
    Name = "Auto Features",
    Icon = "rbxassetid://16932740082"
})

local Section5 = Tab3:AddSection("Auto Use Potions")

local PotionStatus = Section5:AddParagraph({
    Title = "Potions Status",
    Content = "Idle"
})

local Auto_Potions_List = {}
local Auto_Potions_Enable = false

Section5:AddDropdown({
    Title = "Potions to Auto-Use",
    Content = "Select potions to automatically use",
    Multi = true,
    Options = {"Health Potion", "Mana Potion", "Speed Potion", "Strength Potion"},
    Default = {},
    Callback = function(selected)
        Auto_Potions_List = selected
    end
})

Section5:AddToggle({
    Title = "Enable Auto Potions",
    Content = "Automatically use selected potions",
    Default = false,
    Callback = function(value)
        Auto_Potions_Enable = value
        if value then
            PotionStatus:Update({
                Title = "Potions Status",
                Content = "Starting auto potions..."
            })
            
            spawn(function()
                local ToolService = Knit.GetService("ToolService")
                
                while Auto_Potions_Enable do
                    if #Auto_Potions_List == 0 then
                        PotionStatus:Update({
                            Title = "Potions Status",
                            Content = "No potions selected"
                        })
                        task.wait(1)
                        continue
                    end
                    
                    PotionStatus:Update({
                        Title = "Potions Status",
                        Content = "Auto potions running..."
                    })
                    
                    local Character = LocalPlayer.Character
                    if Character then
                        for _, potionName in ipairs(Auto_Potions_List) do
                            local Backpack = LocalPlayer:FindFirstChild("Backpack")
                            if Backpack then
                                for _, tool in ipairs(Backpack:GetChildren()) do
                                    if tool:IsA("Tool") then
                                        local ItemName = tool:GetAttribute("ItemName") or tool.Name
                                        if string.find(string.lower(tostring(ItemName)), string.lower(potionName)) then
                                            tool.Parent = Character
                                            if ToolService then
                                                ToolService.RF.ToolActivated:InvokeServer(tool)
                                            end
                                            task.wait(1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(5)
                end
                PotionStatus:Update({
                    Title = "Potions Status",
                    Content = "Idle"
                })
            end)
        end
    end
})

local Section6 = Tab3:AddSection("Auto Player Movement")

local Auto_Move_AlwaysRun = false
local Auto_Move_AutoDodge = false

Section6:AddToggle({
    Title = "Always Run",
    Content = "Keep running automatically",
    Default = false,
    Callback = function(value)
        Auto_Move_AlwaysRun = value
        if value then
            spawn(function()
                while Auto_Move_AlwaysRun do
                    local Character = LocalPlayer.Character
                    if Character then
                        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                        if Humanoid then
                            Humanoid.WalkSpeed = 32
                        end
                    end
                    task.wait(0.1)
                end
                local Character = LocalPlayer.Character
                if Character then
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid.WalkSpeed = 16
                    end
                end
            end)
        end
    end
})

Section6:AddToggle({
    Title = "Auto Dodge (dash on hit)",
    Content = "Automatically dodge when attacked",
    Default = false,
    Callback = function(value)
        Auto_Move_AutoDodge = value
        if value then
            spawn(function()
                local lastHealth = 100
                while Auto_Move_AutoDodge do
                    local Character = LocalPlayer.Character
                    if Character then
                        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                        
                        if Humanoid and HumanoidRootPart then
                            local currentHealth = Humanoid.Health
                            local moveDirection = Humanoid.MoveDirection
                            local isMoving = moveDirection.Magnitude > 0.1
                            
                            if currentHealth < lastHealth - 0.5 then
                                local dashDirection = Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)).Unit
                                local dashVelocity = Instance.new("BodyVelocity")
                                dashVelocity.Velocity = dashDirection * 50
                                dashVelocity.MaxForce = Vector3.new(10000, 0, 10000)
                                dashVelocity.Parent = HumanoidRootPart
                                
                                task.wait(0.2)
                                dashVelocity:Destroy()
                            end
                            
                            lastHealth = currentHealth
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

local Tab4 = Window:CreateTab({
    Name = "Auto Sell",
    Icon = "rbxassetid://16932740082"
})

local Section7 = Tab4:AddSection("Auto Sell Settings")

local Auto_Sell_Enable = false
local Auto_Sell_Items = {}
local Auto_Sell_Delay = 10

Section7:AddToggle({
    Title = "Enable Auto Sell",
    Content = "Automatically sell items",
    Default = false,
    Callback = function(value)
        Auto_Sell_Enable = value
        if value then
            spawn(function()
                while Auto_Sell_Enable do
                    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    local Menu = PlayerGui and PlayerGui:FindFirstChild("Menu")
                    local MainFrame = Menu and Menu:FindFirstChild("Frame")
                    local InnerFrame = MainFrame and MainFrame:FindFirstChild("Frame")
                    local Menus = InnerFrame and InnerFrame:FindFirstChild("Menus")
                    local Stash = Menus and Menus:FindFirstChild("Stash")
                    
                    if Stash then
                        local UIController = Knit.GetController("UIController")
                        if UIController then
                            for _, itemType in ipairs(Auto_Sell_Items) do
                                UIController:SellItem(itemType, 1)
                                task.wait(1)
                            end
                        end
                    else
                        print("[Forge] Debug: Could not find Stash UI")
                    end
                    
                    task.wait(Auto_Sell_Delay)
                end
            end)
        end
    end
})

Section7:AddDropdown({
    Title = "Items to Sell",
    Content = "Select items to automatically sell",
    Multi = true,
    Options = {"Common Ore", "Rare Ore", "Weapons", "Armor"},
    Default = {},
    Callback = function(selected)
        Auto_Sell_Items = selected
    end
})

Section7:AddSlider({
    Title = "Sell Delay (s)",
    Content = "Delay between sell actions",
    Min = 1,
    Max = 30,
    Default = 10,
    Callback = function(value)
        Auto_Sell_Delay = value
    end
})

local Tab5 = Window:CreateTab({
    Name = "Info & Support",
    Icon = "rbxassetid://16932740082"
})

local Section8 = Tab5:AddSection("Community Support")

Section8:AddButton({
    Title = "Discord",
    Content = "Click to copy Discord invite link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jUctfTAa5D")
            Library:MakeNotify({
                Title = "Discord",
                Description = "Link copied!",
                Content = "Discord invite link has been copied to clipboard",
                Color = Color3.fromRGB(0, 255, 200),
                Delay = 3
            })
        end
    end
})

Section8:AddParagraph({
    Title = "Script Information",
    Content = "Script Name: NisulRocks The Forge Auto Farm\nVersion: V1.0\nStorage ID: NisulRocks_TheForge_AutoFarm\nKey System: Enabled"
})

Section8:AddParagraph({
    Title = "Support",
    Content = "For issues, feature requests, or support, please join our Discord server. The script will be updated regularly for game updates and bug fixes."
})

spawn(function()
    while true do
        local Character = LocalPlayer.Character
        if Character then
            for _, item in ipairs(Character:GetChildren()) do
                if item:IsA("Tool") then
                    local ItemJSON = item:GetAttribute("ItemJSON")
                    if ItemJSON and typeof(ItemJSON) == "string" and ItemJSON ~= "" then
                        local success, decoded = pcall(function()
                            return HttpService:JSONDecode(ItemJSON)
                        end)
                        if success and decoded and decoded.Name then
                            PickaxeParagraph:Update({
                                Title = "Pickaxe Info",
                                Content = "Name: " .. tostring(decoded.Name) .. "\nDamage: " .. tostring(decoded.Damage or 0)
                            })
                            break
                        end
                    end
                end
            end
        end
        task.wait(5)
    end
end)

Library:MakeNotify({
    Title = "The Forge Automation",
    Description = "Loaded successfully!",
    Content = "Welcome to The Forge Auto Farm V1.0 by Nisulrocks",
    Color = Color3.fromRGB(0, 255, 200),
    Delay = 5
})
