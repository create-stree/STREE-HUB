-- [[
--  Dead Rails - Chloe X UI Version
--  Converted to Chloe X UI Library
-- ]]

repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

-- Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local PlayerGui = LocalPlayer.PlayerGui
local TeleportService = game:GetService("TeleportService")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

-- Load Chloe X UI
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/4mVaA8QEMe/refs/heads/main/.lua"))()

-- Create Window
local Window = Chloex:Window({
    Title   = "ChloeX | Dead Rails",
    Footer  = "v0.4.6",
    Image   = "99764942615873",
    Color   = Color3.fromRGB(0, 208, 255),
    Theme   = 9542022979,
    Version = 1,
})

-- Notify window loaded
if Window then
    Chloex:MakeNotify({
        Title = "Chloe X",
        Description = "Dead Rails",
        Content = "Script loaded successfully!",
        Color = Color3.fromRGB(0, 208, 255),
        Delay = 4
    })
end

-- Utility Functions
local function autoExecute()
    if not disable_auto_execute or not getgenv().disable_auto_execute then
        xpcall(function()
            local queueonteleport = queueonteleport or queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
            if queueonteleport then
                local execFeature = {
                    auto_bond = (auto_bond or getgenv().auto_bond),
                    webhook_link = getgenv().webhook_link or "",
                    auto_win = getgenv().auto_win or false
                }

                local enabledfitur = ""
                for name, isEnabled in pairs(execFeature) do
                    if isEnabled ~= nil then
                        if typeof(isEnabled) == "string" then
                            enabledfitur = enabledfitur .. ("getgenv().%s = %q;\n"):format(name, isEnabled)
                        else
                            enabledfitur = enabledfitur .. ("getgenv().%s = %s;\n"):format(name, tostring(isEnabled))
                        end
                    end
                end

                local script_key = script_key or ""
                local script_url = "https://api.luarmor.net/files/v3/loaders/a3e99a8c1a465fc973e7aa0dda0e220c.lua"

                local fullScript = ""
                fullScript = string.format('script_key=%q;%sloadstring(game:HttpGet(%q))()', script_key,  enabledfitur, script_url)

                queueonteleport(fullScript)
                print("[AutoExecute] Auto Execute Success")
            end
        end, function(err)
            warn("Auto execute error: " .. tostring(err))
            autoExecute()
        end)
    end
end

local function NoClip()
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function createBondGui()
    local NatBondGui = game:GetService("CoreGui"):FindFirstChild("NatBondGui")
    if NatBondGui then return NatBondGui end
    local BondGui = Instance.new("ScreenGui")
    local BondInfo = Instance.new("Frame")
    local BondIcon = Instance.new("ImageLabel")
    local BondCount = Instance.new("TextLabel")

    BondGui.Name = "NatBondGui"
    BondGui.Parent = game:GetService("CoreGui")
    BondGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    BondInfo.Name = "BondInfo"
    BondInfo.Parent = BondGui
    BondInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BondInfo.BackgroundTransparency = 1.000
    BondInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BondInfo.BorderSizePixel = 0
    BondInfo.Position = UDim2.new(0.444000006, 0, 0.5, 75)
    BondInfo.Size = UDim2.new(0.112000003, 0, 0, 55)

    BondIcon.Name = "BondIcon"
    BondIcon.Parent = BondInfo
    BondIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BondIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BondIcon.BorderSizePixel = 0
    BondIcon.Size = UDim2.new(0, 100, 1, 0)
    BondIcon.Image = "rbxassetid://73580081637476"

    BondCount.Name = "BondCount"
    BondCount.Parent = BondInfo
    BondCount.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BondCount.BackgroundTransparency = 1.000
    BondCount.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BondCount.BorderSizePixel = 0
    BondCount.Position = UDim2.new(0, 110, 0, 0)
    BondCount.Size = UDim2.new(0.338999987, 0, 1, 0)
    BondCount.Font = Enum.Font.Unknown
    BondCount.Text = "+0"
    BondCount.TextColor3 = Color3.fromRGB(255, 121, 103)
    BondCount.TextScaled = true
    BondCount.TextSize = 14.000
    BondCount.TextStrokeTransparency = 0.000
    return BondGui
end

-- Utility Tables
local VisualUtil = {
    itemEspEnable = false,
    trainEspEnable = false,
    removeFogEnable = false,
    fullBrightEnable = false,
}

local CombatUtil = {
    aimTarget = "Head",
    aimEnabled = false,
}

function VisualUtil.toggleItemESP()
    -- Item ESP Logic
end

function VisualUtil.toggleTrainESP()
    -- Train ESP Logic
end

function VisualUtil.toggleRemoveFog()
    if VisualUtil.removeFogEnable then
        game.Lighting.FogEnd = 100000
    else
        game.Lighting.FogEnd = 1000
    end
end

function VisualUtil.toggleFullBright()
    if VisualUtil.fullBrightEnable then
        game.Lighting.Brightness = 2
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        game.Lighting.Brightness = 1
        game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end

function CombatUtil.toggleAim()
    -- Aim Bot Logic
end

-- Create Tabs
local Tabs = {
    Home = Window:AddTab({ Name = "Home", Icon = "home" }),
    Player = Window:AddTab({ Name = "Player", Icon = "user" }),
    Visual = Window:AddTab({ Name = "Visual", Icon = "eye" }),
    Combat = Window:AddTab({ Name = "Combat", Icon = "sword" }),
    Config = Window:AddTab({ Name = "Config", Icon = "settings" }),
}

-- Home Tab
local HomeSection = Tabs.Home:AddSection("Dead Rails Hub")

HomeSection:AddParagraph({
    Title = "Welcome to Dead Rails",
    Content = "Chloe X Edition - Advanced features for Dead Rails game",
    Icon = "star",
})

HomeSection:AddPanel({
    Title = "Discord Server",
    Content = "Join our community!",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then
            setclipboard("https://discord.gg/nathub")
            Chloex:MakeNotify({
                Title = "Success",
                Description = "Copied!",
                Content = "Discord link copied to clipboard",
                Color = Color3.fromRGB(0, 208, 255),
                Delay = 3
            })
        end
    end,
    SubButtonText = "Open Discord",
    SubButtonCallback = function()
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/nathub")
        end)
    end
})

-- Player Tab
local PlayerSection = Tabs.Player:AddSection("Player Options")

PlayerSection:AddToggle({
    Title = "God Mode",
    Content = "Infinite health",
    Default = false,
    Callback = function(state)
        if state then
            local humanoid = Character:WaitForChild("Humanoid")
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid and humanoid.Health > 0 and humanoid.Health < 100 then
                    humanoid.Health = 100
                end
            end)
            Chloex:MakeNotify({
                Title = "God Mode",
                Content = "Enabled",
                Color = Color3.fromRGB(0, 208, 255),
                Delay = 2
            })
        end
    end
})

PlayerSection:AddToggle({
    Title = "No Clip",
    Content = "Walk through walls",
    Default = false,
    Callback = function(state)
        if state then
            RunService.Stepped:Connect(function()
                if state then
                    NoClip()
                end
            end)
        end
    end
})

PlayerSection:AddButton({
    Title = "Unlock Camera",
    Callback = function()
        local player = game.Players.LocalPlayer
        local camera = game.Workspace.CurrentCamera
        player.CameraMode = Enum.CameraMode.Classic
        player.CameraMinZoomDistance = 0.5
        player.CameraMaxZoomDistance = 50
        camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid") or camera.CameraSubject
        camera.CameraType = Enum.CameraType.Custom
        Chloex:MakeNotify({
            Title = "Camera",
            Content = "Camera unlocked!",
            Color = Color3.fromRGB(0, 208, 255),
            Delay = 2
        })
    end
})

-- Visual Tab
local VisualSection = Tabs.Visual:AddSection("Visual Options")

VisualSection:AddToggle({
    Title = "Item ESP",
    Content = "See items through walls",
    Default = false,
    Callback = function(state)
        VisualUtil.itemEspEnable = state
        VisualUtil.toggleItemESP()
    end
})

VisualSection:AddToggle({
    Title = "Train ESP",
    Content = "See trains through walls",
    Default = false,
    Callback = function(state)
        VisualUtil.trainEspEnable = state
        VisualUtil.toggleTrainESP()
    end
})

VisualSection:AddToggle({
    Title = "Remove Fog",
    Content = "Remove fog from game",
    Default = false,
    Callback = function(state)
        VisualUtil.removeFogEnable = state
        VisualUtil.toggleRemoveFog()
    end
})

VisualSection:AddToggle({
    Title = "Full Bright",
    Content = "Make everything bright",
    Default = false,
    Callback = function(state)
        VisualUtil.fullBrightEnable = state
        VisualUtil.toggleFullBright()
    end
})

-- Combat Tab
local CombatSection = Tabs.Combat:AddSection("Aim Bot")

local AimTargetDropdown = CombatSection:AddDropdown({
    Title = "Select Aim Target",
    Content = "Choose what to aim at",
    Options = { "Head", "HumanoidRootPart" },
    Default = "Head",
    Callback = function(value)
        CombatUtil.aimTarget = value
    end
})

CombatSection:AddToggle({
    Title = "Aim Bot",
    Content = "Auto aim at enemies",
    Default = false,
    Callback = function(state)
        CombatUtil.aimEnabled = state
        CombatUtil.toggleAim()
    end
})

-- Config Tab
local ConfigSection = Tabs.Config:AddSection("Configuration")

local folderPath = "NatHub/DR"
makefolder(folderPath)

local function SaveFile(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

local function LoadFile(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end
end

local function ListFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

ConfigSection:AddToggle({
    Title = "Disable Auto Execute",
    Content = "Turn off auto execution on rejoin",
    Default = getgenv().disable_auto_execute or false,
    Callback = function(state)
        disable_auto_execute = state
        getgenv().disable_auto_execute = state
    end
})

ConfigSection:AddDivider()

local SaveSection = Tabs.Config:AddSection("Save & Load")

local fileNameInput = ""

SaveSection:AddInput({
    Title = "File Name",
    Content = "Enter name for config file",
    Default = "",
    Callback = function(value)
        fileNameInput = value
    end
})

SaveSection:AddButton({
    Title = "Save Config",
    SubTitle = "Overwrite Config",
    Callback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, {
                itemEspEnable = VisualUtil.itemEspEnable,
                trainEspEnable = VisualUtil.trainEspEnable,
                removeFogEnable = VisualUtil.removeFogEnable,
                fullBrightEnable = VisualUtil.fullBrightEnable,
                aimTarget = CombatUtil.aimTarget,
                aimEnabled = CombatUtil.aimEnabled,
            })
            Chloex:MakeNotify({
                Title = "Config",
                Content = "Configuration saved!",
                Color = Color3.fromRGB(0, 208, 255),
                Delay = 3
            })
        end
    end,
    SubCallback = function()
        if fileNameInput ~= "" then
            SaveFile(fileNameInput, {
                itemEspEnable = VisualUtil.itemEspEnable,
                trainEspEnable = VisualUtil.trainEspEnable,
                removeFogEnable = VisualUtil.removeFogEnable,
                fullBrightEnable = VisualUtil.fullBrightEnable,
                aimTarget = CombatUtil.aimTarget,
                aimEnabled = CombatUtil.aimEnabled,
            })
            Chloex:MakeNotify({
                Title = "Config",
                Content = "Configuration overwritten!",
                Color = Color3.fromRGB(0, 208, 255),
                Delay = 3
            })
        end
    end
})

local LoadSection = Tabs.Config:AddSection("Load Configuration")

local files = ListFiles()
local selectedFile = ""

local FilesDropdown = LoadSection:AddDropdown({
    Title = "Select Config File",
    Content = "Choose a config to load",
    Options = files,
    Default = nil,
    Callback = function(value)
        selectedFile = value
    end
})

LoadSection:AddButton({
    Title = "Load Config",
    SubTitle = "Refresh List",
    Callback = function()
        if selectedFile ~= "" then
            local data = LoadFile(selectedFile)
            if data then
                if data.itemEspEnable ~= nil then
                    VisualUtil.itemEspEnable = data.itemEspEnable
                end
                if data.trainEspEnable ~= nil then
                    VisualUtil.trainEspEnable = data.trainEspEnable
                end
                if data.removeFogEnable ~= nil then
                    VisualUtil.removeFogEnable = data.removeFogEnable
                end
                if data.fullBrightEnable ~= nil then
                    VisualUtil.fullBrightEnable = data.fullBrightEnable
                end
                if data.aimTarget then
                    CombatUtil.aimTarget = data.aimTarget
                end
                if data.aimEnabled ~= nil then
                    CombatUtil.aimEnabled = data.aimEnabled
                end
                
                Chloex:MakeNotify({
                    Title = "Config",
                    Content = "Configuration loaded successfully!",
                    Color = Color3.fromRGB(0, 208, 255),
                    Delay = 3
                })
            end
        end
    end,
    SubCallback = function()
        local updatedFiles = ListFiles()
        FilesDropdown:SetValues(updatedFiles)
        Chloex:MakeNotify({
            Title = "Config",
            Content = "File list refreshed!",
            Color = Color3.fromRGB(0, 208, 255),
            Delay = 2
        })
    end
})

-- Auto Bond Check
if (getgenv().auto_bond or auto_bond) then
    if auto_bond then
        getgenv().auto_bond = true
        Chloex:MakeNotify({
            Title = "Auto Bond",
            Content = "Auto Bond is enabled!",
            Color = Color3.fromRGB(0, 208, 255),
            Delay = 5
        })
    end
end

-- Character Removing Handler
LocalPlayer.CharacterRemoving:Connect(function()
    pcall(function()
        if (auto_bond_premium or getgenv().auto_bond_premium) then
            local BondMethod = getgenv().auto_bond_method or "Died"
            if BondMethod:lower() ~= "lobby" then return end
            for i = 0, 200 do
                ReplicatedStorage.Remotes.ReturnToLooby:FireServer()
                task.wait()
            end
        end
    end)
end)

-- God Mode Handler
local humanoid = Character:WaitForChild("Humanoid")
humanoid:GetPropertyChangedSignal("Health"):Connect(function()
    if humanoid and humanoid.Health > 0 and humanoid.Health < 100 then
        humanoid.Health = 100
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
