-- Fungsi drag
local function MakeDraggable(frame)
	local dragging, dragInput, mousePos, framePos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			frame.Position = UDim2.new(
				framePos.X.Scale,
				framePos.X.Offset + delta.X,
				framePos.Y.Scale,
				framePos.Y.Offset + delta.Y
			)
		end
	end)
end

-- Buat GUI utama
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "STREE_HUB_GUI"
ScreenGui.ResetOnSpawn = false

-- Logo Button
local LogoButton = Instance.new("ImageButton", ScreenGui)
LogoButton.Name = "Logo"
LogoButton.Size = UDim2.new(0, 60, 0, 60)
LogoButton.Position = UDim2.new(0, 10, 0, 200)
LogoButton.Image = "rbxassetid://123032091977400"
LogoButton.BackgroundTransparency = 1
LogoButton.Visible = true

-- Frame utama
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MakeDraggable(MainFrame)

-- Efek border hijau neon (UIStroke)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(0, 255, 0)
stroke.Thickness = 1

-- Blur Layar (jika ingin blur background, bukan bagian UI)
local blurEffect = Instance.new("BlurEffect", Lighting)
blurEffect.Size = 12

-- Header
local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundTransparency = 1
Header.Text = "STREE | Grow A Garden | v0.00.01"
Header.TextColor3 = Color3.new(1, 1, 1)
Header.Font = Enum.Font.GothamSemibold
Header.TextSize = 16
Header.TextXAlignment = Enum.TextXAlignment.Center

-- Tombol Minimize
local Minimize = Instance.new("TextButton", MainFrame)
Minimize.Text = "–"
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -60, 0, 0)
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.BackgroundTransparency = 1

-- Tombol Close
local Close = Instance.new("TextButton", MainFrame)
Close.Text = "X"
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.TextColor3 = Color3.new(1, 0, 0)
Close.BackgroundTransparency = 1

-- Aksi Tombol
Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

LogoButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Sidebar (Tab kanan)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 100, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Container untuk Tab
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -100, 1, -30)
TabContainer.Position = UDim2.new(0, 100, 0, 30)
TabContainer.BackgroundTransparency = 1

-- Daftar section/tab
local TabSections = {
	["Home"] = Instance.new("Frame", TabContainer),
	["Settings"] = Instance.new("Frame", TabContainer),
}

-- Inisialisasi tab
for _, frame in pairs(TabSections) do
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Visible = false
	frame.BackgroundTransparency = 1
end
TabSections["Home"].Visible = true

-- Fungsi buat tombol tab
local function CreateTabButton(name)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14

	btn.MouseButton1Click:Connect(function()
		for _, f in pairs(TabSections) do
			f.Visible = false
		end
		TabSections[name].Visible = true
	end)
end

-- Buat tombol tab
CreateTabButton("Home")
CreateTabButton("Settings")

-- Section di Tab Home
local HomeSection = Instance.new("Frame", TabSections["Home"])
HomeSection.Size = UDim2.new(1, -20, 0, 200)
HomeSection.Position = UDim2.new(0, 10, 0, 10)
HomeSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
HomeSection.BorderSizePixel = 0

local HomeTitle = Instance.new("TextLabel", HomeSection)
HomeTitle.Size = UDim2.new(1, 0, 0, 30)
HomeTitle.Position = UDim2.new(0, 0, 0, 0)
HomeTitle.Text = "Welcome to STREE HUB"
HomeTitle.TextColor3 = Color3.new(1, 1, 1)
HomeTitle.Font = Enum.Font.GothamSemibold
HomeTitle.TextSize = 16
HomeTitle.BackgroundTransparency = 1
