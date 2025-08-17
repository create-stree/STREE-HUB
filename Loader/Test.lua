-- Versi Final STREE HUB dengan semua fitur yang diminta
repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- GUI Parent
local parentGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Valid Keys
local validKeys = {
    "STREEHUB-2025-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM",
    "StreeCommunity-7g81ht7NO22"
}

-- Decal Images
local decalImages = {
    Home = "rbxassetid://123032091977400",    -- Ganti dengan ID gambar Anda
    Play = "rbxassetid://987654321",
    Decals = "rbxassetid://555555555",
    Credits = "rbxassetid://111222333",
    Whitelist = "rbxassetid://222333444",
    Discord = "rbxassetid://333444555"         -- Logo Discord
}

-- Key System
local function isKeyValid(keyInput)
    for _, key in ipairs(validKeys) do
        if keyInput == key then return true end
    end
    return false
end

-- Main UI Builder
local function buildMainUI()
    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.ResetOnSpawn = false

    -- Floating Icon
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0, 50, 0, 50)
    logoButton.Position = UDim2.new(0, 20, 0.5, -25)
    logoButton.Image = decalImages.Home
    logoButton.BackgroundTransparency = 1
    logoButton.Active = true
    logoButton.Draggable = true

    -- Main Window
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 500, 0, 350)  -- Diperbesar untuk fit semua konten
    window.Position = UDim2.new(0.5, -250, 0.5, -175)
    window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    window.BackgroundTransparency = 0.1
    window.BorderSizePixel = 0
    window.Active = true
    window.Draggable = true
    Instance.new("UICorner", window).CornerRadius = UDim.new(0,12)

    -- Title Bar
    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "STREE HUB v2.1 FINAL"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 40, 0, 0)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0, 255, 100)
    title.BackgroundTransparency = 1

    -- Close Button
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)

    -- Tab Menu
    local tabMenu = Instance.new("Frame", window)
    tabMenu.Size = UDim2.new(0, 120, 1, -40)
    tabMenu.Position = UDim2.new(1, -120, 0, 40)
    tabMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabMenu.BackgroundTransparency = 0.1
    Instance.new("UICorner", tabMenu).CornerRadius = UDim.new(0,6)

    -- Content Frame
    local contentFrame = Instance.new("Frame", window)
    contentFrame.Size = UDim2.new(1, -140, 1, -50)
    contentFrame.Position = UDim2.new(0, 10, 0, 45)
    contentFrame.BackgroundTransparency = 1

    -- Utility Functions
    local yOffset = 0
    local function nextY(height) local y = yOffset; yOffset = yOffset + height + 5; return y end
    local function resetYOffset() yOffset = 0 end
    
    local function clearContent()
        for _, v in pairs(contentFrame:GetChildren()) do
            if v:IsA("GuiObject") then v:Destroy() end
        end
    end

    local function createLabel(text)
        local lbl = Instance.new("TextLabel", contentFrame)
        lbl.Size = UDim2.new(1, -20, 0, 25)
        lbl.Position = UDim2.new(0, 10, 0, nextY(25))
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.BackgroundTransparency = 1
        return lbl
    end

    -- Modern Toggle Function
    local function createModernToggle(text, defaultValue, callback)
        local toggleContainer = Instance.new("Frame", contentFrame)
        toggleContainer.Size = UDim2.new(1, -20, 0, 40)
        toggleContainer.Position = UDim2.new(0, 10, 0, nextY(40))
        toggleContainer.BackgroundTransparency = 1
        
        -- Label
        local label = Instance.new("TextLabel", toggleContainer)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = "  "..text
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 16
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        -- Toggle Switch
        local toggleFrame = Instance.new("Frame", toggleContainer)
        toggleFrame.Size = UDim2.new(0, 50, 0, 25)
        toggleFrame.Position = UDim2.new(1, -55, 0.5, -12)
        toggleFrame.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)
        
        local toggleCircle = Instance.new("Frame", toggleFrame)
        toggleCircle.Size = UDim2.new(0, 21, 0, 21)
        toggleCircle.Position = defaultValue and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
        
        local button = Instance.new("TextButton", toggleContainer)
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Text = ""
        button.BackgroundTransparency = 1
        
        local state = defaultValue or false
        
        button.MouseButton1Click:Connect(function()
            state = not state
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            if state then
                TweenService:Create(toggleFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
                TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
            else
                TweenService:Create(toggleFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
            end
            
            if callback then callback(state) end
        end)
        
        return {
            SetState = function(newState)
                state = newState
                button.MouseButton1Click:Connect()
            end
        }
    end

    -- Slider Function
    local function createSlider(label, minValue, maxValue, defaultValue, callback)
        local sliderContainer = Instance.new("Frame", contentFrame)
        sliderContainer.Size = UDim2.new(1, -20, 0, 60)
        sliderContainer.Position = UDim2.new(0, 10, 0, nextY(60))
        sliderContainer.BackgroundTransparency = 1
        
        -- Label
        local sliderLabel = Instance.new("TextLabel", sliderContainer)
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.Text = label
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 14
        sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Track
        local track = Instance.new("Frame", sliderContainer)
        track.Size = UDim2.new(1, 0, 0, 6)
        track.Position = UDim2.new(0, 0, 0, 25)
        track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        
        -- Fill
        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new((defaultValue - minValue)/(maxValue - minValue), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        
        -- Thumb
        local thumb = Instance.new("TextButton", track)
        thumb.Size = UDim2.new(0, 20, 0, 20)
        thumb.Position = UDim2.new(fill.Size.X.Scale, -10, 0.5, -10)
        thumb.Text = ""
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
        
        -- Value Display
        local valueLabel = Instance.new("TextLabel", sliderContainer)
        valueLabel.Size = UDim2.new(0, 60, 0, 20)
        valueLabel.Position = UDim2.new(1, -60, 0, 35)
        valueLabel.Text = tostring(defaultValue)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 14
        valueLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        valueLabel.BackgroundTransparency = 1
        
        -- Drag Logic
        local dragging = false
        thumb.MouseButton1Down:Connect(function() dragging = true end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if dragging then
                local mouseX = game:GetService("UserInputService"):GetMouseLocation().X
                local trackX = track.AbsolutePosition.X
                local trackWidth = track.AbsoluteSize.X
                local relative = math.clamp((mouseX - trackX) / trackWidth, 0, 1)
                
                local value = math.floor(minValue + (maxValue - minValue) * relative)
                valueLabel.Text = tostring(value)
                fill.Size = UDim2.new(relative, 0, 1, 0)
                thumb.Position = UDim2.new(relative, -10, 0.5, -10)
                
                if callback then callback(value) end
            end
        end)
    end

    -- Discord Button Function
    local function createDiscordButton()
        local btn = Instance.new("Frame", contentFrame)
        btn.Size = UDim2.new(1, -20, 0, 50)
        btn.Position = UDim2.new(0, 10, 0, nextY(50))
        btn.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        
        -- Icon
        local icon = Instance.new("ImageLabel", btn)
        icon.Size = UDim2.new(0, 30, 0, 30)
        icon.Position = UDim2.new(0, 10, 0.5, -15)
        icon.Image = decalImages.Discord
        icon.BackgroundTransparency = 1
        
        -- Text
        local textFrame = Instance.new("Frame", btn)
        textFrame.Size = UDim2.new(1, -50, 1, 0)
        textFrame.Position = UDim2.new(0, 50, 0, 0)
        textFrame.BackgroundTransparency = 1
        
        local title = Instance.new("TextLabel", textFrame)
        title.Size = UDim2.new(1, 0, 0.5, 0)
        title.Text = "Discord Invite"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.BackgroundTransparency = 1
        
        local subtitle = Instance.new("TextLabel", textFrame)
        subtitle.Size = UDim2.new(1, 0, 0.5, 0)
        subtitle.Position = UDim2.new(0, 0, 0.5, 0)
        subtitle.Text = "Click to Copy Invite Link"
        subtitle.Font = Enum.Font.Gotham
        subtitle.TextSize = 14
        subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.BackgroundTransparency = 1
        
        -- Button
        local button = Instance.new("TextButton", btn)
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Text = ""
        button.BackgroundTransparency = 1
        
        -- Hover Effect
        local hover = Instance.new("Frame", btn)
        hover.Size = UDim2.new(1, 0, 1, 0)
        hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hover.BackgroundTransparency = 0.9
        hover.Visible = false
        Instance.new("UICorner", hover).CornerRadius = UDim.new(0, 8)
        
        button.MouseEnter:Connect(function()
            hover.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
        end)
        
        button.MouseLeave:Connect(function()
            hover.Visible = false
            btn.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
        end)
        
        button.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 43, 48)}):Play()
            wait(0.1)
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(64, 68, 75)}):Play()
            
            if setclipboard then
                setclipboard("https://discord.gg/streehub")
                subtitle.Text = "Copied to clipboard!"
                wait(2)
                subtitle.Text = "Click to Copy Invite Link"
            end
        end)
    end

    -- Collapsible Panel Function
    local function createCollapsiblePanel(title, initialState)
        local isOpen = initialState or false
        local panel = Instance.new("Frame", contentFrame)
        panel.Size = UDim2.new(1, -20, 0, 50)
        panel.Position = UDim2.new(0, 10, 0, nextY(50))
        panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
        
        -- Header
        local header = Instance.new("Frame", panel)
        header.Size = UDim2.new(1, 0, 0, 50)
        header.BackgroundTransparency = 1
        
        local titleLabel = Instance.new("TextLabel", header)
        titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
        titleLabel.Position = UDim2.new(0, 15, 0, 0)
        titleLabel.Text = title
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 16
        titleLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.BackgroundTransparency = 1
        
        -- Arrow Icon (▼ when closed, ▲ when open)
        local arrow = Instance.new("ImageLabel", header)
        arrow.Size = UDim2.new(0, 20, 0, 20)
        arrow.Position = UDim2.new(1, -30, 0.5, -10)
        arrow.Image = "rbxassetid://6751078142" -- ▼ symbol
        arrow.BackgroundTransparency = 1
        arrow.Rotation = isOpen and 180 or 0
        
        -- Content
        local content = Instance.new("Frame", panel)
        content.Size = UDim2.new(1, 0, 0, isOpen and 100 or 0)
        content.Position = UDim2.new(0, 0, 0, 50)
        content.BackgroundTransparency = 1
        content.ClipsDescendants = true
        
        -- Toggle Function
        local function toggle()
            isOpen = not isOpen
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
            
            if isOpen then
                TweenService:Create(panel, tweenInfo, {Size = UDim2.new(1, -20, 0, 150)}):Play()
                TweenService:Create(content, tweenInfo, {Size = UDim2.new(1, 0, 0, 100)}):Play()
                TweenService:Create(arrow, tweenInfo, {Rotation = 180}):Play()
            else
                TweenService:Create(panel, tweenInfo, {Size = UDim2.new(1, -20, 0, 50)}):Play()
                TweenService:Create(content, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                TweenService:Create(arrow, tweenInfo, {Rotation = 0}):Play()
            end
        end
        
        -- Button
        local button = Instance.new("TextButton", header)
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Text = ""
        button.BackgroundTransparency = 1
        button.MouseButton1Click:Connect(toggle)
        
        -- Hover Effect
        local hover = Instance.new("Frame", header)
        hover.Size = UDim2.new(1, 0, 1, 0)
        hover.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        hover.BackgroundTransparency = 0.8
        hover.Visible = false
        Instance.new("UICorner", hover).CornerRadius = UDim.new(0, 8)
        
        button.MouseEnter:Connect(function() hover.Visible = true end)
        button.MouseLeave:Connect(function() hover.Visible = false end)
        
        return {
            Panel = panel,
            Content = content,
            Toggle = toggle
        }
    end

    -- Tab Creation Function
    local lastTabY = 0
    local function createTab(name, decalId, callback)
        local tabContainer = Instance.new("Frame", tabMenu)
        tabContainer.Size = UDim2.new(1, -10, 0, 40)
        tabContainer.Position = UDim2.new(0, 5, 0, lastTabY + 5)
        tabContainer.BackgroundTransparency = 1
        lastTabY = lastTabY + 45
        
        -- Decal Icon
        local decalFrame = Instance.new("Frame", tabContainer)
        decalFrame.Size = UDim2.new(0, 30, 0, 30)
        decalFrame.Position = UDim2.new(0, 5, 0.5, -15)
        decalFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Instance.new("UICorner", decalFrame).CornerRadius = UDim.new(0, 6)
        
        local decalImg = Instance.new("ImageLabel", decalFrame)
        decalImg.Size = UDim2.new(1, -4, 1, -4)
        decalImg.Position = UDim2.new(0, 2, 0, 2)
        decalImg.Image = decalId
        decalImg.BackgroundTransparency = 1
        decalImg.ScaleType = Enum.ScaleType.Fit
        
        -- Tab Name
        local tabName = Instance.new("TextLabel", tabContainer)
        tabName.Size = UDim2.new(1, -45, 1, 0)
        tabName.Position = UDim2.new(0, 40, 0, 0)
        tabName.Text = "  "..name
        tabName.Font = Enum.Font.GothamMedium
        tabName.TextSize = 15
        tabName.TextXAlignment = Enum.TextXAlignment.Left
        tabName.TextColor3 = Color3.fromRGB(0, 255, 100)
        tabName.BackgroundTransparency = 1
        
        -- Button
        local button = Instance.new("TextButton", tabContainer)
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Text = ""
        button.BackgroundTransparency = 1
        
        button.MouseButton1Click:Connect(function()
            -- Reset all tabs
            for _, tab in pairs(tabMenu:GetChildren()) do
                if tab:IsA("Frame") then
                    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end
            
            -- Highlight active tab
            tabContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            clearContent()
            resetYOffset()
            callback()
        end)
    end

    -- Create All Tabs
    createTab("Home", decalImages.Home, function()
        createLabel("⚙️ Utilities")
        createModernToggle("Night Mode", false, function(state)
            game.Lighting.TimeOfDay = state and "00:00:00" or "14:00:00"
        end)
        
        createSlider("Flight Speed", 0, 1000, 100, function(value)
            print("Flight speed set to:", value)
        end)
        
        createSlider("Walk Speed", 16, 200, 50, function(value)
            print("Walk speed set to:", value)
        end)
    end)

    createTab("Play", decalImages.Play, function()
        createLabel("🔄 Auto Features")
        createModernToggle("Auto Play (Inf Money)", false, function(state)
            print("Auto Play:", state)
        end)
        
        createModernToggle("Auto Farm", false, function(state)
            print("Auto Farm:", state)
        end)
        
        createCollapsiblePanel("Advanced Settings", false)
    end)

    createTab("Decals", decalImages.Decals, function()
        createLabel("🎨 Popular Decals")
        -- Tambahkan grid decal di sini
    end)

    createTab("Whitelist", decalImages.Whitelist, fu
