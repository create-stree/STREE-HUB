loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/Example.lua"))()
end)

if not success or not Library then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local player = game.Players.LocalPlayer
player:WaitForChild("PlayerGui")

local function GetRemote(folder, name)
    if typeof(folder) ~= "Instance" then return nil end
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj.Name == name then
            return obj
        end
    end
    return nil
end

local RPath = game:GetService("ReplicatedStorage")

local Window = Library:MakeGui({
    NameHub = "STREE HUB",
    Description = "| Fish It",
    Color = Color3.fromRGB(0, 255, 0)
})

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local G2L = {}

G2L["ScreenGui_1"] = Instance.new("ScreenGui")
G2L["ScreenGui_1"].Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
G2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CollectionService:AddTag(G2L["ScreenGui_1"], "main")

G2L["ButtonRezise_2"] = Instance.new("ImageButton")
G2L["ButtonRezise_2"].Parent = G2L["ScreenGui_1"]
G2L["ButtonRezise_2"].BorderSizePixel = 0
G2L["ButtonRezise_2"].Draggable = true
G2L["ButtonRezise_2"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
G2L["ButtonRezise_2"].Image = "rbxassetid://123032091977400"
G2L["ButtonRezise_2"].Size = UDim2.new(0, 47, 0, 47)
G2L["ButtonRezise_2"].Position = UDim2.new(0.13, 0, 0.03, 0)

local corner = Instance.new("UICorner", G2L["ButtonRezise_2"])
corner.CornerRadius = UDim.new(0, 8)

local neon = Instance.new("UIStroke", G2L["ButtonRezise_2"])
neon.Thickness = 2
neon.Color = Color3.fromRGB(0, 255, 0)
neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

G2L["ButtonRezise_2"].MouseButton1Click:Connect(function()
    G2L["ButtonRezise_2"].Visible = false
    Window:Toggle()
end)

G2L["ButtonRezise_2"].Visible = false

local UserInputService = game:GetService("UserInputService")
local toggleKey = Enum.KeyCode.G

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey then
        Window:Toggle()
        G2L["ButtonRezise_2"].Visible = not Window.Visible
    end
end)

local Tab1 = Window:CreateTab({
    Name = "Info",
    Icon = "rbxassetid://16932740082"
})

local Section1 = Tab1:AddSection("Community Support")

Section1:AddButton({
    Title = "Discord",
    Content = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Section1:AddButton({
    Title = "WhatsApp",
    Content = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Section1:AddParagraph({
    Title = "Support",
    Content = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

local Tab2 = Window:CreateTab({
    Name = "Players",
    Icon = "rbxassetid://16932740082"
})

local Section2 = Tab2:AddSection("Movement")

Section2:AddSlider({
    Title = "Speed",
    Content = "Adjust walk speed",
    Min = 18,
    Max = 100,
    Default = 18,
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

Section2:AddSlider({
    Title = "Jump",
    Content = "Adjust jump power",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(value)
        _G.CustomJumpPower = value
        if game.Players.LocalPlayer.Character then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = value
            end
        end
    end
})

Section2:AddButton({
    Title = "Reset Jump Power",
    Content = "Return Jump Power to normal (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
    end
})

Section2:AddButton({
    Title = "Reset Speed",
    Content = "Return speed to normal (18)",
    Callback = function()
        local Humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = 18
        end
    end
})

local Section3 = Tab2:AddSection("Abilities")

Section3:AddToggle({
    Title = "Infinite Jump",
    Content = "activate to use infinite jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Section3:AddToggle({
    Title = "Noclip",
    Content = "Walk through walls",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
        task.spawn(function()
            local Player = game:GetService("Players").LocalPlayer
            while _G.Noclip do
                task.wait(0.1)
                if Player.Character then
                    for _, part in pairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
})

local freezeConnection
local originalCFrame

Section3:AddToggle({
    Title = "Freeze Character",
    Content = "Freeze your character in place",
    Default = false,
    Callback = function(state)
        _G.FreezeCharacter = state
        if state then
            local character = game.Players.LocalPlayer.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    originalCFrame = root.CFrame
                    freezeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                        if _G.FreezeCharacter and root then
                            root.CFrame = originalCFrame
                        end
                    end)
                end
            end
        else
            if freezeConnection then
                freezeConnection:Disconnect()
                freezeConnection = nil
            end
        end
    end
})

player.CharacterAdded:Connect(function(char)
    if _G.FreezeCharacter then
        task.wait(0.5)
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = originalCFrame
        end
    end
end)

local a=game:GetService("ReplicatedStorage")
local b=game:GetService("RunService")

local c={d=false,e=1.6,f=0.37}

local g=a:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local h,i,j,k,l
pcall(function()
    h=g:WaitForChild("RF/ChargeFishingRod")
    i=g:WaitForChild("RF/RequestFishingMinigameStarted")
    j=g:WaitForChild("RE/FishingCompleted")
    k=g:WaitForChild("RE/EquipToolFromHotbar")
    l=g:WaitForChild("RF/CancelFishingInputs")
end)

local m=nil
local n=nil
local o=nil

local function p()
    task.spawn(function()
        pcall(function()
            local q,r=l:InvokeServer()
            if not q then
                while not q do
                    local s=l:InvokeServer()
                    if s then break end
                    task.wait(0.05)
                end
            end
            local t,u=h:InvokeServer(math.huge)
            if not t then
                while not t do
                    local v=h:InvokeServer(math.huge)
                    if v then break end
                    task.wait(0.05)
                end
            end
            i:InvokeServer(-139.63,0.996)
        end)
    end)
    task.spawn(function()
        task.wait(c.f)
        if c.d then
            pcall(j.FireServer,j)
        end
    end)
end

local function w()
    n=task.spawn(function()
        while c.d do
            pcall(k.FireServer,k,1)
            task.wait(1.5)
        end
    end)
    while c.d do
        p()
        task.wait(c.e)
        if not c.d then break end
        task.wait(0.1)
    end
end

local function x(y)
    c.d=y
    if y then
        if m then task.cancel(m) end
        if n then task.cancel(n) end
        m=task.spawn(w)
    else
        if m then task.cancel(m) end
        if n then task.cancel(n) end
        m=nil
        n=nil
        pcall(l.InvokeServer,l)
    end
end

local Tab3 = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://16932740082"
})

local Section3_1 = Tab3:AddSection("Fishing")

_G.AutoFishing = false
_G.AutoEquipRod = false
_G.AutoSell = false
_G.Radar = false
_G.Instant = false
_G.SellDelay = _G.SellDelay or 30
_G.InstantDelay = _G.InstantDelay or 0.35
_G.CallMinDelay = _G.CallMinDelay or 0.18
_G.CallBackoff = _G.CallBackoff or 1.5

local lastCall = {}
local function safeCall(k, f)
    local n = os.clock()
    if lastCall[k] and n - lastCall[k] < _G.CallMinDelay then
        task.wait(_G.CallMinDelay - (n - lastCall[k]))
    end
    local ok, result = pcall(f)
    lastCall[k] = os.clock()
    if not ok then
        local msg = tostring(result):lower()
        task.wait(msg:find("429") or msg:find("too many requests") and _G.CallBackoff or 0.2)
    end
    return ok, result
end

local RS = game:GetService("ReplicatedStorage")
local net = RS.Packages._Index["sleitnick_net@0.2.0"].net

local function rod()
    safeCall("rod", function()
        net["RE/EquipToolFromHotbar"]:FireServer(1)
    end)
end

local function sell()
    safeCall("sell", function()
        net["RF/SellAllItems"]:InvokeServer()
    end)
end

local function autoon()
    safeCall("autoon", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(true)
    end)
end

local function autooff()
    safeCall("autooff", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(false)
    end)
end

local function catch()
    safeCall("catch", function()
        net["RE/FishingCompleted"]:FireServer()
    end)
end

local function charge()
    safeCall("charge", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function lempar()
    safeCall("lempar", function()
        net["RF/RequestFishingMinigameStarted"]:InvokeServer(-139.63, 0.996, -1761532005.497)
    end)
    safeCall("charge2", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function autosell()
    while _G.AutoSell do
        sell()
        local d = tonumber(_G.SellDelay) or 30
        local t = 0
        while t < d and _G.AutoSell do
            task.wait(0.25)
            t += 0.25
        end
    end
end

local function instant_cycle()
    charge()
    lempar()
    task.wait(_G.InstantDelay)
    catch()
end

Section4:AddToggle({
    Title = "Auto Equip Rod",
    Content = "Automatically equip fishing rod",
    Default = false,
    Callback = function(v)
        _G.AutoEquipRod = v
        if v then rod() end
    end
})

local mode = "Instant"
local fishThread
local sellThread

Section4:AddDropdown({
    Title = "Mode",
    Content = "Select fishing mode",
    Multi = false,
    Options = {"Instant", "Legit"},
    Default = {"Instant"},
    Callback = function(v)
        mode = v
    end
})

Section4:AddToggle({
    Title = "Auto Fishing",
    Content = "Automatically fish",
    Default = false,
    Callback = function(v)
        _G.AutoFishing = v
        if v then
            if mode == "Instant" then
                _G.Instant = true
                if fishThread then fishThread = nil end
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Instant" do
                        instant_cycle()
                        task.wait(0.35)
                    end
                end)
            else
                if fishThread then fishThread = nil end
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Legit" do
                        autoon()
                        task.wait(1)
                    end
                end)
            end
        else
            autooff()
            _G.Instant = false
            if fishThread then task.cancel(fishThread) end
            fishThread = nil
        end
    end
})

Section4:AddSlider({
    Title = "Instant Fishing Delay",
    Content = "Delay between catches",
    Min = 0.05,
    Max = 5,
    Default = 0.65,
    Callback = function(v)
        _G.InstantDelay = v
    end
})

local Section5 = Tab3:AddSection("Auto Sell")

Section5:AddToggle({
    Title = "Auto Sell",
    Content = "Automatically sell items",
    Default = false,
    Callback = function(v)
        _G.AutoSell = v
        if v then
            if sellThread then task.cancel(sellThread) end
            sellThread = task.spawn(autosell)
        else
            _G.AutoSell = false
            if sellThread then task.cancel(sellThread) end
            sellThread = nil
        end
    end
})

Section5:AddSlider({
    Title = "Sell Delay",
    Content = "Delay between auto sells (seconds)",
    Min = 1,
    Max = 120,
    Default = 30,
    Callback = function(v)
        _G.SellDelay = v
    end
})

local Section6 = Tab3:AddSection("Item")

Section6:AddToggle({
    Title = "Radar",
    Content = "Enable fishing radar",
    Default = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        local Replion = require(RS.Packages.Replion).Client:GetReplion("Data")
        local NetFunction = require(RS.Packages.Net):RemoteFunction("UpdateFishingRadar")
        if Replion and NetFunction:InvokeServer(state) then
            local sound = require(RS.Shared.Soundbook).Sounds.RadarToggle:Play()
            sound.PlaybackSpeed = 1 + math.random() * 0.3
            local c = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")
            if c then
                require(RS.Packages.spr).stop(c)
                local time = require(RS.Controllers.ClientTimeController)
                local profile = time._getLightingProfile and time:_getLightingProfile() or {}
                local correction = profile.ColorCorrection or {}
                correction.Brightness = correction.Brightness or 0.04
                correction.TintColor = correction.TintColor or Color3.fromRGB(255,255,255)
                if state then
                    c.TintColor = Color3.fromRGB(42, 226, 118)
                    c.Brightness = 0.4
                else
                    c.TintColor = Color3.fromRGB(255, 0, 0)
                    c.Brightness = 0.2
                end
                require(RS.Packages.spr).target(c, 1, 1, correction)
            end
            require(RS.Packages.spr).stop(Lighting)
            Lighting.ExposureCompensation = 1
            require(RS.Packages.spr).target(Lighting, 1, 2, {ExposureCompensation = 0})
        end
    end
})

Section6:AddToggle({
    Title = "Diving Gear",
    Content = "Oxygen Tank",
    Default = false,
    Callback = function(state)
        _G.DivingGear = state
        local RemoteFolder = RS.Packages._Index["sleitnick_net@0.2.0"].net
        if state then
            RemoteFolder["RF/EquipOxygenTank"]:InvokeServer(105)
        else
            RemoteFolder["RF/UnequipOxygenTank"]:InvokeServer()
        end
    end
})

local Section7 = Tab3:AddSection("Gameplay")

Section7:AddToggle({
    Title = "FPS Boost",
    Content = "Optimizes performance for smooth gameplay",
    Default = false,
    Callback = function(state)
        _G.FPSBoost = state
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        _G._FPSObjects = _G._FPSObjects or {}
        if state then
            if not _G.OldSettings then
                _G.OldSettings = {
                    GlobalShadows = Lighting.GlobalShadows,
                    FogEnd = Lighting.FogEnd,
                    Brightness = Lighting.Brightness,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient,
                    ColorShift_Top = Lighting.ColorShift_Top,
                    ColorShift_Bottom = Lighting.ColorShift_Bottom,
                    WaterTransparency = Terrain and Terrain.WaterTransparency,
                    WaterReflectance = Terrain and Terrain.WaterReflectance,
                    WaterWaveSize = Terrain and Terrain.WaterWaveSize,
                    WaterWaveSpeed = Terrain and Terrain.WaterWaveSpeed
                }
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e10
            Lighting.Brightness = 0
            Lighting.Ambient = Color3.new(1,1,1)
            Lighting.OutdoorAmbient = Color3.new(1,1,1)
            Lighting.ColorShift_Top = Color3.new(0,0,0)
            Lighting.ColorShift_Bottom = Color3.new(0,0,0)
            if Terrain then
                Terrain.WaterTransparency = 1
                Terrain.WaterReflectance = 0
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
            end
            for _,v in ipairs(workspace:GetDescendants()) do
                if not _G._FPSObjects[v] then
                    if v:IsA("BasePart") then
                        _G._FPSObjects[v] = {
                            Material = v.Material,
                            Color = v.Color,
                            CastShadow = v.CastShadow,
                            Reflectance = v.Reflectance
                        }
                        v.Material = Enum.Material.SmoothPlastic
                        v.Color = Color3.new(1,1,1)
                        v.CastShadow = false
                        v.Reflectance = 0
                    elseif v:IsA("Light") then
                        _G._FPSObjects[v] = {Enabled = v.Enabled}
                        v.Enabled = false
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                        _G._FPSObjects[v] = {Enabled = v.Enabled}
                        v.Enabled = false
                    end
                end
            end
        else
            if _G.OldSettings then
                Lighting.GlobalShadows = _G.OldSettings.GlobalShadows
                Lighting.FogEnd = _G.OldSettings.FogEnd
                Lighting.Brightness = _G.OldSettings.Brightness
                Lighting.Ambient = _G.OldSettings.Ambient
                Lighting.OutdoorAmbient = _G.OldSettings.OutdoorAmbient
                Lighting.ColorShift_Top = _G.OldSettings.ColorShift_Top
                Lighting.ColorShift_Bottom = _G.OldSettings.ColorShift_Bottom

                if Terrain then
                    Terrain.WaterTransparency = _G.OldSettings.WaterTransparency
                    Terrain.WaterReflectance = _G.OldSettings.WaterReflectance
                    Terrain.WaterWaveSize = _G.OldSettings.WaterWaveSize
                    Terrain.WaterWaveSpeed = _G.OldSettings.WaterWaveSpeed
                end
            end
            for obj,data in pairs(_G._FPSObjects) do
                if obj and obj.Parent then
                    if obj:IsA("BasePart") then
                        obj.Material = data.Material
                        obj.Color = data.Color
                        obj.CastShadow = data.CastShadow
                        obj.Reflectance = data.Reflectance
                    elseif obj:IsA("Light") or obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = data.Enabled
                    end
                end
            end
            table.clear(_G._FPSObjects)
        end
    end
})

Section7:AddToggle({
    Title = "Black Screen",
    Content = "Show STREE HUB black screen",
    Default = false,
    Callback = function(state)
        if state then
            local ScreenGui = Instance.new("ScreenGui")
            local Frame = Instance.new("Frame")
            local Image = Instance.new("ImageLabel")
            local Text1 = Instance.new("TextLabel")
            local Text2 = Instance.new("TextLabel")

            ScreenGui.Name = "STREE_BlackScreen"
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ResetOnSpawn = false
            ScreenGui.Parent = game.CoreGui

            Frame.Parent = ScreenGui
            Frame.AnchorPoint = Vector2.new(0, 0)
            Frame.Position = UDim2.new(0, 0, 0, 0)
            Frame.Size = UDim2.new(1, 0, 1, 0)
            Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Frame.BorderSizePixel = 0

            Image.Parent = Frame
            Image.AnchorPoint = Vector2.new(0.5, 0.5)
            Image.Position = UDim2.new(0.5, 0, 0.45, 0)
            Image.Size = UDim2.new(0, 180, 0, 180)
            Image.BackgroundTransparency = 1
            Image.Image = "rbxassetid://122683047852451"

            Text1.Parent = Frame
            Text1.AnchorPoint = Vector2.new(0.5, 0)
            Text1.Position = UDim2.new(0.5, 0, 0.7, 0)
            Text1.Size = UDim2.new(0, 400, 0, 50)
            Text1.BackgroundTransparency = 1
            Text1.Text = "STREE HUB | Fish It"
            Text1.TextColor3 = Color3.fromRGB(0, 255, 0)
            Text1.Font = Enum.Font.GothamBold
            Text1.TextSize = 28

            Text2.Parent = Frame
            Text2.AnchorPoint = Vector2.new(0.5, 0)
            Text2.Position = UDim2.new(0.5, 0, 0.78, 0)
            Text2.Size = UDim2.new(0, 400, 0, 30)
            Text2.BackgroundTransparency = 1
            Text2.Text = "discord.gg/jdmX43t5mY"
            Text2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text2.Font = Enum.Font.Gotham
            Text2.TextSize = 20
        else
            if game.CoreGui:FindFirstChild("STREE_BlackScreen") then
                game.CoreGui.STREE_BlackScreen:Destroy()
            end
        end
    end
})

local Section8 = Tab3:AddSection("Enchant Features")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Data = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local equipItemRemote = Net:FindFirstChild("RE/EquipItem")
local activateAltarRemote = Net:FindFirstChild("RE/ActivateEnchantingAltar")
local equipToolRemote = Net:FindFirstChild("RE/EquipToolFromHotbar")
local activateAltarRemote2 = Net:FindFirstChild("RE/ActivateEnchantingAltar")

function gStone()
    local it = Data:GetExpect({ "Inventory", "Items" })
    local t = 0
    for _, v in ipairs(it) do
        local i = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if i and i.Data.Type == "Enchant Stones" then t += v.Quantity or 1 end
    end
    return t
end

local enchantNames = {
    "Big Hunter 1", "Cursed 1", "Empowered 1", "Glistening 1",
    "Gold Digger 1", "Leprechaun 1", "Leprechaun 2",
    "Mutation Hunter 1", "Mutation Hunter 2", "Prismatic 1",
    "Reeler 1", "Stargazer 1", "Stormhunter 1", "XPerienced 1"
}

local enchantIdMap = {
    ["Big Hunter 1"] = 3, ["Cursed 1"] = 12, ["Empowered 1"] = 9,
    ["Glistening 1"] = 1, ["Gold Digger 1"] = 4, ["Leprechaun 1"] = 5,
    ["Leprechaun 2"] = 6, ["Mutation Hunter 1"] = 7, ["Mutation Hunter 2"] = 14,
    ["Prismatic 1"] = 13, ["Reeler 1"] = 2, ["Stargazer 1"] = 8,
    ["Stormhunter 1"] = 11, ["XPerienced 1"] = 10
}

function countDisplayImageButtons()
    local success, backpackGui = pcall(function() return LocalPlayer.PlayerGui.Backpack end)
    if not success or not backpackGui then return 0 end
    local display = backpackGui:FindFirstChild("Display")
    if not display then return 0 end
    local imageButtonCount = 0
    for _, child in ipairs(display:GetChildren()) do
        if child:IsA("ImageButton") then
            imageButtonCount += 1
        end
    end
    return imageButtonCount
end

function findEnchantStones()
    if not Data then return {} end
    local inventory = Data:GetExpect({ "Inventory", "Items" })
    if not inventory then return {} end
    local stones = {}
    for _, item in pairs(inventory) do
        local def = ItemUtility:GetItemData(item.Id)
        if def and def.Data and def.Data.Type == "Enchant Stones" then
            table.insert(stones, { UUID = item.UUID, Quantity = item.Quantity or 1 })
        end
    end
    return stones
end

function getEquippedRodName()
    local equipped = Data:Get("EquippedItems") or {}
    local rods = Data:GetExpect({ "Inventory", "Fishing Rods" }) or {}
    for _, uuid in pairs(equipped) do
        for _, rod in ipairs(rods) do
            if rod.UUID == uuid then
                local itemData = ItemUtility:GetItemData(rod.Id)
                if itemData and itemData.Data and itemData.Data.Name then
                    return itemData.Data.Name
                elseif rod.ItemName then
                    return rod.ItemName
                end
            end
        end
    end
    return "None"
end

function getCurrentRodEnchant()
    if not Data then return nil end
    local equipped = Data:Get("EquippedItems") or {}
    local rods = Data:GetExpect({ "Inventory", "Fishing Rods" }) or {}
    for _, uuid in pairs(equipped) do
        for _, rod in ipairs(rods) do
            if rod.UUID == uuid and rod.Metadata and rod.Metadata.EnchantId then
                return rod.Metadata.EnchantId
            end
        end
    end
    return nil
end

Section8:AddParagraph({
    Title = "Enchanting Features",
    Content = "Loading..."
})

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(1) do
        local stones = findEnchantStones()
        local totalStones = 0
        for _, s in ipairs(stones) do
            totalStones += s.Quantity or 0
        end
        local rodName = getEquippedRodName()
        local currentEnchantId = getCurrentRodEnchant()
        local currentEnchantName = "None"
        if currentEnchantId then
            for name, id in pairs(enchantIdMap) do
                if id == currentEnchantId then
                    currentEnchantName = name
                    break
                end
            end
        end
        local desc =
            "Rod Active = " .. rodName .. "\n" ..
            "Enchant Now = " .. currentEnchantName .. "\n" ..
            "Enchant Stone Left = " .. totalStones
    end
end))

Section8:AddDropdown({
    Title = "Target Enchant",
    Content = "Select enchant to target",
    Multi = false,
    Options = enchantNames,
    Default = {enchantNames[1]},
    Callback = function(selected)
        _G.TargetEnchant = selected
    end
})

Section8:AddToggle({
    Title = "Auto Enchant",
    Content = "Automatically enchant rods",
    Default = false,
    Callback = function(value)
        _G.AutoEnchant = value
    end
})

function getData(stoneId)
    local rod, ench, stones, uuids = "None", "None", 0, {}
    local equipped = Data:Get("EquippedItems") or {}
    local rods = Data:Get({ "Inventory", "Fishing Rods" }) or {}

    for _, u in pairs(equipped) do
        for _, r in ipairs(rods) do
            if r.UUID == u then
                local d = ItemUtility:GetItemData(r.Id)
                rod = (d and d.Data.Name) or r.ItemName or "None"
                if r.Metadata and r.Metadata.EnchantId then
                    local e = ItemUtility:GetEnchantData(r.Metadata.EnchantId)
                    ench = (e and e.Data.Name) or "None"
                end
            end
        end
    end

    for _, it in pairs(Data:GetExpect({ "Inventory", "Items" })) do
        local d = ItemUtility:GetItemData(it.Id)
        if d and d.Data.Type == "Enchant Stones" and it.Id == stoneId then
            stones += 1
            table.insert(uuids, it.UUID)
        end
    end
    return rod, ench, stones, uuids
end

Section8:AddButton({
    Title = "Start Double Enchant",
    Content = "Enchant with double stones",
    Callback = function()
        task.spawn(function()
            local rod, ench, s, uuids = getData(246)
            if rod == "None" or s <= 0 then return end

            local slot, start = nil, tick()
            while tick() - start < 5 do
                for sl, id in pairs(Data:Get("EquippedItems") or {}) do
                    if id == uuids[1] then slot = sl end
                end
                if slot then break end
                equipItemRemote:FireServer(uuids[1], "EnchantStones")
                task.wait(0.3)
            end
            if not slot then return end

            equipToolRemote:FireServer(slot)
            task.wait(0.2)
            activateAltarRemote2:FireServer()
        end)
    end
})

spawn( LPH_NO_VIRTUALIZE( function()
    while task.wait() do
        if _G.AutoEnchant then
            local currentEnchantId = getCurrentRodEnchant()
            local targetEnchantId = enchantIdMap[_G.TargetEnchant]

            if currentEnchantId == targetEnchantId then
                _G.AutoEnchant = false
                break
            end

            local enchantStones = findEnchantStones()
            if #enchantStones > 0 then
                local enchantStone = enchantStones[1]
                local args = { enchantStone.UUID, "Enchant Stones" }
                pcall(function()
                    equipItemRemote:FireServer(unpack(args))
                end)

                task.wait(1)

                local imageButtonCount = countDisplayImageButtons()
                local slotNumber = imageButtonCount - 2
                if slotNumber < 1 then slotNumber = 1 end

                pcall(function()
                    equipToolRemote:FireServer(slotNumber)
                end)

                task.wait(1)

                pcall(function()
                    activateAltarRemote:FireServer()
                end)
            end

            task.wait(5)
        end
    end
end))

Section8:AddButton({
    Title = "Teleport to Altar",
    Content = "Teleport to enchanting altar",
    Callback = function()
        local targetCFrame = CFrame.new(3234.83667, -1302.85486, 1398.39087, 0.464485794, -1.12043161e-07, -0.885580599, 6.74793981e-08, 1, -9.11265872e-08, 0.885580599, -1.74314394e-08, 0.464485794)
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = targetCFrame
            end
        end
    end
})

Section8:AddButton({
    Title = "Teleport to Second Altar",
    Content = "Teleport to second enchanting altar",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = CFrame.new(1481, 128, -592)
            character:PivotTo(targetCFrame)
        end
    end
})

local Section9 = Tab3:AddSection("Event")

local RS = game:GetService("ReplicatedStorage")
local Remote = RS.Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net:FindFirstChild("RF/SpecialDialogueEvent")

_G.AutoClaimChristmas = false

Section9:AddToggle({
    Title = "Auto Claim",
    Content = "Auto Claim Christmas Presents",
    Default = false,
    Callback = function(state)
        _G.AutoClaimChristmas = state

        task.spawn(function()
            local NPCs = {
                "Alien Merchant", "Billy Bob", "Seth", "Joe", "Aura Kid", "Boat Expert", "Scott", "Ron", "Jeffery", "McBoatson", "Scientist",
                "Silly Fisherman","Tim", "Santa", "Santa Doge", "Stickmasterluke", "Merely", "Shendletsky", "BrightEyes", "Guest", "Builderman", "Noob", "John Doe"
            }
            
            while _G.AutoClaimChristmas do
                for _, npc in ipairs(NPCs) do
                    if not _G.AutoClaimChristmas then break end
                    pcall(function()
                        Remote:InvokeServer(npc, "ChristmasPresents")
                    end)
                    task.wait(0.15)
                end
                task.wait(2)
            end
        end)
    end
})

local giftRemote = game:GetService("ReplicatedStorage").Packages._Index
    :FindFirstChild("sleitnick_net@0.2.0").net
    :FindFirstChild("RF/RedeemGift")

Section9:AddToggle({
    Title = "Auto Present Factory",
    Content = "Automatically open Present Factory",
    Default = false,
    Callback = function(state)
        _G.AutoPresentFactory = state
        task.spawn(function()
            while _G.AutoPresentFactory do
                pcall(function()
                    giftRemote:InvokeServer()
                end)
                task.wait(0.5)
            end
        end)
    end
})

local Tab4 = Window:CreateTab({
    Name = "Exclusive",
    Icon = "rbxassetid://16932740082"
})

local Section10 = Tab4:AddSection("Webhook Fish Caught")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local httpRequest = syn and syn.request or http and http.request or http_request or (fluxus and fluxus.request) or
    request
if not httpRequest then return end

local ItemUtility, Replion, DataService
local fishDB = {}
local rarityList = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "SECRET" }
local tierToRarity = {
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "SECRET"
}
local knownFishUUIDs = {}

pcall(function()
    ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
    Replion = require(ReplicatedStorage.Packages.Replion)
    DataService = Replion.Client:WaitReplion("Data")
end)

function buildFishDatabase()
    local RS = game:GetService("ReplicatedStorage")
    local itemsContainer = RS:WaitForChild("Items")
    if not itemsContainer then return end

    for _, itemModule in ipairs(itemsContainer:GetChildren()) do
        local success, itemData = pcall(require, itemModule)
        if success and type(itemData) == "table" and itemData.Data and itemData.Data.Type == "Fish" then
            local data = itemData.Data
            if data.Id and data.Name then
                fishDB[data.Id] = {
                    Name = data.Name,
                    Tier = data.Tier,
                    Icon = data.Icon,
                    SellPrice = itemData.SellPrice
                }
            end
        end
    end
end
function getInventoryFish()
    if not (DataService and ItemUtility) then return {} end
    local inventoryItems = DataService:GetExpect({ "Inventory", "Items" })
    local fishes = {}
    for _, v in pairs(inventoryItems) do
        local itemData = ItemUtility.GetItemDataFromItemType("Items", v.Id)
        if itemData and itemData.Data.Type == "Fish" then
            table.insert(fishes, { Id = v.Id, UUID = v.UUID, Metadata = v.Metadata })
        end
    end
    return fishes
end

function getPlayerCoins()
    if not DataService then return "N/A" end
    local success, coins = pcall(function() return DataService:Get("Coins") end)
    if success and coins then return string.format("%d", coins):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") end
    return "N/A"
end

function getThumbnailURL(assetString)
    local assetId = assetString:match("rbxassetid://(%d+)")
    if not assetId then return nil end
    local api = string.format("https://thumbnails.roblox.com/v1/assets?assetIds=%s&type=Asset&size=420x420&format=Png",
        assetId)
    local success, response = pcall(function() return HttpService:JSONDecode(game:HttpGet(api)) end)
    return success and response and response.data and response.data[1] and response.data[1].imageUrl
end

function sendTestWebhook()
    if not httpRequest or not _G.WebhookURL or not _G.WebhookURL:match("discord.com/api/webhooks") then
        return
    end

    local payload = {
        username = "StreeHub Webhook",
        avatar_url = "https://cdn.discordapp.com/attachments/1430527420468953159/1450326233844940904/1752815705447-1000034555-1.png?ex=6942210f&is=6940cf8f&hm=582f526e0391329af202628cfbb3d17780626252e107defd4a5421573d3b7b4b",
        embeds = {{
            title = "Test Webhook Connected",
            description = "Webhook connection successful!",
            color = 0x00FF00
        }}
    }

    pcall(function()
        httpRequest({
            Url = _G.WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

function sendNewFishWebhook(newlyCaughtFish)
    if not httpRequest or not _G.WebhookURL or not _G.WebhookURL:match("discord.com/api/webhooks") then return end

    local newFishDetails = fishDB[newlyCaughtFish.Id]
    if not newFishDetails then return end

    local newFishRarity = tierToRarity[newFishDetails.Tier] or "Unknown"
    if #_G.WebhookRarities > 0 and not table.find(_G.WebhookRarities, newFishRarity) then return end

    local fishWeight = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.Weight and string.format("%.2f Kg", newlyCaughtFish.Metadata.Weight)) or "N/A"
    local mutation   = (newlyCaughtFish.Metadata and newlyCaughtFish.Metadata.VariantId and tostring(newlyCaughtFish.Metadata.VariantId)) or "None"
    local sellPrice  = (newFishDetails.SellPrice and ("$"..string.format("%d", newFishDetails.SellPrice):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "").." Coins")) or "N/A"
    local currentCoins = getPlayerCoins()

    local totalFishInInventory = #getInventoryFish()
    local backpackInfo = string.format("%d/4500", totalFishInInventory)

    local playerName = game.Players.LocalPlayer.Name

    local payload = {
        content = nil,
        embeds = {{
            title = "StreeHub Fish caught!",
            description = string.format("Congrats! **%s** You obtained new **%s** here for full detail fish :", playerName, newFishRarity),
            url = "https://discord.gg/jdmX43t5mY",
            color = 65280,
            fields = {
                { name = "Name Fish :",        value = "```\n"..newFishDetails.Name.."```" },
                { name = "Rarity :",           value = "```"..newFishRarity.."```" },
                { name = "Weight :",           value = "```"..fishWeight.."```" },
                { name = "Mutation :",         value = "```"..mutation.."```" },
                { name = "Sell Price :",       value = "```"..sellPrice.."```" },
                { name = "Backpack Counter :", value = "```"..backpackInfo.."```" },
                { name = "Current Coin :",     value = "```"..currentCoins.."```" },
            },
            footer = {
                text = "StreeHub Webhook",
                icon_url = "https://cdn.discordapp.com/attachments/1430527420468953159/1450326233844940904/1752815705447-1000034555-1.png?ex=6942210f&is=6940cf8f&hm=582f526e0391329af202628cfbb3d17780626252e107defd4a5421573d3b7b4b"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
            thumbnail = {
                url = getThumbnailURL(newFishDetails.Icon)
            }
        }},
        username = "StreeHub Webhook",
        avatar_url = "https://cdn.discordapp.com/attachments/1430527420468953159/1450326233844940904/1752815705447-1000034555-1.png?ex=6942210f&is=6940cf8f&hm=582f526e0391329af202628cfbb3d17780626252e107defd4a5421573d3b7b4b",
        attachments = {}
    }

    pcall(function()
        httpRequest({
            Url = _G.WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

Section10:AddInput({
    Title = "URL Webhook",
    Content = "Paste your Discord Webhook URL here",
    Placeholder = "Webhook URL",
    Callback = function(text)
        _G.WebhookURL = text
    end
})

Section10:AddDropdown({
    Title = "Rarity Filter",
    Content = "Select rarities to notify",
    Multi = true,
    Options = rarityList,
    Default = {},
    Callback = function(selected_options)
        _G.WebhookRarities = selected_options
    end
})

Section10:AddToggle({
    Title = "Send Webhook",
    Content = "Enable webhook notifications",
    Default = false,
    Callback = function(state)
        _G.DetectNewFishActive = state
    end
})

Section10:AddButton({
    Title = "Test Webhook",
    Content = "Test webhook connection",
    Callback = sendTestWebhook
})

buildFishDatabase()

spawn( LPH_NO_VIRTUALIZE( function()
    local initialFishList = getInventoryFish()
    for _, fish in ipairs(initialFishList) do
        if fish and fish.UUID then
            knownFishUUIDs[fish.UUID] = true
        end
    end
end))

spawn( LPH_NO_VIRTUALIZE( function()
    while wait(0.1) do
        if _G.DetectNewFishActive then
            local currentFishList = getInventoryFish()
            for _, fish in ipairs(currentFishList) do
                if fish and fish.UUID and not knownFishUUIDs[fish.UUID] then
                    knownFishUUIDs[fish.UUID] = true
                    sendNewFishWebhook(fish)
                end
            end
        end
        wait(3)
    end
end))

local Section11 = Tab4:AddSection("Blantant Fishing")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Config = {
    blantant = false,
    cancel = 100,
    complete = 100
}

local Net = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local charge
local requestminigame
local fishingcomplete
local equiprod
local cancelinput
local ReplicateTextEffect
local BaitSpawned
local BaitDestroyed

pcall(function()
    charge               = Net:WaitForChild("RF/ChargeFishingRod")
    requestminigame       = Net:WaitForChild("RF/RequestFishingMinigameStarted")
    fishingcomplete       = Net:WaitForChild("RE/FishingCompleted")
    equiprod              = Net:WaitForChild("RE/EquipToolFromHotbar")
    cancelinput           = Net:WaitForChild("RF/CancelFishingInputs")
    ReplicateTextEffect   = Net:WaitForChild("RE/ReplicateTextEffect")
    BaitSpawned           = Net:WaitForChild("RE/BaitSpawned")
    BaitDestroyed         = Net:WaitForChild("RE/BaitDestroyed")
end)

local mainThread
local equipThread

local exclaimDetected = false
local bait = 0

ReplicateTextEffect.OnClientEvent:Connect(function(data)
    local char = LocalPlayer.Character
    if not char or not data.TextData or not data.TextData.AttachTo then return end

    if data.TextData.AttachTo:IsDescendantOf(char)
        and data.TextData.Text == "!" then
        exclaimDetected = true
    end
end)

if BaitSpawned then
    BaitSpawned.OnClientEvent:Connect(function(bobber, position, owner)
        if owner and owner ~= LocalPlayer then return end
        bait = 1
    end)
end

if BaitDestroyed then
    BaitDestroyed.OnClientEvent:Connect(function(bobber)
        bait = 0
    end)
end

local function StartCast()
    task.spawn(function()
        pcall(function()
            local ok = cancelinput:InvokeServer()
            if not ok then
                repeat ok = cancelinput:InvokeServer() until ok
            end

            local charged = charge:InvokeServer(math.huge)
            if not charged then
                repeat charged = charge:InvokeServer(math.huge) until charged
            end

            requestminigame:InvokeServer(1, 0.05, 1731873.1873)
        end)
    end)

    task.spawn(function()
        exclaimDetected = false

        local timeout = 20
        local timer = 0

        while Config.blantant and timer < timeout do
            if exclaimDetected and bait == 0 then
                break
            end
            task.wait(0.01)
            timer += 0.1
        end

        if not Config.blantant then return end
        if not (exclaimDetected and bait == 0) then return end

        task.wait(Config.complete)

        if Config.blantant then
            pcall(fishingcomplete.FireServer, fishingcomplete)
        end
    end)
end

local function MainLoop()
    equipThread = task.spawn(function()
        while Config.blantant do
            pcall(equiprod.FireServer, equiprod, 1)
            task.wait(1.5)
        end
    end)

    while Config.blantant do
        StartCast()
        task.wait(Config.cancel)
        if not Config.blantant then break end
        task.wait(0.1)
    end
end

local function Toggle(state)
    Config.blantant = state

    if state then
        if mainThread then task.cancel(mainThread) end
        if equipThread then task.cancel(equipThread) end
        mainThread = task.spawn(MainLoop)
    else
        if mainThread then task.cancel(mainThread) end
        if equipThread then task.cancel(equipThread) end
        mainThread = nil
        equipThread = nil
        bait = 0
        pcall(cancelinput.InvokeServer, cancelinput)
    end
end

Section11:AddToggle({
    Title = "Blantant",
    Content = "Enable blatant fishing",
    Default = false,
    Callback = Toggle
})

Section11:AddInput({
    Title = "Delay Bait",
    Content = "Bait delay in seconds",
    Placeholder = "100",
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.cancel = n
        end
    end
})

Section11:AddInput({
    Title = "Delay Reel",
    Content = "Reel delay in seconds",
    Placeholder = "100",
    Callback = function(v)
        local n = tonumber(v)
        if n and n > 0 then
            Config.complete = n
        end
    end
})

local Section12 = Tab4:AddSection("Premium")

local VFX = require(game:GetService("ReplicatedStorage").Controllers.VFXController)

local ORI = {
    H = VFX.Handle,
    P = VFX.RenderAtPoint,
    I = VFX.RenderInstance
}

Section12:AddToggle({
    Title = "Remove Skin Effect",
    Content = "Remove Your Skin Effect",
    Default = false,
    Callback = function(state)
        if state then
            VFX.Handle = function() end
            VFX.RenderAtPoint = function() end
            VFX.RenderInstance = function() end

            local f = workspace:FindFirstChild("CosmeticFolder")
            if f then
                pcall(f.ClearAllChildren, f)
            end
        else
            VFX.Handle = ORI.H
            VFX.RenderAtPoint = ORI.P
            VFX.RenderInstance = ORI.I
        end
    end
})

RE = {
    FavoriteItem = Net:FindFirstChild("RE/FavoriteItem"),
    FavoriteStateChanged = Net:FindFirstChild("RE/FavoriteStateChanged"),
}

local Section13 = Tab4:AddSection("Auto Favorite")

local REFishCaught = RE.FishCaught or Net:WaitForChild("RE/FishCaught")
local REFishingCompleted = RE.FishingCompleted or Net:WaitForChild("RE/FishingCompleted")

if REFishCaught then
    REFishCaught.OnClientEvent:Connect(function()
        st.canFish = true
    end)
end

if REFishingCompleted then
    REFishingCompleted.OnClientEvent:Connect(function()
        st.canFish = true
    end)
end

tierToRarity = {
    [1] = "Uncommon",
    [2] = "Common",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "Secret"
}

Items = ReplicatedStorage:WaitForChild("Items")

fishNames = {}
for _, module in ipairs(Items:GetChildren()) do
    if module:IsA("ModuleScript") then
        local ok, data = pcall(require, module)
        if ok and data.Data and data.Data.Type == "Fish" then
            table.insert(fishNames, data.Data.Name)
        end
    end
end
table.sort(fishNames)

local favState, selectedName, selectedRarity = {}, {}, {}

if RE.FavoriteStateChanged then
    RE.FavoriteStateChanged.OnClientEvent:Connect(function(uuid, fav)
        if uuid then favState[uuid] = fav end
    end)
end

local function checkAndFavorite(item)
    if not st.autoFavEnabled then return end
    local info = ItemUtility.GetItemDataFromItemType("Items", item.Id)
    if not info or info.Data.Type ~= "Fish" then return end

    local rarity = tierToRarity[info.Data.Tier]
    local nameMatches = table.find(selectedName, info.Data.Name)
    local rarityMatches = table.find(selectedRarity, rarity)
    local isFav = favState[item.UUID] or item.Favorited or false
    local shouldFav = (nameMatches or rarityMatches) and not isFav

    if shouldFav and RE.FavoriteItem then
        RE.FavoriteItem:FireServer(item.UUID, true)
        favState[item.UUID] = true
    end
end

local function scanInventory()
    if not st.autoFavEnabled then return end
    local inv = Data:GetExpect({ "Inventory", "Items" })
    if not inv then return end
    for _, item in ipairs(inv) do checkAndFavorite(item) end
end

Data:OnChange({ "Inventory", "Items" }, function()
    if st.autoFavEnabled then scanInventory() end
end)

Section13:AddDropdown({
    Title = "Favorite by Name",
    Content = "Select fish names to auto-favorite",
    Multi = true,
    Options = #fishNames > 0 and fishNames or { "No Data" },
    Default = {},
    Callback = function(opts)
        selectedName = opts or {}
        if st.autoFavEnabled then scanInventory() end
    end
})

Section13:AddDropdown({
    Title = "Favorite by Rarity",
    Content = "Select rarities to auto-favorite",
    Multi = true,
    Options = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret" },
    Default = {},
    Callback = function(opts)
        selectedRarity = opts or {}
        if st.autoFavEnabled then scanInventory() end
    end
})

Section13:AddToggle({
    Title = "Start Auto Favorite",
    Content = "Enable auto favorite",
    Default = false,
    Callback = function(state)
        st = st or {}
        st.autoFavEnabled = state
        if st.autoFavEnabled then scanInventory() end
    end
})

Section13:AddButton({
    Title = "Unfavorite All",
    Content = "Remove all favorites",
    Callback = function()
        local inv = Data:GetExpect({ "Inventory", "Items" })
        if not inv then return end
        for _, item in ipairs(inv) do
            if (item.Favorited or favState[item.UUID]) and RE.FavoriteItem then
                RE.FavoriteItem:FireServer(item.UUID, false)
                favState[item.UUID] = false
            end
        end
    end
})

local Section14 = Tab4:AddSection("Totem")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Net = ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
local EquipItem = Net:FindFirstChild("RE/EquipItem")
local SpawnTotem = Net:FindFirstChild("RE/SpawnTotem")

_G.AutoSpawnTotem = false
_G.SelectedTotem = "Lucky"
_G.TotemUUID = nil

local TotemDisplay = {
    "Lucky",
    "Mutation",
    "Shiny"
}

local function findTotemsFolder()
    for _, v in pairs(LocalPlayer:GetChildren()) do
        if string.lower(v.Name) == "totems" then
            return v
        end
    end
    return nil
end

local function findUUIDFromGame(selected)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") then
            local n = string.lower(v.Name)
            if string.find(n, "lucky") or string.find(n, "mutation") or string.find(n, "shiny") then
                if string.find(n, string.lower(selected)) then
                    local uuid = v:FindFirstChild("ItemId") or v:FindFirstChild("ItemUUID")
                    if uuid and uuid:IsA("ValueBase") then
                        return uuid.Value
                    end
                end
            end
        end
    end
    return nil
end

local function getUUIDFromInventory(selected)
    local folder = findTotemsFolder()
    if not folder then return nil end
    for _, v in pairs(folder:GetDescendants()) do
        if v:IsA("ValueBase") and string.lower(v.Name) == "name" then
            if string.find(string.lower(tostring(v.Value)), string.lower(selected)) then
                local uuid = v.Parent:FindFirstChild("ItemId") or v.Parent:FindFirstChild("ItemUUID")
                if uuid and uuid:IsA("ValueBase") then
                    return uuid.Value
                end
            end
        end
    end
    return nil
end

Section14:AddDropdown({
    Title = "Select Totem",
    Content = "Choose which totem to spawn",
    Multi = false,
    Options = TotemDisplay,
    Default = {"Lucky"},
    Callback = function(option)
        _G.SelectedTotem = option
        _G.TotemUUID = getUUIDFromInventory(option) or findUUIDFromGame(option)
    end
})

Section14:AddToggle({
    Title = "Auto Spawn Totem",
    Content = "Equip & spawn selected totem",
    Default = false,
    Callback = function(state)
        _G.AutoSpawnTotem = state
        if not state then return end
        task.spawn(function()
            while _G.AutoSpawnTotem do
                task.wait(1)
                local uuid = _G.TotemUUID or getUUIDFromInventory(_G.SelectedTotem) or findUUIDFromGame(_G.SelectedTotem)
                if uuid then
                    _G.TotemUUID = uuid
                    pcall(function()
                        EquipItem:FireServer(uuid, "Totems")
                        task.wait(0.2)
                        SpawnTotem:FireServer(uuid)
                    end)
                end
            end
        end)
    end
})

local Tab5 = Window:CreateTab({
    Name = "Shop",
    Icon = "rbxassetid://16932740082"
})

local Section15 = Tab5:AddSection("Buy Rod")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]

local rods = {
    ["Luck Rod (350 Coins)"] = 79,
    ["Carbon Rod (900 Coins)"] = 76,
    ["Grass Rod (1.5k Coins)"] = 85,
    ["Demascus Rod (3k Coins)"] = 77,
    ["Ice Rod (5k Coins)"] = 78,
    ["Lucky Rod (15k Coins)"] = 4,
    ["Midnight Rod (50k Coins)"] = 80,
    ["Steampunk Rod (215k Coins)"] = 6,
    ["Chrome Rod (437k Coins)"] = 7,
    ["Astral Rod (1M Coins)"] = 5,
    ["Ares Rod (3M Coins)"] = 126,
    ["Angler Rod (8M Coins)"] = 168,
    ["Bamboo Rod (12M Coins)"] = 258
}

local rodOptions = {}
for name in pairs(rods) do
    table.insert(rodOptions, name)
end
table.sort(rodOptions)

local selectedRod = rodOptions[1]

Section15:AddDropdown({
    Title = "Select Rod",
    Content = "Choose a fishing rod to buy",
    Multi = false,
    Options = rodOptions,
    Default = {rodOptions[1]},
    Callback = function(value)
        selectedRod = value
    end
})

Section15:AddButton({
    Title = "Buy Rod",
    Content = "Purchase selected rod",
    Callback = function()
        local key = string.match(selectedRod, "([%w%s]+)%s%(")
        if key and rods[selectedRod] then
            local success, err = pcall(function()
                RFPurchaseFishingRod:InvokeServer(rods[selectedRod])
            end)
        end
    end
})

local Section16 = Tab5:AddSection("Buy Baits")

local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]  

local baits = {
    ["Luck Bait (1k Coins)"] = 2,
    ["Midnight Bait (3k Coins)"] = 3,
    ["Nature Bait (83.5k Coins)"] = 10,
    ["Chroma Bait (290k Coins)"] = 6,
    ["Dark Matter Bait (630k Coins)"] = 8,
    ["Corrupt Bait (1.15M Coins)"] = 15,
    ["Aether Bait (3.7M Coins)"] = 16,
    ["Floral Bait (4M Coins)"] = 20,
}

local baitOptions = {}
for name in pairs(baits) do
    table.insert(baitOptions, name)
end
table.sort(baitOptions)

local selectedBait = baitOptions[1]  

Section16:AddDropdown({  
    Title = "Select Bait",  
    Content = "Choose bait to buy",
    Multi = false,  
    Options = baitOptions,  
    Default = {baitOptions[1]},  
    Callback = function(value)  
        selectedBait = value  
    end  
})  

Section16:AddButton({  
    Title = "Buy Bait",  
    Content = "Purchase selected bait",
    Callback = function()  
        local key = string.match(selectedBait, "([%w%s]+)%s%(")
        if key and baits[selectedBait] then  
            local success, err = pcall(function()  
                RFPurchaseBait:InvokeServer(baits[selectedBait])  
            end)  
        end  
    end  
})

local Section17 = Tab5:AddSection("Buy Weathers")

local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]

local weatherKeyMap = {
    ["Wind (10k Coins)"] = "Wind",
    ["Snow (15k Coins)"] = "Snow",
    ["Cloudy (20k Coins)"] = "Cloudy",
    ["Storm (35k Coins)"] = "Storm",
    ["Radiant (50k Coins)"] = "Radiant",
    ["Shark Hunt (300k Coins)"] = "Shark Hunt"
}

local weatherOptions = {}
for name in pairs(weatherKeyMap) do
    table.insert(weatherOptions, name)
end
table.sort(weatherOptions)

local selectedWeathers = {}
local autoBuyEnabled = false
local buyDelay = 540

Section17:AddDropdown({
    Title = "Select Weather",
    Content = "Choose weather events to buy",
    Multi = true,
    Options = weatherOptions,
    Default = {},
    Callback = function(values)
        selectedWeathers = values
    end
})

Section17:AddInput({
    Title = "Buy Delay (minutes)",
    Content = "Delay between purchases",
    Placeholder = "9",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            buyDelay = num * 60
        end
    end
})

Section17:AddToggle({
    Title = "Auto Buy Weather",
    Content = "Automatically buy selected weathers",
    Default = false,
    Callback = function(state)
        autoBuyEnabled = state
        if state then
            task.spawn(function()
                while autoBuyEnabled do
                    for _, displayName in ipairs(selectedWeathers) do
                        local key = weatherKeyMap[displayName]
                        if key then
                            local success, err = pcall(function()
                                RFPurchaseWeatherEvent:InvokeServer(key)
                            end)
                        end
                    end
                    task.wait(buyDelay)
                end
            end)
        end
    end
})

local Tab6 = Window:CreateTab({
    Name = "Teleport",
    Icon = "rbxassetid://16932740082"
})

local Section18 = Tab6:AddSection("Island")

local IslandLocations = {
    ["Ancient Jungle"] = Vector3.new(1518, 1, -186),
    ["Christmas Island"] = Vector3.new(708.17, 16.08, 1567.35),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Crater Island"] = Vector3.new(997, 1, 5012),
    ["Crystal Cavern"] = Vector3.new(-1841, -456, 7186),
    ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
    ["Enchant2"] = Vector3.new(1480, 126, -585),
    ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
    ["Fisherman Island"] = Vector3.new(-175, 3, 2772),
    ["Kohana"] = Vector3.new(-603, 3, 719),
    ["Lost Isle"] = Vector3.new(-3643, 1, -1061),
    ["Sysyphus Statue"] = Vector3.new(-3783.26807, -135.073914, -949.946289),
    ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
    ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
}

local islandOptions = {}
for name in pairs(IslandLocations) do
    table.insert(islandOptions, name)
end
table.sort(islandOptions)

local selectedIsland = islandOptions[1]

Section18:AddDropdown({
    Title = "Select Island",
    Content = "Choose an island to teleport to",
    Multi = false,
    Options = islandOptions,
    Default = {islandOptions[1]},
    Callback = function(Value)
        selectedIsland = Value
    end
})

Section18:AddButton({
    Title = "Teleport to Island",
    Content = "Teleport to selected island",
    Callback = function()
        if IslandLocations[selectedIsland] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(IslandLocations[selectedIsland])
        end
    end
})

local Section19 = Tab6:AddSection("Fishing Spot")

local FishingLocations = {
    ["Actient Ruin"] = Vector3.new(6046.67, -588.61, 4608.87),
    ["Christmas Cave"] = Vector3.new(538.17, -580.58, 8898.02),
    ["Christmas Lake"] = Vector3.new(1136.29, 23.72, 1562.07),
    ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
    ["Enchant2"] = Vector3.new(1480, 126, -585),
    ["Kohana"] = Vector3.new(-603, 3, 719),
    ["Levers 1"] = Vector3.new(1475, 4, -847),
    ["Levers 2"] = Vector3.new(882, 5, -321),
    ["levers 3"] = Vector3.new(1425, 6,126),
    ["levers 4"] = Vector3.new(1837, 4, -309),
    ["Sacred Temple"] = Vector3.new(1475, -22, -632),
    ["Sysyphus Statue"] = Vector3.new(-3693,-136, -1045),
    ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
    ["Underground Cellar"] = Vector3.new(2135, -92, -695),
    ["Volcano"] = Vector3.new(-632, 55, 197),
}

local fishingOptions = {}
for name in pairs(FishingLocations) do
    table.insert(fishingOptions, name)
end
table.sort(fishingOptions)

local selectedFishing = fishingOptions[1]

Section19:AddDropdown({
    Title = "Select Spot",
    Content = "Choose fishing spot to teleport to",
    Multi = false,
    Options = fishingOptions,
    Default = {fishingOptions[1]},
    Callback = function(Value)
        selectedFishing = Value
    end
})

Section19:AddButton({
    Title = "Teleport to Fishing Spot",
    Content = "Teleport to selected fishing spot",
    Callback = function()
        if FishingLocations[selectedFishing] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(FishingLocations[selectedFishing])
        end
    end
})

local Section20 = Tab6:AddSection("Location NPC")

local NPC_Locations = {
    ["Alex"] = Vector3.new(43,17,2876),
    ["Aura kid"] = Vector3.new(70,17,2835),
    ["Billy Bob"] = Vector3.new(84,17,2876),
    ["Boat Expert"] = Vector3.new(32,9,2789),
    ["Esoteric Gatekeeper"] = Vector3.new(2101,-30,1350),
    ["Jeffery"] = Vector3.new(-2771,4,2132),
    ["Joe"] = Vector3.new(144,20,2856),
    ["Jones"] = Vector3.new(-671,16,596),
    ["Lava Fisherman"] = Vector3.new(-593,59,130),
    ["McBoatson"] = Vector3.new(-623,3,719),
    ["Ram"] = Vector3.new(-2838,47,1962),
    ["Ron"] = Vector3.new(-48,17,2856),
    ["Scott"] = Vector3.new(-19,9,2709),
    ["Scientist"] = Vector3.new(-6,17,2881),
    ["Seth"] = Vector3.new(107,17,2877),
    ["Silly Fisherman"] = Vector3.new(97,9,2694),
    ["Tim"] = Vector3.new(-604,16,609),
}

local npcOptions = {}
for name in pairs(NPC_Locations) do
    table.insert(npcOptions, name)
end
table.sort(npcOptions)

local selectedNPC = npcOptions[1]

Section20:AddDropdown({
    Title = "Select NPC",
    Content = "Choose NPC to teleport to",
    Multi = false,
    Options = npcOptions,
    Default = {npcOptions[1]},
    Callback = function(Value)
        selectedNPC = Value
    end
})

Section20:AddButton({
    Title = "Teleport to NPC",
    Content = "Teleport to selected NPC",
    Callback = function()
        if NPC_Locations[selectedNPC] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(NPC_Locations[selectedNPC])
        end
    end
})

local Section21 = Tab6:AddSection("Teleport Player")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function GetPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

local SelectedPlayer = nil

Section21:AddDropdown({
    Title = "List Player",
    Content = "Select player to teleport to",
    Multi = false,
    Options = GetPlayerList(),
    Default = {GetPlayerList()[1]},
    Callback = function(option)
        SelectedPlayer = option
    end
})

Section21:AddButton({
    Title = "Teleport to Player (Target)",
    Content = "Teleport to selected player",
    Callback = function()
        if not SelectedPlayer then
            return
        end
        local target = Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame =
                target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

Section21:AddButton({
    Title = "Refresh Player List",
    Content = "Refresh list of online players",
    Callback = function()
        local newList = GetPlayerList()
    end
})

local Section22 = Tab6:AddSection("Event Teleporter")

local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
    character = c
    hrp = c:WaitForChild("HumanoidRootPart")
end)

local megCheckRadius = 150

local autoEventTPEnabled = false
local selectedEvents = {}
local createdEventPlatform = nil

local eventData = {
    ["Worm Hunt"] = {
        TargetName = "Model",
        Locations = {
            Vector3.new(2190.85, -1.4, 97.575), 
            Vector3.new(-2450.679, -1.4, 139.731), 
            Vector3.new(-267.479, -1.4, 5188.531),
            Vector3.new(-327, -1.4, 2422)
        },
        PlatformY = 107,
        Priority = 1,
        Icon = "fish"
    },
    ["Megalodon Hunt"] = {
        TargetName = "Megalodon Hunt",
        Locations = {
            Vector3.new(-1076.3, -1.4, 1676.2),
            Vector3.new(-1191.8, -1.4, 3597.3),
            Vector3.new(412.7, -1.4, 4134.4),
        },
        PlatformY = 107,
        Priority = 2,
        Icon = "anchor"
    },
    ["Ghost Shark Hunt"] = {
        TargetName = "Ghost Shark Hunt",
        Locations = {
            Vector3.new(489.559, -1.35, 25.406), 
            Vector3.new(-1358.216, -1.35, 4100.556), 
            Vector3.new(627.859, -1.35, 3798.081)
        },
        PlatformY = 107,
        Priority = 3,
        Icon = "fish"
    },
    ["Shark Hunt"] = {
        TargetName = "Shark Hunt",
        Locations = {
            Vector3.new(1.65, -1.35, 2095.725),
            Vector3.new(1369.95, -1.35, 930.125),
            Vector3.new(-1585.5, -1.35, 1242.875),
            Vector3.new(-1896.8, -1.35, 2634.375)
        },
        PlatformY = 107,
        Priority = 4,
        Icon = "fish"
    },
}

local eventOptions = {}
for name in pairs(eventData) do
    table.insert(eventOptions, name)
end
table.sort(eventOptions)

local function destroyEventPlatform()
    if createdEventPlatform and createdEventPlatform.Parent then
        createdEventPlatform:Destroy()
        createdEventPlatform = nil
    end
end

local function createAndTeleportToPlatform(targetPos, y)
    destroyEventPlatform()

    local platform = Instance.new("Part")
    platform.Size = Vector3.new(5, 1, 5)
    platform.Position = Vector3.new(targetPos.X, y, targetPos.Z)
    platform.Anchored = true
    platform.Transparency = 1
    platform.CanCollide = true
    platform.Name = "EventPlatform"
    platform.Parent = Workspace
    createdEventPlatform = platform

    hrp.CFrame = CFrame.new(platform.Position + Vector3.new(0, 3, 0))
end

local function runMultiEventTP()
    while autoEventTPEnabled do
        local sorted = {}
        for _, e in ipairs(selectedEvents) do
            if eventData[e] then
                table.insert(sorted, eventData[e])
            end
        end
        table.sort(sorted, function(a, b) return a.Priority < b.Priority end)

        for _, config in ipairs(sorted) do
            local foundTarget, foundPos = nil, nil

            if config.TargetName == "Model" then
                local menuRings = Workspace:FindFirstChild("!!! MENU RINGS")
                if menuRings then
                    for _, props in ipairs(menuRings:GetChildren()) do
                        if props.Name == "Props" then
                            local model = props:FindFirstChild("Model")
                            if model and model.PrimaryPart then
                                for _, loc in ipairs(config.Locations) do
                                    if (model.PrimaryPart.Position - loc).Magnitude <= megCheckRadius then
                                        foundTarget = model
                                        foundPos = model.PrimaryPart.Position
                                        break
                                    end
                                end
                            end
                        end
                        if foundTarget then break end
                    end
                end
            else
                for _, loc in ipairs(config.Locations) do
                    for _, d in ipairs(Workspace:GetDescendants()) do
                        if d.Name == config.TargetName then
                            local pos = d:IsA("BasePart") and d.Position or (d.PrimaryPart and d.PrimaryPart.Position)
                            if pos and (pos - loc).Magnitude <= megCheckRadius then
                                foundTarget = d
                                foundPos = pos
                                break
                            end
                        end
                    end
                    if foundTarget then break end
                end
            end
            if foundTarget and foundPos then
                createAndTeleportToPlatform(foundPos, config.PlatformY)
            end
        end
        task.wait(0.05)
    end
    destroyEventPlatform()
end

Section22:AddDropdown({
    Title = "Select Events",
    Content = "Choose events to auto-teleport to",
    Multi = true,
    Options = eventOptions,
    Default = {},
    Callback = function(values)
        selectedEvents = values
    end
})

Section22:AddToggle({
    Title = "Auto Event",
    Content = "Auto teleport to selected events",
    Default = false,
    Callback = function(state)
        autoEventTPEnabled = state
        if state then
            task.spawn(runMultiEventTP)
        end
    end
})

local Tab7 = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://16932740082"
})

local Section23 = Tab7:AddSection("Character")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local function getOverhead(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    return hrp:WaitForChild("Overhead")
end

local overhead = getOverhead(Character)
local header = overhead.Content.Header
local levelLabel = overhead.LevelContainer.Label

local defaultHeader = header.Text
local defaultLevel = levelLabel.Text
local customHeader = defaultHeader
local customLevel = defaultLevel

local keepHidden = false
local rgbThread = nil

Section23:AddInput({
    Title = "Hide Name",
    Content = "Input custom display name",
    Placeholder = "Enter name",
    Callback = function(value)
        customHeader = value
        if keepHidden then
            header.Text = customHeader
        end
    end
})

Section23:AddToggle({
    Title = "Hide Identity",
    Content = "Use custom display name",
    Default = false,
    Callback = function(state)
        keepHidden = state
        if state then
            header.Text = customHeader
        end
    end
})

local Section24 = Tab7:AddSection("UI")

local stopAnimConnections = {}

local function setGameAnimationsEnabled(state)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    for _, conn in pairs(stopAnimConnections) do
        conn:Disconnect()
    end
    stopAnimConnections = {}
    if state then
        for _, track in ipairs(humanoid:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
        local conn = humanoid:FindFirstChildOfClass("Animator").AnimationPlayed:Connect(function(track)
            task.defer(function()
                track:Stop(0)
            end)
        end)
        table.insert(stopAnimConnections, conn)
    else
        for _, conn in pairs(stopAnimConnections) do
            conn:Disconnect()
        end
        stopAnimConnections = {}
    end
end

Section24:AddToggle({
    Title = "No Animation",
    Content = "Stop all animations from the game",
    Default = false,
    Callback = function(v)
        setGameAnimationsEnabled(v)
    end
})

local RunService = game:GetService("RunService")
local DisableNotificationConnection

Section24:AddToggle({
    Title = "Disable Notify",
    Content = "Disable game notifications",
    Default = false,
    Callback = function(state)
        local PlayerGui = player:WaitForChild("PlayerGui")
        local SmallNotification = PlayerGui:FindFirstChild("Small Notification")

        if not SmallNotification then
            SmallNotification = PlayerGui:WaitForChild("Small Notification", 5)
            if not SmallNotification then
                return
            end
        end

        if state then
            DisableNotificationConnection = RunService.RenderStepped:Connect(function()
                SmallNotification.Enabled = false
            end)
        else
            if DisableNotificationConnection then
                DisableNotificationConnection:Disconnect()
                DisableNotificationConnection = nil
            end
            SmallNotification.Enabled = true
        end
    end
})

Section24:AddToggle({
    Title = "AntiAFK",
    Content = "Prevent Roblox from kicking you when idle",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        local Players = game:GetService("Players")

        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(50)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(0,0))
                    end)
                end
            end)

            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(300)
                    pcall(function()
                        Players.LocalPlayer.Idled:Fire()
                    end)
                end
            end)
        else
            _G.AntiAFK = false
        end
    end
})

Section24:AddToggle({
    Title = "Auto Reconnect",
    Content = "Automatic reconnect if disconnected",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)

                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})

local Section25 = Tab7:AddSection("Server")

Section25:AddButton({
    Title = "Rejoin Server",
    Content = "Reconnect to current server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

Section25:AddButton({
    Title = "Server Hop",
    Content = "Switch to another server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local function GetServers()
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
            local response = HttpService:JSONDecode(game:HttpGet(url))
            return response.data
        end
        local function FindBestServer(servers)
            for _, server in ipairs(servers) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    return server.id
                end
            end
            return nil
        end
        local servers = GetServers()
        local serverId = FindBestServer(servers)
        if serverId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
        end
    end
})

local Section26 = Tab7:AddSection("Config")

local ConfigFolder = "STREE_HUB/Configs"
if not isfolder("STREE_HUB") then makefolder("STREE_HUB") end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local ConfigName = "default.json"

local function GetConfig()
    return {
        WalkSpeed = Humanoid.WalkSpeed,
        JumpPower = _G.CustomJumpPower or 50,
        InfiniteJump = _G.InfiniteJump or false,
        AutoSell = _G.AutoSell or false,
        InstantCatch = _G.InstantCatch or false,
        AntiAFK = _G.AntiAFK or false,
        AutoReconnect = _G.AutoReconnect or false,
    }
end

local function ApplyConfig(data)
    if data.WalkSpeed then 
        Humanoid.WalkSpeed = data.WalkSpeed 
    end
    if data.JumpPower then
        _G.CustomJumpPower = data.JumpPower
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = data.JumpPower
        end
    end
    if data.InfiniteJump ~= nil then
        _G.InfiniteJump = data.InfiniteJump
    end
    if data.AutoSell ~= nil then
        _G.AutoSell = data.AutoSell
    end
    if data.InstantCatch ~= nil then
        _G.InstantCatch = data.InstantCatch
    end
    if data.AntiAFK ~= nil then
        _G.AntiAFK = data.AntiAFK
    end
    if data.AutoReconnect ~= nil then
        _G.AutoReconnect = data.AutoReconnect
    end
end

Section26:AddButton({
    Title = "Save Config",
    Content = "Save all settings",
    Callback = function()
        local data = GetConfig()
        writefile(ConfigFolder.."/"..ConfigName, game:GetService("HttpService"):JSONEncode(data))
    end
})

Section26:AddButton({
    Title = "Load Config",
    Content = "Use saved config",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            local data = readfile(ConfigFolder.."/"..ConfigName)
            local decoded = game:GetService("HttpService"):JSONDecode(data)
            ApplyConfig(decoded)
        end
    end
})

Section26:AddButton({
    Title = "Delete Config",
    Content = "Delete saved config",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            delfile(ConfigFolder.."/"..ConfigName)
        end
    end
})

local Section27 = Tab7:AddSection("Other Scripts")

Section27:AddButton({
    Title = "FLY",
    Content = "Scripts Fly Gui",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

Section27:AddButton({
    Title = "Simple Shader",
    Content = "Shader effects",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua"))()
    end
})

Section27:AddButton({
    Title = "Infinite Yield",
    Content = "Admin commands",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
    end
})

player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.UseJumpPower = true
    humanoid.JumpPower = _G.CustomJumpPower or 50
end)
