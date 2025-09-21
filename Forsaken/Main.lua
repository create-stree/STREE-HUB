local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://123032091977400",
    Author = "KirsiaSC | Forsaken",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0, 255, 0),
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info"
})

local Section = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab1:Button({
    Title = "Discord",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app")
        end
    end
})

local Section = Tab1:Section({
    Title = "Updates & Fixes",
    TextXAlignment = "Left",
    TextSize = 17
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user"
})

local Section = Tab2:Section({
    Title = "Movement",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab2:Slider({
    Title = "WalkSpeed",
    Description = "Adjust WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

Tab2:Slider({
    Title = "JumpPower",
    Description = "Adjust JumpPower",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end
})

Tab2:Toggle({
    Title = "Infinite Stamina",
    Desc = "Energy never decrease",
    Default = false,
    Callback = function(state)
        _G.InfiniteEnergy = state
        task.spawn(function()
            while _G.InfiniteEnergy do
                task.wait(0.2)
                local lp = game.Players.LocalPlayer
                if lp and lp.Character then
                    local char = lp.Character
                    if char:FindFirstChild("Energy") then pcall(function() char.Energy.Value = math.huge end) end
                    if char:FindFirstChild("Stamina") then pcall(function() char.Stamina.Value = math.huge end) end
                    if lp:FindFirstChild("Energy") then pcall(function() lp.Energy.Value = math.huge end) end
                    if lp:FindFirstChild("Stamina") then pcall(function() lp.Stamina.Value = math.huge end) end
                    if char:FindFirstChild("Humanoid") then
                        local hum = char.Humanoid
                        if hum:GetAttribute("Energy") then hum:SetAttribute("Energy", 999999) end
                        if hum:GetAttribute("Stamina") then hum:SetAttribute("Stamina", 999999) end
                    end
                end
            end
        end)
    end
})

local Tab3 = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

local Section = Tab3:Section({
    Title = "ESP Survivor",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab3:Toggle({
    Title = "Survivor Highlight",
    Desc = "Highlight survivors",
    Default = false,
    Callback = function(state)
        _G.SurvivorHighlight = state
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Team and player.Team.Name == "Survivor" and player.Character then
                if state then createSurvivorHighlight(player.Character) else removeSurvivorHighlight(player.Character) end
            end
        end
    end
})

Tab3:Toggle({
    Title = "Survivor Box",
    Desc = "Box survivors",
    Default = false,
    Callback = function(state)
        _G.SurvivorBox = state
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Team and player.Team.Name == "Survivor" and player.Character then
                if state then createSurvivorBox(player.Character) else removeSurvivorBox(player.Character) end
            end
        end
    end
})

local Section = Tab3:Section({
    Title = "ESP Killer",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab3:Toggle({
    Title = "Killer Highlight",
    Desc = "Highlight killer",
    Default = false,
    Callback = function(state)
        _G.KillerHighlight = state
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                if state then createKillerHighlight(player.Character) else removeKillerHighlight(player.Character) end
            end
        end
    end
})

Tab3:Toggle({
    Title = "Killer Box",
    Desc = "Box killer",
    Default = false,
    Callback = function(state)
        _G.KillerBox = state
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                if state then createKillerBox(player.Character) else removeKillerBox(player.Character) end
            end
        end
    end
})

Tab3:Toggle({
    Title = "Name & Distance",
    Desc = "Show player names and distance",
    Default = false,
    Callback = function(state)
        _G.NameDistanceESP = state
    end
})

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.NameDistanceESP then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    createNameDistanceESP(player.Character)
                end
            end
        end
    end
end)

-- ESP Functions
function createSurvivorHighlight(char)
    if not char or char:FindFirstChild("SurvivorHighlight") then return end
    local h = Instance.new("Highlight")
    h.Name = "SurvivorHighlight"
    h.FillColor = Color3.fromRGB(0,255,0)
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.Adornee = char
    h.Parent = char
end

function removeSurvivorHighlight(char)
    if char and char:FindFirstChild("SurvivorHighlight") then char.SurvivorHighlight:Destroy() end
end

function createSurvivorBox(char)
    if not char or not char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("SurvivorBox") then return end
    local b = Instance.new("BoxHandleAdornment")
    b.Name = "SurvivorBox"
    b.Adornee = char.HumanoidRootPart
    b.AlwaysOnTop = true
    b.ZIndex = 2
    b.Size = Vector3.new(4,6,2)
    b.Color3 = Color3.fromRGB(0,255,0)
    b.Transparency = 0.5
    b.Parent = char
end

function removeSurvivorBox(char)
    if char and char:FindFirstChild("SurvivorBox") then char.SurvivorBox:Destroy() end
end

function createKillerHighlight(char)
    if not char or char:FindFirstChild("KillerHighlight") then return end
    local h = Instance.new("Highlight")
    h.Name = "KillerHighlight"
    h.FillColor = Color3.fromRGB(255,0,0)
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.Adornee = char
    h.Parent = char
end

function removeKillerHighlight(char)
    if char and char:FindFirstChild("KillerHighlight") then char.KillerHighlight:Destroy() end
end

function createKillerBox(char)
    if not char or not char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("KillerBox") then return end
    local b = Instance.new("BoxHandleAdornment")
    b.Name = "KillerBox"
    b.Adornee = char.HumanoidRootPart
    b.AlwaysOnTop = true
    b.ZIndex = 2
    b.Size = Vector3.new(4,6,2)
    b.Color3 = Color3.fromRGB(255,0,0)
    b.Transparency = 0.5
    b.Parent = char
end

function removeKillerBox(char)
    if char and char:FindFirstChild("KillerBox") then char.KillerBox:Destroy() end
end

function createNameDistanceESP(char)
    if not char or not char:FindFirstChild("Head") then return end
    local gui = char:FindFirstChild("NameDistanceBillboard") or Instance.new("BillboardGui")
    gui.Name = "NameDistanceBillboard"
    gui.Adornee = char.Head
    gui.Size = UDim2.new(0,200,0,40)
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0,3.5,0)
    gui.Parent = char
    local txt = gui:FindFirstChild("TextLabel") or Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255,255,255)
    txt.TextStrokeColor3 = Color3.new(0,0,0)
    txt.TextStrokeTransparency = 0.5
    txt.Font = Enum.Font.SourceSans
    txt.TextSize = 14
    txt.TextScaled = false
    txt.Text = char.Name.." | "..math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude).." studs"
    txt.Parent = gui
end

function removeNameDistanceESP(char)
    if char and char:FindFirstChild("NameDistanceBillboard") then char.NameDistanceBillboard:Destroy() end
end

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings"
})

local Section = Tab5:Section({
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 17
})

Tab5:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle",
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        if state then
            task.spawn(function()
                while _G.AntiAFK do
                    task.wait(60)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end)
        end
    end
})

Tab5:Toggle({
    Title = "Auto Reconnect",
    Desc = "Reconnect if disconnected",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
    end
})
