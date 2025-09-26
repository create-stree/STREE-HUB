local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI gagal dimuat!")
    return
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://7734068321",
    Size = UDim2.new(0, 600, 0, 360),
    Theme = "Dark"
})

local mainFrame = Window.Frame or Window.Object or Window
if mainFrame then
    local bg = Instance.new("Frame")
    bg.Parent = mainFrame
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    bg.ZIndex = 0

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    gradient.Rotation = 270
    gradient.Parent = bg

    local wave1 = Instance.new("ImageLabel")
    wave1.Parent = bg
    wave1.Size = UDim2.new(2, 0, 0.3, 0)
    wave1.Position = UDim2.new(-0.5, 0, 0.7, 0)
    wave1.BackgroundTransparency = 1
    wave1.Image = "rbxassetid://6888539094"
    wave1.ImageColor3 = Color3.fromRGB(0, 255, 0)
    wave1.ImageTransparency = 0.2
    wave1.ZIndex = 1

    local wave2 = wave1:Clone()
    wave2.Parent = bg
    wave2.Position = UDim2.new(-0.5, 0, 0.75, 0)
    wave2.ImageTransparency = 0.35
    wave2.ZIndex = 1

    task.spawn(function()
        while task.wait() do
            wave1.Position = UDim2.new(-0.5, 0, 0.7, 0)
            wave1:TweenPosition(UDim2.new(0, 0, 0.7, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 4, true)
            task.wait(4)
        end
    end)

    task.spawn(function()
        while task.wait() do
            wave2.Position = UDim2.new(-0.5, 0, 0.75, 0)
            wave2:TweenPosition(UDim2.new(0, 0, 0.75, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 7, true)
            task.wait(7)
        end
    end)
end

local TabInfo = Window:CreateTab({
    Title = "Information",
    Icon = "rbxassetid://6034684946"
})

TabInfo:Label("🌐 STREE HUB v0.0.1")
TabInfo:Button({
    Title = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/xxxx")
    end
})

local TabMain = Window:CreateTab({
    Title = "Main",
    Icon = "rbxassetid://6034509993"
})

TabMain:Toggle({
    Title = "Auto Farm",
    Desc = "Collect otomatis",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        task.spawn(function()
            while _G.AutoFarm do
                task.wait(1)
                print("🌱 Auto Farming aktif")
            end
        end)
    end
})
