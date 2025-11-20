-- ====== FLUENT KEY SYSTEM - COMPLETE ======
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

-- ====== UTILITY FUNCTIONS ======
local function MakeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

local function RoundedCorner(parent, radius)
    local corner = CreateElement("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius or 8)
    })
    return corner
end

local function NeonStroke(parent, thickness, transparency)
    local stroke = CreateElement("UIStroke", {
        Parent = parent,
        Color = Color3.fromRGB(0, 255, 0),
        Thickness = thickness or 2,
        Transparency = transparency or 0.3
    })
    return stroke
end

-- ====== KEY SYSTEM ======
local validKeys = {
    "STREEHUB-INDONESIA-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM", 
    "StreeCommunity-7g81ht7NO22",
    "STREE-PREMIUM-ACCESS-KEY",
    "STREEHUB-VIP-MEMBER"
}

local function isKeyValid(keyInput)
    local key = keyInput:gsub("%s+", ""):upper()
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

-- ====== BUILD KEY UI ======
function buildKeyUI()
    if parentGui:FindFirstChild("STREE_KeyUI") then 
        parentGui.STREE_KeyUI:Destroy() 
    end

    local keyGui = CreateElement("ScreenGui", {
        Parent = parentGui,
        Name = "STREE_KeyUI",
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    local frame = CreateElement("Frame", {
        Parent = keyGui,
        Size = UDim2.new(0, 380, 0, 280),
        Position = UDim2.new(0.5, -190, 0.5, -140),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0
    })
    RoundedCorner(frame, 14)
    
    -- Fluent-style neon border
    local outerGlow = CreateElement("UIStroke", {
        Parent = frame,
        Color = Color3.fromRGB(0, 255, 0),
        Thickness = 3,
        Transparency = 0.2
    })
    
    local innerGlow = CreateElement("UIStroke", {
        Parent = frame,
        Color = Color3.fromRGB(0, 255, 150),
        Thickness = 1,
        Transparency = 0.4
    })

    -- Title Bar
    local titleBar = CreateElement("Frame", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 42),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.1
    })
    RoundedCorner(titleBar, 10)

    local titleBarStroke = CreateElement("UIStroke", {
        Parent = titleBar,
        Color = Color3.fromRGB(0, 255, 0),
        Thickness = 1,
        Transparency = 0.6
    })

    local title = CreateElement("TextLabel", {
        Parent = titleBar,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(0, 255, 0),
        Text = "🔑 STREE HUB KEY SYSTEM",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Close button
    local closeBtn = CreateElement("TextButton", {
        Parent = titleBar,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -32, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0
    })
    RoundedCorner(closeBtn, 6)
    
    local closeStroke = CreateElement("UIStroke", {
        Parent = closeBtn,
        Color = Color3.fromRGB(255, 100, 100),
        Thickness = 1,
        Transparency = 0.5
    })

    -- Input field
    local inputContainer = CreateElement("Frame", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 52),
        Position = UDim2.new(0, 12, 0, 70),
        BackgroundTransparency = 1
    })

    local inputLabel = CreateElement("TextLabel", {
        Parent = inputContainer,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        Text = "ENTER YOUR KEY",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local input = CreateElement("TextBox", {
        Parent = inputContainer,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 18),
        PlaceholderText = "Paste your key here...",
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        ClearTextOnFocus = false,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Text = ""
    })
    RoundedCorner(input, 8)
    
    local inputStroke = CreateElement("UIStroke", {
        Parent = input,
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 2
    })

    -- Status label
    local status = CreateElement("TextLabel", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 130),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Text = "🔒 Enter your key to continue",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Button container
    local buttonContainer = CreateElement("Frame", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 100),
        Position = UDim2.new(0, 12, 1, -112),
        BackgroundTransparency = 1
    })

    -- Submit button
    local submitBtn = CreateElement("TextButton", {
        Parent = buttonContainer,
        Size = UDim2.new(0.48, -4, 0, 42),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "SUBMIT",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(0, 180, 0),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    RoundedCorner(submitBtn, 8)
    
    local submitStroke = CreateElement("UIStroke", {
        Parent = submitBtn,
        Color = Color3.fromRGB(0, 255, 0),
        Thickness = 2
    })

    -- Discord button
    local discordBtn = CreateElement("TextButton", {
        Parent = buttonContainer,
        Size = UDim2.new(0.48, -4, 0, 42),
        Position = UDim2.new(0.52, 4, 0, 0),
        Text = "DISCORD",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(88, 101, 242),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
    RoundedCorner(discordBtn, 8)
    
    local discordStroke = CreateElement("UIStroke", {
        Parent = discordBtn,
        Color = Color3.fromRGB(114, 137, 218),
        Thickness = 2
    })

    -- Get Key button
    local linkBtn = CreateElement("TextButton", {
        Parent = buttonContainer,
        Size = UDim2.new(1, 0, 0, 42),
        Position = UDim2.new(0, 0, 0, 52),
        Text = "🔗 GET KEY FROM LINKS",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        TextColor3 = Color3.fromRGB(0, 255, 150),
        BorderSizePixel = 0
    })
    RoundedCorner(linkBtn, 8)
    
    local linkStroke = CreateElement("UIStroke", {
        Parent = linkBtn,
        Color = Color3.fromRGB(0, 255, 150),
        Thickness = 2
    })

    -- ====== HOVER EFFECTS ======
    local function setupButtonHover(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = hoverColor
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = normalColor
            }):Play()
        end)
    end

    -- Input field focus effects
    input.Focused:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(0, 255, 0),
            Transparency = 0
        }):Play()
        TweenService:Create(input, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end)
    
    input.FocusLost:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(60, 60, 60),
            Transparency = 0.5
        }):Play()
        TweenService:Create(input, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }):Play()
    end)

    -- Apply hover effects
    setupButtonHover(submitBtn, Color3.fromRGB(0, 180, 0), Color3.fromRGB(0, 220, 0))
    setupButtonHover(discordBtn, Color3.fromRGB(88, 101, 242), Color3.fromRGB(114, 137, 218))
    setupButtonHover(linkBtn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(50, 50, 50))
    setupButtonHover(closeBtn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))

    -- ====== BUTTON FUNCTIONALITY ======
    closeBtn.MouseButton1Click:Connect(function()
        keyGui:Destroy()
    end)

    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then 
            setclipboard("https://discord.gg/jdmX43t5mY") 
        end
        status.TextColor3 = Color3.fromRGB(0, 255, 120)
        status.Text = "✅ Discord link copied to clipboard!"
        
        task.wait(2)
        status.TextColor3 = Color3.fromRGB(200, 200, 200)
        status.Text = "🔒 Enter your key to continue"
    end)

    linkBtn.MouseButton1Click:Connect(function()
        keyGui:Destroy()
        buildKeyLinksUI()
    end)

    submitBtn.MouseButton1Click:Connect(function()
        local key = input.Text:gsub("%s+", ""):upper()
        
        if key == "" then
            status.TextColor3 = Color3.fromRGB(255, 165, 0)
            status.Text = "⚠️ Please enter a key"
            return
        end
        
        if isKeyValid(key) then
            status.TextColor3 = Color3.fromRGB(0, 255, 0)
            status.Text = "✅ Key accepted! Loading..."
            
            TweenService:Create(submitBtn, TweenInfo.new(0.5), {
                BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            }):Play()
            TweenService:Create(submitStroke, TweenInfo.new(0.5), {
                Color = Color3.fromRGB(0, 255, 0)
            }):Play()
            
            task.wait(1.2)
            keyGui:Destroy()
            buildMainUI()
        else
            status.TextColor3 = Color3.fromRGB(255, 80, 80)
            status.Text = "❌ Invalid key, please try again"
            
            TweenService:Create(submitBtn, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            }):Play()
            TweenService:Create(submitStroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(255, 80, 80)
            }):Play()
            
            local shake = TweenService:Create(input, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 3, true), {
                Position = input.Position + UDim2.new(0, 8, 0, 0)
            })
            shake:Play()
            
            task.wait(0.8)
            TweenService:Create(submitBtn, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            }):Play()
            TweenService:Create(submitStroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(0, 255, 0)
            }):Play()
        end
    end)

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitBtn.MouseButton1Click:Wait()
        end
    end)

    MakeDraggable(frame, titleBar)
end

-- ====== KEY LINKS UI ======
function buildKeyLinksUI()
    if parentGui:FindFirstChild("STREE_KeyLinksUI") then
        parentGui.STREE_KeyLinksUI:Destroy()
    end

    local gui = CreateElement("ScreenGui", {
        Parent = parentGui,
        Name = "STREE_KeyLinksUI",
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    local frame = CreateElement("Frame", {
        Parent = gui,
        Size = UDim2.new(0, 400, 0, 320),
        Position = UDim2.new(0.5, -200, 0.5, -160),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0
    })
    RoundedCorner(frame, 14)
    NeonStroke(frame, 3, 0.2)

    local titleBar = CreateElement("Frame", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 42),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.1
    })
    RoundedCorner(titleBar, 10)

    local title = CreateElement("TextLabel", {
        Parent = titleBar,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(0, 255, 0),
        Text = "🔑 Get Your Key",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local backBtn = CreateElement("TextButton", {
        Parent = titleBar,
        Size = UDim2.new(0, 60, 0, 25),
        Position = UDim2.new(0, 0, 0.5, -12),
        Text = "← Back",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        TextColor3 = Color3.fromRGB(0, 255, 0)
    })
    RoundedCorner(backBtn, 6)
    NeonStroke(backBtn, 1, 0.5)

    local instruction = CreateElement("TextLabel", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 40),
        Position = UDim2.new(0, 12, 0, 70),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Text = "Complete any link to get your key:",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local linksFrame = CreateElement("ScrollingFrame", {
        Parent = frame,
        Size = UDim2.new(1, -24, 1, -140),
        Position = UDim2.new(0, 12, 0, 110),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
    })

    local layout = CreateElement("UIListLayout", {
        Parent = linksFrame,
        Padding = UDim.new(0, 10)
    })

    local keyLinks = {
        {"Rekonise", "https://rkns.link/2vbo0"},
        {"Linkvertise", "https://link-hub.net/1365203/NqhrZrvoQhoi"},
        {"Lootlabs", "https://lootdest.org/s?VooVvLbJ"},
        {"Work.Ink", "https://link-hub.net/1365203/NqhrZrvoQhoi"}
    }

    for _, linkData in ipairs(keyLinks) do
        local name, url = linkData[1], linkData[2]
        
        local linkBtn = CreateElement("TextButton", {
            Parent = linksFrame,
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Text = "",
            AutoButtonColor = false
        })
        RoundedCorner(linkBtn, 8)
        NeonStroke(linkBtn, 2, 0.5)

        local linkTitle = CreateElement("TextLabel", {
            Parent = linkBtn,
            Size = UDim2.new(1, -20, 0.6, 0),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(0, 255, 150),
            Text = "🔗 " .. name,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local linkDesc = CreateElement("TextLabel", {
            Parent = linkBtn,
            Size = UDim2.new(1, -20, 0.4, 0),
            Position = UDim2.new(0, 10, 0.6, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            Text = "Click to copy link",
            TextXAlignment = Enum.TextXAlignment.Left
        })

        setupButtonHover(linkBtn, Color3.fromRGB(30, 30, 30), Color3.fromRGB(40, 40, 40))

        linkBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(url)
            end
            linkTitle.Text = "✅ " .. name
            linkDesc.Text = "Link copied to clipboard!"
            linkTitle.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            task.wait(1.5)
            linkTitle.Text = "🔗 " .. name
            linkDesc.Text = "Click to copy link"
            linkTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
        end)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        linksFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    backBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        buildKeyUI()
    end)

    MakeDraggable(frame, titleBar)
end

-- ====== MAIN UI (After Key Verification) ======
function buildMainUI()
    if parentGui:FindFirstChild("STREE_MainUI") then
        parentGui.STREE_MainUI:Destroy()
    end

    local gui = CreateElement("ScreenGui", {
        Parent = parentGui,
        Name = "STREE_MainUI",
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    local frame = CreateElement("Frame", {
        Parent = gui,
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0
    })
    RoundedCorner(frame, 14)
    NeonStroke(frame, 3, 0.2)

    local titleBar = CreateElement("Frame", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 42),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.1
    })
    RoundedCorner(titleBar, 10)

    local title = CreateElement("TextLabel", {
        Parent = titleBar,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(0, 255, 0),
        Text = "🎉 STREE HUB - PREMIUM ACCESS",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local welcome = CreateElement("TextLabel", {
        Parent = frame,
        Size = UDim2.new(1, -24, 0, 60),
        Position = UDim2.new(0, 12, 0, 70),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.1,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(0, 255, 0),
        Text = "Welcome to STREE HUB!",
        TextWrapped = true
    })
    RoundedCorner(welcome, 8)
    NeonStroke(welcome, 1, 0.5)

    local status = CreateElement("TextLabel", {
        Parent = welcome,
        Size = UDim2.new(1, -20, 0.5, 0),
        Position = UDim2.new(0, 10, 0.5, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        Text = "✅ Premium access activated • Enjoy your stay!",
        TextXAlignment = Enum.TextXAlignment.Left
    })

    MakeDraggable(frame, titleBar)

    -- Di sini Anda bisa tambahkan script buttons atau fitur lainnya
    print("STREE HUB: Main UI Loaded Successfully!")
end

-- ====== START THE KEY SYSTEM ======
buildKeyUI()

return {
    BuildKeyUI = buildKeyUI,
    BuildMainUI = buildMainUI,
    IsKeyValid = isKeyValid
}
]])()
