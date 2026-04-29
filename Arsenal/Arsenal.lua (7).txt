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
    Title = "Seraphin",
    Icon = "rbxassetid://120248611602330",
    Author = "KirsiaSC | Arsenal",
    Folder = "SERAPHIN_HUB",
    Size = UDim2.fromOffset(280, 320),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = true,
    },
})

Window:EditOpenButton({
    Enabled = false,
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
G2L["ButtonRezise_2"].Image = "rbxassetid://120248611602330"
G2L["ButtonRezise_2"].Size = UDim2.new(0, 45, 0, 45)
G2L["ButtonRezise_2"].Position = UDim2.new(0.13, 0, 0.03, 0)

local corner = Instance.new("UICorner", G2L["ButtonRezise_2"])
corner.CornerRadius = UDim.new(0, 8)

local neon = Instance.new("UIStroke", G2L["ButtonRezise_2"])
neon.Thickness = 2
neon.Color = Color3.fromRGB(148, 0, 211)
neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

G2L["ButtonRezise_2"].MouseButton1Click:Connect(function()
    G2L["ButtonRezise_2"].Visible = false
    Window:Open()
end)

Window:OnClose(function()
    G2L["ButtonRezise_2"].Visible = true
end)

Window:OnDestroy(function()
    G2L["ButtonRezise_2"].Visible = false
end)

G2L["ButtonRezise_2"].Visible = false

Window:Tag({
    Title = "v0.0.0.5",
    Color = Color3.fromRGB(180, 0, 255)
})

WindUI:Notify({
    Title = "SeraphinHub Loaded",
    Content = "Arsenal script loaded!",
    Duration = 3,
    Icon = "bell",
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Info = Window:Tab({ Title = "Info", Icon = "info" })

Info:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Info:Button({
    Title = "Discord",
    Desc = "Click to copy Discord link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/getseraphin")
        end
    end
})

Info:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

local Combat = Window:Tab({ Title = "Combat", Icon = "sword" })

local hitboxEnabled = false
Combat:Toggle({
    Title = "Hitbox Extender",
    Default = false,
    Callback = function(v)
        hitboxEnabled = v
        if v then
            task.spawn(function()
                while hitboxEnabled do
                    task.wait(0.5)
                    for _, enemy in pairs(Players:GetPlayers()) do
                        if enemy.Team ~= LocalPlayer.Team and enemy.Character and enemy.Character:FindFirstChild("Head") then
                            local head = enemy.Character.Head
                            if not head:FindFirstChild("HitboxNeon") then
                                local adorn = Instance.new("BoxHandleAdornment")
                                adorn.Name = "HitboxNeon"
                                adorn.Adornee = head
                                adorn.Parent = head
                                adorn.AlwaysOnTop = true
                                adorn.ZIndex = 5
                                adorn.Size = Vector3.new(5, 5, 5)
                                adorn.Transparency = 0.3
                                adorn.Color3 = Color3.fromRGB(170, 0, 255)
                            end
                            head.Size = Vector3.new(5, 5, 5)
                            head.CanCollide = false
                        end
                    end
                end
                
                for _, enemy in pairs(Players:GetPlayers()) do
                    if enemy.Character and enemy.Character:FindFirstChild("Head") then
                        local head = enemy.Character.Head
                        if head:FindFirstChild("HitboxNeon") then
                            head.HitboxNeon:Destroy()
                        end
                        head.Size = Vector3.new(1, 1, 1)
                    end
                end
            end)
        end
    end
})

_G.KillAura = false

Combat:Toggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(state)
        _G.KillAura = state
    end
})

RunService.Heartbeat:Connect(function()
    if _G.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < 100 then
                    player.Character.Humanoid:TakeDamage(5)
                end
            end
        end
    end
end)

Combat:Toggle({
    Title = "Aimbot",
    Default = false,
    Callback = function(state)
        _G.Aimbot = state
    end
})

Combat:Toggle({
    Title = "Auto Aim (Head)",
    Default = false,
    Callback = function(state)
        _G.AutoAim = state
        if state then
            task.spawn(function()
                while _G.AutoAim do
                    task.wait()
                    local closestPlayer, closestDistance = nil, math.huge
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
                                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestPlayer = player
                                end
                            end
                        end
                    end

                    if closestPlayer and closestPlayer.Character then
                        local targetHead = closestPlayer.Character:FindFirstChild("Head")
                        if targetHead then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                        end
                    end
                end
            end)
        end
    end
})

local circle = Drawing.new("Circle")
circle.Thickness = 1.5
circle.NumSides = 100
circle.Radius = 70
circle.Filled = false
circle.Color = Color3.fromRGB(170, 0, 255)
circle.Visible = false

Combat:Toggle({
    Title = "Aim Circle",
    Default = false,
    Callback = function(state)
        _G.AimCircle = state
        circle.Visible = state
    end
})

RunService.RenderStepped:Connect(function()
    if _G.AimCircle then
        local mouse = UserInputService:GetMouseLocation()
        circle.Position = Vector2.new(mouse.X, mouse.Y + 36)
    end
end)

_G.TriggerBot = false
local triggerBotRange = 500

Combat:Toggle({
    Title = "Trigger Bot",
    Default = false,
    Callback = function(state)
        _G.TriggerBot = state
        if state then
            task.spawn(function()
                while _G.TriggerBot do
                    task.wait(0.05)
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            local closestPlayer = nil
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                                    local character = player.Character
                                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                                        if distance < triggerBotRange then
                                            local screenPoint, onScreen = Camera:WorldToViewportPoint(character.HumanoidRootPart.Position)
                                            if onScreen then
                                                closestPlayer = player
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            
                            if closestPlayer and closestPlayer.Character then
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                task.wait(0.03)
                                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
})

Combat:Input({
    Title = "Trigger Bot Range",
    Value = "500",
    Callback = function(val)
        local num = tonumber(val)
        if num then triggerBotRange = num end
    end
})

Combat:Section({
    Title = "No delay",
    TextXAlignment = "Left",
    TextSize = 17,
})

_G.NoRecoil = false
_G.NoSpread = false

Combat:Toggle({
    Title = "No Recoil",
    Default = false,
    Callback = function(state)
        _G.NoRecoil = state
    end
})

Combat:Toggle({
    Title = "No Spread",
    Default = false,
    Callback = function(state)
        _G.NoSpread = state
    end
})

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Tool") then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool:FindFirstChild("CameraRecoil") and _G.NoRecoil then
            tool.CameraRecoil.Value = 0
        end
        if tool:FindFirstChild("Spread") and _G.NoSpread then
            tool.Spread.Value = 0
        end
    end
end)

Combat:Section({
    Title = "Attack",
    TextXAlignment = "Left",
    TextSize = 17,
})

Combat:Toggle({
    Title = "Teleport to Enemy",
    Default = false,
    Callback = function(state)
        _G.TeleportEnemy = state
        task.spawn(function()
            while _G.TeleportEnemy do
                task.wait(1)
                local nearest, dist = nil, math.huge
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if mag < dist then
                            dist = mag
                            nearest = plr
                        end
                    end
                end
                if nearest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end)
    end
})

local knifeRange = 10
Combat:Input({
    Title = "Knife Range",
    Value = "10",
    Callback = function(val)
        local num = tonumber(val)
        if num then knifeRange = num end
    end
})

Combat:Toggle({
    Title = "Auto Knife",
    Default = false,
    Callback = function(state)
        _G.AutoKnife = state
        task.spawn(function()
            while _G.AutoKnife do
                task.wait(0.2)
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local mag = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if mag <= knifeRange then
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        end
                    end
                end
            end
        end)
    end
})


local Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" })

local ESP = {
    Players = {},
    Drawings = {},
    Connections = {}
}

local ESPFeatures = {
    Box = false,
    Line = false,
    Name = false,
    Studs = false,
    Highlight = false
}

local function createESP(player)
    if player == LocalPlayer then return end
    if ESP.Players[player] then return end
    
    ESP.Players[player] = true
    
    local drawings = {}
    
    if ESPFeatures.Box then
        drawings.Box = Drawing.new("Square")
        drawings.Box.Thickness = 1
        drawings.Box.Filled = false
        drawings.Box.Color = Color3.fromRGB(180, 0, 255)
        drawings.Box.Visible = false
    end
    
    if ESPFeatures.Line then
        drawings.Line = Drawing.new("Line")
        drawings.Line.Thickness = 1
        drawings.Line.Color = Color3.fromRGB(180, 0, 255)
        drawings.Line.Visible = false
    end
    
    if ESPFeatures.Name then
        drawings.Name = Drawing.new("Text")
        drawings.Name.Text = player.Name
        drawings.Name.Size = 14
        drawings.Name.Center = true
        drawings.Name.Outline = true
        drawings.Name.OutlineColor = Color3.new(0, 0, 0)
        drawings.Name.Color = Color3.fromRGB(180, 0, 255)
        drawings.Name.Visible = false
    end
    
    if ESPFeatures.Studs then
        drawings.Distance = Drawing.new("Text")
        drawings.Distance.Size = 12
        drawings.Distance.Center = true
        drawings.Distance.Outline = true
        drawings.Distance.OutlineColor = Color3.new(0, 0, 0)
        drawings.Distance.Color = Color3.fromRGB(255, 255, 255)
        drawings.Distance.Visible = false
    end
    
    if ESPFeatures.Highlight then
        drawings.Highlight = Instance.new("Highlight")
        drawings.Highlight.Name = "SeraphinESP_HL"
        drawings.Highlight.FillColor = Color3.fromRGB(180, 0, 255)
        drawings.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        drawings.Highlight.OutlineTransparency = 0
        drawings.Highlight.FillTransparency = 0.3
        drawings.Highlight.Enabled = false
    end
    
    ESP.Drawings[player] = drawings
    
    local function characterAdded(char)
        if drawings.Highlight then
            drawings.Highlight.Adornee = char
            drawings.Highlight.Parent = char
        end
    end
    
    local charAddedConn = player.CharacterAdded:Connect(characterAdded)
    local charRemovingConn = player.CharacterRemoving:Connect(function()
        if drawings.Highlight then
            drawings.Highlight.Adornee = nil
            drawings.Highlight.Parent = nil
        end
    end)
    
    ESP.Connections[player] = {
        CharAdded = charAddedConn,
        CharRemoving = charRemovingConn
    }
    
    if player.Character then
        characterAdded(player.Character)
    end
end

local function removeESP(player)
    if ESP.Drawings[player] then
        for _, drawing in pairs(ESP.Drawings[player]) do
            if typeof(drawing) == "userdata" and drawing.Remove then
                drawing:Remove()
            elseif typeof(drawing) == "Instance" then
                drawing:Destroy()
            end
        end
        ESP.Drawings[player] = nil
    end
    
    if ESP.Connections[player] then
        if ESP.Connections[player].CharAdded then
            ESP.Connections[player].CharAdded:Disconnect()
        end
        if ESP.Connections[player].CharRemoving then
            ESP.Connections[player].CharRemoving:Disconnect()
        end
        ESP.Connections[player] = nil
    end
    
    ESP.Players[player] = nil
end

local function updateESP()
    for player, drawings in pairs(ESP.Drawings) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
            local char = player.Character
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            
            if rootPart and head then
                local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                
                if rootVis then
                    local distanceVal = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    
                    if drawings.Box then
                        local height = (headPos.Y - rootPos.Y)
                        local width = height / 2
                        
                        drawings.Box.Size = Vector2.new(width, height)
                        drawings.Box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height)
                        drawings.Box.Visible = true
                    end
                    
                    if drawings.Line then
                        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        drawings.Line.From = screenCenter
                        drawings.Line.To = Vector2.new(rootPos.X, rootPos.Y)
                        drawings.Line.Visible = true
                    end
                    
                    if drawings.Name then
                        drawings.Name.Position = Vector2.new(rootPos.X, headPos.Y + 10)
                        drawings.Name.Visible = true
                    end
                    
                    if drawings.Distance then
                        drawings.Distance.Text = math.floor(distanceVal) .. " studs"
                        drawings.Distance.Position = Vector2.new(rootPos.X, headPos.Y + 25)
                        drawings.Distance.Visible = true
                    end
                    
                    if drawings.Highlight then
                        drawings.Highlight.Enabled = true
                    end
                else
                    if drawings.Box then drawings.Box.Visible = false end
                    if drawings.Line then drawings.Line.Visible = false end
                    if drawings.Name then drawings.Name.Visible = false end
                    if drawings.Distance then drawings.Distance.Visible = false end
                    if drawings.Highlight then drawings.Highlight.Enabled = false end
                end
            else
                if drawings.Box then drawings.Box.Visible = false end
                if drawings.Line then drawings.Line.Visible = false end
                if drawings.Name then drawings.Name.Visible = false end
                if drawings.Distance then drawings.Distance.Visible = false end
                if drawings.Highlight then drawings.Highlight.Enabled = false end
            end
        else
            if drawings.Box then drawings.Box.Visible = false end
            if drawings.Line then drawings.Line.Visible = false end
            if drawings.Name then drawings.Name.Visible = false end
            if drawings.Distance then drawings.Distance.Visible = false end
            if drawings.Highlight then drawings.Highlight.Enabled = false end
        end
    end
end

local function setupAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
end

local function cleanupAllESP()
    for player, _ in pairs(ESP.Players) do
        removeESP(player)
    end
end

local function refreshESP()
    cleanupAllESP()
    setupAllESP()
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(updateESP)

Visuals:Toggle({
    Title = "ESP Box",
    Default = false,
    Callback = function(state)
        ESPFeatures.Box = state
        if state then
            for player, drawings in pairs(ESP.Drawings) do
                if not drawings.Box then
                    drawings.Box = Drawing.new("Square")
                    drawings.Box.Thickness = 1
                    drawings.Box.Filled = false
                    drawings.Box.Color = Color3.fromRGB(180, 0, 255)
                    drawings.Box.Visible = false
                end
            end
        else
            for _, drawings in pairs(ESP.Drawings) do
                if drawings.Box then
                    drawings.Box:Remove()
                    drawings.Box = nil
                end
            end
        end
    end
})

Visuals:Toggle({
    Title = "ESP Line",
    Default = false,
    Callback = function(state)
        ESPFeatures.Line = state
        if state then
            for player, drawings in pairs(ESP.Drawings) do
                if not drawings.Line then
                    drawings.Line = Drawing.new("Line")
                    drawings.Line.Thickness = 1
                    drawings.Line.Color = Color3.fromRGB(180, 0, 255)
                    drawings.Line.Visible = false
                end
            end
        else
            for _, drawings in pairs(ESP.Drawings) do
                if drawings.Line then
                    drawings.Line:Remove()
                    drawings.Line = nil
                end
            end
        end
    end
})

Visuals:Toggle({
    Title = "ESP Name",
    Default = false,
    Callback = function(state)
        ESPFeatures.Name = state
        if state then
            for player, drawings in pairs(ESP.Drawings) do
                if not drawings.Name then
                    drawings.Name = Drawing.new("Text")
                    drawings.Name.Text = player.Name
                    drawings.Name.Size = 14
                    drawings.Name.Center = true
                    drawings.Name.Outline = true
                    drawings.Name.OutlineColor = Color3.new(0, 0, 0)
                    drawings.Name.Color = Color3.fromRGB(180, 0, 255)
                    drawings.Name.Visible = false
                end
            end
        else
            for _, drawings in pairs(ESP.Drawings) do
                if drawings.Name then
                    drawings.Name:Remove()
                    drawings.Name = nil
                end
            end
        end
    end
})

Visuals:Toggle({
    Title = "ESP Studs",
    Default = false,
    Callback = function(state)
        ESPFeatures.Studs = state
        if state then
            for player, drawings in pairs(ESP.Drawings) do
                if not drawings.Distance then
                    drawings.Distance = Drawing.new("Text")
                    drawings.Distance.Size = 12
                    drawings.Distance.Center = true
                    drawings.Distance.Outline = true
                    drawings.Distance.OutlineColor = Color3.new(0, 0, 0)
                    drawings.Distance.Color = Color3.fromRGB(255, 255, 255)
                    drawings.Distance.Visible = false
                end
            end
        else
            for _, drawings in pairs(ESP.Drawings) do
                if drawings.Distance then
                    drawings.Distance:Remove()
                    drawings.Distance = nil
                end
            end
        end
    end
})

Visuals:Toggle({
    Title = "ESP Highlight",
    Default = false,
    Callback = function(state)
        ESPFeatures.Highlight = state
        if state then
            for player, drawings in pairs(ESP.Drawings) do
                if not drawings.Highlight then
                    drawings.Highlight = Instance.new("Highlight")
                    drawings.Highlight.Name = "SeraphinESP_HL"
                    drawings.Highlight.FillColor = Color3.fromRGB(180, 0, 255)
                    drawings.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    drawings.Highlight.OutlineTransparency = 0
                    drawings.Highlight.FillTransparency = 0.3
                    drawings.Highlight.Enabled = false
                    
                    if player.Character then
                        drawings.Highlight.Adornee = player.Character
                        drawings.Highlight.Parent = player.Character
                    end
                end
            end
        else
            for _, drawings in pairs(ESP.Drawings) do
                if drawings.Highlight then
                    drawings.Highlight:Destroy()
                    drawings.Highlight = nil
                end
            end
        end
    end
})

setupAllESP()

local PlayersTab = Window:Tab({
    Title = "Players",
    Icon = "user"
})

local walkVal, jumpVal = 16, 50

local function applyStats(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = walkVal
    hum.UseJumpPower = true
    hum.JumpPower = jumpVal
end

applyStats(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.2)
    applyStats(char)
end)

PlayersTab:Input({
    Title = "WalkSpeed",
    Value = tostring(walkVal),
    Callback = function(val)
        local spd = tonumber(val)
        if spd and spd >= 16 then
            walkVal = spd
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = walkVal
            end
        end
    end
})

PlayersTab:Input({
    Title = "JumpPower",
    Value = tostring(jumpVal),
    Callback = function(val)
        local jp = tonumber(val)
        if jp then
            jumpVal = jp
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.UseJumpPower = true
                LocalPlayer.Character.Humanoid.JumpPower = jumpVal
            end
        end
    end
})

PlayersTab:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        _G.Noclip = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

PlayersTab:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayersTab:Toggle({
    Title = "Fly",
    Default = false,
    Callback = function(state)
        _G.Fly = state
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if state and hrp then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
            task.spawn(function()
                while _G.Fly and bv.Parent do
                    task.wait()
                    bv.Velocity = Camera.CFrame.LookVector * 50
                end
            end)
        else
            if hrp and hrp:FindFirstChild("FlyVelocity") then
                hrp.FlyVelocity:Destroy()
            end
        end
    end
})

local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

Settings:Toggle({
    Title = "AntiAFK",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
})

Settings:Toggle({
    Title = "Auto Reconnect",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        task.spawn(function()
            while _G.AutoReconnect do
                task.wait(2)
                local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if reconnectUI then
                    local prompt = reconnectUI:FindFirstChild("promptOverlay")
                    if prompt then
                        local errorPrompt = prompt:FindFirstChild("ErrorPrompt")
                        if errorPrompt then
                            local confirmButton = errorPrompt:FindFirstChild("ConfirmButton")
                            if confirmButton then
                                firesignal(confirmButton.MouseButton1Click)
                            end
                        end
                    end
                end
            end
        end)
    end
})

Settings:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

Settings:Section({
    Title = "Server",
    TextXAlignment = "Left",
    TextSize = 17,
})

Settings:Button({
    Title = "Rejoin",
    Desc = "Reconnect to current server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Player = game.Players.LocalPlayer
        TeleportService:Teleport(PlaceId, Player)
    end
})

Settings:Button({
    Title = "Server Hop",
    Desc = "Teleport to a different server",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Servers = {}
        local success, response = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success and response then
            local data = HttpService:JSONDecode(response)
            for _, v in pairs(data.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(Servers, v.id)
                end
            end
        end
        if #Servers > 0 then
            local randomServer = Servers[math.random(1, #Servers)]
            TeleportService:TeleportToPlaceInstance(PlaceId, randomServer, game.Players.LocalPlayer)
        end
    end
})

Settings:Section({
    Title = "Config",
    TextXAlignment = "Left",
    TextSize = 17,
})

Settings:Button({
    Title = "Save Config",
    Desc = "Save your current settings",
    Callback = function()
        WindUI:SaveConfig("Seraphin_Config")
    end
})

Settings:Button({
    Title = "Load Config",
    Desc = "Load your saved settings",
    Callback = function()
        WindUI:LoadConfig("Seraphin_Config")
    end
})

Settings:Button({
    Title = "Delete Config",
    Desc = "Delete saved config",
    Callback = function()
        WindUI:DeleteConfig("Seraphin_Config")
    end
})

task.spawn(function()
    while true do
        task.wait()
        if _G.Aimbot then
            local closestPlayer, closestDistance = nil, math.huge

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head") then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end

            if closestPlayer and closestPlayer.Character then
                local targetHead = closestPlayer.Character:FindFirstChild("Head")
                if targetHead then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                end
            end
        end
    end
end)

Settings:Section({
    Title = "other scripts",
    TextXAlignment = "Left",
    TextSize = 17,
})

Settings:Button({
    Title = "Infinite Yield",
    Desc = "Script Other",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})
