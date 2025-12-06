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
local Xoffset, Yoffset, Zoffset = 0, 4, 0

local function safe(obj)
    return obj ~= nil
end

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
        end
    end
})

Tab2:Slider({
    Title = "X Offset",
    Min = -20,
    Max = 20,
    Value = 0,
    Callback = function(v)
        Xoffset = v
    end
})

Tab2:Slider({
    Title = "Y Offset",
    Min = -20,
    Max = 20,
    Value = 4,
    Callback = function(v)
        Yoffset = v
    end
})

Tab2:Slider({
    Title = "Z Offset",
    Min = -20,
    Max = 20,
    Value = 0,
    Callback = function(v)
        Zoffset = v
    end
})

local flying = false
local noclipConn = nil

local function enableFly(char)
    if flying then return end
    flying = true
    local hrp = safe(char) and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    local bg = Instance.new("BodyGyro")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = hrp
    bg.Parent = hrp
    task.spawn(function()
        while flying do
            task.wait()
            bg.CFrame = workspace.Camera.CFrame
        end
        bv:Destroy()
        bg:Destroy()
    end)
end

local function disableFly()
    flying = false
end

local function enableNoclip()
    if noclipConn then return end
    noclipConn = game.RunService.Stepped:Connect(function()
        local char = game.Players.LocalPlayer.Character
        if safe(char) then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

_G.AutoFarm = false

Tab2:Toggle({
    Title = "Auto Farm",
    Desc = "Walking, Flying, Noclip",
    Value = false,
    Callback = function(state)
        _G.AutoFarm = state
        task.spawn(function()
            while _G.AutoFarm do
                task.wait(0.2)

                local plr = game.Players.LocalPlayer
                local char = plr.Character
                if not safe(char) then continue end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end

                if #SelectedRocks == 0 then
                    SelectedRocks = { "Pebble" }
                end

                local nearestObj, nearestDist, nearestPart = nil, math.huge, nil

                for _, obj in ipairs(workspace:GetDescendants()) do
                    for _, name in ipairs(SelectedRocks) do
                        if obj.Name:lower():find(name:lower()) then
                            local p = nil
                            if obj:IsA("BasePart") then
                                p = obj
                            elseif obj:IsA("Model") then
                                p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            end
                            if p then
                                local d = (hrp.Position - p.Position).Magnitude
                                if d < nearestDist then
                                    nearestObj = obj
                                    nearestDist = d
                                    nearestPart = p
                                end
                            end
                        end
                    end
                end

                if not nearestPart then continue end

                enableFly(char)
                enableNoclip()

                local target = nearestPart.Position + Vector3.new(Xoffset, Yoffset, Zoffset)
                local dir = (target - hrp.Position).Unit

                local bv = hrp:FindFirstChildOfClass("BodyVelocity")
                if bv then
                    bv.Velocity = dir * 25
                end

                local tool = char:FindFirstChildOfClass("Tool") or plr.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = char
                    tool:Activate()
                end
            end

            disableFly()
            disableNoclip()
        end)
    end
})
