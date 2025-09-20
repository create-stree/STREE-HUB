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
    Title = "v0.0.1 Forsaken",
    Color = Color3.fromRGB(0, 255, 0),
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "Forsaken UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Home = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Home:Button({
    Title = "Discord",
    Desc = "Copy Discord Link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

local Players = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

Players:Input({
    Title = "WalkSpeed",
    Value = "16",
    Callback = function(val)
        local s = tonumber(val)
        if s and s >= 16 then
            hum.WalkSpeed = s
        else
            hum.WalkSpeed = 16
        end
    end
})

Players:Input({
    Title = "JumpPower",
    Value = "50",
    Callback = function(val)
        local j = tonumber(val)
        if j then
            _G.CustomJumpPower = j
            hum.UseJumpPower = true
            hum.JumpPower = j
        end
    end
})

Players:Button({
    Title = "Reset Speed",
    Callback = function()
        hum.WalkSpeed = 16
    end
})

Players:Button({
    Title = "Reset Jump",
    Callback = function()
        hum.JumpPower = 50
    end
})

local uis = game:GetService("UserInputService")

Players:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfJump = state
    end
})

uis.JumpRequest:Connect(function()
    if _G.InfJump then
        local c = lp.Character or lp.CharacterAdded:Wait()
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Main = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

Main:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        task.spawn(function()
            while _G.AutoFarm do
                task.wait(1)
                game:GetService("ReplicatedStorage").Events.Farm:FireServer()
            end
        end)
    end
})

Main:Toggle({
    Title = "Auto Collect",
    Default = false,
    Callback = function(state)
        _G.AutoCollect = state
        task.spawn(function()
            while _G.AutoCollect do
                task.wait(0.5)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent then
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
        end)
    end
})

local Teleport = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

Teleport:Dropdown({
    Title = "Locations",
    Values = {"Spawn", "Arena", "BossRoom"},
    Callback = function(v)
        local loc = {
            ["Spawn"] = Vector3.new(0,5,0),
            ["Arena"] = Vector3.new(200,10,50),
            ["BossRoom"] = Vector3.new(-100,20,300)
        }
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(loc[v])
        end
    end
})

local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

Settings:Toggle({
    Title = "AntiAFK",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local vu = game:GetService("VirtualUser")
        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end
        end)
    end
})

Settings:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = false,
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
