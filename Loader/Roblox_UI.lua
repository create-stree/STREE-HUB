-- Layanan Roblox
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- URL untuk verifikasi key
local verifyURL = "https://rkns.link/qss3x" -- Ganti dengan link server verifikasi

-- Simpan UI utama di sini (di-hide dulu)
local mainWindow -- nanti diisi

-- Fungsi verifikasi key
local function verifyKey(keyInput)
    local success, response = pcall(function()
        return HttpService:PostAsync(
            verifyURL,
            HttpService:JSONEncode({key = keyInput}),
            Enum.HttpContentType.ApplicationJson
        )
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        if data.status == "valid" then
            return true
        end
    end
    return false
end

-- Buat UI Key System
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "STREE HUB - Key System"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -20, 0, 30)
KeyBox.Position = UDim2.new(0, 10, 0, 50)
KeyBox.PlaceholderText = "Masukkan Key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = Frame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 5)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 85)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.Text = ""
StatusLabel.Parent = Frame

local RekoniseButton = Instance.new("TextButton")
RekoniseButton.Size = UDim2.new(1, -20, 0, 30)
RekoniseButton.Position = UDim2.new(0, 10, 0, 110)
RekoniseButton.Text = "Rekonise"
RekoniseButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
RekoniseButton.TextColor3 = Color3.new(1, 1, 1)
RekoniseButton.Font = Enum.Font.GothamBold
RekoniseButton.TextSize = 16
RekoniseButton.Parent = Frame
Instance.new("UICorner", RekoniseButton).CornerRadius = UDim.new(0, 5)

-- Event klik tombol
RekoniseButton.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if key == "" then
        StatusLabel.Text = "❌ Key tidak boleh kosong!"
        return
    end
    
    StatusLabel.Text = "🔄 Memverifikasi..."
    
    if verifyKey(key) then
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        StatusLabel.Text = "✅ Key valid!"
        
        wait(1)
        ScreenGui:Destroy() -- Tutup UI key system
        if mainWindow then
            mainWindow.Enabled = true -- Tampilkan UI utama
        end
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        StatusLabel.Text = "❌ Key salah!"
    end
end)

-- Contoh pembuatan UI utama (kamu bisa ganti dengan UI kamu)
-- STREE HUB LOADER - UI Custom (Mirip Alchemy Hub, kanan)
repeat wait() until game:IsLoaded()

-- Konfigurasi GUI
local success, result = pcall(function()
	return game:GetService("CoreGui")
end)

local parentGui = success and result or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ui = Instance.new("ScreenGui", parentGui)
ui.Name = "STREE_HUB_UI"
ui.ResetOnSpawn = false

game.StarterGui:SetCore("SendNotification", {
	Title = "STREE HUB",
	Text = "UI berhasil dimuat!",
	Icon = "rbxassetid://123032091977400", -- Ubah jika ada ikon baru
	Duration = 3
})

-- Tombol Icon STREE HUB (untuk buka/tutup window)
local logoButton = Instance.new("ImageButton", ui)
logoButton.Name = "HubIcon"
logoButton.Size = UDim2.new(0, 40, 0, 40)
logoButton.Position = UDim2.new(0, 120, 0.8, 0)
logoButton.Image = "rbxassetid://123032091977400"
logoButton.BackgroundTransparency = 1
logoButton.Draggable = true
logoButton.Active = true

-- Frame Utama (Window)
local window = Instance.new("Frame", ui)
window.Name = "MainWindow"
window.Size = UDim2.new(0, 500, 0, 320)
window.Position = UDim2.new(0.5, -250, 0.5, -160)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
window.BackgroundTransparency = 0.1
window.BorderSizePixel = 0
window.Active = true
window.Draggable = true

local corner = Instance.new("UICorner", window)
corner.CornerRadius = UDim.new(0, 12)

-- Judul dan tombol X / -
local titleBar = Instance.new("Frame", window)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1

-- Logo kecil kiri atas titleBar
local headerLogo = Instance.new("ImageLabel", titleBar)
headerLogo.Size = UDim2.new(0, 30, 0, 30)
headerLogo.Position = UDim2.new(0, 5, 0, 5)
headerLogo.Image = "rbxassetid://123032091977400"
headerLogo.BackgroundTransparency = 1

-- Judul STREE HUB
local title = Instance.new("TextLabel", titleBar)
title.Text = "STREE HUB"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 40, 0, 0) -- Sudah digeser agar tidak menimpa logo
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 255, 100)
title.BackgroundTransparency = 1

do
	local closeBtn = Instance.new("TextButton", titleBar)
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 5)
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 16
	closeBtn.BackgroundTransparency = 1
	closeBtn.MouseButton1Click:Connect(function()
		ui:Destroy()
	end)

	local minimizeBtn = Instance.new("TextButton", titleBar)
	minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
	minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
	minimizeBtn.Text = "-"
	minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 80)
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.TextSize = 16
	minimizeBtn.BackgroundTransparency = 1
	minimizeBtn.MouseButton1Click:Connect(function()
		window.Visible = false
	end)

	logoButton.MouseButton1Click:Connect(function()
		window.Visible = not window.Visible
	end)
end

-- Panel kanan (Tab menu)
local tabMenu = Instance.new("Frame", window)
tabMenu.Name = "TabMenu"
tabMenu.Size = UDim2.new(0, 120, 1, -40)
tabMenu.Position = UDim2.new(1, -120, 0, 40)
tabMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabMenu.BackgroundTransparency = 0.1
Instance.new("UICorner", tabMenu).CornerRadius = UDim.new(0, 6)

-- Blur pada sidebar
local SidebarBlur = Instance.new("ImageLabel")
SidebarBlur.Name = "SidebarBlur"
SidebarBlur.Parent = tabMenu
SidebarBlur.Size = UDim2.new(1, 0, 1, 0)
SidebarBlur.Position = UDim2.new(0, 0, 0, 0)
SidebarBlur.BackgroundTransparency = 1
SidebarBlur.Image = "rbxassetid://5553946656"
SidebarBlur.ImageTransparency = 0.4
SidebarBlur.ScaleType = Enum.ScaleType.Stretch
SidebarBlur.ZIndex = 0

-- Konten Area
local contentFrame = Instance.new("Frame", window)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -140, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1

-- Fungsi Bersih Konten
local function clearContent()
	for _,v in pairs(contentFrame:GetChildren()) do
		if v:IsA("GuiObject") then
			v:Destroy()
		end
	end
end

-- Perhitungan Dinamis Posisi Komponen
local yOffset = 0
local function resetYOffset()
	yOffset = 0
end
local function nextY(height)
	local y = yOffset
	yOffset += height + 5
	return y
end

-- Fungsi Tambah Komponen
local function createLabel(text)
	local lbl = Instance.new("TextLabel", contentFrame)
	lbl.Size = UDim2.new(1, -20, 0, 25)
	lbl.Position = UDim2.new(0, 10, 0, nextY(25))
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.BackgroundTransparency = 1
end

local function createButton(text, callback)
	local btn = Instance.new("TextButton", contentFrame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, nextY(30))
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.fromRGB(0, 255, 0)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

local function createToggle(text, callback)
	local btn = Instance.new("TextButton", contentFrame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, nextY(30))
	btn.Text = text.." [OFF]"
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text.." ["..(state and "ON" or "OFF").."]"
		callback(state)
	end)
end

local function createSectionTitle(text)
	local title = Instance.new("TextLabel", contentFrame)
	title.Size = UDim2.new(1, -20, 0, 25)
	title.Position = UDim2.new(0, 10, 0, nextY(25))
	title.Text = text
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.TextColor3 = Color3.fromRGB(0, 255, 150)
	title.BackgroundTransparency = 1
end

local function createSection(titleText, elements)
	createSectionTitle(titleText)
	for _, element in ipairs(elements) do
		element()
	end
end

-- Fungsi Tambah Tab
local lastTabY = 0
local function createTab(name, callback)
	local btn = Instance.new("TextButton", tabMenu)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, lastTabY + 5)
	lastTabY = lastTabY + 35
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(0, 255, 100)
	btn.ZIndex = 1
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(function()
		clearContent()
		resetYOffset()
		callback()
	end)
end

-- Tab: Home
createTab("Home", function()
	createSection("⚙️ Utilities", {
		function() createLabel("Welcome to STREE HUB!") end,
		function() createButton("Enable Shiftlock", function()
			local plr = game.Players.LocalPlayer
			pcall(function()
				plr.DevEnableMouseLock = true
			end)
		end) end,
		function() createToggle("Night Mode", function(state)
			if state then
				game.Lighting.TimeOfDay = "00:00:00"
			else
				game.Lighting.TimeOfDay = "14:00:00"
			end
		end) end
	})

	createSection("📌 Info", {
		function() createLabel("Version: 1.0.0") end,
		function() createLabel("Creator: STREE") end
	})
end)

-- Tab: Credits
createTab("Credits", function()
	createLabel("Create : STREE Community")
	createLabel("STREE HUB | create-stree")
end)
