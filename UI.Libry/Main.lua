-- Black Neon UI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Protection
local protectGui = protectgui or (syn and syn.protect_gui) or function() end

-- Colors
local BLACK = Color3.new(0, 0, 0)
local NEON_GREEN = Color3.new(0, 1, 0)
local WHITE = Color3.new(1, 1, 1)

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabButtons = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local ContentFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

ScreenGui.Name = "BlackNeonUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = BLACK
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Neon Border Effect
local BorderGlow = Instance.new("UIStroke")
BorderGlow.Parent = MainFrame
BorderGlow.Color = NEON_GREEN
BorderGlow.Thickness = 2
BorderGlow.Transparency = 0.3

local InnerGlow = Instance.new("UIStroke")
InnerGlow.Parent = MainFrame
InnerGlow.Color = NEON_GREEN
InnerGlow.Thickness = 1
InnerGlow.Transparency = 0.7

-- Title
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = BLACK
TitleLabel.Text = "BLACK NEON UI"
TitleLabel.TextColor3 = NEON_GREEN
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.BorderSizePixel = 0
TitleLabel.Parent = MainFrame

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = BLACK
CloseButton.TextColor3 = NEON_GREEN
CloseButton.Text = "X"
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = MainFrame

local CloseGlow = Instance.new("UIStroke")
CloseGlow.Parent = CloseButton
CloseGlow.Color = NEON_GREEN
CloseGlow.Thickness = 1

-- Tab Buttons
TabButtons.Name = "TabButtons"
TabButtons.Size = UDim2.new(0, 120, 1, -40)
TabButtons.Position = UDim2.new(0, 0, 0, 40)
TabButtons.BackgroundColor3 = BLACK
TabButtons.BorderSizePixel = 0
TabButtons.Parent = MainFrame

UIListLayout.Parent = TabButtons
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)

-- Content Frame
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -120, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 40)
ContentFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Make draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TitleLabel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Close functionality
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

protectGui(ScreenGui)
ScreenGui.Parent = player:WaitForChild("PlayerGui")

return {
	ScreenGui = ScreenGui,
	MainFrame = MainFrame,
	TabButtons = TabButtons,
	ContentFrame = ContentFrame,
	Colors = {
		Black = BLACK,
		NeonGreen = NEON_GREEN,
		White = WHITE
	}
}
