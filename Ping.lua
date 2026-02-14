local function CreateStreePanel()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "StreeMiniPanel"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 210, 0, 70)
    main.Position = UDim2.new(0.5, -105, 1, -120)
    main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    main.BackgroundTransparency = 0.25
    main.BorderSizePixel = 0
    main.Active = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(0,255,0)
    stroke.Thickness = 2

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,26)
    header.BackgroundTransparency = 1

    local logo = Instance.new("ImageLabel", header)
    logo.Image = "rbxassetid://122683047852451"
    logo.Size = UDim2.new(0,18,0,18)
    logo.Position = UDim2.new(0,6,0.5,-9)
    logo.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1,-30,1,0)
    title.Position = UDim2.new(0,28,0,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "STREE HUB PANEL"
    title.TextColor3 = Color3.fromRGB(0,255,120)

    local statsFrame = Instance.new("Frame", main)
    statsFrame.Position = UDim2.new(0,6,0,30)
    statsFrame.Size = UDim2.new(1,-12,1,-34)
    statsFrame.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", statsFrame)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0,6)

    local function makeStat()
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0,60,1,0)
        box.BackgroundColor3 = Color3.fromRGB(20,20,20)
        box.BackgroundTransparency = 0.2
        box.BorderSizePixel = 0
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

        local stroke = Instance.new("UIStroke", box)
        stroke.Color = Color3.fromRGB(60,60,60)

        local label = Instance.new("TextLabel", box)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextWrapped = true
        label.TextColor3 = Color3.new(1,1,1)

        box.Parent = statsFrame
        return label
    end

    local cpuLabel = makeStat()
    local pingLabel = makeStat()
    local fpsLabel = makeStat()

    local dragging = false
    local dragStart, startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local frames = 0
    local fps = 0
    local last = tick()

    RunService.RenderStepped:Connect(function()
        frames += 1
        if tick() - last >= 1 then
            fps = frames
            frames = 0
            last = tick()
        end
    end)

    local function getPing()
        local net = Stats:FindFirstChild("Network")
        if net and net:FindFirstChild("ServerStatsItem") then
            local item = net.ServerStatsItem:FindFirstChild("Data Ping")
            if item then return math.floor(item:GetValue()) end
        end
        return 0
    end

    local function getCPU()
        local perf = Stats:FindFirstChild("PerformanceStats")
        if perf then
            local cpu = perf:FindFirstChild("CPU")
            if cpu then return math.floor(cpu:GetValue()) end
        end
        return 0
    end

    local function color(label, v, y, r)
        if v >= r then
            label.TextColor3 = Color3.fromRGB(255,80,80)
        elseif v >= y then
            label.TextColor3 = Color3.fromRGB(255,220,0)
        else
            label.TextColor3 = Color3.fromRGB(0,255,120)
        end
    end

    task.spawn(function()
        while gui.Parent do
            local ping = getPing()
            local cpu = getCPU()

            cpuLabel.Text = "CPU\n"..cpu.."%"
            pingLabel.Text = "PING\n"..ping.."ms"
            fpsLabel.Text = "FPS\n"..fps

            color(cpuLabel, cpu, 60, 85)
            color(pingLabel, ping, 120, 200)
            color(fpsLabel, fps, 40, 90)

            task.wait(1)
        end
    end)

    return gui
end

local StreePanel = CreateStreePanel()
