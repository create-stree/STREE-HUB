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
    Author = "KirsiaSC | Escape Tsunami For Brainrot",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = true,
    },
})

Window:EditOpenButton({Enabled = false})

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local G2L = {}

G2L["ScreenGui_1"] = Instance.new("ScreenGui")
G2L["ScreenGui_1"].Parent = game:GetService("CoreGui")
G2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G2L["ScreenGui_1"].ResetOnSpawn = false
CollectionService:AddTag(G2L["ScreenGui_1"], "main")

G2L["ButtonRezise_2"] = Instance.new("ImageButton")
G2L["ButtonRezise_2"].Parent = G2L["ScreenGui_1"]
G2L["ButtonRezise_2"].BorderSizePixel = 0
G2L["ButtonRezise_2"].Draggable = true
G2L["ButtonRezise_2"].BackgroundColor3 = Color3.fromRGB(0, 255, 120)
G2L["ButtonRezise_2"].Image = "rbxassetid://123032091977400"
G2L["ButtonRezise_2"].Size = UDim2.new(0, 47, 0, 47)
G2L["ButtonRezise_2"].Position = UDim2.new(0.13, 0, 0.03, 0)
G2L["ButtonRezise_2"].Visible = true

local corner = Instance.new("UICorner", G2L["ButtonRezise_2"])
corner.CornerRadius = UDim.new(0, 8)

local neon = Instance.new("UIStroke", G2L["ButtonRezise_2"])
neon.Thickness = 2
neon.Color = Color3.fromRGB(0, 255, 120)
neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local windowVisible = true

G2L["ButtonRezise_2"].MouseButton1Click:Connect(function()
	if windowVisible then
		Window:Close()
	else
		Window:Open()
	end
	windowVisible = not windowVisible
end)

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Dev",
    Color = Color3.fromRGB(0, 0, 0),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({Title = "Information", Icon = "info"})
local Tab2 = Window:Tab({Title = "Main", Icon = "landmark"})
local Tab3 = Window:Tab({Title = "Teleport", Icon = "landmark"})
local Tab4 = Window:Tab({Title = "Player", Icon = "user"})
local Tab5 = Window:Tab({Title = "Shop", Icon = "badge-dollar-sign"})
local Tab6 = Window:Tab({Title = "Setting", Icon = "settings"})

Tab1:Section({
    Title = "Community Support",
    Icon = "chevrons-left-right-ellipsis",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Divider()

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Divider()

Tab1:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tab1:Divider()

Tab1:Keybind({
    Title = "Close/Open UI",
    Desc = "Keybind to Close/Open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

Tab2:Section({
    Title = "Base",
    Icon = "building",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab2:Divider()

local ToggleActive = false

Tab2:Toggle({
    Title = "Auto Upgrade Base",
    Desc = "this will always upgrade if you have money",
    Value = false,
    Callback = function(state) 
        ToggleActive = state
        if state then
            while ToggleActive do
                game:GetService("ReplicatedStorage").RemoteFunctions.UpgradeBase:InvokeServer()
                wait(0.5)
            end
        end
    end
})

Tab2:Section({
    Title = "Rebirth",
    Icon = "ellipsis",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab2:Divider()

local RebirthRemote = game:GetService("ReplicatedStorage").RemoteFunctions.Rebirth

Tab2:Toggle({
    Title = "Auto Rebirth",
    Desc = "this will be automatic for Rebirth",
    Value = false,
    Callback = function(state)
        while state and task.wait(0.1) do
            pcall(function()
                RebirthRemote:InvokeServer()
            end)
        end
    end
})

Tab2:Section({
    Title = "Sell",
    Icon = "hand-coins",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab2:Divider()

local SellRemote = game:GetService("ReplicatedStorage").RemoteFunctions.SellTool

Tab2:Toggle({
    Title = "Auto Sell Tool",
    Desc = "this will automatically sell tools",
    Value = false,
    Callback = function(state)
        while state and task.wait(0.1) do
            pcall(function()
                SellRemote:InvokeServer()
            end)
        end
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local CurrentCamera = Workspace.CurrentCamera

local GodModeEnabled = false
local AutoTeleportEnabled = false
local HealthConnection = nil
local CharacterConnection = nil

local GapPositions = {
    Vector3.new(200, -3, 0),
    Vector3.new(286, -3, -1),
    Vector3.new(393, -3, 5),
    Vector3.new(541, -3, 5),
    Vector3.new(758, -3, 1),
    Vector3.new(1079, -3, 6),
    Vector3.new(1564, -3, -2),
    Vector3.new(2247, -3, -14),
    Vector3.new(2615, -3, 12)
}

local TotalGaps = #GapPositions

local function SafeGetCharacter()
    local char = LocalPlayer.Character
    if not char then
        return nil, nil, nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

local function TweenToPosition(targetPosition, duration)
    local char, hum, hrp = SafeGetCharacter()
    if not hrp then
        return
    end
    duration = duration or 1
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local targetCFrame = CFrame.new(targetPosition)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

local function EnableGodMode()
    local char, hum, hrp = SafeGetCharacter()
    if not hum then
        return
    end
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    HealthConnection = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if GodModeEnabled and hum.Health < 1000000 then
            hum.Health = 1000000
        end
    end)
    CharacterConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        if not GodModeEnabled then
            return
        end
        local newHum = newChar:FindFirstChildOfClass("Humanoid")
        if newHum then
            task.wait(0.5)
            newHum.MaxHealth = math.huge
            newHum.Health = math.huge
            if HealthConnection then
                HealthConnection:Disconnect()
            end
            HealthConnection = newHum:GetPropertyChangedSignal("Health"):Connect(function()
                if GodModeEnabled and newHum.Health < 1000000 then
                    newHum.Health = 1000000
                end
            end)
        end
    end)
end

local function DisableGodMode()
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end
    if CharacterConnection then
        CharacterConnection:Disconnect()
        CharacterConnection = nil
    end
end

Tab4:Toggle({
    Title = "God Mode",
    Desc = "1 wave only",
    Value = false,
    Callback = function(state)
        GodModeEnabled = state
        if state then
            EnableGodMode()
        else
            DisableGodMode()
        end
    end
})

Tab3:Toggle({
    Title = "Auto Teleport",
    Desc = "Teleport from spwan to celestial",
    Value = false,
    Callback = function(state)
        AutoTeleportEnabled = state
        while AutoTeleportEnabled do
            local char, hum, hrp = SafeGetCharacter()
            if hrp then
                for i = 1, TotalGaps do
                    if not AutoTeleportEnabled then break end
                    TweenToPosition(GapPositions[i], 1.5)
                    task.wait(2)
                end
            end
            task.wait(0.1)
        end
    end
})

Tab3:Button({
    Title = "Gap 1",
    Desc = "Teleport Common Zone",
    Callback = function()
        TweenToPosition(GapPositions[1], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 2",
    Desc = "Teleport Uncommon Zone",
    Callback = function()
        TweenToPosition(GapPositions[2], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 3",
    Desc = "Teleport Rare Zond",
    Callback = function()
        TweenToPosition(GapPositions[3], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 4",
    Desc = "Teleport Legend Zone",
    Callback = function()
        TweenToPosition(GapPositions[4], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 5",
    Desc = "Teleport Mythic Zone",
    Callback = function()
        TweenToPosition(GapPositions[5], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 6",
    Desc = "Teleport Cosmtic",
    Callback = function()
        TweenToPosition(GapPositions[6], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 7",
    Desc = "Teleport ke Gap 7",
    Callback = function()
        TweenToPosition(GapPositions[7], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 8",
    Desc = "Teleport ke Gap 8",
    Callback = function()
        TweenToPosition(GapPositions[8], 1.5)
    end
})

Tab3:Button({
    Title = "Gap 9",
    Desc = "Teleport ke Gap 9",
    Callback = function()
        TweenToPosition(GapPositions[9], 1.5)
    end
})

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), CurrentCamera.CFrame)
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if GodModeEnabled then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    end
end)

Tab4:Toggle({
    Title = "Infinite Jump",
    Desc = "jump without limits and go beyond it",
    Default = false,
    Callback = function(value)
        infiniteJumpEnabled = value
        
        if value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJumpEnabled then
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid:ChangeState("Jumping")
                    end
                end
            end)
        end
    end
})

Tab4:Toggle({
    Title = "Noclip",
    Desc = "pass through objects",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        
        if value then
            local player = game.Players.LocalPlayer
            local character = player.Character
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        else
            local player = game.Players.LocalPlayer
            local character = player.Character
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

spawn(function()
    while true do
        if noclipEnabled then
            local player = game.Players.LocalPlayer
            local character = player.Character
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
        wait(0.1)
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    
    character.Humanoid.WalkSpeed = DEFAULT_WALKSPEED
    character.Humanoid.JumpPower = DEFAULT_JUMPPOWER
    
    if infiniteJumpEnabled then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if infiniteJumpEnabled then
                character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
    
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Tab5:Section({
    Title = "Upgrade Speed",
    Icon = "gauge",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

Tab5:Button({
    Title = "Upgrade Speed 1",
    Desc = "Increase speed",
    Callback = function()
        local args = {[1] = 1}
        game:GetService("ReplicatedStorage").RemoteFunctions.UpgradeSpeed:InvokeServer(unpack(args))
    end
})

Tab5:Button({
    Title = "Upgrade Speed 5",
    Desc = "Increase speed",
    Callback = function()
        local args = {[1] = 5}
        game:GetService("ReplicatedStorage").RemoteFunctions.UpgradeSpeed:InvokeServer(unpack(args))
    end
})

Tab5:Button({
    Title = "Upgrade Speed 10",
    Desc = "Increase speed",
    Callback = function()
        local args = {[1] = 10}
        game:GetService("ReplicatedStorage").RemoteFunctions.UpgradeSpeed:InvokeServer(unpack(args))
    end
})

Tab5:Section({
    Title = "Upgrade Carry",
    Icon = "gauge",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

Tab5:Button({
    Title = "Upgrade Carry",
    Desc = "Increase carrying capacity",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("UpgradeCarry"):InvokeServer()
    end
})

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local AntiAFK = false

local function Rejoin()
    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end

local function ServerHop()
    local PlaceId = game.PlaceId
    local Servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local body = HttpService:JSONDecode(req)

    for _,v in pairs(body.data) do
        if v.playing < v.maxPlayers then
            table.insert(Servers, v.id)
        end
    end

    if #Servers > 0 then
        TeleportService:TeleportToPlaceInstance(
            PlaceId,
            Servers[math.random(1, #Servers)],
            Players.LocalPlayer
        )
    end
end

Players.LocalPlayer.Idled:Connect(function()
    if AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

Tab6:Button({
    Title = "Rejoin Server",
    Desc = "Rejoin current server",
    Callback = function()
        Rejoin()
    end
})

Tab6:Button({
    Title = "Server Hop",
    Desc = "Join another server",
    Callback = function()
        ServerHop()
    end
})

Tab6:Toggle({
    Title = "Anti AFK",
    Desc = "Prevent AFK kick",
    Value = false,
    Callback = function(state)
        AntiAFK = state
    end
})
