loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/dy1zn4t/4mVaA8QEMe/refs/heads/main/.lua"))()
    local Window = Chloex:Window({
        Title   = "WisHub",
        Footer  = (premium and "Premium" or "99 NITF") .. " | " .. version,
        Image   = "99764942615873",
        Color   = Color3.fromRGB(200, 0, 255),
        Theme   = 9542022979,
        Version = 1,
    })

local Tabs = {}

Tabs.LobbyTab = Window:AddTab({ Name = "Lobby", Icon = "scan"})
Tabs.MainTab = Window:AddTab({ Name = "Main", Icon = "settings"})
Tabs.ItemTab = Window:AddTab({ Name = "Items", Icon = "plug"})
Tabs.QuestTab = Window:AddTab({ Name = "Quest", Icon = "scroll"})
--Tabs.EventTab = Window:AddTab({ Name = "Event", Icon = "next"})
Tabs.CraftingTab = Window:AddTab({ Name = "Crafting", Icon = "idea"})
Tabs.TeleportTab = Window:AddTab({ Name = "Teleport", Icon = "gps"})
Tabs.EspTab = Window:AddTab({ Name = "Esp", Icon = "eyes"})
Tabs.MiscTab = Window:AddTab({ Name = "Misc", Icon = "compas"})

_G.Settings = {
	Main = {
		["Auto Choop Small Tree"] = false,
		["Kill Aura"] = false,
		["Auto Burn"] = false,
		["Auto Recycling"] = false,
		["Auto Plant Circle"] = false,
		["Auto Plant Sapling"] = false,
		["Auto Cook"] = false,
		["Auto Eat"] = false,
		["Auto Farm Diamond"] = false,
		["Open Map"] = false,
		["God Mode"] = false,
	},
	Quest = {
	    ["L1"] = false,
	    ["L2"] = false,
	    ["L3"] = false,
	    ["L4"] = false,
	    ["Auto Lost Child Quest"] = false,
	    ["Auto Lost Child2 Quest"] = false,
	    ["Auto Lost Child3 Quest"] = false,
	    ["Auto Lost Child4 Quest"] = false,
	},
	Crafting = {
	},
	Teleport = {
	},	
	Esp = {
	    ["Item ESP"] = false,
	    ["Item ESP Filter"] = {},
	    ["Enable Enemy ESP"] = false
	},
	Misc = {
	    ["Remove Fog"] = false,
	    ["Anti Void"] = false,
	    ["Night Teleport"] = false
	},
	AutoSave = false
}
--[[VARIABLE]]--
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:FindFirstChild("HumanoidRootPart")
local Players = game:GetService("Players")
local plr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local placeId = game.PlaceId
local Lobby = placeId == 79546208627805
local Hutan = placeId == 126509999114328
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
RunService.Stepped:Connect(function()
    pcall(function()
        sethiddenproperty(plr, "SimulationRadius", math.huge)
        sethiddenproperty(plr, "MaxSimulationRadius", math.huge)
    end)
end)
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
function TweenToPosition(model, targetCFrame)
	if not model.PrimaryPart then
		local base = model:FindFirstChildWhichIsA("BasePart")
		if not base then return end
		model.PrimaryPart = base
	end
	local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(model.PrimaryPart, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end


local HttpService = game:GetService("HttpService")
local folderPath = "WisHub"
makefolder(folderPath)
local configFile = folderPath .. "/99NITF.json"

function SaveConfig()
	local success, result = pcall(function()
		return HttpService:JSONEncode(_G.Settings)
	end)
	if success then
		writefile(configFile, result)
	end
end

function LoadConfig()
	if isfile(configFile) then
		local data = readfile(configFile)
		local success, result = pcall(function()
			return HttpService:JSONDecode(data)
		end)
		if success and type(result) == "table" then
			for k, v in pairs(result) do
				_G.Settings[k] = v
			end
		end
	else
		SaveConfig()
	end
end

LoadConfig()


_G.Settings.AutoSave = true

local Sec_MainTab_Default = Tabs.MainTab:AddSection("General")
if Hutan then
local OpenMapToggle = Sec_MainTab_Default:AddToggle({
    Title = "Open Map",
    Default = _G.Settings.Main and _G.Settings.Main["Open Map"] or false,
    Callback = function(value)
        _G.Settings.Main = _G.Settings.Main or {}
        _G.Settings.Main["Open Map"] = value
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if value then
            _G.OriginalPosition = humanoidRootPart.CFrame
            _G.OriginalCameraType = workspace.CurrentCamera.CameraType
            _G.OriginalCameraSubject = workspace.CurrentCamera.CameraSubject
            _G.VisitedPositions = {}
            
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            workspace.CurrentCamera.CameraSubject = nil
            
            function getRandomUnvisitedCFrame()
                local randomCFrame
                local attempts = 0
                
                repeat
                    local randomX = math.random(-1000, 1000)
                    local randomY = math.random(25, 100)
                    local randomZ = math.random(-1000, 1000)
                    randomCFrame = CFrame.new(randomX, randomY, randomZ)
                    attempts = attempts + 1
                until not _G.VisitedPositions[tostring(randomCFrame.Position)] or attempts > 50
                
                _G.VisitedPositions[tostring(randomCFrame.Position)] = true
                return randomCFrame
            end
            
            _G.MapTeleportConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.Settings.Main["Open Map"] and humanoidRootPart then
                    local newCFrame = getRandomUnvisitedCFrame()
                    humanoidRootPart.CFrame = newCFrame
                    task.wait(1)
                end
            end)
        else
            if _G.MapTeleportConnection then
                _G.MapTeleportConnection:Disconnect()
                _G.MapTeleportConnection = nil
            end
            
            if humanoidRootPart and _G.OriginalPosition then
                humanoidRootPart.CFrame = _G.OriginalPosition
            end
            
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraType = _G.OriginalCameraType or Enum.CameraType.Custom
                workspace.CurrentCamera.CameraSubject = _G.OriginalCameraSubject or character:FindFirstChild("Humanoid")
            end
            
            _G.VisitedPositions = nil
            _G.OriginalPosition = nil
        end
    end
})

local GodModeToggle = Sec_MainTab_Default:AddToggle({
    Title = "God Mode",
    Default = _G.Settings.Main and _G.Settings.Main["God Mode"] or false,
    Callback = function(value)
        _G.Settings.Main = _G.Settings.Main or {}
        _G.Settings.Main["God Mode"] = value
        
        local rs = game:GetService("ReplicatedStorage")
        local dmgEvent = rs:FindFirstChild("RemoteEvents") and rs.RemoteEvents:FindFirstChild("DamagePlayer")
        
        if value then
            if dmgEvent then
                _G.GodModeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if _G.Settings.Main["God Mode"] then
                        dmgEvent:FireServer(-math.huge)
                    end
                end)
            else
                _G.Settings.Main["God Mode"] = false
            end
        else
            if _G.GodModeConnection then
                _G.GodModeConnection:Disconnect()
                _G.GodModeConnection = nil
            end
        end
    end
})
end

if Lobby then
    Chloex:MakeNotify({
        Title = "Lobby Detected",
        Description = "NatHub",
        Content = "        Features not loaded",
        Color = Color3.fromRGB(0, 208, 255),
        Delay = 4
    })

    local TeleportEvent = game:GetService("ReplicatedStorage").RemoteEvents.TeleportEvent

    _G.AutoPlay = false
    _G.SelectedAdd = 1
    _G.SelectedChosen = 5

    local Sec_Lobby = Tabs.LobbyTab:AddSection("Play")

    Sec_Lobby:AddDropdown({
        Title = "Select Add (1-3)",
        Options = { "1", "2", "3" },
        Default = "1",
        Callback = function(value)
            _G.SelectedAdd = tonumber(value)
        end
    })

    Sec_Lobby:AddDropdown({
        Title = "Select Chosen (1-5)",
        Options = { "1", "2", "3", "4", "5" },
        Default = "5",
        Callback = function(value)
            _G.SelectedChosen = tonumber(value)
        end
    })

    Sec_Lobby:AddButton({
        Title = "Set Chosen",
        Callback = function()
            TeleportEvent:FireServer("Chosen", nil, _G.SelectedChosen, nil)
        end
    })

    Sec_Lobby:AddButton({
        Title = "Remove",
        Callback = function()
            TeleportEvent:FireServer("Remove")
        end
    })

    Sec_Lobby:AddButton({
        Title = "Play",
        Callback = function()
            TeleportEvent:FireServer("Add", _G.SelectedAdd)
        end
    })
end
Sec_MainTab_Default:AddButton({
    Title = "Reset Config",
    Callback = function()
        function ResetTable(tbl)
            for k, v in pairs(tbl) do
                if type(v) == "table" then
                    ResetTable(v)
                else
                    tbl[k] = false
                end
            end
        end

        ResetTable(_G.Settings)

        SaveConfig()

        Chloex:MakeNotify({
    Title = "WisHub Notify",
    Description = "WisHub",
    Content = "⚠️ Config has been reset!",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 3
})
    end
})
if Hutan then
local Sec_MainTab_1 = Tabs.MainTab:AddSection("Auto Farm")
Sec_MainTab_1:AddDropdown({
    Title = "Tree Type",
    Options = {"Small Tree", "Big Tree"},
    Default = _G.Settings.Main["Selected Tree Type"] or "Small Tree",
    Callback = function(option)
        _G.Settings.Main["Selected Tree Type"] = option
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})

Sec_MainTab_1:AddToggle({
    Title = "Auto Chop Tree",
    Default = _G.Settings.Main["Auto Chop Tree"],
    Desc = "Equip Weapon to Enable",
    Callback = function(value)
        _G.Settings.Main["Auto Chop Tree"] = value
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local player = Players.LocalPlayer

local toolsDamageIDs = {
    ["Old Axe"] = "_1",
    ["Good Axe"] = "_1", 
    ["Strong Axe"] = "_1",
}
function getToolAndDamageID()
    for toolName, suffix in pairs(toolsDamageIDs) do
        local tool = player:FindFirstChild("Inventory") and player.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, suffix
        end
    end
    return nil, nil
end
function findBasePart(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            return v
        end
    end
    return nil
end
function getAllTrees()
    local trees = {}
    local folders = {
        Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Landmarks"),
        Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Foliage")
    }
    
    local targetType = _G.Settings.Main["Selected Tree Type"]
    
    for _, folder in ipairs(folders) do
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if targetType == "Small Tree" and obj.Name == "Small Tree" and obj:IsA("Model") then
                    table.insert(trees, obj)
                elseif targetType == "Big Tree" and (obj.Name == "TreeBig1" or obj.Name == "TreeBig2" or obj.Name == "TreeBig3") and obj:IsA("Model") then
                    table.insert(trees, obj)
                end
            end
        end
    end
    return trees
end
function createHealthText(tree)
    if tree:FindFirstChild("HealthTextGUI") then
        return tree.HealthTextGUI
    end
    
    local healthText = Instance.new("BillboardGui")
    healthText.Name = "HealthTextGUI"
    healthText.Size = UDim2.new(8, 0, 3, 0)
    healthText.StudsOffset = Vector3.new(0, 8, 0)
    healthText.AlwaysOnTop = true
    healthText.Adornee = findBasePart(tree)
    healthText.Parent = tree
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "HealthLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 2
    uiStroke.Color = Color3.fromRGB(0, 0, 0)
    uiStroke.Parent = textLabel
    
    textLabel.Parent = healthText
    
    return healthText
end
function updateHealthText(tree)
    if not tree:FindFirstChild("HealthTextGUI") then
        return
    end
    
    local healthText = tree.HealthTextGUI
    local textLabel = healthText.HealthLabel
    
    local maxHealth = tree:GetAttribute("MaxHealth") or 100
    local currentHealth = tree:GetAttribute("Health") or maxHealth
    
    textLabel.Text = string.format("%d/%d", currentHealth, maxHealth)
end
function cleanupHealthTexts()
    for _, folder in ipairs({Workspace.Map.Landmarks, Workspace.Map.Foliage}) do
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if obj:IsA("Model") and (obj.Name == "Small Tree" or obj.Name == "TreeBig1" or obj.Name == "TreeBig2" or obj.Name == "TreeBig3") then
                    if obj:FindFirstChild("HealthTextGUI") then
                        obj.HealthTextGUI:Destroy()
                    end
                end
            end
        end
    end
end

local hitCounter = 1

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.2) do
        if _G.Settings.Main["Auto Chop Tree"] then
            local tool, suffix = getToolAndDamageID()
            if tool and suffix then
                local allTrees = getAllTrees()
                if #allTrees == 0 then
                    task.wait(1)
                else
                    for _, tree in ipairs(allTrees) do
                        if not _G.Settings.Main["Auto Chop Tree"] then
                            break
                        end
                        
                        createHealthText(tree)
                        updateHealthText(tree)
                        
                        local part = findBasePart(tree)
                        if part then
                            coroutine.wrap(function()
                                local hitCount = _G.Settings.Main["Selected Tree Type"] == "Small Tree" and 13 or 20
                                for i = 1, hitCount do
                                    if not _G.Settings.Main["Auto Chop Tree"] then
                                        break
                                    end
                                    
                                    local damageID = tostring(hitCounter) .. suffix
                                    local args = {
                                        tree,
                                        tool,
                                        damageID,
                                        CFrame.new(part.Position)
                                    }
                                    RemoteEvents.ToolDamageObject:InvokeServer(unpack(args))
                                    hitCounter += 1
                                    
                                    updateHealthText(tree)
                                    task.wait(0.25)
                                end
                            end)()
                        end
                    end
                    task.wait(0.2)
                end
            end
        else
            cleanupHealthTexts()
            task.wait(1)
        end
    end
end))
Sec_MainTab_1:AddToggle({
    Title = "Kill Aura",
    Default = _G.Settings.Main["Kill Aura"],
    Desc = "Equip Weapon to Enable",
    Callback = function(value)
        _G.Settings.Main["Kill Aura"] = value
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})

spawn(LPH_NO_VIRTUALIZE(function()
    while true do
        task.wait(0.2)
        if _G.Settings.Main["Kill Aura"] then
            local tool, suffix = getToolAndDamageID()
            if tool and suffix and hrp then
                for _, enemy in ipairs(Workspace.Characters:GetChildren()) do
                    if enemy:IsA("Model") and enemy ~= character then
                        local part = findBasePart(enemy)
                        if part then
                            coroutine.wrap(function()
                                for i = 1, 13 do
                                    if not _G.Settings.Main["Kill Aura"] or not enemy or not enemy.Parent then
                                        break
                                    end
                                    local damageID = tostring(hitCounter) .. suffix
                                    pcall(function()
                                        RemoteEvents.ToolDamageObject:InvokeServer(
                                            enemy,
                                            tool,
                                            damageID,
                                            CFrame.new(part.Position)
                                        )
                                    end)
                                    hitCounter += 1
                                    task.wait(0.2)
                                end
                            end)()
                        end
                    end
                end
            end
        end
    end
end))
Sec_MainTab_1:AddToggle({
    Title = "Auto Burn Fuel",
    Default = _G.Settings.Main["Auto Burn Fire"],
    Desc = "",
    Callback = function(value)
        _G.Settings.Main["Auto Burn Fire"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})

spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local remoteEvents = game.ReplicatedStorage:WaitForChild("RemoteEvents")
        local allowedNames = {
            ["Log"] = true,
            ["Chair"] = true,
            ["Biofuel"] = true,
            ["Coal"] = true,
            ["Fuel Canister"] = true,
            ["Oil Barrel"] = true,
        }

        local targetPosition = Vector3.new(0, 8, 0)

        while true do
            task.wait(0.2)
            if _G.Settings.Main["Auto Burn Fire"] then
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                while _G.Settings.Main["Auto Burn Fire"] do
                    local itemsFolder = workspace:FindFirstChild("Items")
                    local foundItem = false

                    if itemsFolder and hrp then
                        for _, item in ipairs(itemsFolder:GetChildren()) do
                            if not _G.Settings.Main["Auto Burn Fire"] then break end
                            if allowedNames[item.Name] and item:IsA("Model") then
                                local base = item:FindFirstChildWhichIsA("BasePart")
                                if base then
                                    foundItem = true

                                    if not item.PrimaryPart then
                                        item.PrimaryPart = base
                                    end

                                    remoteEvents.RequestStartDraggingItem:FireServer(item)

                                    item:SetPrimaryPartCFrame(CFrame.new(targetPosition))

                                    remoteEvents.RequestBurnItem:FireServer("MainFire", item)
                                    remoteEvents.StopDraggingItem:FireServer(item)

                                    task.wait(0.1)
                                end
                            end
                        end
                    end

                    if not foundItem then
                        task.wait(1)
                    else
                        task.wait(0.5)
                    end
                end
            else
                task.wait(1)
            end
        end
    end)
end))
Sec_MainTab_1:AddToggle({
    Title = "Auto Recycling",
    Default = _G.Settings.Main["Auto Recycling"],
    Desc = "",
    Callback = function(value)
        _G.Settings.Main["Auto Recycling"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local allowedNames = {
            ["Log"] = true,
            ["Sheet Metal"] = true,
            ["Bolt"] = true,
            ["UFO Junk"] = true,
            ["UFO Component"] = true,
            ["Broken Fan"] = true,
            ["Broken Radio"] = true,
            ["Broken Microwave"] = true,
            ["Tyre"] = true,
            ["Metal Chair"] = true,
            ["Old Car Engine"] = true,
            ["Washing Machine"] = true,
            ["Cultist Experiment"] = true,
            ["Cultist Prototype"] = true,
            ["UFO Scrap"] = true,
        }

        local targetPos = Vector3.new(20.953278, 8, -5.237123)
        local remote = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestScrapItem")
        local craftingBench = workspace.Map.Campground:WaitForChild("CraftingBench")

        while true do
            task.wait(0.2)

            if _G.Settings.Main["Auto Recycling"] then
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                if not hrp then continue end

                local itemsFolder = workspace:FindFirstChild("Items")
                if itemsFolder then
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if not _G.Settings.Main["Auto Recycling"] then break end
                        if item:IsA("Model") and allowedNames[item.Name] then
                            local basePart = item:FindFirstChildWhichIsA("BasePart")
                            if basePart then
                                if not item.PrimaryPart then
                                    item.PrimaryPart = basePart
                                end

                                item:SetPrimaryPartCFrame(CFrame.new(targetPos))
                                task.wait(0.3)

                                pcall(function()
                                    remote:InvokeServer(craftingBench, item)
                                end)

                                task.wait(0.5)
                            end
                        end
                    end
                end
            else
                task.wait(1)
            end
        end
    end)
end))
Sec_MainTab_1:AddToggle({
    Title = "Auto Plant",
    Default = _G.Settings.Main["Auto Plant Sapling"],
    Desc = "",
    Callback = function(value)
        _G.Settings.Main["Auto Plant Sapling"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local remoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents")
        local itemsFolder = workspace:WaitForChild("Items")

        while true do
            task.wait(0.5)

            if _G.Settings.Main["Auto Plant Sapling"] then
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                if not hrp then continue end

                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if not _G.Settings.Main["Auto Plant Sapling"] then break end

                    if item:IsA("Model") and item.Name == "Sapling" then
                        local base = item:FindFirstChildWhichIsA("BasePart")
                        if base then
                            if not item.PrimaryPart then
                                item.PrimaryPart = base
                            end

                            local pos = item:GetPivot().Position
                            local vec = Vector3.new(pos.X, pos.Y - 1, pos.Z)

                            remoteEvents.RequestStartDraggingItem:FireServer(item)
                            task.wait(0.1)

                            pcall(function()
                                remoteEvents.RequestPlantItem:InvokeServer(item, vec)
                            end)

                            remoteEvents.StopDraggingItem:FireServer(item)
                            task.wait(0.2)
                        end
                    end
                end
            else
                task.wait(1)
            end
        end
    end)
end))

Sec_MainTab_1:AddToggle({
    Title = "Auto Plant Circle",
    Default = _G.Settings.Main["Auto Plant Circle"],
    Desc = "",
    Callback = function(value)
        _G.Settings.Main["Auto Plant Circle"] = value
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})

spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local remoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents")
        local itemsFolder = workspace:WaitForChild("Items")
        local outerZone = workspace.Map.Campground.MainFire.OuterTouchZone
        
        local plantedPositions = {}
        local maxPlants = 16
        local radius = outerZone.Size.X / 2 + 8

        while true do
            task.wait(0.5)

            if _G.Settings.Main["Auto Plant Circle"] then
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                if not hrp then continue end

                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if not _G.Settings.Main["Auto Plant Circle"] then break end
                    if #plantedPositions >= maxPlants then break end

                    if item:IsA("Model") and item.Name == "Sapling" then
                        local base = item:FindFirstChildWhichIsA("BasePart")
                        if base then
                            if not item.PrimaryPart then
                                item.PrimaryPart = base
                            end

                            local angle
                            local attempts = 0
                            local validPosition = false
                            local newVec
                            
                            repeat
                                angle = (#plantedPositions / maxPlants) * 2 * math.pi
                                local offset = Vector3.new(
                                    math.cos(angle) * radius,
                                    0,
                                    math.sin(angle) * radius
                                )
                                
                                newVec = outerZone.Position + offset
                                newVec = Vector3.new(newVec.X, outerZone.Position.Y, newVec.Z)
                                
                                validPosition = true
                                for _, existingPos in ipairs(plantedPositions) do
                                    if (existingPos - newVec).Magnitude < 5 then
                                        validPosition = false
                                        angle = angle + (2 * math.pi / maxPlants)
                                        break
                                    end
                                end
                                
                                attempts = attempts + 1
                            until validPosition or attempts > 10
                            
                            if validPosition then
                                table.insert(plantedPositions, newVec)
                                
                                remoteEvents.RequestStartDraggingItem:FireServer(item)
                                task.wait(0.1)

                                pcall(function()
                                    remoteEvents.RequestPlantItem:InvokeServer(item, newVec)
                                end)

                                remoteEvents.StopDraggingItem:FireServer(item)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            else
                task.wait(1)
            end
        end
    end)
end))

local Sec_MainTab_2 = Tabs.MainTab:AddSection("Consumable")

Sec_MainTab_2:AddToggle({
    Title = "Auto Cook",
    Default = _G.Settings.Main["Auto Cook"],
    Desc = "",
    Callback = function(value)
        _G.Settings.Main["Auto Cook"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local autoCookFoods = {
            "Steak", "Morsel"
        }
        local itemsFolder = workspace:WaitForChild("Items")        
        while true do
            task.wait(0.5)
            if _G.Settings.Main["Auto Cook"] then
                local available = {}
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item:IsA("Model") and table.find(autoCookFoods, item.Name) then
                        table.insert(available, item)
                    end
                end                
                if #available > 0 then
                    local food = available[math.random(1, #available)]
                    food:SetPrimaryPartCFrame(CFrame.new(0, 8, 0))
                end
            else
                task.wait(1)
            end
        end
    end)
end))

Sec_MainTab_2:AddToggle({
    Title = "Auto Eat",
    Default = _G.Settings.Main["Auto Eat"],
    Desc = "",
    Callback = function(value)
        _G.Settings.Main["Auto Eat"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local autoEatFoods = {
            "Cooked Steak", "Cooked Morsel", "Berry", "Carrot", "Apple"
        }
        local itemsFolder = workspace:WaitForChild("Items")
        local remoteConsume = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")
        local remoteDrag = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
        while true do
            task.wait(0.5)
            if _G.Settings.Main["Auto Eat"] then
                local available = {}
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item:IsA("Model") and table.find(autoEatFoods, item.Name) then
                        table.insert(available, item)
                    end
                end
                if #available > 0 then
                    local food = available[math.random(1, #available)]
                    pcall(function()
                        remoteDrag:FireServer(food)
                        task.wait(0.25)
                        remoteConsume:InvokeServer(food)
                    end)
                end
            else
                task.wait(1)
            end
        end
    end)
end))

local Sec_MainTab_3 = Tabs.MainTab:AddSection("Flowers")
_G.AutoCollectFlower = false

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local originalCFrame = nil
local pickFlowerRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPickFlower")

function collectFlower(flower)
    pcall(function()
        if not flower:IsA("Model") or not flower.PrimaryPart then return end
        if not originalCFrame then
            originalCFrame = hrp.CFrame
        end
        hrp.CFrame = flower.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.1)
        pickFlowerRemote:InvokeServer(flower)
        task.wait(0.1)
    end)
end

function returnToOriginal()
    if originalCFrame then
        hrp.CFrame = originalCFrame
        originalCFrame = nil
    end
end

spawn(LPH_NO_VIRTUALIZE(function()
    while true do
        task.wait(0.2)

        if _G.AutoCollectFlower then
            local found = false
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("flower") and obj:IsA("Model") then
                    found = true
                    collectFlower(obj)
                end
            end
            if not found then
                returnToOriginal()
            end
        else
            returnToOriginal()
        end
    end
end))

Sec_MainTab_3:AddToggle({
    Title = "Auto Collect Flower",
    Default = _G.AutoCollectFlower,
    Callback = function(val)
        _G.AutoCollectFlower = val
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
Sec_MainTab_3:AddButton({
    Title = "Show Flower Shop",
    Callback = function()
        local flowerUI = player:WaitForChild("PlayerGui")
            :WaitForChild("Interface")
            :FindFirstChild("Flower")
        if flowerUI then
            flowerUI.Visible = true
        end
    end
})
Sec_MainTab_3:AddButton({
    Title = "Teleport Seed Box",
    Callback = function()
        local seedBox = workspace:FindFirstChild("Items") and workspace.Items:FindFirstChild("Seed Box")
        if seedBox then
            if not seedBox.PrimaryPart then
                seedBox.PrimaryPart = seedBox:FindFirstChild("HumanoidRootPart") or seedBox:FindFirstChildWhichIsA("BasePart")
            end
            if seedBox.PrimaryPart then
                seedBox:SetPrimaryPartCFrame(CFrame.new(0, 8, 0))
            end
        end
    end
})             
selectedTargets = {}

local Sec_ItemTab_Default = Tabs.ItemTab:AddSection("General")
Sec_ItemTab_Default:AddDropdown({
    Title = "Choose Target",
    Options = { "Player", "Campfire" },
    Default = {},        
    Multi = true,       
    AllowNone = true,
    Callback = function(option)
        selectedTargets = option
    end
})


local Sec_ItemTab_1 = Tabs.ItemTab:AddSection("Gears")
local selectedItems = {}
Sec_ItemTab_1:AddDropdown({
    Title = "Choose Item",
    Options = {
        "Bolt", "Tyre", "Sheet Metal", "Old Radio", "Broken Fan",
        "Broken Microwave", "Washing Machine", "Old Car Engine",
        "UFO Scrap", "UFO Component", "UFO Junk", "Cutlist Gem", "Gem of the Forest"
    },
    Default = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedItems = option
    end
})
local MAX_ITEMS = 1000

Sec_ItemTab_1:AddButton({
    Title = "Collect Item",
    Content = "",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local itemsFolder = workspace:WaitForChild("Items")
        local totalMoved = 0
        local notFound = {}

        function includes(t, v)
            return t and table.find(t, v) ~= nil
        end

        local destinationCFrame
        if includes(selectedTargets, "Campfire") then
            destinationCFrame = CFrame.new(0, 8, 0)
        elseif includes(selectedTargets, "Player") then
            destinationCFrame = hrp.CFrame
        else
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose a Target",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        local MAX_ITEMS = MAX_ITEMS or math.huge

        for _, itemName in ipairs(selectedItems or {}) do
            if totalMoved >= MAX_ITEMS then break end

            local foundAny = false
            for _, item in ipairs(itemsFolder:GetChildren()) do
                if totalMoved >= MAX_ITEMS then break end
                if item.Name == itemName then
                    foundAny = true

                    if item:IsA("Model") then
                        item:PivotTo(destinationCFrame)
                    elseif item:IsA("BasePart") then
                        item.CFrame = destinationCFrame
                    else
                        local part = item:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local modelLike = part:FindFirstAncestorOfClass("Model")
                            if modelLike then
                                modelLike:PivotTo(destinationCFrame)
                            else
                                part.CFrame = destinationCFrame
                            end
                        end
                    end

                    totalMoved += 1
                    task.wait(0.03)
                end
            end

            if not foundAny then
                table.insert(notFound, itemName)
            end
        end

        local targetLabel = includes(selectedTargets, "Campfire") and "Campfire (0, 8, 0)" or "Player"
        if totalMoved > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "✅ Successfully moved ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
        end

        if #notFound > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Not found: ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 5
})
        end
    end
})


local Sec_ItemTab_2 = Tabs.ItemTab:AddSection("Fuel")
local selectedFuelItems = {}
Sec_ItemTab_2:AddDropdown({
    Title = "Choose Fuel",
    Options = {
        "Corpse", "Sapling", "Alien", "Log", "Chair",
        "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"
    },
    Default = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedFuelItems = option
    end
})
Sec_ItemTab_2:AddButton({
    Title = "Collect Fuel",
    Content = "",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local itemsFolder = workspace:WaitForChild("Items")
        local totalMoved = 0
        local notFound = {}

        function includes(t, v) return t and table.find(t, v) ~= nil end

        local dest
        if includes(selectedTargets, "Campfire") then
            dest = CFrame.new(0, 8, 0)
        elseif includes(selectedTargets, "Player") then
            dest = hrp.CFrame
        else
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose a Target",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        local MAX_ITEMS = MAX_ITEMS or math.huge

        if not (selectedFuelItems and #selectedFuelItems > 0) then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose Fuel Items",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        for _, itemName in ipairs(selectedFuelItems) do
            if totalMoved >= MAX_ITEMS then break end
            local found = false

            for _, item in ipairs(itemsFolder:GetChildren()) do
                if totalMoved >= MAX_ITEMS then break end
                if item.Name == itemName then
                    found = true

                    if item:IsA("Model") then
                        item:PivotTo(dest)
                    elseif item:IsA("BasePart") then
                        item.CFrame = dest
                    else
                        local part = item:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local modelLike = part:FindFirstAncestorOfClass("Model")
                            if modelLike then
                                modelLike:PivotTo(dest)
                            else
                                part.CFrame = dest
                            end
                        end
                    end

                    totalMoved += 1
                    task.wait(0.03)
                end
            end

            if not found then
                table.insert(notFound, itemName)
            end
        end

        local targetLabel = includes(selectedTargets, "Campfire") and "Campfire (0, 8, 0)" or "Player"
        if totalMoved > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "✅ Successfully moved ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
        end

        if #notFound > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Not found: ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 5
})
        end
    end
})


local Sec_ItemTab_3 = Tabs.ItemTab:AddSection("Food / Healing")
local selectedFoodItems = {}
Sec_ItemTab_3:AddDropdown({
    Title = "Choose Food / Healing",
    Options = {
        "Carrot", "Berry", "Morsel", "Steak", "Ribs",
        "Cooked Morsel", "Cooked Steak", "Cooked Ribs",
        "Bandage", "Medkit", "Chili"
    },
    Default = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedFoodItems = option
    end
})

Sec_ItemTab_3:AddButton({
    Title = "Collect Food / Healing",
    Content = "",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local itemsFolder = workspace:WaitForChild("Items")
        local totalMoved, notFound = 0, {}

        function includes(t, v) return t and table.find(t, v) ~= nil end

        local dest
        if includes(selectedTargets, "Campfire") then
            dest = CFrame.new(0, 8, 0)
        elseif includes(selectedTargets, "Player") then
            dest = hrp.CFrame
        else
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose a Target",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        local MAX_ITEMS = MAX_ITEMS or math.huge

        if not (selectedFoodItems and #selectedFoodItems > 0) then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose Food Items",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        for _, itemName in ipairs(selectedFoodItems) do
            if totalMoved >= MAX_ITEMS then break end
            local found = false

            for _, item in ipairs(itemsFolder:GetChildren()) do
                if totalMoved >= MAX_ITEMS then break end
                if item.Name == itemName then
                    found = true

                    if item:IsA("Model") then
                        item:PivotTo(dest)
                    elseif item:IsA("BasePart") then
                        item.CFrame = dest
                    else
                        local part = item:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local modelLike = part:FindFirstAncestorOfClass("Model")
                            if modelLike then
                                modelLike:PivotTo(dest)
                            else
                                part.CFrame = dest
                            end
                        end
                    end

                    totalMoved += 1
                    task.wait(0.03)
                end
            end

            if not found then
                table.insert(notFound, itemName)
            end
        end

        local targetLabel = includes(selectedTargets, "Campfire") and "Campfire (0, 8, 0)" or "Player"
        if totalMoved > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "✅ Successfully moved ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
        end

        if #notFound > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Not found: ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 5
})
        end
    end
})


local Sec_ItemTab_4 = Tabs.ItemTab:AddSection("Guns & Armor")
local selectedGearItems = {}

Sec_ItemTab_4:AddDropdown({
    Title = "Choose Guns / Armor",
    Options = {
        "Morning star", "Laser Sword", "Raygun", "Chainsaw", "Strong Axe",
        "Spear", "Good Axe", "Revolver", "Rifle", "Tactical Shotgun",
        "Revolver Ammo", "Rifle Ammo", "Alien Armour", "Leather Body",
        "Iron Body", "Thorn Body", "Riot Shield"
    },
    Default = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedGearItems = option
    end
})

Sec_ItemTab_4:AddButton({
    Title = "Collect Guns / Armor",
    Content = "",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local itemsFolder = workspace:WaitForChild("Items")
        local totalMoved, notFound = 0, {}

        function includes(t, v) return t and table.find(t, v) ~= nil end

        local dest
        if includes(selectedTargets, "Campfire") then
            dest = CFrame.new(0, 8, 0)
        elseif includes(selectedTargets, "Player") then
            dest = hrp.CFrame
        else
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose a Target",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        local MAX_ITEMS = MAX_ITEMS or math.huge
        if not (selectedGearItems and #selectedGearItems > 0) then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose Gear Items",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        for _, itemName in ipairs(selectedGearItems) do
            if totalMoved >= MAX_ITEMS then break end
            local found = false

            for _, item in ipairs(itemsFolder:GetChildren()) do
                if totalMoved >= MAX_ITEMS then break end
                if item.Name == itemName then
                    found = true

                    if item:IsA("Model") then
                        item:PivotTo(dest)
                    elseif item:IsA("BasePart") then
                        item.CFrame = dest
                    else
                        local part = item:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local modelLike = part:FindFirstAncestorOfClass("Model")
                            if modelLike then
                                modelLike:PivotTo(dest)
                            else
                                part.CFrame = dest
                            end
                        end
                    end

                    totalMoved += 1
                    task.wait(0.03)
                end
            end

            if not found then
                table.insert(notFound, itemName)
            end
        end

        local targetLabel = includes(selectedTargets, "Campfire") and "Campfire (0, 8, 0)" or "Player"
        if totalMoved > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "✅ Successfully moved ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
        end

        if #notFound > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Not found: ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 5
})
        end
    end
})


local Sec_ItemTab_5 = Tabs.ItemTab:AddSection("Chest")
Sec_ItemTab_5:AddToggle({
    Title = "Auto Open Chest",
    Default = _G.Settings.Main["Auto Open Chest"],
    Desc = "",
    Callback = function(value)
        _G.Settings.Main["Auto Open Chest"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})

spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        while true do
            task.wait(0.5)
            if _G.Settings.Main["Auto Open Chest"] then
                while _G.Settings.Main["Auto Open Chest"] do
                    local itemsFolder = workspace:FindFirstChild("Items")
                    if itemsFolder then
                        for _, chest in ipairs(itemsFolder:GetChildren()) do
                            if not _G.Settings.Main["Auto Open Chest"] then break end
                            if chest:IsA("Model") and string.find(chest.Name, "Chest") then
                                local prompt = chest:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then
                                    fireproximityprompt(prompt, 0)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            else
                task.wait(1)
            end
        end
    end)
end))
local selectedItems = {}

local allItems = {
    "Bandage",
    "Good Sack",
    "Good Axe",
    "Old Flashlight",
    "Spear",
    "Revolver",
    "Revolver Ammo",
    "Fuel Canister",
    "Flower Seeds",
    "Alien Armor",
    "Laser Sword",
    "Laser Cannon",
    "Ice Axe",
    "Snowball",
    "Ice Sword",
    "Frozen Shuriken",
    "Leather Body",
    "Berry Seeds",
    "Rifle",
    "Ammo",
    "Strong Flashlight",
    "Defensive Blueprint Spikes",
    "Iron Body",
    "Chili Seeds",
    "Oil Barrel",
    "Strong Axe",
    "Giant Sack",
    "Medkit",
    "Defensive Blueprint Bear Trap",
    "Defensive Blueprint Barbed Sore",
    "Cultist Gem",
    "Chainsaw",
    "Kunai",
    "Riot Shield",
    "Thorn Armor",
    "Tactical Shotgun",
    "Gem of the Forest Fragment"
}

Sec_ItemTab_5:AddDropdown({
    Title = "Select Chest Items",
    Options = allItems,
    Default = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedItems = selected
    end
})
Sec_ItemTab_5:AddButton({
    Title = "Collect Chest Items",
    Content = "",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local itemsFolder = workspace:WaitForChild("Items")
        local totalMoved, notFound = 0, {}

        function includes(t, v) return t and table.find(t, v) ~= nil end

        local dest
        if includes(selectedTargets, "Campfire") then
            dest = CFrame.new(0, 8, 0)
        elseif includes(selectedTargets, "Player") then
            dest = hrp.CFrame
        else
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose a Target",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        local MAX_ITEMS = MAX_ITEMS or math.huge
        if not (selectedItems and #selectedItems > 0) then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose Items",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        for _, itemName in ipairs(selectedItems) do
            if totalMoved >= MAX_ITEMS then break end
            local found = false

            for _, item in ipairs(itemsFolder:GetChildren()) do
                if totalMoved >= MAX_ITEMS then break end
                if item.Name == itemName then
                    found = true

                    if item:IsA("Model") then
                        item:PivotTo(dest)
                    elseif item:IsA("BasePart") then
                        item.CFrame = dest
                    else
                        local part = item:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local modelLike = part:FindFirstAncestorOfClass("Model")
                            if modelLike then
                                modelLike:PivotTo(dest)
                            else
                                part.CFrame = dest
                            end
                        end
                    end

                    totalMoved += 1
                    task.wait(0.03)
                    break
                end
            end

            if not found then
                table.insert(notFound, itemName)
            end
        end

        local targetLabel = includes(selectedTargets, "Campfire") and "Campfire (0, 8, 0)" or "Player"
        if totalMoved > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "✅ Successfully moved ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
        end

        if #notFound > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Not found: ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 5
})
        end
    end
})


local Sec_ItemTab_6 = Tabs.ItemTab:AddSection("Other Items")
local selectedOtherItems = {}

Sec_ItemTab_6:AddDropdown({
    Title = "Choose Other Items",
    Options = {
        "Sack", "Seed Box", "Chainsaw", "Old Flashlight", "Strong Flastlight",
        "Bunny Foot", "Wolf Pelt", "Bear Pelt", "Alpha Wolf Pet",
        "Artic Fox Pelt", "Polar Bear Pelt", "Mammoth Tusk"
    },
    Default = {},
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        selectedOtherItems = option
    end
})
Sec_ItemTab_6:AddButton({
    Title = "Collect Other Items",
    Content = "",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local itemsFolder = workspace:WaitForChild("Items")
        local totalMoved, notFound = 0, {}
        local MAX_ITEMS = MAX_ITEMS or math.huge

        function includes(t, v) return t and table.find(t, v) ~= nil end

        local dest
        if includes(selectedTargets, "Campfire") then
            dest = CFrame.new(0, 8, 0)
        elseif includes(selectedTargets, "Player") then
            dest = hrp.CFrame
        else
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose a Target",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        if not (selectedOtherItems and #selectedOtherItems > 0) then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Choose Other Items",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            return
        end

        for _, itemName in ipairs(selectedOtherItems) do
            if totalMoved >= MAX_ITEMS then break end
            local found = false

            for _, item in ipairs(itemsFolder:GetChildren()) do
                if totalMoved >= MAX_ITEMS then break end
                if item.Name == itemName then
                    found = true

                    if item:IsA("Model") then
                        item:PivotTo(dest)
                    elseif item:IsA("BasePart") then
                        item.CFrame = dest
                    else
                        local part = item:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local modelLike = part:FindFirstAncestorOfClass("Model")
                            if modelLike then
                                modelLike:PivotTo(dest)
                            else
                                part.CFrame = dest
                            end
                        end
                    end

                    totalMoved += 1
                    task.wait(0.03)
                end
            end

            if not found then
                table.insert(notFound, itemName)
            end
        end

        local targetLabel = includes(selectedTargets, "Campfire") and "Campfire (0, 8, 0)" or "Player"
        if totalMoved > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "✅ Successfully moved ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
        end

        if #notFound > 0 then
            Chloex:MakeNotify({
    Title = "NatHub Notify",
    Description = "NatHub",
    Content = "⚠️ Not found: ",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 5
})
        end
    end
})



local Sec_EspTab_1 = Tabs.EspTab:AddSection("ESP Items")
local itemList = {}
local selectedItems = {}

function refreshItemList()
    itemList = {}
    local itemsFolder = workspace:FindFirstChild("Items")
    if itemsFolder then
        for _, item in ipairs(itemsFolder:GetChildren()) do
            if item:IsA("Model") and item.PrimaryPart and not table.find(itemList, item.Name) then
                table.insert(itemList, item.Name)
            end
        end
    end
    return itemList
end

local ItemDropdown = Sec_EspTab_1:AddDropdown({
    Title = "Select Items",
    Options = refreshItemList(),
    Default = selectedItems,
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedItems = selected
    end
})

local RefreshItemButton = Sec_EspTab_1:AddButton({
    Title = "Refresh Item List",
    Callback = function()
        local newList = refreshItemList()
        ItemDropdown:Refresh(newList, true)
    end
})

local ESPToggle = Sec_EspTab_1:AddToggle({
    Title = "Esp Items",
    Default = _G.Settings.Esp["Enable Item ESP"],
    Callback = function(v)
        _G.Settings.Esp["Enable Item ESP"] = v
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})

function getColorForName(name)
    local hash = 0
    for i = 1, #name do
        hash = (hash + name:byte(i)) % 256
    end
    return Color3.fromHSV(hash / 256, 1, 1)
end

local espItems = {}

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.2) do
        pcall(function()
            local itemsFolder = workspace:FindFirstChild("Items")
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            
            if not (_G.Settings.Esp["Enable Item ESP"] and #selectedItems > 0) then
                for item, obj in pairs(espItems) do
                    obj.highlight:Destroy()
                    obj.billboard:Destroy()
                    espItems[item] = nil
                end
                return
            end
            
            for _, item in ipairs(itemsFolder and itemsFolder:GetChildren() or {}) do
                if item:IsA("Model") and item.PrimaryPart then
                    local shouldESP = table.find(selectedItems, item.Name)
                    
                    if shouldESP then
                        local dist = hrp and (hrp.Position - item.PrimaryPart.Position).Magnitude
                        local name = item.Name
                        
                        if not espItems[item] then
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = getColorForName(name)
                            highlight.OutlineColor = Color3.new(1, 1, 1)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = item
                            highlight.Parent = item
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.AlwaysOnTop = true
                            billboard.Adornee = item.PrimaryPart
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextScaled = true
                            label.Font = Enum.Font.SourceSansBold
                            label.TextColor3 = highlight.FillColor
                            label.TextStrokeTransparency = 0.5
                            label.Parent = billboard
                            billboard.Parent = item
                            
                            espItems[item] = {highlight = highlight, label = label, billboard = billboard}
                        end
                        
                        if espItems[item] and espItems[item].label then
                            espItems[item].label.Text = name .. " | " .. (dist and string.format("%.1f", dist) or "?") .. "m"
                        end
                    else
                        if espItems[item] then
                            espItems[item].highlight:Destroy()
                            espItems[item].billboard:Destroy()
                            espItems[item] = nil
                        end
                    end
                end
            end
            
            for item, obj in pairs(espItems) do
                if not item or not item:IsDescendantOf(game) or not table.find(selectedItems, item.Name) then
                    obj.highlight:Destroy()
                    obj.billboard:Destroy()
                    espItems[item] = nil
                end
            end
        end)
    end
end))
local Sec_CraftingTab_Default = Tabs.CraftingTab:AddSection("General")
local CraftMaterialStatus = Sec_CraftingTab_Default:AddParagraph({
    Title = "Material Status",
    Content = "Waiting for material info..."
})
function CleanText(text)
    text = text:gsub("[%c%s]+", " ") 
    text = text:gsub("^%s+", "")    
    text = text:gsub("%s+$", "")    
    return text
end
spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.5) do
        pcall(function()
            local map = workspace:FindFirstChild("Map")
            local camp = map and map:FindFirstChild("Campground")
            local bench = camp and camp:FindFirstChild("CraftingBench")
            local woodLabel = bench and bench:FindFirstChild("WoodSign")
                and bench.WoodSign:FindFirstChild("SurfaceGui")
                and bench.WoodSign.SurfaceGui:FindFirstChild("TextLabel")
            local scrapLabel = bench and bench:FindFirstChild("ScrapSign")
                and bench.ScrapSign:FindFirstChild("SurfaceGui")
                and bench.ScrapSign.SurfaceGui:FindFirstChild("TextLabel")
            local woodText = woodLabel and CleanText(woodLabel.Text) or "N/A"
            local scrapText = scrapLabel and CleanText(scrapLabel.Text) or "N/A"
            local output = "Wood: " .. woodText .. " | Scrap: " .. scrapText
            CraftMaterialStatus:SetDesc(output)
        end)
    end
end))
local Sec_CraftingTab_1 = Tabs.CraftingTab:AddSection("Bench 1")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CraftItem")
local craftableItems = {
    "Map",
    "Old Bed",
    "Bunny Trap",
    "Crafting Bench 2"
}
for _, itemName in ipairs(craftableItems) do
    Sec_CraftingTab_1:AddButton({
        Title = "Craft: " .. itemName,
        Content = "⚠️Only use this if you have materials!",
        Callback = function()
            pcall(function()
                remote:InvokeServer(itemName)
            end)
        end
    })
end
local Sec_CraftingTab_2 = Tabs.CraftingTab:AddSection("Bench 2")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CraftItem")
local craftableItems = {
    "Sun Dial",
    "Regular Bed",
    "Compass",
    "Freezer",
    "Farm Plot",
    "Wood Rain Storage",
    "Shelf",
    "Log Wall",
    "Bear Trap",
    "Crafting Bench 3"
}
for _, itemName in ipairs(craftableItems) do
    Sec_CraftingTab_2:AddButton({
        Title = "Craft: " .. itemName,
        Content = "⚠️Only use this if you have materials!",
        Callback = function()
            pcall(function()
                remote:InvokeServer(itemName)
            end)
        end
    })
end
local Sec_CraftingTab_3 = Tabs.CraftingTab:AddSection("Bench 3")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CraftItem")
local craftableItems = {
    "Crock Pot",
    "Radar",
    "Boost Pad",
    "Biofuel Processor",
    "Torch",
    "Good Bed",
    "Lightning Rod",
    "Crafting Bench 4"
}
for _, itemName in ipairs(craftableItems) do
    Sec_CraftingTab_3:AddButton({
        Title = "Craft: " .. itemName,
        Content = "⚠️Only use this if you have materials!",
        Callback = function()
            pcall(function()
                remote:InvokeServer(itemName)
            end)
        end
    })
end
local Sec_CraftingTab_4 = Tabs.CraftingTab:AddSection("Bench 4")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CraftItem")
local craftableItems = {
    "Ammo Crate",
    "Oil Drill",
    "Giant Bed",
    "Teleporter",
    "Crafting Bench 5"
}
for _, itemName in ipairs(craftableItems) do
    Sec_CraftingTab_4:AddButton({
        Title = "Craft: " .. itemName,
        Content = "⚠️Only use this if you have materials!",
        Callback = function()
            pcall(function()
                remote:InvokeServer(itemName)
            end)
        end
    })
end
local Sec_CraftingTab_5 = Tabs.CraftingTab:AddSection("Bench 5")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("CraftItem")
local craftableItems = {
    "Respawn Capsule",
    "Temporal Accelerometer",
    "Weather Machine"
}
for _, itemName in ipairs(craftableItems) do
    Sec_CraftingTab_5:AddButton({
        Title = "Craft: " .. itemName,
        Content = "⚠️Only use this if you have materials!",
        Callback = function()
            pcall(function()
                remote:InvokeServer(itemName)
            end)
        end
    })
end
local Sec_EspTab_2 = Tabs.EspTab:AddSection("ESP Enemy")
local enemyList = {}
local selectedEnemies = {}

function refreshEnemyList()
    enemyList = {}
    local chars = workspace:FindFirstChild("Characters")
    if chars then
        for _, char in ipairs(chars:GetChildren()) do
            if char:IsA("Model") and char:FindFirstChildWhichIsA("Humanoid") and not table.find(enemyList, char.Name) then
                table.insert(enemyList, char.Name)
            end
        end
    end
    return enemyList
end

local Dropdown = Sec_EspTab_2:AddDropdown({
    Title = "Select Enemies",
    Options = refreshEnemyList(),
    Default = selectedEnemies,
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedEnemies = selected
    end
})

local RefreshButton = Sec_EspTab_2:AddButton({
    Title = "Refresh Enemy List",
    Callback = function()
        local newList = refreshEnemyList()
        Dropdown:Refresh(newList, true)
    end
})

local ESPToggle = Sec_EspTab_2:AddToggle({
    Title = "Esp Enemy",
    Default = _G.Settings.Esp["Enable Enemy ESP"],
    Callback = function(v)
        _G.Settings.Esp["Enable Enemy ESP"] = v
    end
})

function getColorForName(name)
    local hash = 0
    for i = 1, #name do
        hash = (hash + name:byte(i)) % 256
    end
    return Color3.fromHSV(hash / 256, 1, 1)
end

local espChars = {}

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.2) do
        pcall(function()
            local chars = workspace:FindFirstChild("Characters")
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            
            if not (_G.Settings.Esp["Enable Enemy ESP"] and #selectedEnemies > 0) then
                for char, obj in pairs(espChars) do
                    obj.highlight:Destroy()
                    obj.label.Parent:Destroy()
                    espChars[char] = nil
                end
                return
            end
            
            for _, char in ipairs(chars and chars:GetChildren() or {}) do
                if char:IsA("Model") and char:FindFirstChildWhichIsA("Humanoid") then
                    local shouldESP = table.find(selectedEnemies, char.Name)
                    
                    if shouldESP then
                        local dist = hrp and (hrp.Position - char:GetPrimaryPartCFrame().Position).Magnitude
                        local name = char.Name
                        
                        if not espChars[char] then
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = getColorForName(name)
                            highlight.OutlineColor = Color3.new(1, 1, 1)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = char
                            highlight.Parent = char
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.AlwaysOnTop = true
                            billboard.Adornee = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head") or char.PrimaryPart
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextScaled = true
                            label.Font = Enum.Font.SourceSansBold
                            label.TextColor3 = highlight.FillColor
                            label.TextStrokeTransparency = 0.5
                            label.Parent = billboard
                            billboard.Parent = char
                            
                            espChars[char] = {highlight = highlight, label = label, billboard = billboard}
                        end
                        
                        if espChars[char] and espChars[char].label then
                            espChars[char].label.Text = name .. " | " .. (dist and string.format("%.1f", dist) or "?") .. "m"
                        end
                    else
                        if espChars[char] then
                            espChars[char].highlight:Destroy()
                            espChars[char].billboard:Destroy()
                            espChars[char] = nil
                        end
                    end
                end
            end
            
            for char, obj in pairs(espChars) do
                if not char or not char:IsDescendantOf(game) or not table.find(selectedEnemies, char.Name) then
                    obj.highlight:Destroy()
                    obj.billboard:Destroy()
                    espChars[char] = nil
                end
            end
        end)
    end
end))
local Sec_TeleportTab_1 = Tabs.TeleportTab:AddSection("Teleport")
Sec_TeleportTab_1:AddButton({
    Title = "Teleport to Campground",
    Content = "",
    Callback = function()
        local position = Vector3.new(0, 8, 0)
        local character = game.Players.LocalPlayer.Character
        if character then
            character:PivotTo(CFrame.new(position))
        end
    end
})
local localPlayer = Players.LocalPlayer
local itemFolder = workspace:WaitForChild("Items")
local itemNames = {
    "Revolver", "Medkit", "Alien Chest", "Berry", "Bolt", "Broken Fan",
    "Carrot", "Coal", "Coin Stack", "Hologram Emitter", "Item Chest",
    "Laser Fence Blueprint", "Log", "Old Flashlight", "Old Radio",
    "Sheet Metal", "Bandage", "Rifle"
}
_G.Settings = _G.Settings or {}
_G.Settings.Teleport = _G.Settings.Teleport or {}
_G.Settings.Teleport["Selected Item"] = itemNames[1]
Sec_TeleportTab_1:AddDropdown({
    Title = "Teleport to Item",
    Options = itemNames,
    Default = _G.Settings.Teleport["Selected Item"],
    Callback = function(value)
        _G.Settings.Teleport["Selected Item"] = value
    end
})
function getModelPart(model)
    if model.PrimaryPart then return model.PrimaryPart end
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end
Sec_TeleportTab_1:AddButton({
    Title = "Teleport to Selected Item",
    Content = "",
    Callback = function()
        local selectedItem = _G.Settings.Teleport["Selected Item"]
        local candidates = {}
        for _, model in ipairs(itemFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == selectedItem then
                local part = getModelPart(model)
                if part then
                    table.insert(candidates, part)
                end
            end
        end
        if #candidates == 0 then
            return
        end
        local targetPart = candidates[math.random(1, #candidates)]
        local character = localPlayer.Character
        if character then
            if hrp then
                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
})
Sec_TeleportTab_1:AddButton({
    Title = "Teleport to Volcano",
    Content = "",
    Callback = function()
        pcall(function()
            local volcano = workspace.Map.Landmarks:FindFirstChild("Volcano")
            if volcano and volcano:IsA("Model") then
                local character = LocalPlayer.Character
                if character then
                    if hrp then
                        hrp.CFrame = volcano:GetPivot() + Vector3.new(0, 5, 0)
                    end
                end
            else
                Chloex:MakeNotify({
    Title = "Volcano Not Found",
    Description = "WisHub",
    Content = "Volcano has not spawned yet",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})
            end
        end)
    end
})
local Lighting = game:GetService("Lighting")

local Sec_MiscTab_Default = Tabs.MiscTab:AddSection("General")
Sec_MiscTab_Default:AddToggle({
    Title = "Auto Detect Night",
    Default = _G.Settings.Misc["Night Teleport"],
    Desc = "Automatically Teleport to Campfire",
    Callback = function(value)
        _G.Settings.Misc["Night Teleport"] = value
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})

Sec_MiscTab_Default:AddToggle({
    Title = "Anti Void",
    Default = _G.Settings.Misc["Anti Void"],
    Callback = function(value)
        _G.Settings.Misc["Anti Void"] = value
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})

spawn(LPH_NO_VIRTUALIZE(function()
    while true do
        task.wait(0.3)
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local currentPos = hrp.Position
            local targetPos = Vector3.new(0, 8, 0)
            local distance = (currentPos - targetPos).Magnitude
            
            if _G.Settings.Misc["Anti Void"] and currentPos.Y < -5 and distance > 10 then
                hrp.CFrame = CFrame.new(targetPos)
            end
            
            if _G.Settings.Misc["Night Teleport"] then
                local currentTime = Lighting.ClockTime
                local isNightTime = currentTime < 6 or currentTime >= 18
                if isNightTime and distance > 10 then
                    hrp.CFrame = CFrame.new(targetPos)
                end
            end
        end
    end
end))
Sec_MiscTab_Default:AddSlider({
    Title = "Character Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        _G.Settings.Misc = _G.Settings.Misc or {}
        _G.Settings.Misc["Character Speed"] = value
        local character = game:GetService("Players").LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer


Sec_MiscTab_Default:AddToggle({
    Title = "Infinite Jump",
    Default = _G.Settings.Misc and _G.Settings.Misc["Infinite Jump"] or false,
    Callback = function(value)
        _G.Settings.Misc["Infinite Jump"] = value
        if _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})


if not _G.InfiniteJumpConnection then
    _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        if _G.Settings.Misc and _G.Settings.Misc["Infinite Jump"] then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)
end
Sec_MiscTab_Default:AddToggle({
    Title = "Fly",
    Default = _G.Settings.Misc and _G.Settings.Misc["Fly"] or false,
    Callback = function(value)
        _G.Settings.Misc = _G.Settings.Misc or {}
        _G.Settings.Misc["Fly"] = value
        local speaker = game:GetService("Players").LocalPlayer
        local char = speaker.Character or speaker.CharacterAdded:Wait()
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        
        if value then
            _G.nowe = true
            _G.tpwalking = false
            local speeds = _G.Settings.Misc["FlySpeed"] or 5
            char.Animate.Disabled = true
            
            for _, v in next, hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
            
            for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                hum:SetStateEnabled(state, false)
            end
            
            hum.PlatformStand = true
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
            
            for i = 1, speeds do
                task.spawn(function()
                    local hb = game:GetService("RunService").Heartbeat
                    while _G.nowe and hb:Wait() and char and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            char:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
            
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if root then
                if _G.FlyBV then _G.FlyBV:Destroy() end
                local bv = Instance.new("BodyVelocity", root)
                bv.Velocity = Vector3.new(0, 0.1, 0)
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                _G.FlyBV = bv
                
                task.spawn(function()
                    while _G.nowe and task.wait() and root and root.Parent do
                        local cam = workspace.CurrentCamera
                        local pos = root.Position
                        local dir = cam.CFrame.LookVector
                        root.CFrame = CFrame.new(pos, pos + dir)
                    end
                end)
            end
        else
            _G.nowe = false
            local char = speaker.Character
            local hum = char and char:FindFirstChildWhichIsA("Humanoid")
            
            if hum then
                for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                    hum:SetStateEnabled(state, true)
                end
                
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                char.Animate.Disabled = false
                
                task.wait(0.1)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            if _G.FlyBV then 
                _G.FlyBV:Destroy() 
                _G.FlyBV = nil 
            end
        end
    end
})
local Lighting = game:GetService("Lighting")
function setFogState(enabled)
    if enabled then
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 1e6 - 1
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    end
end
Sec_MiscTab_Default:AddToggle({
    Title = "Remove Fog",
    Default = _G.Settings.Misc and _G.Settings.Misc["Remove Fog"],
    Callback = function(value)
        _G.Settings.Misc = _G.Settings.Misc or {}
        _G.Settings.Misc["Remove Fog"] = value
        setFogState(value)
    end
})
Sec_MiscTab_Default:AddButton({
    Title = "FPS Boost",
    Callback = function()
        local decalsyeeted = true
        local g = game
        local w = g.Workspace

        function optimizeObject(v)
            if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end

        for _, v in pairs(g:GetDescendants()) do
            optimizeObject(v)
        end

        spawn(function()
            w.DescendantAdded:Connect(function(newObj)
                optimizeObject(newObj)
                if newObj:IsA("Model") or newObj:IsA("Folder") then
                    for _, child in ipairs(newObj:GetDescendants()) do
                        optimizeObject(child)
                    end
                end
            end)
        end)
    end
})
local Sec_QuestTab_Default = Tabs.QuestTab:AddSection("General")
Sec_QuestTab_Default:AddParagraph({
    Title = "Announcement",
    Content = "Equip Weapon to Enable"
})
local Sec_QuestTab_1 = Tabs.QuestTab:AddSection("Lost Child 1")
local JailCellarLabel = Sec_QuestTab_1:AddParagraph({
    Title = "Jail Cellar Status",
    Content = "Status : Waiting..."
})
spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.2) do
        pcall(function()
            local jailCellar = workspace:FindFirstChild("Map")
                and workspace.Map:FindFirstChild("Landmarks")
                and workspace.Map.Landmarks:FindFirstChild("Jail Cellar1")

            if jailCellar then
                JailCellarLabel:SetDesc("Status : Map Spawned 🟢")
            else
                JailCellarLabel:SetDesc("Status : Not Spawned 🔴")
            end
        end)
    end
end))
Sec_QuestTab_1:AddToggle({
    Title = "Auto Lost Child 1",
    Desc = "Need Campfire Level 2",
    Default = _G.Settings.Quest["Auto Lost Child Quest"],
    Callback = function(value)
        _G.Settings.Quest["Auto Lost Child Quest"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local HRP = character:WaitForChild("HumanoidRootPart")
local bodyVelocity = Instance.new("BodyVelocity")
local bodyGyro = Instance.new("BodyGyro")
local flySpeed = 50
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
function fly()
    bodyVelocity.Parent = HRP
    bodyGyro.Parent = HRP
    humanoid.PlatformStand = true
    local hoverConnection
    hoverConnection = RunService.Heartbeat:Connect(function()
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        bodyVelocity.Velocity = Vector3.new(0, 0, 0) 
    end)    
    return hoverConnection
end
function unfly(hoverConnection)
    if hoverConnection then hoverConnection:Disconnect() end
    bodyVelocity.Parent = nil
    bodyGyro.Parent = nil
    humanoid.PlatformStand = false   
end
task.spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        local player = Players.LocalPlayer
        local visitedTrees = {}

        local sackNames = {
            ["Old Sack"] = true,
            ["Good Sack"] = true,
            ["Giant Sack"] = true,
        }

        while true do
            task.wait(1)
            if _G.Settings.Quest["Auto Lost Child Quest"] then
                local hover = fly()
                local jailCellar
                local foliage = Workspace:WaitForChild("Map"):WaitForChild("Foliage")
                visitedTrees = {}

                while not jailCellar and _G.Settings.Quest["Auto Lost Child Quest"] do
                    for _, tree in pairs(foliage:GetChildren()) do
                        if not _G.Settings.Quest["Auto Lost Child Quest"] then
                            unfly(hover)
                            break
                        end
                        if tree:IsA("Model") and (tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and not visitedTrees[tree] then
                            visitedTrees[tree] = true
                            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            local base = tree:FindFirstChildWhichIsA("BasePart")
                            if root and base then
                                root.CFrame = base.CFrame + Vector3.new(0, 3, 0)
                            end
                            task.wait(1)
                            jailCellar = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Landmarks") and Workspace.Map.Landmarks:FindFirstChild("Jail Cellar1")
                            if jailCellar then break end
                        end
                    end
                    task.wait(1)
                end

                if jailCellar then
                    local jailCellar = Workspace.Map.Landmarks:WaitForChild("Jail Cellar1")
                    local keyInteraction = jailCellar.LockedDoor:WaitForChild("KeyInteraction")
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:WaitForChild("HumanoidRootPart")
                    root.CFrame = keyInteraction.CFrame + Vector3.new(0, 25, 0)
                    task.wait(5)

                    local redKey
                    repeat
                        redKey = Workspace.Items:FindFirstChild("Red Key")
                        task.wait(0.5)
                    until redKey

                    RemoteEvents.RequestStartDraggingItem:FireServer(redKey)
                    redKey.PrimaryPart.CFrame = keyInteraction.CFrame
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.LockedDoor, true)
                    task.wait(0.3)
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.Door, true)
                    task.wait(0.3)

                    local inventory = player:WaitForChild("Inventory")
                    local itemBag = player:WaitForChild("ItemBag")
                    local sackItem
                    for _, item in ipairs(inventory:GetChildren()) do
                        if sackNames[item.Name] then
                            sackItem = item
                            break
                        end
                    end

                    local lostChild = Workspace.Characters:FindFirstChild("Lost Child")
                    if lostChild and sackItem then
                        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                        local rightArm = lostChild:FindFirstChild("Right Arm") or lostChild.PrimaryPart
                        if rightArm then
                            humanoidRootPart.CFrame = rightArm.CFrame
                            task.wait(0.2)
                            RemoteEvents.RequestBagStoreItem:InvokeServer(sackItem, lostChild)
                            task.wait(0.2)
                            humanoidRootPart.CFrame = CFrame.new(0, 8, 0)
                            task.wait(0.2)
                            RemoteEvents.EquipItemHandle:FireServer("FireAllClients", sackItem)
                            task.wait(0.3)
                            RemoteEvents.RequestBagDropItem:FireServer(sackItem, lostChild)
                            unfly(hover)
                        end
                    end
                end

                repeat task.wait(1) until not _G.Settings.Quest["Auto Lost Child Quest"]
                unfly(hover)
            end
        end
    end)
end))
local Sec_QuestTab_2 = Tabs.QuestTab:AddSection("Lost Child 2")
local JailCellar2Label = Sec_QuestTab_2:AddParagraph({
    Title = "Jail Cellar 2 Status",
    Content = "Status : Waiting..."
})

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.2) do
        pcall(function()
            local jailCellar2 = workspace:FindFirstChild("Map")
                and workspace.Map:FindFirstChild("Landmarks")
                and workspace.Map.Landmarks:FindFirstChild("Jail Cellar2")

            if jailCellar2 then
                JailCellar2Label:SetDesc("Status : Map Spawned 🟢")
            else
                JailCellar2Label:SetDesc("Status : Not Spawned 🔴")
            end
        end)
    end
end))
Sec_QuestTab_2:AddToggle({
    Title = "Auto Lost Child 2",
    Desc = "Need Campfire Level 4",
    Default = _G.Settings.Quest["Auto Lost Child2 Quest"],
    Callback = function(value)
        _G.Settings.Quest["Auto Lost Child2 Quest"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
task.spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        local player = Players.LocalPlayer
        local visitedTrees = {}
        local sackNames = {
            ["Old Sack"] = true,
            ["Good Sack"] = true,
            ["Giant Sack"] = true,
        }

        while true do
            task.wait(0.2)
            if _G.Settings.Quest["Auto Lost Child2 Quest"] then
                local hover = fly()
                local jailCellar
                local foliage = Workspace:WaitForChild("Map"):WaitForChild("Foliage")
                visitedTrees = {}
                while not jailCellar and _G.Settings.Quest["Auto Lost Child2 Quest"] do
                    for _, tree in pairs(foliage:GetChildren()) do
                        if not _G.Settings.Quest["Auto Lost Child2 Quest"] then
                            unfly(hover)
                            break
                        end
                        if tree:IsA("Model") and (tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and not visitedTrees[tree] then
                            visitedTrees[tree] = true
                            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            local base = tree:FindFirstChildWhichIsA("BasePart")
                            if root and base then
                                root.CFrame = base.CFrame + Vector3.new(0, 3, 0)
                            end
                            task.wait(1)
                            jailCellar = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Landmarks") and Workspace.Map.Landmarks:FindFirstChild("Jail Cellar2")
                            if jailCellar then break end
                        end
                    end
                    task.wait(1)
                end

                if jailCellar then
                    local jailCellar = Workspace.Map.Landmarks:WaitForChild("Jail Cellar2")
                    local keyInteraction = jailCellar.LockedDoor:WaitForChild("KeyInteraction")
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:WaitForChild("HumanoidRootPart")
                    root.CFrame = keyInteraction.CFrame + Vector3.new(0, 25, 0)
                    task.wait(5)
                    local blueKey
                    repeat
                        blueKey = Workspace.Items:FindFirstChild("Blue Key")
                        task.wait(0.5)
                    until blueKey
                    RemoteEvents.RequestStartDraggingItem:FireServer(blueKey)
                    blueKey.PrimaryPart.CFrame = keyInteraction.CFrame
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.LockedDoor, true)
                    task.wait(0.3)
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.Door, true)
                    task.wait(0.3)
                    local inventory = player:WaitForChild("Inventory")
                    local itemBag = player:WaitForChild("ItemBag")

                    local sackItem
                    for _, item in ipairs(inventory:GetChildren()) do
                        if sackNames[item.Name] then
                            sackItem = item
                            break
                        end
                    end

                    local lostChild2 = Workspace.Characters:FindFirstChild("Lost Child2")
                    if lostChild2 and sackItem then
                        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                        local rightArm = lostChild2:FindFirstChild("Right Arm") or lostChild2.PrimaryPart
                        if rightArm then
                            humanoidRootPart.CFrame = rightArm.CFrame
                            task.wait(0.2)
                            RemoteEvents.RequestBagStoreItem:InvokeServer(sackItem, lostChild2)
                            task.wait(0.2)
                            humanoidRootPart.CFrame = CFrame.new(0, 8, 0)
                            task.wait(0.2)
                            RemoteEvents.EquipItemHandle:FireServer("FireAllClients", sackItem)
                            task.wait(0.3)
                            RemoteEvents.RequestBagDropItem:FireServer(sackItem, lostChild2)
                            unfly(hover)
                        end
                    end
                end

                repeat task.wait(0.2) until not _G.Settings.Quest["Auto Lost Child2 Quest"]
                unfly(hover)
            end
        end
    end)
end))
local Sec_QuestTab_3 = Tabs.QuestTab:AddSection("Lost Child 3")
local JailCellar3Label = Sec_QuestTab_3:AddParagraph({
    Title = "Jail Cellar 3 Status",
    Content = "Status : Waiting..."
})

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.2) do
        pcall(function()
            local jailCellar3 = workspace:FindFirstChild("Map")
                and workspace.Map:FindFirstChild("Landmarks")
                and workspace.Map.Landmarks:FindFirstChild("Jail Cellar3")

            if jailCellar3 then
                JailCellar3Label:SetDesc("Status : Map Spawned 🟢")
            else
                JailCellar3Label:SetDesc("Status : Not Spawned 🔴")
            end
        end)
    end
end))
Sec_QuestTab_3:AddToggle({
    Title = "Auto Lost Child 3",
    Desc = "Need Campfire Level 5",
    Default = _G.Settings.Quest["Auto Lost Child3 Quest"],
    Callback = function(value)
        _G.Settings.Quest["Auto Lost Child3 Quest"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
task.spawn(LPH_NO_VIRTUALIZE(function()
    pcall(function()
        local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        local player = Players.LocalPlayer
        local visitedTrees = {}
        local sackNames = {
            ["Old Sack"] = true,
            ["Good Sack"] = true,
            ["Giant Sack"] = true,
        }

        while true do
            task.wait(0.2)
            if _G.Settings.Quest["Auto Lost Child3 Quest"] then
                local hover = fly()
                local jailCellar
                local foliage = Workspace:WaitForChild("Map"):WaitForChild("Foliage")
                visitedTrees = {}
                while not jailCellar and _G.Settings.Quest["Auto Lost Child3 Quest"] do
                    for _, tree in pairs(foliage:GetChildren()) do
                        if not _G.Settings.Quest["Auto Lost Child3 Quest"] then
                            unfly(hover)
                            break
                        end
                        if tree:IsA("Model") and (tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and not visitedTrees[tree] then
                            visitedTrees[tree] = true
                            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            local base = tree:FindFirstChildWhichIsA("BasePart")
                            if root and base then
                                root.CFrame = base.CFrame + Vector3.new(0, 3, 0)
                            end
                            task.wait(1)
                            jailCellar = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Landmarks") and Workspace.Map.Landmarks:FindFirstChild("Jail Cellar3")
                            if jailCellar then break end
                        end
                    end
                    task.wait(1)
                end

                if jailCellar then
                    local jailCellar = Workspace.Map.Landmarks:WaitForChild("Jail Cellar3")
                    local keyInteraction = jailCellar.LockedDoor:WaitForChild("KeyInteraction")
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:WaitForChild("HumanoidRootPart")
                    root.CFrame = keyInteraction.CFrame + Vector3.new(0, 25, 0)
                    task.wait(5)
                    local keyItem
                    repeat
                        keyItem = nil
                        for _, item in ipairs(Workspace.Items:GetChildren()) do
                            if item:IsA("Model") and item.Name:find("Key") then
                                keyItem = item
                                break
                            end
                        end
                        task.wait(0.5)
                    until keyItem
                    RemoteEvents.RequestStartDraggingItem:FireServer(keyItem)
                    keyItem.PrimaryPart.CFrame = keyInteraction.CFrame
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.LockedDoor, true)
                    task.wait(0.3)
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.Door, true)
                    task.wait(0.3)
                    local inventory = player:WaitForChild("Inventory")
                    local itemBag = player:WaitForChild("ItemBag")

                    local sackItem
                    for _, item in ipairs(inventory:GetChildren()) do
                        if sackNames[item.Name] then
                            sackItem = item
                            break
                        end
                    end

                    local lostChild3 = Workspace.Characters:FindFirstChild("Lost Child3")
                    if lostChild3 and sackItem then
                        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                        local rightArm = lostChild3:FindFirstChild("Right Arm") or lostChild3.PrimaryPart
                        if rightArm then
                            humanoidRootPart.CFrame = rightArm.CFrame
                            task.wait(0.2)
                            RemoteEvents.RequestBagStoreItem:InvokeServer(sackItem, lostChild3)
                            task.wait(0.2)
                            humanoidRootPart.CFrame = CFrame.new(0, 8, 0)
                            task.wait(0.2)
                            RemoteEvents.EquipItemHandle:FireServer("FireAllClients", sackItem)
                            task.wait(0.3)
                            RemoteEvents.RequestBagDropItem:FireServer(sackItem, lostChild3)
                            unfly(hover)
                        end
                    end
                end

                repeat task.wait(0.2) until not _G.Settings.Quest["Auto Lost Child3 Quest"]
                unfly(hover)
            end
        end
    end)
end))
local Sec_QuestTab_4 = Tabs.QuestTab:AddSection("Lost Child 4")
local JailCellar4Label = Sec_QuestTab_4:AddParagraph({
    Title = "Jail Cellar 4 Status",
    Content = "Status : Waiting..."
})

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.2) do
        pcall(function()
            local jailCellar4 = workspace:FindFirstChild("Map")
                and workspace.Map:FindFirstChild("Landmarks")
                and workspace.Map.Landmarks:FindFirstChild("Jail Cellar4")

            if jailCellar4 then
                JailCellar4Label:SetDesc("Status : Map Spawned 🟢")
            else
                JailCellar4Label:SetDesc("Status : Not Spawned 🔴")
            end
        end)
    end
end))
Sec_QuestTab_4:AddToggle({
    Title = "Auto Lost Child 4",
    Desc = "Need Campfire Level 5",
    Default = _G.Settings.Quest["Auto Lost Child4 Quest"],
    Callback = function(value)
        _G.Settings.Quest["Auto Lost Child4 Quest"] = value
        if _G.Settings.AutoSave then
			SaveConfig()
		end
    end
})
task.spawn(function()
    pcall(function()
        local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        local player = Players.LocalPlayer
        local visitedTrees = {}

        local sackNames = {
            ["Old Sack"] = true,
            ["Good Sack"] = true,
            ["Giant Sack"] = true,
        }

        while true do
            task.wait(0.2)
            if _G.Settings.Quest["Auto Lost Child4 Quest"] then
                local hover = fly()
                local jailCellar
                local foliage = Workspace:WaitForChild("Map"):WaitForChild("Foliage")
                visitedTrees = {}
                while not jailCellar and _G.Settings.Quest["Auto Lost Child4 Quest"] do
                    for _, tree in pairs(foliage:GetChildren()) do
                        if not _G.Settings.Quest["Auto Lost Child4 Quest"] then
                            unfly(hover)
                            break
                        end
                        if tree:IsA("Model") and (tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and not visitedTrees[tree] then
                            visitedTrees[tree] = true
                            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            local base = tree:FindFirstChildWhichIsA("BasePart")
                            if root and base then
                                root.CFrame = base.CFrame + Vector3.new(0, 3, 0)
                            end
                            task.wait(1)
                            jailCellar = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Landmarks") and Workspace.Map.Landmarks:FindFirstChild("Jail Cellar4")
                            if jailCellar then break end
                        end
                    end
                    task.wait(1)
                end
                if jailCellar then
                    local jailCellar = Workspace.Map.Landmarks:WaitForChild("Jail Cellar4")
                    local keyInteraction = jailCellar.LockedDoor:WaitForChild("KeyInteraction")
                    local character = player.Character or player.CharacterAdded:Wait()
                    local root = character:WaitForChild("HumanoidRootPart")
                    root.CFrame = keyInteraction.CFrame + Vector3.new(0, 25, 0)
                    task.wait(5)
                    local keyItem
                    repeat
                        keyItem = nil
                        for _, item in ipairs(Workspace.Items:GetChildren()) do
                            if item:IsA("Model") and item.Name:find("Key") then
                                keyItem = item
                                break
                            end
                        end
                        task.wait(0.5)
                    until keyItem
                    RemoteEvents.RequestStartDraggingItem:FireServer(keyItem)
                    keyItem.PrimaryPart.CFrame = keyInteraction.CFrame
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.LockedDoor, true)
                    task.wait(0.3)
                    RemoteEvents.ToggleDoor:FireServer("FireAllClients", jailCellar.Door, true)
                    task.wait(0.3)

                    local inventory = player:WaitForChild("Inventory")
                    local itemBag = player:WaitForChild("ItemBag")

                    local sackItem
                    for _, item in ipairs(inventory:GetChildren()) do
                        if sackNames[item.Name] then
                            sackItem = item
                            break
                        end
                    end

                    local lostChild4 = Workspace.Characters:FindFirstChild("Lost Child4")
                    if lostChild4 and sackItem then
                        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                        local rightArm = lostChild4:FindFirstChild("Right Arm") or lostChild4.PrimaryPart
                        if rightArm then
                            humanoidRootPart.CFrame = rightArm.CFrame
                            task.wait(0.2)
                            RemoteEvents.RequestBagStoreItem:InvokeServer(sackItem, lostChild4)
                            task.wait(0.2)
                            humanoidRootPart.CFrame = CFrame.new(0, 8, 0)
                            task.wait(0.2)
                            RemoteEvents.EquipItemHandle:FireServer("FireAllClients", sackItem)
                            task.wait(0.3)
                            RemoteEvents.RequestBagDropItem:FireServer(sackItem, lostChild4)
                            unfly(hover)
                        end
                    end
                end
                repeat task.wait(0.2) until not _G.Settings.Quest["Auto Lost Child4 Quest"]
                unfly(hover)
            end
        end
    end)
end)
end

local Sec_MainTab_4 = Tabs.MainTab:AddSection("Fishing")
Sec_MainTab_4:AddParagraph({
    Title = "Announcement",
    Content = "If Rod Cast failed. Please perform a manual cast first."
})

Sec_MainTab_4:AddButton({
    Title = "Teleport to Fishing Area",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local targetPart = workspace:WaitForChild("Map"):WaitForChild("Landmarks"):WaitForChild("Fishing Hut")
                           :WaitForChild("Building"):WaitForChild("Door"):WaitForChild("Main")

        if hrp and targetPart then
            hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
})

Sec_MainTab_4:AddToggle({
    Title = "Auto Fishing",
    Default = false,
    Default = _G.AutoFishing,
    Callback = function(value)
        _G.AutoFishing = value
        if _G.Settings and _G.Settings.AutoSave then
            SaveConfig()
        end
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local waterFolder = workspace:WaitForChild("Map"):WaitForChild("Water")

function getNearestWater()
    local nearest, nearestDist = nil, math.huge
    for _, part in ipairs(waterFolder:GetChildren()) do
        if part:IsA("BasePart") then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = part
            end
        end
    end
    return nearest
end
function clickPartOnce(part)
    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
    if not onScreen then return end
    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
end

function getClient()
    local clientScript = player.PlayerScripts:FindFirstChild("Client")
    if not clientScript then return nil end
    local ok, result = pcall(require, clientScript)
    return ok and result or nil
end

local Client = getClient()

spawn(LPH_NO_VIRTUALIZE(function()
    while task.wait(0.5) do
        if _G.AutoFishing then
            pcall(function()
                local nearestWater = getNearestWater()
                if nearestWater then
                    clickPartOnce(nearestWater)
                end
                local frame
                repeat
                    frame = Client.Interface and Client.Interface.FishingCatchFrame
                    task.wait(0.1)
                until not _G.AutoFishing or (frame and frame.Visible)
                while _G.AutoFishing and frame and frame.Visible do
                    local successArea = frame.TimingBar.SuccessArea
                    local bar = frame.TimingBar.Bar
                    if successArea and bar then
                        local successY = successArea.AbsolutePosition.Y
                        local successH = successArea.AbsoluteSize.Y
                        local barY = bar.AbsolutePosition.Y
                        if barY >= successY and barY <= successY + successH then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            task.wait(0.05)
                        end
                    end
                    task.wait(0.05)
                end
                task.wait(0.5)
            end)
        end
    end
end))

if Hutan then
local Sec_MainTab_5 = Tabs.MainTab:AddSection("Taming Animal")

local TamingEnabled = false
local SelectedAnimal = ""

function GetAnimalList()
    local animals = {}
    local charactersFolder = Workspace:WaitForChild("Characters")
    local foundNames = {}
    
    for _, animal in pairs(charactersFolder:GetChildren()) do
        if animal:IsA("Model") and not foundNames[animal.Name] and not animal:FindFirstChild("NameLabel") then
            table.insert(animals, animal.Name)
            foundNames[animal.Name] = true
        end
    end
    
    return animals
end

function GetClosestAnimal(animalName)
    local closest = nil
    local shortestDistance = math.huge
    local playerPos = LocalPlayer.Character and LocalPlayer.Character:GetPivot().Position
    
    if not playerPos then return nil end
    
    for _, animal in pairs(Workspace.Characters:GetChildren()) do
        if animal.Name == animalName and animal:IsA("Model") and not animal:FindFirstChild("NameLabel") then
            local distance = (animal:GetPivot().Position - playerPos).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closest = animal
            end
        end
    end
    return closest
end

function GetRequiredFood(petName)
    local pet = GetClosestAnimal(petName)
    if pet then
        local food1 = pet:FindFirstChild("Head") and pet.Head:FindFirstChild("TamingHunger") and pet.Head.TamingHunger:FindFirstChild("Food1")
        if food1 and food1:FindFirstChild("TextLabel") then
            return food1.TextLabel.Text
        end
    end
    return nil
end

function BringFood(foodName)
    local foodItem = Workspace.Items:FindFirstChild(foodName)
    if foodItem then
        local args = {foodItem}
        ReplicatedStorage.RemoteEvents.RequestStartDraggingItem:FireServer(unpack(args))
        
        local pet = GetClosestAnimal(SelectedAnimal)
        if pet then
            foodItem:PivotTo(pet:GetPivot())
        end
    end
end

function AutoTame()
    while TamingEnabled do
        wait(1)
        
        if SelectedAnimal == "" then
            break
        end
        
        local pet = GetClosestAnimal(SelectedAnimal)
        if not pet then
            break
        end
        
        local flute = LocalPlayer.Inventory:FindFirstChild("Old Taming Flute")
        
        if pet and flute then
            local requiredFood = GetRequiredFood(SelectedAnimal)
            if requiredFood and requiredFood ~= "" then
                BringFood(requiredFood)
                wait(2)
            else
                local args = {pet, flute}
                ReplicatedStorage.RemoteEvents.RequestTame_Neutral:FireServer(unpack(args))
                wait(0.5)
                ReplicatedStorage.RemoteEvents.RequestTame_Hungry:FireServer(unpack(args))
            end
        end
    end
end

local Dropdown = Sec_MainTab_5:AddDropdown({
    Title = "Choose Animal",
    Options = GetAnimalList(),
    Default = "",
    Callback = function(option) 
        SelectedAnimal = option
    end
})

local Button = Sec_MainTab_5:AddButton({
    Title = "Refresh List",
    Locked = false,
    Callback = function()
        Dropdown:Refresh(GetAnimalList(), "")
        SelectedAnimal = ""
    end
})

local Toggle = Sec_MainTab_5:AddToggle({
    Title = "Auto Taming",
    Default = false,
    Callback = function(state) 
        TamingEnabled = state
        if state then
            AutoTame()
        end
    end
})
end
