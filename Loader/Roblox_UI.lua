-- STREE HUB LOADER - UI Custom with Logo
repeat wait() until game:IsLoaded()

-- Konfigurasi Loader
local ui = Instance.new("ScreenGui")
ui.Name = "STREE_HUB_UI"
ui.ResetOnSpawn = false
ui.Parent = game:GetService("CoreGui")

-- Frame Utama (Window)
local window = Instance.new("Frame")
window.Name = "MainWindow"
window.Size = UDim2.new(0, 550, 0, 350) -- Diperbesar untuk logo
window.Position = UDim2.new(0.5, -275, 0.5, -175)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
window.BackgroundTransparency = 0.2
window.BorderSizePixel = 0
window.Parent = ui

-- Tambahkan corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = window

-- Header dengan logo
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1
header.Parent = window

-- Logo (TextLabel sebagai placeholder, bisa diganti dengan ImageLabel)
local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 5)
logo.BackgroundTransparency = 1
-- Untuk logo aktual, uncomment dan tambahkan URL gambar:
-- logo.Image = "rbxassetid://1234567890" -- Ganti dengan AssetID Anda
-- Sebagai placeholder, kita buat text logo
local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.Text = "rbxassetid://123032091977400"
logoText.TextSize = 30
logoText.Font = Enum.Font.GothamBold
logoText.TextColor3 = Color3.fromRGB(0, 255, 100)
logoText.BackgroundTransparency = 1
logoText.Parent = logo

-- Judul
local title = Instance.new("TextLabel")
title.Text = "STREE HUB"
title.Size = UDim2.new(0, 200, 0, 40)
title.Position = UDim2.new(0, 60, 0, 5)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Panel kanan (Tab menu)
local tabMenu = Instance.new("Frame")
tabMenu.Name = "TabMenu"
tabMenu.Size = UDim2.new(0, 120, 1, -50)
tabMenu.Position = UDim2.new(1, -120, 0, 50)
tabMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabMenu.BackgroundTransparency = 0.1
tabMenu.Parent = window

-- Konten Area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -130, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = window

-- Fungsi Bersih Konten
local function clearContent()
    for _, v in ipairs(contentFrame:GetChildren()) do
        if v:IsA("GuiObject") then
            v:Destroy()
        end
    end
end

-- Fungsi Tambah Komponen
local yOffset = 0

local function resetYOffset()
    yOffset = 0
end

local function addYOffset(amount)
    yOffset = yOffset + amount
    return yOffset - amount
end

local function createLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, addYOffset(30))
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = contentFrame
    return lbl
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, addYOffset(35))
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return btn
end

local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, addYOffset(35))
    btn.Text = text.." [OFF]"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text.." ["..(state and "ON" or "OFF").."]"
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        pcall(callback, state)
    end)
    return btn
end

-- Fungsi Tab
local function createHomeTab()
    resetYOffset()
    clearContent()
    createLabel("Welcome to STREE HUB!")
    createLabel("Premium scripting hub for Roblox")
    createButton("Load Script", function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/Roblox_UI.lua", true))()
        end)
        if not success then
            warn("Failed to load script: "..err)
        end
    end)
    createToggle("Auto Execute", function(state)
        print("Auto Exec:", state)
    end)
end

local function createSettingsTab()
    resetYOffset()
    clearContent()
    createLabel("Pengaturan Umum:")
    createToggle("Anti-AFK
