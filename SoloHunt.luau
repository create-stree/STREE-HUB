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

local flying = false
local bv, bg
local keys = {
    W = false, A = false, S = false, D = false,
    Space = false, Ctrl = false
}

function Collection:IsTeleporting()
    if LocalPlayer:GetAttribute("DungeonId") == (nil or "") then
        return false
    else
        return true 
    end
end

function Collection:RewriteSynxtaxe(str)
    return string.lower(str):gsub("%s+", "")
end

function Collection:IsReturnPortal()
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "OverworldPortal" then
            print("Is havz for exit")
            return true
        end
    end
    print("not Door exit")
    return false
end

function Collection:CheckDistanceFrom(a, b, distance)
    if (a.Position - b.Position).Magnitude <= distance then
        return true
    else
        return false
    end
end

function Collection:InstantTeleportTo(pos)
    LocalPlayer.Character.HumanoidRootPart.CFrame = pos
end

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

function Collection:EquipBestArmor()
    for _, v1 in ipairs(List_Helmet) do
        if not LocalPlayer.Character:FindFirstChild(v1) then
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Helmet", v1)
            break
        end
    end
    for _, v2 in ipairs(List_Chestplate) do
        if not LocalPlayer.Character:FindFirstChild(v2) then
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Chestplate", v2)
            break
        end
    end
    for _, v3 in ipairs(List_Leggings) do
        if not LocalPlayer.Character:FindFirstChild(v3) then
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Leggings", v3)
            break
        end
    end
end

function Collection:EquipBestSword()
    for _, v in ipairs(ListSword) do
        if not LocalPlayer.Backpack:FindFirstChild(v) then
            ReplicatedStorage.RemoteServices.InventoryService.RF.Equip:InvokeServer("Weapon", v)
            break
        end
    end
end

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

    game:GetService("UserInputService").InputChanged:Connect(function(input)
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
        Title = "Choose Dungueon",
        Values = {"Subway", "Caves", "Desert", "Jungle", "WolfCave", "SpiderCave"},
        Multi = false,
        Default = getgenv().choosendungeon,
    })

    selectdungeaonsdropdown:OnChanged(function(v)
        getgenv().choosendungeon = v
    end)

    local selectdungeaonsrankdropdown = Section_1:AddDropdown("selectdungeaonsrankdropdown", {
        Title = "Choose Dungueon Rank",
        Values = {"F", "F+", "E", "E+", "D", "D+", "C", "C+", "B", "B+", "A", "A+", "S", "S+", "S++", "S+++"},
        Multi = false,
        Default = getgenv().choosendungeonrank,
    })

    selectdungeaonsrankdropdown:OnChanged(function(v)
        getgenv().choosendungeonrank = v
    end)

    local Section_2 = Tabs.General:AddSection("[☠️] Dungeon")

    local autofarmdungeontoggle = Section_2:AddToggle("autofarmdungeontoggle", {Title = "Auto Farm Dungeon", Description = "Automatically farms the selected dungeon", Default = false })

    autofarmdungeontoggle:OnChanged(function(v)
        getgenv().autofarmdungeon = v
    end)

    local autojoindungeontoggle = Section_2:AddToggle("autojoindungeontoggle", {Title = "Auto Join Dungeon", Description = "Automatically joins the selected dungeon", Default = false })

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
            local Success, Error = pcall(function()
                if getgenv().autofarmdungeon then
                    local SelectedDungeonIs = getgenv().choosendungeon
                    local SelectRankIs = getgenv().choosendungeonrank
                    local Alrin = false
                    local TransformedNameDungeonIs = DungeonMap[SelectedDungeonIs]
                    for _, PortalSpawns in pairs(workspace.PortalSpawns.Normal:GetChildren()) do
                        local realPortal = Collection:RewriteSynxtaxe(PortalSpawns.Name)
                        local formattedDungeon = Collection:RewriteSynxtaxe(TransformedNameDungeonIs)
                        local rankAttribute = PortalSpawns:GetAttribute("Rank")
                        if string.find(realPortal, formattedDungeon, 1, true) and rankAttribute == SelectRankIs then
                            if not Alrin then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = PortalSpawns.CFrame
                                Alrin = true
                            end
                            if getgenv().autojoindungeon and not Joined then
                                task.wait(0.4)
                                local portalId = "N_" .. PortalSpawns.Name
                                ReplicatedStorage.RemoteServices.PortalService.RF.QueuePortal:InvokeServer(portalId)
                                task.wait(0.5)
                                ReplicatedStorage.RemoteServices.PortalService.RF.EnterPortal:InvokeServer(portalId)
                                task.wait(0.2)
                                Joined = true
                                break
                            end
                            task.wait(6)
                        end
                    end
                end
            end)
            if not Success then
                task.wait(3)
                warn("Eror Auto Farm Deungeon : " .. Error)
            end
        end
    end)

    local autostartdungeontoggle = Section_2:AddToggle("autostartdungeontoggle", {Title = "Auto Start Dungeon", Description = "Automatically Start dungeon if able to", Default = false })

    autostartdungeontoggle:OnChanged(function(v)
        getgenv().autostartdungeon = v
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if getgenv().autostartdungeon then
                    local Event = game:GetService("ReplicatedStorage").RemoteServices.DungeonService.RF.StartDungeon
                    Event:InvokeServer()
                end
            end)
        end
    end)

    local autoleavedungeontoggle = Section_2:AddToggle("autoleavedungeontoggle", {Title = "Auto Leave Dungeon", Description = "Automatically leaves the dungeon", Default = false })

    autoleavedungeontoggle:OnChanged(function(v)
        getgenv().autoleavedungeon = v
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if getgenv().autoleavedungeon then
                    if Collection:IsReturnPortal() then
                        local Event = game:GetService("ReplicatedStorage").RemoteServices.DungeonService.RF.TeleportToLobby
                        Event:InvokeServer()
                        Joined = false
                    else
                        Fluent:Notify({
                            Title = "Forge Hub - Solo Hunter",
                            Content = "Not in dungeon or no portal to exit found",
                            SubContent = "Check Notifications",
                            Duration = 5
                        })
                        task.wait(8)
                    end
                end
            end)
        end
    end)

    local autopenchesttoggle = Section_2:AddToggle("autopenchesttoggle", {Title = "Auto Open Chest", Description = "Automatically opens chests", Default = false })

    autopenchesttoggle:OnChanged(function(v)
        getgenv().AutoOpenChest = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().AutoOpenChest then
                    for _, v in pairs(workspace:GetChildren()) do
                        if string.find(v.Name, "Chest") and v:IsA("Model") then
                            local OwwnerAttributes = v:GetAttribute("Owner")
                            local KnowChestAttributes = v:GetAttribute("ChestUUID")
                            if OwwnerAttributes == LocalPlayer.Name then
                                local RemoteNameChest = KnowChestAttributes
                                Collection:InstantTeleportTo(v.Part.CFrame + Vector3.new(0, 3, 0))
                                task.wait(0.15)
                                ReplicatedStorage.RemoteServices.BossDropsService.RF.OpenChest:InvokeServer(RemoteNameChest)
                                Joined = false
                            end
                        end
                    end
                end
            end)
        end
    end)

    local Section_4 = Tabs.General:AddSection("[🧟] Monster")

    local autofarmmonstertoggle = Section_4:AddToggle("autofarmmonstertoggle", {Title = "Auto Farm Monster", Description = "Automatically farms monsters", Default = false })

    autofarmmonstertoggle:OnChanged(function(v)
        getgenv().AutoFarmMonster = v
    end)

    task.spawn(function()
        while task.wait(0.2) do
            pcall(function()
                if getgenv().AutoFarmMonster then
                    for i, v in pairs(workspace.Mobs:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 350 then
                            repeat task.wait()
                                Collection:InstantTeleportTo(v.HumanoidRootPart.CFrame)
                            until not v or not v.Parent or not getgenv().AutoFarmMonster
                        end
                    end
                end
            end)
        end
    end)

    local autoattackmonster = Section_4:AddToggle("autoattackmonster", {Title = "Fast Attack Monster", Description = "Automatically attacks monsters", Default = false })

    autoattackmonster:OnChanged(function(v)
        getgenv().AutoAttackMonster = v
    end)

    task.spawn(function()
        while task.wait(0.1) do
            local Success, Error = pcall(function()
                if getgenv().AutoAttackMonster then
                    for i, v in pairs(workspace.Mobs:GetChildren()) do
                        local Event = game:GetService("ReplicatedStorage").RemoteServices.CombatService.RF.UseWeapon
                        Event:InvokeServer(
                            10,
                            {
                                v
                            },
                            10
                        )
                    end
                end
            end)
            if not Success then
                task.wait(3)
                warn("EROR AUTO ATTACK : " .. Error)
            end
        end
    end)

    local normalattacktoggle = Section_4:AddToggle("normalattacktoggle", {Title = "Normal Attack Monster", Description = "Automatically attacks monsters", Default = false })

    normalattacktoggle:OnChanged(function(v)
        getgenv().normalattack = v
    end)

    task.spawn(function()
        while task.wait(0.1) do
            local Success, Error = pcall(function()
                if getgenv().normalattack then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end)
            if not Success then
                task.wait(3)
                warn("EROR AUTO ATTACK : " .. Error)
            end
        end
    end)

    local enablekillauratoggle = Section_4:AddToggle("enablekillauratoggle", {Title = "Enable Kill Aura", Description = "Automatically kills monsters in range", Default = false })

    enablekillauratoggle:OnChanged(function(v)
        getgenv().KillAura = v
    end)

    task.spawn(function()
        while task.wait(0.1) do
            local Success, Error = pcall(function()
                if getgenv().KillAura then
                    for i, v in pairs(workspace.Mobs:GetChildren()) do
                        sethiddenproperty(Players.LocalPlayer, "SimulationRadius", 5000)
                        sethiddenproperty(LocalPlayer, "MaxSimulationRadius", 5000)
                        v.Humanoid.Health = 0
                    end
                end
            end)
            if not Success then
                task.wait(3)
                warn("EROR AUTO ATTACK : " .. Error)
            end
        end
    end)

    local Section_3 = Tabs.Stats:AddSection("[📈] Stats")

    local pointamountslider = Section_3:AddSlider("pointamountslider", {
        Title = "Point Amount",
        Description = "Choose how many points you want to spend",
        Default = 1,
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
        Default = false,
    })

    selectstatsdopdown:OnChanged(function(v)
        getgenv().choosenstats = v
    end)

    local enableautostatstoggle = Section_3:AddToggle("enableautostatstoggle", {Title = "Enable Auto Stats", Default = false })

    enableautostatstoggle:OnChanged(function(v)
        getgenv().autostats = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().autostats then
                    local Event = game:GetService("ReplicatedStorage").RemoteServices.InventoryService.RF.UseSkillPoints
                    Event:InvokeServer(
                        {
                            [getgenv().choosenstats] = getgenv().PointAmount
                        }
                    )
                end
            end)
        end
    end)

    local Section_5 = Tabs.Merchant:AddSection("[🛒] Shop")

    local TableItemsShop = {}
    local MerchantItems = require(ReplicatedStorage.ReplicatedStorage.Modules.Shared.Data.MerchantItems)
    for _, item in pairs(MerchantItems.Normal) do
        if type(item) == "table" and item.Base then
            print(item.Base)
            table.insert(TableItemsShop, item.Base)
        end
    end

    local selectshopstuffdopdown = Section_5:AddDropdown("selectshopstuffdopdown", {
        Title = "Choose Items To Buy",
        Values = TableItemsShop,
        Multi = false,
        Default = false,
    })

    selectshopstuffdopdown:OnChanged(function(v)
        getgenv().chooseItems = v
    end)

    Section_5:AddButton({
        Title = "Buy Item Once",
        Description = "Buys the selected item once",
        Callback = function()
            local Event33 = game:GetService("ReplicatedStorage").RemoteServices.MerchantService.RF.Buy
            Event33:InvokeServer(getgenv().chooseItems)
        end
    })

    local Section_AutoBuy = Tabs.Merchant:AddSection("[🤖] Auto Buy")

    local autobuytoggle = Section_AutoBuy:AddToggle("autobuytoggle", {
        Title = "Auto Buy Selected Item",
        Description = "Continuously buys the chosen item (use with caution)",
        Default = false
    })

    autobuytoggle:OnChanged(function(v)
        getgenv().AutoBuy = v
    end)

    task.spawn(function()
        while task.wait(3) do
            pcall(function()
                if getgenv().AutoBuy and getgenv().chooseItems then
                    local Event = game:GetService("ReplicatedStorage").RemoteServices.MerchantService.RF.Buy
                    Event:InvokeServer(getgenv().chooseItems)
                end
            end)
        end
    end)

    local Section_6 = Tabs.Misc:AddSection("[🛡️] Protection")

    local enableprotectiontoggle = Section_6:AddToggle("enableprotectiontoggle", {Title = "Enable Protection", Description = "Enables protection against certain game mechanics", Default = false })

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
                    local LeaderStats = LocalPlayer:FindFirstChild("leaderstats")
                    if LeaderStats then
                        for _, Stats in pairs(LeaderStats:GetChildren()) do
                            if Stats.Name ~= ProtectName then
                                Stats.Name = ProtectName
                            end
                        end
                    end
                end
            end)
        end
    end)

    local Section_7 = Tabs.Misc:AddSection("[🔎] Max Zoom")

    local camerazoomslider = Section_7:AddSlider("camerazoomslider", {
        Title = "Maximum  Zoom  Distance",
        Description = "change the maximum zoom distance of your camera",
        Default = 100,
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
                if getgenv().Camera_Zoom then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").CameraMaxZoomDistance = getgenv().Camera_Zoom
                end
            end)
        end
    end)
    
    local Section_8 = Tabs.Misc:AddSection("[🪽] Fly")

    local flyspeedslider = Section_8:AddSlider("flyspeedslider", {
        Title = "Fly Speed",
        Description = "change the speed of fly",
        Default = 50,
        Min = 10,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            getgenv().FlySpeed = Value
        end
    })

    local enableflytoggle = Section_8:AddToggle("enableflytoggle", {Title = "Enable Fly", Description = "Enables flying", Default = false })

    enableflytoggle:OnChanged(function(v)
        getgenv().enablefly = v
    end)

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
        if getgenv().enablefly and not flying then
            flying = true

            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.zero
            bv.Parent = LocalPlayer.Character.HumanoidRootPart

            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bg.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            bg.Parent = LocalPlayer.Character.HumanoidRootPart
        end

        if not getgenv().enablefly and flying then
            flying = false
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end 
        end

        if flying then
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
        end
    end)

    local Section_9 = Tabs.Misc:AddSection("[👱] Player")

    local speedchangerslider = Section_9:AddSlider("speedchangerslider", {
        Title = "Speed Changer",
        Description = "change the speed of your character",
        Default = 13,
        Min = 1,
        Max = 300,
        Rounding = 1,
        Callback = function(Value)
            getgenv().speedchanger = Value
        end
    })

    local enablespeedtoggle = Section_9:AddToggle("enablespeedtoggle", {Title = "Enable Speed Changer", Description = "Enables speed changing", Default = false })

    enablespeedtoggle:OnChanged(function(v)
        getgenv().enablespeed = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().enablespeed then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = getgenv().speedchanger
                end
            end)
        end
    end)

    local jumppowercachangerslider = Section_9:AddSlider("jumppowercachangerslider", {
        Title = "Jump Power Changer",
        Description = "change the jump power of your character",
        Default = 13,
        Min = 1,
        Max = 300,
        Rounding = 1,
        Callback = function(Value)
            getgenv().jumppowerchanger = Value
        end
    })

    local enablejumppowertoggle = Section_9:AddToggle("enablejumppowertoggle", {Title = "Enable Jump Power Changer", Description = "Enables jump power changing", Default = false })

    enablejumppowertoggle:OnChanged(function(v)
        getgenv().enablejumppower = v
    end)

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if getgenv().enablejumppower then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = getgenv().jumppowerchanger
                end
            end)
        end
    end)

    local Section_10 = Tabs.Items:AddSection("[⚔️] Sword")
    
    local SwordList = {};
    for i, v in pairs(game:GetService("ReplicatedStorage").ReplicatedStorage.Storage.Weapons:GetChildren()) do
         table.insert(SwordList, v.Name)
    end

    local selectshopstuffdopdown = Section_10:AddDropdown("selectshopstuffdopdown", {
        Title = "Choose Sword To Equip",
        Values = SwordList,
        Multi = false,
        Default = false,
    })

    selectshopstuffdopdown:OnChanged(function(v)
        getgenv().choosesword = v
    end)

    Section_10:AddButton({
        Title = "Equip choosen sword",
        Description = "",
        Callback = function()
            local Event = game:GetService("ReplicatedStorage").RemoteServices.InventoryService.RF.Equip
            Event:InvokeServer(
                "Weapon",
                getgenv().choosesword
            )
        end
    })

    local Section_11 = Tabs.Items:AddSection("[🛒] Sell")

    Section_11:AddButton({
        Title = "Sell All Loot Materials",
        Description = "",
        Callback = function()
            game:GetService("ReplicatedStorage").RemoteServices.InventoryService.RF.SellAllLootMaterial:FireServer()
        end
    })

    local Section_AutoSell = Tabs.Items:AddSection("[💰] Auto Sell")

    local autoselltoggle = Section_AutoSell:AddToggle("autoselltoggle", {
        Title = "Auto Sell Loot Materials",
        Description = "Automatically sells all loot materials every few seconds",
        Default = false
    })

    autoselltoggle:OnChanged(function(v)
        getgenv().AutoSellLoot = v
    end)

    task.spawn(function()
        while task.wait(10) do
            pcall(function()
                if getgenv().AutoSellLoot then
                    game:GetService("ReplicatedStorage").RemoteServices.InventoryService.RF.SellAllLootMaterial:FireServer()
                end
            end)
        end
    end)

    local Section_12 = Tabs.Items:AddSection("[🏆] Best")

    Section_12:AddButton({
        Title = "Equip Best Sword",
        Description = "Equip Best Sword in your inventory",
        Callback = function()
            Collection:EquipBestSword()
        end
    })

    Section_12:AddButton({
        Title = "Equip Best Armor",
        Description = "Equip Best armor in your inventory",
        Callback = function()
            Collection:EquipBestArmor()
        end
    })

    local Section_AutoEquip = Tabs.Items:AddSection("[🔄] Auto Equip")

    local autoequipswordtoggle = Section_AutoEquip:AddToggle("autoequipswordtoggle", {
        Title = "Auto Equip Best Sword",
        Description = "Continuously equips the best sword available",
        Default = false
    })

    autoequipswordtoggle:OnChanged(function(v)
        getgenv().AutoEquipSword = v
    end)

    local autoequiparmortoggle = Section_AutoEquip:AddToggle("autoequiparmortoggle", {
        Title = "Auto Equip Best Armor",
        Description = "Continuously equips the best helmet/chestplate/leggings",
        Default = false
    })

    autoequiparmortoggle:OnChanged(function(v)
        getgenv().AutoEquipArmor = v
    end)

    task.spawn(function()
        while task.wait(5) do
            pcall(function()
                if getgenv().AutoEquipSword then
                    Collection:EquipBestSword()
                end
                if getgenv().AutoEquipArmor then
                    Collection:EquipBestArmor()
                end
            end)
        end
    end)

    local Section_13 = Tabs.Items:AddSection("[📜] Quest")

    local autotakesubwayquest = Section_13:AddToggle("autotakesubwayquest", {Title = "Auto Take Quest", Description = "Automatically takes the subway quest", Default = false })

    autotakesubwayquest:OnChanged(function(v)
        getgenv().autotakesubwayquest = v
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if getgenv().autotakesubwayquest then
                    game:GetService("ReplicatedStorage").RemoteServices.OnboardingService.RF.TalkedToTin:InvokeServer()
                    task.wait(0.3)
                    game:GetService("ReplicatedStorage").RemoteServices.QuestsV2Service.RF.MarkGiverViewed:InvokeServer("Subway")
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").RemoteServices.QuestsV2Service.RF.RequestQuest:InvokeServer("Subway")
                end
            end)
        end
    end)
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Fluent:Notify({
    Title = "Fluent",
    Content = "Solo Hunter loaded successfully!",
    Duration = 5
})
