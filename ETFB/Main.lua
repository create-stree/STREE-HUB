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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

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
    Title = "v0.0.0.2",
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

local Tab1 = Window:Tab({Title = "Information", Icon = "info"})
local Tab2 = Window:Tab({Title = "Main", Icon = "landmark"})
local Tab3 = Window:Tab({Title = "Teleport", Icon = "map-pin"})
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

local ToggleActive = false
local AutoRebirthActive = false
local AutoSellActive = false
local GodModeEnabled = false
local AutoTeleportEnabled = false
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local AntiAFKEnabled = false

local function SafeGetCharacter()
    local char = Player.Character
    if not char then
        return nil, nil, nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

Tab2:Section({
    Title = "Base",
    Icon = "building",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab2:Divider()

Tab2:Toggle({
    Title = "Auto Upgrade Base",
    Desc = "this will always upgrade if you have money",
    Value = false,
    Callback = function(state) 
        ToggleActive = state
        if state then
            spawn(function()
                while ToggleActive do
                    pcall(function()
                        ReplicatedStorage.RemoteFunctions.UpgradeBase:InvokeServer()
                    end)
                    task.wait(0.5)
                end
            end)
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

Tab2:Toggle({
    Title = "Auto Rebirth",
    Desc = "this will be automatic for Rebirth",
    Value = false,
    Callback = function(state)
        AutoRebirthActive = state
        if state then
            spawn(function()
                while AutoRebirthActive do
                    pcall(function()
                        ReplicatedStorage.RemoteFunctions.Rebirth:InvokeServer()
                    end)
                    task.wait(0.1)
                end
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

Tab2:Toggle({
    Title = "Auto Sell Tool",
    Desc = "this will automatically sell tools",
    Value = false,
    Callback = function(state)
        AutoSellActive = state
        if state then
            spawn(function()
                while AutoSellActive do
                    pcall(function()
                        ReplicatedStorage.RemoteFunctions.SellTool:InvokeServer()
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

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

Tab3:Toggle({
    Title = "Auto Teleport",
    Desc = "Teleport from spwan to celestial",
    Value = false,
    Callback = function(state)
        AutoTeleportEnabled = state
        if state then
            spawn(function()
                while AutoTeleportEnabled do
                    local char, hum, hrp = SafeGetCharacter()
                    if hrp then
                        for i = 1, #GapPositions do
                            if not AutoTeleportEnabled then break end
                            TweenToPosition(GapPositions[i], 1.5)
                            task.wait(2)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

for i = 1, #GapPositions do
    Tab3:Button({
        Title = "Gap " .. i,
        Desc = "Teleport to Gap " .. i,
        Callback = function()
            TweenToPosition(GapPositions[i], 1.5)
        end
    })
end

Tab4:Toggle({
    Title = "God Mode",
    Desc = "1 wave only",
    Value = false,
    Callback = function(state)
        GodModeEnabled = state
        if state then
            spawn(function()
                while GodModeEnabled do
                    local char, hum, hrp = SafeGetCharacter()
                    if hum then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

Tab4:Toggle({
    Title = "Infinite Jump",
    Desc = "jump without limits and go beyond it",
    Value = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
        if state then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if InfiniteJumpEnabled then
                    local char, hum, hrp = SafeGetCharacter()
                    if hum then
                        hum:ChangeState("Jumping")
                    end
                end
            end)
        end
    end
})

Tab4:Toggle({
    Title = "Noclip",
    Desc = "pass through objects",
    Value = false,
    Callback = function(state)
        NoclipEnabled = state
        if state then
            spawn(function()
                while NoclipEnabled do
                    local char, hum, hrp = SafeGetCharacter()
                    if char then
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            local char, hum, hrp = SafeGetCharacter()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

Tab5:Section({
    Title = "Upgrade Speed",
    Icon = "gauge",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab5:Divider()

local speedUpgrades = {1, 5, 10}
for _, amount in ipairs(speedUpgrades) do
    Tab5:Button({
        Title = "Upgrade Speed " .. amount,
        Desc = "Increase speed",
        Callback = function()
            pcall(function()
                ReplicatedStorage.RemoteFunctions.UpgradeSpeed:InvokeServer(amount)
            end)
        end
    })
end

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
        pcall(function()
            ReplicatedStorage.RemoteFunctions.UpgradeCarry:InvokeServer()
        end)
    end
})

local function Rejoin()
    TeleportService:Teleport(game.PlaceId, Player)
end

local function ServerHop()
    local PlaceId = game.PlaceId
    local Servers = {}
    local success, result = pcall(function()
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        return HttpService:JSONDecode(req)
    end)
    
    if success and result.data then
        for _,v in pairs(result.data) do
            if v.playing < v.maxPlayers then
                table.insert(Servers, v.id)
            end
        end
        
        if #Servers > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceId, Servers[math.random(1, #Servers)], Player)
        end
    end
end

Tab6:Button({
    Title = "Rejoin Server",
    Desc = "Rejoin current server",
    Callback = Rejoin
})

Tab6:Button({
    Title = "Server Hop",
    Desc = "Join another server",
    Callback = ServerHop
})

Tab6:Toggle({
    Title = "Anti AFK",
    Desc = "Prevent AFK kick",
    Value = false,
    Callback = function(state)
        AntiAFKEnabled = state
        if state then
            Player.Idled:Connect(function()
                if AntiAFKEnabled then
                    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end
})

Player.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    if GodModeEnabled then
        local hum = character:WaitForChild("Humanoid")
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end)
