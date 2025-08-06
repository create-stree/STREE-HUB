-- STREE HUB LOADER - UI Custom (Mirip Alchemy Hub, kanan)
repeat wait() until game:IsLoaded()

-- Konfigurasi Loader
local ui = Instance.new("ScreenGui")
ui.Name = "STREE_HUB_UI"
ui.ResetOnSpawn = false
ui.Parent = game:GetService("CoreGui")

-- Frame Utama (Window)
local window = Instance.new("Frame")
window.Name = "MainWindow"
window.Size = UDim2.new(0, 500, 0, 320)
window.Position = UDim2.new(0.5, -250, 0.5, -160)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
window.BackgroundTransparency = 0.2
window.BorderSizePixel = 0
window.Parent = ui

-- Judul
local title = Instance.new("TextLabel")
title.Text = "🧠 STREE HUB v1.0"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.BackgroundTransparency = 1
title.Parent = window

-- Panel kanan (Tab menu)
local tabMenu = Instance.new("Frame")
tabMenu.Name = "TabMenu"
tabMenu.Size = UDim2.new(0, 120, 1, -40)
tabMenu.Position = UDim2.new(1, -120, 0, 40)
tabMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabMenu.BackgroundTransparency = 0.1
tabMenu.Parent = window

-- Konten Area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -130, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = window

-- Fungsi Bersih Konten
local function clearContent()
    for _,v in pairs(contentFrame:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
end

-- Fungsi Tambah Komponen
local function createLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, #contentFrame:GetChildren() * 30)
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
    btn.Position = UDim2.new(0, 10, 0, #contentFrame:GetChildren() * 35)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #contentFrame:GetChildren() * 35)
    btn.Text = text.." [OFF]"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text.." ["..(state and "ON" or "OFF").."]"
        btn.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        callback(state)
    end)
    return btn
end

-- Fungsi Tab Home
local function createHomeTab()
    clearContent()
    createLabel("Welcome to STREE HUB!")
    createButton("Load Script", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Main.lua", true))()
    end)
    createToggle("Auto Execute", function(state)
        print("Auto Exec:", state)
    end)
end

-- Fungsi Tab Settings
local function createSettingsTab()
    clearContent()
    createLabel("Pengaturan Umum:")
    createToggle("Anti-AFK", function(state)
        if state then
            local vu = game:service'VirtualUser'
            game:service'Players'.LocalPlayer.Idled:connect(function()
                vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end
    end)
end

-- Fungsi Tab Visual
local function createVisualTab()
    clearContent()
    createLabel("Visual Mode:")
    createButton("ESP ON", function()
        print("ESP Dinyalakan")
    end)
end

-- Fungsi Tab Credits
local function createCreditsTab()
    clearContent()
    createLabel("Made by kirsiasc")
    createLabel("STREE HUB | create-stree")
end

-- Tab Button
local function createTab(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(0, 255, 100)
    btn.Parent = tabMenu
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    -- Penyesuaian posisi tab
    btn.Position = UDim2.new(0, 0, 0, (#tabMenu:GetChildren() - 1) * 35)
    return btn
end

-- Buat tab-tab
createTab("Home", createHomeTab)
createTab("Settings", createSettingsTab)
createTab("Visual", createVisualTab)
createTab("Credits", createCreditsTab)

-- Buka tab Home secara default
createHomeTab()

-- Tambahkan drag functionality
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Tambahkan tombol close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = window

closeBtn.MouseButton1Click:Connect(function()
    ui:Destroy()
end)
