--[[ 
    STREE HUB MAIN.LUA
    Fitur:
    1. UI Key System (pinggir hijau neon, tengah transparan)
    2. Tombol Rekonise → copy link ke clipboard
    3. Validasi key dari Pastebin
    4. Jika valid → UI Key System destroy → Windows Utama STREE HUB muncul
--]]

------------------------------
-- SERVICES
------------------------------
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

------------------------------
-- SETTINGS
------------------------------
local RekoniseLink = "https://rkns.link/fm7zd"
local PastebinRaw = "https://pastebin.com/raw/6FHx6MP8"

------------------------------
-- UI KEY SYSTEM
------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "STREE_KeySystem"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Outline Neon Hijau
local outline = Instance.new("UIStroke")
outline.Thickness = 3
outline.Color = Color3.fromRGB(0, 255, 0)
outline.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "STREE HUB | Key System"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Parent = mainFrame

-- Key Input
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
keyBox.PlaceholderText = "Enter Key..."
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 18
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
keyBox.BackgroundTransparency = 0.2
keyBox.ClearTextOnFocus = false
keyBox.Parent = mainFrame

-- Submit Button
local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.35, 0, 0, 40)
submitBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
submitBtn.Text = "Submit"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 18
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
submitBtn.Parent = mainFrame

-- Rekonise Button
local rekoniseBtn = Instance.new("TextButton")
rekoniseBtn.Size = UDim2.new(0.35, 0, 0, 40)
rekoniseBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
rekoniseBtn.Text = "Rekonise"
rekoniseBtn.Font = Enum.Font.GothamBold
rekoniseBtn.TextSize = 18
rekoniseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rekoniseBtn.BackgroundColor3 = Color3.fromRGB(0, 85, 170)
rekoniseBtn.Parent = mainFrame

------------------------------
-- FUNCTIONS
------------------------------
local function validateKey(key)
    local success, response = pcall(function()
        return game:HttpGet(PastebinRaw)
    end)
    if success and response then
        for validKey in string.gmatch(response, "[^\r\n]+") do
            if key == validKey then
                return true
            end
        end
    end
    return false
end

local function createMainWindow()
    local gui = Instance.new("ScreenGui")
    gui.Name = "STREE_MainHub"
    gui.Parent = player:WaitForChild("PlayerGui")
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui

    local outline = Instance.new("UIStroke")
    outline.Thickness = 3
    outline.Color = Color3.fromRGB(0, 255, 0)
    outline.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "STREE | Grow A Garden | v0.00.01"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = mainFrame

    -- Tab Panel
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0, 150, 1, -40)
    tabFrame.Position = UDim2.new(1, -150, 0, 40)
    tabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = mainFrame

    local section = Instance.new("TextButton")
    section.Size = UDim2.new(1, -10, 0, 30)
    section.Position = UDim2.new(0, 5, 0, 5)
    section.Text = "Home"
    section.Font = Enum.Font.Gotham
    section.TextSize = 16
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    section.Parent = tabFrame
end

------------------------------
-- BUTTON EVENTS
------------------------------
submitBtn.MouseButton1Click:Connect(function()
    if validateKey(keyBox.Text) then
        screenGui:Destroy()
        createMainWindow()
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Invalid Key";
            Text = "Key yang kamu masukkan salah!";
            Duration = 3;
        })
    end
end)

rekoniseBtn.MouseButton1Click:Connect(function()
    setclipboard(RekoniseLink)
    StarterGui:SetCore("SendNotification", {
        Title = "Link Copied";
        Text = "Rekonise link copied to clipboard!";
        Duration = 3;
    })
end)
