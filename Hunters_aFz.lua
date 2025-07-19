-- STREE HUB | PRRI SCRIPT
-- Key: PRRI TETAP JAYA
-- Insert = Re-open UI | X = Close UI
-- Transparan 30 % + ESP Highlight + ESP Name-Tag + Super Ring, Fly, Noclip, Speed, Teleport

if not game:IsLoaded() then game.Loaded:Wait() end
local Players, UIS, RunSvc, TweenSvc = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("TweenService")
local player, camera, neonGreen, pureBlack = Players.LocalPlayer, workspace.CurrentCamera, Color3.fromRGB(0, 255, 127), Color3.fromRGB(0, 0, 0)

local correctKey = "PRRI TETAP JAYA"
local toggleKey = Enum.KeyCode.Insert
local superOn, flyOn, noclipOn, speedOn, espOn = false, false, false, false, false
local root, hum = player.Character and player.Character:WaitForChild("HumanoidRootPart"), player.Character and player.Character:WaitForChild("Humanoid")

local function updateRoot()
    root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    hum = player.Character and player.Character:WaitForChild("Humanoid")
end
player.CharacterAdded:Connect(updateRoot)

-- ========= KEY SYSTEM =========
local keyGui = Instance.new("ScreenGui", game.CoreGui)
local kF = Instance.new("Frame", keyGui)
kF.Size, kF.Position, kF.AnchorPoint = UDim2.new(0, 320, 0, 180), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5)
kF.BackgroundColor3, kF.BackgroundTransparency, kF.BorderSizePixel = pureBlack, 0.7, 0
Instance.new("UICorner", kF).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", kF).Color, Instance.new("UIStroke", kF).Thickness = neonGreen, 2

local kLabel = Instance.new("TextLabel", kF)
kLabel.Size, kLabel.Position, kLabel.BackgroundTransparency = UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 10), 1
kLabel.Text, kLabel.TextColor3, kLabel.Font, kLabel.TextSize = "Enter Key:", neonGreen, Enum.Font.SourceSansBold, 18

local kBox = Instance.new("TextBox", kF)
kBox.Size, kBox.Position, kBox.BackgroundTransparency = UDim2.new(1, -20, 0, 40), UDim2.new(0, 10, 0, 55), 0.7
kBox.BackgroundColor3, kBox.TextColor3, kBox.Font, kBox.TextSize, kBox.PlaceholderText = pureBlack, neonGreen, Enum.Font.SourceSans, 16, "Key..."

local kBtn = Instance.new("TextButton", kF)
kBtn.Size, kBtn.Position, kBtn.BackgroundTransparency = UDim2.new(0, 100, 0, 35), UDim2.new(0.5, -50, 0, 110), 0.7
kBtn.BackgroundColor3, kBtn.TextColor3, kBtn.Font, kBtn.TextSize, kBtn.Text = pureBlack, neonGreen, Enum.Font.SourceSansBold, 16, "Submit"
Instance.new("UICorner", kBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", kBtn).Color, Instance.new("UIStroke", kBtn).Thickness = neonGreen, 2

kBtn.MouseButton1Click:Connect(function()
    if kBox.Text == correctKey then
        keyGui:Destroy()
        loadMain()
    else
        kBox.Text = "INVALID!"
    end
end)

-- ========= MAIN UI =========
local mainGui
local function loadMain()
    mainGui = Instance.new("ScreenGui", game.CoreGui)
    local mF = Instance.new("Frame", mainGui)
    mF.Size, mF.Position, mF.AnchorPoint = UDim2.new(0, 260, 0, 400), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5)
    mF.BackgroundColor3, mF.BackgroundTransparency, mF.BorderSizePixel = pureBlack, 0.7, 0
    mF.Active, mF.Draggable = true, true
    Instance.new("UICorner", mF).CornerRadius = UDim.new(0, 8)
    local mStroke = Instance.new("UIStroke", mF)
    mStroke.Color, mStroke.Thickness = neonGreen, 2

    local title = Instance.new("TextLabel", mF)
    title.Size, title.BackgroundTransparency = UDim2.new(1, 0, 0, 25), 1
    title.Text, title.TextColor3, title.Font, title.TextSize = "STREE HUB | PRRI SCRIPT", neonGreen, Enum.Font.SourceSansBold, 18

    local closeBtn = Instance.new("TextButton", mF)
    closeBtn.Size, closeBtn.Position, closeBtn.BackgroundTransparency = UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0, 5), 0.7
    closeBtn.BackgroundColor3, closeBtn.TextColor3, closeBtn.Text, closeBtn.Font, closeBtn.TextSize = pureBlack, neonGreen, "X", Enum.Font.SourceSansBold, 14
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", closeBtn).Color, Instance.new("UIStroke", closeBtn).Thickness = neonGreen, 2
    closeBtn.MouseButton1Click:Connect(function() mainGui.Enabled = false end)

    -- ESP Toggle
    local espOn = false
    local espCache = {}
    local toggleBtn = Instance.new("TextButton", mF)
    toggleBtn.Size, toggleBtn.Position, toggleBtn.BackgroundTransparency = UDim2.new(0, 220, 0, 35), UDim2.new(0.5, -110, 0, 50), 0.7
    toggleBtn.BackgroundColor3, toggleBtn.TextColor3, toggleBtn.Font, toggleBtn.TextSize, toggleBtn.Text = pureBlack, neonGreen, Enum.Font.SourceSansBold, 15, "aFz ESP: OFF"
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", toggleBtn).Color, Instance.new("UIStroke", toggleBtn).Thickness = neonGreen, 2

    local cylinder = Instance.new("Frame", toggleBtn)
    cylinder.Size, cylinder.Position, cylinder.BackgroundColor3 = UDim2.new(0, 30, 0, 30), UDim2.new(0, 5, 0.5, -15), neonGreen
    cylinder.BorderSizePixel = 0
    Instance.new("UICorner", cylinder).CornerRadius = UDim.new(1, 0)

    -- Buttons: Super Ring, Fly, Noclip, Speed
    local yPos = 90
    local buttons = {"Super Ring", "Fly", "Noclip", "Speed"}
    local states = {superOn = false, flyOn = false, noclipOn = false, speedOn = false}
    local btnObjects = {}

    for _, name in ipairs(buttons) do
        local btn = Instance.new("TextButton", mF)
        btn.Size = UDim2.new(0, 220, 0, 35)
        btn.Position = UDim2.new(0.5, -110, 0, yPos)
        btn.BackgroundColor3 = pureBlack
        btn.BackgroundTransparency = 0.7
        btn.Text = name .. ": OFF"
        btn.TextColor3 = neonGreen
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 15
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", btn).Color, Instance.new("UIStroke", btn).Thickness = neonGreen, 2
        btnObjects[name] = btn
        yPos = yPos + 40
    end

    -- ESP Highlight + Name-Tag
    local function updateEsp()
        for _, obj in pairs(espCache) do obj:Destroy() end
        table.clear(espCache)

        if espOn then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character and string.lower(plr.Name):find("afz") then
                    local char = plr.Character
                    -- Highlight
                    local hl = Instance.new("Highlight", char)
                    hl.Adornee = char
                    hl.FillColor = Color3.fromRGB(0, 0, 0)      -- fill hitam transparan
                    hl.FillTransparency = 0.7
                    hl.OutlineColor = neonGreen                   -- outline hijau neon
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    table.insert(espCache, hl)

                    -- Name-Tag
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bbg = Instance.new("BillboardGui", head)
                        bbg.Adornee = head
                        bbg.Size = UDim2.new(0, 200, 0, 50)
                        bbg.StudsOffset = Vector3.new(0, 3, 0)
                        bbg.AlwaysOnTop = true
                        bbg.MaxDistance = 1000
                        local txt = Instance.new("TextLabel", bbg)
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.Text = plr.Name
                        txt.TextColor3 = neonGreen
                        txt.Font = Enum.Font.SourceSansBold
                        txt.TextSize = 18
                        table.insert(espCache, bbg)
                    end
                end
            end
        end
    end

    -- ESP Toggle
    toggleBtn.MouseButton1Click:Connect(function()
        espOn = not espOn
        toggleBtn.Text = "aFz ESP: " .. (espOn and "ON" or "OFF")
        TweenSvc:Create(cylinder, TweenInfo.new(0.2), {Position = espOn and UDim2.new(1, -35, 0.5, -15) or UDim2.new(0, 5, 0.5, -15)}):Play()
        updateEsp()
    end)

    -- Refresh ESP on character load / remove
    Players.PlayerAdded:Connect(updateEsp)
    Players.PlayerRemoving:Connect(updateEsp)
    player.CharacterAdded:Connect(updateEsp)

    -- Functions
    local function superRing()
        if states.superOn and hum then hum.MaxHealth, hum.Health = 9999, 9999 end
    end
    local function fly()
        if states.flyOn and root then
            local BV = Instance.new("BodyVelocity", root)
            BV.Velocity = Vector3.new(0, 0, 0)
            BV.MaxForce = Vector3.new(4000, 4000, 4000)
            BV.Name = "STREE_Fly"
        else
            if root and root:FindFirstChild("STREE_Fly") then root.STREE_Fly:Destroy() end
        end
    end
    local function noclip()
        if states.noclipOn and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
    local function speed()
        if states.speedOn and hum then hum.WalkSpeed = 100 else hum.WalkSpeed = 16 end
    end

    -- Teleport to cursor
    UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            local mouse = player:GetMouse()
            if mouse.Hit and root then
                root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
            end
        end
    end)

    -- Toggle events
    for _, name in ipairs(buttons) do
        btnObjects[name].MouseButton1Click:Connect(function()
            states[name:lower():gsub(" ", "")] = not states[name:lower():gsub(" ", "")]
            btnObjects[name].Text = name .. ": " .. (states[name:lower():gsub(" ", "")] and "ON" or "OFF")
            if name == "Super Ring" then superRing() elseif name == "Fly" then fly() elseif name == "Noclip" then noclip() elseif name == "Speed" then speed() end
        end)
    end

    RunSvc.Heartbeat:Connect(function()
        if states.noclipOn then noclip() end
    end)

    -- Re-open keybind
    UIS.InputBegan:Connect(function(inp, gpe)
        if not gpe and inp.KeyCode == toggleKey then
            mainGui.Enabled = not mainGui.Enabled
        end
    end)
end

kBtn.MouseButton1Click:Connect(function()
    if kBox.Text == correctKey then
        keyGui:Destroy()
        loadMain()
    else
        kBox.Text = "INVALID!"
    end
end)
