local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to loaded!")
    return
else
    print("✓ UI loaded successfully!")
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

local function setStatus(t)
    print("[STREE]", tostring(t))
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

local Tab2 = Window:Tab({ Title = "Main", Icon = "landmark" })

local oreFarm = {
    enabled = false,
    scanDistance = 500,
    tweenSpeed = 120,
    selectedRockTypes = {},
    selectedOreTypes = {},
    rocksESPEnabled = false,
    maxRockTime = 4,
    mineInterval = 0.1
}

Tab2:Slider({
    Title = "Scan Distance",
    Value = { Min = 50, Max = 1000, Default = 500 },
    Callback = function(v)
        oreFarm.scanDistance = v
    end
})

Tab2:Slider({
    Title = "Tween Speed",
    Value = { Min = 20, Max = 200, Default = 120 },
    Callback = function(v)
        oreFarm.tweenSpeed = v
    end
})

local function getHRP()
    local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end

local function collectRocks()
    local list = {}
    local root = workspace:FindFirstChild("Rocks")
    if not root then return list end
    for _, f in ipairs(root:GetChildren()) do
        for _, r in ipairs(f:GetChildren()) do
            local p = r.PrimaryPart or r:FindFirstChildWhichIsA("BasePart")
            if p then
                table.insert(list, { model = r, core = p })
            end
        end
    end
    return list
end

local function tweenTo(pos)
    local hrp = getHRP()
    local d = (pos - hrp.Position).Magnitude
    local t = d / oreFarm.tweenSpeed
    TweenService:Create(hrp, TweenInfo.new(t), {
        CFrame = CFrame.new(pos + Vector3.new(0,3,0))
    }):Play()
end

Tab2:Toggle({
    Title = "Auto Farm Ores",
    Value = false,
    Callback = function(v)
        oreFarm.enabled = v
        if not v then return end
        task.spawn(function()
            while oreFarm.enabled do
                local rocks = collectRocks()
                local hrp = getHRP()
                table.sort(rocks, function(a,b)
                    return (a.core.Position-hrp.Position).Magnitude <
                           (b.core.Position-hrp.Position).Magnitude
                end)
                local target = rocks[1]
                if target then
                    tweenTo(target.core.Position)
                end
                task.wait(0.3)
            end
        end)
    end
})

local mobFarm = {
    enabled = false,
    mobsESPEnabled = false,
    selectedMobs = {}
}

local function collectMobs()
    local list = {}
    local living = workspace:FindFirstChild("Living")
    if not living then return list end
    for _, m in ipairs(living:GetChildren()) do
        local hrp = m:FindFirstChild("HumanoidRootPart")
        if hrp then
            table.insert(list, { model = m, hrp = hrp })
        end
    end
    return list
end

Tab2:Toggle({
    Title = "Auto Farm Mobs",
    Value = false,
    Callback = function(v)
        mobFarm.enabled = v
        if not v then return end
        task.spawn(function()
            while mobFarm.enabled do
                local mobs = collectMobs()
                local hrp = getHRP()
                table.sort(mobs, function(a,b)
                    return (a.hrp.Position-hrp.Position).Magnitude <
                           (b.hrp.Position-hrp.Position).Magnitude
                end)
                local target = mobs[1]
                if target then
                    tweenTo(target.hrp.Position)
                end
                task.wait(0.3)
            end
        end)
    end
})

local autoForge = {
    enabled = false,
    itemType = "Weapon",
    weaponThreshold = 10,
    armorThreshold = 10,
    mode = "Above"
}

local Tab3 = Window:Tab({ Title = "Forge", Icon = "anvil" })

Tab3:Dropdown({
    Title = "Item Type",
    Values = { "Weapon", "Armor" },
    Value = { autoForge.itemType },
    Callback = function(o)
        autoForge.itemType = o[1]
    end
})

Tab3:Toggle({
    Title = "Auto Forge",
    Value = false,
    Callback = function(v)
        autoForge.enabled = v
        if v then
            setStatus("Auto Forge Enabled")
        else
            setStatus("Auto Forge Disabled")
        end
    end
})
