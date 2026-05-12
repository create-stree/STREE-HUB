repeat task.wait() until game:IsLoaded()

local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)


local players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = players.LocalPlayer
local client = workspace:FindFirstChild(localPlayer.Name)
local clientHRP = client.HumanoidRootPart

localPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function getUserTime()
    return os.date(" at %I:%M %p, %m/%d/%Y")
end

function SendDiscordWebhook(url, data)
    local body = HttpService:JSONEncode({
        username = "StreeHub",
        avatar_url = "https://cdn.discordapp.com/attachments/1429845065752117268/1479099416055906334/Tak_berjudul76_20260203000028.png",
        embeds = {{
            title = "StreeHub | Slime Rng",
            color = 65280,
            fields = {
                {
                    name = "Player",
                    value = "|| User Protect StreeHub ||",
                    inline = false
                },
                {
                    name = "Rolls",
                    value = data.description,
                    inline = false
                }
            },
            footer = {
                text = "StreeHub Webhook" .. getUserTime()
            }
        }}
    })
    request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = body
    })
end

function TP(x, y, z)
    clientHRP.CFrame = CFrame.new(x, y, z)
end

local function getUpgradeTiles()
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local root = playerGui:FindFirstChild("Root")
    if not root then return nil end
    local upgradeScreen = root:FindFirstChild("UpgradeScreen")
    if not upgradeScreen then return nil end
    local upgradeContent = upgradeScreen:FindFirstChild("UpgradeContent")
    if not upgradeContent then return nil end
    local frame = upgradeContent:FindFirstChild("Frame")
    if not frame then return nil end
    return frame:GetChildren()
end

function Upgrade()
    local upgradeTiles = getUpgradeTiles()
    if upgradeTiles then
        for _, tile in pairs(upgradeTiles) do
            if tile.Name ~= "UIAspectRatioConstraint" and tile.Name ~= "UpgradeHoverInfo" then
                local upgrade = tile.Name:match("^(%S+)Tile")
                if upgrade then
                    local args = {"requestUnlock", upgrade}
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("UpgradeService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
                end
            end
        end
    end
end

function Roll()
    local args = {"requestRoll"}
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("RollService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
end

function ConsumePotions()
    local boosts = {"luck", "ultraLuck", "currency", "rollSpeed"}
    for _, boost in ipairs(boosts) do
        local args = {"requestUseBoost", boost}
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("BoostService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
    end
end

local function getTeleportZones()
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local root = playerGui:FindFirstChild("Root")
    if not root then return nil end
    local teleporter = root:FindFirstChild("Teleporter")
    if not teleporter then return nil end
    local content = teleporter:FindFirstChild("Content")
    if not content then return nil end
    local frame = content:FindFirstChild("Frame")
    if not frame then return nil end
    local scrollingFrame = frame:FindFirstChild("ScrollingFrame")
    if not scrollingFrame then return nil end
    return scrollingFrame:GetChildren()
end

function TeleportBestZone()
    local zones = workspace.Zones:GetChildren()
    local returnZones = {}
    for _, zone in pairs(zones) do
        local blockerName = "ClientGateBlocker_" .. zone.Name
        local gate = zone.Gate:FindFirstChild(blockerName)
        if gate then
            table.insert(returnZones, gate)
        end
    end
    local counter = 0
    for _, gateBlocker in pairs(returnZones) do
        if gateBlocker.CanCollide ~= true then
            if tonumber(gateBlocker.Parent.Parent.Name) > counter then
                counter = tonumber(gateBlocker.Parent.Parent.Name)
            end
        end
    end
    counter = counter + 1
    Teleport(counter)
end

function ClaimIndex()
    local rewards = {"basic", "big", "huge", "shiny", "inverted"}
    for _, reward in ipairs(rewards) do
        local args = {"requestClaimReward", reward}
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("IndexService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
        task.wait(0.1)
    end
end

function Teleport(worldNum)
    local args = {"requestTeleportZone", worldNum}
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("ZonesService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
end


local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = "Slime Rng",
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/config.json"
})


local Tabs = {
    Home = Window:Tab({ Title = "Home", Icon = "house" }),
    Main = Window:Tab({ Title = "Main", Icon = "landmark" }),
    Automatically = Window:Tab({ Title = "Automatically", Icon = "play" }),
    Webhook = Window:Tab({ Title = "Webhook", Icon = "webhook" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "layout-grid" }),
    Settings = Window:Tab({ Title = "Settings", Icon = "settings" })
}


local defaultWalk = 16
local defaultJump = 50
local currentWalk = defaultWalk
local currentJump = defaultJump
local autoRollEnabled = false
local autoIndexEnabled = false
local autoFarmEnabled = false
local autoUpgradeEnabled = false
local autoUpgradeInterval = 30
local autoTeleportBestZoneEnabled = false
local autoBestZoneInterval = 30
local autoBuyZoneEnabled = false
local autoRebirthEnabled = false
local autoPotionsEnabled = false
local autoEquipBestEnabled = false
local webhookEnabled = false
local webhookUrl = ""
local webhookInterval = 30
local infJump = false
local noclip = false
local antiAFK = false
local afkConnection
local autoReconnect = false
local savedServers = {}


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


Tabs.Main:Section({ Title = "Auto Farming" })

Tabs.Main:Toggle({
    Title = "Auto Roll",
    Default = false,
    Callback = function(state)
        autoRollEnabled = state
        if state then
            task.spawn(function()
                while autoRollEnabled do
                    local rollSpeedText = game:GetService("Players").LocalPlayer.PlayerGui.Root.BottomBarStats.StatsList.RollSpeedStat.Content.Value.TextLabel.Text
                    task.wait(tonumber(string.match(rollSpeedText, "[%d%.]+")) or 1)
                    Roll()
                end
            end)
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Index",
    Default = false,
    Callback = function(state)
        autoIndexEnabled = state
        if state then
            task.spawn(function()
                while autoIndexEnabled do
                    ClaimIndex()
                    task.wait(30)
                end
            end)
        end
    end
})

Tabs.Main:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(state)
        autoFarmEnabled = state
        if state then
            task.spawn(function()
                while autoFarmEnabled do
                    local drops = workspace.Loot:GetChildren()
                    for _, drop in pairs(drops) do
                        if drop then
                            for _, dropChild in pairs(drop:GetChildren()) do
                                if dropChild.Name ~= "LootHighlight" then
                                    dropChild.CFrame = CFrame.new(clientHRP.CFrame.X, clientHRP.CFrame.Y, clientHRP.CFrame.Z)
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

local autoTeleportBestZoneToggle = Tabs.Main:Toggle({
    Title = "Auto Best Zone",
    Default = false,
    Callback = function(state)
        autoTeleportBestZoneEnabled = state
        if state then
            task.spawn(function()
                while autoTeleportBestZoneEnabled do
                    TeleportBestZone()
                    task.wait(autoBestZoneInterval)
                end
            end)
        end
    end
})

local autoBestZoneIntervalInput = Tabs.Main:Input({
    Title = "Best Zone Interval",
    Default = "30",
    Placeholder = "Seconds",
    Callback = function(value)
        local num = tonumber(value)
        if num then autoBestZoneInterval = num end
    end
})

local autoPotionsToggle = Tabs.Main:Toggle({
    Title = "Auto Potions",
    Default = false,
    Callback = function(state)
        autoPotionsEnabled = state
        if state then
            task.spawn(function()
                while autoPotionsEnabled do
                    ConsumePotions()
                    task.wait(3)
                end
            end)
        end
    end
})

Tabs.Main:Section({ Title = "Manual" })

Tabs.Main:Button({
    Title = "Equip Best",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages._Index["leifstout_networker@0.3.1"].networker._remotes.InventoryService.RemoteFunction:InvokeServer("requestEquipBest")
    end
})

Tabs.Main:Button({
    Title = "Purchase Zone",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages._Index["leifstout_networker@0.3.1"].networker._remotes.ZonesService.RemoteFunction:InvokeServer("requestPurchaseZone")
    end
})

Tabs.Main:Button({
    Title = "Unlock Machine",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages._Index["leifstout_networker@0.3.1"].networker._remotes.CraftingService.RemoteFunction:InvokeServer("requestUnlockMachine")
    end
})

Tabs.Main:Button({
    Title = "Claim Offline",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages._Index["leifstout_networker@0.3.1"].networker._remotes.OfflineEarningsService.RemoteFunction:InvokeServer("requestClaim")
    end
})


Tabs.Automatically:Section({ Title = "Upgrades Automation" })

Tabs.Automatically:Toggle({
    Title = "Auto Upgrade",
    Default = false,
    Callback = function(state)
        autoUpgradeEnabled = state
        if state then
            task.spawn(function()
                while autoUpgradeEnabled do
                    Upgrade()
                    task.wait(autoUpgradeInterval)
                end
            end)
        end
    end
})

Tabs.Automatically:Input({
    Title = "Upgrade Interval",
    Default = "30",
    Placeholder = "Seconds",
    Callback = function(value)
        local num = tonumber(value)
        if num then autoUpgradeInterval = num end
    end
})

Tabs.Automatically:Toggle({
    Title = "Auto Buy Zone",
    Default = false,
    Callback = function(state)
        autoBuyZoneEnabled = state
        if state then
            task.spawn(function()
                while autoBuyZoneEnabled do
                    local args = {"requestPurchaseZone"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("ZonesService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end
})

Tabs.Automatically:Toggle({
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        autoRebirthEnabled = state
        if state then
            task.spawn(function()
                while autoRebirthEnabled do
                    local args = {"requestRebirth"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("RebirthService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end
})

Tabs.Automatically:Toggle({
    Title = "Auto Equip Best",
    Default = false,
    Callback = function(state)
        autoEquipBestEnabled = state
        if state then
            task.spawn(function()
                while autoEquipBestEnabled do
                    local args = {"requestEquipBest"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("InventoryService"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
                    task.wait(10)
                end
            end)
        end
    end
})


Tabs.Webhook:Section({ Title = "Discord Webhook" })

Tabs.Webhook:Input({
    Title = "Webhook URL",
    Default = "",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(value)
        webhookUrl = value
    end
})

Tabs.Webhook:Toggle({
    Title = "Enable Webhook",
    Default = false,
    Callback = function(state)
        webhookEnabled = state
        if state then
            task.spawn(function()
                while webhookEnabled do
                    SendDiscordWebhook(webhookUrl, {
                        title = localPlayer.Name,
                        description = workspace:FindFirstChild(localPlayer.Name).HumanoidRootPart.TitleGui.NumRolls.Text
                    })
                    task.wait(webhookInterval)
                end
            end)
        end
    end
})

Tabs.Webhook:Input({
    Title = "Webhook Interval",
    Default = "30",
    Placeholder = "Seconds",
    Callback = function(value)
        local num = tonumber(value)
        if num then webhookInterval = num end
    end
})


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


Tabs.Settings:Button({
    Title = "Rejoin",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local player = game.Players.LocalPlayer
        ts:Teleport(game.PlaceId, player)
    end
})

Tabs.Settings:Button({
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

local function refreshDropdown()
    if dropdownObj and dropdownObj.SetValues then
        local values = {}
        for _, id in ipairs(savedServers) do
            values[#values + 1] = id
        end
        if #values == 0 then
            values = {"No saved servers"}
        end
        dropdownObj:SetValues(values)
    end
end

Tabs.Settings:Paragraph({
    Title = "Current Server",
    Desc = "You are in server: " .. game.JobId
})

Tabs.Settings:Dropdown({
    Title = "Select Server",
    Values = (function()
        local v = {}
        for _, id in ipairs(savedServers) do
            v[#v + 1] = id
        end
        if #v == 0 then
            v = {"No saved servers"}
        end
        return v
    end)(),
    Value = (#savedServers > 0 and savedServers[1] or "No saved servers"),
    Callback = function(option)
        if option ~= "No saved servers" and inputObj and inputObj.SetValue then
            inputObj:SetValue(option)
        end
    end
})

Tabs.Settings:Input({
    Title = "Target Server ID",
    Default = "",
    Placeholder = "Enter JobId...",
    MultiLine = false,
    Callback = function(input)
        if input ~= "" then
            local found = false
            for _, id in ipairs(savedServers) do
                if id == input then
                    found = true
                    break
                end
            end
            if not found then
                table.insert(savedServers, 1, input)
                refreshDropdown()
            end
        end
    end
})

Tabs.Settings:Button({
    Title = "Teleport",
    Callback = function()
        local target
        if inputObj and inputObj.GetValue then
            target = inputObj:GetValue()
        end
        if target and target ~= "" then
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, target)
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
