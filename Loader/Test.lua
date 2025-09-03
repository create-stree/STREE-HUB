local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Buat Window WindUI (Hub utama)
local Window = Library:Window("STREE HUB", "Blox Fruits v1.0")

local Window = WindUI:CreateWindow({
    Title = "My Super script | Test Hub",
    Icon = "door-open",
    Author = "Example UI",
    Folder = "MyTestHub",
})

local Tab = Window:Tab({
    Title = "Tab Title",
    Icon = "bird",
    Locked = false,
})

local Button = Tab:Button({
    Title = "Button",
    Desc = "Test Button",
    Locked = false,
    Callback = function()
        print("clicked")
    end
})

-- === Logo bulat di pojok layar ===
local logoGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
logoGui.Name = "STREEHUB_Logo"

local logoBtn = Instance.new("ImageButton")
logoBtn.Parent = logoGui
logoBtn.Size = UDim2.new(0, 60, 0, 60)
logoBtn.Position = UDim2.new(1, -80, 0, 150) -- kanan atas
logoBtn.AnchorPoint = Vector2.new(0,0)
logoBtn.Image = "rbxassetid://101447877507131" -- ganti ke asset ID planet/logo kamu
logoBtn.BackgroundTransparency = 1

-- Biar bulat
local uicorner = Instance.new("UICorner", logoBtn)
uicorner.CornerRadius = UDim.new(1,0)

-- === Fungsi buka/tutup Window WindUI
local isOpen = true
logoBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    Window.Visible = isOpen
end)
