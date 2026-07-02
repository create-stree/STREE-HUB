local Services = {
	Players = game:GetService("Players"),
	TweenService = game:GetService("TweenService"),
	UserInputService = game:GetService("UserInputService"),
	RunService = game:GetService("RunService")
}
local Player = Services.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = {
	MaxKeyLength = 50,
	AnimationSpeed = 0.4,
	ParticleCount = 60,
	ParticleSpeed = 60
}

local Colors = {
	Background = Color3.fromRGB(18, 18, 22),
	Surface = Color3.fromRGB(25, 25, 30),
	Primary = Color3.fromRGB(45, 45, 50),
	Secondary = Color3.fromRGB(35, 35, 40),
	Border = Color3.fromRGB(40, 40, 45),
	TextPrimary = Color3.fromRGB(220, 220, 225),
	TextSecondary = Color3.fromRGB(140, 140, 150),
	Success = Color3.fromRGB(25, 135, 84),
	Error = Color3.fromRGB(180, 50, 50),
	Warning = Color3.fromRGB(200, 120, 30),
	GetKey = Color3.fromRGB(40, 140, 100),
	HoverPrimary = Color3.fromRGB(55, 55, 60),
	HoverGetKey = Color3.fromRGB(30, 120, 80),
	NeonGreen = Color3.fromRGB(0, 255, 100),
	NeonGlow = Color3.fromRGB(0, 200, 80)
}

local State = {
	IsLoading = false,
	Particles = {},
	Animations = {},
	IsDestroyed = false,
	MousePosition = {X = 0, Y = 0},
	FocusStates = { InputFocused = false, ButtonHovered = {}, AnimationsActive = true }
}
local UI = {}

local function CreateMainGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "KeySystemGUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 100
	screenGui.Parent = PlayerGui
	UI.ScreenGui = screenGui
	return screenGui
end

local function CreateBackdrop(parent)
	local backdrop = Instance.new("Frame")
	backdrop.Name = "Backdrop"
	backdrop.Size = UDim2.new(1, 0, 1, 0)
	backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	backdrop.BackgroundTransparency = 0.1
	backdrop.BorderSizePixel = 0
	backdrop.ZIndex = 100
	backdrop.Parent = parent
	UI.Backdrop = backdrop
	return backdrop
end

local function CreateContainer(parent)
	local container = Instance.new("Frame")
	container.Name = "MainContainer"
	container.Size = UDim2.new(0, 420, 0, 280)
	container.Position = UDim2.new(0.5, -210, 0.5, -140)
	container.BackgroundColor3 = Colors.Background
	container.BorderSizePixel = 0
	container.ZIndex = 110
	container.Selectable = false
	container.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 20)
	corner.Parent = container
	local stroke = Instance.new("UIStroke")
	stroke.Color = Colors.Border
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	stroke.Parent = container
	UI.Container = container
	return container
end

local function CreateAnimatedBorder(parent)
	local border = Instance.new("Frame")
	border.Name = "AnimatedBorder"
	border.Size = UDim2.new(1, 6, 1, 6)
	border.Position = UDim2.new(0, -3, 0, -3)
	border.BackgroundTransparency = 1
	border.ZIndex = 109
	border.Selectable = false
	border.Parent = parent
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 23)
	corner.Parent = border
	local stroke = Instance.new("UIStroke")
	stroke.Color = Colors.NeonGreen
	stroke.Thickness = 2
	stroke.Transparency = 0.3
	stroke.Parent = border
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Colors.NeonGreen),
		ColorSequenceKeypoint.new(0.5, Colors.NeonGlow),
		ColorSequenceKeypoint.new(1, Colors.NeonGreen)
	}
	gradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.9),
		NumberSequenceKeypoint.new(0.2, 0.1),
		NumberSequenceKeypoint.new(0.8, 0.1),
		NumberSequenceKeypoint.new(1, 0.9)
	}
	gradient.Parent = stroke
	UI.AnimatedBorder = {Frame = border, Gradient = gradient, Stroke = stroke}
	return border
end

local function CreateHeader(parent)
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundTransparency = 1
	header.ZIndex = 11
	header.Selectable = false
	header.Parent = parent

	local iconContainer = Instance.new("Frame")
	iconContainer.Size = UDim2.new(0, 32, 0, 32)
	iconContainer.Position = UDim2.new(0.5, -16, 0, 9)
	iconContainer.BackgroundColor3 = Colors.Primary
	iconContainer.BorderSizePixel = 0
	iconContainer.ZIndex = 12
	iconContainer.Selectable = false
	iconContainer.Parent = header
	local iconCorner = Instance.new("UICorner")
	iconCorner.CornerRadius = UDim.new(0, 8)
	iconCorner.Parent = iconContainer

	local iconGlow = Instance.new("Frame")
	iconGlow.Size = UDim2.new(1, 8, 1, 8)
	iconGlow.Position = UDim2.new(0, -4, 0, -4)
	iconGlow.BackgroundTransparency = 1
	iconGlow.ZIndex = 11
	iconGlow.Selectable = false
	iconGlow.Parent = iconContainer
	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(0, 12)
	glowCorner.Parent = iconGlow
	local glowStroke = Instance.new("UIStroke")
	glowStroke.Color = Colors.NeonGreen
	glowStroke.Thickness = 2
	glowStroke.Transparency = 0.2
	glowStroke.Parent = iconGlow
	local glowGradient = Instance.new("UIGradient")
	glowGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Colors.NeonGreen),
		ColorSequenceKeypoint.new(0.5, Colors.NeonGlow),
		ColorSequenceKeypoint.new(1, Colors.NeonGreen)
	}
	glowGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.2, 0.05),
		NumberSequenceKeypoint.new(0.8, 0.05),
		NumberSequenceKeypoint.new(1, 0.8)
	}
	glowGradient.Parent = glowStroke

	local iconImage = Instance.new("ImageLabel")
	iconImage.Size = UDim2.new(0.7, 0, 0.7, 0)
	iconImage.Position = UDim2.new(0.15, 0, 0.15, 0)
	iconImage.BackgroundTransparency = 1
	iconImage.Image = "rbxassetid://99948086845842"
	iconImage.ImageColor3 = Colors.NeonGreen
	iconImage.ImageTransparency = 0.1
	iconImage.ScaleType = Enum.ScaleType.Fit
	iconImage.ZIndex = 13
	iconImage.Parent = iconContainer

	local closeButton = Instance.new("ImageButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 24, 0, 24)
	closeButton.Position = UDim2.new(1, -32, 0, 13)
	closeButton.BackgroundTransparency = 1
	closeButton.Image = "rbxassetid://10152135063"
	closeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.ImageTransparency = 0.1
	closeButton.ScaleType = Enum.ScaleType.Fit
	closeButton.ZIndex = 20
	closeButton.Parent = header
	closeButton.MouseButton1Click:Connect(function()
		UI.ScreenGui:Destroy()
	end)

	UI.Header = {Container = header, IconGlow = glowGradient, IconStroke = glowStroke}
	return header
end

local function CreateContent(parent)
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -40, 0, 225)
	content.Position = UDim2.new(0, 20, 0, 55)
	content.BackgroundTransparency = 1
	content.ZIndex = 11
	content.Selectable = false
	content.Parent = parent

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 22)
	title.BackgroundTransparency = 1
	title.Text = "Key System"
	title.TextColor3 = Colors.TextPrimary
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.ZIndex = 12
	title.Parent = content

	UI.Content = content
	return content
end

local function CreateInputSection(parent)
	local section = Instance.new("Frame")
	section.Size = UDim2.new(1, 0, 0, 65)
	section.Position = UDim2.new(0, 0, 0, 50)  -- digeser ke bawah agar lebih tengah
	section.BackgroundTransparency = 1
	section.ZIndex = 12
	section.Selectable = false
	section.Parent = parent

	local inputContainer = Instance.new("Frame")
	inputContainer.Size = UDim2.new(1, 0, 0, 40)
	inputContainer.BackgroundColor3 = Colors.Surface
	inputContainer.BorderSizePixel = 0
	inputContainer.ZIndex = 13
	inputContainer.Selectable = false
	inputContainer.Parent = section
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = inputContainer
	local stroke = Instance.new("UIStroke")
	stroke.Color = Colors.Border
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	stroke.Parent = inputContainer

	local inputGlow = Instance.new("Frame")
	inputGlow.Size = UDim2.new(1, 8, 1, 8)
	inputGlow.Position = UDim2.new(0, -4, 0, -4)
	inputGlow.BackgroundTransparency = 1
	inputGlow.ZIndex = inputContainer.ZIndex - 1
	inputGlow.Visible = false
	inputGlow.Selectable = false
	inputGlow.Parent = inputContainer
	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(0, 12)
	glowCorner.Parent = inputGlow
	local glowStroke = Instance.new("UIStroke")
	glowStroke.Color = Colors.NeonGreen
	glowStroke.Thickness = 2
	glowStroke.Transparency = 0.3
	glowStroke.Parent = inputGlow
	local glowGradient = Instance.new("UIGradient")
	glowGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Colors.NeonGreen),
		ColorSequenceKeypoint.new(0.5, Colors.NeonGlow),
		ColorSequenceKeypoint.new(1, Colors.NeonGreen)
	}
	glowGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.2, 0.1),
		NumberSequenceKeypoint.new(0.8, 0.1),
		NumberSequenceKeypoint.new(1, 0.8)
	}
	glowGradient.Parent = glowStroke

	local textInput = Instance.new("TextBox")
	textInput.Size = UDim2.new(1, -20, 1, 0)
	textInput.Position = UDim2.new(0, 10, 0, 0)
	textInput.BackgroundTransparency = 1
	textInput.Text = ""
	textInput.PlaceholderText = "Enter key here"
	textInput.TextColor3 = Colors.TextPrimary
	textInput.PlaceholderColor3 = Colors.TextSecondary
	textInput.TextSize = 13
	textInput.Font = Enum.Font.Gotham
	textInput.TextXAlignment = Enum.TextXAlignment.Left
	textInput.ClearTextOnFocus = false
	textInput.ZIndex = 14
	textInput.Selectable = true
	textInput.Parent = inputContainer

	local charCounter = Instance.new("TextLabel")
	charCounter.Size = UDim2.new(0, 80, 0, 16)
	charCounter.Position = UDim2.new(1, -85, 0, 42)
	charCounter.BackgroundTransparency = 1
	charCounter.Text = "0/" .. Config.MaxKeyLength
	charCounter.TextColor3 = Colors.TextSecondary
	charCounter.TextSize = 11
	charCounter.Font = Enum.Font.Gotham
	charCounter.TextXAlignment = Enum.TextXAlignment.Right
	charCounter.ZIndex = 13
	charCounter.Parent = section

	UI.Input = {
		Container = inputContainer,
		TextBox = textInput,
		Counter = charCounter,
		Stroke = stroke,
		Glow = {Frame = inputGlow, Stroke = glowStroke, Gradient = glowGradient}
	}
	return section
end

local function CreateButtons(parent)
	local buttonsContainer = Instance.new("Frame")
	buttonsContainer.Size = UDim2.new(1, 0, 0, 40)
	buttonsContainer.Position = UDim2.new(0, 0, 0, 120)  -- di bawah input
	buttonsContainer.BackgroundTransparency = 1
	buttonsContainer.ZIndex = 12
	buttonsContainer.Selectable = false
	buttonsContainer.Parent = parent

	local getKeyButton = Instance.new("TextButton")
	getKeyButton.Size = UDim2.new(0.48, 0, 1, 0)
	getKeyButton.BackgroundColor3 = Colors.GetKey
	getKeyButton.BorderSizePixel = 0
	getKeyButton.Text = "Get Key"
	getKeyButton.TextColor3 = Colors.TextPrimary
	getKeyButton.TextSize = 14
	getKeyButton.Font = Enum.Font.GothamMedium
	getKeyButton.AutoButtonColor = false
	getKeyButton.ZIndex = 13
	getKeyButton.Selectable = true
	getKeyButton.Parent = buttonsContainer
	Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 8)

	local verifyButton = Instance.new("TextButton")
	verifyButton.Size = UDim2.new(0.48, 0, 1, 0)
	verifyButton.Position = UDim2.new(0.52, 0, 0, 0)
	verifyButton.BackgroundColor3 = Colors.Primary
	verifyButton.BorderSizePixel = 0
	verifyButton.Text = "Submit"
	verifyButton.TextColor3 = Colors.TextPrimary
	verifyButton.TextSize = 14
	verifyButton.Font = Enum.Font.GothamMedium
	verifyButton.AutoButtonColor = false
	verifyButton.ZIndex = 13
	verifyButton.Selectable = true
	verifyButton.Parent = buttonsContainer
	Instance.new("UICorner", verifyButton).CornerRadius = UDim.new(0, 8)

	local loadingContainer = Instance.new("Frame")
	loadingContainer.Size = UDim2.new(0, 22, 0, 22)
	loadingContainer.Position = UDim2.new(0.5, -11, 0, 9)
	loadingContainer.BackgroundTransparency = 1
	loadingContainer.Visible = false
	loadingContainer.ZIndex = 14
	loadingContainer.Selectable = false
	loadingContainer.Parent = verifyButton

	local spinner = Instance.new("Frame")
	spinner.Size = UDim2.new(1, 0, 1, 0)
	spinner.BackgroundColor3 = Colors.TextPrimary
	spinner.BorderSizePixel = 0
	spinner.ZIndex = 15
	spinner.Selectable = false
	spinner.Parent = loadingContainer
	local spinnerCorner = Instance.new("UICorner")
	spinnerCorner.CornerRadius = UDim.new(1, 0)
	spinnerCorner.Parent = spinner
	local spinnerGradient = Instance.new("UIGradient")
	spinnerGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.8, 0.8),
		NumberSequenceKeypoint.new(1, 1)
	}
	spinnerGradient.Parent = spinner

	UI.Buttons = {
		Submit = verifyButton,
		GetKey = getKeyButton,
		Loading = {Container = loadingContainer, Spinner = spinner}
	}
	return {verifyButton, getKeyButton}
end

local function CreateStatus(parent)
	local statusContainer = Instance.new("Frame")
	statusContainer.Size = UDim2.new(1, 0, 0, 40)
	statusContainer.Position = UDim2.new(0, 0, 0, 165)  -- di bawah tombol
	statusContainer.BackgroundTransparency = 1
	statusContainer.ZIndex = 12
	statusContainer.Selectable = false
	statusContainer.Parent = parent

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(1, 0, 1, 0)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = ""
	statusLabel.TextColor3 = Colors.Error
	statusLabel.TextSize = 13
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextXAlignment = Enum.TextXAlignment.Center
	statusLabel.TextWrapped = true
	statusLabel.ZIndex = 13
	statusLabel.Parent = statusContainer

	UI.Status = statusLabel
	return statusLabel
end

local function CreateParticleContainer(parent)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 1, 0)
	container.BackgroundTransparency = 1
	container.ZIndex = 105
	container.Selectable = false
	container.Parent = parent
	UI.ParticleContainer = container
	return container
end

local function CreateParticle()
	if not UI.ParticleContainer or not UI.ParticleContainer.Parent or State.IsDestroyed then return nil end
	local size = math.random(6, 20)
	local particle = Instance.new("Frame")
	particle.Size = UDim2.new(0, size, 0, size)
	particle.Position = UDim2.new(math.random() * 1.4 - 0.2, 0, 1.2, 0)
	particle.BackgroundColor3 = Colors.NeonGreen
	particle.BackgroundTransparency = math.random(60, 85) / 100
	particle.BorderSizePixel = 0
	particle.ZIndex = 106
	particle.Selectable = false
	particle.Parent = UI.ParticleContainer
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = particle
	local gradient = Instance.new("UIGradient")
	local bubbleColors = {
		Color3.fromRGB(0, 255, 100),
		Color3.fromRGB(50, 220, 80),
		Color3.fromRGB(0, 230, 120),
		Color3.fromRGB(100, 255, 150)
	}
	local color1 = bubbleColors[math.random(#bubbleColors)]
	local color2 = bubbleColors[math.random(#bubbleColors)]
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.7, color2),
		ColorSequenceKeypoint.new(1, color1)
	}
	gradient.Rotation = math.random(0, 360)
	gradient.Parent = particle
	local highlight = Instance.new("Frame")
	highlight.Size = UDim2.new(0.3, 0, 0.3, 0)
	highlight.Position = UDim2.new(0.2, 0, 0.15, 0)
	highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	highlight.BackgroundTransparency = 0.3
	highlight.BorderSizePixel = 0
	highlight.ZIndex = particle.ZIndex + 1
	highlight.Parent = particle
	local highlightCorner = Instance.new("UICorner")
	highlightCorner.CornerRadius = UDim.new(1, 0)
	highlightCorner.Parent = highlight
	local glow = Instance.new("Frame")
	glow.Size = UDim2.new(1.8, 0, 1.8, 0)
	glow.Position = UDim2.new(-0.4, 0, -0.4, 0)
	glow.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
	glow.BackgroundTransparency = 0.9
	glow.BorderSizePixel = 0
	glow.ZIndex = particle.ZIndex - 1
	glow.Parent = particle
	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(1, 0)
	glowCorner.Parent = glow
	local particleData = {
		frame = particle,
		vx = (math.random() - 0.5) * 0.004,
		vy = -math.random(20, 50) / 10000,
		created = tick(),
		rotation = 0,
		rotationSpeed = (math.random() - 0.5) * 2,
		pulsePhase = math.random() * math.pi * 2,
		driftPhase = math.random() * math.pi * 2,
		originalTransparency = particle.BackgroundTransparency,
		glow = glow,
		highlight = highlight,
		lifetime = math.random(30, 60),
		originalSize = size,
		wobblePhase = math.random() * math.pi * 2,
		repelForce = {x = 0, y = 0},
		mass = size / 10
	}
	table.insert(State.Particles, particleData)
	return particle
end

local function UpdateParticles()
	if State.IsDestroyed or not UI.ParticleContainer then return end
	local screenSize = UI.ScreenGui.AbsoluteSize
	local mouseScreenX = State.MousePosition.X / screenSize.X
	local mouseScreenY = State.MousePosition.Y / screenSize.Y
	for i = #State.Particles, 1, -1 do
		local p = State.Particles[i]
		if not p or not p.frame or not p.frame.Parent then
			table.remove(State.Particles, i)
		else
			local currentPos = p.frame.Position
			local age = tick() - p.created
			if currentPos.Y.Scale < -0.3 or age > p.lifetime then
				p.frame:Destroy()
				table.remove(State.Particles, i)
			else
				local distanceToMouse = math.sqrt(
					(currentPos.X.Scale - mouseScreenX)^2 + (currentPos.Y.Scale - mouseScreenY)^2
				)
				local repelStrength = 0.08
				local repelRadius = 0.15
				local repelForceX = 0
				local repelForceY = 0
				if distanceToMouse < repelRadius and distanceToMouse > 0 then
					local repelPower = (repelRadius - distanceToMouse) / repelRadius
					repelPower = repelPower * repelStrength / p.mass
					local directionX = (currentPos.X.Scale - mouseScreenX) / distanceToMouse
					local directionY = (currentPos.Y.Scale - mouseScreenY) / distanceToMouse
					repelForceX = directionX * repelPower
					repelForceY = directionY * repelPower
				end
				p.repelForce.x = p.repelForce.x * 0.85 + repelForceX * 0.15
				p.repelForce.y = p.repelForce.y * 0.85 + repelForceY * 0.15
				local newX = currentPos.X.Scale + p.vx + p.repelForce.x
				local newY = currentPos.Y.Scale + p.vy + p.repelForce.y
				if newX <= -0.2 then newX = 1.2 elseif newX >= 1.2 then newX = -0.2 end
				local wobbleTime = tick() * 1.5 + p.wobblePhase
				newX = newX + math.sin(wobbleTime) * 0.002
				newY = newY + math.cos(wobbleTime * 0.7) * 0.001
				newX = newX + (math.random() - 0.5) * 0.0008
				newY = newY + (math.random() - 0.5) * 0.0005
				p.rotation = p.rotation + p.rotationSpeed
				p.frame.Rotation = p.rotation
				local breathe = math.sin(tick() * 2.5 + p.pulsePhase) * 0.1 + 1
				local currentSize = p.originalSize * breathe
				p.frame.Size = UDim2.new(0, currentSize, 0, currentSize)
				local transparencyPulse = math.sin(tick() * 3 + p.pulsePhase) * 0.1
				local newTransparency = math.max(0.5, math.min(0.95, p.originalTransparency + transparencyPulse))
				p.frame.BackgroundTransparency = newTransparency
				local glowIntensity = 0.9
				if distanceToMouse < 0.2 then
					glowIntensity = 0.7 + (distanceToMouse / 0.2) * 0.2
				end
				p.glow.BackgroundTransparency = glowIntensity
				local shimmer = math.sin(tick() * 4 + p.pulsePhase) * 0.2 + 0.3
				p.highlight.BackgroundTransparency = shimmer
				p.vx = p.vx * 0.995
				p.vy = p.vy * 0.998
				p.frame.Position = UDim2.new(newX, 0, newY, 0)
			end
		end
	end
end

local function CreateButtonGlow(button, hoverColor, originalColor)
	local glowBorder = Instance.new("Frame")
	glowBorder.Size = UDim2.new(1, 8, 1, 8)
	glowBorder.Position = UDim2.new(0, -4, 0, -4)
	glowBorder.BackgroundTransparency = 1
	glowBorder.ZIndex = button.ZIndex - 1
	glowBorder.Visible = false
	glowBorder.Selectable = false
	glowBorder.Parent = button
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = glowBorder
	local stroke = Instance.new("UIStroke")
	stroke.Color = Colors.NeonGreen
	stroke.Thickness = 2
	stroke.Transparency = 0.3
	stroke.Parent = glowBorder
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Colors.NeonGreen),
		ColorSequenceKeypoint.new(0.5, Colors.NeonGlow),
		ColorSequenceKeypoint.new(1, Colors.NeonGreen)
	}
	gradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.2, 0.1),
		NumberSequenceKeypoint.new(0.8, 0.1),
		NumberSequenceKeypoint.new(1, 0.8)
	}
	gradient.Parent = stroke
	local currentTween = nil
	local buttonId = tostring(button)
	button.MouseEnter:Connect(function()
		State.FocusStates.ButtonHovered[buttonId] = true
		glowBorder.Visible = true
		Services.TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
		Services.TweenService:Create(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.1}):Play()
		if currentTween then currentTween:Cancel() end
		currentTween = Services.TweenService:Create(gradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
		currentTween:Play()
	end)
	button.MouseLeave:Connect(function()
		State.FocusStates.ButtonHovered[buttonId] = false
		Services.TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = originalColor}):Play()
		Services.TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Transparency = 0.8}):Play()
		if currentTween then currentTween:Cancel() gradient.Rotation = 0 end
		task.spawn(function()
			task.wait(0.3)
			if glowBorder and glowBorder.Parent then glowBorder.Visible = false end
		end)
	end)
	return {glowBorder, stroke, gradient}
end

local function ShowStatus(message, isError, isSuccess)
	if not UI.Status then return end
	UI.Status.Text = message
	if isSuccess then UI.Status.TextColor3 = Colors.Success
	elseif isError then UI.Status.TextColor3 = Colors.Error
	else UI.Status.TextColor3 = Colors.Warning end
	UI.Status.TextTransparency = 1
	Services.TweenService:Create(UI.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
end

local function ClearStatus()
	if UI.Status then
		Services.TweenService:Create(UI.Status, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
	end
end

local function SetLoading(isLoading)
	State.IsLoading = isLoading
	if not UI.Buttons then return end
	UI.Buttons.Loading.Container.Visible = isLoading
	UI.Buttons.Submit.Text = isLoading and "" or "Submit"
	if isLoading then
		local tween = Services.TweenService:Create(UI.Buttons.Loading.Spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
		tween:Play()
		State.Animations.SpinTween = tween
	else
		if State.Animations.SpinTween then State.Animations.SpinTween:Cancel() UI.Buttons.Loading.Spinner.Rotation = 0 end
	end
end

local function UpdateCharCounter()
	if not UI.Input then return end
	local currentLength = string.len(UI.Input.TextBox.Text)
	UI.Input.Counter.Text = currentLength .. "/" .. Config.MaxKeyLength
	if currentLength >= Config.MaxKeyLength then UI.Input.Counter.TextColor3 = Colors.Error
	elseif currentLength >= Config.MaxKeyLength * 0.8 then UI.Input.Counter.TextColor3 = Colors.Warning
	else UI.Input.Counter.TextColor3 = Colors.TextSecondary end
end

local function CopyToClipboard(text, successMessage)
	local success = pcall(function()
		if setclipboard then setclipboard(text) ShowStatus(successMessage, false, true)
		else ShowStatus("Link: " .. text, false, true) end
	end)
	if not success then ShowStatus("Link: " .. text, false, true) end
end

local function ConnectEvents()
	Services.UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			State.MousePosition.X = input.Position.X
			State.MousePosition.Y = input.Position.Y
		end
	end)
	UI.Input.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		local currentText = UI.Input.TextBox.Text
		if string.len(currentText) > Config.MaxKeyLength then
			UI.Input.TextBox.Text = string.sub(currentText, 1, Config.MaxKeyLength)
			ShowStatus("Maximum character limit reached (" .. Config.MaxKeyLength .. ")", true)
		end
		UpdateCharCounter()
		ClearStatus()
	end)
	local inputGlowTween = nil
	UI.Input.TextBox.Focused:Connect(function()
		State.FocusStates.InputFocused = true
		UI.Input.Glow.Frame.Visible = true
		Services.TweenService:Create(UI.Input.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Colors.NeonGreen, Transparency = 0.1}):Play()
		Services.TweenService:Create(UI.Input.Glow.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.1}):Play()
		if inputGlowTween then inputGlowTween:Cancel() end
		inputGlowTween = Services.TweenService:Create(UI.Input.Glow.Gradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
		inputGlowTween:Play()
		State.Animations.InputGlowTween = inputGlowTween
		ClearStatus()
	end)
	UI.Input.TextBox.FocusLost:Connect(function()
		State.FocusStates.InputFocused = false
		Services.TweenService:Create(UI.Input.Stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Color = Colors.Border, Transparency = 0.3}):Play()
		Services.TweenService:Create(UI.Input.Glow.Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Transparency = 0.8}):Play()
		if inputGlowTween then inputGlowTween:Cancel() UI.Input.Glow.Gradient.Rotation = 0 State.Animations.InputGlowTween = nil end
		task.spawn(function()
			task.wait(0.3)
			if UI.Input.Glow.Frame and UI.Input.Glow.Frame.Parent then UI.Input.Glow.Frame.Visible = false end
		end)
	end)
	Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or State.IsDestroyed then return end
		if input.KeyCode == Enum.KeyCode.Return and UI.Input.TextBox:IsFocused() then
			local key = UI.Input.TextBox.Text
			if key == "" then ShowStatus("Please enter an access key", true) UI.Input.TextBox:CaptureFocus() return end
			SetLoading(true)
			ShowStatus("Validating key...", false, false)
			task.spawn(function()
				task.wait(2)
				SetLoading(false)
				ShowStatus("This is a template - add your validation logic here", false, true)
			end)
		end
	end)
	UI.Buttons.Submit.MouseButton1Click:Connect(function()
		if State.IsLoading then return end
		local key = UI.Input.TextBox.Text
		if key == "" then ShowStatus("Please enter an access key", true) UI.Input.TextBox:CaptureFocus() return end
		SetLoading(true)
		ShowStatus("Validating key...", false, false)
		task.spawn(function()
			task.wait(2)
			SetLoading(false)
			ShowStatus("This is a template - add your validation logic here", false, true)
		end)
	end)
	UI.Buttons.GetKey.MouseButton1Click:Connect(function()
		ShowStatus("Opening key website...", false, false)
		CopyToClipboard("https://discord.gg/jdmX43t5mY", "Key website link copied to clipboard!")
	end)
end

local function StartAnimationLoops()
	State.Animations.BorderTween = nil
	State.Animations.IconTween = nil
	State.FocusStates.AnimationsActive = true
	task.spawn(function()
		for i = 1, 25 do
			if State.IsDestroyed then break end
			CreateParticle()
			task.wait(math.random(20, 100) / 1000)
		end
		while not State.IsDestroyed and UI.ScreenGui.Parent do
			if #State.Particles < Config.ParticleCount then CreateParticle() end
			task.wait(math.random(400, 1200) / 1000)
		end
	end)
	task.spawn(function()
		while not State.IsDestroyed and UI.ScreenGui.Parent do
			pcall(UpdateParticles)
			task.wait(1/Config.ParticleSpeed)
		end
	end)
	task.spawn(function()
		while not State.IsDestroyed and UI.AnimatedBorder and UI.AnimatedBorder.Frame.Parent do
			if State.Animations.BorderTween then State.Animations.BorderTween:Cancel() end
			local startRotation = UI.AnimatedBorder.Gradient.Rotation
			local tween = Services.TweenService:Create(UI.AnimatedBorder.Gradient, TweenInfo.new(4, Enum.EasingStyle.Linear), {Rotation = startRotation + 360})
			State.Animations.BorderTween = tween
			tween:Play()
			local success = pcall(function() tween.Completed:Wait() end)
			if not success then task.wait(4) end
			if UI.AnimatedBorder and UI.AnimatedBorder.Gradient and UI.AnimatedBorder.Gradient.Parent then
				UI.AnimatedBorder.Gradient.Rotation = UI.AnimatedBorder.Gradient.Rotation % 360
			end
			task.wait(0.1)
		end
	end)
	task.spawn(function()
		while not State.IsDestroyed and UI.Header and UI.Header.IconGlow and UI.Header.IconGlow.Parent do
			if State.Animations.IconTween then State.Animations.IconTween:Cancel() end
			local startRotation = UI.Header.IconGlow.Rotation
			State.Animations.IconTween = Services.TweenService:Create(UI.Header.IconGlow, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = startRotation + 360})
			State.Animations.IconTween:Play()
			local success = pcall(function() State.Animations.IconTween.Completed:Wait() end)
			if not success then task.wait(3) end
			if UI.Header and UI.Header.IconGlow and UI.Header.IconGlow.Parent then
				UI.Header.IconGlow.Rotation = UI.Header.IconGlow.Rotation % 360
			end
			task.wait(0.1)
		end
	end)
end

local function PlayEntranceAnimation()
	UI.Container.Size = UDim2.new(0, 0, 0, 0)
	UI.Container.BackgroundTransparency = 1
	UI.Backdrop.BackgroundTransparency = 1
	Services.TweenService:Create(UI.Backdrop, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()
	task.wait(0.1)
	Services.TweenService:Create(UI.Container, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 280), BackgroundTransparency = 0}):Play()
	task.wait(0.5)
	UI.Input.TextBox:CaptureFocus()
end

local function Initialize()
	local screenGui = CreateMainGUI()
	local backdrop = CreateBackdrop(screenGui)
	CreateParticleContainer(backdrop)
	local container = CreateContainer(screenGui)
	CreateAnimatedBorder(container)
	CreateHeader(container)
	local content = CreateContent(container)
	CreateInputSection(content)
	CreateButtons(content)
	CreateStatus(content)
	CreateButtonGlow(UI.Buttons.Submit, Colors.HoverPrimary, Colors.Primary)
	CreateButtonGlow(UI.Buttons.GetKey, Colors.HoverGetKey, Colors.GetKey)
	UpdateCharCounter()
	ConnectEvents()
	StartAnimationLoops()
	PlayEntranceAnimation()
end

Initialize()
