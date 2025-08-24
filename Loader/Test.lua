-- STREE HUB - Loader & UI Final
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Parent GUI
local success, result = pcall(function() return game:GetService("CoreGui") end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

-- ====== UTIL: DRAGGABLE (untuk semua window) ======
local function MakeDraggable(frame: Frame, dragHandle: GuiObject?)
    dragHandle = dragHandle or frame
    local dragging, dragStart, startPos = false
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
local function corner(parent, r) local c=Instance.new("UICorner", parent); c.CornerRadius = UDim.new(0, r or 8) return c end
local function stroke(parent, color, th, tr)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or Color3.fromRGB(0,255,0)
    s.Thickness = th or 2
    s.Transparency = tr or 0.15
    return s
end

-- Flag storage
local Flags = {}
local function getFlag(k, default) if Flags[k]==nil then Flags[k]=default end return Flags[k] end
local function setFlag(k,v) Flags[k]=v end

-- ====== VALID KEYS ======
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
    if parentGui:FindFirstChild("STREE_HUB_UI") then parentGui.STREE_HUB_UI:Destroy() end
    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.IgnoreGuiInset, ui.ResetOnSpawn = true, false

    -- Window
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 560, 0, 360)
    window.Position = UDim2.new(0.5, -280, 0.5, -180)
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)
    window.BorderSizePixel = 0
    corner(window, 14)
    stroke(window, Color3.fromRGB(0,255,0), 2)

    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1, -20, 0, 42)
    titleBar.Position = UDim2.new(0, 10, 0, 8)
    titleBar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "STREE HUB"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0,40,0,0)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0,255,100)
    title.BackgroundTransparency = 1

    -- Close
    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 34, 0, 30)
    closeBtn.Position = UDim2.new(1,-36,0,6)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)

    -- Tab menu
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

    local yOffset = 0
    local function nextY(h) local y=yOffset; yOffset=yOffset+h+8; return y end
    local function resetY() yOffset=0 end
    local function clearContent() for _,v in ipairs(contentFrame:GetChildren()) do if v:IsA("GuiObject") then v:Destroy() end end resetY() end

    -- Widgets
    local function section(txt)
        local l = Instance.new("TextLabel", contentFrame)
        l.Size = UDim2.new(1,-20,0,24)
        l.Position = UDim2.new(0,10,0,nextY(24))
        l.Text = txt; l.Font = Enum.Font.GothamBold; l.TextSize = 16
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextColor3 = Color3.fromRGB(0,255,140)
        l.BackgroundTransparency = 1
    end
    local function label(txt)
        local l = Instance.new("TextLabel", contentFrame)
        l.Size = UDim2.new(1,-20,0,20)
        l.Position = UDim2.new(0,10,0,nextY(20))
        l.Text = txt; l.Font = Enum.Font.Gotham; l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextColor3 = Color3.fromRGB(210,210,210)
        l.BackgroundTransparency = 1
    end
    local function button(txt, cb)
        local b = Instance.new("TextButton", contentFrame)
        b.Size = UDim2.new(1,-20,0,36)
        b.Position = UDim2.new(0,10,0,nextY(36))
        b.Text = txt; b.Font = Enum.Font.GothamBold; b.TextSize = 14
        b.BackgroundColor3 = Color3.fromRGB(32,32,32)
        b.TextColor3 = Color3.fromRGB(0,255,120)
        corner(b, 10); stroke(b, Color3.fromRGB(0,255,120), 1, 0.6)
        b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    end
    local function slider(text,min,max,default,cb)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,44)
        row.Position = UDim2.new(0,10,0,nextY(44))
        row.BackgroundColor3 = Color3.fromRGB(30,30,30); corner(row,10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1,-160,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        local val = default or min
        lbl.Text = ("%s: %d"):format(text,val)
        local bar = Instance.new("Frame", row)
        bar.Size = UDim2.new(0,140,0,6)
        bar.Position = UDim2.new(1,-150,0.5,-3)
        bar.BackgroundColor3 = Color3.fromRGB(55,55,55); corner(bar,3)
        local fill = Instance.new("Frame", bar)
        fill.BackgroundColor3 = Color3.fromRGB(0,200,100); corner(fill,3)
        local function apply()
            local a = (val-min)/(max-min)
            fill.Size = UDim2.new(a,0,1,0)
            lbl.Text = ("%s: %d"):format(text,math.floor(val))
        end
        apply()
        local dragging=false
        bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
        bar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        bar.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local rel=(i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
                rel=math.clamp(rel,0,1)
                val=min+rel*(max-min); apply(); if cb then pcall(cb,math.floor(val)) end
            end
        end)
    end
    local function toggleModern(text, flag, default, cb)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,40)
        row.Position = UDim2.new(0,10,0,nextY(40))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28); corner(row,10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1,-90,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = text
        local switch = Instance.new("TextButton", row)
        switch.Size = UDim2.new(0,56,0,24)
        switch.Position = UDim2.new(1,-66,0.5,-12)
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60); corner(switch,12)
        local knob = Instance.new("Frame", switch)
        knob.Size = UDim2.new(0,20,0,20)
        knob.Position = UDim2.new(0,2,0.5,-10)
        knob.BackgroundColor3 = Color3.fromRGB(245,245,245); corner(knob,10)
        local state = getFlag(flag,default)
        local function apply(animated)
            setFlag(flag,state)
            local bg = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(60,60,60)
            local x = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
            if animated then
                TweenService:Create(switch,TweenInfo.new(0.15),{BackgroundColor3=bg}):Play()
                TweenService:Create(knob,TweenInfo.new(0.15),{Position=x}):Play()
            else switch.BackgroundColor3=bg; knob.Position=x end
        end
        apply(false)
        switch.MouseButton1Click:Connect(function()
            state=not state; apply(true); if cb then pcall(cb,state) end
        end)
    end

    -- Tab System
    local function createTab(name, onSelect)
        local b = Instance.new("TextButton", tabMenu)
        b.Size = UDim2.new(1,-20,0,30)
        b.Position = UDim2.new(0,10,0,#tabMenu:GetChildren()*35)
        b.Text = name
        b.Font = Enum.Font.GothamBold; b.TextSize = 14
        b.BackgroundColor3 = Color3.fromRGB(32,32,32)
        b.TextColor3 = Color3.fromRGB(200,200,200)
        corner(b,6)
        b.MouseButton1Click:Connect(function()
            clearContent(); if onSelect then onSelect() end
        end)
    end

    -- Tabs isi
    createTab("Home", function()
        section("⚙️ Utilities")
        toggleModern("Night Mode","night",false,function(on)
            pcall(function() game.Lighting.TimeOfDay = on and "00:00:00" or "14:00:00" end)
        end)
        toggleModern("Shiftlock","shiftlock",false,function(on)
            LocalPlayer.DevEnableMouseLock = on
        end)
        slider("WalkSpeed",10,100,16,function(val)
            pcall(function()
                LocalPlayer.Character.Humanoid.WalkSpeed = val
            end)
        end)
    end)
    createTab("Credits", function()
        section("👥 Credits")
        label("Created by: STREE Community")
        label("STREE HUB | create-stree")
        lanel("Thank you for using our script😄")
    end)

    -- Silinder dekorasi
    local deco = Instance.new("Frame", window)
    deco.Size = UDim2.new(0,40,1,0)
    deco.Position = UDim2.new(0, -50, 0, 0)
    deco.BackgroundColor3 = Color3.fromRGB(0,255,0)
    deco.BackgroundTransparency = 0.4
    corner(deco,20)
    local grad = Instance.new("UIGradient",deco)
    grad.Rotation = 90
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(0,150,0)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(0,150,0))
    }

    MakeDraggable(window,titleBar)
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
    frame.BorderSizePixel = 0
    corner(frame, 12)
    stroke(frame, Color3.fromRGB(0,255,0), 3)

    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1,-20,0,36)
    titleBar.Position = UDim2.new(0,10,0,8)
    titleBar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.Text = "🔑 | Key System"

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1,-20,0,40)
    input.Position = UDim2.new(0,10,0,56)
    input.PlaceholderText = "Enter key..."
    input.BackgroundColor3 = Color3.fromRGB(36,36,36)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.ClearTextOnFocus = false
    input.Font = Enum.Font.Gotham
    input.TextSize = 16
    corner(input, 8)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1,-20,0,18)
    status.Position = UDim2.new(0,10,0,104)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Text = ""

    local enterBtn = Instance.new("", frame)
    enterBtn.Size = UDim2.new(0.47,-6,0,32)
    enterBtn.Position = UDim2.new(0,10,0,130)
    enterBtn.Text = "Enter"
    enterBtn.Font = Enum.Font.GothamBold
    enterBtn.TextSize = 16
    enterBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    enterBtn.TextColor3 = Color3.fromRGB(0,0,0)
    corner(enterBtn, 8)

    local discordBtn = Instance.new("TextButton", frame)
    discordBtn.Size = UDim2.new(0.47,-6,0,32)
    discordBtn.Position = UDim2.new(0,180,0,130)
    discordBtn.Text = "Join Discord"
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 16
    discordBtn.BackgroundColor3 = Color3.fromRGB(60,60,255)
    discordBtn.TextColor3 = Color3.fromRGB(255,255,255)
    corner(discordBtn, 8)
    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard("https://discord.gg/jdmX43t5mY") end
        status.TextColor3 = Color3.fromRGB(0,255,120)
        status.Text = "Discord link copied!"
    end)

    local linkBtn = Instance.new("TextButton", frame)
    linkBtn.Size = UDim2.new(1,-20,0,32)
    linkBtn.Position = UDim2.new(0,10,0,170)
    linkBtn.Text = "Get Key"
    linkBtn.Font = Enum.Font.GothamBold
    linkBtn.TextSize = 16
    linkBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    linkBtn.TextColor3 = Color3.fromRGB(255,255,255)
    corner(linkBtn, 8)
    linkBtn.MouseButton1Click:Connect(function()
        keyGui:Destroy()
        buildKeyLinksUI()
    end)

    enterBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if isKeyValid(key) then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Key Valid!"
            task.wait(0.45)
            keyGui:Destroy()
            buildMainUI()
        else
            status.TextColor3 = Color3.fromRGB(255,0,0)
            status.Text = "Key Invalid!"
            TweenService:Create(input, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 3, true), {Position = input.Position + UDim2.new(0,3,0,0)}):Play()
        end
    end)

    MakeDraggable(frame, titleBar)
end

-- START
buildKeyUI()
