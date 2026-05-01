local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)


local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = (premium and "Premium" or "KALB") .. " - " .. version,
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/Config.json"
})


local Tabs = {
    Home = Window:Tab({ Title = "Home", Icon = "scan-face" }),
    Main = Window:Tab({ Title = "Main", Icon = "landmark" }),
    Upgrade = Window:Tab({ Title = "Upgrade", Icon = "chart-column-increasing" }),
    Shop = Window:Tab({ Title = "Shop", Icon = "shopping-bag" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "layout-grid" })
}


local defaultWalk = 16
local defaultJump = 50

local currentWalk = defaultWalk
local currentJump = defaultJump

Tabs.Home:Section({ Title = "Information" })

Tabs.Home:Button({
    Title = "Discord",
    Desc = "Copy Discord Link",
    Callback = function()
        local link = "https://discord.gg/jdmX43t5mY"
        if setclipboard then
            setclipboard(link)
        end
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

Tabs.Home:Paragraph({
    Title = "Test"
})

Tabs.Home:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = defaultWalk },
    Callback = function(value)
        currentWalk = value
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
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
        currentJump = value
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = value
        end
    end
})

Tabs.Home:Button({
    Title = "Reset Default",
    Callback = function()
        currentWalk = defaultWalk
        currentJump = defaultJump

        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = defaultWalk
            char.Humanoid.JumpPower = defaultJump
        end
    end
})


local TweenService = game:GetService("TweenService")
local tweenSpeed = 50
local x2Delay = 0.2
local selectedEquip = "Wooden Stick"
local selectedIndex = 1

Tabs.Main:Section({ Title = "Auto Kick" })

Tabs.Main:Button({
    Title = "Teleport Safe Zone",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        hrp.CFrame = CFrame.new(690.45, 2.79, 230.67)
    end
})

Tabs.Main:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        autofarm = state

        if autofarm then
            task.spawn(function()
                while autofarm do
                    local rs = game:GetService("ReplicatedStorage")
                    local kickEvent = rs.Shared.Packages.Network.rev_KickEvent
                    local collectEvent = rs.Shared.Packages.Network.rev_KickCollect

                    local player = game.Players.LocalPlayer
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")

                    kickEvent:FireServer(1)

                    task.wait(20)

                    local target = CFrame.new(690.45, 2.79, 230.67)
                    local distance = (hrp.Position - target.Position).Magnitude
                    local duration = distance / tweenSpeed

                    local tween = TweenService:Create(
                        hrp,
                        TweenInfo.new(duration, Enum.EasingStyle.Linear),
                        {CFrame = target}
                    )

                    tween:Play()
                    tween.Completed:Wait()

                    for i = 1, 8 do
                        collectEvent:FireServer()
                        task.wait(0.3)
                    end

                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Main:Slider({
    Title = "Tween Speed",
    Step = 1,
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(value)
        tweenSpeed = value
    end
})

local function clickX2()
    local player = game:GetService("Players").LocalPlayer
    local gui = player.PlayerGui:FindFirstChild("KickUpgrades")

    if not gui then return end

    for _, v in pairs(gui:GetDescendants()) do
        if v.Name == "Bonus" and (v:IsA("ImageButton") or v:IsA("TextButton")) then
            pcall(function()
                firesignal(v.Activated)
                firesignal(v.MouseButton1Click)
            end)
        end
    end
end

Tabs.Main:Section({ Title = "Auto Click X2" })

Tabs.Main:Toggle({
    Title = "Auto Click X2",
    Default = false,
    Callback = function(state)
        autoX2 = state

        if autoX2 then
            task.spawn(function()
                while autoX2 do
                    clickX2()
                    task.wait(x2Delay)
                end
            end)
        end
    end
})

Tabs.Main:Button({
    Title = "Click X2",
    Callback = function()
        clickX2()
    end
})

Tabs.Main:Slider({
    Title = "Auto Click Delay",
    Step = 0.05,
    Value = { Min = 0.1, Max = 1, Default = 0.2 },
    Callback = function(v)
        x2Delay = v
    end
})

Tabs.Main:Section({ Title = "Equip Weight" })

Tabs.Main:Dropdown({
    Title = "Equip Weight",
    Values = {
        "Wooden Stick",
        "Bone Barbell",
        "Stone Block",
        "Copper Plate",
        "Iron Plate",
        "Ice Barbell",
        "Donut Barbell",
        "Golden Barbell",
        "Heaven Plate",
        "Mega Golden Barbell",
        "Neon Pulse",
        "Giat Gold Star Barbell"
    },
    Value = "Wooden Stick",
    Callback = function(option)
        selectedEquip = option
    end
})

Tabs.Main:Button({
    Title = "Equip Weight",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_WeightEquip
            :FireServer(selectedEquip)
    end
})

Tabs.Main:Section({ Title = "Collect" })

Tabs.Main:Toggle({
    Title = "Auto Collect",
    Default = false,
    Callback = function(state)
        brainrotLoop = state

        if brainrotLoop then
            task.spawn(function()
                while brainrotLoop do
                    local event = game:GetService("ReplicatedStorage")
                        .Shared.Packages.Network.rev_B_Collect

                    for i = 1, 30 do
                        event:FireServer(i)
                        task.wait(0.05)
                    end

                    task.wait(0.5)
                end
            end)
        end
    end
})

Tabs.Main:Section({ Title = "Rebirt" })

Tabs.Main:Toggle({
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        rebirthLoop = state

        if rebirthLoop then
            task.spawn(function()
                while rebirthLoop do
                    game:GetService("ReplicatedStorage")
                        .Shared.Packages.Network.rev_RebirthRequest
                        :FireServer()
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Main:Button({
    Title = "Rebirth",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_RebirthRequest
            :FireServer()
    end
})

Tabs.Main:Section({ Title = "Base" })

Tabs.Main:Dropdown({
    Title = "Select Slot",
    Values = (function()
        local t = {}
        for i = 1, 30 do
            table.insert(t, tostring(i))
        end
        return t
    end)(),
    Value = "1",
    Callback = function(option)
        selectedIndex = tonumber(option)
    end
})

Tabs.Main:Button({
    Title = "Pick Up",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_S_Interact
            :FireServer(selectedIndex)
    end
})

Tabs.Main:Button({
    Title = "Place",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_S_Interact
            :FireServer(selectedIndex)
    end
})

Tabs.Main:Section({ Title = "Offline Reward" })

Tabs.Main:Button({
    Title = "Claim Offline Reward",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_Offline_Claim
            :FireServer()
    end
})

Tabs.Main:Toggle({
    Title = "Auto Claim Offline Reward",
    Default = false,
    Callback = function(state)
        offlineLoop = state

        if offlineLoop then
            task.spawn(function()
                while offlineLoop do
                    game:GetService("ReplicatedStorage")
                        .Shared.Packages.Network.rev_Offline_Claim
                        :FireServer()
                    task.wait(5)
                end
            end)
        end
    end
})

Tabs.Main:Section({ Title = "Sell" })

Tabs.Main:Button({
    Title = "Sell Brainrot",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.ref_B_Sell
            :InvokeServer()
    end
})

Tabs.Main:Button({
    Title = "Sell All Brainrot",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.ref_B_SellAll
            :InvokeServer()
    end
})

Tabs.Main:Toggle({
    Title = "Auto Sell Brainrot",
    Default = false,
    Callback = function(state)
        sellLoop = state

        if sellLoop then
            task.spawn(function()
                while sellLoop do
                    game:GetService("ReplicatedStorage")
                        .Shared.Packages.Network.ref_B_Sell
                        :InvokeServer()

                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Sell All Brainrot",
    Default = false,
    Callback = function(state)
        sellAllLoop = state

        if sellAllLoop then
            task.spawn(function()
                while sellAllLoop do
                    game:GetService("ReplicatedStorage")
                        .Shared.Packages.Network.ref_B_SellAll
                        :InvokeServer()

                    task.wait(2)
                end
            end)
        end
    end
})


Tabs.Upgrade:Section({ Title = "Upgrade Base" })

Tabs.Upgrade:Button({
    Title = "Upgrade Base",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_bs_upgrade
            :FireServer()
    end
})

Tabs.Upgrade:Toggle({
    Title = "Auto Upgrade Base",
    Default = false,
    Callback = function(state)
        bsLoop = state

        if bsLoop then
            task.spawn(function()
                while bsLoop do
                    game:GetService("ReplicatedStorage")
                        .Shared.Packages.Network.rev_bs_upgrade
                        :FireServer()
                    task.wait(0.5)
                end
            end)
        end
    end
})

Tabs.Upgrade:Section({ Title = "Upgrade Brainrot" })

Tabs.Upgrade:Dropdown({
    Title = "Upgrade Brainrot Place",
    Values = (function()
        local t = {}
        for i = 1, 30 do
            table.insert(t, tostring(i))
        end
        return t
    end)(),
    Value = "1",
    Callback = function(option)
        selectedLevel = tonumber(option)
    end
})

Tabs.Upgrade:Button({
    Title = "Upgrade Brainrot",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_B_Upgrade
            :FireServer(selectedLevel)
    end
})

Tabs.Upgrade:Toggle({
    Title = "Auto Upgrade Brainrot",
    Default = false,
    Callback = function(state)
        upgradeLoop = state

        if upgradeLoop then
            task.spawn(function()
                while upgradeLoop do
                    game:GetService("ReplicatedStorage")
                        .Shared.Packages.Network.rev_B_Upgrade
                        :FireServer(selectedLevel)
                    task.wait(0.5)
                end
            end)
        end
    end
})


local selectedSpeed = 1
local selectedItem = "Wooden Stick"

Tabs.Shop:Section({ Title = "Speed Shop" })

Tabs.Shop:Dropdown({
    Title = "Speed Upgrade",
    Values = (function()
        local t = {}
        for i = 1, 11 do
            table.insert(t, tostring(i))
        end
        return t
    end)(),
    Value = "1",
    Callback = function(option)
        selectedSpeed = tonumber(option)
    end
})

Tabs.Shop:Button({
    Title = "Upgrade Speed",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_SPEED_UPGRADE
            :FireServer(selectedSpeed)
    end
})

Tabs.Shop:Section({ Title = "Weight Shop" })

Tabs.Shop:Dropdown({
    Title = "Weight Shop Item",
    Values = {
        "Wooden Stick",
        "Bone Barbell",
        "Stone Block",
        "Copper Plate",
        "Iron Plate",
        "Ice Barbell",
        "Donut Barbell",
        "Golden Barbell",
        "Heaven Plate",
        "Mega Golden Barbell",
        "Neon Pulse",
        "Giat Gold Star Barbell"
    },
    Value = "Bone Barbell",
    Callback = function(option)
        selectedItem = option
    end
})

Tabs.Shop:Button({
    Title = "Buy Weight Item",
    Callback = function()
        game:GetService("ReplicatedStorage")
            .Shared.Packages.Network.rev_Shop_Buy
            :FireServer("WeightShop", selectedItem)
    end
})


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

Tabs.Misc:Toggle({
    Title = "Anti AFK",
    Default = false,
    Callback = function(state)
        antiAFK = state

        if antiAFK then
            local vu = game:GetService("VirtualUser")

            afkConnection = game.Players.LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end
})

Tabs.Misc:Button({
    Title = "Rejoin",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        ts:Teleport(game.PlaceId, player)
    end
})

Tabs.Misc:Button({
    Title = "Server Hop",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        local placeId = game.PlaceId

        local servers = game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
        )

        for _, v in pairs(servers.data) do
            if v.playing < v.maxPlayers then
                ts:TeleportToPlaceInstance(placeId, v.id, player)
                break
            end
        end
    end
})


StreeHub:Notify({
    Title = "StreeHub",
    Content = "Script loaded successfully",
    Icon = "bell-ring",
    Duration = 4
})
