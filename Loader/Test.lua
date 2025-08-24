-- STREE HUB - Loader & UI Final
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

-- Parent GUI
local success, result = pcall(function() return game:GetService("CoreGui") end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

-- ====== UTIL: DRAGGABLE ======
local function MakeDraggable(frame: Frame, dragHandle: GuiObject?)
    dragHandle = dragHandle or frame
    local dragging, dragStart, startPos = false, nil, nil

    local function update(input)
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
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then update(input) end
        end
    end)
end

-- ====== STYLE HELPERS ======
local function corner(parent, r) local c=Instance.new("UICorner", parent); c.CornerRadius=UDim.new(0, r or 8) return c end
local function stroke(parent, color, th)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or Color3.fromRGB(0,255,0)
    s.Thickness = th or 2
    s.Transparency = 0.15
    return s
end

-- Valid Keys
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

-- ====== Build Main UI ======
local function buildMainUI()
    if parentGui:FindFirstChild("STREE_HUB_UI") then parentGui.STREE_HUB_UI:Destroy() end
    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false

    -- Logo Toggle
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Size = UDim2.new(0,44,0,44)
    logoButton.Position = UDim2.new(0, 120, 0.8, 0)
    logoButton.Image = "rbxassetid://123032091977400"
    logoButton.BackgroundTransparency = 1
    MakeDraggable(logoButton, logoButton)

    -- Window
    local window = Instance.new("Frame", ui)
    window.Size = UDim2.new(0, 560, 0, 360)
    window.Position = UDim2.new(0.5, -280, 0.5, -180)
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)
    corner(window, 14)
    stroke(window, Color3.fromRGB(0,255,0), 2)

    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1,-20,0,42)
    titleBar.Position = UDim2.new(0,10,0,8)
    titleBar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "STREE HUB"
    title.Size = UDim2.new(1,-120,1,0)
    title.Position = UDim2.new(0,40,0,0)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0,255,100)
    title.BackgroundTransparency = 1

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0,34,0,30)
    closeBtn.Position = UDim2.new(1,-36,0,6)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)

    local minimizeBtn = Instance.new("TextButton", titleBar)
    minimizeBtn.Size = UDim2.new(0,34,0,30)
    minimizeBtn.Position = UDim2.new(1,-72,0,6)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255,255,80)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.MouseButton1Click:Connect(function() window.Visible = false end)

    logoButton.MouseButton1Click:Connect(function() window.Visible = not window.Visible end)

    -- Tab Menu
    local tabMenu = Instance.new("Frame", window)
    tabMenu.Size = UDim2.new(0,140,1,-60)
    tabMenu.Position = UDim2.new(1,-150,0,52)
    tabMenu.BackgroundColor3 = Color3.fromRGB(40,40,40)
    corner(tabMenu, 10)
    stroke(tabMenu, Color3.fromRGB(0,255,120), 1)

    -- Konten
    local contentFrame = Instance.new("Frame", window)
    contentFrame.Size = UDim2.new(1,-180,1,-70)
    contentFrame.Position = UDim2.new(0,15,0,55)
    contentFrame.BackgroundTransparency = 1

    local function clearContent() for _,v in pairs(contentFrame:GetChildren()) do if v:IsA("GuiObject") then v:Destroy() end end end
    local yOffset = 0
    local function nextY(h) local y=yOffset; yOffset=yOffset+h+8; return y end
    local function resetYOffset() yOffset=0 end

    -- Components
    local function createLabel(text)
        local lbl = Instance.new("TextLabel", contentFrame)
        lbl.Size = UDim2.new(1,-20,0,24)
        lbl.Position = UDim2.new(0,10,0,nextY(24))
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
    end
    local function createButton(text, callback)
        local btn = Instance.new("TextButton", contentFrame)
        btn.Size = UDim2.new(1,-20,0,34)
        btn.Position = UDim2.new(0,10,0,nextY(34))
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.TextColor3 = Color3.fromRGB(0,255,120)
        corner(btn, 8)
        btn.MouseButton1Click:Connect(callback)
    end
    local function createToggleModern(text, default, callback)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,38)
        row.Position = UDim2.new(0,10,0,nextY(38))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)
        corner(row, 8)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1,-90,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = text

        local switch = Instance.new("TextButton", row)
        switch.AutoButtonColor = false
        switch.Text = ""
        switch.Size = UDim2.new(0,56,0,24)
        switch.Position = UDim2.new(1,-66,0.5,-12)
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60)
        corner(switch, 12)

        local knob = Instance.new("Frame", switch)
        knob.Size = UDim2.new(0,20,0,20)
        knob.Position = UDim2.new(0,2,0.5,-10)
        knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
        corner(knob, 10)

        local state = default
        local function apply(animated)
            local bg = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(60,60,60)
            local x = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
            if animated then
                TweenService:Create(switch,TweenInfo.new(0.15),{BackgroundColor3=bg}):Play()
                TweenService:Create(knob,TweenInfo.new(0.15),{Position=x}):Play()
            else
                switch.BackgroundColor3=bg; knob.Position=x
            end
        end
        apply(false)

        switch.MouseButton1Click:Connect(function()
            state = not state
            apply(true)
            if callback then pcall(callback,state) end
        end)
    end

    -- ===== Tabs =====
    local lastTabY = 0
    local function createTab(name, callback)
        local btn = Instance.new("TextButton", tabMenu)
        btn.Size = UDim2.new(1,-12,0,32)
        btn.Position = UDim2.new(0,6,0,lastTabY+6)
        lastTabY = lastTabY+38
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(0,255,120)
        corner(btn, 8)
        btn.MouseButton1Click:Connect(function()
            clearContent(); resetYOffset(); callback()
        end)
    end

    -- Tab Scripts (pakai silinder/section)
    createTab("Scripts", function()
        createLabel("🚀 WalkSpeed Hack")
        createToggleModern("Enable WalkSpeed", false, function(on)
            if Humanoid then
                Humanoid.WalkSpeed = on and 50 or 16
            end
        end)
        createButton("Load External Script", function()
            loadstring(game:HttpGet("https://pastebin.com/raw/YOUR_PASTE_ID"))()
        end)
    end)

    -- Tab Home
    createTab("Home", function()
        createLabel("⚙️ Utilities")
        createToggleModern("Night Mode", false, function(on)
            game.Lighting.TimeOfDay = on and "00:00:00" or "14:00:00"
        end)
    end)

    -- Tab Credits
    createTab("Credits", function()
        createLabel("Created by: STREE Community")
    end)

    MakeDraggable(window, titleBar)
end

-- ====== Build Key UI utama ======
function buildKeyUI()
    if parentGui:FindFirstChild("STREE_KeyUI") then parentGui.STREE_KeyUI:Destroy() end
    local keyGui = Instance.new("ScreenGui", parentGui)
    keyGui.Name = "STREE_KeyUI"
    keyGui.IgnoreGuiInset = true
    keyGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0,340,0,230)
    frame.Position = UDim2.new(0.5,-170,0.5,-115)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    corner(frame, 12)
    stroke(frame, Color3.fromRGB(0,255,0), 3)

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1,-20,0,40)
    input.Position = UDim2.new(0,10,0,56)
    input.PlaceholderText = "Enter key..."
    input.BackgroundColor3 = Color3.fromRGB(36,36,36)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    corner(input, 8)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1,-20,0,18)
    status.Position = UDim2.new(0,10,0,104)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Text = ""

    local enterBtn = Instance.new("TextButton", frame)
    enterBtn.Size = UDim2.new(0.47,-6,0,32)
    enterBtn.Position = UDim2.new(0,10,0,130)
    enterBtn.Text = "Enter"
    enterBtn.Font = Enum.Font.GothamBold
    enterBtn.TextSize = 16
    enterBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    corner(enterBtn, 8)
    enterBtn.MouseButton1Click:Connect(function()
        if isKeyValid(input.Text) then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Key Valid!"
            task.wait(0.5)
            keyGui:Destroy()
            buildMainUI()
        else
            status.TextColor3 = Color3.fromRGB(255,0,0)
            status.Text = "Key Invalid!"
        end
    end)

    MakeDraggable(frame, frame)
end

-- START
buildKeyUI()
