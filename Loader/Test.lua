-- STREE HUB - Loader & UI Final (FIXED)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Parent GUI (Fix supaya tidak error di executor low-UNC)
local parentGui = (function()
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:WaitForChild("PlayerGui")
end)()

-- ====== UTIL: DRAGGABLE (Tetap sama) ======
local function MakeDraggable(frame:Frame, dragHandle: GuiObject?)
    dragHandle = dragHandle or frame
    local dragging, dragStart, startPos = false, nil, nil

    local function update(input)
        if not (dragStart and startPos) then return end
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            update(input)
        end
    end)
end

-- ====== STYLE HELPERS (Tetap sama) ======
local function corner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function stroke(parent, color, th)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or Color3.fromRGB(0,255,0)
    s.Thickness = th or 2
    s.Transparency = 0.25
    return s
end

-- ====== SAFE LOADER (Fix 429 + warn handling) ======
local function safeLoad(url)
    task.wait(0.2)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not ok then warn("[STREE HUB] Load Error:", err) end
    return ok
end

-- ====== KEY LIST (Tetap sama) ======
local validKeys = {
    "STREEHUB-INDONESIA-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM",
    "StreeCommunity-7g81ht7NO22"
}
local function isKeyValid(keyInput)
    for _, key in ipairs(validKeys) do
        if keyInput == key then return true end
    end
    return false
end

-- ====== MAIN UI ======
local function buildMainUI()
    if parentGui:FindFirstChild("STREE_HUB_UI") then
        parentGui.STREE_HUB_UI:Destroy()
    end

    local ui = Instance.new("ScreenGui")
    ui.Name = "STREE_HUB_UI"
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false
    ui.Parent = parentGui

    -- Toggle logo
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0,44,0,44)
    logoButton.Position = UDim2.new(0,120,0.8,0)
    logoButton.Image = "rbxassetid://123032091977400"
    logoButton.BackgroundTransparency = 1
    MakeDraggable(logoButton, logoButton)

    -- Window utama
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0,560,0,360)
    window.Position = UDim2.new(0.5,-280,0.5,-180)
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)
    window.BorderSizePixel = 0
    corner(window,14)
    stroke(window,Color3.fromRGB(0,255,0),2)

    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1,-20,0,42)
    titleBar.Position = UDim2.new(0,10,0,8)
    titleBar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1,-120,1,0)
    title.Position = UDim2.new(0,40,0,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(0,255,100)
    title.Text = "STREE HUB | Grow A Garden | v0.00.03"

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0,34,0,30)
    closeBtn.Position = UDim2.new(1,-36,0,6)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Text = "X"
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)

    local minimizeBtn = Instance.new("TextButton", titleBar)
    minimizeBtn.Size = UDim2.new(0,34,0,30)
    minimizeBtn.Position = UDim2.new(1,-72,0,6)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 16
    minimizeBtn.TextColor3 = Color3.fromRGB(255,255,80)
    minimizeBtn.Text = "-"
    minimizeBtn.MouseButton1Click:Connect(function() window.Visible = false end)

    logoButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
    end)

    -- TAB MENU KANAN
    local tabMenu = Instance.new("Frame", window)
    tabMenu.Size = UDim2.new(0,140,1,-60)
    tabMenu.Position = UDim2.new(1,-150,0,52)
    tabMenu.BackgroundColor3 = Color3.fromRGB(40,40,40)
    corner(tabMenu,10)
    stroke(tabMenu,Color3.fromRGB(0,255,120),1)

    -- CONTENT FRAME (Fix CanvasSize)
    local contentFrame = Instance.new("ScrollingFrame", window)
    contentFrame.Size = UDim2.new(1,-180,1,-70)
    contentFrame.Position = UDim2.new(0,15,0,55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.CanvasSize = UDim2.new(0,0,0,0)

    local yOffset = 0
    local function nextY(h) local y=yOffset; yOffset=yOffset+h+8; return y end
    local function resetYOffset() yOffset=0 end
    local function refreshCanvas() contentFrame.CanvasSize = UDim2.new(0,0,0,yOffset) end

    local function createLabel(text)
        local lbl = Instance.new("TextLabel", contentFrame)
        lbl.Size = UDim2.new(1,-20,0,24)
        lbl.Position = UDim2.new(0,10,0,nextY(24))
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = text
    end

    local function createButton(text, cb)
        local btn = Instance.new("TextButton", contentFrame)
        btn.Size = UDim2.new(1,-20,0,34)
        btn.Position = UDim2.new(0,10,0,nextY(34))
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Text = text
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.TextColor3 = Color3.fromRGB(0,255,120)
        corner(btn,8)

        btn.MouseButton1Click:Connect(cb)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.15}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
        end)
    end

    local function createToggleModern(text, default, cb)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,38)
        row.Position = UDim2.new(0,10,0,nextY(38))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)
        corner(row,8)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1,-90,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = text

        local switch = Instance.new("TextButton", row)
        switch.Size = UDim2.new(0,56,0,24)
        switch.Position = UDim2.new(1,-66,0.5,-12)
        switch.Text = ""
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60)
        corner(switch,12)

        local knob = Instance.new("Frame", switch)
        knob.Size = UDim2.new(0,20,0,20)
        knob.Position = UDim2.new(0,2,0.5,-10)
        knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
        corner(knob,10)
        stroke(knob,Color3.fromRGB(0,0,0),1)

        local state = default
        local function apply(anim)
            local bg = state and 0 or 60
            local pos = state and 1 or 2
            if anim then
                TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundTransparency = state and 0 or 0}):Play()
                TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)}):Play()
            else
                switch.BackgroundTransparency = 0
                knob.Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
            end
            if cb then task.spawn(function() pcall(cb,state) end) end
        end
        apply(false)

        switch.MouseButton1Click:Connect(function()
            state = not state
            apply(true)
        end)
    end

    -- HOME CONTENT
    createLabel("Information")
    createButton("Copy Discord", function()
        if setclipboard then setclipboard("https://discord.gg/jdmX43t5mY") end
    end)

    refreshCanvas()
    MakeDraggable(window, titleBar)
end

-- ====== KEY UI ======
local function buildKeyUI()
    if parentGui:FindFirstChild("STREE_KeyUI") then parentGui.STREE_KeyUI:Destroy() end

    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "STREE_KeyUI"
    keyGui.IgnoreGuiInset = true
    keyGui.ResetOnSpawn = false
    keyGui.Parent = parentGui

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0,340,0,230)
    frame.Position = UDim2.new(0.5,-170,0.5,-115)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.BorderSizePixel = 0
    corner(frame,12)
    stroke(frame,Color3.fromRGB(0,255,0),3)

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1,-20,0,40)
    input.Position = UDim2.new(0,10,0,56)
    input.PlaceholderText = "Enter key..."
    input.BackgroundColor3 = Color3.fromRGB(36,36,36)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 16
    corner(input,8)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1,-20,0,18)
    status.Position = UDim2.new(0,10,0,104)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Text = ""

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.Size = UDim2.new(1,-20,0,32)
    submitBtn.Position = UDim2.new(0,10,0,130)
    submitBtn.Text = "Submit"
    submitBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    submitBtn.TextColor3 = Color3.fromRGB(0,0,0)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 16
    corner(submitBtn,8)

    submitBtn.MouseButton1Click:Connect(function()
        if isKeyValid(input.Text) then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Key Valid!"
            task.wait(0.4)
            keyGui:Destroy()
            buildMainUI()
        else
            status.TextColor3 = Color3.fromRGB(255,0,0)
            status.Text = "Key Invalid!"
            TweenService:Create(input, TweenInfo.new(0.08,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut,3,true), {
                Position = input.Position + UDim2.new(0,6,0,0)
            }):Play()
        end
    end)

    MakeDraggable(frame)
end

-- START
buildKeyUI()
