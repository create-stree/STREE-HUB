-- STREE HUB - Loader & UI Final
repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Parent GUI
local success, result = pcall(function() return game:GetService("CoreGui") end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

-- Daftar key valid
local validKeys = {
    "STREEHUB-2025-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM",
    "StreeCommunity-7g81ht7NO22"
}

-- Fungsi cek key
local function isKeyValid(keyInput)
    for _, key in ipairs(validKeys) do
        if keyInput == key then return true end
    end
    return false
end

-- Build Key Links UI
local function buildKeyLinksUI()
    if parentGui:FindFirstChild("STREE_KeyLinksUI") then
        parentGui.STREE_KeyLinksUI:Destroy()
    end

    local gui = Instance.new("ScreenGui", parentGui)
    gui.Name = "STREE_KeyLinksUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 360, 0, 240)
    frame.Position = UDim2.new(0.5, -180, 0.5, -120)
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
    title.Text = "Key Links"

    -- Close button
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 8)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        buildKeyUI() -- Return to key system UI
    end)

    local yOffset = 50
    local function createLinkButton(name, link, imageId)
        local btn = Instance.new("ImageButton", frame)
        btn.Size = UDim2.new(0, 320, 0, 50)
        btn.Position = UDim2.new(0, 20, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.Image = imageId
        btn.ScaleType = Enum.ScaleType.Fit
        btn.AutoButtonColor = true
        btn.Name = name
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, -10, 1, -10)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.Text = name
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.BackgroundTransparency = 1

        btn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(link)
            end
        end)

        yOffset = yOffset + 60
    end

    createLinkButton("Rekonise", "https://rkns.link/2vbo0", "rbxassetid://140280617864380")
    createLinkButton("Linkvertise", "https://link-hub.net/1365203/NqhrZrvoQhoi", "rbxassetid://113798183844310")
    createLinkButton("Lootlabs", "https://lootdest.org/s?VooVvLbJ", "rbxassetid://112846309972303")
end

-- Build Main UI
local function buildMainUI()
    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.ResetOnSpawn = false

    -- Logo STREE HUB
    local logoButton = Instance.new("ImageButton", ui)
    logoButton.Name = "HubIcon"
    logoButton.Size = UDim2.new(0, 40, 0, 40)
    logoButton.Position = UDim2.new(0, 120, 0.8, 0)
    logoButton.Image = "rbxassetid://123032091977400"
    logoButton.BackgroundTransparency = 1
    logoButton.Active = true
    logoButton.Draggable = true

    -- Window Utama
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 500, 0, 320)
    window.Position = UDim2.new(0.5, -250, 0.5, -160)
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)
    window.BackgroundTransparency = 0.1
    window.BorderSizePixel = 0
    window.Active = true
    window.Draggable = true
    Instance.new("UICorner", window).CornerRadius = UDim.new(0,12)

    -- TitleBar
    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1,0,0,40)
    titleBar.BackgroundTransparency = 1

    local headerLogo = Instance.new("ImageLabel", titleBar)
    headerLogo.Size = UDim2.new(0, 30, 0, 30)
    headerLogo.Position = UDim2.new(0,5,0,5)
    headerLogo.Image = "rbxassetid://123032091977400"
    headerLogo.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "STREE HUB"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0,40,0,0)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0,255,100)
    title.BackgroundTransparency = 1

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1,-35,0,5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function()
        ui:Destroy()
    end)

    local minimizeBtn = Instance.new("TextButton", titleBar)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1,-70,0,5)
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

    -- Tab kanan
    local tabMenu = Instance.new("Frame", window)
    tabMenu.Size = UDim2.new(0,120,1,-40)
    tabMenu.Position = UDim2.new(1,-120,0,40)
    tabMenu.BackgroundColor3 = Color3.fromRGB(40,40,40)
    tabMenu.BackgroundTransparency = 0.1
    Instance.new("UICorner", tabMenu).CornerRadius = UDim.new(0,6)

    -- Konten
    local contentFrame = Instance.new("Frame", window)
    contentFrame.Size = UDim2.new(1,-140,1,-50)
    contentFrame.Position = UDim2.new(0,10,0,45)
    contentFrame.BackgroundTransparency = 1

    local function clearContent()
        for _,v in pairs(contentFrame:GetChildren()) do
            if v:IsA("GuiObject") then v:Destroy() end
        end
    end

    local yOffset = 0
    local function nextY(height) local y = yOffset; yOffset=yOffset+height+5; return y end
    local function resetYOffset() yOffset=0 end

    local function createLabel(text)
        local lbl = Instance.new("TextLabel", contentFrame)
        lbl.Size = UDim2.new(1,-20,0,25)
        lbl.Position = UDim2.new(0,10,0,nextY(25))
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.BackgroundTransparency = 1
    end

    local function createButton(text, callback)
        local btn = Instance.new("TextButton", contentFrame)
        btn.Size = UDim2.new(1,-20,0,30)
        btn.Position = UDim2.new(0,10,0,nextY(30))
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.TextColor3 = Color3.fromRGB(0,255,0)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
        btn.MouseButton1Click:Connect(callback)
    end

    local function createToggle(text, callback)
        local btn = Instance.new("TextButton", contentFrame)
        btn.Size = UDim2.new(1,-20,0,30)
        btn.Position = UDim2.new(0,10,0,nextY(30))
        btn.Text = text.." [OFF]"
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
        local state=false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text.." ["..(state and "ON" or "OFF").."]"
            callback(state)
        end)
    end

    local lastTabY=0
    local function createTab(name, callback)
        local btn = Instance.new("TextButton", tabMenu)
        btn.Size = UDim2.new(1,-10,0,30)
        btn.Position = UDim2.new(0,5,0,lastTabY+5)
        lastTabY = lastTabY+35
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(0,255,100)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
        btn.MouseButton1Click:Connect(function()
            clearContent()
            resetYOffset()
            callback()
        end)
    end

    -- Tab Home
    createTab("Home", function()
        createLabel("⚙️ Utilities")
        createToggle("Night Mode", function(state)
            game.Lighting.TimeOfDay = state and "00:00:00" or "14:00:00"
        end)
        createButton("Enable Shiftlock", function()
            pcall(function() LocalPlayer.DevEnableMouseLock=true end)
        end)
    end)

   -- Tab Main
   createTab("Main", function()
        createLabel("⚙️ Utility")
        createToggle("auto plant & auto harvest", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Auto%20plant%20%26%20Auto%20Harvest.lua"))()
         end)
        createToggle("Auto Sell", function()
            loadstring(game:Http("https://github.com/create-stree/STREE-HUB/blob/main/Grow/Auto%20sell.lua"))()
         end)
         createToggle("Auto Watering", function()
            loadstring(game:HttpGet("")
         end)
         createLabel("Predik", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Predik.lua"))()
         end)
     end)
        

   -- Tab Settings
   createTab("Settings", function()
        createLabel("Other")
        createButton("Anti Lag", function()
             loadstring
        end)
        createButton("Anti AFK", function()
             loadstring
        end)
    end)

    -- Tab Credits
    createTab("Credits", function()
        createLabel("Created by: STREE Community")
        createLabel("STREE HUB | create-stree")
    end)
end

-- Build Key UI utama
local function buildKeyUI()
    local keyGui = Instance.new("ScreenGui", parentGui)
    keyGui.Name = "STREE_KeyUI"
    keyGui.ResetOnSpawn=false

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0,340,0,220)
    frame.Position = UDim2.new(0.5,-170,0.5,-110)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0,255,0)
    stroke.Thickness=3

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,-20,0,36)
    title.Position = UDim2.new(0,10,0,8)
    title.BackgroundTransparency=1
    title.Font=Enum.Font.GothamBold
    title.TextSize=18
    title.TextColor3=Color3.fromRGB(0,255,0)
    title.Text="🔑 | Key System"

    local input=Instance.new("TextBox", frame)
    input.Size=UDim2.new(1,-20,0,40)
    input.Position=UDim2.new(0,10,0,56)
    input.PlaceholderText="Enter key..."
    input.BackgroundColor3=Color3.fromRGB(36,36,36)
    input.TextColor3=Color3.fromRGB(255,255,255)
    input.ClearTextOnFocus=false
    input.Font=Enum.Font.Gotham
    input.TextSize=16
    Instance.new("UICorner", input).CornerRadius=UDim.new(0,6)

    local status=Instance.new("TextLabel", frame)
    status.Size=UDim2.new(1,-20,0,18)
    status.Position=UDim2.new(0,10,0,104)
    status.BackgroundTransparency=1
    status.Font=Enum.Font.Gotham
    status.TextSize=14
    status.TextColor3=Color3.fromRGB(200,200,200)
    status.Text=""

    local enterBtn=Instance.new("TextButton", frame)
    enterBtn.Size=UDim2.new(0.47,-6,0,30)
    enterBtn.Position=UDim2.new(0,10,0,130)
    enterBtn.Text="Enter"
    enterBtn.Font=Enum.Font.GothamBold
    enterBtn.TextSize=16
    enterBtn.BackgroundColor3=Color3.fromRGB(0,200,0)
    enterBtn.TextColor3=Color3.fromRGB(0,0,0)
    Instance.new("UICorner", enterBtn).CornerRadius=UDim.new(0,6)

    local discordBtn=Instance.new("TextButton", frame)
    discordBtn.Size=UDim2.new(0.47,-6,0,30)
    discordBtn.Position=UDim2.new(0,180,0,130)
    discordBtn.Text="Join Discord"
    discordBtn.Font=Enum.Font.GothamBold
    discordBtn.TextSize=16
    discordBtn.BackgroundColor3=Color3.fromRGB(60,60,255)
    discordBtn.TextColor3=Color3.fromRGB(255,255,255)
    Instance.new("UICorner", discordBtn).CornerRadius=UDim.new(0,6)
    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end)

    local linkBtn=Instance.new("TextButton", frame)
    linkBtn.Size=UDim2.new(1,-20,0,30)
    linkBtn.Position=UDim2.new(0,10,0,170)
    linkBtn.Text="Get Key"
    linkBtn.Font=Enum.Font.GothamBold
    linkBtn.TextSize=16
    linkBtn.BackgroundColor3=Color3.fromRGB(80,80,80)
    linkBtn.TextColor3=Color3.fromRGB(255,255,255)
    Instance.new("UICorner", linkBtn).CornerRadius=UDim.new(0,6)
    linkBtn.MouseButton1Click:Connect(function()
        buildKeyLinksUI()
    end)

    enterBtn.MouseButton1Click:Connect(function()
        local key=input.Text
        if isKeyValid(key) then
            status.TextColor3=Color3.fromRGB(0,255,0)
            status.Text="Key Valid!"
            wait(0.5)
            keyGui:Destroy()
            buildMainUI()
        else
            status.TextColor3=Color3.fromRGB(255,0,0)
            status.Text="Key Invalid!"
        end
    end)
end

-- START
buildKeyUI()
