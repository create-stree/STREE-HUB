loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)

local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = "Premium - 100 Days At Sea",
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/Config.json"
})

local Tabs = {
    Home = Window:Tab({ Title = "Home", Icon = "scan-face" }),
    Main = Window:Tab({ Title = "Main", Icon = "landmark" }),
    Visual = Window:Tab({ Title = "Visual", Icon = "eye" }),
    Misc = Window:Tab({ Title = "Miscellaneous", Icon = "layout-grid" }),
    Settings = Window:Tab({ Title = "Settings", Icon = "settings" }),
}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local defaultWalk = 16
local defaultJump = 50

local lootKeywords = {
    "wood","plastic","scrap","metal","barrel","crate",
    "box","plank","bolt","leaf","stone","rope","cloth","goo"
}

local function getBasePart(v)
    if v:IsA("BasePart") then return v end
    if v:IsA("Model")    then return v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart") end
    return nil
end

local function findNearest(name)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == name then
            local part = getBasePart(v)
            if part then
                local d = (part.Position - hrp.Position).Magnitude
                if d < dist then dist = d; nearest = part end
            end
        end
    end
    return nearest
end


Tabs.Home:Section({ Title = "Information" })

Tabs.Home:Button({
    Title = "Discord",
    Desc = "Copy Discord Link",
    Callback = function()
        if setclipboard then setclipboard("https://discord.gg/jdmX43t5mY") end
    end
})

Tabs.Home:Paragraph({ 
    Title = "Join Us",
    Desc = "Every Update Will Be On Discord"
})

Tabs.Home:Paragraph({ 
    Title = "Support", 
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible." 
})

Tabs.Home:Section({ Title = "Local Player" })

Tabs.Home:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = defaultWalk },
    Callback = function(value)
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

Tabs.Home:Slider({
    Title = "JumpPower",
    Step = 1,
    Value = { Min = 0, Max = 150, Default = defaultJump },
    Callback = function(value)
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end
})

Tabs.Home:Button({
    Title = "Reset Default",
    Callback = function()
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = defaultWalk
            char.Humanoid.JumpPower = defaultJump
        end
    end
})


Tabs.Main:Section({ Title = "Dropper" })

Tabs.Main:Button({
    Title = "Goto Dropper",
    Callback = function()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local part = findNearest("Dropper")
        if part then hrp.CFrame = part.CFrame * CFrame.new(0, 5, 0) end
    end
})

local bringLootOn = false
Tabs.Main:Toggle({
    Title = "Bring Loot To Player",
    Default = false,
    Callback = function(state)
        bringLootOn = state
        task.spawn(function()
            while bringLootOn do
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local idx = 0
                    for _, v in pairs(workspace:GetDescendants()) do
                        local isLoot = false
                        for _, key in pairs(lootKeywords) do
                            if v.Name:lower():find(key) then isLoot = true; break end
                        end
                        if isLoot then
                            local part = getBasePart(v)
                            if part then
                                local angle  = idx * 1.1
                                local radius = 1.8 + idx * 0.3
                                part.CFrame = CFrame.new(hrp.Position + Vector3.new(
                                    math.cos(angle) * radius, 0, math.sin(angle) * radius
                                ))
                                idx += 1
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

Tabs.Main:Section({ Title = "Collection" })

Tabs.Main:Button({
    Title = "Goto Collection",
    Callback = function()
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local part = findNearest("Collection")
        if part then hrp.CFrame = part.CFrame * CFrame.new(0, 5, 0) end
    end
})

local bringToCollectionOn = false
Tabs.Main:Toggle({
    Title = "Bring Loot to Collection",
    Default = false,
    Callback = function(state)
        bringToCollectionOn = state
        task.spawn(function()
            while bringToCollectionOn do
                local hrp        = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local targetPart = hrp and findNearest("Collection")
                if targetPart then
                    local idx = 0
                    for _, v in pairs(workspace:GetDescendants()) do
                        local isLoot = false
                        for _, key in pairs(lootKeywords) do
                            if v.Name:lower():find(key) then isLoot = true; break end
                        end
                        if isLoot then
                            local part = getBasePart(v)
                            if part then
                                local angle  = idx * 1.1
                                local radius = 0.8 + idx * 0.2
                                part.CFrame  = CFrame.new(targetPart.Position + Vector3.new(
                                    math.cos(angle) * radius, 1, math.sin(angle) * radius
                                ))
                                idx += 1
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

Tabs.Main:Section({ Title = "Crafting" })

Tabs.Main:Button({
    Title = "Open / Close Crafting UI",
    Callback = function()
        local craftGui = LP.PlayerGui:FindFirstChild("Crafting")
        if craftGui then
            craftGui.Enabled = not craftGui.Enabled
        else
            local ok, prompt = pcall(function()
                return workspace:WaitForChild("SpawnIsland",    3)
                    :WaitForChild("CraftingTable",   3)
                    :WaitForChild("CraftingBrick",   3)
                    :WaitForChild("ProximityPrompt", 3)
            end)
            if ok and prompt then
                fireproximityprompt(prompt)
            else
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.ActionText == "Craft" then
                        fireproximityprompt(v); break
                    end
                end
            end
        end
    end
})

Tabs.Main:Button({
    Title = "Instant Interact",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "CollectionTime") ~= nil then v.CollectionTime = 0 end
                if rawget(v, "HoldTime")       ~= nil then v.HoldTime       = 0 end
                if rawget(v, "InteractTime")   ~= nil then v.InteractTime   = 0 end
            end
        end
    end
})


Tabs.Visual:Section({ Title = "ESP" })

local lootEspOn = false
Tabs.Visual:Toggle({
    Title = "Item ESP",
    Default = false,
    Callback = function(state)
        lootEspOn = state
        task.spawn(function()
            while lootEspOn do
                for _, v in pairs(workspace:GetDescendants()) do
                    if not v:FindFirstChild("_ItemESP") then
                        local isLoot = false
                        for _, key in pairs(lootKeywords) do
                            if v.Name:lower():find(key) then isLoot = true; break end
                        end
                        if isLoot then
                            local anchor = getBasePart(v)
                            if anchor then
                                local bg = Instance.new("BillboardGui", anchor)
                                bg.Name = "_ItemESP"; bg.Size = UDim2.new(0, 130, 0, 45)
                                bg.AlwaysOnTop = true; bg.ExtentsOffset = Vector3.new(0, 2, 0)
                                local tl = Instance.new("TextLabel", bg)
                                tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1
                                tl.TextColor3 = Color3.fromRGB(0, 220, 255)
                                tl.Font = Enum.Font.GothamBold; tl.TextSize = 11
                                tl.TextStrokeTransparency = 0.4
                                tl.Text = "[ " .. v.Name .. " ]"
                            end
                        end
                    end
                end
                task.wait(2.5)
            end
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "_ItemESP" then v:Destroy() end
            end
        end)
    end
})

local pEspOn = false
Tabs.Visual:Toggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        pEspOn = state
        task.spawn(function()
            while pEspOn do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local char = p.Character
                        local hrp  = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            if not char:FindFirstChild("_PHL") then
                                local hl = Instance.new("Highlight", char)
                                hl.Name = "_PHL"
                                hl.FillColor    = Color3.fromRGB(100, 0, 200)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            end
                            if not hrp:FindFirstChild("_PLbl") then
                                local b = Instance.new("BillboardGui", hrp)
                                b.Name = "_PLbl"; b.Size = UDim2.new(0, 160, 0, 50)
                                b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0, 3, 0)
                                local t = Instance.new("TextLabel", b)
                                t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1
                                t.TextColor3 = Color3.fromRGB(255, 255, 255)
                                t.Font = Enum.Font.GothamBold; t.TextSize = 12
                                t.TextStrokeTransparency = 0
                                task.spawn(function()
                                    while hrp and hrp.Parent and pEspOn do
                                        local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                                        if myHRP then
                                            local dist = math.floor((myHRP.Position - hrp.Position).Magnitude)
                                            t.Text = "⚡ " .. p.Name .. "\n[" .. dist .. " m]"
                                        end
                                        task.wait(0.1)
                                    end
                                    b:Destroy()
                                end)
                            end
                        end
                    end
                end
                task.wait(2)
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then
                    local hl = p.Character:FindFirstChild("_PHL")
                    if hl then hl:Destroy() end
                end
            end
        end)
    end
})


Tabs.Misc:Section({ Title = "Players" })

local infJump = false
local noclip = false
local antiAFK = false
local afkConnection
local autoReconnect = false

Tabs.Misc:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        infJump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

Tabs.Misc:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        noclip = state
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if noclip then
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

Tabs.Misc:Section({ Title = "Performance" })

Tabs.Misc:Button({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
})

Tabs.Misc:Section({ Title = "Session" })

Tabs.Misc:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(state)
        antiAFK = state
        if antiAFK then
            local vu = game:GetService("VirtualUser")
            afkConnection = game.Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end
})

Tabs.Misc:Toggle({
    Title = "Auto Reconnect",
    Default = false,
    Callback = function(state)
        autoReconnect = state
        if autoReconnect then
            local ts = game:GetService("TeleportService")
            local player = game.Players.LocalPlayer
            game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if autoReconnect and child.Name == "ErrorPrompt" then
                    task.wait(2)
                    ts:Teleport(game.PlaceId, player)
                end
            end)
        end
    end
})


local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game.Players.LocalPlayer
local inputObj = ""

Tabs.Settings:Section({ Title = "Server" })

Tabs.Settings:Paragraph({
    Title = "Current Server",
    Desc = game.JobId
})

Tabs.Settings:Button({
    Title = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Settings:Button({
    Title = "Server Hop",
    Callback = function()
        local success, result = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet(
                    "https://games.roblox.com/v1/games/" ..
                    game.PlaceId ..
                    "/servers/Public?sortOrder=Asc&limit=100"
                )
            )
        end)
        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(
                        game.PlaceId,
                        server.id,
                        LocalPlayer
                    )
                    break
                end
            end
        end
    end
})

Tabs.Settings:Section({ Title = "Teleport" })

Tabs.Settings:Input({
    Title = "Target Server ID",
    Default = "",
    Placeholder = "Enter JobId...",
    MultiLine = false,
    Callback = function(input)
        inputObj = tostring(input)
    end
})

Tabs.Settings:Button({
    Title = "Teleport To JobId",
    Callback = function()
        if inputObj ~= "" then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    inputObj,
                    LocalPlayer
                )
            end)
        end
    end
})


StreeHub:Notify({
    Title = "StreeHub",
    Content = "Script loaded successfully",
    Icon = "bell-ring",
    Duration = 4
})
