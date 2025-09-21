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
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
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
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
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
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
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
    Title = "Player ESP",
    Desc = "Show players through walls",
    Default = false,
    Callback = function(state)
        _G.PlayerESP = state
        
        if state then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    setupESP(player)
                end
            end
            
            game.Players.PlayerAdded:Connect(function(player)
                if _G.PlayerESP then
                    setupESP(player)
                end
            end)
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local highlight = player.Character:FindFirstChild("ESPHighlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
})

function setupESP(player)
    if player.Character then
        createHighlight(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        if _G.PlayerESP then
            createHighlight(character)
        end
    end)
end

function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = character
    highlight.Parent = character
    
    character.AncestryChanged:Connect(function()
        if not character:IsDescendantOf(game.Workspace) then
            highlight:Destroy()
        end
    end)
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
