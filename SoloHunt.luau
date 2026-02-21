local Collection = {}; Collection.__index = Collection

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local Joined = false

local ProtectName = "Protect by Forge Hub"
local ForgeHub_Image = "rbxassetid://88704482117379"

-- Fly variables
local flying = false
local bv, bg
local keys = {
    W = false, A = false, S = false, D = false,
    Space = false, Ctrl = false
}

-- Initialize global settings
getgenv().choosendungeon = getgenv().choosendungeon or "Subway"
getgenv().choosendungeonrank = getgenv().choosendungeonrank or "F"
getgenv().autofarmdungeon = getgenv().autofarmdungeon or false
getgenv().autojoindungeon = getgenv().autojoindungeon or false
getgenv().autostartdungeon = getgenv().autostartdungeon or false
getgenv().autoleavedungeon = getgenv().autoleavedungeon or false
getgenv().AutoOpenChest = getgenv().AutoOpenChest or false
getgenv().AutoFarmMonster = getgenv().AutoFarmMonster or false
getgenv().AutoAttackMonster = getgenv().AutoAttackMonster or false
getgenv().normalattack = getgenv().normalattack or false
getgenv().KillAura = getgenv().KillAura or false
getgenv().PointAmount = getgenv().PointAmount or 1
getgenv().choosenstats = getgenv().choosenstats or "Strength"
getgenv().autostats = getgenv().autostats or false
getgenv().chooseItems = getgenv().chooseItems or ""
getgenv().enableprotection = getgenv().enableprotection or false
getgenv().Camera_Zoom = getgenv().Camera_Zoom or 100
getgenv().FlySpeed = getgenv().FlySpeed or 50
getgenv().enablefly = getgenv().enablefly or false
getgenv().speedchanger = getgenv().speedchanger or 13
getgenv().enablespeed = getgenv().enablespeed or false
getgenv().jumppowerchanger = getgenv().jumppowerchanger or 13
getgenv().enablejumppower = getgenv().enablejumppower or false
getgenv().choosesword = getgenv().choosesword or ""
getgenv().autotakesubwayquest = getgenv().autotakesubwayquest or false

function Collection:IsTeleporting()
    if LocalPlayer:GetAttribute("DungeonId") == (nil or "") then
        return false
    else
        return true 
    end
end

function Collection:RewriteSyntax(str)
    return string.lower(str):gsub("%s+", "")
end

function Collection:IsReturnPortal()
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "OverworldPortal" then
            print("Exit portal found")
            return true
        end
    end
    print("No exit portal")
    return false
end

function Collection:CheckDistanceFrom(a, b, distance)
    if a and b and a.Position and b.Position then
        return (a.Position - b.Position).Magnitude <= distance
    end
    return false
end

function Collection:InstantTeleportTo(pos)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = pos
    end
end

-- Item lists (ordered from best to worst)
local ListSword = {
    "Shadow Scrythe",
    "Dual Daggers",
    "Thunder Axe",
    "Venom Fang",
    "Carmesi Katana",
    "King's Trident",
    "Link Sword",
    "Demon King Daggers",
    "Diamond Dagger",
    "Pesand Sword"
}
local List_Helmet = {
    "Serpent Helmet",
    "Venomspike Helmet",
    "Astral Helmet",
    "Iron Helmet"
}
local List_Chestplate = {
    "Serpent Chestplate",
    "Venomspike Chestplate",
    "Astral Chestplate",
    "Iron Chestplate"
}
local List_Leggings = {
    "Serpent Leggings",
    "Venomspike Leggings",
    "Astral Leggings",
    "Iron Leggings"
}

function Collection:GetPlayerInventory()
    local playerData = LocalPlayer:FindFirstChild("PlayerData")
    if playerData then
        return playerData:FindFirstChild("Inventory")
    end
    local success, inv = pcall(function()
        return ReplicatedStorage.RemoteServices.InventoryService.RF.GetInventory:InvokeServer()
    end)
    if success then
        return inv
    end
    return nil
end

function Collection:EquipBestArmorV2()
    local inventory = self:GetPlayerInventory()
    if not inventory then
        self:EquipBestArmor()
        return
    end
    
    local armorTypes = {"Helmet", "Chestplate", "Leggings"}
    local priorityLists = {
        Helmet = List_Helmet,
        Chestplate = List_Chestplate,
        Leggings = List_Leggings
    }
    
    for _, armorType in ipairs(armorTypes) do
        for _, itemName in ipairs(priorityLists[armorType]) do
            local owned = false
            if type(inventory) == "table" then
                for _, invItem in pairs(inventory) do
                    if (type(invItem) == "table" and invItem.Name == itemName) or invItem == itemName then
                        owned = true
                        break
                    end
                end
            elseif type(inventory) == "Instance" then
                if inventory:FindFirstChild(itemName) then
                    owned = true
                end
            end
            
            if owned then
                pcall(function()
                    ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer(armorType, itemName)
                end)
                break
            end
        end
    end
end

function Collection:EquipBestSwordV2()
    local inventory = self:GetPlayerInventory()
    if not inventory then
        self:EquipBestSword()
        return
    end
    
    for _, itemName in ipairs(ListSword) do
        local owned = false
        if type(inventory) == "table" then
            for _, invItem in pairs(inventory) do
                if (type(invItem) == "table" and invItem.Name == itemName) or invItem == itemName then
                    owned = true
                    break
                end
            end
        elseif type(inventory) == "Instance" then
            if inventory:FindFirstChild(itemName) then
                owned = true
            end
        end
        
        if owned then
            pcall(function()
                ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Weapon", itemName)
            end)
            break
        end
    end
end

function Collection:EquipBestArmor()
    for _, item in ipairs(List_Helmet) do
        local success = pcall(function()
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Helmet", item)
        end)
        if success then break end
    end
    for _, item in ipairs(List_Chestplate) do
        local success = pcall(function()
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Chestplate", item)
        end)
        if success then break end
    end
    for _, item in ipairs(List_Leggings) do
        local success = pcall(function()
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Leggings", item)
        end)
        if success then break end
    end
end

function Collection:EquipBestSword()
    for _, item in ipairs(ListSword) do
        local success = pcall(function()
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Weapon", item)
        end)
        if success then break end
    end
end

-- UI Library
local Fluent, SaveManager, InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Forge Hub - Solo Hunter",
    SubTitle = "discord.gg/forgehubrbx",
    TitleIcon = "rbxassetid://88704482117379",
    Image = "",
    Size = UDim2.fromOffset(500, 350),
    TabWidth = 150,
    Acrylic = true,
    Theme = "Dark",
    Search = true,
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = false,
    UserInfoTitle = "Protected By Forge Hub",
    UserInfoSubtitle = "User",
    UserInfoSubtitleColor = Color3.fromRGB(255, 215, 0),
    UserInfoTop = false
})

-- Mobile drag icon (unchanged)
if isMobile then
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "ForgeHub.Ui"
    gui.ResetOnSpawn = false

    local icon = Instance.new("ImageButton")
    icon.Name = "ForgeHub.Logo"
    icon.Size = UDim2.new(0, 55, 0, 50)
    icon.Position = UDim2.new(0, 200, 0, 150)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://88704482117379"
    icon.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = icon

    local dragging, dragInput, dragStart, startPos
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = icon.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    icon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local isMinimized = false
    icon.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        Window:Minimize(isMinimized)
    end)
end

-- Tabs
local Tabs = {
    General = Window:AddTab({ Title = "Main", Icon = "house" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "bar-chart-2" }),
    Items = Window:AddTab({ Title = "Items", Icon = "sword" }),
    Merchant = Window:AddTab({ Title = "Merchant", Icon = "shopping-cart" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "cog" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

do
    local Section_1 = Tabs.General:AddSection("[🔧] Setup")

    local selectdungeaonsdropdown = Section_1:AddDropdown("selectdungeaonsdropdown", {
        Title = "Choose Dungeon",
        Values = {"Subway", "Caves", "Desert", "Jungle", "WolfCave", "SpiderCave"},
        Multi = false,
        Default = getgenv().choosendungeon,
    })
    selectdungeaonsdropdown:OnChanged(function(v)
        getgenv().choosendungeon = v
    end)

    local selectdungeaonsrankdropdown = Section_1:AddDropdown("selectdungeaonsrankdropdown", {
        Title = "Choose Dungeon Rank",
        Values = {"F", "F+", "E", "E+", "D", "D+", "C", "C+", "B", "B+", "A", "A+", "S", "S+", "S++", "S+++"},
        Multi = false,
        Default = getgenv().choosendungeonrank,
    })
    selectdungeaonsrankdropdown:OnChanged(function(v)
        getgenv().choosendungeonrank = v
    end)

    local Section_2 = Tabs.General:AddSection("[☠️] Dungeon")

    local autofarmdungeontoggle = Section_2:AddToggle("autofarmdungeontoggle", {Title = "Auto Farm Dungeon", Description = "Automatically farms the selected dungeon", Default = getgenv().autofarmdungeon })
    autofarmdungeontoggle:OnChanged(function(v)
        getgenv().autofarmdungeon = v
        if not v then Joined = false end -- Reset join state when toggled off
    end)

    local autojoindungeontoggle = Section_2:AddToggle("autojoindungeontoggle", {Title = "Auto Join Dungeon", Description = "Automatically joins the selected dungeon", Default = getgenv().autojoindungeon })
    autojoindungeontoggle:OnChanged(function(v)
        getgenv().autojoindungeon = v
    end)

    local DungeonMap = {
        Subway = "Subway",
        Caves = "Cave",
        Desert = "Desert",
        Jungle = "Jungle",
        WolfCave = "Wolf",
        SpiderCave = "Spider"
    }

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if not getgenv().autofarmdungeon then return end

                local selectedDungeon = getgenv().choosendungeon
                local selectedRank = getgenv().choosendungeonrank
                local dungeonKey = DungeonMap[selectedDungeon]
                if not dungeonKey then return end

                local targetPortal = nil
                for _, portal in pairs(workspace.PortalSpawns.Normal:GetChildren()) do
                    local portalName = Collection:RewriteSyntax(portal.Name)
                    local formattedDungeon = Collection:RewriteSyntax(dungeonKey)
                    if string.find(portalName, formattedDungeon, 1, true) and portal:GetAttribute("Rank") == selectedRank then
                        targetPortal = portal
                        break
                    end
                end

                if targetPortal then
                    Collection:InstantTeleportTo(targetPortal.CFrame)

                    if getgenv().autojoindungeon and not Joined then
                        task.wait(0.4)
                        local portalId = "N_" .. targetPortal.Name
                        ReplicatedStorage.RemoteServices.PortalService.RF.QueuePortal:InvokeServer(portalId)
                        task.wait(0.5)
                        ReplicatedStorage.RemoteServices.PortalService.RF.EnterPortal:InvokeServer(portalId)
                        Joined = true
                    end
                end
            end)
        end
    end)

    local autostartdungeontoggle = Section_2:AddToggle("autostartdungeontoggle", {Title = "Auto Start Dungeon", Description = "Automatically start dungeon if able to", Default = getgenv().autostartdungeon })
    autostartdungeontoggle:OnChanged(function(v)
        getgenv().autostartdungeon = v
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if getgenv().autostartdungeon then
                    ReplicatedStorage.RemoteServices.DungeonService.RF.StartDungeon:InvokeServer()
                end
            end)
        end
    end)

    local autoleavedungeontoggle = Section_2:AddToggle("autoleavedungeontoggle", {Title = "Auto Leave Dungeon", Description = "Automatically leaves the dungeon", Default = getgenv().autoleavedungeon })
    autoleavedungeontoggle:OnChanged(function(v)
        getgenv().autoleavedungeon = v
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if getgenv().autoleavedungeon and Collection:IsReturnPortal() then
                    ReplicatedStorage.RemoteServices.DungeonService.RF.TeleportToLobby:InvokeServer()
                    Joined = false
                end
            end)
        end
    end)

    local autopenchesttoggle = Section_2:AddToggle("autopenchesttoggle", {Title = "Auto Open Chest", Description = "Automatically opens chests", Default = getgenv().AutoOpenChest })
    autopenchesttoggle:OnChanged(function(v)
        getgenv().AutoOpenChest = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().AutoOpenChest then
                    for _, v in pairs(workspace:GetChildren()) do
                        if string.find(v.Name, "Chest") and v:IsA("Model") then
                            local owner = v:GetAttribute("Owner")
                            local chestUUID = v:GetAttribute("ChestUUID")
                            if owner == LocalPlayer.Name and chestUUID then
                                Collection:InstantTeleportTo(v.Part.CFrame + Vector3.new(0,3,0))
                                task.wait(0.15)
                                ReplicatedStorage.RemoteServices.BossDropsService.RF.OpenChest:InvokeServer(chestUUID)
                            end
                        end
                    end
                end
            end)
        end
    end)

    local Section_4 = Tabs.General:AddSection("[🧟] Monster")

    local autofarmmonstertoggle = Section_4:AddToggle("autofarmmonstertoggle", {Title = "Auto Farm Monster", Description = "Automatically farms monsters", Default = getgenv().AutoFarmMonster })
    autofarmmonstertoggle:OnChanged(function(v)
        getgenv().AutoFarmMonster = v
    end)

    task.spawn(function()
        while task.wait(0.2) do
            pcall(function()
                if getgenv().AutoFarmMonster and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, mob in pairs(workspace.Mobs:GetChildren()) do
                        if mob and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            local dist = (mob.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 350 then
                                while getgenv().AutoFarmMonster and mob and mob.Parent and mob.Humanoid.Health > 0 do
                                    Collection:InstantTeleportTo(mob.HumanoidRootPart.CFrame)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

    local autoattackmonster = Section_4:AddToggle("autoattackmonster", {Title = "Fast Attack Monster", Description = "Automatically attacks monsters", Default = getgenv().AutoAttackMonster })
    autoattackmonster:OnChanged(function(v)
        getgenv().AutoAttackMonster = v
    end)

    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if getgenv().AutoAttackMonster then
                    for _, mob in pairs(workspace.Mobs:GetChildren()) do
                        if mob and mob:FindFirstChild("Humanoid") then
                            ReplicatedStorage.RemoteServices.CombatService.RF.UseWeapon:InvokeServer(10, {mob}, 10)
                        end
                    end
                end
            end)
        end
    end)

    local normalattacktoggle = Section_4:AddToggle("normalattacktoggle", {Title = "Normal Attack Monster", Description = "Simulates mouse clicks", Default = getgenv().normalattack })
    normalattacktoggle:OnChanged(function(v)
        getgenv().normalattack = v
    end)

    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if getgenv().normalattack then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
        end
    end)

    local enablekillauratoggle = Section_4:AddToggle("enablekillauratoggle", {Title = "Enable Kill Aura", Description = "Automatically kills monsters in range", Default = getgenv().KillAura })
    enablekillauratoggle:OnChanged(function(v)
        getgenv().KillAura = v
    end)

    task.spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if getgenv().KillAura then
                    sethiddenproperty(Players.LocalPlayer, "SimulationRadius", 5000)
                    sethiddenproperty(LocalPlayer, "MaxSimulationRadius", 5000)
                    for _, mob in pairs(workspace.Mobs:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") then
                            mob.Humanoid.Health = 0
                        end
                    end
                end
            end)
        end
    end)

    local Section_3 = Tabs.Stats:AddSection("[📈] Stats")

    local pointamountslider = Section_3:AddSlider("pointamountslider", {
        Title = "Point Amount",
        Description = "Choose how many points you want to spend",
        Default = getgenv().PointAmount,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Callback = function(Value)
            getgenv().PointAmount = Value
        end
    })

    local selectstatsdopdown = Section_3:AddDropdown("selectstatsdopdown", {
        Title = "Choose Stats",
        Values = {"Magic", "Strength", "Defense", "Agility", "Energy"},
        Multi = false,
        Default = getgenv().choosenstats,
    })
    selectstatsdopdown:OnChanged(function(v)
        getgenv().choosenstats = v
    end)

    local enableautostatstoggle = Section_3:AddToggle("enableautostatstoggle", {Title = "Enable Auto Stats", Default = getgenv().autostats })
    enableautostatstoggle:OnChanged(function(v)
        getgenv().autostats = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().autostats then
                    ReplicatedStorage.RemoteServices.InventoryService.RF.UseSkillPoints:InvokeServer({
                        [getgenv().choosenstats] = getgenv().PointAmount
                    })
                end
            end)
        end
    end)

    local Section_5 = Tabs.Merchant:AddSection("[🛒] Shop")

    local TableItemsShop = {}
    local MerchantItems = require(ReplicatedStorage.ReplicatedStorage.Modules.Shared.Data.MerchantItems)
    for _, item in pairs(MerchantItems.Normal) do
        if type(item) == "table" and item.Base then
            table.insert(TableItemsShop, item.Base)
        end
    end

    local selectshopstuffdopdown = Section_5:AddDropdown("selectshopstuffdopdown", {
        Title = "Choose Items To Buy",
        Values = TableItemsShop,
        Multi = false,
        Default = getgenv().chooseItems,
    })
    selectshopstuffdopdown:OnChanged(function(v)
        getgenv().chooseItems = v
    end)

    Section_5:AddButton({
        Title = "Buy Item Once",
        Description = "Buys the selected item once",
        Callback = function()
            local itemName = getgenv().chooseItems
            if itemName and itemName ~= "" then
                pcall(function()
                    ReplicatedStorage.RemoteServices.MerchantService.RF.Buy:InvokeServer(itemName, 1)
                end)
            else
                Fluent:Notify({
                    Title = "Forge Hub",
                    Content = "Pilih item terlebih dahulu!",
                    Duration = 3
                })
            end
        end
    })

    local Section_6 = Tabs.Misc:AddSection("[🛡️] Protection")

    local enableprotectiontoggle = Section_6:AddToggle("enableprotectiontoggle", {Title = "Enable Protection", Description = "Enables protection against certain game mechanics", Default = getgenv().enableprotection })
    enableprotectiontoggle:OnChanged(function(v)
        getgenv().enableprotection = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().enableprotection then
                    if LocalPlayer.DisplayName ~= ProtectName then
                        LocalPlayer.DisplayName = ProtectName
                    end
                    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                    if leaderstats then
                        for _, stat in pairs(leaderstats:GetChildren()) do
                            if stat.Name ~= ProtectName then
                                stat.Name = ProtectName
                            end
                        end
                    end
                end
            end)
        end
    end)

    local Section_7 = Tabs.Misc:AddSection("[🔎] Max Zoom")

    local camerazoomslider = Section_7:AddSlider("camerazoomslider", {
        Title = "Maximum Zoom Distance",
        Description = "Change the maximum zoom distance of your camera",
        Default = getgenv().Camera_Zoom,
        Min = 10,
        Max = 1000,
        Rounding = 1,
        Callback = function(Value)
            getgenv().Camera_Zoom = Value
        end
    })

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().Camera_Zoom and LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.CameraMaxZoomDistance = getgenv().Camera_Zoom
                    end
                end
            end)
        end
    end)

    local Section_8 = Tabs.Misc:AddSection("[🪽] Fly")

    local flyspeedslider = Section_8:AddSlider("flyspeedslider", {
        Title = "Fly Speed",
        Description = "Change the speed of fly",
        Default = getgenv().FlySpeed,
        Min = 10,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            getgenv().FlySpeed = Value
        end
    })

    -- Fly cleanup function
    local function cleanupFly()
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        flying = false
    end

    local function setupFly(character)
        if not character or not getgenv().enablefly then return end
        cleanupFly()
        local hrp = character:WaitForChild("HumanoidRootPart")
        flying = true
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp
    end

    LocalPlayer.CharacterAdded:Connect(setupFly)
    LocalPlayer.CharacterRemoving:Connect(cleanupFly)
    if LocalPlayer.Character then setupFly(LocalPlayer.Character) end

    local enableflytoggle = Section_8:AddToggle("enableflytoggle", {Title = "Enable Fly", Description = "Enables flying", Default = getgenv().enablefly })
    enableflytoggle:OnChanged(function(v)
        getgenv().enablefly = v
        if v then
            if LocalPlayer.Character then
                setupFly(LocalPlayer.Character)
            end
        else
            cleanupFly()
        end
    end)

    -- Fly input handling
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then keys.W = true end
        if input.KeyCode == Enum.KeyCode.A then keys.A = true end
        if input.KeyCode == Enum.KeyCode.S then keys.S = true end
        if input.KeyCode == Enum.KeyCode.D then keys.D = true end
        if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = true end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keys.W = false end
        if input.KeyCode == Enum.KeyCode.A then keys.A = false end
        if input.KeyCode == Enum.KeyCode.S then keys.S = false end
        if input.KeyCode == Enum.KeyCode.D then keys.D = false end
        if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftControl then keys.Ctrl = false end
    end)

    RunService.RenderStepped:Connect(function()
        if getgenv().enablefly and flying and bv and bg then
            local cam = workspace.CurrentCamera
            local dir = Vector3.zero

            if keys.W then dir += cam.CFrame.LookVector end
            if keys.S then dir -= cam.CFrame.LookVector end
            if keys.A then dir -= cam.CFrame.RightVector end
            if keys.D then dir += cam.CFrame.RightVector end
            if keys.Space then dir += Vector3.new(0,1,0) end
            if keys.Ctrl then dir -= Vector3.new(0,1,0) end

            if dir.Magnitude > 0 then
                dir = dir.Unit * getgenv().FlySpeed
            end

            bv.Velocity = dir
            bg.CFrame = cam.CFrame
        elseif not getgenv().enablefly and flying then
            cleanupFly()
        end
    end)

    local Section_9 = Tabs.Misc:AddSection("[👱] Player")

    local speedchangerslider = Section_9:AddSlider("speedchangerslider", {
        Title = "Speed Changer",
        Description = "Change the speed of your character",
        Default = getgenv().speedchanger,
        Min = 1,
        Max = 300,
        Rounding = 1,
        Callback = function(Value)
            getgenv().speedchanger = Value
        end
    })

    local enablespeedtoggle = Section_9:AddToggle("enablespeedtoggle", {Title = "Enable Speed Changer", Description = "Enables speed changing", Default = getgenv().enablespeed })
    enablespeedtoggle:OnChanged(function(v)
        getgenv().enablespeed = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().enablespeed and LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = getgenv().speedchanger
                    end
                end
            end)
        end
    end)

    local jumppowercachangerslider = Section_9:AddSlider("jumppowercachangerslider", {
        Title = "Jump Power Changer",
        Description = "Change the jump power of your character",
        Default = getgenv().jumppowerchanger,
        Min = 1,
        Max = 300,
        Rounding = 1,
        Callback = function(Value)
            getgenv().jumppowerchanger = Value
        end
    })

    local enablejumppowertoggle = Section_9:AddToggle("enablejumppowertoggle", {Title = "Enable Jump Power Changer", Description = "Enables jump power changing", Default = getgenv().enablejumppower })
    enablejumppowertoggle:OnChanged(function(v)
        getgenv().enablejumppower = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().enablejumppower and LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = getgenv().jumppowerchanger
                    end
                end
            end)
        end
    end)

    local Section_10 = Tabs.Items:AddSection("[⚔️] Sword")

    local SwordList = {}
    for _, v in pairs(ReplicatedStorage.ReplicatedStorage.Storage.Weapons:GetChildren()) do
        table.insert(SwordList, v.Name)
    end

    local selectsworddropdown = Section_10:AddDropdown("selectsworddropdown", {
        Title = "Choose Sword To Equip",
        Values = SwordList,
        Multi = false,
        Default = getgenv().choosesword,
    })
    selectsworddropdown:OnChanged(function(v)
        getgenv().choosesword = v
    end)

    Section_10:AddButton({
        Title = "Equip Chosen Sword",
        Description = "",
        Callback = function()
            pcall(function()
                ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Weapon", getgenv().choosesword)
            end)
        end
    })

    local Section_11 = Tabs.Items:AddSection("[🛒] Sell")

    Section_11:AddButton({
        Title = "Sell All Loot Materials",
        Description = "",
        Callback = function()
            pcall(function()
                ReplicatedStorage.RemoteServices.InventoryService.RF.SellAllLootMaterial:InvokeServer()
            end)
        end
    })

    local Section_12 = Tabs.Items:AddSection("[🏆] Best")

    Section_12:AddButton({
        Title = "Equip Best Sword",
        Description = "Equip best sword in your inventory",
        Callback = function()
            Collection:EquipBestSwordV2()
        end
    })

    Section_12:AddButton({
        Title = "Equip Best Armor",
        Description = "Equip best armor in your inventory",
        Callback = function()
            Collection:EquipBestArmorV2()
        end
    })

    local Section_13 = Tabs.Items:AddSection("[📜] Quest")

    local autotakesubwayquest = Section_13:AddToggle("autotakesubwayquest", {Title = "Auto Take Quest", Description = "Automatically takes the subway quest", Default = getgenv().autotakesubwayquest })
    autotakesubwayquest:OnChanged(function(v)
        getgenv().autotakesubwayquest = v
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if getgenv().autotakesubwayquest then
                    ReplicatedStorage.RemoteServices.OnboardingService.RF.TalkedToTin:InvokeServer()
                    task.wait(0.3)
                    ReplicatedStorage.RemoteServices.QuestsV2Service.RF.MarkGiverViewed:InvokeServer("Subway")
                    task.wait(0.5)
                    ReplicatedStorage.RemoteServices.QuestsV2Service.RF.RequestQuest:InvokeServer("Subway")
                end
            end)
        end
    end)
end

-- Save/Load managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Forge Hub",
    Content = "Solo Hunter loaded successfully!",
    Duration = 5
})
