--  STREE HUB LOADER – fixed
repeat task.wait() until game:IsLoaded()

--/////////////////////////////
--// 1. GUI SKELETON
--/////////////////////////////

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Http = game:GetService("HttpService")

local gui = Instance.new("ScreenGui")
gui.Name = "STREE_HUB_UI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local win = Instance.new("Frame")
win.Name = "MainWindow"
win.Size = UDim2.new(0, 500, 0, 320)
win.Position = UDim2.new(0.5, -250, 0.5, -160)
win.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
win.BackgroundTransparency = 0.2
win.BorderSizePixel = 0
win.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Text = "🧠 STREE HUB v1.0"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.BackgroundTransparency = 1
title.Parent = win

-- Tab menu (kanan)
local tabMenu = Instance.new("Frame")
tabMenu.Name = "TabMenu"
tabMenu.Size = UDim2.new(0, 120, 1, -40)
tabMenu.Position = UDim2.new(1, -120, 0, 40)
tabMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabMenu.BackgroundTransparency = 0.1
tabMenu.Parent = win

-- Content area
local content = Instance.new("Frame")
content.Name = "ContentFrame"
content.Size = UDim2.new(1, -130, 1, -40)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = win

--/////////////////////////////
--// 2. UTILS
--/////////////////////////////

local function clearContent()
    for _, obj in ipairs(content:GetChildren()) do
        if obj:IsA("GuiObject") then obj:Destroy() end
    end
end

local function createLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, #content:GetChildren() * 30)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.BackgroundTransparency = 1
    lbl.Parent = content
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #content:GetChildren() * 35)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = content
    return btn
end

local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #content:GetChildren() * 35)
    btn.Text = text .. " [OFF]"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"
        callback(state)
    end)
    btn.Parent = content
    return btn
end

--/////////////////////////////
--// 3. TAB HANDLERS
--/////////////////////////////

local function addTab(name, handler)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 30)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 16
    tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tabBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = tabMenu
    tabBtn.MouseButton1Click:Connect(function()
        clearContent()
        handler()
    end)
end

-- Home
addTab("Home", function()
    createLabel("Welcome to STREE HUB!")
    createButton("Load Main Script", function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Main.lua"))()
        end)
        if not success then warn("Gagal load script:", err) end
    end)
    createToggle("Auto Execute", function(state)
        print("Auto Exec:", state)
    end)
end)

-- Settings
addTab("Settings", function()
    createLabel("Pengaturan Umum:")
    createToggle("Anti-AFK", function(state)
        if state then
            local vu = game:GetService("VirtualUser")
            Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end)
end)

-- Visual
addTab("Visual", function()
    createLabel("Visual Mode:")
    createButton("ESP ON", function()
        print("ESP Dinyalakan")
    end)
end)

-- Credits
addTab("Credits", function()
    createLabel("Made by kirsiasc")
    createLabel("STREE HUB | create-stree")
end)

-- Default tab
clearContent()
addTab("Home", function() end)()
