-- STREE HUB - Loader & UI Full Final
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

-- ==== Build Key Links UI ====
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
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0,255,0)
    stroke.Thickness = 3

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -50, 0, 36)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.Text = "STREE HUB - Key Links"

    -- Tombol X (close -> balik ke Key System)
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0,30,0,30)
    closeBtn.Position = UDim2.new(1,-35,0,5)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local yOffset = 50
    local function createLinkButton(name, link, imageId)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 320, 0, 40)
        btn.Position = UDim2.new(0, 20, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

        btn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(link)
            end
        end)

        yOffset = yOffset + 50
    end

    createLinkButton("Rekonise", "https://rkns.link/2vbo0")
    createLinkButton("Linkvertise", "https://link-hub.net/1365203/NqhrZrvoQhoi")
    createLinkButton("Lootlabs", "https://lootdest.org/s?VooVvLbJ")
end

-- ==== Build Main UI ====
local function buildMainUI()
    local ui = Instance.new("ScreenGui", parentGui)
    ui.Name = "STREE_HUB_UI"
    ui.ResetOnSpawn = false

    -- Window Utama
    local window = Instance.new("Frame", ui)
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 500, 0, 320)
    window.Position = UDim2.new(0.5, -250, 0.5, -160)
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)
    window.Active = true
    window.Draggable = true
    Instance.new("UICorner", window).CornerRadius = UDim.new(0,12)

    -- TitleBar
    local titleBar = Instance.new("Frame", window)
    titleBar.Size = UDim2.new(1,0,0,40)
    titleBar.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", titleBar)
    title.Text = "STREE HUB"
    title.Size = UDim2.new(1,-40,1,0)
    title.Position = UDim2.new(0,10,0,0)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0,255,100)
    title.BackgroundTransparency = 1

    -- Tambahan Persegi Panjang (Search Box)
    local searchBox = Instance.new("TextBox", window)
    searchBox.Size = UDim2.new(0, 200, 0, 30)
    searchBox.Position = UDim2.new(0, 20, 0, 60)
    searchBox.PlaceholderText = "Search..."
    searchBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
    searchBox.TextColor3 = Color3.fromRGB(255,255,255)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)

    -- Tambahan Silinder (hiasan)
    local cylinder = Instance.new("Frame", window)
    cylinder.Size = UDim2.new(0,40,0,120)
    cylinder.Position = UDim2.new(1,-60,0,60)
    cylinder.BackgroundColor3 = Color3.fromRGB(0,255,100)
    Instance.new("UICorner", cylinder).CornerRadius = UDim.new(1,0) -- jadi bentuk silinder oval
end

-- ==== Build Key UI utama ====
local function buildKeyUI()
    local keyGui = Instance.new("ScreenGui", parentGui)
    keyGui.Name = "STREE_KeyUI"
    keyGui.ResetOnSpawn=false

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0,340,0,220)
    frame.Position = UDim2.new(0.5,-170,0.5,-110)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0,255,0)
    stroke.Thickness=3

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,-50,0,36)
    title.Position = UDim2.new(0,10,0,8)
    title.BackgroundTransparency=1
    title.Font=Enum.Font.GothamBold
    title.TextSize=18
    title.TextColor3=Color3.fromRGB(0,255,0)
    title.Text="STREE HUB - Key System"

    -- Tombol X (close)
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0,30,0,30)
    closeBtn.Position = UDim2.new(1,-35,0,5)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
    closeBtn.BackgroundTransparency = 1
    closeBtn.MouseButton1Click:Connect(function()
        keyGui:Destroy()
    end)

    local input=Instance.new("TextBox", frame)
    input.Size=UDim2.new(1,-20,0,40)
    input.Position=UDim2.new(0,10,0,56)
    input.PlaceholderText="Masukkan key..."
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

    local linkBtn=Instance.new("TextButton", frame)
    linkBtn.Size=UDim2.new(0.47,-6,0,30)
    linkBtn.Position=UDim2.new(0,180,0,130)
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
