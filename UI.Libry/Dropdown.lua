-- Elements/Dropdown.lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local module = {}

function module:Create(parent, config)
	local dropdownFrame = Instance.new("Frame")
	local titleLabel = Instance.new("TextLabel")
	local descLabel = Instance.new("TextLabel")
	local dropdownButton = Instance.new("TextButton")
	local dropdownText = Instance.new("TextLabel")
	local dropdownIcon = Instance.new("ImageLabel")
	local dropdownList = Instance.new("ScrollingFrame")
	local listLayout = Instance.new("UIListLayout")
	
	dropdownFrame.Name = "DropdownFrame"
	dropdownFrame.Size = UDim2.new(1, -20, 0, 60)
	dropdownFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	dropdownFrame.BorderSizePixel = 0
	dropdownFrame.ClipsDescendants = true
	dropdownFrame.Parent = parent
	
	local frameGlow = Instance.new("UIStroke")
	frameGlow.Parent = dropdownFrame
	frameGlow.Color = Color3.new(0, 1, 0)
	frameGlow.Thickness = 1
	frameGlow.Transparency = 0.5
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = dropdownFrame
	
	-- Title
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.7, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.Title or "Dropdown"
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = dropdownFrame
	
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
	descLabel.Parent = dropdownFrame
	
	-- Dropdown Button
	dropdownButton.Name = "DropdownButton"
	dropdownButton.Size = UDim2.new(0, 150, 0, 30)
	dropdownButton.Position = UDim2.new(1, -160, 0.5, -15)
	dropdownButton.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	dropdownButton.Text = ""
	dropdownButton.ZIndex = 2
	dropdownButton.Parent = dropdownFrame
	
	local buttonGlow = Instance.new("UIStroke")
	buttonGlow.Parent = dropdownButton
	buttonGlow.Color = Color3.new(0, 1, 0)
	buttonGlow.Thickness = 1
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 4)
	buttonCorner.Parent = dropdownButton
	
	-- Dropdown Text
	dropdownText.Name = "DropdownText"
	dropdownText.Size = UDim2.new(1, -30, 1, 0)
	dropdownText.Position = UDim2.new(0, 8, 0, 0)
	dropdownText.BackgroundTransparency = 1
	dropdownText.Text = config.Default or "Select..."
	dropdownText.TextColor3 = Color3.new(1, 1, 1)
	dropdownText.TextSize = 12
	dropdownText.Font = Enum.Font.Gotham
	dropdownText.TextXAlignment = Enum.TextXAlignment.Left
	dropdownText.ClipsDescendants = true
	dropdownText.Parent = dropdownButton
	
	-- Dropdown Icon
	dropdownIcon.Name = "DropdownIcon"
	dropdownIcon.Size = UDim2.new(0, 16, 0, 16)
	dropdownIcon.Position = UDim2.new(1, -20, 0.5, -8)
	dropdownIcon.BackgroundTransparency = 1
	dropdownIcon.Image = "rbxassetid://10709790948"
	dropdownIcon.ImageColor3 = Color3.new(0, 1, 0)
	dropdownIcon.Parent = dropdownButton
	
	-- Dropdown List
	dropdownList.Name = "DropdownList"
	dropdownList.Size = UDim2.new(0, 150, 0, 0)
	dropdownList.Position = UDim2.new(1, -160, 1, 5)
	dropdownList.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
	dropdownList.BorderSizePixel = 0
	dropdownList.ScrollBarThickness = 4
	dropdownList.ScrollBarImageColor3 = Color3.new(0, 1, 0)
	dropdownList.Visible = false
	dropdownList.ZIndex = 3
	dropdownList.Parent = dropdownFrame
	
	local listGlow = Instance.new("UIStroke")
	listGlow.Parent = dropdownList
	listGlow.Color = Color3.new(0, 1, 0)
	listGlow.Thickness = 1
	listGlow.ZIndex = 3
	
	local listCorner = Instance.new("UICorner")
	listCorner.CornerRadius = UDim.new(0, 4)
	listCorner.Parent = dropdownList
	
	listLayout.Parent = dropdownList
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 2)
	
	local padding = Instance.new("UIPadding")
	padding.Parent = dropdownList
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	
	local options = config.Options or {}
	local isMulti = config.Multi or false
	local isOpen = false
	
	-- Handle different value types for single vs multi
	local selectedOption
	local selectedOptions = {}
	
	if isMulti then
		selectedOptions = config.Default or {}
		selectedOption = nil
		dropdownText.Text = #selectedOptions > 0 and table.concat(selectedOptions, ", ") or "Select..."
	else
		selectedOption = config.Default or nil
		selectedOptions = {}
		dropdownText.Text = selectedOption or "Select..."
	end
	
	local function updateListSize()
		local contentSize = listLayout.AbsoluteContentSize
		dropdownList.Size = UDim2.new(0, 150, 0, math.min(contentSize.Y + 10, 150))
		dropdownList.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
	end
	
	local function updateDisplayText()
		if isMulti then
			if #selectedOptions > 0 then
				dropdownText.Text = #selectedOptions == 1 and selectedOptions[1] or #selectedOptions .. " selected"
			else
				dropdownText.Text = "Select..."
			end
		else
			dropdownText.Text = selectedOption or "Select..."
		end
	end
	
	local function createOption(optionText)
		local optionButton = Instance.new("TextButton")
		local optionLabel = Instance.new("TextLabel")
		local checkIcon = Instance.new("ImageLabel")
		
		optionButton.Name = "OptionButton"
		optionButton.Size = UDim2.new(1, 0, 0, 25)
		optionButton.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
		optionButton.Text = ""
		optionButton.ZIndex = 4
		optionButton.Parent = dropdownList
		
		local optionGlow = Instance.new("UIStroke")
		optionGlow.Parent = optionButton
		optionGlow.Color = Color3.new(0, 1, 0)
		optionGlow.Thickness = 1
		optionGlow.Transparency = 0.7
		optionGlow.ZIndex = 4
		
		local optionCorner = Instance.new("UICorner")
		optionCorner.CornerRadius = UDim.new(0, 3)
		optionCorner.Parent = optionButton
		
		-- Check icon for multi-select
		checkIcon.Name = "CheckIcon"
		checkIcon.Size = UDim2.new(0, 12, 0, 12)
		checkIcon.Position = UDim2.new(0, 5, 0.5, -6)
		checkIcon.BackgroundTransparency = 1
		checkIcon.Image = "rbxassetid://10709791562"
		checkIcon.ImageColor3 = Color3.new(0, 1, 0)
		checkIcon.Visible = false
		checkIcon.ZIndex = 4
		checkIcon.Parent = optionButton
		
		optionLabel.Name = "OptionLabel"
		optionLabel.Size = UDim2.new(1, isMulti and -25 or -10, 1, 0)
		optionLabel.Position = UDim2.new(0, isMulti and 22 : 5, 0, 0)
		optionLabel.BackgroundTransparency = 1
		optionLabel.Text = optionText
		optionLabel.TextColor3 = Color3.new(1, 1, 1)
		optionLabel.TextSize = 11
		optionLabel.Font = Enum.Font.Gotham
		optionLabel.TextXAlignment = Enum.TextXAlignment.Left
		optionLabel.ZIndex = 4
		optionLabel.Parent = optionButton
		
		local function updateOptionAppearance()
			if isMulti then
				local isSelected = table.find(selectedOptions, optionText)
				checkIcon.Visible = isSelected ~= nil
				if isSelected then
					optionLabel.TextColor3 = Color3.new(0, 1, 0)
					optionButton.BackgroundColor3 = Color3.new(0.2, 0.3, 0.2)
				else
					optionLabel.TextColor3 = Color3.new(1, 1, 1)
					optionButton.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
				end
			else
				local isSelected = (selectedOption == optionText)
				if isSelected then
					optionLabel.TextColor3 = Color3.new(0, 1, 0)
					optionButton.BackgroundColor3 = Color3.new(0.2, 0.3, 0.2)
				else
					optionLabel.TextColor3 = Color3.new(1, 1, 1)
					optionButton.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
				end
			end
		end
		
		optionButton.MouseEnter:Connect(function()
			if not (isMulti and table.find(selectedOptions, optionText)) and not (not isMulti and selectedOption == optionText) then
				TweenService:Create(optionButton, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
				}):Play()
			end
		end)
		
		optionButton.MouseLeave:Connect(function()
			if not (isMulti and table.find(selectedOptions, optionText)) and not (not isMulti and selectedOption == optionText) then
				TweenService:Create(optionButton, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
				}):Play()
			end
		end)
		
		optionButton.MouseButton1Click:Connect(function()
			if isMulti then
				-- Multi-select logic
				local existingIndex = table.find(selectedOptions, optionText)
				if existingIndex then
					table.remove(selectedOptions, existingIndex)
				else
					table.insert(selectedOptions, optionText)
				end
				updateDisplayText()
				updateOptionAppearance()
				
				if config.Callback then
					config.Callback(selectedOptions)
				end
			else
				-- Single-select logic
				selectedOption = optionText
				isOpen = false
				dropdownList.Visible = false
				updateDisplayText()
				updateOptionAppearance()
				TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
					Rotation = 0
				}):Play()
				
				if config.Callback then
					config.Callback(optionText)
				end
			end
		end)
		
		updateOptionAppearance()
	end
	
	-- Create options
	for _, option in ipairs(options) do
		createOption(option)
	end
	
	updateListSize()
	
	dropdownButton.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		dropdownList.Visible = isOpen
		
		if isOpen then
			TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
				Rotation = 180
			}):Play()
		else
			TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
				Rotation = 0
			}):Play()
		end
	end)
	
	-- Close dropdown when clicking outside
	UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
			local mousePos = input.Position
			local buttonAbsolutePos = dropdownButton.AbsolutePosition
			local buttonAbsoluteSize = dropdownButton.AbsoluteSize
			local listAbsolutePos = dropdownList.AbsolutePosition
			local listAbsoluteSize = dropdownList.AbsoluteSize
			
			if not (mousePos.X >= buttonAbsolutePos.X and mousePos.X <= buttonAbsolutePos.X + buttonAbsoluteSize.X and
					mousePos.Y >= buttonAbsolutePos.Y and mousePos.Y <= buttonAbsolutePos.Y + buttonAbsoluteSize.Y) and
			   not (mousePos.X >= listAbsolutePos.X and mousePos.X <= listAbsolutePos.X + listAbsoluteSize.X and
					mousePos.Y >= listAbsolutePos.Y and mousePos.Y <= listAbsolutePos.Y + listAbsoluteSize.Y) then
				isOpen = false
				dropdownList.Visible = false
				TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
					Rotation = 0
				}):Play()
			end
		end
	end)
	
	local dropdownObject = {
		Frame = dropdownFrame,
		Value = isMulti and selectedOptions or selectedOption,
		IsMulti = isMulti,
		
		SetValue = function(self, value)
			if isMulti then
				if type(value) == "table" then
					selectedOptions = {}
					for _, option in ipairs(value) do
						if table.find(options, option) then
							table.insert(selectedOptions, option)
						end
					end
				end
			else
				if table.find(options, value) then
					selectedOption = value
				end
			end
			updateDisplayText()
			
			-- Update all option appearances
			for _, child in ipairs(dropdownList:GetChildren()) do
				if child:IsA("TextButton") and child:FindFirstChild("OptionLabel") then
					local optionText = child.OptionLabel.Text
					if isMulti then
						local isSelected = table.find(selectedOptions, optionText)
						child.CheckIcon.Visible = isSelected ~= nil
						if isSelected then
							child.OptionLabel.TextColor3 = Color3.new(0, 1, 0)
							child.BackgroundColor3 = Color3.new(0.2, 0.3, 0.2)
						else
							child.OptionLabel.TextColor3 = Color3.new(1, 1, 1)
							child.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
						end
					else
						local isSelected = (selectedOption == optionText)
						if isSelected then
							child.OptionLabel.TextColor3 = Color3.new(0, 1, 0)
							child.BackgroundColor3 = Color3.new(0.2, 0.3, 0.2)
						else
							child.OptionLabel.TextColor3 = Color3.new(1, 1, 1)
							child.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
						end
					end
				end
			end
		end,
		
		SetOptions = function(self, newOptions)
			-- Clear existing options
			for _, child in ipairs(dropdownList:GetChildren()) do
				if child:IsA("TextButton") then
					child:Destroy()
				end
			end
			
			-- Create new options
			options = newOptions
			for _, option in ipairs(newOptions) do
				createOption(option)
			end
			
			updateListSize()
		end,
		
		SetTitle = function(self, text)
			titleLabel.Text = text
		end,
		
		SetDescription = function(self, text)
			descLabel.Text = text
		end,
		
		ClearSelection = function(self)
			if isMulti then
				selectedOptions = {}
			else
				selectedOption = nil
			end
			updateDisplayText()
			
			-- Reset all option appearances
			for _, child in ipairs(dropdownList:GetChildren()) do
				if child:IsA("TextButton") then
					child.OptionLabel.TextColor3 = Color3.new(1, 1, 1)
					child.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
					if child:FindFirstChild("CheckIcon") then
						child.CheckIcon.Visible = false
					end
				end
			end
		end,
		
		Destroy = function(self)
			dropdownFrame:Destroy()
		end
	}
	
	return dropdownObject
end

return module
