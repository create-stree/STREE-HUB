local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to loaded!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | The Forge",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },
})

Window:EditOpenButton({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("#000000"), 
        Color3.fromHex("#39FF14")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "Version",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Dev",
    Color = Color3.fromRGB(0, 0, 0),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info",
})

local Section = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Divider()

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Divider()

Tab1:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tab1:Keybind({
    Title = "Close/Open UI",
    Desc = "Keybind to Close/Open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

local Section = Tab2:Section({
    Title = "Mining Farm",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab2:Divider()

local SelectedRocks = {}

Tab2:Dropdown({
    Title = "Select",
    Desc = "Select Rock",
    Values = { "Basalt", "Basalt Core", "Basalt Rock", "Basalt Vein", "Boulder", "Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Lava Rock", "Lucky Block", "Light Crystal", "Pebble", "Rock", "Violet Crystal", "Volcanic Rock" },
    Value = { "Pebble" },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        if typeof(option) == "table" then
            SelectedRocks = option
        elseif typeof(option) == "string" then
            SelectedRocks = { option }
        else
            SelectedRocks = {}
        end
    end
})

_G.AutoMine = false
local ownDebounce = false
local noclipConnection = nil

local function enableNoclip()
    if noclipConnection then return end
    noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        local plr = game.Players.LocalPlayer
        if not plr then return end
        local char = plr.Character
        if not char then return end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

Tab2:Toggle({
    Title = "Auto Farm",
    Desc = "Automatic Farm Mine + Noclip",
    Value = false,
    Callback = function(state)
        _G.AutoMine = state
        
        -- Aktifkan Noclip otomatis saat Auto Farm aktif
        if _G.AutoMine then
            enableNoclip()
        else
            disableNoclip()
        end
        
        if _G.AutoMine and ownDebounce then
            return
        end
        
        task.spawn(function()
            ownDebounce = true
            while _G.AutoMine do
                task.wait(0.2)
                local plr = game.Players.LocalPlayer
                if not plr then break end
                local char = plr.Character or plr.CharacterAdded:Wait()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then
                    task.wait(1)
                    continue
                end
                if #SelectedRocks == 0 then
                    SelectedRocks = {"Pebble"}
                end
                local nearestObj = nil
                local nearestDist = math.huge
                local validTargets = {}
                for _, obj in ipairs(workspace:GetDescendants()) do
                    for _, name in ipairs(SelectedRocks) do
                        if obj.Name == name or obj.Name:lower():find(name:lower()) then
                            table.insert(validTargets, obj)
                            break
                        end
                    end
                end
                for _, obj in ipairs(validTargets) do
                    local targetPart = nil
                    if obj:IsA("Model") then
                        targetPart = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                        if not targetPart then
                            for _, c in ipairs(obj:GetChildren()) do
                                if c:IsA("BasePart") then
                                    targetPart = c
                                    break
                                end
                            end
                        end
                    elseif obj:IsA("BasePart") then
                        targetPart = obj
                    end
                    if targetPart and targetPart.Position then
                        local d = (hrp.Position - targetPart.Position).Magnitude
                        if d < nearestDist then
                            nearestDist = d
                            nearestObj = {model = obj, part = targetPart}
                        end
                    end
                end
                if not nearestObj then
                    task.wait(1)
                    continue
                end
                
                -- Posisi di BAWAH objek (di dalam tanah)
                local targetPos = nearestObj.part.Position
                local offset = Vector3.new(0, -5, 0) -- Posisi di BAWAH target (negatif Y)
                
                -- CFrame yang menghadap ke atas
                local cframePos = targetPos + offset
                
                -- Hitung rotasi untuk menghadap ke atas
                -- Menggunakan CFrame.Angles untuk rotasi ke atas
                local upCFrame = CFrame.new(cframePos) * CFrame.Angles(math.rad(-90), 0, 0)
                
                pcall(function()
                    -- Set posisi dan rotasi
                    hrp.CFrame = upCFrame
                    
                    -- Nonaktifkan gravitasi agar tidak jatuh
                    hum.PlatformStand = true
                end)
                
                local equipped = char:FindFirstChildOfClass("Tool")
                if not equipped then
                    for _, tool in ipairs(plr.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("pick") or tool.Name:lower():find("axe") or tool.Name:lower():find("pickaxe")) then
                            tool.Parent = char
                            equipped = tool
                            break
                        end
                    end
                end
                if not equipped then
                    for _, tool in ipairs(plr.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            tool.Parent = char
                            equipped = tool
                            break
                        end
                    end
                end
                
                local startTime = tick()
                while _G.AutoMine and tick() - startTime < 8 do
                    if not nearestObj.part or not nearestObj.part.Parent then break end
                    
                    -- Update posisi agar tetap di bawah target
                    local newTargetPos = nearestObj.part.Position
                    local newCframePos = newTargetPos + Vector3.new(0, -5, 0) -- Tetap di bawah
                    
                    -- Perbarui rotasi untuk tetap menghadap ke atas
                    local newUpCFrame = CFrame.new(newCframePos) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    pcall(function()
                        hrp.CFrame = newUpCFrame
                    end)
                    
                    if equipped and equipped.Parent == char then
                        pcall(function()
                            equipped:Activate()
                        end)
                    end
                    
                    task.wait(0.6)
                    
                    if not nearestObj.model.Parent then
                        break
                    end
                    
                    local hum2 = nearestObj.model:FindFirstChildWhichIsA("Humanoid")
                    if hum2 and hum2.Health <= 0 then
                        break
                    else
                        local p = nearestObj.part
                        if not p or p.Transparency >= 1 or p.Size.Magnitude <= 0.1 then
                            break
                        end
                    end
                end
                task.wait(0.2)
            end
            ownDebounce = false
            
            -- Reset PlatformStand saat Auto Farm dimatikan
            local plr = game.Players.LocalPlayer
            if plr and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.PlatformStand = false
                end
            end
        end)
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if _G.AutoMine then
        enableNoclip()
        task.wait(0.5)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
        end
    end
end)

-- Reset PlatformStand saat karakter mati
game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    local plr = game.Players.LocalPlayer
    if plr and plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
end)
