local allowedKeys = {
    "FreeKeySystem",
    "PRRI",
    "STREE2025"
}

local UserInputService = game:GetService("UserInputService")

local function createAlchemyUI()
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = "STREE_UI_ALCHEMY"
    gui.ResetOnSpawn = false

    -- Main Frame
    local mainFrame = Instance.new("Frame", gui)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.Size = UDim2.new(0, 750, 0, 420)
    mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
    mainFrame.BorderSizePixel = 0

    -- Sidebar kiri
    local sidebar = Instance.new("Frame", mainFrame)
    sidebar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    sidebar.BackgroundTransparency = 0.8
    sidebar.Size = UDim2.new(0, 180, 1, 0)
    sidebar.BorderSizePixel = 0

    local logo = Instance.new("TextLabel", sidebar)
    logo.Text = "STREE HUB"
    logo.Font = Enum.Font.GothamBlack
    logo.TextColor3 = Color3.fromRGB(0, 255, 0)
    logo.BackgroundTransparency = 1
    logo.TextScaled = true
    logo.Size = UDim2.new(1, 0, 0, 50)

    local content = Instance.new("Frame", mainFrame)
    content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    content.BackgroundTransparency = 0.05
    content.Position = UDim2.new(0, 190, 0, 10)
    content.Size = UDim2.new(1, -200, 1, -20)
    content.BorderSizePixel = 0

    local label = Instance.new("TextLabel", content)
    label.Text = "🎮 Game Loader Panel"
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 10)
    label.Size = UDim2.new(1, -20, 0, 40)
    label.TextScaled = true

    -- Fungsi buat tombol sidebar
    local function createSideButton(text, y, callback)
        local btn = Instance.new("TextButton", sidebar)
        btn.Text = text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextColor3 = Color3.fromRGB(0, 255, 100)
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.Size = UDim2.new(1, -20, 0, 30)
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

    createSideButton("❌ Close UI", 180, function()
        gui:Destroy()
    end)

    -- Drag support
    local dragging = false
    local dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

-- KEY UI
local function showKeyUI()
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = "STREE_KEY_UI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.Position = UDim2.new(0.35, 0, 0.35, 0)
    frame.Size = UDim2.new(0, 350, 0, 180)
    frame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", frame)
    title.Text = "🔐 Enter Your Key"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(0, 255, 0)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 40)

    local box = Instance.new("TextBox", frame)
    box.PlaceholderText = "Enter key here..."
    box.Font = Enum.Font.Gotham
    box.Text = ""
    box.TextScaled = true
    box.TextColor3 = Color3.fromRGB(0, 255, 0)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    box.Position = UDim2.new(0.1, 0, 0.4, 0)
    box.Size = UDim2.new(0.8, 0, 0, 40)
    box.BorderSizePixel = 0

    local button = Instance.new("TextButton", frame)
    button.Text = "✅ Verify Key"
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.fromRGB(0, 255, 0)
    button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    button.Size = UDim2.new(0.5, 0, 0, 40)
    button.Position = UDim2.new(0.25, 0, 0.75, 0)
    button.BorderSizePixel = 0

    button.MouseButton1Click:Connect(function()
        for _, key in pairs(allowedKeys) do
            if box.Text == key then
                gui:Destroy()
                createAlchemyUI()
                return
            end
        end
        title.Text = "❌ Key Salah!"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
    end)
end

-- Start dengan Key UI
showKeyUI()
