-- Elements/Toggle.lua
local TweenService = game:GetService("TweenService")

local module = {}

function module:Create(parent, config)
	local toggleFrame = Instance.new("Frame")
	local titleLabel = Instance.new("TextLabel")
	local descLabel = Instance.new("TextLabel")
	local toggleButton = Instance.new("TextButton")
	local toggleSlider = Instance.new("Frame")
	local toggleCircle = Instance.new("Frame")
	
	toggleFrame.Name = "ToggleFrame"
	toggleFrame.Size = UDim2.new(1, -20, 0, 60)
	toggleFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	toggleFrame.BorderSizePixel = 0
	toggleFrame.Parent = parent
	
	local frameGlow = Instance.new("UIStroke")
	frameGlow.Parent = toggleFrame
	frameGlow.Color = Color3.new(0, 1, 0)
	frameGlow.Thickness = 1
	frameGlow.Transparency = 0.5
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = toggleFrame
	
	-- Title
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.7, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.Title or "Toggle"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = toggleFrame
	
	-- Description
	descLabel.Name = "DescLabel"
	descLabel.Size = UDim2.new(0.7, -10, 0, 14)
	descLabel.Position = UDim2.new(0, 10, 0, 30)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = config.Description or ""
	descLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
	descLabel.TextSize = 12
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = toggleFrame
	
	-- Toggle Slider
	toggleSlider.Name = "ToggleSlider"
	toggleSlider.Size = UDim2.new(0, 40, 0, 20)
	toggleSlider.Position = UDim2.new(1, -50, 0.5, -10)
	toggleSlider.AnchorPoint = Vector2.new(1, 0.5)
	toggleSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	toggleSlider.BorderSizePixel = 0
	toggleSlider.Parent = toggleFrame
	
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(0, 10)
	sliderCorner.Parent = toggleSlider
	
	local sliderGlow = Instance.new("UIStroke")
	sliderGlow.Parent = toggleSlider
	sliderGlow.Color = Color3.new(0, 1, 0)
	sliderGlow.Thickness = 1
	
	-- Toggle Circle
	toggleCircle.Name = "ToggleCircle"
	toggleCircle.Size = UDim2.new(0, 16, 0, 16)
	toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
	toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
	toggleCircle.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
	toggleCircle.BorderSizePixel = 0
	toggleCircle.Parent = toggleSlider
	
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(0, 8)
	circleCorner.Parent = toggleCircle
	
	-- Toggle Button
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(1, 0, 1, 0)
	toggleButton.BackgroundTransparency = 1
	toggleButton.Text = ""
	toggleButton.ZIndex = 2
	toggleButton.Parent = toggleFrame
	
	local isToggled = config.Default or false
	updateToggle()
	
	function updateToggle()
		if isToggled then
			TweenService:Create(toggleSlider, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.new(0, 0.5, 0)
			}):Play()
			TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.new(0, 1, 0),
				Position = UDim2.new(1, -18, 0.5, -8)
			}):Play()
		else
			TweenService:Create(toggleSlider, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			}):Play()
			TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.new(0.5, 0.5, 0.5),
				Position = UDim2.new(0, 2, 0.5, -8)
			}):Play()
		end
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		isToggled = not isToggled
		updateToggle()
		
		if config.Callback then
			config.Callback(isToggled)
		end
	end)
	
	local toggleObject = {
		Frame = toggleFrame,
		Value = isToggled,
		
		SetValue = function(self, value)
			isToggled = value
			updateToggle()
		end,
		
		SetTitle = function(self, text)
			titleLabel.Text = text
		end,
		
		SetDescription = function(self, text)
			descLabel.Text = text
		end,
		
		Destroy = function(self)
			toggleFrame:Destroy()
		end
	}
	
	return toggleObject
end

return module
