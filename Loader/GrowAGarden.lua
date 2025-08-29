-- STREE HUB - Loader & UI Final (Fixed)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Parent GUI
local success, result = pcall(function()
    return game:GetService("CoreGui")
end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

-- ====== UTIL: DRAGGABLE ======
local function MakeDraggable(frame:Frame, dragHandle: GuiObject?)
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
            if dragging then
                update(input)
            end
        end
    end)
end

-- ====== STYLE HELPERS ======
local function corner(parent, r)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function stroke(parent, color, th)
    local s = Instance.new("UIStroke", parent)
    s.Color = color or Color3.fromRGB(0, 255, 0)
    s.Thickness = th or 2
    s.Transparency = 0.15
    return s
end

-- ====== KEY LIST ======
local validKeys = {
    "STREEHUB-INDONESIA-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM",
    "StreeCommunity-7g81ht7NO22"
}
local function isKeyValid(keyInput)
    for _, key in ipairs(validKeys) do
        if keyInput == key then
            return true
        end
    end
    return false
end

-- ====== Key Links UI ======
local function buildKeyLinksUI()
    if parentGui:FindFirstChild("STREE_KeyLinksUI") then
        parentGui.STREE_KeyLinksUI:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "STREE_KeyLinksUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = parentGui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 380, 0, 260)
    frame.Position = UDim2.new(0.5, -190, 0.5, -130)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.BorderSizePixel = 0
    corner(frame,12)
    stroke(frame,Color3.fromRGB(0,255,0), 3)

    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, -20, 0, 40)
    titleBar.Position = UDim2.new(0, 10, 0, 8)
    titleBar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -40, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.Text = "Key Links"

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        if not parentGui:FindFirstChild("STREE_KeyUI") then
            buildKeyUI()
        end
    end)

    local list = Instance.new("Frame", frame)
    list.Size = UDim2.new(1, -20, 1, -60)
    list.Position = UDim2.new(0, 10, 0, 50)
    list.BackgroundTransparency = 1

    local uiList = Instance.new("UIListLayout", list)
    uiList.Padding = UDim.new(0, 8)
    uiList.FillDirection = Enum.FillDirection.Vertical
    uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function createLinkCard(name, link, imageId)
        local card = Instance.new("TextButton")
        card.AutoButtonColor = true
        card.Text = name
        card.Size = UDim2.new(1, 0, 0, 60)
        card.BackgroundColor3 = Color3.fromRGB(30,30,30)
        card.TextColor3 = Color3.fromRGB(0,255,120)
        card.Font = Enum.Font.GothamBold
        card.TextSize = 16
        corner(card, 10)
        stroke(card, Color3.fromRGB(0,255,120), 1.5)
        card.Parent = list

        card.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(link)
            end
        end)
    end

    createLinkCard("Rekonise",    "https://rkns.link/2vbo0",                   "rbxassetid://140280617864380")
    createLinkCard("Linkvertise","https://link-hub.net/1365203/NqhrZrvoQhoi", "rbxassetid://113798183844310")
    createLinkCard("Lootlabs",   "https://lootdest.org/s?VooVvLbJ",            "rbxassetid://112846309972303")

    MakeDraggable(frame, titleBar)
end

-- ====== Main UI ======
local function buildMainUI()
    if parentGui:FindFirstChild("STREE_HUB_UI") then parentGui.STREE_HUB_UI:Destroy() end

    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false

    -- Toggle logo
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0, 44, 0, 44)
    logoButton.Position = UDim2.new(0, 120, 0.8, 0)
    logoButton.Image = "rbxassetid://123032091977400"
    logoButton.BackgroundTransparency = 1
    MakeDraggable(logoButton, logoButton)

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

    local headerLogo = Instance.new("ImageLabel", titleBar)
    headerLogo.Size = UDim2.new(0, 30, 0, 30)
    headerLogo.Position = UDim2.new(0,5,0,6)
    headerLogo.Image = "rbxassetid://123032091977400"
    headerLogo.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "STREE HUB | Grow A Garden | v0.00.01"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0,40,0,0)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0,255,100)
    title.BackgroundTransparency = 1

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 34, 0, 30)
    closeBtn.Position = UDim2.new(1,-36,0,6)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)

    local minimizeBtn = Instance.new("TextButton", titleBar)
    minimizeBtn.Size = UDim2.new(0, 34, 0, 30)
    minimizeBtn.Position = UDim2.new(1,-72,0,6)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255,255,80)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 16
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.MouseButton1Click:Connect(function() window.Visible = false end)

    logoButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
    end)

    -- Tab kanan
    local tabMenu = Instance.new("Frame", window)
    tabMenu.Size = UDim2.new(0,140,1,-60)
    tabMenu.Position = UDim2.new(1,-150,0,52)
    tabMenu.BackgroundColor3 = Color3.fromRGB(40,40,40)
    corner(tabMenu, 10)
    stroke(tabMenu, Color3.fromRGB(0,255,120), 1)

    -- Konten (ScrollingFrame supaya CanvasSize berfungsi)
    local contentFrame = Instance.new("ScrollingFrame", window)
    contentFrame.Size = UDim2.new(1,-180,1,-70)
    contentFrame.Position = UDim2.new(0,15,0,55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.CanvasSize = UDim2.new(0,0,0,0)
    contentFrame.ScrollBarThickness = 6
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.None

    local function clearContent()
        for _,v in pairs(contentFrame:GetChildren()) do
            if v:IsA("GuiObject") then v:Destroy() end
        end
    end

    local yOffset = 0
    local function nextY(h) local y=yOffset; yOffset=yOffset+h+8; return y end
    local function resetYOffset() yOffset=0 end
    local function refreshCanvas() contentFrame.CanvasSize = UDim2.new(0,0,yOffset,0) end

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
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(36,36,36)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
        end)
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
        switch.Size = UDim2.new(0, 56, 0, 24)
        switch.Position = UDim2.new(1, -66, 0.5, -12)
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60)
        corner(switch, 12)

        local knob = Instance.new("Frame", switch)
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 2, 0.5, -10)
        knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
        corner(knob, 10)
        stroke(knob, Color3.fromRGB(0,0,0), 1)

        local state = default and true or false
        local function apply(animated)
            local bg = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60,60,60)
            local x = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            if animated then
                TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = bg}):Play()
                TweenService:Create(knob, TweenInfo.new(0.15), {Position = x}):Play()
            else
                switch.BackgroundColor3 = bg
                knob.Position = x
            end
        end
        apply(false)

        local function toggle()
            state = not state
            apply(true)
            if callback then
                task.spawn(function()
                    pcall(callback, state)
                end)
            end
        end

        switch.MouseButton1Click:Connect(toggle)
        row.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
        end)
    end

    local function createSlider(text, min, max, default, callback)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,50)
        row.Position = UDim2.new(0,10,0,nextY(50))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)
        corner(row, 8)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, -10, 0, 20)
        lbl.Position = UDim2.new(0,10,0,5)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = text

        local valueLbl = Instance.new("TextLabel", row)
        valueLbl.Size = UDim2.new(0.3, -10, 0, 20)
        valueLbl.Position = UDim2.new(1, -110, 0, 5)
        valueLbl.BackgroundTransparency = 1
        valueLbl.TextXAlignment = Enum.TextXAlignment.Right
        valueLbl.Font = Enum.Font.Gotham
        valueLbl.TextSize = 14
        valueLbl.TextColor3 = Color3.fromRGB(0,255,120)
        valueLbl.Text = tostring(default)

        local sliderBG = Instance.new("Frame", row)
        sliderBG.Size = UDim2.new(1,-20,0,8)
        sliderBG.Position = UDim2.new(0,10,1,-18)
        sliderBG.BackgroundColor3 = Color3.fromRGB(60,60,60)
        corner(sliderBG, 4)

        local sliderFill = Instance.new("Frame", sliderBG)
        sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0,200,0)
        corner(sliderFill, 4)

        local dragging = false
        local function update(inputPos)
            local relative = math.clamp((inputPos.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
            local value = math.floor((min + (max-min) * relative) * 10)/10
            sliderFill.Size = UDim2.new(relative,0,1,0)
            valueLbl.Text = tostring(value)
            if callback then pcall(callback, value) end
        end
        sliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input.Position)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        sliderBG.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                update(input.Position)
            end
        end)
    end

    local lastTabY = 0
    local firstTabCallback -- simpan callback Home untuk auto-open
    local function createTab(name, callback)
        local btn = Instance.new("TextButton", tabMenu)
        btn.Size = UDim2.new(1,-12,0,32)
        btn.Position = UDim2.new(0,6,0,lastTabY+6)
        lastTabY = lastTabY + 38
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(0,255,120)
        corner(btn, 8)
        btn.MouseButton1Click:Connect(function()
            clearContent()
            resetYOffset()
            callback()
            refreshCanvas()
        end)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
        end)
        if not firstTabCallback then firstTabCallback = callback end
    end

    -- ===== Tabs =====
    createTab("Home", function()
        createLabel("Information")

        createButton("Discord", function()
            if setclipboard then setclipboard("https://discord.gg/jdmX43t5mY") end
        end)
        createButton("WhatsApp", function()
            if setclipboard then setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N") end
        end)
        createButton("Telegram", function()
            if setclipboard then setclipboard("https://t.me/StreeCoumminty") end
        end)
        createButton("Website", function()
            if setclipboard then setclipboard("https://streehub.netlify.app") end
        end)

        createLabel("⚙️ Utility")    
    
        createToggleModern("Auto sell", false, 
        function(on)
            _G.AutoSell = on
            if on then
                loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Auto%20sell.lua"))()
            end
        end)
    
        createToggleModern("Auto Plant & Harvest", false, function(on)    
            if on then    
                pcall(function()    
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Auto%20plant%20%26%20Auto%20Harvest.lua"))()    
                end)    
            end    
        end)    
    
        createToggleModern("Auto watering", false, function(on)    
            if on then    
                pcall(function()    
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Auto%20Watering.lua"))()    
                end)    
            end    
        end)    

        createLabel("Players")

        -- WalkSpeed input
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,40)
        row.Position = UDim2.new(0,10,0,nextY(40))
        row.BackgroundTransparency = 1

        local walkLabel = Instance.new("TextLabel", row)
        walkLabel.Size = UDim2.new(0.5,0,1,0)
        walkLabel.TextXAlignment = Enum.TextXAlignment.Left
        walkLabel.BackgroundTransparency = 1
        walkLabel.TextColor3 = Color3.fromRGB(200,200,200)
        walkLabel.Text = "WalkSpeed: 16"
        walkLabel.Font = Enum.Font.Gotham
        walkLabel.TextSize = 14

        local walkBox = Instance.new("TextBox", row)
        walkBox.Size = UDim2.new(0.3,0,0.7,0)
        walkBox.Position = UDim2.new(0.65,0,0.15,0)
        walkBox.PlaceholderText = "16"
        walkBox.BackgroundColor3 = Color3.fromRGB(36,36,36)
        walkBox.TextColor3 = Color3.fromRGB(255,255,255)
        walkBox.Font = Enum.Font.Gotham
        walkBox.TextSize = 14
        corner(walkBox, 6)

        walkBox.FocusLost:Connect(function()
            local val = tonumber(walkBox.Text)
            if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
                walkLabel.Text = "WalkSpeed: "..val
            end
        end)
    end)

    createTab("Visual", function()
        createLabel("Coming soon: ESP, Highlight, dll.")
    end)

    createTab("Credits", function()
        createLabel("Created by: STREE Community")
        createLabel("STREE HUB | create-stree")
        createLabel("Thank you for using our script 😄")
        createLabel("This UI still has shortcomings [Beta]")
    end)

    -- Buka tab pertama (Home)
    if firstTabCallback then firstTabCallback() end

    MakeDraggable(window, titleBar)
end

-- ====== Key UI ======
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

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.Size = UDim2.new(0.47,-6,0,32)
    submitBtn.Position = UDim2.new(0,10,0,130)
    submitBtn.Text = "Submit"
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 16
    submitBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    submitBtn.TextColor3 = Color3.fromRGB(0,0,0)
    corner(submitBtn, 8)

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

    submitBtn.MouseButton1Click:Connect(function()
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
