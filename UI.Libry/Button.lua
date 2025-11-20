-- Elements/Button.lua
local TweenService = game:GetService("TweenService")

local module = {}

function module:Create(parent, config)
	local buttonFrame = Instance.new("Frame")
	local button = Instance.new("TextButton")
	local titleLabel = Instance.new("TextLabel")
	local descLabel = Instance.new("TextLabel")
	
	buttonFrame.Name = "ButtonFrame"
	buttonFrame.Size = UDim2.new(1, -20, 0, 60)
	buttonFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Parent = parent
	
	local frameGlow = Instance.new("UIStroke")
	frameGlow.Parent = buttonFrame
	frameGlow.Color = Color3.new(0, 1, 0)
	frameGlow.Thickness = 1
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = buttonFrame
	
	-- Title
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.Title or "Button"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = buttonFrame
	
	-- Description
	descLabel.Name = "DescLabel"
	descLabel.Size = UDim2.new(1, -20, 0, 14)
	descLabel.Position = UDim2.new(0, 10, 0, 30)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = config.Description or ""
	descLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
	descLabel.TextSize = 12
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.Parent = buttonFrame
	
	-- Actual button
	button.Name = "Button"
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.ZIndex = 2
	button.Parent = buttonFrame
	
	local buttonObject = {
		Frame = buttonFrame,
		Button = button,
		Title = titleLabel,
		Description = descLabel
	}
	
	-- Hover effects
	button.MouseEnter:Connect(function()
		TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		}):Play()
		TweenService:Create(frameGlow, TweenInfo.new(0.2), {
			Transparency = 0
		}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.new(0, 0, 0)
		}):Play()
		TweenService:Create(frameGlow, TweenInfo.new(0.2), {
			Transparency = 0.5
		}):Play()
	end)
	
	button.MouseButton1Down:Connect(function()
		TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		}):Play()
	end)
	
	button.MouseButton1Up:Connect(function()
		TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		}):Play()
		
		if config.Callback then
			config.Callback()
		end
	end)
	
	function buttonObject:SetTitle(text)
		titleLabel.Text = text
	end
	
	function buttonObject:SetDescription(text)
		descLabel.Text = text
	end
	
	function buttonObject:Destroy()
		buttonFrame:Destroy()
	end
	
	return buttonObject
end

return module
