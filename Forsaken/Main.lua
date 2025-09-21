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
    Size = UDim2.fromOffset(560, 400),
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
    Icon = "user"
})

local Section = Tab2:Section({
    Title = "Movement",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab2:Slider({
    Title = "WalkSpeed",
    Description = "Adjust WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

Tab2:Slider({
    Title = "JumpPower",
    Description = "Adjust JumpPower",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end
})

Tab2:Toggle({
    Title = "Infinite Stamina",
    Desc = "Energy never decrease",
    Default = false,
    Callback = function(state)
        _G.InfiniteEnergy = state
        task.spawn(function()
            while _G.InfiniteEnergy do
                task.wait(0.2)
                local lp = game.Players.LocalPlayer
                if lp and lp.Character then
                    local char = lp.Character
                    if char:FindFirstChild("Energy") then
                        pcall(function()
                            char.Energy.Value = math.huge
                        end)
                    end
                    if char:FindFirstChild("Stamina") then
                        pcall(function()
                            char.Stamina.Value = math.huge
                        end)
                    end
                    if lp:FindFirstChild("Energy") then
                        pcall(function()
                            lp.Energy.Value = math.huge
                        end)
                    end
                    if lp:FindFirstChild("Stamina") then
                        pcall(function()
                            lp.Stamina.Value = math.huge
                        end)
                    end
                    if char:FindFirstChild("Humanoid") then
                        local hum = char.Humanoid
                        if hum:GetAttribute("Energy") then
                            hum:SetAttribute("Energy", 999999)
                        end
                        if hum:GetAttribute("Stamina") then
                            hum:SetAttribute("Stamina", 999999)
                        end
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
    Title = "ESP",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab3:Toggle({
    Title = "Survivor ESP",
    Desc = "Highlight survivors",
    Default = false,
    Callback = function(state)
        _G.SurvivorESP = state
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Team and player.Team.Name == "Survivor" then
                if state then
                    setupCustomESP(player, Color3.fromRGB(0, 255, 0))
                else
                    removeESP(player)
                end
            end
        end
        game.Players.PlayerAdded:Connect(function(player)
            if _G.SurvivorESP and player.Team and player.Team.Name == "Survivor" then
                setupCustomESP(player, Color3.fromRGB(0, 255, 0))
            end
        end)
    end
})

Tab3:Toggle({
    Title = "Killer ESP",
    Desc = "Highlight killer",
    Default = false,
    Callback = function(state)
        _G.KillerESP = state
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Team and player.Team.Name == "Killer" then
                if state then
                    setupCustomESP(player, Color3.fromRGB(255, 0, 0))
                else
                    removeESP(player)
                end
            end
        end
        game.Players.PlayerAdded:Connect(function(player)
            if _G.KillerESP and player.Team and player.Team.Name == "Killer" then
                setupCustomESP(player, Color3.fromRGB(255, 0, 0))
            end
        end)
    end
})

function setupCustomESP(player, color)
    if player.Character then
        createCustomHighlight(player.Character, color)
    end
    player.CharacterAdded:Connect(function(char)
        if (player.Team and ((player.Team.Name == "Survivor" and _G.SurvivorESP) or (player.Team.Name == "Killer" and _G.KillerESP))) then
            createCustomHighlight(char, color)
        end
    end)
end

function createCustomHighlight(character, color)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = character
    highlight.Parent = character
end

function removeESP(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

local Tab4 = Window:Tab({
    Title = "World",
    Icon = "globe"
})

local section = Tab4:Section({
    Title = "Teleport",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab4:Button({
    Title = "Safe Zone",
    Desc = "Teleport to safe zone",
    Callback = function()
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
})

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
