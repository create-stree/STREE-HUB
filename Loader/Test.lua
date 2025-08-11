-- STREE HUB LOADER - UI Custom (Mirip Alchemy Hub, kanan)
repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Konfigurasi GUI
local success, result = pcall(function()
	return game:GetService("CoreGui")
end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

-- Daftar key valid (hardcoded)
local validKeys = {
	"STREEHUB-2025-9GHTQ7ZP4M",
	"STREE-KeySystem-82ghtQRSM",
	"StreeCommunity-7g81ht7NO22"
}

-- Fungsi cek key di daftar validKeys
local function isKeyValid(keyInput)
	for _, key in ipairs(validKeys) do
		if keyInput == key then
			return true
		end
	end
	return false
end

-- UI utama STREE HUB, dibuat setelah key valid
local function buildMainUI()
	game.StarterGui:SetCore("SendNotification", {
		Title = "STREE HUB",
		Text = "UI berhasil dimuat!",
		Icon = "rbxassetid://123032091977400",
		Duration = 3
	})

	local ui = Instance.new("ScreenGui", parentGui)
	ui.Name = "STREE_HUB_UI"
	ui.ResetOnSpawn = false

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
	title.Position = UDim2.new(0, 40, 0, 0)
	title.TextSize = 22
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.fromRGB(0, 255, 100)
	title.BackgroundTransparency = 1

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

	titleBar.Parent = window

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

	return {
		ScreenGui = ui,
		Window = window,
		Logo = logoButton
	}
end

-- ==== Build Key UI, sebelum main UI muncul ====
local function buildKeyUI()
	local keyGui = Instance.new("ScreenGui", parentGui)
	keyGui.Name = "STREE_KeyUI"
	keyGui.ResetOnSpawn = false

	local frame = Instance.new("Frame", keyGui)
	frame.Size = UDim2.new(0, 340, 0, 170)
	frame.Position = UDim2.new(0.5, -170, 0.5, -85)
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
	title.Text = "STREE HUB - Key System"

	local input = Instance.new("TextBox", frame)
	input.Size = UDim2.new(1, -20, 0, 40)
	input.Position = UDim2.new(0, 10, 0, 56)
	input.PlaceholderText = "Masukkan key..."
	input.BackgroundColor3 = Color3.fromRGB(36,36,36)
	input.TextColor3 = Color3.fromRGB(255,255,255)
	input.ClearTextOnFocus = false
	input.Font = Enum.Font.Gotham
	input.TextSize = 16
	Instance.new("UICorner", input).CornerRadius = UDim.new(0,6)

	local status = Instance.new("TextLabel", frame)
	status.Size = UDim2.new(1, -20, 0, 18)
	status.Position = UDim2.new(0, 10, 0, 104)
	status.BackgroundTransparency = 1
	status.Font = Enum.Font.Gotham
	status.TextSize = 14
	status.TextColor3 = Color3.fromRGB(200,200,200)
	status.Text = ""

	local getBtn = Instance.new("TextButton", frame)
	getBtn.Size = UDim2.new(0.47, -6, 0, 30)
	getBtn.Position = UDim2.new(0, 10, 0, 126)
	getBtn.Text = "Get Key"
	getBtn.Font = Enum.Font.GothamBold
	getBtn.TextSize = 16
	getBtn.BackgroundColor3 = Color3.fromRGB(60,120,255)
	getBtn.TextColor3 = Color3.fromRGB(255,255,255)
	Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0,6)

	local verifyBtn = Instance.new("TextButton", frame)
	verifyBtn.Size = UDim2.new(0.47, -6, 0, 30)
	verifyBtn.Position = UDim2.new(0, 10 + (0.47 * 340) + 12, 0, 126)
	verifyBtn.Text = "Verify"
	verifyBtn.Font = Enum.Font.GothamBold
	verifyBtn.TextSize = 16
	verifyBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
	verifyBtn.TextColor3 = Color3.fromRGB(0,0,0)
	Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0,6)

	getBtn.MouseButton1Click:Connect(function()
		pcall(function() setclipboard("https://rkns.link/qss3x") end)
		status.TextColor3 = Color3.fromRGB(0,255,0)
		status.Text = "Link copied! Paste di browser untuk dapatkan key."
	end)

	verifyBtn.MouseButton1Click:Connect(function()
		local key = tostring(input.Text or "")
		if key == "" then
			status.TextColor3 = Color3.fromRGB(255,100,100)
			status.Text = "Key tidak boleh kosong!"
			return
		end

		status.TextColor3 = Color3.fromRGB(200,200,200)
		status.Text = "Memverifikasi..."

		if isKeyValid(key) then
			status.TextColor3 = Color3.fromRGB(0,255,0)
			status.Text = "Key valid! Memuat UI..."
			wait(0.6)
			keyGui:Destroy()
			buildMainUI()
		else
			status.TextColor3 = Color3.fromRGB(255,100,100)
			status.Text = "Key salah!"
		end
	end)
end

-- Main flow: tampilkan key UI dulu
buildKeyUI()
