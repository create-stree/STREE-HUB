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
    Author = "KirsiaSC | Fish It",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.5",
    Color = Color3.fromRGB(0, 255, 0),
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

_G.CustomJumpPower = 50
_G.CustomWalkSpeed = 16
_G.InfiniteJump = false
_G.AutoFishing = false
_G.AutoSell = false
_G.AutoFavorite = false
_G.AutoUnfavorite = false
_G.InstantCatch = false
_G.AntiAFK = false
_G.AutoReconnect = false

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = _G.CustomJumpPower or 50
    Humanoid.WalkSpeed = _G.CustomWalkSpeed or 16
end)

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info",
})

Tab1:Section({ 
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

local function copyToClipboard(text, platform)
    if setclipboard then
        setclipboard(text)
        WindUI:Notify({
            Title = "Link Copied",
            Content = platform .. " link copied to clipboard!",
            Duration = 2,
            Icon = "copy",
        })
    end
end

Tab1:Button({
    Title = "Discord",
    Desc = "Click to copy link",
    Callback = function()
        copyToClipboard("https://discord.gg/jdmX43t5mY", "Discord")
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Click to copy link",
    Callback = function()
        copyToClipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N", "WhatsApp")
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Click to copy link",
    Callback = function()
        copyToClipboard("https://t.me/StreeCoumminty", "Telegram")
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Click to copy link",
    Callback = function()
        copyToClipboard("https://stree-hub-nexus.lovable.app/", "Website")
    end
})

Tab1:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local function updateWalkSpeed(speed)
    if speed and speed >= 16 then
        _G.CustomWalkSpeed = speed
        if Humanoid then
            Humanoid.WalkSpeed = speed
        end
        print("WalkSpeed set to: " .. speed)
        return true
    else
        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
        print("⚠️ Invalid input, set to default (16)")
        return false
    end
end

local function updateJumpPower(power)
    if power and power >= 50 then
        _G.CustomJumpPower = power
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = power
        end
        print("Jump Power set to: " .. power)
        return true
    else
        warn("⚠️ Must be number and minimum 50!")
        return false
    end
end

Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = "arrow-right",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        updateWalkSpeed(tonumber(input))
    end
})

Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = "arrow-up",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        updateJumpPower(tonumber(input))
    end
})

Tab2:Button({
    Title = "Reset WalkSpeed",
    Desc = "Return WalkSpeed to normal (16)",
    Callback = function()
        updateWalkSpeed(16)
        print("🔄 WalkSpeed reset to 16")
    end
})

Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "Return Jump Power to normal (50)",
    Callback = function()
        updateJumpPower(50)
        print("🔄 Jump Power reset to 50")
    end
})

Tab2:Toggle({
    Title = "Infinite Jump",
    Desc = "Activate to use infinite jump",
    Icon = "bird",
    Default = false,
    Callback = function(state) 
        _G.InfiniteJump = state
        if state then
            print("✅ Infinite Jump Active")
        else
            print("❌ Infinite Jump Inactive")
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

Tab3:Section({ 
    Title = "Main Features",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab3:Toggle({
    Title = "Auto Fishing",
    Desc = "Automatic fishing v1",
    Default = false,
    Callback = function(state) 
        _G.AutoFishing = state
        if state then
            print("✅ Auto Fishing Active")
        else
            print("❌ Auto Fishing Inactive")
        end
    end
})

Tab3:Toggle({
    Title = "Auto Sell",
    Desc = "Automatic fish sales",
    Default = false,
    Callback = function(state)
        _G.AutoSell = state
        if state then
            print("✅ Auto Sell Active")
        else
            print("❌ Auto Sell Inactive")
        end
    end
})

Tab3:Toggle({
    Title = "Auto Favorite",
    Desc = "Automatically favorite fish",
    Default = false,
    Callback = function(state)
        _G.AutoFavorite = state
        if state then
            print("✅ Auto Favorite Active")
        else
            print("❌ Auto Favorite Inactive")
        end
    end
})

Tab3:Toggle({
    Title = "Auto Unfavorite",
    Desc = "Automatically unfavorite fish",
    Default = false,
    Callback = function(state)
        _G.AutoUnfavorite = state
        if state then
            print("✅ Auto Unfavorite Active")
        else
            print("❌ Auto Unfavorite Inactive")
        end
    end
})

Tab3:Section({ 
    Title = "Optional",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab3:Toggle({
    Title = "Instant Catch",
    Desc = "Get fish straight away",
    Default = false,
    Callback = function(state)
        _G.InstantCatch = state
        if state then
            print("✅ Instant Catch Active")
        else
            print("❌ Instant Catch Inactive")
        end
    end
})

task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFishing then
            pcall(function()
                local char = Player.Character
                if not char then return end
                
                local fishingViewModel = char:FindFirstChild("!!!FISHING_VIEW_MODEL!!!")
                local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
                local playerCosmetic = cosmeticFolder and cosmeticFolder:FindFirstChild(tostring(Player.UserId))
                
                if not fishingViewModel and not playerCosmetic then
                    ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]:FireServer(1)
                    task.wait(0.5)
                    ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]:InvokeServer(2)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSell then
            pcall(function()
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then
                        v:FireServer()
                    elseif v:IsA("RemoteFunction") and v.Name:lower():find("sell") then
                        v:InvokeServer()
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFavorite then
            pcall(function()
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name:lower():find("favorite") or v.Name:lower():find("fav")) then
                        if v:IsA("RemoteEvent") then
                            v:FireServer(true)
                        else
                            v:InvokeServer(true)
                        end
                    end
                end
            end)
        end
        
        if _G.AutoUnfavorite then
            pcall(function()
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name:lower():find("favorite") or v.Name:lower():find("fav")) then
                        if v:IsA("RemoteEvent") then
                            v:FireServer(false)
                        else
                            v:InvokeServer(false)
                        end
                    end
                end
            end)
        end
    end
end)

local function findRemote(name)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Name:lower():find(name:lower()) then
            return v
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.1) do
        if _G.InstantCatch then
            pcall(function()
                local remote = findRemote("FishingCompleted")
                if remote then
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer()
                    else
                        remote:InvokeServer()
                    end
                end
            end)
        end
    end
end)

local Tab4 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

Tab4:Section({ 
    Title = "Island Locations",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab4:Dropdown({
    Title = "Select Island",
    Values = {"Esoteric Island", "Konoha", "Coral Refs", "Enchant Room", "Tropical Grove", "Weather Machine", "Treasure Room"},
    Callback = function(Value)
        local Locations = {
            ["Esoteric Island"] = CFrame.new(1990, 5, 1398),
            ["Konoha"] = CFrame.new(-603, 3, 719),
            ["Coral Refs"] = CFrame.new(-2855, 47, 1996),
            ["Enchant Room"] = CFrame.new(3221, -1303, 1406),
            ["Treasure Room"] = CFrame.new(-3600, -267, -1575),
            ["Tropical Grove"] = CFrame.new(-2091, 6, 3703),
            ["Weather Machine"] = CFrame.new(-1508, 6, 1895),
        }

        local location = Locations[Value]
        if location and Player.Character then
            local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = location
                WindUI:Notify({
                    Title = "Teleported",
                    Content = "Teleported to " .. Value,
                    Duration = 2,
                    Icon = "map-pin",
                })
            end
        end
    end
})

Tab4:Section({ 
    Title = "Fishing Spots",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab4:Dropdown({
    Title = "Select Fishing Spot",
    Values = {"Spawn", "Konoha", "Coral Refs", "Volcano", "Sysyphus Statue"},
    Callback = function(Value)
        local Locations = {
            ["Spawn"] = CFrame.new(33, 9, 2810),
            ["Konoha"] = CFrame.new(-603, 3, 719),
            ["Coral Refs"] = CFrame.new(-2855, 47, 1996),
            ["Volcano"] = CFrame.new(-632, 55, 197),
            ["Sysyphus Statue"] = CFrame.new(-3693, -136, -1045),
        }

        local location = Locations[Value]
        if location and Player.Character then
            local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = location
                WindUI:Notify({
                    Title = "Teleported",
                    Content = "Teleported to " .. Value,
                    Duration = 2,
                    Icon = "fish",
                })
            end
        end
    end
})

local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
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
            WindUI:Notify({
                Title = "AntiAFK Enabled",
                Content = "Coded By Kirsiasc",
                Duration = 3,
                Icon = "shield",
            })
        else
            WindUI:Notify({
                Title = "AntiAFK Disabled",
                Content = "Stopped AntiAFK",
                Duration = 3,
                Icon = "shield-off",
            })
        end
    end
})

Tab5:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            WindUI:Notify({
                Title = "Auto Reconnect Enabled",
                Content = "Will automatically reconnect if disconnected",
                Duration = 3,
                Icon = "refresh-cw",
            })
        else
            WindUI:Notify({
                Title = "Auto Reconnect Disabled",
                Content = "Auto reconnect turned off",
                Duration = 3,
                Icon = "refresh-cw",
            })
        end
    end
})

local ConfigFolder = "STREE_HUB/Configs"
if not isfolder("STREE_HUB") then makefolder("STREE_HUB") end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local ConfigName = "default.json"

local function GetConfig()
    return {
        WalkSpeed = _G.CustomWalkSpeed,
        JumpPower = _G.CustomJumpPower,
        InfiniteJump = _G.InfiniteJump,
        AutoFishing = _G.AutoFishing,
        AutoSell = _G.AutoSell,
        AutoFavorite = _G.AutoFavorite,
        AutoUnfavorite = _G.AutoUnfavorite,
        InstantCatch = _G.InstantCatch,
        AntiAFK = _G.AntiAFK,
        AutoReconnect = _G.AutoReconnect,
    }
end

local function ApplyConfig(data)
    if data.WalkSpeed then 
        updateWalkSpeed(data.WalkSpeed)
    end
    if data.JumpPower then
        updateJumpPower(data.JumpPower)
    end
    if data.InfiniteJump ~= nil then
        _G.InfiniteJump = data.InfiniteJump
    end
    if data.AutoFishing ~= nil then
        _G.AutoFishing = data.AutoFishing
    end
    if data.AutoSell ~= nil then
        _G.AutoSell = data.AutoSell
    end
    if data.AutoFavorite ~= nil then
        _G.AutoFavorite = data.AutoFavorite
    end
    if data.AutoUnfavorite ~= nil then
        _G.AutoUnfavorite = data.AutoUnfavorite
    end
    if data.InstantCatch ~= nil then
        _G.InstantCatch = data.InstantCatch
    end
    if data.AntiAFK ~= nil then
        _G.AntiAFK = data.AntiAFK
    end
    if data.AutoReconnect ~= nil then
        _G.AutoReconnect = data.AutoReconnect
    end
end

Tab5:Button({
    Title = "Save Config",
    Desc = "Save all settings to config file",
    Callback = function()
        local data = GetConfig()
        if writefile then
            writefile(ConfigFolder.."/"..ConfigName, HttpService:JSONEncode(data))
            WindUI:Notify({
                Title = "Config Saved",
                Content = "Settings saved successfully!",
                Duration = 3,
                Icon = "save",
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "File functions not available",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

Tab5:Button({
    Title = "Load Config",
    Desc = "Load settings from config file",
    Callback = function()
        if readfile and isfile(ConfigFolder.."/"..ConfigName) then
            local data = readfile(ConfigFolder.."/"..ConfigName)
            local decoded = HttpService:JSONDecode(data)
            ApplyConfig(decoded)
            WindUI:Notify({
                Title = "Config Loaded",
                Content = "Settings applied successfully!",
                Duration = 3,
                Icon = "folder-open",
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Config file not found",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

Tab5:Button({
    Title = "Delete Config",
    Desc = "Delete saved config file",
    Callback = function()
        if delfile and isfile(ConfigFolder.."/"..ConfigName) then
            delfile(ConfigFolder.."/"..ConfigName)
            WindUI:Notify({
                Title = "Config Deleted",
                Content = "Config file removed successfully!",
                Duration = 3,
                Icon = "trash-2",
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "No config file to delete",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

task.spawn(function()
    while task.wait(2) do
        if _G.AutoReconnect then
            pcall(function()
                local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if reconnectUI then
                    local prompt = reconnectUI:FindFirstChild("promptOverlay")
                    if prompt then
                        local button = prompt:FindFirstChild("ErrorPrompt") and prompt.ErrorPrompt:FindFirstChild("ButtonArea")
                        if button then
                            local primaryButton = button:FindFirstChild("Button1")
                            if primaryButton and primaryButton.Visible then
                                firesignal(primaryButton.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
