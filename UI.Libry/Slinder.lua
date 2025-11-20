-- Elements/Slider.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local module = {}

function module:Create(parent, config)
	local sliderFrame = Instance.new("Frame")
	local titleLabel = Instance.new("TextLabel")
	local valueLabel = Instance.new("TextLabel")
	local sliderTrack = Instance.new("Frame")
	local sliderFill = Instance.new("Frame")
	local sliderButton = Instance.new("TextButton")
	
	sliderFrame.Name = "SliderFrame"
	sliderFrame.Size = UDim2.new(1, -20, 0, 70)
	sliderFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	sliderFrame.BorderSizePixel = 0
	sliderFrame.Parent = parent
	
	local frameGlow = Instance.new("UIStroke")
	frameGlow.Parent = sliderFrame
	frameGlow.Color = Color3.new(0, 1, 0)
	frameGlow.Thickness = 1
	frameGlow.Transparency = 0.5
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = sliderFrame
	
	-- Title
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.Title or "Slider"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = sliderFrame
	
	-- Value display
	valueLabel.Name = "ValueLabel"
	valueLabel.Size = UDim2.new(0, 60, 0, 20)
	valueLabel.Position = UDim2.new(1, -70, 0, 8)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(config.Default or config.Min or 0)
	valueLabel.TextColor3 = Color3.new(0, 1, 0)
	valueLabel.TextSize = 14
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = sliderFrame
	
	-- Slider track
	sliderTrack.Name = "SliderTrack"
	sliderTrack.Size = UDim2.new(1, -20, 0, 6)
	sliderTrack.Position = UDim2.new(0, 10, 1, -25)
	sliderTrack.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	sliderTrack.BorderSizePixel = 0
	sliderTrack.Parent = sliderFrame
	
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0, 3)
	trackCorner.Parent = sliderTrack
	
	local trackGlow = Instance.new("UIStroke")
	trackGlow.Parent = sliderTrack
	trackGlow.Color = Color3.new(0, 1, 0)
	trackGlow.Thickness = 1
	
	-- Slider fill
	sliderFill.Name = "SliderFill"
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.new(0, 1, 0)
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderTrack
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 3)
	fillCorner.Parent = sliderFill
	
	-- Slider button
	sliderButton.Name = "SliderButton"
	sliderButton.Size = UDim2.new(0, 16, 0, 16)
	sliderButton.Position = UDim2.new(0, -8, 0.5, -8)
	sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
	sliderButton.Text = ""
	sliderButton.ZIndex = 2
	sliderButton.Parent = sliderTrack
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = sliderButton
	
	local buttonGlow = Instance.new("UIStroke")
	buttonGlow.Parent = sliderButton
	buttonGlow.Color = Color3.new(0, 1, 0)
	buttonGlow.Thickness = 2
	
	local minValue = config.Min or 0
	local maxValue = config.Max or 100
	local currentValue = config.Default or minValue
	local rounding = config.Rounding or 0
	
	local dragging = false
	
	function updateSlider(value)
		currentValue = math.clamp(value, minValue, maxValue)
		if rounding > 0 then
			currentValue = math.floor(currentValue * (10 ^ rounding)) / (10 ^ rounding)
		end
		
		local percentage = (currentValue - minValue) / (maxValue - minValue)
		sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		sliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
		valueLabel.Text = tostring(currentValue)
		
		if config.Callback then
			config.Callback(currentValue)
		end
	end
	
	sliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	
	sliderButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local sliderAbsolutePos = sliderTrack.AbsolutePosition.X
			local sliderAbsoluteSize = sliderTrack.AbsoluteSize.X
			local mouseX = input.Position.X
			
			local percentage = math.clamp((mouseX - sliderAbsolutePos) / sliderAbsoluteSize, 0, 1)
			local value = minValue + (percentage * (maxValue - minValue))
			
			updateSlider(value)
		end
	end)
	
	-- Initialize
	updateSlider(currentValue)
	
	local sliderObject = {
		Frame = sliderFrame,
		Value = currentValue,
		
		SetValue = function(self, value)
			updateSlider(value)
		end,
		
		SetTitle = function(self, text)
			titleLabel.Text = text
		end,
		
		Destroy = function(self)
			sliderFrame:Destroy()
		end
	}
	
	return sliderObject
end

return module
