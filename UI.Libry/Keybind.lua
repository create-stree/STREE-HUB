-- Elements/Keybind.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local module = {}

function module:Create(parent, config)
	local keybindFrame = Instance.new("Frame")
	local titleLabel = Instance.new("TextLabel")
	local descLabel = Instance.new("TextLabel")
	local keybindButton = Instance.new("TextButton")
	local keybindText = Instance.new("TextLabel")
	
	keybindFrame.Name = "KeybindFrame"
	keybindFrame.Size = UDim2.new(1, -20, 0, 60)
	keybindFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	keybindFrame.BorderSizePixel = 0
	keybindFrame.Parent = parent
	
	local frameGlow = Instance.new("UIStroke")
	frameGlow.Parent = keybindFrame
	frameGlow.Color = Color3.new(0, 1, 0)
	frameGlow.Thickness = 1
	frameGlow.Transparency = 0.5
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = keybindFrame
	
	-- Title
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.7, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.Title or "Keybind"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = keybindFrame
	
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
	descLabel.Parent = keybindFrame
	
	-- Keybind Button
	keybindButton.Name = "KeybindButton"
	keybindButton.Size = UDim2.new(0, 80, 0, 30)
	keybindButton.Position = UDim2.new(1, -90, 0.5, -15)
	keybindButton.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	keybindButton.Text = ""
	keybindButton.ZIndex = 2
	keybindButton.Parent = keybindFrame
	
	local buttonGlow = Instance.new("UIStroke")
	buttonGlow.Parent = keybindButton
	buttonGlow.Color = Color3.new(0, 1, 0)
	buttonGlow.Thickness = 1
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 4)
	buttonCorner.Parent = keybindButton
	
	-- Keybind Text
	keybindText.Name = "KeybindText"
	keybindText.Size = UDim2.new(1, 0, 1, 0)
	keybindText.BackgroundTransparency = 1
	keybindText.Text = config.Default or "None"
	keybindText.TextColor3 = Color3.new(1, 1, 1)
	keybindText.TextSize = 12
	keybindText.Font = Enum.Font.Gotham
	keybindText.Parent = keybindButton
	
	local currentKey = config.Default or "None"
	local listening = false
	
	local function setKey(key)
		currentKey = key
		keybindText.Text = key
		listening = false
		
		TweenService:Create(keybindButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		}):Play()
		
		if config.Callback then
			config.Callback(key)
		end
	end
	
	keybindButton.MouseButton1Click:Connect(function()
		if not listening then
			listening = true
			keybindText.Text = "..."
			TweenService:Create(keybindButton, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.new(0.2, 0.1, 0.1)
			}):Play()
		end
	end)
	
	-- Key detection
	local connection
	connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if listening then
			local key = ""
			
			if input.UserInputType == Enum.UserInputType.Keyboard then
				key = input.KeyCode.Name
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				key = "MouseButton1"
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
				key = "MouseButton2"
			elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
				key = "MouseButton3"
			end
			
			if key ~= "" then
				setKey(key)
			end
		else
			-- Check if current key is pressed
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
				if config.PressCallback then
					config.PressCallback()
				end
			elseif (input.UserInputType == Enum.UserInputType.MouseButton1 and currentKey == "MouseButton1") or
				   (input.UserInputType == Enum.UserInputType.MouseButton2 and currentKey == "MouseButton2") or
				   (input.UserInputType == Enum.UserInputType.MouseButton3 and currentKey == "MouseButton3") then
				if config.PressCallback then
					config.PressCallback()
				end
			end
		end
	end)
	
	local keybindObject = {
		Frame = keybindFrame,
		Value = currentKey,
		
		SetKey = function(self, key)
			setKey(key)
		end,
		
		SetTitle = function(self, text)
			titleLabel.Text = text
		end,
		
		SetDescription = function(self, text)
			descLabel.Text = text
		end,
		
		Destroy = function(self)
			if connection then
				connection:Disconnect()
			end
			keybindFrame:Destroy()
		end
	}
	
	return keybindObject
end

return module
