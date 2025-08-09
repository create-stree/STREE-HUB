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
-- STREE HUB (Key system + Main UI) – All in one
-- Key verification via HTTP, no loadstring, Main UI created only after key is valid.

------------------------------------------------------------------
-- Services
------------------------------------------------------------------
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------------------------
-- Config
------------------------------------------------------------------
local VERIFY_URL = "https://rkns.link/qss3x" -- verification endpoint

------------------------------------------------------------------
-- Helper – verify key via HTTP POST
------------------------------------------------------------------
local function verifyKey(keyInput)
	if not keyInput or keyInput == "" then
		return false, "empty"
	end

	local ok, resp = pcall(function()
		return HttpService:PostAsync(
			VERIFY_URL,
			HttpService:JSONEncode({ key = keyInput }),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not ok then
		return false, "request_error"
	end

	local suc, decoded = pcall(HttpService.JSONDecode, HttpService, resp)
	if not suc or type(decoded) ~= "table" then
		return false, "invalid_response"
	end

	return decoded.status == "valid", "invalid_key"
end

------------------------------------------------------------------
-- Build Main UI (only after key is verified)
------------------------------------------------------------------
local function buildMainUI(parent)
	local ui = Instance.new("ScreenGui")
	ui.Name            = "STREE_HUB_UI"
	ui.ResetOnSpawn    = false
	ui.Parent          = parent

	pcall(function()
		game.StarterGui:SetCore("SendNotification", {
			Title = "STREE HUB",
			Text  = "UI berhasil dimuat!",
			Icon  = "rbxassetid://123032091977400",
			Duration = 3
		})
	end)

	-- Logo button (restore / minimize)
	local logoBtn = Instance.new("ImageButton")
	logoBtn.Name               = "HubIcon"
	logoBtn.Size               = UDim2.new(0, 48, 0, 48)
	logoBtn.Position           = UDim2.new(0, 12, 0, 12)
	logoBtn.Image              = "rbxassetid://123032091977400"
	logoBtn.BackgroundTransparency = 1
	logoBtn.ZIndex             = 2
	logoBtn.Parent             = ui

	-- Main window
	local window = Instance.new("Frame")
	window.Name               = "MainWindow"
	window.Size               = UDim2.new(0, 600, 0, 400)
	window.Position           = UDim2.new(0.5, -300, 0.5, -200)
	window.BackgroundColor3   = Color3.fromRGB(25, 25, 25)
	window.BackgroundTransparency = 0.25
	window.BorderSizePixel    = 0
	window.Active             = true
	window.Draggable          = true
	window.Visible            = true
	window.Parent             = ui

	local stroke = Instance.new("UIStroke", window)
	stroke.Thickness          = 3
	stroke.Color              = Color3.fromRGB(0, 255, 0)
	stroke.ApplyStrokeMode    = Enum.ApplyStrokeMode.Border
	stroke.LineJoinMode       = Enum.LineJoinMode.Round

	Instance.new("UICorner", window).CornerRadius = UDim.new(0, 12)

	------------------------------------------------------------------
	-- Title bar
	------------------------------------------------------------------
	local titleBar = Instance.new("Frame")
	titleBar.Size               = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3   = Color3.fromRGB(28, 28, 28)
	titleBar.BorderSizePixel    = 0
	titleBar.Parent             = window

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size               = UDim2.new(1, -120, 1, 0)
	titleLabel.Position           = UDim2.new(0, 50, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font               = Enum.Font.GothamBold
	titleLabel.TextSize           = 16
	titleLabel.TextColor3         = Color3.fromRGB(0, 255, 0)
	titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
	titleLabel.Text               = "STREE | Grow A Garden | v0.00.01"
	titleLabel.Parent             = titleBar

	local headerLogo = Instance.new("ImageLabel")
	headerLogo.Size               = UDim2.new(0, 36, 0, 36)
	headerLogo.Position           = UDim2.new(0, 6, 0, 2)
	headerLogo.Image              = "rbxassetid://123032091977400"
	headerLogo.BackgroundTransparency = 1
	headerLogo.Parent             = titleBar

	------------------------------------------------------------------
	-- Buttons: close / minimize
	------------------------------------------------------------------
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size               = UDim2.new(0, 32, 0, 28)
	closeBtn.Position           = UDim2.new(1, -36, 0, 6)
	closeBtn.Text               = "X"
	closeBtn.Font               = Enum.Font.GothamBold
	closeBtn.TextSize           = 16
	closeBtn.BackgroundTransparency = 0.8
	closeBtn.TextColor3         = Color3.fromRGB(255, 80, 80)
	closeBtn.Parent             = titleBar

	local minBtn = Instance.new("TextButton")
	minBtn.Size               = UDim2.new(0, 32, 0, 28)
	minBtn.Position           = UDim2.new(1, -76, 0, 6)
	minBtn.Text               = "-"
	minBtn.Font               = Enum.Font.GothamBold
	minBtn.TextSize           = 16
	minBtn.BackgroundTransparency = 0.8
	minBtn.TextColor3         = Color3.fromRGB(255, 255, 140)
	minBtn.Parent             = titleBar

	------------------------------------------------------------------
	-- Content & Sidebar
	------------------------------------------------------------------
	local contentFrame = Instance.new("Frame")
	contentFrame.Name           = "Content"
	contentFrame.Size           = UDim2.new(1, -160, 1, -60)
	contentFrame.Position       = UDim2.new(0, 10, 0, 50)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent         = window

	local sidebar = Instance.new("Frame")
	sidebar.Name               = "Sidebar"
	sidebar.Size               = UDim2.new(0, 140, 1, -60)
	sidebar.Position           = UDim2.new(1, -150, 0, 50)
	sidebar.BackgroundColor3   = Color3.fromRGB(35, 35, 35)
	sidebar.BorderSizePixel    = 0
	sidebar.Parent             = window

	Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

	local sideBlur = Instance.new("ImageLabel")
	sideBlur.Name               = "SidebarBlur"
	sideBlur.Size               = UDim2.new(1, 0, 1, 0)
	sideBlur.BackgroundTransparency = 1
	sideBlur.Image              = "rbxassetid://5553946656"
	sideBlur.ImageTransparency  = 0.45
	sideBlur.ScaleType          = Enum.ScaleType.Stretch
	sideBlur.ZIndex             = 0
	sideBlur.Parent             = sidebar

	------------------------------------------------------------------
	-- Tabs
	------------------------------------------------------------------
	local tabs      = { "Home", "Game", "Macro", "Webhook", "Settings", "Credits" }
	local tabBtns   = {}
	local tabFrames = {}

	local startY = 6
	for _, tabName in ipairs(tabs) do
		local btn = Instance.new("TextButton")
		btn.Size               = UDim2.new(1, -12, 0, 34)
		btn.Position           = UDim2.new(0, 6, 0, startY)
		btn.Text               = tabName
		btn.Font               = Enum.Font.Gotham
		btn.TextSize           = 14
		btn.BackgroundColor3   = Color3.fromRGB(55, 55, 55)
		btn.TextColor3         = Color3.fromRGB(0, 255, 140)
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		btn.Parent             = sidebar

		local f = Instance.new("Frame")
		f.Name               = tabName .. "Frame"
		f.Size               = UDim2.new(1, 0, 1, 0)
		f.BackgroundTransparency = 1
		f.Visible            = false
		f.Parent             = contentFrame

		tabBtns[tabName]   = btn
		tabFrames[tabName] = f

		btn.MouseButton1Click:Connect(function()
			for _, tf in pairs(tabFrames) do tf.Visible = false end
			f.Visible = true
		end)

		startY = startY + 40
	end

	tabFrames["Home"].Visible = true

	------------------------------------------------------------------
	-- Utility creators
	------------------------------------------------------------------
	local function createLabel(parent, text, y)
		local lbl = Instance.new("TextLabel")
		lbl.Size               = UDim2.new(1, -20, 0, 22)
		lbl.Position           = UDim2.new(0, 10, 0, y)
		lbl.BackgroundTransparency = 1
		lbl.Font               = Enum.Font.Gotham
		lbl.TextSize           = 14
		lbl.TextColor3         = Color3.fromRGB(200, 200, 200)
		lbl.Text               = text
		lbl.Parent             = parent
		return lbl
	end

	local function createButton(parent, text, y, cb)
		local b = Instance.new("TextButton")
		b.Size               = UDim2.new(0, 220, 0, 30)
		b.Position           = UDim2.new(0, 10, 0, y)
		b.BackgroundColor3   = Color3.fromRGB(40, 40, 40)
		b.TextColor3         = Color3.fromRGB(0, 255, 0)
		b.Font               = Enum.Font.GothamBold
		b.Text               = text
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		b.MouseButton1Click:Connect(function()
			if cb then cb() end
		end)
		b.Parent             = parent
		return b
	end

	local function createToggle(parent, text, y, cb)
		local t = Instance.new("TextButton")
		t.Size               = UDim2.new(0, 220, 0, 30)
		t.Position           = UDim2.new(0, 10, 0, y)
		t.BackgroundColor3   = Color3.fromRGB(40, 40, 40)
		t.TextColor3         = Color3.fromRGB(255, 255, 255)
		t.Font               = Enum.Font.Gotham
		t.Text               = text .. " [OFF]"
		Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)

		local state = false
		t.MouseButton1Click:Connect(function()
			state = not state
			t.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"
			if cb then pcall(cb, state) end
		end)
		t.Parent = parent
		return t
	end

	------------------------------------------------------------------
	-- Home tab
	------------------------------------------------------------------
	do
		local home = tabFrames["Home"]
		local y = 8
		createLabel(home, "Welcome to STREE HUB!", y); y = y + 28
		createButton(home, "Load Script (example)", y, function()
			warn("Load Script clicked")
		end); y = y + 36

		createToggle(home, "Auto Execute", y, function(state)
			warn("Auto execute:", state)
		end); y = y + 36

		createButton(home, "Enable Shiftlock", y, function()
			pcall(function()
				LocalPlayer.DevEnableMouseLock = true
			end)
		end)
	end

	------------------------------------------------------------------
	-- Credits tab
	------------------------------------------------------------------
	do
		local c = tabFrames["Credits"]
		createLabel(c, "Create : STREE Community", 8)
		createLabel(c, "STREE HUB | create-stree", 36)
	end

	------------------------------------------------------------------
	-- Window controls
	------------------------------------------------------------------
	closeBtn.MouseButton1Click:Connect(function()
		ui:Destroy()
	end)

	minBtn.MouseButton1Click:Connect(function()
		window.Visible = false
		logoBtn.Visible = true
	end)

	logoBtn.MouseButton1Click:Connect(function()
		window.Visible = not window.Visible
		if window.Visible then logoBtn.Visible = false end
	end)

	------------------------------------------------------------------
	-- Dragging (logo button)
	------------------------------------------------------------------
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		window.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	logoBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragStart = input.Position
			startPos  = window.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	logoBtn.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	return {
		ScreenGui = ui,
		Window    = window,
		Logo      = logoBtn
	}
end

------------------------------------------------------------------
-- Build Key UI
------------------------------------------------------------------
local function buildKeyUI(parent, onSuccess)
	local keyGui = Instance.new("ScreenGui")
	keyGui.Name         = "STREE_KeyUI"
	keyGui.ResetOnSpawn = false
	keyGui.Parent       = parent

	local frame = Instance.new("Frame")
	frame.Size               = UDim2.new(0, 340, 0, 170)
	frame.Position           = UDim2.new(0.5, -170, 0.5, -85)
	frame.BackgroundColor3   = Color3.fromRGB(24, 24, 24)
	frame.BorderSizePixel    = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", frame)
	stroke.Color    = Color3.fromRGB(0, 255, 0)
	stroke.Thickness = 3
	frame.Parent = keyGui

	local title = Instance.new("TextLabel")
	title.Size               = UDim2.new(1, -20, 0, 36)
	title.Position           = UDim2.new(0, 10, 0, 8)
	title.BackgroundTransparency = 1
	title.Font               = Enum.Font.GothamBold
	title.TextSize           = 18
	title.TextColor3         = Color3.fromRGB(0, 255, 0)
	title.Text               = "STREE HUB - Key System"
	title.Parent             = frame

	local input = Instance.new("TextBox")
	input.Size               = UDim2.new(1, -20, 0, 40)
	input.Position           = UDim2.new(0, 10, 0, 56)
	input.PlaceholderText    = "Masukkan key..."
	input.BackgroundColor3   = Color3.fromRGB(36, 36, 36)
	input.TextColor3         = Color3.fromRGB(255, 255, 255)
	input.ClearTextOnFocus   = false
	input.Font               = Enum.Font.Gotham
	input.TextSize           = 16
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
	input.Parent             = frame

	local status = Instance.new("TextLabel")
	status.Size               = UDim2.new(1, -20, 0, 18)
	status.Position           = UDim2.new(0, 10, 0, 104)
	status.BackgroundTransparency = 1
	status.Font               = Enum.Font.Gotham
	status.TextSize           = 14
	status.TextColor3         = Color3.fromRGB(200, 200, 200)
	status.Text               = ""
	status.Parent             = frame

	local getBtn = Instance.new("TextButton")
	getBtn.Size               = UDim2.new(0.47, -6, 0, 30)
	getBtn.Position           = UDim2.new(0, 10, 0, 126)
	getBtn.Text               = "Get Key"
	getBtn.Font               = Enum.Font.GothamBold
	getBtn.TextSize           = 16
	getBtn.BackgroundColor3   = Color3.fromRGB(60, 120, 255)
	getBtn.TextColor3         = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0, 6)
	getBtn.Parent             = frame

	local verifyBtn = Instance.new("TextButton")
	verifyBtn.Size               = UDim2.new(0.47, -6, 0, 30)
	verifyBtn.Position           = UDim2.new(0, 10 + (0.47 * 340) + 12, 0, 126)
	verifyBtn.Text               = "Verify"
	verifyBtn.Font               = Enum.Font.GothamBold
	verifyBtn.TextSize           = 16
	verifyBtn.BackgroundColor3   = Color3.fromRGB(0, 200, 0)
	verifyBtn.TextColor3         = Color3.fromRGB(0, 0, 0)
	Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 6)
	verifyBtn.Parent             = frame

	------------------------------------------------------------------
	-- Button events
	------------------------------------------------------------------
	getBtn.MouseButton1Click:Connect(function()
		pcall(function()
			setclipboard(VERIFY_URL)
		end)
		status.TextColor3 = Color3.fromRGB(0, 255, 0)
		status.Text       = "Link copied! Paste in browser."
	end)

	verifyBtn.MouseButton1Click:Connect(function()
		local key = tostring(input.Text):gsub("^%s*(.-)%s*$", "%1") -- trim
		if key == "STREEHUB-2025-9GHTQ7ZP4M", "STREE-KeySystem-82ghtQRSM", "StreeCommunity-7g81ht7NO22" then
			status.TextColor3 = Color3.fromRGB(255, 100, 100)
			status.Text       = "Key tidak boleh kosong!"
			return
		end

		status.TextColor3 = Color3.fromRGB(200, 200, 200)
		status.Text       = "Memverifikasi..."

		local ok, err = verifyKey(key)
		if ok then
			status.TextColor3 = Color3.fromRGB(0, 255, 0)
			status.Text       = "Key valid! Memuat UI..."
			task.wait(0.6)
			keyGui:Destroy()
			if onSuccess then pcall(onSuccess) end
		else
			status.TextColor3 = Color3.fromRGB(255, 100, 100)
			if err == "request_error" then
				status.Text = "Error koneksi. Cek HTTP(s) & endpoint."
			elseif err == "invalid_response" then
				status.Text = "Response server tidak valid."
			else
				status.Text = "Key salah!"
			end
		end
	end)
end

------------------------------------------------------------------
-- Main flow – show key UI first
------------------------------------------------------------------
buildKeyUI(PlayerGui, function()
	local main = buildMainUI(PlayerGui)
	main.Window.Visible = true
	main.Logo.Visible   = false
end)

--End Script
