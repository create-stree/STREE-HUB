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
    Icon = "rbxassetid://123032091977400",
    Author = "KirsiaSC | Climb and Jump Tower",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0, 255, 0),
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info"
})

local Section1 = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab1:Button({
    Title = "Discord",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app")
        end
    end
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

local Section2 = Tab2:Section({
    Title = "Auto Farm",
    TextXAlignment = "Left",
    TextSize = 17
})

local autoFarmConnection
local autoFarmCoinsConnection
local autoFarmFastConnection
local autoFarmSafeConnection

Tab2:Toggle({
    Title = "Auto Win",
    Desc = "Auto claim win [BETA]",
    Default = false,
    Callback = function(state)
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
            autoFarmConnection = nil
        end
        
        if state then
            autoFarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.AutoFarmWin then return end
                
                local lp = game.Players.LocalPlayer
                local character = lp.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local winPart = workspace:FindFirstChild("Win") or workspace:FindFirstChild("WinPart")
                if winPart then
                    firetouchinterest(hrp, winPart, 0)
                    task.wait(0.1)
                    firetouchinterest(hrp, winPart, 1)
                else
                    hrp.CFrame = CFrame.new(-4, 14401, -115)
                end
            end)
        end
        _G.AutoFarmWin = state
    end
})

Tab2:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Auto collect coins [Normal]",
    Default = false,
    Callback = function(state)
        if autoFarmCoinsConnection then
            autoFarmCoinsConnection:Disconnect()
            autoFarmCoinsConnection = nil
        end
        
        if state then
            autoFarmCoinsConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.AutoFarmCoins then return end
                
                local lp = game.Players.LocalPlayer
                local character = lp.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                for _, coin in pairs(workspace:GetDescendants()) do
                    if coin:IsA("Part") and coin.Name:lower():find("coin") then
                        firetouchinterest(hrp, coin, 0)
                        task.wait(0.05)
                        firetouchinterest(hrp, coin, 1)
                    end
                end
            end)
        end
        _G.AutoFarmCoins = state
    end
})

Tab2:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Auto collect coins [Fast]",
    Default = false,
    Callback = function(state)
        if autoFarmFastConnection then
            autoFarmFastConnection:Disconnect()
            autoFarmFastConnection = nil
        end
        
        if state then
            autoFarmFastConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.AutoFarmFast then return end
                
                local lp = game.Players.LocalPlayer
                local character = lp.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                for _, coin in pairs(workspace:GetDescendants()) do
                    if coin:IsA("Part") and coin.Name:lower():find("coin") then
                        firetouchinterest(hrp, coin, 0)
                        firetouchinterest(hrp, coin, 1)
                    end
                end
            end)
        end
        _G.AutoFarmFast = state
    end
})

Tab2:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Auto collect coins [Safe]",
    Default = false,
    Callback = function(state)
        if autoFarmSafeConnection then
            autoFarmSafeConnection:Disconnect()
            autoFarmSafeConnection = nil
        end
        
        if state then
            autoFarmSafeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.AutoFarmSafe then return end
                
                local lp = game.Players.LocalPlayer
                local character = lp.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                for _, coin in pairs(workspace:GetDescendants()) do
                    if coin:IsA("Part") and coin.Name:lower():find("coin") then
                        firetouchinterest(hrp, coin, 0)
                        task.wait(0.1)
                        firetouchinterest(hrp, coin, 1)
                        task.wait(0.5)
                    end
                end
            end)
        end
        _G.AutoFarmSafe = state
    end
})

local Tab3 = Window:Tab({
    Title = "Players",
    Icon = "user"
})

local Section3 = Tab3:Section({
    Title = "Movement",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab3:Slider({
    Title = "WalkSpeed",
    Description = "Adjust WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        local lp = game.Players.LocalPlayer
        local character = lp.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

Tab3:Slider({
    Title = "JumpPower",
    Description = "Adjust JumpPower",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        local lp = game.Players.LocalPlayer
        local character = lp.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
})

Tab3:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump without limit",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local lp = game.Players.LocalPlayer
        local character = lp.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                humanoid:ChangeState("Jumping")
            end
        end
    end
end)

Tab3:Toggle({
    Title = "NoClip",
    Desc = "Walk through walls",
    Default = false,
    Callback = function(state)
        _G.NoClip = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if _G.NoClip then
        local lp = game.Players.LocalPlayer
        local character = lp.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local Tab4 = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

local function createNameESP(character)
    if not character or not character:FindFirstChild("Head") or character:FindFirstChild("NameDistanceBillboard") then 
        return 
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameDistanceBillboard"
    billboard.Adornee = character.Head
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboard.Parent = character
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.TextStrokeTransparency = 0.5
    text.Font = Enum.Font.SourceSansBold
    text.TextSize = 14
    text.Parent = billboard
end

local function removeNameESP(character)
    if character and character:FindFirstChild("NameDistanceBillboard") then
        character.NameDistanceBillboard:Destroy()
    end
end

Tab4:Toggle({
    Title = "Name & Distance ESP",
    Desc = "Show player names and distance",
    Default = false,
    Callback = function(state)
        _G.NameDistanceESP = state
        
        if not state then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    removeNameESP(player.Character)
                end
            end
        end
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
    if not _G.NameDistanceESP then return end
    
    local lp = game.Players.LocalPlayer
    local lpCharacter = lp.Character
    if not lpCharacter or not lpCharacter:FindFirstChild("HumanoidRootPart") then return end
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lp then
            local character = player.Character
            if character and character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart") then
                createNameESP(character)
                
                local billboard = character:FindFirstChild("NameDistanceBillboard")
                if billboard then
                    local textLabel = billboard:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        local distance = (lpCharacter.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                        textLabel.Text = string.format("%s | %d studs", player.Name, math.floor(distance))
                    end
                end
            end
        end
    end
end)

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

Tab5:Toggle({
    Title = "AntiAFK",
    Desc = "Stay active",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        
        if state then
            local virtualUser = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                if _G.AntiAFK then
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                end
            end)
        end
    end
})

Tab5:Toggle({
    Title = "Auto Reconnect",
    Desc = "Reconnect if disconnected",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
    end
})

game:GetService("CoreGui").ChildAdded:Connect(function(child)
    if child.Name == "RobloxPromptGui" and _G.AutoReconnect then
        task.wait(1)
        local promptOverlay = child:FindFirstChild("promptOverlay")
        if promptOverlay then
            local errorPrompt = promptOverlay:FindFirstChild("ErrorPrompt")
            if errorPrompt then
                local button = errorPrompt:FindFirstChild("Button")
                if button then
                    firesignal(button.MouseButton1Click)
                end
            end
        end
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game.Players.LocalPlayer then
        _G.AutoFarmWin = false
        _G.AutoFarmCoins = false
        _G.AutoFarmFast = false
        _G.AutoFarmSafe = false
        _G.InfiniteJump = false
        _G.NoClip = false
        _G.NameDistanceESP = false
        _G.AntiAFK = false
        _G.AutoReconnect = false
    end
end)
