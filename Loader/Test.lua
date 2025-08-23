-- STREE HUB - Loader & UI Final
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- PARENT GUI
local success, result = pcall(function() return game:GetService("CoreGui") end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

--  HELPERS (UI STYLE)
local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(0,255,120)
    s.Thickness = th or 2
    s.Transparency = tr or 0.15
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

-- Neon border anim sederhana (opsional)
local function animateBorderGlow(uiStroke)
    if not uiStroke then return end
    task.spawn(function()
        local t = 0
        while uiStroke.Parent and uiStroke.Parent.Parent do
            t += task.wait()
            local g = 160 + math.floor(95 * math.abs(math.sin(t*1.5)))
            uiStroke.Color = Color3.fromRGB(0, g, 100)
        end
    end)
end

-- DRAGGABLE (semua window)
local function MakeDraggable(frame: Frame, dragHandle: GuiObject?)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- IMAGE HELPER
-- Pakai ID "rbxassetid://<angka>" untuk Asset/Texture ID.
-- Kalau sebelumnya pakai ID halaman (Decal page), gambar bisa tidak muncul.
local function setImageSmart(imageObj: ImageLabel | ImageButton, idStr: string)
    if not imageObj then return end
    if typeof(idStr) == "string" then
        if idStr:match("^rbxassetid://%d+$") or idStr:match("^rbxthumb://") then
            imageObj.Image = idStr
        elseif idStr:match("^%d+$") then
            imageObj.Image = "rbxassetid://"..idStr
        else
            -- fallback kosong
            imageObj.Image = "rbxassetid://0"
        end
    elseif typeof(idStr) == "number" then
        imageObj.Image = "rbxassetid://"..tostring(idStr)
    else
        imageObj.Image = "rbxassetid://0"
    end
end

-- GLOBAL FLAGS & CONFIG
_G.STREE_FLAGS = _G.STREE_FLAGS or {}
local function setFlag(name, val) _G.STREE_FLAGS[name] = val end
local function getFlag(name, def) local v = _G.STREE_FLAGS[name]; if v == nil then return def end; return v end

local CONFIG_NAME = "streehub_config.json"

local function saveConfig()
    local cfg = {
        flags = _G.STREE_FLAGS or {},
        version = "v0.00.01",
        savedAt = os.time()
    }
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, cfg)
    if not ok then return false, "encode_fail" end

    if writefile then
        local ok2, err = pcall(writefile, CONFIG_NAME, encoded)
        if ok2 then
            return true
        else
            return false, tostring(err)
        end
    else
        -- environment tanpa writefile, fallback: copy ke clipboard
        if setclipboard then
            setclipboard(encoded)
            return true, "clipboard"
        end
        return false, "no_write_permission"
    end
end

local function loadConfig()
    if isfile and isfile(CONFIG_NAME) and readfile then
        local ok, data = pcall(readfile, CONFIG_NAME)
        if ok and data then
            local ok2, parsed = pcall(HttpService.JSONDecode, HttpService, data)
            if ok2 and typeof(parsed) == "table" and parsed.flags then
                _G.STREE_FLAGS = parsed.flags
                return true
            end
        end
        return false, "read_fail"
    end
    return false, "no_config"
end

-- KEY SYSTEM
local validKeys = {
    "STREEHUB-2025-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM",
    "StreeCommunity-7g81ht7NO22"
}
local function isKeyValid(keyInput)
    for _, key in ipairs(validKeys) do
        if keyInput == key then return true end
    end
    return false
end

-- ICONS (GANTI JIKA PERLU)
-- Kalau gambar belum muncul, kemungkinan besar ID yang kamu punya adalah ID halaman (Decal Page).
-- Ganti menjadi TEXTURE ID dan tetap format "rbxassetid://<angka>".
local LINK_ICONS = {
    Rekonise   = "rbxassetid://140280617864380", -- ganti ke TextureID jika belum tampil
    Linkvertise= "rbxassetid://113798183844310",
    Lootlabs   = "rbxassetid://112846309972303",
}
local HUB_LOGO_ID = "rbxassetid://123032091977400" -- logo utama (pojok kiri atas & header)

-- UI BUILDERS
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
    frame.Name = "KeyLinksWindow"
    frame.Size = UDim2.new(0, 400, 0, 280)
    frame.Position = UDim2.new(0.5, -200, 0.5, -140)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.BorderSizePixel = 0
    corner(frame, 14)
    local glow = stroke(frame, Color3.fromRGB(0,255,120), 3, 0.08)
    animateBorderGlow(glow)

    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, -20, 0, 42)
    titleBar.Position = UDim2.new(0, 10, 0, 8)
    titleBar.BackgroundTransparency = 1

    local titleIcon = Instance.new("ImageLabel", titleBar)
    titleIcon.Size = UDim2.new(0, 28, 0, 28)
    titleIcon.Position = UDim2.new(0, 2, 0, 7)
    titleIcon.BackgroundTransparency = 1
    setImageSmart(titleIcon, HUB_LOGO_ID)

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 36, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,120)
    title.Text = "Key Links"

    local backBtn = Instance.new("TextButton", titleBar)
    backBtn.Size = UDim2.new(0, 80, 0, 30)
    backBtn.Position = UDim2.new(1, -118, 0, 6)
    backBtn.Text = "Back"
    backBtn.Font = Enum.Font.GothamBold
    backBtn.TextSize = 14
    backBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    backBtn.TextColor3 = Color3.fromRGB(255,255,255)
    corner(backBtn, 8)
    backBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        if not parentGui:FindFirstChild("STREE_KeyUI") then
            buildKeyUI()
        end
    end)

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 6)
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
    list.Position = UDim2.new(0, 10, 0, 54)
    list.BackgroundTransparency = 1

    local uiList = Instance.new("UIListLayout", list)
    uiList.Padding = UDim.new(0, 10)
    uiList.FillDirection = Enum.FillDirection.Vertical
    uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function makeCard(name, link, imageId)
        local card = Instance.new("TextButton")
        card.AutoButtonColor = true
        card.Text = ""
        card.Size = UDim2.new(1, 0, 0, 64)
        card.BackgroundColor3 = Color3.fromRGB(30,30,30)
        corner(card, 10)
        stroke(card, Color3.fromRGB(0,255,120), 1.5)
        card.Parent = list

        local icon = Instance.new("ImageLabel", card)
        icon.Size = UDim2.new(0, 44, 0, 44)
        icon.Position = UDim2.new(0, 10, 0.5, -22)
        icon.BackgroundTransparency = 1
        setImageSmart(icon, imageId)

        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(1, -80, 0, 24)
        lbl.Position = UDim2.new(0, 64, 0, 8)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Text = name

        local note = Instance.new("TextLabel", card)
        note.Size = UDim2.new(1, -80, 0, 18)
        note.Position = UDim2.new(0, 64, 0, 34)
        note.BackgroundTransparency = 1
        note.TextXAlignment = Enum.TextXAlignment.Left
        note.Font = Enum.Font.Gotham
        note.TextSize = 13
        note.TextColor3 = Color3.fromRGB(180,180,180)
        note.Text = "Klik untuk copy link"

        card.MouseEnter:Connect(function()
            TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(36,36,36)}):Play()
        end)
        card.MouseLeave:Connect(function()
            TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
        end)
        card.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(link) end
            note.Text = "Copied!"
            TweenService:Create(note, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(0,255,120)}):Play()
            task.delay(1.2, function()
                note.Text = "Klik untuk copy link"
                note.TextColor3 = Color3.fromRGB(180,180,180)
            end)
        end)
    end

    makeCard("Rekonise",    "https://rkns.link/2vbo0",                         LINK_ICONS.Rekonise)
    makeCard("Linkvertise", "https://link-hub.net/1365203/NqhrZrvoQhoi",       LINK_ICONS.Linkvertise)
    makeCard("Lootlabs",    "https://lootdest.org/s?VooVvLbJ",                 LINK_ICONS.Lootlabs)

    MakeDraggable(frame, titleBar)
end

local function buildMainUI()
    if parentGui:FindFirstChild("STREE_HUB_UI") then parentGui.STREE_HUB_UI:Destroy() end

    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.IgnoreGuiInset = true
    ui.ResetOnSpawn = false

    -- Logo Toggle (pojok kiri atas, bisa drag)
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0, 44, 0, 44)
    logoButton.Position = UDim2.new(0, 12, 0, 90) -- dekat kiri atas chat
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

    -- Header (judul + tombol)
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
    closeBtn.MouseButton1Click:Connect(function()
        ui:Destroy()
    end)

    local minimizeBtn = Instance.new("TextButton", titleBar)
    minimizeBtn.Size = UDim2.new(0, 34, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -72, 0, 10)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255,255,80)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 16
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.MouseButton1Click:Connect(function()
        window.Visible = false
    end)

    logoButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
    end)

    -- Search Bar (kanan atas konten)
    local searchBox = Instance.new("TextBox", window)
    searchBox.PlaceholderText = "Search..."
    searchBox.Size = UDim2.new(0, 220, 0, 32)
    searchBox.Position = UDim2.new(1, -240, 0, 58)
    searchBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
    searchBox.TextColor3 = Color3.fromRGB(255,255,255)
    searchBox.ClearTextOnFocus = false
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    corner(searchBox, 8)
    stroke(searchBox, Color3.fromRGB(0,255,120), 1, 0.5)

    -- Sidebar Tab (kanan)
    local tabMenu = Instance.new("Frame", window)
    tabMenu.Size = UDim2.new(0, 160, 1, -90)
    tabMenu.Position = UDim2.new(1, -170, 0, 96)
    tabMenu.BackgroundColor3 = Color3.fromRGB(36,36,36)
    corner(tabMenu, 12)
    stroke(tabMenu, Color3.fromRGB(0,255,120), 1, 0.4)

    -- Content
    local contentFrame = Instance.new("Frame", window)
    contentFrame.Size = UDim2.new(1, -200, 1, -110)
    contentFrame.Position = UDim2.new(0, 16, 0, 96)
    contentFrame.BackgroundColor3 = Color3.fromRGB(26,26,26)
    corner(contentFrame, 12)
    stroke(contentFrame, Color3.fromRGB(0,255,120), 1, 0.6)

    -- Layout helpers
    local yOffset = 0
    local function nextY(height) local y=yOffset; yOffset=yOffset+height+8; return y end
    local function resetYOffset() yOffset = 0 end

    local function clearContent()
        for _,v in ipairs(contentFrame:GetChildren()) do
            if v:IsA("GuiObject") then v:Destroy() end
        end
        resetYOffset()
    end

    local function section(titleText)
        local lbl = Instance.new("TextLabel", contentFrame)
        lbl.Size = UDim2.new(1, -20, 0, 24)
        lbl.Position = UDim2.new(0, 10, 0, nextY(24))
        lbl.Text = titleText
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextColor3 = Color3.fromRGB(0,255,140)
        lbl.BackgroundTransparency = 1
    end

    local function label(text)
        local lbl = Instance.new("TextLabel", contentFrame)
        lbl.Size = UDim2.new(1, -20, 0, 20)
        lbl.Position = UDim2.new(0, 10, 0, nextY(20))
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextColor3 = Color3.fromRGB(210,210,210)
        lbl.BackgroundTransparency = 1
    end

    local function button(text, callback)
        local btn = Instance.new("TextButton", contentFrame)
        btn.Size = UDim2.new(1, -20, 0, 36)
        btn.Position = UDim2.new(0, 10, 0, nextY(36))
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
        btn.TextColor3 = Color3.fromRGB(0,255,120)
        corner(btn, 10)
        stroke(btn, Color3.fromRGB(0,255,120), 1, 0.6)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(32,32,32)}):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            if callback then pcall(callback) end
        end)
    end

    local function slider(text, min, max, default, callback)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1, -20, 0, 44)
        row.Position = UDim2.new(0, 10, 0, nextY(44))
        row.BackgroundColor3 = Color3.fromRGB(30,30,30)
        corner(row, 10)

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
        bar.BackgroundColor3 = Color3.fromRGB(55,55,55)
        corner(bar, 3)

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0,200,100)
        corner(fill, 3)

        local val = default or min
        local function apply()
            local alpha = (val - min) / (max - min)
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            lbl.Text = ("%s: %d"):format(text, math.floor(val))
        end
        apply()

        local dragging = false
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        bar.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                rel = math.clamp(rel, 0, 1)
                val = min + rel * (max - min)
                apply()
                if callback then pcall(callback, math.floor(val)) end
            end
        end)
    end

    local function toggleModern(text, flagName, default, callback)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1, -20, 0, 40)
        row.Position = UDim2.new(0, 10, 0, nextY(40))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)
        corner(row, 10)

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
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60)
        corner(switch, 12)

        local knob = Instance.new("Frame", switch)
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 2, 0.5, -10)
        knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
        corner(knob, 10)
        stroke(knob, Color3.fromRGB(0,0,0), 1, 0.6)

        local state = getFlag(flagName, default and true or false)
        local function apply(animated)
            setFlag(flagName, state)
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
            if callback then task.spawn(function() pcall(callback, state) end) end
        end

        switch.MouseButton1Click:Connect(toggle)
        row.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggle()
            end
        end)
    end

    -- ====== TAB BUILDER ======
    addTab("Home", function()
        section("⚙️ Utilities")
        toggleModern("Night Mode", "NightMode", false, function(on)
            pcall(function()
                Lighting.TimeOfDay = on and "00:00:00" or "14:00:00"
                Lighting.Brightness = on and 1 or 2
            end)
        end)
        toggleModern("Shift Lock", "ShiftLock", false, function(on)
            pcall(function() LocalPlayer.DevEnableMouseLock = on end)
        end)
        slider("WalkSpeed", 16, 150, 16, function(v)
            pcall(function()
                local c = LocalPlayer.Character
                if c and c:FindFirstChildOfClass("Humanoid") then
                    c:FindFirstChildOfClass("Humanoid").WalkSpeed = v
                end
            end)
        end)
        slider("JumpPower", 50, 200, 50, function(v)
            pcall(function()
                local c = LocalPlayer.Character
                if c and c:FindFirstChildOfClass("Humanoid") then
                    c:FindFirstChildOfClass("Humanoid").JumpPower = v
                end
            end)
        end)

        section("💾 Config")
        button("Save Config", function()
            local ok, why = saveConfig()
            if ok then
                title.Text = "STREE | Grow A Garden | v0.00.01  (Config Saved)"
                task.delay(1.2, function() title.Text = "STREE | Grow A Garden | v0.00.01" end)
            else
                title.Text = "Save Failed: "..tostring(why or "")
                task.delay(1.6, function() title.Text = "STREE | Grow A Garden | v0.00.01" end)
            end
        end)
        button("Load Config", function()
            local ok, why = loadConfig()
            if ok then
                -- apply flags ke UI: buka ulang tab utk render ulang status toggle
                title.Text = "Config Loaded"
                task.delay(1.2, function() title.Text = "STREE | Grow A Garden | v0.00.01" end)
            else
                title.Text = "Load Failed: "..tostring(why or "")
                task.delay(1.6, function() title.Text = "STREE | Grow A Garden | v0.00.01" end)
            end
        end)
    end)

    -- ====== TAB: Game ======
    addTab("Game", function()
        section("🎮 Gameplay")
        toggleModern("Infinite Jump", "InfiniteJump", false, function(on)
            if on then
                if _G.__STREE_IJ_CONN then _G.__STREE_IJ_CONN:Disconnect() end
                _G.__STREE_IJ_CONN = UserInputService.JumpRequest:Connect(function()
                    local c = LocalPlayer.Character
                    if c and c:FindFirstChildOfClass("Humanoid") then
                        c:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            else
                if _G.__STREE_IJ_CONN then _G.__STREE_IJ_CONN:Disconnect(); _G.__STREE_IJ_CONN = nil end
            end
        end)
        toggleModern("NoClip", "NoClip", false, function(on)
            if on then
                if _G.__STREE_NC_CONN then _G.__STREE_NC_CONN:Disconnect() end
                _G.__STREE_NC_CONN = game:GetService("RunService").Stepped:Connect(function()
                    local c = LocalPlayer.Character
                    if c then
                        for _,v in ipairs(c:GetDescendants()) do
                            if v:IsA("BasePart") and v.CanCollide then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if _G.__STREE_NC_CONN then _G.__STREE_NC_CONN:Disconnect(); _G.__STREE_NC_CONN=nil end
                local c = LocalPlayer.Character
                if c then
                    for _,v in ipairs(c:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = true end
                    end
                end
            end
        end)
        toggleModern("Anti AFK", "AntiAFK", true, function(on)
            if on then
                if _G.__STREE_AAFK then _G.__STREE_AAFK:Disconnect() end
                local vu = game:GetService("VirtualUser")
                _G.__STREE_AAFK = LocalPlayer.Idled:Connect(function()
                    pcall(function()
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new())
                    end)
                end)
            else
                if _G.__STREE_AAFK then _G.__STREE_AAFK:Disconnect(); _G.__STREE_AAFK = nil end
            end
        end)
    end)

    -- ====== TAB: Macro ======
    addTab("Macro", function()
        section("🌀 Simple Macro")
        label("Auto Jump (tiap 1.5s) & Auto Move (W)")
        toggleModern("Auto Jump", "AutoJump", false, function(on)
            if on then
                if _G.__STREE_AJ_LOOP then _G.__STREE_AJ_LOOP:Disconnect() end
                _G.__STREE_AJ_LOOP = game:GetService("RunService").Heartbeat:Connect(function(step)
                    if tick() % 1.5 < step then
                        pcall(function()
                            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                        end)
                    end
                end)
            else
                if _G.__STREE_AJ_LOOP then _G.__STREE_AJ_LOOP:Disconnect(); _G.__STREE_AJ_LOOP=nil end
            end
        end)
        toggleModern("Auto Move Forward", "AutoMoveW", false, function(on)
            if on then
                if _G.__STREE_AM_LOOP then _G.__STREE_AM_LOOP:Disconnect() end
                _G.__STREE_AM_LOOP = game:GetService("RunService").RenderStepped:Connect(function()
                    pcall(function()
                        LocalPlayer.Character:TranslateBy(Vector3.new(0,0,-0.1))
                    end)
                end)
            else
                if _G.__STREE_AM_LOOP then _G.__STREE_AM_LOOP:Disconnect(); _G.__STREE_AM_LOOP=nil end
            end
        end)
    end)

    -- ====== TAB: Webhook ======
    addTab("Webhook", function()
        section("🔗 Discord Webhook")
        label("Masukkan URL webhook (belum mengirim data beneran, hanya mock).")

        local box = Instance.new("TextBox", contentFrame)
        box.Size = UDim2.new(1, -20, 0, 36)
        box.Position = UDim2.new(0, 10, 0, nextY(36))
        box.PlaceholderText = "https://discord.com/api/webhooks/...."
        box.BackgroundColor3 = Color3.fromRGB(32,32,32)
        box.TextColor3 = Color3.fromRGB(255,255,255)
        box.ClearTextOnFocus = false
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        corner(box, 8)
        stroke(box, Color3.fromRGB(0,255,120), 1, 0.6)

        button("Test Send (Mock)", function()
            if setclipboard then setclipboard("MOCK_SEND::"..box.Text) end
            title.Text = "Webhook mocked to clipboard"
            task.delay(1.2, function() title.Text = "STREE | Grow A Garden | v0.00.01" end)
        end)
    end)

    -- ====== TAB: Settings ======
    addTab("Settings", function()
        section("🎨 UI")
        toggleModern("Compact Mode", "CompactMode", false, function(on)
            local scale = window:FindFirstChild("UIScale") or Instance.new("UIScale", window)
            scale.Scale = on and 0.9 or 1
        end)
        toggleModern("Glow Border", "Glow", true, function(on)
            if gl then gl.Enabled = on end
        end)

        section("🧰 System")
        button("Rebuild UI", function()
            buildMainUI()
        end)
        button("Open Key Links", function()
            buildKeyLinksUI()
        end)
    end)

    -- ====== TAB: Credits ======
    addTab("Credits", function()
        section("👑 Credits")
        label("Created by: STREE Community")
        label("STREE HUB | create-stree")
        label("Thanks for using STREE HUB!")
        button("Join Discord (Copy)", function()
            if setclipboard then setclipboard("https://discord.gg/jdmX43t5mY") end
            title.Text = "Discord link copied!"
            task.delay(1.2, function() title.Text = "STREE | Grow A Garden | v0.00.01" end)
        end)
    end)

    -- Default buka Home
    for _,b in ipairs(tabMenu:GetChildren()) do
        if b:IsA("TextButton") then b:Activate(); break end
    end

    -- Draggable
    MakeDraggable(window, titleBar)
end

function buildKeyUI()
    if parentGui:FindFirstChild("STREE_KeyUI") then parentGui.STREE_KeyUI:Destroy() end

    local keyGui = Instance.new("ScreenGui", parentGui)
    keyGui.Name = "STREE_KeyUI"
    keyGui.IgnoreGuiInset = true
    keyGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 360, 0, 250)
    frame.Position = UDim2.new(0.5, -180, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.BorderSizePixel = 0
    corner(frame, 14)
    local gl = stroke(frame, Color3.fromRGB(0,255,120), 3, 0.08)
    animateBorderGlow(gl)

    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, -20, 0, 40)
    titleBar.Position = UDim2.new(0, 10, 0, 8)
    titleBar.BackgroundTransparency = 1

    local titleIcon = Instance.new("ImageLabel", titleBar)
    titleIcon.Size = UDim2.new(0, 28, 0, 28)
    titleIcon.Position = UDim2.new(0, 2, 0, 6)
    titleIcon.BackgroundTransparency = 1
    setImageSmart(titleIcon, HUB_LOGO_ID)

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 36, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,120)
    title.Text = "🔑 | Key System"

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1, -20, 0, 40)
    input.Position = UDim2.new(0, 10, 0, 56)
    input.PlaceholderText = "Enter key..."
    input.BackgroundColor3 = Color3.fromRGB(36,36,36)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.ClearTextOnFocus = false
    input.Font = Enum.Font.Gotham
    input.TextSize = 16
    corner(input, 10)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1, -20, 0, 18)
    status.Position = UDim2.new(0, 10, 0, 104)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Text = ""

    local enterBtn = Instance.new("TextButton", frame)
    enterBtn.Size = UDim2.new(0.47, -6, 0, 34)
    enterBtn.Position = UDim2.new(0, 10, 0, 132)
    enterBtn.Text = "Enter"
    enterBtn.Font = Enum.Font.GothamBold
    enterBtn.TextSize = 16
    enterBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    enterBtn.TextColor3 = Color3.fromRGB(0,0,0)
    corner(enterBtn, 10)

    local discordBtn = Instance.new("TextButton", frame)
    discordBtn.Size = UDim2.new(0.47, -6, 0, 34)
    discordBtn.Position = UDim2.new(0, 190, 0, 132)
    discordBtn.Text = "Join Discord"
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 16
    discordBtn.BackgroundColor3 = Color3.fromRGB(60,60,255)
    discordBtn.TextColor3 = Color3.fromRGB(255,255,255)
    corner(discordBtn, 10)
    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard("https://discord.gg/jdmX43t5mY") end
        status.TextColor3 = Color3.fromRGB(0,255,120)
        status.Text = "Discord link copied!"
    end)

    local linkBtn = Instance.new("TextButton", frame)
    linkBtn.Size = UDim2.new(1, -20, 0, 34)
    linkBtn.Position = UDim2.new(0, 10, 0, 172)
    linkBtn.Text = "Get Key"
    linkBtn.Font = Enum.Font.GothamBold
    linkBtn.TextSize = 16
    linkBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    linkBtn.TextColor3 = Color3.fromRGB(255,255,255)
    corner(linkBtn, 10)
    linkBtn.MouseButton1Click:Connect(function()
        keyGui:Destroy()
        buildKeyLinksUI()
    end)

    local tip = Instance.new("TextLabel", frame)
    tip.Size = UDim2.new(1, -20, 0, 18)
    tip.Position = UDim2.new(0, 10, 0, 210)
    tip.BackgroundTransparency = 1
    tip.Font = Enum.Font.Gotham
    tip.TextSize = 12
    tip.TextColor3 = Color3.fromRGB(160,160,160)
    tip.Text = "Note: Pastikan pakai Texture ID untuk logo link."

    enterBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if isKeyValid(key) then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Key Valid!"
            task.wait(0.35)
            keyGui:Destroy()
            buildMainUI()
        else
            status.TextColor3 = Color3.fromRGB(255,0,0)
            status.Text = "Key Invalid!"
            local orig = input.Position
            TweenService:Create(input, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 3, true), {Position = orig + UDim2.new(0, 3, 0, 0)}):Play()
        end
-- START
buildKeyUI()
