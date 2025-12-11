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
    Icon = "rbxassetid://86466533300907",
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
    Enabled = false,
})

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local G2L = {}

G2L["ScreenGui_1"] = Instance.new("ScreenGui")
G2L["ScreenGui_1"].Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
G2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CollectionService:AddTag(G2L["ScreenGui_1"], "main")

G2L["ButtonRezise_2"] = Instance.new("ImageButton")
G2L["ButtonRezise_2"].Parent = G2L["ScreenGui_1"]
G2L["ButtonRezise_2"].BorderSizePixel = 0
G2L["ButtonRezise_2"].Draggable = true
G2L["ButtonRezise_2"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
G2L["ButtonRezise_2"].Image = "rbxassetid://123032091977400"
G2L["ButtonRezise_2"].Size = UDim2.new(0, 60, 0, 60)
G2L["ButtonRezise_2"].Position = UDim2.new(0.13, 0, 0.03, 0)

local corner = Instance.new("UICorner", G2L["ButtonRezise_2"])
corner.CornerRadius = UDim.new(0, 8)

local neon = Instance.new("UIStroke", G2L["ButtonRezise_2"])
neon.Thickness = 2
neon.Color = Color3.fromRGB(0, 255, 0)
neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

G2L["ButtonRezise_2"].MouseButton1Click:Connect(function()
    G2L["ButtonRezise_2"].Visible = false
    Window:Open()
end)

Window:OnClose(function()
    G2L["ButtonRezise_2"].Visible = true
end)

Window:OnDestroy(function()
    G2L["ButtonRezise_2"].Visible = false
end)

G2L["ButtonRezise_2"].Visible = false

G2L["ButtonRezise_2"].Visible = false

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

local SelectedRocks = { "Pebble" }

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
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

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

-- dynamic slide move: update dest while moving (speed = 26)
local function moveToTargetSmooth(char, getTargetPartFunc)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hrp then return false end

    local speed = 26
    local timeout = 14
    local startTime = tick()

    local function reached(dest)
        return (hrp.Position - dest).Magnitude <= 1.6
    end

    -- get initial dest
    local part = getTargetPartFunc()
    if not part or not part.Parent then return false end
    local dest = Vector3.new(part.Position.X, part.Position.Y - 6, part.Position.Z)

    while _G.AutoMine and tick() - startTime < timeout do
        -- refresh target part each loop
        part = getTargetPartFunc()
        if not part or not part.Parent then return false end
        dest = Vector3.new(part.Position.X, part.Position.Y - 6, part.Position.Z)

        if reached(dest) then return true end

        local dt = 1/60
        local dir = dest - hrp.Position
        local dist = dir.Magnitude
        if dist > 0.01 then
            local moveStep = dir.Unit * math.min(speed * dt, dist)
            local newPos = hrp.Position + moveStep
            local lookC = CFrame.new(newPos, Vector3.new(part.Position.X, part.Position.Y + 2, part.Position.Z))
            hrp.CFrame = hrp.CFrame:Lerp(lookC, 0.48)
        end

        RunService.RenderStepped:Wait()
    end

    return (hrp.Position - dest).Magnitude <= 1.6
end

-- global flag (tidak clash dengan _G.AutoMine)
_G.AutoOreSleep = false
local sleepDebounce = false

-- helper: cari part/model batu terdekat yang nama cocok dengan SelectedRocks
local function GetNearestRockForSleep()
    local plr = Players.LocalPlayer
    if not plr or not plr.Character then return nil end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest = nil
    local ndist = math.huge

    -- perhatikan: kita mencari BasePart atau Model yang matching SelectedRocks
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            for _, name in ipairs(SelectedRocks) do
                if obj.Name == name then
                    -- dapatkan representative part
                    local part = nil
                    if obj:IsA("BasePart") then
                        part = obj
                    elseif obj:IsA("Model") then
                        part = obj.PrimaryPart
                        if not part then
                            for _, c in ipairs(obj:GetChildren()) do
                                if c:IsA("BasePart") then
                                    part = c
                                    break
                                end
                            end
                        end
                    end
                    if part and part.Parent then
                        local d = (hrp.Position - part.Position).Magnitude
                        if d < ndist then
                            ndist = d
                            nearest = part
                        end
                    end
                    break
                end
            end
        end
    end

    return nearest
end

-- fungsi untuk "tidur/nempel" di atas batu dan auto-pukul
local function SleepAndMineAtRock(part)
    local plr = Players.LocalPlayer
    if not plr or not plr.Character then return false end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    -- pastikan pakai tool yang sesuai
    local equipped = plr.Character:FindFirstChildOfClass("Tool")
    if not equipped then
        equipped = equipBestMiningTool()
        task.wait(0.12)
    end

    -- posisi: sedikit di atas batu, nempel
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
    end)

    -- loop pukul hingga hilang atau flag dimatikan
    local maxTime = 30
    local start = tick()
    while _G.AutoOreSleep and tick() - start < maxTime do
        if not part or not part.Parent then break end
        -- re-equip bila perlu
        if not (equipped and equipped.Parent == plr.Character) then
            equipped = equipBestMiningTool()
        end

        -- face ke target
        if hrp and part.Position then
            smoothLookAt(hrp, part.Position, 0.06)
        end

        -- aktifkan tool jika ada
        if equipped and equipped.Parent == plr.Character then
            pcall(function()
                if equipped:FindFirstChild("Activate") or equipped:IsA("Tool") then
                    equipped:Activate()
                else
                    if equipped.Activate then equipped:Activate() end
                end
            end)
        end

        task.wait(0.12)
        -- jika part hilang, break
        if not part.Parent or part.Transparency >= 1 or part.Size.Magnitude < 0.1 then
            break
        end
    end

    return true
end

-- UI Toggle untuk Mode Tidur
Tab2:Toggle({
    Title = "Auto Farm Rock",
    Desc = "Automatic farm rock NEW",
    Value = false,
    Callback = function(state)
        _G.AutoOreSleep = state

        -- jika diaktifkan, pastikan noclip untuk nembus tanah (re-use fungsi)
        if _G.AutoOreSleep then
            enableNoclip()
        else
            -- matikan noclip jika tidak ada _G.AutoMine berjalan
            if not _G.AutoMine then
                disableNoclip()
            end
        end

        if _G.AutoOreSleep and sleepDebounce then return end

        task.spawn(function()
            sleepDebounce = true
            while _G.AutoOreSleep do
                task.wait(0.35)
                local plr = Players.LocalPlayer
                if not plr then break end
                if not plr.Character or not plr.Character.Parent then
                    plr.CharacterAdded:Wait()
                    task.wait(0.6)
                end
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then task.wait(0.6) continue end

                -- cari rock terdekat
                local rockPart = GetNearestRockForSleep()
                if not rockPart then
                    task.wait(1.2)
                    continue
                end

                -- nempel di atas rock (teleport sedikit di atas)
                pcall(function()
                    hrp.CFrame = CFrame.new(rockPart.Position + Vector3.new(0,2.2,0))
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end)

                -- panggil loop mining "sleep" (sampai batu hilang atau timeout)
                SleepAndMineAtRock(rockPart)

                task.wait(0.45)
            end
            sleepDebounce = false
            -- nonaktifkan noclip jika kedua mode mati
            if not _G.AutoMine and not _G.AutoOreSleep then
                disableNoclip()
            end
        end)
    end
})

-- Pastikan saat respawn, mode Sleep tetap equip tool jika diaktifkan
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if _G.AutoOreSleep or _G.AutoMine then
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
