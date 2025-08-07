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
logoButton.Image = "rbxassetid://123032091977400" -- Ganti dengan asset logo kamu
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

local title = Instance.new("TextLabel", titleBar)
title.Text = "STREE HUB"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
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
SidebarBlur.Image = "rbxassetid://5553946656" -- Blur asset ID
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

-- TODO: Tambahkan Key System jika diperlukan di bagian atas
