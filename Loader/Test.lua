-- STREE HUB - Loader
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Parent GUI
local success, result = pcall(function() return game:GetService("CoreGui") end)
local parentGui = success and result or LocalPlayer:WaitForChild("PlayerGui")

-- UTIL DRAGGABLE
local function MakeDraggable(frame: Frame, dragHandle: GuiObject?)
    dragHandle = dragHandle or frame
    local dragging, dragStart, startPos

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
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            update(input)
        end
    end)
end

-- STYLE HELPERS
local function corner(parent, r) local c=Instance.new("UICorner", parent); c.CornerRadius=UDim.new(0,r or 8) return c end
local function stroke(parent, color, th) local s=Instance.new("UIStroke", parent); s.Color=color or Color3.fromRGB(0,255,0); s.Thickness=th or 2; return s end

-- VALID KEYS
local validKeys = {
    "STREEHUB-INDONESIAN-9GHTQ7ZP4M",
    "STREE-KeySystem-82ghtQRSM",
    "StreeCommunity-7g81ht7NO22"
}
local function isKeyValid(keyInput)
    for _, key in ipairs(validKeys) do
        if keyInput == key then return true end
    end
    return false
end

-- BUILD KEY LINKS UI
local function buildKeyLinksUI()
    if parentGui:FindFirstChild("STREE_KeyLinksUI") then parentGui.STREE_KeyLinksUI:Destroy() end
    local gui = Instance.new("ScreenGui", parentGui)
    gui.Name = "STREE_KeyLinksUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 380, 0, 260)
    frame.Position = UDim2.new(0.5, -190, 0.5, -130)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    corner(frame, 12) stroke(frame, Color3.fromRGB(0,255,0), 3)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "🔗 Key Links"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.BackgroundTransparency = 1

    local list = Instance.new("Frame", frame)
    list.Size = UDim2.new(1,-20,1,-50)
    list.Position = UDim2.new(0,10,0,50)
    list.BackgroundTransparency = 1
    local uiList = Instance.new("UIListLayout", list)
    uiList.Padding = UDim.new(0,8)

    local function createLink(name, link)
        local btn = Instance.new("TextButton", list)
        btn.Size = UDim2.new(1,0,0,40)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        corner(btn,8) stroke(btn, Color3.fromRGB(0,255,120),1.2)
        btn.Text = name.." 🔗"
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(link) end
            btn.Text = "✅ Copied!"
            task.delay(1.5,function() btn.Text = name.." 🔗" end)
        end)
    end

    createLink("Rekonise", "https://rkns.link/2vbo0", "rbxassetid://140280617864380")
    createLink("Linkvertise", "https://link-hub.net/1365203/NqhrZrvoQhoi", "rbxassetid://113798183844310",)
    createLink("Lootlabs", "https://lootdest.org/s?VooVvLbJ", "rbxassetid://112846309972303")

    MakeDraggable(frame, frame)
end

-- BUILD MAIN UI
local function buildMainUI()
    if parentGui:FindFirstChild("STREE_HUB_UI") then parentGui.STREE_HUB_UI:Destroy() end
    local ui = Instance.new("ScreenGui", parentGui) ui.Name = "STREE_HUB_UI"

    local window = Instance.new("Frame", ui)
    window.Size = UDim2.new(0, 560, 0, 360)
    window.Position = UDim2.new(0.5,-280,0.5,-180)
    window.BackgroundColor3 = Color3.fromRGB(20,20,20)
    corner(window,14) stroke(window, Color3.fromRGB(0,255,0),2)

    -- Cylinder dekorasi
    local cylinder = Instance.new("Frame", window)
    cylinder.Size = UDim2.new(0,120,0,120)
    cylinder.Position = UDim2.new(1,-140,1,-140)
    cylinder.BackgroundColor3 = Color3.fromRGB(0,255,120)
    cylinder.BackgroundTransparency = 0.85
    corner(cylinder,60)

    local title = Instance.new("TextLabel", window)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "-- STREE HUB --"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(0,255,100)
    title.BackgroundTransparency = 1

    -- Scrollable dengan section (accordion)
    local ScrollFrame = Instance.new("ScrollingFrame", window)
    ScrollFrame.Size = UDim2.new(1,-20,1,-60)
    ScrollFrame.Position = UDim2.new(0,10,0,50)
    ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.BackgroundTransparency = 1
    local UILayout = Instance.new("UIListLayout", ScrollFrame)
    UILayout.Padding = UDim.new(0,6)

    local function createSection(title)
        local sec = Instance.new("Frame", ScrollFrame)
        sec.Size = UDim2.new(1,-10,0,35)
        sec.BackgroundColor3 = Color3.fromRGB(25,25,25)
        corner(sec,8)
        local lbl = Instance.new("TextLabel", sec)
        lbl.Size = UDim2.new(1,-30,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.Text = title
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.BackgroundTransparency = 1
        local arrow = Instance.new("TextButton", sec)
        arrow.Size = UDim2.new(0,25,0,25)
        arrow.Position = UDim2.new(1,-30,0,5)
        arrow.Text = "▼"
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 16
        arrow.TextColor3 = Color3.fromRGB(0,255,100)
        arrow.BackgroundTransparency = 1
        local content = Instance.new("Frame", sec)
        content.Size = UDim2.new(1,-20,0,0)
        content.Position = UDim2.new(0,10,0,35)
        content.BackgroundTransparency = 1
        local list = Instance.new("UIListLayout", content)
        list.Padding = UDim.new(0,5)
        local expanded = false
        arrow.MouseButton1Click:Connect(function()
            expanded = not expanded
            arrow.Text = expanded and "▲" or "▼"
            local newHeight = expanded and (#content:GetChildren()-1)*35+10 or 0
            TweenService:Create(content,TweenInfo.new(0.3),{Size=UDim2.new(1,-20,0,newHeight)}):Play()
            TweenService:Create(sec,TweenInfo.new(0.3),{Size=UDim2.new(1,-10,0,expanded and newHeight+40 or 35)}):Play()
        end)
        return content
    end

    local Gameplay = createSection("Gameplay Scripts")
    local btn = Instance.new("TextButton", Gameplay)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = "⚡ Infinite Jump"
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    corner(btn,6)
    btn.MouseButton1Click:Connect(function()
        _G.InfiniteJump = not _G.InfiniteJump
        btn.Text = _G.InfiniteJump and "✅ Infinite Jump" or "⚡ Infinite Jump"
        if _G.InfiniteJump then
            UserInputService.JumpRequest:Connect(function()
                if _G.InfiniteJump then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end)

    UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0,0,0,UILayout.AbsoluteContentSize.Y+10)
    end)

    MakeDraggable(window, title)
end

-- BUILD KEY UI
function buildKeyUI()
    if parentGui:FindFirstChild("STREE_KeyUI") then parentGui.STREE_KeyUI:Destroy() end
    local gui = Instance.new("ScreenGui", parentGui)
    gui.Name = "STREE_KeyUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,340,0,230)
    frame.Position = UDim2.new(0.5,-170,0.5,-115)
    frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
    corner(frame,12) stroke(frame,Color3.fromRGB(0,255,0),3)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "🔑 | Key System"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.BackgroundTransparency = 1

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1,-20,0,40)
    input.Position = UDim2.new(0,10,0,50)
    input.PlaceholderText = "Enter key..."
    input.BackgroundColor3 = Color3.fromRGB(36,36,36)
    input.TextColor3 = Color3.fromRGB(255,255,255)
    input.ClearTextOnFocus = false
    corner(input,8)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1,-20,0,18)
    status.Position = UDim2.new(0,10,0,95)
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham

    local enterBtn = Instance.new("TextButton", frame)
    enterBtn.Size = UDim2.new(1,-20,0,32)
    enterBtn.Position = UDim2.new(0,10,0,130)
    enterBtn.Text = "Enter"
    enterBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
    enterBtn.TextColor3 = Color3.fromRGB(0,0,0)
    corner(enterBtn,8)

    local linkBtn = Instance.new("TextButton", frame)
    linkBtn.Size = UDim2.new(1,-20,0,32)
    linkBtn.Position = UDim2.new(0,10,0,170)
    linkBtn.Text = "Get Key"
    linkBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    linkBtn.TextColor3 = Color3.fromRGB(255,255,255)
    corner(linkBtn,8)

    enterBtn.MouseButton1Click:Connect(function()
        if isKeyValid(input.Text) then
            status.TextColor3 = Color3.fromRGB(0,255,0)
            status.Text = "Key Valid!"
            task.wait(0.5)
            gui:Destroy()
            buildMainUI()
        else
            status.TextColor3 = Color3.fromRGB(255,0,0)
            status.Text = "Key Invalid!"
        end
    end)

    linkBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        buildKeyLinksUI()
    end)

    MakeDraggable(frame, frame)
end

-- START
buildKeyUI()
