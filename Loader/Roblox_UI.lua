-- STREE HUB LOADER - UI Custom (Mirip Alchemy Hub, kanan)
repeat wait() until game:IsLoaded()

-- Konfigurasi Loader
local ui = Instance.new("ScreenGui", game.CoreGui)
ui.Name = "STREE_HUB_UI"
ui.ResetOnSpawn = false

-- Frame Utama (Window)
local window = Instance.new("Frame", ui)
window.Name = "MainWindow"
window.Size = UDim2.new(0, 500, 0, 320)
window.Position = UDim2.new(0.5, -250, 0.5, -160)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
window.BackgroundTransparency = 0.2
window.BorderSizePixel = 0

-- Judul
local title = Instance.new("TextLabel", window)
title.Text = "🧠 STREE HUB v1.0"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.BackgroundTransparency = 1

-- Panel kanan (Tab menu)
local tabMenu = Instance.new("Frame", window)
tabMenu.Name = "TabMenu"
tabMenu.Size = UDim2.new(0, 120, 1, -40)
tabMenu.Position = UDim2.new(1, -120, 0, 40)
tabMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabMenu.BackgroundTransparency = 0.1

-- Tab Button
local function createTab(name, callback)
    local btn = Instance.new("TextButton", tabMenu)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(0, 255, 100)
    btn.MouseButton1Click:Connect(callback)
end

-- Konten Area
local contentFrame = Instance.new("Frame", window)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -130, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1

-- Fungsi Bersih Konten
local function clearContent()
    for _,v in pairs(contentFrame:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
end

-- Fungsi Tambah Komponen
local function createLabel(text)
    local lbl = Instance.new("TextLabel", contentFrame)
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, #contentFrame:GetChildren()*30)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.BackgroundTransparency = 1
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #contentFrame:GetChildren()*35)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.MouseButton1Click:Connect(callback)
end

local function createToggle(text, callback)
    local btn = Instance.new("TextButton", contentFrame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #contentFrame:GetChildren()*35)
    btn.Text = text.." [OFF]"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text.." ["..(state and "ON" or "OFF").."]"
        callback(state)
    end)
end

-- Fungsi Tab Home
createTab("Home", function()
    clearContent()
    createLabel("Welcome to STREE HUB!")
    createButton("Load Script", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Main.lua"))()
    end)
    createToggle("Auto Execute", function(state)
        print("Auto Exec:", state)
    end)
end)

-- Fungsi Tab Settings
createTab("Settings", function()
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
end)

-- Fungsi Tab Visual
createTab("Visual", function()
    clearContent()
    createLabel("Visual Mode:")
    createButton("ESP ON", function()
        print("ESP Dinyalakan")
    end)
end)

-- Fungsi Tab Credits
createTab("Credits", function()
    clearContent()
    createLabel("Made by kirsiasc")
    createLabel("STREE HUB | create-stree")
end)
