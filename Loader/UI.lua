-- STREE HUB - Loader & UI Final  
repeat task.wait() until game:IsLoaded()  
  
local Players = game:GetService("Players")  
local TweenService = game:GetService("TweenService")  
local UserInputService = game:GetService("UserInputService")  
local LocalPlayer = Players.LocalPlayer  
  
-- Parent GUI  
local success, result = pcall(function()  
    return game:GetService("CoreGui")  
end)  
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")  
  
-- ====== UTIL: DRAGGABLE ======  
local function MakeDraggable(frame:Frame, dragHandle: GuiObject?)  
    dragHandle = dragHandle or frame  
    local dragging, dragStart, startPos = false, nil, nil  
  
    local function update(input)  
        local delta = input.Position - dragStart  
        frame.Position = UDim2.new(  
            startPos.X.Scale, startPos.X.Offset + delta.X,  
            startPos.Y.Scale, startPos.Y.Offset + delta.Y  
        )  
    end  
  
    dragHandle.InputBegan:Connect(function(input)  
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
            dragging = true  
            dragStart = input.Position  
            startPos = frame.Position  
            input.Changed:Connect(function()  
                if input.UserInputState == Enum.UserInputState.End then  
                    dragging = false  
                end  
            end)  
        end  
    end)  
  
    dragHandle.InputChanged:Connect(function(input)  
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then  
            if dragging then  
                update(input)  
            end  
        end  
    end)  
end  
  
-- ====== STYLE HELPERS ======  
local function corner(parent, r)  
    local c = Instance.new("UICorner", parent)  
    c.CornerRadius = UDim.new(0, r or 8)  
    return c  
end  
  
local function stroke(parent, color, th)  
    local s = Instance.new("UIStroke", parent)  
    s.Color = color or Color3.fromRGB(0, 255, 0)  
    s.Thickness = th or 2  
    s.Transparency = 0.15  
    return s  
end  
  
-- ====== Main UI ======  
local function buildMainUI()  
    if parentGui:FindFirstChild("STREE_HUB_UI") then parentGui.STREE_HUB_UI:Destroy() end  
  
    local ui = Instance.new("ScreenGui", parentGui)  
    ui.Name = "STREE_HUB_UI"  
    ui.IgnoreGuiInset = true  
    ui.ResetOnSpawn = false  
  
    -- Toggle logo  
    local logoButton = Instance.new("ImageButton", ui)  
    logoButton.Name = "HubIcon"  
    logoButton.Size = UDim2.new(0, 44, 0, 44)  
    logoButton.Position = UDim2.new(0, 120, 0.8, 0)  
    logoButton.Image = "rbxassetid://123032091977400"  
    logoButton.BackgroundTransparency = 1  
    MakeDraggable(logoButton, logoButton)  
  
    -- Window  
    local window = Instance.new("Frame", ui)  
    window.Name = "MainWindow"  
    window.Size = UDim2.new(0, 560, 0, 360)  
    window.Position = UDim2.new(0.5, -280, 0.5, -180)  
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)  
    window.BorderSizePixel = 0  
    corner(window, 14)  
    stroke(window, Color3.fromRGB(0,255,0), 2)  
  
    local titleBar = Instance.new("Frame", window)  
    titleBar.Size = UDim2.new(1, -20, 0, 42)  
    titleBar.Position = UDim2.new(0, 10, 0, 8)  
    titleBar.BackgroundTransparency = 1  
  
    local headerLogo = Instance.new("ImageLabel", titleBar)  
    headerLogo.Size = UDim2.new(0, 30, 0, 30)  
    headerLogo.Position = UDim2.new(0,5,0,6)  
    headerLogo.Image = "rbxassetid://123032091977400"  
    headerLogo.BackgroundTransparency = 1  
  
    local title = Instance.new("TextLabel", titleBar)  
    title.Text = "STREE HUB | Fish It | Version Developer"  
    title.Size = UDim2.new(1, -120, 1, 0)  
    title.Position = UDim2.new(0,40,0,0)  
    title.TextSize = 22  
    title.Font = Enum.Font.GothamBold  
    title.TextColor3 = Color3.fromRGB(0,255,100)  
    title.BackgroundTransparency = 1  
  
    local closeBtn = Instance.new("TextButton", titleBar)  
    closeBtn.Size = UDim2.new(0, 34, 0, 30)  
    closeBtn.Position = UDim2.new(1,-36,0,6)  
    closeBtn.Text = "X"  
    closeBtn.TextColor3 = Color3.fromRGB(255,80,80)  
    closeBtn.Font = Enum.Font.GothamBold  
    closeBtn.TextSize = 16  
    closeBtn.BackgroundTransparency = 1  
    closeBtn.MouseButton1Click:Connect(function() ui:Destroy() end)  
  
    local minimizeBtn = Instance.new("TextButton", titleBar)  
    minimizeBtn.Size = UDim2.new(0, 34, 0, 30)  
    minimizeBtn.Position = UDim2.new(1,-72,0,6)  
    minimizeBtn.Text = "-"  
    minimizeBtn.TextColor3 = Color3.fromRGB(255,255,80)  
    minimizeBtn.Font = Enum.Font.GothamBold  
    minimizeBtn.TextSize = 16  
    minimizeBtn.BackgroundTransparency = 1  
    minimizeBtn.MouseButton1Click:Connect(function() window.Visible = false end)  
  
    logoButton.MouseButton1Click:Connect(function()  
        window.Visible = not window.Visible  
    end)  
  
    -- Tab kanan  
    local tabMenu = Instance.new("Frame", window)  
    tabMenu.Size = UDim2.new(0,140,1,-60)  
    tabMenu.Position = UDim2.new(1,-150,0,52)  
    tabMenu.BackgroundColor3 = Color3.fromRGB(40,40,40)  
    corner(tabMenu, 10)  
    stroke(tabMenu, Color3.fromRGB(0,255,120), 1)  
  
    -- Konten (ScrollingFrame supaya CanvasSize berfungsi)  
    local contentFrame = Instance.new("ScrollingFrame", window)  
    contentFrame.Size = UDim2.new(1,-180,1,-70)  
    contentFrame.Position = UDim2.new(0,15,0,55)  
    contentFrame.BackgroundTransparency = 1  
    contentFrame.CanvasSize = UDim2.new(0,0,0,0)  
    contentFrame.ScrollBarThickness = 6  
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y  
  
    local function clearContent()  
        for _,v in pairs(contentFrame:GetChildren()) do  
            if v:IsA("GuiObject") then v:Destroy() end  
        end  
    end  
  
    local yOffset = 0  
    local function nextY(h) local y=yOffset; yOffset=yOffset+h+8; return y end  
    local function resetYOffset() yOffset=0 end  
  
    local function createLabel(text)  
        local lbl = Instance.new("TextLabel", contentFrame)  
        lbl.Size = UDim2.new(1,-20,0,24)  
        lbl.Position = UDim2.new(0,10,0,nextY(24))  
        lbl.Text = text  
        lbl.TextColor3 = Color3.fromRGB(200,200,200)  
        lbl.Font = Enum.Font.GothamMedium  
        lbl.TextSize = 14  
        lbl.TextXAlignment = Enum.TextXAlignment.Left  
        lbl.BackgroundTransparency = 1  
        return lbl
    end  
  
    local function createButton(text, callback)  
        local btn = Instance.new("TextButton", contentFrame)  
        btn.Size = UDim2.new(1,-20,0,34)  
        btn.Position = UDim2.new(0,10,0,nextY(34))  
        btn.Text = text  
        btn.Font = Enum.Font.GothamBold  
        btn.TextSize = 14  
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)  
        btn.TextColor3 = Color3.fromRGB(0,255,120)  
        corner(btn, 8)  
        btn.MouseButton1Click:Connect(callback)  
        btn.MouseEnter:Connect(function()  
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(36,36,36)}):Play()  
        end)  
        btn.MouseLeave:Connect(function()  
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()  
        end)  
        return btn
    end  
  
    local function createToggleModern(text, default, callback)  
        local row = Instance.new("Frame", contentFrame)  
        row.Size = UDim2.new(1,-20,0,38)  
        row.Position = UDim2.new(0,10,0,nextY(38))  
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)  
        corner(row, 8)  
  
        local lbl = Instance.new("TextLabel", row)  
        lbl.Size = UDim2.new(1,-90,1,0)  
        lbl.Position = UDim2.new(0,10,0,0)  
        lbl.BackgroundTransparency = 1  
        lbl.TextXAlignment = Enum.TextXAlignment.Left  
        lbl.Font = Enum.Font.Gotham  
        lbl.TextSize = 14  
        lbl.TextColor3 = Color3.fromRGB(220,220,220)  
        lbl.Text = text  
  
        local switch = Instance.new("TextButton", row)  
        switch.AutoButtonColor = false  
        switch.Text = ""  
        switch.Size = UDim2.new(0, 56, 0, 24)  
        switch.Position = UDim2.new(1, -66, 0.5, -12)  
        switch.BackgroundColor3 = Color3.fromRGB(60,60,60)  
        corner(switch, 12)  
  
        local knob = Instance.new("Frame", switch)  
        knob.Size = UDim2.new(0, 20, 0, 20)  
        knob.Position = UDim2.new(0, 2, 0.5, -10)  
        knob.BackgroundColor3 = Color3.fromRGB(245,245,245)  
        corner(knob, 10)  
        stroke(knob, Color3.fromRGB(0,0,0), 1)  
  
        local state = default and true or false  
        local function apply(animated)  
            local bg = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60,60,60)  
            local x = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)  
            if animated then  
                TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = bg}):Play()  
                TweenService:Create(knob, TweenInfo.new(0.15), {Position = x}):Play()  
            else  
                switch.BackgroundColor3 = bg  
                knob.Position = x  
            end  
        end  
        apply(false)  
  
        local function toggle()  
            state = not state  
            apply(true)  
            if callback then  
                task.spawn(function()  
                    pcall(callback, state)  
                end)  
            end  
        end  
  
        switch.MouseButton1Click:Connect(toggle)
        return {Toggle = toggle, GetState = function() return state end}
    end  
  
    local function createSlider(text, min, max, default, callback)  
        local row = Instance.new("Frame", contentFrame)  
        row.Size = UDim2.new(1,-20,0,50)  
        row.Position = UDim2.new(0,10,0,nextY(50))  
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)  
        corner(row, 8)  
  
        local lbl = Instance.new("TextLabel", row)  
        lbl.Size = UDim2.new(0.5, -10, 0, 20)  
        lbl.Position = UDim2.new(0,10,0,5)  
        lbl.BackgroundTransparency = 1  
        lbl.TextXAlignment = Enum.TextXAlignment.Left  
        lbl.Font = Enum.Font.Gotham  
        lbl.TextSize = 14  
        lbl.TextColor3 = Color3.fromRGB(220,220,220)  
        lbl.Text = text  
  
        local valueLbl = Instance.new("TextLabel", row)  
        valueLbl.Size = UDim2.new(0.3, -10, 0, 20)  
        valueLbl.Position = UDim2.new(1, -110, 0, 5)  
        valueLbl.BackgroundTransparency = 1  
        valueLbl.TextXAlignment = Enum.TextXAlignment.Right  
        valueLbl.Font = Enum.Font.Gotham  
        valueLbl.TextSize = 14  
        valueLbl.TextColor3 = Color3.fromRGB(0,255,120)  
        valueLbl.Text = tostring(default)  
  
        local sliderBG = Instance.new("Frame", row)  
        sliderBG.Size = UDim2.new(1,-20,0,8)  
        sliderBG.Position = UDim2.new(0,10,1,-18)  
        sliderBG.BackgroundColor3 = Color3.fromRGB(60,60,60)  
        corner(sliderBG, 4)  
  
        local sliderFill = Instance.new("Frame", sliderBG)  
        sliderFill.Size = UDim2.new((default-min)/(max-min),0,1,0)  
        sliderFill.BackgroundColor3 = Color3.fromRGB(0,200,0)  
        corner(sliderFill, 4)  
  
        local dragging = false  
        local function update(inputPos)  
            local relative = math.clamp((inputPos.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)  
            local value = math.floor((min + (max-min) * relative) * 10)/10  
            sliderFill.Size = UDim2.new(relative,0,1,0)  
            valueLbl.Text = tostring(value)  
            if callback then pcall(callback, value) end  
        end  
        sliderBG.InputBegan:Connect(function(input)  
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
                dragging = true  
                update(input.Position)  
                input.Changed:Connect(function()  
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end  
                end)  
            end  
        end)  
        sliderBG.InputChanged:Connect(function(input)  
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then  
                update(input.Position)  
            end  
        end)  
        return {Update = function(value) 
            local relative = math.clamp((value-min)/(max-min), 0, 1)
            sliderFill.Size = UDim2.new(relative,0,1,0)
            valueLbl.Text = tostring(value)
        end}
    end

    -- ====== INPUT FIELD ======
    local function createInputField(text, placeholder, callback)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,50)
        row.Position = UDim2.new(0,10,0,nextY(50))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)
        corner(row, 8)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, -10, 0, 20)
        lbl.Position = UDim2.new(0,10,0,5)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = text

        local inputBox = Instance.new("TextBox", row)
        inputBox.Size = UDim2.new(0.55, -10, 0, 30)
        inputBox.Position = UDim2.new(0.4, 5, 0.5, -15)
        inputBox.PlaceholderText = placeholder or "Enter value..."
        inputBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
        inputBox.TextColor3 = Color3.fromRGB(255,255,255)
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 14
        inputBox.ClearTextOnFocus = false
        corner(inputBox, 6)
        stroke(inputBox, Color3.fromRGB(80,80,80), 1)

        inputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                pcall(callback, inputBox.Text)
            end
        end)

        return {
            SetText = function(text)
                inputBox.Text = text
            end,
            GetText = function()
                return inputBox.Text
            end
        }
    end

    -- ====== DROPDOWN ======
    local function createDropdown(text, options, default, callback)
        local row = Instance.new("Frame", contentFrame)
        row.Size = UDim2.new(1,-20,0,50)
        row.Position = UDim2.new(0,10,0,nextY(50))
        row.BackgroundColor3 = Color3.fromRGB(28,28,28)
        corner(row, 8)

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, -10, 0, 20)
        lbl.Position = UDim2.new(0,10,0,5)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(220,220,220)
        lbl.Text = text

        local dropdownBtn = Instance.new("TextButton", row)
        dropdownBtn.Size = UDim2.new(0.55, -10, 0, 30)
        dropdownBtn.Position = UDim2.new(0.4, 5, 0.5, -15)
        dropdownBtn.Text = default or "Select..."
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        dropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.TextSize = 14
        corner(dropdownBtn, 6)
        stroke(dropdownBtn, Color3.fromRGB(80,80,80), 1)

        local dropdownFrame = Instance.new("Frame", row)
        dropdownFrame.Size = UDim2.new(0.55, -10, 0, 0)
        dropdownFrame.Position = UDim2.new(0.4, 5, 1, 5)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = true
        corner(dropdownFrame, 6)
        dropdownFrame.Visible = false

        local dropdownScroll = Instance.new("ScrollingFrame", dropdownFrame)
        dropdownScroll.Size = UDim2.new(1,0,1,0)
        dropdownScroll.Position = UDim2.new(0,0,0,0)
        dropdownScroll.BackgroundTransparency = 1
        dropdownScroll.ScrollBarThickness = 4
        dropdownScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local dropdownLayout = Instance.new("UIListLayout", dropdownScroll)
        dropdownLayout.Padding = UDim.new(0,2)

        local isOpen = false
        local selectedOption = default

        local function toggleDropdown()
            isOpen = not isOpen
            if isOpen then
                dropdownFrame.Size = UDim2.new(0.55, -10, 0, math.min(#options * 32, 120))
                dropdownFrame.Visible = true
            else
                dropdownFrame.Size = UDim2.new(0.55, -10, 0, 0)
                dropdownFrame.Visible = false
            end
        end

        local function selectOption(option)
            selectedOption = option
            dropdownBtn.Text = option
            toggleDropdown()
            if callback then
                pcall(callback, option)
            end
        end

        dropdownBtn.MouseButton1Click:Connect(toggleDropdown)

        -- Create option buttons
        for _, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton", dropdownScroll)
            optionBtn.Size = UDim2.new(1, -10, 0, 30)
            optionBtn.Position = UDim2.new(0,5,0,0)
            optionBtn.Text = option
            optionBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            optionBtn.TextColor3 = Color3.fromRGB(255,255,255)
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.TextSize = 12
            corner(optionBtn, 4)
            
            optionBtn.MouseButton1Click:Connect(function()
                selectOption(option)
            end)
            
            optionBtn.MouseEnter:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
            end)
            
            optionBtn.MouseLeave:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
            end)
        end

        -- Close dropdown when clicking outside
        UserInputService.InputBegan:Connect(function(input)
            if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = UserInputService:GetMouseLocation()
                local absPos = dropdownFrame.AbsolutePosition
                local absSize = dropdownFrame.AbsoluteSize
                
                if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                       mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                    toggleDropdown()
                end
            end
        end)

        return {
            SetSelected = function(option)
                selectedOption = option
                dropdownBtn.Text = option
            end,
            GetSelected = function()
                return selectedOption
            end
        }
    end
  
    local lastTabY = 0  
    local firstTabCallback
    local function createTab(name, callback)  
        local btn = Instance.new("TextButton", tabMenu)  
        btn.Size = UDim2.new(1,-12,0,32)  
        btn.Position = UDim2.new(0,6,0,lastTabY+6)  
        lastTabY = lastTabY + 38  
        btn.Text = name  
        btn.Font = Enum.Font.Gotham  
        btn.TextSize = 15  
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)  
        btn.TextColor3 = Color3.fromRGB(0,255,120)  
        corner(btn, 8)  
        btn.MouseButton1Click:Connect(function()  
            clearContent()  
            resetYOffset()  
            callback()  
        end)  
        btn.MouseEnter:Connect(function()  
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()  
        end)  
        btn.MouseLeave:Connect(function()  
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()  
        end)  
        if not firstTabCallback then firstTabCallback = callback end  
        return btn
    end  
  
    _G.AutoSell = false  
    _G.STREE_AutoFarm = false  
    _G.STREE_AutoWatering = false  
    _G.GAG_PrismaticESP_Enabled = false  
  
    -- ===== TABS =====  
    createTab("Home", function()  
        createLabel("Information")  
  
        createButton("Discord", function()  
            if setclipboard then setclipboard("https://discord.gg/jdmX43t5mY") end  
        end)  
        createButton("WhatsApp", function()  
            if setclipboard then setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N") end  
        end)  
        createButton("Telegram", function()  
            if setclipboard then setclipboard("https://t.me/StreeCoumminty") end  
        end)  
        createButton("Website", function()  
            if setclipboard then setclipboard("https://stree-hub-nexus.lovable.app") end  
        end)  
  
        createLabel("Players")  
  
        -- WalkSpeed input  
        local row = Instance.new("Frame", contentFrame)  
        row.Size = UDim2.new(1,-20,0,40)  
        row.Position = UDim2.new(0,10,0,nextY(40))  
        row.BackgroundTransparency = 1  
  
        local walkLabel = Instance.new("TextLabel", row)  
        walkLabel.Size = UDim2.new(0.5,0,1,0)  
        walkLabel.TextXAlignment = Enum.TextXAlignment.Left  
        walkLabel.BackgroundTransparency = 1  
        walkLabel.TextColor3 = Color3.fromRGB(200,200,200)  
        walkLabel.Text = "WalkSpeed: 16"  
        walkLabel.Font = Enum.Font.Gotham  
        walkLabel.TextSize = 14  
  
        local walkBox = Instance.new("TextBox", row)  
        walkBox.Size = UDim2.new(0.3,0,0.7,0)  
        walkBox.Position = UDim2.new(0.65,0,0.15,0)  
        walkBox.PlaceholderText = "16"  
        walkBox.BackgroundColor3 = Color3.fromRGB(36,36,36)  
        walkBox.TextColor3 = Color3.fromRGB(255,255,255)  
        walkBox.Font = Enum.Font.Gotham  
        walkBox.TextSize = 14  
        corner(walkBox, 6)  
  
        walkBox.FocusLost:Connect(function()  
            local val = tonumber(walkBox.Text)  
            if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then  
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val  
                walkLabel.Text = "WalkSpeed: "..val  
            end  
        end)  

        -- Contoh penggunaan Input Field
        createLabel("Input Fields Example")
        
        local nameInput = createInputField("Player Name:", "Enter your name", function(text)
            print("Player name set to:", text)
        end)

        local numberInput = createInputField("Amount:", "Enter amount", function(text)
            local num = tonumber(text)
            if num then
                print("Amount set to:", num)
            else
                warn("Invalid number!")
            end
        end)

        -- Contoh penggunaan Dropdown
        createLabel("Dropdown Example")
        
        local farmModeDropdown = createDropdown("Farm Mode", {"Auto", "Manual", "Semi-Auto"}, "Auto", function(selected)
            print("Farm mode selected:", selected)
        end)

        local plantTypeDropdown = createDropdown("Plant Type", {"Rose", "Tulip", "Sunflower", "Lily"}, "Rose", function(selected)
            print("Plant type selected:", selected)
        end)
    end)  
  
    createTab("Auto", function()  
        createLabel("⚙️ Utility")      
  
        createToggleModern("Auto Sell", false, function(on)  
            _G.AutoSell = on  
            if on then  
                warn("[STREE HUB] Auto Sell ENABLED")  
                pcall(function()  
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Auto%20sell.lua"))()  
                end)  
            else  
                warn("[STREE HUB] Auto Sell DISABLED")  
            end  
        end)  
  
        createToggleModern("Auto Plant & Harvest", false, function(on)  
            _G.STREE_AutoFarm = on  
            if on then  
                warn("[STREE HUB] Auto Plant & Harvest ENABLED")  
                pcall(function()  
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Auto%20plant%20%26%20Auto%20Harvest.lua"))()  
                end)  
            else  
                warn("[STREE HUB] Auto Plant & Harvest DISABLED")  
            end  
        end)  
  
        createToggleModern("Auto Watering", false, function(on)  
            _G.STREE_AutoWatering = on  
            if on then  
                warn("[STREE HUB] Auto Watering ENABLED")  
                pcall(function()  
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Auto%20Watering.lua"))()  
                end)  
            else  
                warn("[STREE HUB] Auto Watering DISABLED")  
            end  
        end)  

        -- Contoh penggunaan di tab Auto
        createLabel("Advanced Settings")
        
        local delaySlider = createSlider("Farm Delay", 0.1, 5, 1, function(value)
            print("Farm delay set to:", value)
        end)

        local rangeInput = createInputField("Farm Range:", "Enter range", function(text)
            local range = tonumber(text)
            if range then
                print("Farm range set to:", range)
            end
        end)

        local priorityDropdown = createDropdown("Priority", {"Nearest", "Highest Value", "Lowest Health"}, "Nearest", function(selected)
            print("Priority set to:", selected)
        end)
    end)  
  
    createTab("Visual", function()  
        createToggleModern("Esp Grow", false, function(on)  
            _G.GAG_PrismaticESP_Enabled = on  
            if on then  
                warn("[STREE HUB] ESP Grow ENABLED")  
                pcall(function()  
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Grow/Espprismatic.lua"))()  
                end)  
            else  
                warn("[STREE HUB] ESP Grow DISABLED")  
                if _G.__GAG_PRISMATIC_ESP and _G.__GAG_PRISMATIC_ESP.Destroy then  
                    _G.__GAG_PRISMATIC_ESP.Destroy()  
                end  
            end  
        end)  

        -- Contoh penggunaan di tab Visual
        createLabel("ESP Settings")
        
        local espColorDropdown = createDropdown("ESP Color", {"Green", "Red", "Blue", "Yellow", "Purple"}, "Green", function(selected)
            print("ESP color set to:", selected)
        end)

        local espRangeSlider = createSlider("ESP Range", 10, 500, 100, function(value)
            print("ESP range set to:", value)
        end)

        local showNamesToggle = createToggleModern("Show Plant Names", true, function(on)
            print("Show plant names:", on)
        end)
    end)  
  
    createTab("Credits", function()  
        createLabel("Created by: STREE Community")  
        createLabel("STREE HUB | create-stree")  
        createLabel("Thank you for using our script 😄")  
        createLabel("This UI still has shortcomings [Beta]")  
    end)  
  
    if firstTabCallback then firstTabCallback() end
  
    -- Draggable  
    MakeDraggable(window, titleBar) 
end

-- START
buildMainUI()
