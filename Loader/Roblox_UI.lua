-- STREE HUB (Key system + Main UI)
-- Key verification via HTTP POST (no loadstring). Main UI is created only after key is valid.

-- ======= Services =======
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ======= Config =======
local VERIFY_URL = "https://rkns.link/qss3x" -- endpoint verifikasi (ubah jika perlu)
local REKONISE_URL = VERIFY_URL -- link yang akan dibuka / disalin oleh tombol Rekonise

-- ======= Helper: verifyKey via HTTPS POST =======
local function verifyKey(keyInput)
    if not keyInput or tostring(keyInput):match("^%s*$") then
        return false, "empty"
    end

    local ok, resp = pcall(function()
        return HttpService:PostAsync(VERIFY_URL, HttpService:JSONEncode({ key = keyInput }), Enum.HttpContentType.ApplicationJson)
    end)
    if not ok then
        return false, "request_error"
    end

    local suc, decoded = pcall(function() return HttpService:JSONDecode(resp) end)
    if not suc then
        return false, "invalid_response"
    end

    -- Accept both { status = "valid" } or plain "valid" string
    if type(decoded) == "table" and decoded.status and tostring(decoded.status):lower() == "valid" then
        return true
    elseif type(decoded) == "string" and tostring(decoded):lower():find("valid") then
        return true
    end

    return false, "invalid_key"
end

-- ======= Build Main UI (created only after key valid) =======
local function buildMainUI(parent)
    local ui = Instance.new("ScreenGui")
    ui.Name = "STREE_HUB_UI"
    ui.ResetOnSpawn = false
    ui.Parent = parent

    -- notif
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "UI berhasil dimuat!",
            Icon = "rbxassetid://123032091977400",
            Duration = 3
        })
    end)

    -- Logo button (restore)
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0, 48, 0, 48)
    logoButton.Position = UDim2.new(0, 12, 0, 12) -- sesuai permintaan: dekat chat kiri atas
    logoButton.Image = "rbxassetid://123032091977400"
    logoButton.BackgroundTransparency = 1
    logoButton.ZIndex = 2
    logoButton.Visible = false -- akan disembunyikan ketika window muncul

    -- Main window
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    window.BackgroundTransparency = 0.25
    window.BorderSizePixel = 0
    window.Active = true
    window.Draggable = true
    window.Visible = true

    -- neon border
    local border = Instance.new("UIStroke", window)
    border.Thickness = 3
    border.Color = Color3.fromRGB(0, 255, 0)
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.LineJoinMode = Enum.LineJoinMode.Round

    Instance.new("UICorner", window).CornerRadius = UDim.new(0, 12)

    -- Title bar
    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)

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

    -- Content + Sidebar
    local contentFrame = Instance.new("Frame", window)
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -160, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1

    local sidebar = Instance.new("Frame", window)
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, -60)
    sidebar.Position = UDim2.new(1, -150, 0, 50)
    sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

    local sideBlur = Instance.new("ImageLabel", sidebar)
    sideBlur.Size = UDim2.new(1, 0, 1, 0)
    sideBlur.Position = UDim2.new(0, 0, 0, 0)
    sideBlur.BackgroundTransparency = 1
    sideBlur.Image = "rbxassetid://5553946656"
    sideBlur.ImageTransparency = 0.45
    sideBlur.ScaleType = Enum.ScaleType.Stretch
    sideBlur.ZIndex = 0

    -- Tabs
    local tabs = { "Home", "Game", "Macro", "Webhook", "Settings", "Credits" }
    local tabFrames = {}
    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1, -12, 0, 34)
        btn.Position = UDim2.new(0, 6, 0, 6 + (i-1)*40)
        btn.Text = tabName
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        btn.TextColor3 = Color3.fromRGB(0, 255, 140)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

        local f = Instance.new("Frame", contentFrame)
        f.Name = tabName .. "Frame"
        f.Size = UDim2.new(1, 0, 1, 0)
        f.Position = UDim2.new(0, 0, 0, 0)
        f.BackgroundTransparency = 1
        f.Visible = false
        tabFrames[tabName] = f

        btn.MouseButton1Click:Connect(function()
            for _, v in pairs(tabFrames) do v.Visible = false end
            f.Visible = true
        end)
    end
    tabFrames["Home"].Visible = true

    -- Small helpers to add controls to tabs
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
        b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
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

    -- Populate Home
    do
        local home = tabFrames["Home"]
        local y = 8
        createLabel(home, "Welcome to STREE HUB!", y); y = y + 28
        createButton(home, "Load Script (example)", y, function() warn("Load Script clicked") end); y = y + 36
        createToggle(home, "Auto Execute", y, function(state) warn("Auto execute:", state) end); y = y + 36
        createButton(home, "Enable Shiftlock", y, function() pcall(function() Players.LocalPlayer.DevEnableMouseLock = true end) end); y = y + 36
    end

    do
        local c = tabFrames["Credits"]
        createLabel(c, "Create : STREE Community", 8)
        createLabel(c, "STREE HUB | create-stree", 36)
    end

    -- Minimize / Close / Logo behavior
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)
    minBtn.MouseButton1Click:Connect(function()
        window.Visible = false
        logoButton.Visible = true
    end)
    logoButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
        if window.Visible then logoButton.Visible = false end
    end)

    -- allow dragging the logo to reposition the whole window
    do
        local dragging, dragInput, dragStart, startPos
        local function update(input)
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        logoButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = window.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        logoButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then update(input) end
        end)
    end

    return {
        ScreenGui = ui;
        Window = window;
        Logo = logoButton;
    }
end

-- ======= Build Key UI (shown first) =======
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
    local stroke = Instance.new("UIStroke", frame); stroke.Color = Color3.fromRGB(0,255,0); stroke.Thickness = 3

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
    getBtn.Size = UDim2.new(0, 160, 0, 30)
    getBtn.Position = UDim2.new(0, 10, 0, 126)
    getBtn.Text = "Rekonise"
    getBtn.Font = Enum.Font.GothamBold
    getBtn.TextSize = 16
    getBtn.BackgroundColor3 = Color3.fromRGB(60,120,255)
    getBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0,6)

    local verifyBtn = Instance.new("TextButton", frame)
    verifyBtn.Size = UDim2.new(0, 160, 0, 30)
    verifyBtn.Position = UDim2.new(0, 170, 0, 126)
    verifyBtn.Text = "Verify"
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 16
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    verifyBtn.TextColor3 = Color3.fromRGB(0,0,0)
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0,6)

    -- Rekonise: try to open browser, else copy link to clipboard
    getBtn.MouseButton1Click:Connect(function()
        local okOpen = pcall(function()
            StarterGui:SetCore("OpenBrowserWindow", REKONISE_URL)
        end)
        if okOpen then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Membuka link Rekonise..."
            return
        end
        -- fallback: copy to clipboard (may not work in all executors)
        local okCopy = pcall(function() setclipboard(REKONISE_URL) end)
        if okCopy then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Link disalin ke clipboard."
        else
            status.TextColor3 = Color3.fromRGB(255,100,100)
            status.Text = "Gagal membuka/copy link."
        end
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        local key = tostring(input.Text or "")
        if key:match("^%s*$") then
            status.TextColor3 = Color3.fromRGB(255,100,100)
            status.Text = "Key tidak boleh kosong!"
            return
        end
        status.TextColor3 = Color3.fromRGB(200,200,200)
        status.Text = "Memverifikasi..."
        -- verify
        local ok, err = verifyKey(key)
        if ok then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Key valid! Memuat UI..."
            wait(0.6)
            keyGui:Destroy()
            if onSuccess then pcall(onSuccess) end
        else
            status.TextColor3 = Color3.fromRGB(255,100,100)
            if err == "request_error" then
                status.Text = "Error koneksi. Cek HTTP & endpoint."
            elseif err == "invalid_response" then
                status.Text = "Response server tidak valid."
            elseif err == "empty" then
                status.Text = "Key kosong."
            else
                status.Text = "Key salah!"
            end
        end
    end)
end

-- ======= Start: show key UI first, then create main UI on success =======
buildKeyUI(PlayerGui, function()
    local builtMain = buildMainUI(PlayerGui)
    -- main UI already visible by buildMainUI
    -- ensure logo is hidden
    pcall(function() builtMain.Logo.Visible = false end)
    print("Main UI dimuat setelah verifikasi key.")
end)p
