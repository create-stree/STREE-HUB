-- Elements/Textbox.lua
local TweenService = game:GetService("TweenService")

local module = {}

function module:Create(parent, config)
	local textboxFrame = Instance.new("Frame")
	local titleLabel = Instance.new("TextLabel")
	local descLabel = Instance.new("TextLabel")
	local textbox = Instance.new("TextBox")
	local placeholderLabel = Instance.new("TextLabel")
	
	textboxFrame.Name = "TextboxFrame"
	textboxFrame.Size = UDim2.new(1, -20, 0, 60)
	textboxFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	textboxFrame.BorderSizePixel = 0
	textboxFrame.Parent = parent
	
	local frameGlow = Instance.new("UIStroke")
	frameGlow.Parent = textboxFrame
	frameGlow.Color = Color3.new(0, 1, 0)
	frameGlow.Thickness = 1
	frameGlow.Transparency = 0.5
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = textboxFrame
	
	-- Title
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.7, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.Title or "Textbox"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = textboxFrame
	
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
	descLabel.Parent = textboxFrame
	
	-- Textbox
	textbox.Name = "Textbox"
	textbox.Size = UDim2.new(0, 150, 0, 30)
	textbox.Position = UDim2.new(1, -160, 0.5, -15)
	textbox.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	textbox.TextColor3 = Color3.new(1, 1, 1)
	textbox.Text = config.Default or ""
	textbox.PlaceholderText = config.Placeholder or "Type here..."
	textbox.TextSize = 12
	textbox.Font = Enum.Font.Gotham
	textbox.ClearTextOnFocus = false
	textbox.Parent = textboxFrame
	
	local textboxGlow = Instance.new("UIStroke")
	textboxGlow.Parent = textbox
	textboxGlow.Color = Color3.new(0, 1, 0)
	textboxGlow.Thickness = 1
	
	local textboxCorner = Instance.new("UICorner")
	textboxCorner.CornerRadius = UDim.new(0, 4)
	textboxCorner.Parent = textbox
	
	local padding = Instance.new("UIPadding")
	padding.Parent = textbox
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	
	-- Focus effects
	textbox.Focused:Connect(function()
		TweenService:Create(textboxGlow, TweenInfo.new(0.2), {
			Transparency = 0
		}):Play()
		TweenService:Create(textbox, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
		}):Play()
	end)
	
	textbox.FocusLost:Connect(function()
		TweenService:Create(textboxGlow, TweenInfo.new(0.2), {
			Transparency = 0.5
		}):Play()
		TweenService:Create(textbox, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		}):Play()
		
		if config.Callback then
			config.Callback(textbox.Text)
		end
	end)
	
	-- Numeric validation
	if config.Numeric then
		textbox:GetPropertyChangedSignal("Text"):Connect(function()
			local text = textbox.Text
			if text == "" then return end
			
			if not tonumber(text) then
				-- Remove non-numeric characters
				local cleaned = ""
				for i = 1, #text do
					local char = text:sub(i, i)
					if tonumber(char) or char == "." or (i == 1 and char == "-") then
						cleaned = cleaned .. char
					end
				end
				textbox.Text = cleaned
			end
		end)
	end
	
	local textboxObject = {
		Frame = textboxFrame,
		Value = config.Default or "",
		
		SetValue = function(self, value)
			textbox.Text = tostring(value)
		end,
		
		SetTitle = function(self, text)
			titleLabel.Text = text
		end,
		
		SetDescription = function(self, text)
			descLabel.Text = text
		end,
		
		Destroy = function(self)
			textboxFrame:Destroy()
		end
	}
	
	return textboxObject
end

return module
