-- STREE HUB (Key system + Main UI) - All in one
-- Key verification via HTTP, no loadstring, UI main included
-- Main UI is NOT created until the key is verified.

-- ======= Services =======
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ======= Config =======
local VERIFY_URL = "https://rkns.link/qss3x" -- verification keyInput

-- ======= Helper: verifyKey via HTTPS POST =======
local function verifyKey(keyInput)
    if not keyInput or keyInput == "" then
        return false, "empty"
    end

    local ok, resp = pcall(function()
        return HttpService:PostAsync(
            VERIFY_URL,
            HttpService:JSONEncode({ key = keyInput }),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if not ok then
        return false, "request_error"
    end

    local suc, decoded = pcall(function() return HttpService:JSONDecode(resp) end)
    if not suc or type(decoded) ~= "table" then
        return false, "invalid_response"
    end

    if decoded.status == "valid" then
        return true
    end

    return false, "invalid_key"
end

-- ======= Build Main UI (only called after key is valid) =======
local function buildMainUI(parent)
    local ui = Instance.new("ScreenGui")
    ui.Name = "STREE_HUB_UI"
    ui.ResetOnSpawn = false
    ui.Parent = parent

    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "UI berhasil dimuat!",
            Icon = "rbxassetid://123032091977400",
            Duration = 3
        })
    end)

    -- Logo button (restore/minimize)
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0, 48, 0, 48)
    logoButton.Position = UDim2.new(0, 12, 0, 12)
    logoButton.Image = "rbxassetid://123032091977400"
    logoButton.BackgroundTransparency = 1
    logoButton.ZIndex = 2
    logoButton.Visible = false -- sembunyi saat window muncul

    -- Main window
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    window.BackgroundTransparency = 0.25
    window.BorderSizePixel = 0
    window.Visible = true -- muncul saat UI dibuat

    local border = Instance.new("UIStroke", window)
    border.Thickness = 3
    border.Color = Color3.fromRGB(0, 255, 0)
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.LineJoinMode = Enum.LineJoinMode.Round

    local windowCorner = Instance.new("UICorner", window)
    windowCorner.CornerRadius = UDim.new(0, 12)

    local titleBar = Instance.new("Frame", window)
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    titleBar.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 50, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = "STREE | Grow A Garden | v0.00.01"

    local headerLogo = Instance.new("ImageLabel", titleBar)
    headerLogo.Size = UDim2.new(0, 36, 0, 36)
    headerLogo.Position = UDim2.new(0, 6, 0, 2)
    headerLogo.Image = "rbxassetid://123032091977400"
    headerLogo.BackgroundTransparency = 1

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 32, 0, 28)
    closeBtn.Position = UDim2.new(1, -36, 0, 6)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 0.8
    closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)

    local minBtn = Instance.new("TextButton", titleBar)
    minBtn.Size = UDim2.new(0, 32, 0, 28)
    minBtn.Position = UDim2.new(1, -76, 0, 6)
    minBtn.Text = "-"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.BackgroundTransparency = 0.8
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 140)

    local contentFrame = Instance.new("Frame", window)
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -160, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0

    local sidebar = Instance.new("Frame", window)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, -60)
    sidebar.Position = UDim2.new(1, -150, 0, 50)
    sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sidebar.BorderSizePixel = 0

    local sidebarCorner = Instance.new("UICorner", sidebar)
    sidebarCorner.CornerRadius = UDim.new(0, 8)

    local sideBlur = Instance.new("ImageLabel", sidebar)
    sideBlur.Name = "SidebarBlur"
    sideBlur.Size = UDim2.new(1, 0, 1, 0)
    sideBlur.Position = UDim2.new(0, 0, 0, 0)
    sideBlur.BackgroundTransparency = 1
    sideBlur.Image = "rbxassetid://5553946656"
    sideBlur.ImageTransparency = 0.45
    sideBlur.ScaleType = Enum.ScaleType.Stretch
    sideBlur.ZIndex = 0

    local tabs = { "Home", "Game", "Macro", "Webhook", "Settings", "Credits" }
    local tabButtons = {}
    local tabFrames = {}
    local startY = 6
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1, -12, 0, 34)
        btn.Position = UDim2.new(0, 6, 0, startY + (i-1) * 40)
        btn.Text = tabName
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        btn.TextColor3 = Color3.fromRGB(0, 255, 140)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

        local f = Instance.new("Frame", contentFrame)
        f.Name = tabName .. "Frame"
        f.Size = UDim2.new(1, 0, 1, 0)
        f.Position = UDim2.new(0,0,0,0)
        f.BackgroundTransparency = 1
        f.Visible = false

        tabButtons[tabName] = btn
        tabFrames[tabName] = f

        btn.MouseButton1Click:Connect(function()
            for _, tf in pairs(tabFrames) do tf.Visible = false end
            f.Visible = true
        end)
    end
    tabFrames["Home"].Visible = true

    local function createLabel(parent, text, y)
        local lbl = Instance.new("TextLabel", parent)
        lbl.Size = UDim2.new(1, -20, 0, 22)
        lbl.Position = UDim2.new(0, 10, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.Text = text
        return lbl
    end
    local function createButton(parent, text, y, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0, 220, 0, 30)
        b.Position = UDim2.new(0, 10, 0, y)
        b.BackgroundColor3 = Color3.fromRGB(40,40,40)
        b.TextColor3 = Color3.fromRGB(0,255,0)
        b.Font = Enum.Font.GothamBold
        b.Text = text
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.MouseButton1Click:Connect(function() if cb then cb() end end)
        return b
    end
    local function createToggle(parent, text, y, cb)
        local t = Instance.new("TextButton", parent)
        t.Size = UDim2.new(0, 220, 0, 30)
        t.Position = UDim2.new(0, 10, 0, y)
        t.BackgroundColor3 = Color3.fromRGB(40,40,40)
        t.TextColor3 = Color3.fromRGB(255,255,255)
        t.Font = Enum.Font.Gotham
        t.Text = text .. " [OFF]"
        Instance.new("UICorner", t).CornerRadius = UDim.new(0,6)
        local st = false
        t.MouseButton1Click:Connect(function()
            st = not st
            t.Text = text .. " [" .. (st and "ON" or "OFF") .. "]"
            if cb then pcall(cb, st) end
        end)
        return t
    end

    do
        local home = tabFrames["Home"]
        local y = 8
        createLabel(home, "Welcome to STREE HUB!", y); y = y + 28
        createButton(home, "Load Script (example)", y, function() warn("Load Script clicked") end); y = y + 36
        createToggle(home, "Auto Execute", y, function(state) warn("Auto execute:", state) end); y = y + 36
        createButton(home, "Enable Shiftlock", y, function()
            pcall(function() Players.LocalPlayer.DevEnableMouseLock = true end)
        end); y = y + 36
    end

    do
        local c = tabFrames["Credits"]
        createLabel(c, "Create : STREE Community", 8)
        createLabel(c, "STREE HUB | create-stree", 36)
    end

    closeBtn.MouseButton1Click:Connect(function()
        ui:Destroy()
    end)

    minBtn.MouseButton1Click:Connect(function()
        window.Visible = false
        logoButton.Visible = true
    end)

    logoButton.MouseButton1Click:Connect(function()
        window.Visible = true
        logoButton.Visible = false
    end)

    -- Dragging window
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    window.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    window.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return {
        ScreenGui = ui;
        Window = window;
        Logo = logoButton;
    }
end

-- ======= Build Key UI (only shown first) =======
local function buildKeyUI(parent, onSuccess)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "STREE_KeyUI"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = parent

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 340, 0, 170)
    frame.Position = UDim2.new(0.5, -170, 0.5, -85)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0,255,0)
    stroke.Thickness = 3

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -20, 0, 36)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.Text = "STREE HUB - Key System"

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1, -20, 0, 40)
    input.Position = UDim2.new(0, 10, 0, 56)
    input.PlaceholderText = "Masukkan key..."
    input.BackgroundColor3 = Color3.fromRGB(36,36,36)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.ClearTextOnFocus = false
    input.Font = Enum.Font.Gotham
    input.TextSize = 16
    Instance.new("UICorner", input).CornerRadius = UDim.new(0,6)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1, -20, 0, 18)
    status.Position = UDim2.new(0, 10, 0, 104)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Text = ""

    local getBtn = Instance.new("TextButton", frame)
    getBtn.Size = UDim2.new(0.47, -6, 0, 30)
    getBtn.Position = UDim2.new(0, 10, 0, 126)
    getBtn.Text = "Get Key"
    getBtn.Font = Enum.Font.GothamBold
    getBtn.TextSize = 16
    getBtn.BackgroundColor3 = Color3.fromRGB(60,120,255)
    getBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0,6)

    local verifyBtn = Instance.new("TextButton", frame)
    verifyBtn.Size = UDim2.new(0.47, -6, 0, 30)
    verifyBtn.Position = UDim2.new(0, 10 + (0.47 * 340) + 12, 0, 126)
    verifyBtn.Text = "Verify"
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 16
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    verifyBtn.TextColor3 = Color3.fromRGB(0,0,0)
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0,6)

    getBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(VERIFY_URL) end)
        status.TextColor3 = Color3.fromRGB(0,255,0)
        status.Text = "Link copied! Paste in browser."
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        local key = tostring(input.Text or "")

        if key == "" then
            status.TextColor3 = Color3.fromRGB(255,100,100)
            status.Text = "Key tidak boleh kosong!"
            return
        end

        status.TextColor3 = Color3.fromRGB(200,200,200)
        status.Text = "Memverifikasi..."
        local ok, err = verifyKey(key)
        if ok then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Key valid! Memuat UI..."
            wait(0.6)
            keyGui:Destroy()
            if onSuccess then pcall(onSuccess) end
        else
            status.TextColor3 = Color3.fromRGB(255,100,100)
            if err == "request

-- End Of Script
