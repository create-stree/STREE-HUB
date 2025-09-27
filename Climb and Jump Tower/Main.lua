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
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
        end,
    },
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

local Section = Tab1:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

local Section2 = Tab2:Section({
    Title = "First Place",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab2:Toggle({
    Title = "Auto Win",
    Desc = "Auto claim win [BETA]",
    Default = false,
    Callback = function(state)
        _G.AutoFarmWin = state
        task.spawn(function()
            while _G.AutoFarmWin do
                task.wait(2)
                local lp = game.Players.LocalPlayer
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local winPart = nil
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Part") and v.Name:lower():find("win") then
                            winPart = v
                            break
                        end
                    end
                    if winPart then
                        firetouchinterest(hrp, winPart, 0)
                        task.wait(0.1)
                        firetouchinterest(hrp, winPart, 1)
                    else
                        hrp.CFrame = CFrame.new(-4, 14401, -115)
                    end
                end
            end
        end)
    end
})

Tab2:Toggle({
    Title = "Auto Farm Coins [Normal]",
    Desc = "Auto collect coins [Normal]",
    Default = false,
    Callback = function(state)
        _G.AutoFarmCoinsNormal = state
        task.spawn(function()
            while _G.AutoFarmCoinsNormal do
                task.wait(3)
                local lp = game.Players.LocalPlayer
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("money")) then
                            firetouchinterest(hrp, v, 0)
                            task.wait(0.1)
                            firetouchinterest(hrp, v, 1)
                        end
                    end
                end
            end
        end)
    end
})

Tab2:Toggle({
    Title = "Auto Farm Coins [Fast]",
    Desc = "Auto collect coins [Fast]",
    Default = false,
    Callback = function(state)
        _G.AutoFarmCoinsFast = state
        task.spawn(function()
            while _G.AutoFarmCoinsFast do
                task.wait(1)
                local lp = game.Players.LocalPlayer
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("money")) then
                            firetouchinterest(hrp, v, 0)
                            task.wait(0.05)
                            firetouchinterest(hrp, v, 1)
                        end
                    end
                end
            end
        end)
    end
})

Tab2:Toggle({
    Title = "Auto Farm Coins [Safe]",
    Desc = "Auto collect coins [Safe]",
    Default = false,
    Callback = function(state)
        _G.AutoFarmCoinsSafe = state
        task.spawn(function()
            while _G.AutoFarmCoinsSafe do
                task.wait(5)
                local lp = game.Players.LocalPlayer
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("money")) then
                            firetouchinterest(hrp, v, 0)
                            task.wait(0.2)
                            firetouchinterest(hrp, v, 1)
                        end
                    end
                end
            end
        end)
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
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
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
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
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
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
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
    if _G.NoClip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

local Tab4 = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

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
    text.Parent = billboard
end

local function removeNameESP(char)
    if char and char:FindFirstChild("NameDistanceBillboard") then
        char.NameDistanceBillboard:Destroy()
    end
end

Tab4:Toggle({
    Title = "Name & Distance ESP",
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
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character then
                    removeNameESP(p.Character)
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
        local vu = game:GetService("VirtualUser")
        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(60)
                    pcall(function()
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new())
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
                    local ui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if ui then
                        local prompt = ui:FindFirstChild("promptOverlay")
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
