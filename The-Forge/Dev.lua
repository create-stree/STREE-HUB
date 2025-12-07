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
local miningToolNames = {"Pickaxe", "Drill", "Hammer", "Axe", "Tool"}
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")

local function enableNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        local plr = Players.LocalPlayer
        if not plr then return end
        local char = plr.Character
        if not char then return end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CanCollide = false
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

local function equipBestMiningTool()
    local plr = Players.LocalPlayer
    if not plr then return nil end
    local char = plr.Character
    if not char then return nil end

    local bestTool = nil
    local bestToolValue = 0

    for _, tool in ipairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolName = tool.Name:lower()
            local isMiningTool = false
            for _, name in ipairs(miningToolNames) do
                if toolName:find(name:lower()) then
                    isMiningTool = true
                    break
                end
            end
            if isMiningTool then
                local toolValue = 0
                if toolName:find("pickaxe") then toolValue = 100
                elseif toolName:find("drill") then toolValue = 90
                elseif toolName:find("hammer") then toolValue = 80
                elseif toolName:find("axe") then toolValue = 70
                else toolValue = 10 end

                if toolValue > bestToolValue then
                    bestToolValue = toolValue
                    bestTool = tool
                end
            end
        end
    end

    if bestTool then
        bestTool.Parent = char
        return bestTool
    end

    for _, tool in ipairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = char
            return tool
        end
    end

    return nil
end

local function smoothLookAt(hrp, targetPos, duration)
    local start = tick()
    local initialCFrame = hrp.CFrame
    while tick() - start < (duration or 0.25) do
        local alpha = math.clamp((tick() - start) / (duration or 0.25), 0, 1)
        local lookCFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, targetPos.Y + 2, targetPos.Z))
        hrp.CFrame = initialCFrame:Lerp(lookCFrame, alpha)
        RunService.RenderStepped:Wait()
    end
end

local function moveToTargetSmooth(char, destination)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return false end

    local path = nil
    local success, err = pcall(function()
        path = PathfindingService:CreatePath({
            AgentHeight = 5,
            AgentRadius = 2,
            AgentCanJump = true,
            WaypointSpacing = 4
        })
        path:ComputeAsync(hrp.Position, destination)
    end)

    if not path or path.Status ~= Enum.PathStatus.Success then
        return false
    end

    local waypoints = path:GetWaypoints()
    for i, wp in ipairs(waypoints) do
        if not _G.AutoMine then return false end
        local wpPos = wp.Position
        hum:MoveTo(wpPos)
        local reached = hum.MoveToFinished:Wait()
        local lookPos = destination
        smoothLookAt(hrp, lookPos, 0.18)
        task.wait(0.05)
    end

    return true
end

Tab2:Toggle({
    Title = "Auto Farm",
    Desc = "Automatic Farm Mine",
    Value = false,
    Callback = function(state)
        _G.AutoMine = state

        if _G.AutoMine then
            enableNoclip()
            local plr = Players.LocalPlayer
            if plr and plr.Character then
                equipBestMiningTool()
            end
        else
            disableNoclip()
        end

        if _G.AutoMine and ownDebounce then
            return
        end

        task.spawn(function()
            ownDebounce = true
            if _G.AutoMine then
                enableNoclip()
            end

            while _G.AutoMine do
                task.wait(0.5)
                local plr = Players.LocalPlayer
                if not plr then break end
                local char = plr.Character
                if not char then
                    char = plr.CharacterAdded:Wait()
                    task.wait(0.5)
                end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")

                if not hrp or not hum then
                    task.wait(1)
                    continue
                end

                local equipped = char:FindFirstChildOfClass("Tool")
                if not equipped then
                    equipped = equipBestMiningTool()
                end

                if #SelectedRocks == 0 then
                    SelectedRocks = {"Pebble"}
                end

                local validTargets = {}
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") or obj:IsA("Model") then
                        for _, rockName in ipairs(SelectedRocks) do
                            if obj.Name == rockName then
                                table.insert(validTargets, obj)
                                break
                            end
                        end
                    end
                end

                if #validTargets == 0 then
                    task.wait(2)
                    continue
                end

                local nearestObj = nil
                local nearestDist = math.huge
                for _, obj in ipairs(validTargets) do
                    local targetPart = nil
                    local targetPos = nil
                    if obj:IsA("Model") then
                        targetPart = obj.PrimaryPart
                        if not targetPart then
                            for _, child in ipairs(obj:GetChildren()) do
                                if child:IsA("BasePart") then
                                    targetPart = child
                                    break
                                end
                            end
                        end
                        if targetPart then targetPos = targetPart.Position end
                    elseif obj:IsA("BasePart") then
                        targetPart = obj
                        targetPos = obj.Position
                    end

                    if targetPos then
                        local distance = (hrp.Position - targetPos).Magnitude
                        if distance < nearestDist then
                            nearestDist = distance
                            nearestObj = { model = obj, part = targetPart, position = targetPos }
                        end
                    end
                end

                if not nearestObj then
                    task.wait(2)
                    continue
                end

                local targetPos = nearestObj.position
                local undergroundStart = Vector3.new(hrp.Position.X, hrp.Position.Y - 8, hrp.Position.Z)
                hrp.CFrame = CFrame.new(undergroundStart) -- teleport down once to be under ground (safe)
                task.wait(0.2)

                enableNoclip()
                task.wait(0.15)

                local destBelow = Vector3.new(targetPos.X, targetPos.Y - 6, targetPos.Z)

                local moved = moveToTargetSmooth(char, destBelow)
                if not moved then
                    -- fallback: try MoveTo directly a few times
                    for i = 1, 3 do
                        if not _G.AutoMine then break end
                        hum:MoveTo(destBelow)
                        hum.MoveToFinished:Wait()
                        smoothLookAt(hrp, targetPos, 0.12)
                    end
                end

                -- face the object smoothly and slightly tilt up
                smoothLookAt(hrp, targetPos, 0.25)

                local miningTime = 0
                local maxMiningTime = 20

                while _G.AutoMine and miningTime < maxMiningTime do
                    if not nearestObj.model or not nearestObj.model.Parent then
                        break
                    end

                    if nearestObj.part and nearestObj.part.Parent then
                        local newPos = nearestObj.part.Position
                        targetPos = newPos
                    end

                    if equipped and equipped.Parent == char then
                        pcall(function()
                            if equipped:FindFirstChild("Activate") or equipped:IsA("Tool") then
                                equipped:Activate()
                            else
                                if equipped.Activate then
                                    equipped:Activate()
                                end
                            end
                        end)
                    else
                        equipped = equipBestMiningTool()
                    end

                    smoothLookAt(hrp, targetPos, 0.12)

                    task.wait(0.45)
                    miningTime = miningTime + 0.45

                    if nearestObj.part then
                        if nearestObj.part.Transparency >= 1 or nearestObj.part.Size.Magnitude < 0.1 or not nearestObj.part.Parent then
                            break
                        end
                    end
                end

                task.wait(0.6)
            end

            ownDebounce = false
            disableNoclip()
        end)
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if _G.AutoMine then
        enableNoclip()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        if hrp and hum then
            task.wait(0.5)
            equipBestMiningTool()
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0,0,0)
        end
    end
end)

game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    if noclipConnection then
        disableNoclip()
    end
end)
