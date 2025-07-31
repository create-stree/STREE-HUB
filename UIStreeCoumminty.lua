local function createUI()
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = "STREE_HUB_UI"
    gui.ResetOnSpawn = false

    -- Frame Utama
    local mainFrame = Instance.new("Frame", gui)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
    mainFrame.Size = UDim2.new(0, 700, 0, 400)

    -- Sidebar (Transparan hijau neon)
    local sideBar = Instance.new("Frame", mainFrame)
    sideBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    sideBar.BackgroundTransparency = 0.8
    sideBar.BorderSizePixel = 0
    sideBar.Size = UDim2.new(0, 180, 1, 0)

    local title = Instance.new("TextLabel", sideBar)
    title.Text = "📁 STREE HUB"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(0, 255, 0)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 40)

    -- Konten Panel
    local content = Instance.new("Frame", mainFrame)
    content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    content.BackgroundTransparency = 0.1
    content.Position = UDim2.new(0, 190, 0, 10)
    content.Size = UDim2.new(1, -200, 1, -20)
    content.BorderSizePixel = 0

    local contentTitle = Instance.new("TextLabel", content)
    contentTitle.Text = "🛠️ Game Loader"
    contentTitle.Font = Enum.Font.GothamBold
    contentTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
    contentTitle.BackgroundTransparency = 1
    contentTitle.Position = UDim2.new(0, 10, 0, 10)
    contentTitle.Size = UDim2.new(1, -20, 0, 30)
    contentTitle.TextScaled = true

    local function createSideButton(text, y, callback)
        local btn = Instance.new("TextButton", sideBar)
        btn.Text = text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextColor3 = Color3.fromRGB(0, 255, 100)
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.BackgroundTransparency = 0.2
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(callback)
    end

    createSideButton("Grow A Garden", 60, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NAMA_GITHUB/STREE-HUB/main/GrowAGarden.lua"))()
    end)

    createSideButton("Steal A Brainrot", 100, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NAMA_GITHUB/STREE-HUB/main/StealABrainrot.lua"))()
    end)

    createSideButton("Dead Raills", 140, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NAMA_GITHUB/STREE-HUB/main/DeadRaills.lua"))()
    end)

    createSideButton("❌ Close", 180, function()
        gui:Destroy()
    end)

    -- Drag support
    local dragToggle = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            update(input)
        end
    end)
end

-- Panggil UI
createUI()
