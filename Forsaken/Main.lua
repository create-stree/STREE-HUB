local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then 
    warn("WindUI failed to load")
    return 
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Camera = Workspace.CurrentCamera

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "monitor",
    Author = "KirsiaSC | Forsaken",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

local MainTab = Window:Tab({Title = "Main", Icon = "sword"})
local CombatTab = Window:Tab({Title = "Combat", Icon = "target"})
local VisualsTab = Window:Tab({Title = "Visuals", Icon = "eye"})
local FarmTab = Window:Tab({Title = "Farm", Icon = "coins"})
local MiscTab = Window:Tab({Title = "Misc", Icon = "settings"})
local SettingsTab = Window:Tab({Title = "Settings", Icon = "gear"})

local state = {
    walkSpeed = 16,
    jumpPower = 50,
    fly = false,
    flySpeed = 50,
    noclip = false,
    esp = false,
    aimlock = false,
    aimFOV = 120,
    aimSmooth = 0.3,
    silentAim = false,
    silentAimFOV = 120,
    killAura = false,
    killAuraRange = 10,
    fling = false,
    flingForce = 1000,
    antiAfk = true,
    serverHop = false,
    autoFarm = false,
    autoFarmRange = 100,
    autoClick = false,
    autoClickRate = 5,
    uiOpen = true
}

local highlights = {}
local espConnections = {}

local function getCharacter(player)
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid(character)
    return character:FindFirstChildOfClass("Humanoid")
end

local function getRootPart(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function addESP(player)
    if not player or player == LocalPlayer or highlights[player] then return end
    
    local function createHighlight(character)
        if not character then return end
        
        local hl = Instance.new("Highlight")
        hl.Name = "STREE_ESP"
        hl.Adornee = character
        hl.Parent = Workspace
        hl.Enabled = true
        highlights[player] = hl
        
        espConnections[player] = player.AncestryChanged:Connect(function()
            if not player.Parent then
                removeESP(player)
            end
        end)
    end
    
    if player.Character then
        createHighlight(player.Character)
    end
    
    player.CharacterAdded:Connect(createHighlight)
end

local function removeESP(player)
    local hl = highlights[player]
    if hl then
        pcall(function() 
            hl:Destroy() 
            highlights[player] = nil 
        end)
    end
    
    local conn = espConnections[player]
    if conn then
        conn:Disconnect()
        espConnections[player] = nil
    end
end

local function toggleAllESP(enable)
    if enable then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                addESP(player)
            end
        end
    else
        for player, _ in pairs(highlights) do
            removeESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if state.esp then
        addESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

local function getClosestToCursor(maxFOV)
    local closest, closestDistance = nil, math.huge
    local mouseLocation = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and getHumanoid(character) and getHumanoid(character).Health > 0 then
                local rootPart = getRootPart(character)
                if rootPart then
                    local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local dx = position.X - mouseLocation.X
                        local dy = position.Y - mouseLocation.Y
                        local distance = math.sqrt(dx * dx + dy * dy)
                        
                        if distance < closestDistance and distance <= (maxFOV or 100) then
                            closestDistance = distance
                            closest = player
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

local function applyMovement()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = getHumanoid(character)
    if humanoid then
        pcall(function()
            humanoid.WalkSpeed = state.walkSpeed
            humanoid.JumpPower = state.jumpPower
        end)
    end
end

local flyBV
local function enableFly()
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = getRootPart(character)
    if not rootPart then return end
    
    if flyBV then flyBV:Destroy() end
    
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = rootPart
end

local function disableFly()
    if flyBV then
        pcall(function() flyBV:Destroy() end)
        flyBV = nil
    end
end

local noclipConnection
local function toggleNoclip(enable)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    if enable then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

if state.antiAfk then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end)
end

local function flingPlayer(target)
    if not target or not target.Character then return end
    
    local targetRoot = getRootPart(target.Character)
    if not targetRoot then return end
    
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return end
    
    local myRoot = getRootPart(myCharacter)
    if not myRoot then return end
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = (targetRoot.Position - myRoot.Position).Unit * state.flingForce
    bv.Parent = myRoot
    
    task.delay(0.2, function()
        pcall(function() bv:Destroy() end)
    end)
end

local function killAuraTick()
    if not state.killAura then return end
    
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return end
    
    local myRoot = getRootPart(myCharacter)
    if not myRoot then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and getHumanoid(character) and getHumanoid(character).Health > 0 then
                local rootPart = getRootPart(character)
                if rootPart and (rootPart.Position - myRoot.Position).Magnitude <= state.killAuraRange then
                    local tool = myCharacter:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        tool:Activate()
                    else
                        getHumanoid(character).Health = 0
                    end
                end
            end
        end
    end
end

local autoFarmTarget
local function findNearestNPC(range)
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return nil end
    
    local myRoot = getRootPart(myCharacter)
    if not myRoot then return nil end
    
    local best, bestDistance = nil, math.huge
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and getHumanoid(obj) and getRootPart(obj) then
            if getHumanoid(obj).Health > 0 then
                local distance = (getRootPart(obj).Position - myRoot.Position).Magnitude
                if distance < bestDistance and distance <= (range or state.autoFarmRange) then
                    bestDistance = distance
                    best = obj
                end
            end
        end
    end
    
    return best
end

local function performAutoFarm()
    if not state.autoFarm then return end
    
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return end
    
    local npc = findNearestNPC(state.autoFarmRange)
    if npc then
        autoFarmTarget = npc
        local myRoot = getRootPart(myCharacter)
        if myRoot then
            myRoot.CFrame = getRootPart(npc).CFrame * CFrame.new(0, 0, 2)
        end
        
        local tool = myCharacter:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        else
            getHumanoid(npc).Health = 0
        end
    end
end

local autoClickConnection
local lastClickTime = 0

local function startAutoClick()
    if autoClickConnection then return end
    
    autoClickConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if state.autoClick then
            lastClickTime = lastClickTime + deltaTime
            local clickInterval = 1 / state.autoClickRate
            
            if lastClickTime >= clickInterval then
                lastClickTime = 0
                local character = LocalPlayer.Character
                if character then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end
    end)
end

local function stopAutoClick()
    if autoClickConnection then
        autoClickConnection:Disconnect()
        autoClickConnection = nil
    end
    lastClickTime = 0
end

local function serverHop()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

local renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
    applyMovement()
    
    if state.fly then
        if not flyBV then enableFly() end
        
        if flyBV then
            local direction = Vector3.new()
            local camera = Camera
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            
            if direction.Magnitude > 0 then
                flyBV.Velocity = direction.Unit * state.flySpeed
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end
        end
    else
        disableFly()
    end
    
    if state.noclip then
        toggleNoclip(true)
    else
        toggleNoclip(false)
    end
    
    if state.aimlock or state.silentAim then
        local target = getClosestToCursor(state.aimFOV)
        if target and target.Character then
            local rootPart = getRootPart(target.Character)
            if rootPart then
                local camera = Camera
                local goal = CFrame.new(camera.CFrame.Position, rootPart.Position)
                
                if state.aimlock then
                    Camera.CFrame = camera.CFrame:Lerp(goal, state.aimSmooth)
                end
            end
        end
    end
    
    if state.killAura then
        killAuraTick()
    end
    
    if state.autoFarm then
        performAutoFarm()
    end
end)

local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if state.silentAim then
        local target = getClosestToCursor(state.silentAimFOV)
        if target and target.Character then
            local rootPart = getRootPart(target.Character)
            if rootPart then
                local camera = Camera
                local goal = CFrame.new(camera.CFrame.Position, rootPart.Position)
                Camera.CFrame = camera.CFrame:Lerp(goal, state.aimSmooth)
                task.wait(0.03)
            end
        end
    end
end)

CombatTab:Toggle({
    Title = "Aimlock", 
    Enabled = false, 
    Callback = function(value) 
        state.aimlock = value 
    end
})

CombatTab:Slider({
    Title = "Aim FOV", 
    Value = state.aimFOV, 
    Min = 20, 
    Max = 500, 
    Callback = function(value) 
        state.aimFOV = value 
    end
})

CombatTab:Slider({
    Title = "Aim Smooth", 
    Value = state.aimSmooth, 
    Min = 0.01, 
    Max = 1, 
    Callback = function(value) 
        state.aimSmooth = value 
    end
})

CombatTab:Toggle({
    Title = "Silent Aim", 
    Enabled = false, 
    Callback = function(value) 
        state.silentAim = value 
    end
})

CombatTab:Slider({
    Title = "Silent Aim FOV", 
    Value = state.silentAimFOV, 
    Min = 20, 
    Max = 500, 
    Callback = function(value) 
        state.silentAimFOV = value 
    end
})

CombatTab:Toggle({
    Title = "Kill Aura", 
    Enabled = false, 
    Callback = function(value) 
        state.killAura = value 
    end
})

CombatTab:Slider({
    Title = "Kill Aura Range", 
    Value = state.killAuraRange, 
    Min = 3, 
    Max = 50, 
    Callback = function(value) 
        state.killAuraRange = value 
    end
})

CombatTab:Toggle({
    Title = "Fling Nearby", 
    Enabled = false, 
    Callback = function(value) 
        state.fling = value 
        if value then
            local myCharacter = LocalPlayer.Character
            if myCharacter then
                local myRoot = getRootPart(myCharacter)
                if myRoot then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local rootPart = getRootPart(player.Character)
                            if rootPart and (rootPart.Position - myRoot.Position).Magnitude <= 20 then
                                flingPlayer(player)
                            end
                        end
                    end
                end
            end
        end
    end
})

CombatTab:Slider({
    Title = "Fling Force", 
    Value = state.flingForce, 
    Min = 200, 
    Max = 5000, 
    Callback = function(value) 
        state.flingForce = value 
    end
})

VisualsTab:Toggle({
    Title = "ESP Highlight", 
    Enabled = false, 
    Callback = function(value) 
        state.esp = value 
        toggleAllESP(value)
    end
})

VisualsTab:Button({
    Title = "Remove All ESP", 
    Callback = function() 
        toggleAllESP(false) 
    end
})

MainTab:Slider({
    Title = "WalkSpeed", 
    Value = state.walkSpeed, 
    Min = 8, 
    Max = 300, 
    Callback = function(value) 
        state.walkSpeed = value 
    end
})

MainTab:Slider({
    Title = "JumpPower", 
    Value = state.jumpPower, 
    Min = 50, 
    Max = 400, 
    Callback = function(value) 
        state.jumpPower = value 
    end
})

MainTab:Toggle({
    Title = "Fly", 
    Enabled = false, 
    Callback = function(value) 
        state.fly = value 
    end
})

MainTab:Slider({
    Title = "Fly Speed", 
    Value = state.flySpeed, 
    Min = 10, 
    Max = 500, 
    Callback = function(value) 
        state.flySpeed = value 
    end
})

MainTab:Toggle({
    Title = "Noclip", 
    Enabled = false, 
    Callback = function(value) 
        state.noclip = value 
        toggleNoclip(value)
    end
})

FarmTab:Toggle({
    Title = "Auto Farm (generic)", 
    Enabled = false, 
    Callback = function(value) 
        state.autoFarm = value 
    end
})

FarmTab:Slider({
    Title = "Auto Farm Range", 
    Value = state.autoFarmRange, 
    Min = 20, 
    Max = 500, 
    Callback = function(value) 
        state.autoFarmRange = value 
    end
})

FarmTab:Toggle({
    Title = "Auto Click", 
    Enabled = false, 
    Callback = function(value) 
        state.autoClick = value 
        if value then 
            startAutoClick() 
        else 
            stopAutoClick() 
        end
    end
})

FarmTab:Slider({
    Title = "Auto Click Rate", 
    Value = state.autoClickRate, 
    Min = 1, 
    Max = 30, 
    Callback = function(value) 
        state.autoClickRate = value 
    end
})

MiscTab:Toggle({
    Title = "Anti-AFK", 
    Enabled = state.antiAfk, 
    Callback = function(value) 
        state.antiAfk = value 
    end
})

MiscTab:Button({
    Title = "Server Hop", 
    Callback = serverHop
})

MiscTab:Button({
    Title = "Rejoin", 
    Callback = function() 
        TeleportService:Teleport(game.PlaceId, LocalPlayer) 
    end
})

MiscTab:Button({
    Title = "Refresh Character", 
    Callback = function() 
        local character = LocalPlayer.Character
        if character then 
            character:BreakJoints() 
        end
    end
})

SettingsTab:Button({
    Title = "Unload Script", 
    Callback = function() 
        toggleAllESP(false)
        disableFly()
        toggleNoclip(false)
        stopAutoClick()
        
        if renderConnection then
            renderConnection:Disconnect()
        end
        
        pcall(function() 
            Window:Destroy() 
        end)
    end
})

SettingsTab:Button({
    Title = "Toggle UI", 
    Callback = function() 
        if state.uiOpen then 
            Window:Hide() 
            state.uiOpen = false 
        else 
            Window:Show() 
            state.uiOpen = true 
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyMovement()
    if state.esp then 
        toggleAllESP(true) 
    end
end)

if state.esp then
    toggleAllESP(true)
end

print("STREE HUB Forsaken script loaded successfully")
