-- MAIN UI
local function buildMainUI()

    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false

    -- Logo Toggle (pojok kiri atas)
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0, 44, 0, 44)
    logoButton.Position = UDim2.new(0, 12, 0, 90)
    logoButton.BackgroundTransparency = 1
    setImageSmart(logoButton, HUB_LOGO_ID)
    MakeDraggable(logoButton, logoButton)

    -- Window Utama
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 680, 0, 420)
    window.Position = UDim2.new(0.5, -340, 0.5, -210)
    window.BackgroundColor3 = Color3.fromRGB(22,22,22)
    window.BorderSizePixel = 0
    corner(window, 16)
    local gl = stroke(window, Color3.fromRGB(0,255,120), 2, 0.1)
    animateBorderGlow(gl)

    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1, -20, 0, 50)
    titleBar.Position = UDim2.new(0, 10, 0, 8)
    titleBar.BackgroundTransparency = 1

    local headerLogo = Instance.new("ImageLabel", titleBar)
    headerLogo.Size = UDim2.new(0, 34, 0, 34)
    headerLogo.Position = UDim2.new(0, 4, 0, 8)
    headerLogo.BackgroundTransparency = 1
    setImageSmart(headerLogo, HUB_LOGO_ID)

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "STREE | Grow A Garden | v0.00.01"
    title.Size = UDim2.new(1, -140, 1, 0)
    title.Position = UDim2.new(0, 46, 0, 0)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0,255,120)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 34, 0, 30)
    closeBtn.Position = UDim2.new(1, -36, 0, 10)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)

    local minimizeBtn = Instance.new("TextButton", titleBar)
    minimizeBtn.Size = UDim2.new(0, 34, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -72, 0, 10)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255,255,80)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 16
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.MouseButton1Click:Connect(function() window.Visible = false end)

    logoButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
    end)

    -- Content area
    local contentFrame = Instance.new("Frame", window)
    contentFrame.Size = UDim2.new(1, -200, 1, -110)
    contentFrame.Position = UDim2.new(0, 16, 0, 96)
    contentFrame.BackgroundColor3 = Color3.fromRGB(26,26,26)
    corner(contentFrame, 12)
    stroke(contentFrame, Color3.fromRGB(0,255,120), 1, 0.6)

    -- Layout helpers
    local yOffset = 0
    local function nextY(h) local y=yOffset; yOffset=yOffset+h+8; return y end
    local function resetY() yOffset = 0 end
    local function clearContent()
        for _,v in ipairs(contentFrame:GetChildren()) do if v:IsA("GuiObject") then v:Destroy() end end
        resetY()
    end

    local function section(txt)
        local l = Instance.new("TextLabel", contentFrame)
        l.Size = UDim2.new(1, -20, 0, 24)
        l.Position = UDim2.new(0, 10, 0, nextY(24))
        l.Text = txt
        l.Font = Enum.Font.GothamBold
        l.TextSize = 16
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextColor3 = Color3.fromRGB(0,255,140)
        l.BackgroundTransparency = 1
    end
    local function label(txt)
        local l = Instance.new("TextLabel", contentFrame)
        l.Size = UDim2.new(1, -20, 0, 20)
        l.Position = UDim2.new(0, 10, 0, nextY(20))
        l.Text = txt
        l.Font = Enum.Font.Gotham
        l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextColor3 = Color3.fromRGB(210,210,210)
        l.BackgroundTransparency = 1
    end
    local function button(txt, cb)
        local b = Instance.new("TextButton", contentFrame)
        b.Size = UDim2.new(1, -20, 0, 36)
        b.Position = UDim2.new(0, 10, 0, nextY(36))
        b.Text = txt
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.BackgroundColor3 = Color3.fromRGB(32,32,32)
        b.TextColor3 = Color3.fromRGB(0,255,120)
        corner(b, 10)
        stroke(b, Color3.fromRGB(0,255,120), 1, 0.6)
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(32,32,32)}):Play() end)
        b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    end
    local function slider(text, min, max, default, cb)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1, -20, 0, 44)
        row.Position = UDim2.new(0, 10, 0, nextY(44))
        row.BackgroundColor3 = Color3.fromRGB(30,30,30); corner(row, 10)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -160, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = ("%s: %d"):format(text, default or min)

        local bar = Instance.new("Frame", row)
        bar.Size = UDim2.new(0, 140, 0, 6)
        bar.Position = UDim2.new(1, -150, 0.5, -3)
        bar.BackgroundColor3 = Color3.fromRGB(55,55,55); corner(bar,3)

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new(0,0,1,0)
        fill.BackgroundColor3 = Color3.fromRGB(0,200,100); corner(fill,3)

        local val = default or min
        local function apply()
            local a = (val - min) / (max - min)
            fill.Size = UDim2.new(a, 0, 1, 0)
            lbl.Text = ("%s: %d"):format(text, math.floor(val))
        end
        apply()

        local dragging=false
        bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end end)
        bar.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
        bar.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local rel = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                rel = math.clamp(rel,0,1)
                val = min + rel*(max-min)
                apply(); if cb then pcall(cb, math.floor(val)) end
            end
        end)
    end
    local function toggleModern(text, flag, default, cb)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1, -20, 0, 40)
        row.Position = UDim2.new(0, 10, 0, nextY(40))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28); corner(row,10)

                local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -90, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = text

        local switch = Instance.new("TextButton", row)
        switch.AutoButtonColor = false
        switch.Text = ""
        switch.Size = UDim2.new(0, 56, 0, 24)
        switch.Position = UDim2.new(1, -66, 0.5, -12)
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60); corner(switch,12)

        local knob = Instance.new("Frame", switch)
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 2, 0.5, -10)
        knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
        corner(knob, 10); stroke(knob, Color3.fromRGB(0,0,0), 1, 0.6)

        local state = getFlag(flag, default and true or false)
        local function apply(animated)
            setFlag(flag, state)
            local bg = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60,60,60)
            local x = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            if animated then
                TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = bg}):Play()
                TweenService:Create(knob, TweenInfo.new(0.15), {Position = x}):Play()
            else
                switch.BackgroundColor3 = bg; knob.Position = x
            end
        end
        apply(false)

        local function toggle()
            state = not state
            apply(true)
            if cb then task.spawn(function() pcall(cb, state) end) end
        end
        switch.MouseButton1Click:Connect(toggle)
        row.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then toggle() end end)
    end
