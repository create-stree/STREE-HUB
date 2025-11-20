-- Elements/Label.lua
local module = {}

function module:Create(parent, config)
	local labelFrame = Instance.new("Frame")
	local titleLabel = Instance.new("TextLabel")
	local descLabel = Instance.new("TextLabel")
	
	labelFrame.Name = "LabelFrame"
	labelFrame.Size = UDim2.new(1, -20, 0, config.Compact and 30 or 50)
	labelFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	labelFrame.BorderSizePixel = 0
	labelFrame.Parent = parent
	
	local frameGlow = Instance.new("UIStroke")
	frameGlow.Parent = labelFrame
	frameGlow.Color = Color3.new(0, 1, 0)
	frameGlow.Thickness = 1
	frameGlow.Transparency = 0.5
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = labelFrame
	
	-- Title
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -20, config.Compact and 1 or 0.5, config.Compact and 0 or -10)
	titleLabel.Position = UDim2.new(0, 10, 0, config.Compact and 0 or 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.Title or "Label"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = config.Compact and 12 or 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = labelFrame
	
	if not config.Compact then
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
		descLabel.Parent = labelFrame
	end
	
	local labelObject = {
		Frame = labelFrame,
		
		SetTitle = function(self, text)
			titleLabel.Text = text
		end,
		
		SetDescription = function(self, text)
			if not config.Compact then
				descLabel.Text = text
			end
		end,
		
		SetColor = function(self, color)
			titleLabel.TextColor3 = color
		end,
		
		Destroy = function(self)
			labelFrame:Destroy()
		end
	}
	
	return labelObject
end

return module
