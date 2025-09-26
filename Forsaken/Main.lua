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
    Author = "KirsiaSC | Forsaken",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 380),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.3",
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

local Section = Tab1:Section({
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

local Section = Tab1:Section({
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

_G.CustomJumpPower = 50

local Input = Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local speed = tonumber(input)
        if speed and speed >= 16 then
            Humanoid.WalkSpeed = speed
            print("WalkSpeed set to: " .. speed)
        else
            Humanoid.WalkSpeed = 16
            print("⚠️ Invalid input, set to default (16)")
        end
    end
})

local Input = Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local value = tonumber(input)
        if value and value >= 50 then
            _G.CustomJumpPower = value
            local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = value
            end
            print("Jump Power set to: " .. value)
        else
            warn("⚠️ Must be number and minimum 50!")
        end
    end
})

local Button = Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "Return Jump Power to normal (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
        print("🔄 Jump Power reset to 50")
    end
})

Player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.UseJumpPower = true
    humanoid.JumpPower = _G.CustomJumpPower or 50
end)

Tab2:Button({
    Title = "Reset Speed",
    Desc = "Return speed to normal (16)",
    Callback = function()
        Humanoid.WalkSpeed = 16
        print("WalkSpeed reset to default (16)")
    end
})

local UserInputService = game:GetService("UserInputService")

local Toggle = Tab2:Toggle({
    Title = "Infinite Jump",
    Desc = "activate to use infinite jump",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state) 
        _G.InfiniteJump = state
        if state then
            print("✅ Infinite Jump Active")
        else
            print("❌ Infinite Jump Inactive")
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local character = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tab2:Toggle({
    Title = "Infinite Stamina",
    Desc = "Energy never decrease [Beta]",
    Default = false,
    Callback = function(state)
        _G.InfiniteEnergy = state
        task.spawn(function()
            while _G.InfiniteEnergy do
                task.wait(0.2)
                local lp = game.Players.LocalPlayer
                if lp and lp.Character then
                    local char = lp.Character
                    if char:FindFirstChild("Energy") then pcall(function() char.Energy.Value = math.huge end) end
                    if char:FindFirstChild("Stamina") then pcall(function() char.Stamina.Value = math.huge end) end
                    if lp:FindFirstChild("Energy") then pcall(function() lp.Energy.Value = math.huge end) end
                    if lp:FindFirstChild("Stamina") then pcall(function() lp.Stamina.Value = math.huge end) end
                    if char:FindFirstChild("Humanoid") then
                        local hum = char.Humanoid
                        if hum:GetAttribute("Energy") then hum:SetAttribute("Energy", 999999) end
                        if hum:GetAttribute("Stamina") then hum:SetAttribute("Stamina", 999999) end
                    end
                end
            end
        end)
    end
})

local Tab3 = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

local Section = Tab3:Section({
    Title = "ESP Survivor",
    TextXAlignment = "Left",
    TextSize = 17
})

local function createHighlight(char, color, name)
    if not char or char:FindFirstChild(name) then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = name
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.Adornee = char
    highlight.Parent = char
end

local function removeHighlight(char, name)
    if char and char:FindFirstChild(name) then
        char[name]:Destroy()
    end
end

local function createBox(char, color, name)
    if not char or not char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild(name) then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = name
    box.Adornee = char.HumanoidRootPart
    box.AlwaysOnTop = true
    box.ZIndex = 2
    box.Size = Vector3.new(4,6,2)
    box.Color3 = color
    box.Transparency = 0.5
    box.Parent = char
end

local function removeBox(char, name)
    if char and char:FindFirstChild(name) then
        char[name]:Destroy()
    end
end

local function createNameESP(char)
    if not char or not char:FindFirstChild("Head") or char:FindFirstChild("NameDistanceBillboard") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameDistanceBillboard"
    billboard.Adornee = char.Head
    billboard.Size = UDim2.new(0,200,0,40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0,3.5,0)
    billboard.Parent = char

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255,255,255)
    text.TextStrokeColor3 = Color3.new(0,0,0)
    text.TextStrokeTransparency = 0.5
    text.Font = Enum.Font.SourceSans
    text.TextSize = 14
    text.TextScaled = false
    text.Parent = billboard
end

local function removeNameESP(char)
    if char and char:FindFirstChild("NameDistanceBillboard") then
        char.NameDistanceBillboard:Destroy()
    end
end

Tab3:Toggle({
    Title = "Survivor Highlight",
    Desc = "Highlight survivors",
    Default = false,
    Callback = function(state)
        _G.SurvivorHighlight = state
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Team and p.Team.Name == "Survivor" then
                p.CharacterAdded:Connect(function(c)
                    if _G.SurvivorHighlight then createHighlight(c, Color3.fromRGB(0,255,0), "SurvivorHighlight") end
                end)
                if p.Character then
                    if _G.SurvivorHighlight then createHighlight(p.Character, Color3.fromRGB(0,255,0), "SurvivorHighlight") end
                end
            end
        end
        game.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                if _G.SurvivorHighlight and p.Team and p.Team.Name == "Survivor" then
                    createHighlight(c, Color3.fromRGB(0,255,0), "SurvivorHighlight")
                end
            end)
        end)
    end
})

Tab3:Toggle({
    Title = "Survivor Box",
    Desc = "Box survivors",
    Default = false,
    Callback = function(state)
        _G.SurvivorBox = state
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Team and p.Team.Name == "Survivor" then
                p.CharacterAdded:Connect(function(c)
                    if _G.SurvivorBox then createBox(c, Color3.fromRGB(0,255,0), "SurvivorBox") end
                end)
                if p.Character then
                    if _G.SurvivorBox then createBox(p.Character, Color3.fromRGB(0,255,0), "SurvivorBox") end
                end
            end
        end
        game.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                if _G.SurvivorBox and p.Team and p.Team.Name == "Survivor" then
                    createBox(c, Color3.fromRGB(0,255,0), "SurvivorBox")
                end
            end)
        end)
    end
})

local Section = Tab3:Section({
    Title = "ESP Killer",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab3:Toggle({
    Title = "Killer Highlight",
    Desc = "Highlight killer",
    Default = false,
    Callback = function(state)
        _G.KillerHighlight = state
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Team and p.Team.Name == "Killer" then
                p.CharacterAdded:Connect(function(c)
                    if _G.KillerHighlight then createHighlight(c, Color3.fromRGB(255,0,0), "KillerHighlight") end
                end)
                if p.Character then
                    if _G.KillerHighlight then createHighlight(p.Character, Color3.fromRGB(255,0,0), "KillerHighlight") end
                end
            end
        end
        game.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                if _G.KillerHighlight and p.Team and p.Team.Name == "Killer" then
                    createHighlight(c, Color3.fromRGB(255,0,0), "KillerHighlight")
                end
            end)
        end)
    end
})

Tab3:Toggle({
    Title = "Killer Box",
    Desc = "Box killer",
    Default = false,
    Callback = function(state)
        _G.KillerBox = state
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Team and p.Team.Name == "Killer" then
                p.CharacterAdded:Connect(function(c)
                    if _G.KillerBox then createBox(c, Color3.fromRGB(255,0,0), "KillerBox") end
                end)
                if p.Character then
                    if _G.KillerBox then createBox(p.Character, Color3.fromRGB(255,0,0), "KillerBox") end
                end
            end
        end
        game.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function(c)
                if _G.KillerBox and p.Team and p.Team.Name == "Killer" then
                    createBox(c, Color3.fromRGB(255,0,0), "KillerBox")
                end
            end)
        end)
    end
})

local Section = Tab3:Section({
    Title = "ESP Other",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab3:Toggle({
    Title = "Name & Distance",
    Desc = "Show player names and distance",
    Default = false,
    Callback = function(state)
        _G.NameDistanceESP = state
    end
})

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.NameDistanceESP then
            local lp = game.Players.LocalPlayer
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
                        createNameESP(p.Character)
                        local bp = p.Character:FindFirstChild("NameDistanceBillboard")
                        if bp and bp:FindFirstChildOfClass("TextLabel") then
                            local dist = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            bp:FindFirstChildOfClass("TextLabel").Text = p.Name.." | "..math.floor(dist).." studs"
                        end
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

local Section = Tab5:Section({
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab5:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(60)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
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
