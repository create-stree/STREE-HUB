--[[
    Stree Hub Interface Suite
    Modified from Fluent Interface
    Customized for Stree Hub

    Author: Modified from dawid's Fluent
    License: MIT
    Original GitHub: https://github.com/dawid-scripts/Fluent
]]

local moduleTable = {
    {1, 'ModuleScript', {'MainModule'}, {
        {18, 'ModuleScript', {'Creator'}},
        {28, 'ModuleScript', {'Icons'}},
        {47, 'ModuleScript', {'Themes'}, {
            {50, 'ModuleScript', {'Dark'}},
            {52, 'ModuleScript', {'Light'}},
            {51, 'ModuleScript', {'Darker'}},
            {53, 'ModuleScript', {'Rose'}},
            {49, 'ModuleScript', {'Aqua'}},
            {48, 'ModuleScript', {'Amethyst'}}
        }},
        {19, 'ModuleScript', {'Elements'}, {
            {27, 'ModuleScript', {'Toggle'}},
            {23, 'ModuleScript', {'Input'}},
            {20, 'ModuleScript', {'Button'}},
            {25, 'ModuleScript', {'Paragraph'}},
            {22, 'ModuleScript', {'Dropdown'}},
            {26, 'ModuleScript', {'Slider'}}
        }},
        {29, 'Folder', {'Packages'}, {
            {30, 'ModuleScript', {'Flipper'}, {
                {33, 'ModuleScript', {'GroupMotor'}},
                {46, 'ModuleScript', {'isMotor.spec'}},
                {39, 'ModuleScript', {'Signal'}},
                {40, 'ModuleScript', {'Signal.spec'}},
                {45, 'ModuleScript', {'isMotor'}},
                {36, 'ModuleScript', {'Instant.spec'}},
                {44, 'ModuleScript', {'Spring.spec'}},
                {42, 'ModuleScript', {'SingleMotor.spec'}},
                {38, 'ModuleScript', {'Linear.spec'}},
                {31, 'ModuleScript', {'BaseMotor'}},
                {43, 'ModuleScript', {'Spring'}},
                {35, 'ModuleScript', {'Instant'}},
                {37, 'ModuleScript', {'Linear'}},
                {41, 'ModuleScript', {'SingleMotor'}},
                {34, 'ModuleScript', {'GroupMotor.spec'}},
                {32, 'ModuleScript', {'BaseMotor.spec'}}
            }}
        }}
    }},
    {2, 'ModuleScript', {'Acrylic'}, {
        {3, 'ModuleScript', {'AcrylicBlur'}},
        {5, 'ModuleScript', {'CreateAcrylic'}},
        {6, 'ModuleScript', {'Utils'}},
        {4, 'ModuleScript', {'AcrylicPaint'}}
    }},
    {7, 'Folder', {'Components'}, {
        {9, 'ModuleScript', {'Button'}},
        {12, 'ModuleScript', {'Notification'}},
        {13, 'ModuleScript', {'Section'}},
        {17, 'ModuleScript', {'Window'}},
        {14, 'ModuleScript', {'Tab'}},
        {10, 'ModuleScript', {'Dialog'}},
        {8, 'ModuleScript', {'Assets'}},
        {16, 'ModuleScript', {'TitleBar'}},
        {15, 'ModuleScript', {'Textbox'}},
        {11, 'ModuleScript', {'Element'}}
    }}
}

local function getModule(id)
    local function findModule(tbl, targetId)
        for _, v in ipairs(tbl) do
            if v[1] == targetId then
                return v
            elseif v[4] then
                local found = findModule(v[4], targetId)
                if found then return found end
            end
        end
        return nil
    end
    
    local module = findModule(moduleTable, id)
    if module then
        if module[2] == 'ModuleScript' then
            return loadstring("return " .. tostring(module[3][1]))()
        end
    end
    return nil
end

-- Main Library
local MainModule = function()
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Workspace = game:GetService("Workspace")
    
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local Camera = Workspace.CurrentCamera
    
    -- Get required modules
    local Creator = getModule(18)
    local Icons = getModule(28)
    local Themes = getModule(47)
    local Elements = getModule(19)
    local Acrylic = getModule(2)
    local Components = getModule(7)
    
    local New = Creator.New
    local Notification = getModule(12)
    local Window = getModule(17)
    
    local protectgui = protectgui or (syn and syn.protect_gui) or function() end
    
    -- Create main GUI
    local MainGUI = New("ScreenGui", {
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        Name = "StreeHubUI",
        DisplayOrder = 999
    })
    protectgui(MainGUI)
    
    Notification:Init(MainGUI)
    
    -- Logo Button
    local LogoButton = New("ImageButton", {
        Size = UDim2.fromOffset(50, 50),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10709790948",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = MainGUI,
        Name = "LogoButton",
        ZIndex = 1000
    })
    
    -- Image Window Button
    local ImageWindowButton = New("ImageButton", {
        Size = UDim2.fromOffset(50, 50),
        Position = UDim2.new(0, 80, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://113067683358494",
        Parent = MainGUI,
        Name = "ImageWindowButton",
        ZIndex = 1000
    })
    
    -- Library table
    local Library = {
        Version = "2.0.0",
        OpenFrames = {},
        Options = {},
        Themes = Themes.Names,
        Window = nil,
        WindowFrame = nil,
        Unloaded = false,
        Theme = "Dark",
        DialogOpen = false,
        UseAcrylic = false,
        Acrylic = false,
        Transparency = true,
        MinimizeKeybind = nil,
        GUI = MainGUI,
        ImageWindows = {},
        Notifications = {},
        CurrentTab = nil
    }
    
    -- Safe callback function
    function Library:SafeCallback(callback, ...)
        if not callback then return end
        local success, result = pcall(callback, ...)
        if not success then
            local _, errorPos = result:find(":%d+: ")
            if not errorPos then
                return self:Notify({
                    Title = "Stree Hub",
                    Content = "Callback error",
                    SubContent = result,
                    Duration = 5
                })
            end
            return self:Notify({
                Title = "Stree Hub",
                Content = "Callback error",
                SubContent = result:sub(errorPos + 1),
                Duration = 5
            })
        end
        return result
    end
    
    -- Round function
    function Library:Round(number, decimalPlaces)
        if decimalPlaces == 0 then
            return math.floor(number)
        end
        local numString = tostring(number)
        local decimalPos = numString:find("%.")
        if decimalPos then
            return tonumber(numString:sub(1, decimalPos + decimalPlaces))
        end
        return number
    end
    
    -- Get icon function
    function Library:GetIcon(iconName)
        local icons = Icons.assets
        if iconName and icons["lucide-" .. iconName] then
            return icons["lucide-" .. iconName]
        end
        return nil
    end
    
    -- Setup elements
    local ElementsTable = {}
    ElementsTable.__index = ElementsTable
    
    ElementsTable.__namecall = function(self, funcName, ...)
        return self[funcName](...)
    end
    
    -- Register all element types
    for _, elementModule in ipairs(Elements) do
        local elementType = elementModule.__type
        if elementType then
            ElementsTable["Add" .. elementType] = function(container, name, options)
                elementModule.Container = container.Container
                elementModule.Type = container.Type
                elementModule.ScrollFrame = container.ScrollFrame
                elementModule.Library = Library
                return elementModule:New(name, options)
            end
        end
    end
    
    Library.Elements = ElementsTable
    
    -- Create Image Window function
    function Library:CreateImageWindow(options)
        assert(options.ImageId, "ImageWindow - Missing ImageId")
        
        local imageId = options.ImageId
        local windowSize = options.Size or UDim2.fromOffset(500, 400)
        local windowPosition = options.Position or UDim2.new(0.5, -250, 0.5, -200)
        local draggable = options.Draggable ~= false
        local resizable = options.Resizable ~= false
        local title = options.Title or "Image Window"
        local closeCallback = options.CloseCallback
        
        -- Create main window frame
        local imageWindow = New("Frame", {
            Name = "ImageWindow_" .. imageId,
            Size = UDim2.fromOffset(0, 0),
            Position = windowPosition + UDim2.new(0, windowSize.X.Offset / 2, 0, windowSize.Y.Offset / 2),
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            BackgroundTransparency = 0.05,
            BorderSizePixel = 0,
            Parent = MainGUI,
            Active = true,
            ClipsDescendants = true,
            ZIndex = 900
        }, {
            New("UICorner", {CornerRadius = UDim.new(0, 12)}),
            New("UIStroke", {
                Color = Color3.fromRGB(50, 50, 50),
                Thickness = 2,
                Transparency = 0.3
            })
        })
        
        -- Shadow effect
        local shadow = New("ImageLabel", {
            Name = "Shadow",
            Size = UDim2.new(1, 40, 1, 40),
            Position = UDim2.new(0, -20, 0, -20),
            BackgroundTransparency = 1,
            Image = "rbxassetid://5554236805",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(23, 23, 277, 277),
            ZIndex = 899
        })
        shadow.Parent = imageWindow
        
        -- Title bar
        local titleBar = New("Frame", {
            Name = "TitleBar",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            ZIndex = 901
        }, {
            New("UICorner", {CornerRadius = UDim.new(0, 12, 0, 0)}),
            New("UIStroke", {
                Color = Color3.fromRGB(40, 40, 40),
                Thickness = 1,
                Transparency = 0.5
            }),
            New("TextLabel", {
                Name = "TitleLabel",
                Text = title,
                Font = Enum.Font.GothamSemibold,
                TextSize = 16,
                TextColor3 = Color3.fromRGB(240, 240, 240),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 902
            }),
            New("ImageButton", {
                Name = "CloseButton",
                Size = UDim2.fromOffset(24, 24),
                Position = UDim2.new(1, -30, 0.5, -12),
                BackgroundTransparency = 1,
                Image = "rbxassetid://10709791437",
                ImageColor3 = Color3.fromRGB(255, 100, 100),
                ZIndex = 902
            }),
            New("ImageButton", {
                Name = "MinimizeButton",
                Size = UDim2.fromOffset(24, 24),
                Position = UDim2.new(1, -60, 0.5, -12),
                BackgroundTransparency = 1,
                Image = "rbxassetid://9886659276",
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                ZIndex = 902
            })
        })
        titleBar.Parent = imageWindow
        
        -- Image container
        local imageContainer = New("Frame", {
            Name = "ImageContainer",
            Size = UDim2.new(1, -20, 1, -60),
            Position = UDim2.new(0, 10, 0, 50),
            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 901
        }, {
            New("UICorner", {CornerRadius = UDim.new(0, 8)}),
            New("UIStroke", {
                Color = Color3.fromRGB(30, 30, 30),
                Thickness = 1
            })
        })
        imageContainer.Parent = imageWindow
        
        -- Main image
        local mainImage = New("ImageLabel", {
            Name = "MainImage",
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://" .. imageId,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 902
        })
        mainImage.Parent = imageContainer
        
        -- Loading indicator (optional)
        local loadingIndicator = New("Frame", {
            Name = "LoadingIndicator",
            Size = UDim2.fromOffset(40, 40),
            Position = UDim2.new(0.5, -20, 0.5, -20),
            BackgroundTransparency = 0.8,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Visible = false,
            ZIndex = 903
        }, {
            New("UICorner", {CornerRadius = UDim.new(0, 8)}),
            New("ImageLabel", {
                Image = "rbxassetid://10709790948",
                Size = UDim2.fromOffset(24, 24),
                Position = UDim2.new(0.5, -12, 0.5, -12),
                BackgroundTransparency = 1,
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            })
        })
        loadingIndicator.Parent = imageContainer
        
        -- Status bar
        local statusBar = New("Frame", {
            Name = "StatusBar",
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 1, -25),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            ZIndex = 901
        }, {
            New("UICorner", {CornerRadius = UDim.new(0, 0, 8, 8)}),
            New("TextLabel", {
                Name = "StatusText",
                Text = "Image ID: " .. imageId,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
        })
        statusBar.Parent = imageWindow
        
        -- Resize handles
        if resizable then
            local resizeHandles = {}
            
            local handlePositions = {
                {name = "Top", position = UDim2.new(0.5, 0, 0, 0), size = UDim2.new(1, -20, 0, 5), cursor = "SizeNS"},
                {name = "Bottom", position = UDim2.new(0.5, 0, 1, 0), size = UDim2.new(1, -20, 0, 5), cursor = "SizeNS"},
                {name = "Left", position = UDim2.new(0, 0, 0.5, 0), size = UDim2.new(0, 5, 1, -40), cursor = "SizeWE"},
                {name = "Right", position = UDim2.new(1, 0, 0.5, 0), size = UDim2.new(0, 5, 1, -40), cursor = "SizeWE"},
                {name = "TopLeft", position = UDim2.new(0, 0, 0, 0), size = UDim2.fromOffset(10, 10), cursor = "SizeNWSE"},
                {name = "TopRight", position = UDim2.new(1, 0, 0, 0), size = UDim2.fromOffset(10, 10), cursor = "SizeNESW"},
                {name = "BottomLeft", position = UDim2.new(0, 0, 1, 0), size = UDim2.fromOffset(10, 10), cursor = "SizeNESW"},
                {name = "BottomRight", position = UDim2.new(1, 0, 1, 0), size = UDim2.fromOffset(10, 10), cursor = "SizeNWSE"}
            }
            
            for _, handleInfo in ipairs(handlePositions) do
                local handle = New("Frame", {
                    Name = "ResizeHandle_" .. handleInfo.name,
                    Size = handleInfo.size,
                    Position = handleInfo.position,
                    AnchorPoint = Vector2.new(
                        handleInfo.position.X.Scale,
                        handleInfo.position.Y.Scale
                    ),
                    BackgroundTransparency = 1,
                    ZIndex = 910,
                    Parent = imageWindow
                })
                
                local mouseEnterConnection
                mouseEnterConnection = handle.MouseEnter:Connect(function()
                    UserInputService.MouseIcon = handleInfo.cursor
                end)
                
                local mouseLeaveConnection
                mouseLeaveConnection = handle.MouseLeave:Connect(function()
                    UserInputService.MouseIcon = ""
                end)
                
                table.insert(resizeHandles, {
                    handle = handle,
                    cursor = handleInfo.cursor,
                    connections = {mouseEnterConnection, mouseLeaveConnection}
                })
            end
            
            -- Resize functionality
            local isResizing = false
            local resizeAxis = nil
            local startPos = nil
            local startSize = nil
            
            local function beginResize(input, axis)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isResizing = true
                    resizeAxis = axis
                    startPos = input.Position
                    startSize = imageWindow.Size
                    
                    local connection
                    connection = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            isResizing = false
                            resizeAxis = nil
                            if connection then
                                connection:Disconnect()
                            end
                        end
                    end)
                end
            end
            
            UserInputService.InputChanged:Connect(function(input)
                if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement) then
                    local delta = input.Position - startPos
                    local newSize = UDim2.new(
                        startSize.X.Scale,
                        startSize.X.Offset,
                        startSize.Y.Scale,
                        startSize.Y.Offset
                    )
                    
                    if resizeAxis == "H" or resizeAxis == "HV" then
                        newSize = UDim2.new(
                            newSize.X.Scale,
                            math.max(300, newSize.X.Offset + delta.X),
                            newSize.Y.Scale,
                            newSize.Y.Offset
                        )
                    end
                    
                    if resizeAxis == "V" or resizeAxis == "HV" then
                        newSize = UDim2.new(
                            newSize.X.Scale,
                            newSize.X.Offset,
                            newSize.Y.Scale,
                            math.max(200, newSize.Y.Offset + delta.Y)
                        )
                    end
                    
                    imageWindow.Size = newSize
                end
            end)
            
            -- Setup resize for each handle
            for _, handleData in ipairs(resizeHandles) do
                local handle = handleData.handle
                local cursor = handleData.cursor
                
                handle.InputBegan:Connect(function(input)
                    local axis = "H"
                    if cursor == "SizeNS" then
                        axis = "V"
                    elseif cursor == "SizeNWSE" or cursor == "SizeNESW" then
                        axis = "HV"
                    end
                    beginResize(input, axis)
                end)
            end
        end
        
        -- Dragging functionality
        if draggable then
            local isDragging = false
            local dragStart = nil
            local startPosition = nil
            
            titleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    dragStart = input.Position
                    startPosition = imageWindow.Position
                    
                    local connection
                    connection = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            isDragging = false
                            if connection then
                                connection:Disconnect()
                            end
                        end
                    end)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - dragStart
                    imageWindow.Position = UDim2.new(
                        startPosition.X.Scale,
                        startPosition.X.Offset + delta.X,
                        startPosition.Y.Scale,
                        startPosition.Y.Offset + delta.Y
                    )
                end
            end)
        end
        
        -- Close button functionality
        local closeButton = titleBar:FindFirstChild("CloseButton")
        if closeButton then
            closeButton.MouseButton1Click:Connect(function()
                -- Animation for closing
                local closeTween = TweenService:Create(imageWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = UDim2.fromOffset(0, 0),
                    Position = imageWindow.Position + UDim2.new(
                        0, imageWindow.AbsoluteSize.X / 2,
                        0, imageWindow.AbsoluteSize.Y / 2
                    ),
                    BackgroundTransparency = 1
                })
                
                closeTween:Play()
                closeTween.Completed:Wait()
                
                -- Cleanup
                if Library.ImageWindows[imageId] then
                    Library.ImageWindows[imageId] = nil
                end
                
                if closeCallback then
                    pcall(closeCallback, imageId)
                end
                
                imageWindow:Destroy()
            end)
        end
        
        -- Minimize button functionality
        local minimizeButton = titleBar:FindFirstChild("MinimizeButton")
        local isMinimized = false
        local originalSize = windowSize
        local minimizedSize = UDim2.new(windowSize.X.Scale, windowSize.X.Offset, 0, 40)
        
        if minimizeButton then
            minimizeButton.MouseButton1Click:Connect(function()
                isMinimized = not isMinimized
                
                if isMinimized then
                    TweenService:Create(imageWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = minimizedSize
                    }):Play()
                    minimizeButton.Image = "rbxassetid://9886659406" -- Restore icon
                    imageContainer.Visible = false
                    statusBar.Visible = false
                else
                    TweenService:Create(imageWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = originalSize
                    }):Play()
                    minimizeButton.Image = "rbxassetid://9886659276" -- Minimize icon
                    imageContainer.Visible = true
                    statusBar.Visible = true
                end
            end)
        end
        
        -- Animate opening
        local openTween = TweenService:Create(imageWindow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = windowSize,
            Position = windowPosition,
            BackgroundTransparency = 0.05
        })
        
        openTween:Play()
        
        -- Store reference
        Library.ImageWindows[imageId] = {
            Window = imageWindow,
            Id = imageId,
            Title = title,
            IsMinimized = false,
            Close = function()
                if closeButton then
                    closeButton:Fire()
                end
            end,
            Minimize = function()
                if minimizeButton then
                    minimizeButton:Fire()
                end
            end,
            BringToFront = function()
                imageWindow.ZIndex = 1000
                for _, child in ipairs(MainGUI:GetChildren()) do
                    if child ~= imageWindow and child:IsA("Frame") then
                        child.ZIndex = 900
                    end
                end
            end
        }
    
        -- Bring to front on click
        imageWindow.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Library.ImageWindows[imageId].BringToFront()
            end
        end)
        
        return Library.ImageWindows[imageId]
    end
    
    -- Create main window
    function Library:CreateWindow(options)
        assert(options.Title, "Window - Missing Title")
        
        if self.Window then
            warn("Stree Hub: You cannot create more than one main window.")
            return self.Window
        end
        
        self.UseAcrylic = options.Acrylic or false
        
        if self.UseAcrylic then
            Acrylic.init()
        end
        
        local windowInstance = Window({
            Parent = MainGUI,
            Size = options.Size or UDim2.fromOffset(580, 460),
            Title = options.Title,
            SubTitle = options.SubTitle or "",
            TabWidth = options.TabWidth or 160
        })
        
        self.Window = windowInstance
        self:SetTheme(options.Theme or "Dark")
        
        -- Logo button click to minimize main window
        Creator.AddSignal(LogoButton.MouseButton1Click, function()
            if self.Window then
                self.Window:Minimize()
            end
        end)
        
        -- Image window button click
        Creator.AddSignal(ImageWindowButton.MouseButton1Click, function()
            self:CreateImageWindow({
                ImageId = "113067683358494",
                Title = "Stree Hub Image Viewer",
                Size = UDim2.fromOffset(600, 500),
                Position = UDim2.new(0.5, -300, 0.5, -250),
                Draggable = true,
                Resizable = true,
                CloseCallback = function(imageId)
                    print("Image window closed:", imageId)
                end
            })
        end)
        
        -- Add keyboard shortcuts
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.RightControl then
                if self.Window then
                    self.Window:Minimize()
                end
            elseif input.KeyCode == Enum.KeyCode.F2 then
                -- Open image window with F2
                self:CreateImageWindow({
                    ImageId = "113067683358494",
                    Title = "Quick Image Viewer",
                    Size = UDim2.fromOffset(500, 400),
                    Position = UDim2.new(0.3, 0, 0.3, 0)
                })
            end
        end)
        
        return windowInstance
    end
    
    -- Set theme
    function Library:SetTheme(themeName)
        if self.Window and table.find(self.Themes, themeName) then
            self.Theme = themeName
            Creator.UpdateTheme()
        end
    end
    
    -- Destroy library
    function Library:Destroy()
        if self.Window then
            self.Unloaded = true
            
            if self.UseAcrylic then
                self.Window.AcrylicPaint.Model:Destroy()
            end
            
            Creator.Disconnect()
        end
        
        -- Destroy all image windows
        for imageId, windowData in pairs(self.ImageWindows) do
            if windowData and windowData.Window and windowData.Window.Parent then
                windowData.Window:Destroy()
            end
        end
        self.ImageWindows = {}
        
        -- Destroy main GUI
        if MainGUI and MainGUI.Parent then
            MainGUI:Destroy()
        end
    end
    
    -- Toggle acrylic
    function Library:ToggleAcrylic(enabled)
        if self.Window then
            if self.UseAcrylic then
                self.Acrylic = enabled
                self.Window.AcrylicPaint.Model.Transparency = enabled and 0.98 or 1
                if enabled then
                    Acrylic.Enable()
                else
                    Acrylic.Disable()
                end
            end
        end
    end
    
    -- Toggle transparency
    function Library:ToggleTransparency(enabled)
        if self.Window then
            self.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = enabled and 0.35 or 0
        end
    end
    
    -- Create notification
    function Library:Notify(options)
        return Notification:New(options)
    end
    
    -- Open image window (public API)
    function Library:OpenImageWindow(options)
        return self:CreateImageWindow(options)
    end
    
    -- Close image window (public API)
    function Library:CloseImageWindow(imageId)
        local windowData = self.ImageWindows[imageId]
        if windowData then
            windowData.Close()
            return true
        end
        return false
    end
    
    -- Get all image windows (public API)
    function Library:GetImageWindows()
        return self.ImageWindows
    end
    
    -- Bring image window to front
    function Library:BringImageWindowToFront(imageId)
        local windowData = self.ImageWindows[imageId]
        if windowData then
            windowData.BringToFront()
            return true
        end
        return false
    end
    
    -- Check if image window exists
    function Library:HasImageWindow(imageId)
        return self.ImageWindows[imageId] ~= nil
    end
    
    -- Toggle all image windows visibility
    function Library:ToggleAllImageWindows(visible)
        for _, windowData in pairs(self.ImageWindows) do
            if windowData.Window then
                windowData.Window.Visible = visible
            end
        end
    end
    
    -- Create example UI
    function Library:CreateExampleUI()
        if not self.Window then
            self:CreateWindow({
                Title = "Stree Hub",
                SubTitle = "Example Interface",
                TabWidth = 160,
                Size = UDim2.fromOffset(580, 460)
            })
            
            local tab = self.Window:AddTab("Main")
            local section = tab:AddSection("Controls")
            
            section:AddButton({
                Title = "Open Image Window",
                Description = "Open the image viewer window",
                Callback = function()
                    self:OpenImageWindow({
                        ImageId = "113067683358494",
                        Title = "Example Image",
                        Size = UDim2.fromOffset(550, 450)
                    })
                end
            })
            
            section:AddToggle({
                Title = "Enable Acrylic",
                Description = "Toggle acrylic blur effect",
                Default = false,
                Callback = function(value)
                    self:ToggleAcrylic(value)
                end
            })
            
            section:AddSlider({
                Title = "Transparency",
                Description = "Adjust window transparency",
                Default = 0.35,
                Min = 0,
                Max = 1,
                Rounding = 2,
                Callback = function(value)
                    self:ToggleTransparency(value > 0)
                end
            })
        end
    end
    
    -- Export to global environment
    if getgenv then
        getgenv().StreeHub = Library
    end
    
    return Library
end
