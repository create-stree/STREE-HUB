local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local version = LRM_ScriptVersion and ("v" .. table.concat(LRM_ScriptVersion:split(""), ".")) or "1.0.0"

LocalPlayer.Idled:Connect(function()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end)

local okUi, uiSource = pcall(function()
	return game:HttpGet("https://raw.githubusercontent.com/Moonshall/ZyphraxHub/refs/heads/main/mainui.lua")
end)

if not okUi then
	warn("[ZyphraxHub] Failed to fetch UI library")
	return
end

local ZyphraxHub = loadstring(uiSource)()
if not ZyphraxHub then
	warn("[ZyphraxHub] Failed to initialize UI")
	return
end

local isMobile = table.find({ Enum.Platform.Android, Enum.Platform.IOS }, UserInputService:GetPlatform()) ~= nil
local windowSize = isMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(620, 370)

local Window = ZyphraxHub:CreateWindow({
	Title = "ZyphraxHub",
	Icon = "rbxassetid://125623993645104",
	 Author = (premium and "Premium" or "Violent District") .. " | " .. version,
	Folder = "ZyphraxHub_ViolentDistrict",
	Size = windowSize,
	LiveSearchDropdown = true,
	FileSaveName = "ZyphraxHub/violent_district.json",
})

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
local MainTab = Window:Tab({ Title = "Main", Icon = "swords" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "sparkles" })

Window:SelectTab(1)

local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
	warn("[ZyphraxHub] Remotes folder was not found")
	return
end

local equipItemRemote = Remotes:FindFirstChild("Shop") and Remotes.Shop:FindFirstChild("EquipItem")
local itemsFolder = Remotes:FindFirstChild("Items")
local daggerFolder = itemsFolder and itemsFolder:FindFirstChild("Parrying Dagger")
local daggerParryRemote = daggerFolder and daggerFolder:FindFirstChild("parry")
local repairEvent = Remotes:FindFirstChild("Generator") and Remotes.Generator:FindFirstChild("RepairEvent")
local healEvent = Remotes:FindFirstChild("Healing") and Remotes.Healing:FindFirstChild("HealEvent")
local flags = {
	autoParry = false,
	autoGenerator = false,
	autoHeal = false,
	playerEsp = false,
	eyePerkVisual = false,
	fullbright = false,
	noclip = false,
	fly = false,
	speedKiller = false,
	fastAttackKiller = false,
}

local cfg = {
	parryDistance = 14,
	parryEmergencyDistance = 8,
	generatorRange = 16,
	healInterval = 0.2,
	loopInterval = 0.1,
	espRange = 420,
	eyesVisualRange = 200,
	flySpeed = 65,
	speedMultiplier = 1.5,
	attackSpeedMultiplier = 1.5,
}

local lightingBackup = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	ExposureCompensation = Lighting.ExposureCompensation,
}

local espPool = {}
local mapVisualPool = {}
local lastMapVisualScan = 0
local parryLastTick = 0
local equipLastTick = 0
local activeGeneratorPart = nil
local activeGeneratorTick = 0
local flyVelocity = nil
local flyGyro = nil
local flyControl = {
	F = 0,
	B = 0,
	L = 0,
	R = 0,
	U = 0,
	D = 0,
}

local survivorDefaultColor = Color3.fromRGB(90, 255, 120)
local killerDefaultColor = Color3.fromRGB(255, 70, 70)

local function notify(title, text)
	pcall(function()
		ZyphraxHub:Notify({
			Title = title,
			Content = text,
			Icon = "info",
			Duration = 3,
		})
	end)
end

local function getRoot(character)
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
end

local function getHumanoid(character)
	if not character then
		return nil
	end
	return character:FindFirstChildOfClass("Humanoid")
end

local function getDistanceFromLocal(position)
	local localCharacter = LocalPlayer.Character
	local localRoot = getRoot(localCharacter)
	if not localRoot or not position then
		return math.huge
	end
	return (localRoot.Position - position).Magnitude
end

local function isKiller(player)
	if not player then
		return false
	end

	local teamName = player.Team and string.lower(player.Team.Name) or ""
	local playerName = string.lower(player.Name)

	if teamName:find("killer", 1, true) then
		return true
	end

	if playerName == "killer" or playerName:find("killer", 1, true) then
		return true
	end

	return false
end

local function isSurvivor(player)
	if not player or player == LocalPlayer then
		return false
	end

	if isKiller(player) then
		return false
	end

	local teamName = player.Team and string.lower(player.Team.Name) or ""
	if teamName ~= "" and teamName:find("survivor", 1, true) then
		return true
	end

	return true
end

local function safeFire(remote, ...)
	if not remote then
		return false
	end

	local ok = pcall(function(...)
		remote:FireServer(...)
	end, ...)

	return ok
end

local function equipDagger()
	if equipItemRemote then
		safeFire(equipItemRemote, "Parrying Dagger")
	end
end

local function hasDaggerEquipped()
	local character = LocalPlayer.Character
	if not character then
		return false
	end

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and string.lower(child.Name):find("dagger", 1, true) then
			return true
		end
	end

	return false
end

local function ensureDaggerEquipped()
	if hasDaggerEquipped() then
		return true
	end

	equipDagger()
	return false
end

local function getGeneratorCandidates()
	local candidates = {}

	for _, inst in ipairs(workspace:GetDescendants()) do
		if inst:IsA("BasePart") then
			local lowerName = string.lower(inst.Name)
			if lowerName:find("generator", 1, true) or lowerName:find("repair", 1, true) then
				table.insert(candidates, inst)
			end
		end
	end

	if getnilinstances then
		for _, inst in ipairs(getnilinstances()) do
			if inst:IsA("BasePart") then
				local lowerName = string.lower(inst.Name)
				if lowerName:find("generator", 1, true) then
					table.insert(candidates, inst)
				end
			end
		end
	end

	return candidates
end

local function getClosestGenerator()
	local localCharacter = LocalPlayer.Character
	local localRoot = getRoot(localCharacter)
	if not localRoot then
		return nil, math.huge
	end

	local best, bestDistance = nil, math.huge
	for _, candidate in ipairs(getGeneratorCandidates()) do
		local distance = (localRoot.Position - candidate.Position).Magnitude
		if distance < bestDistance then
			best = candidate
			bestDistance = distance
		end
	end

	return best, bestDistance
end

local function applyFullbright(state)
	if state then
		Lighting.Brightness = 2.2
		Lighting.ClockTime = 13.7
		Lighting.ExposureCompensation = 0.08
		Lighting.Ambient = Color3.fromRGB(165, 165, 165)
		Lighting.OutdoorAmbient = Color3.fromRGB(175, 175, 175)
	else
		Lighting.Brightness = lightingBackup.Brightness
		Lighting.ClockTime = lightingBackup.ClockTime
		Lighting.ExposureCompensation = lightingBackup.ExposureCompensation
		Lighting.Ambient = lightingBackup.Ambient
		Lighting.OutdoorAmbient = lightingBackup.OutdoorAmbient
	end
end

local function clearEspForPlayer(player)
	local object = espPool[player]
	if object and object.Parent then
		object:Destroy()
	end
	espPool[player] = nil
end

local function getEspColor(player)
	if isKiller(player) then
		return killerDefaultColor
	end
	return survivorDefaultColor
end

local function isAnimationAttackTrack(track)
	if not track then
		return false
	end

	local text = ""
	if track.Name then
		text = text .. string.lower(track.Name)
	end
	if track.Animation and track.Animation.AnimationId then
		text = text .. " " .. string.lower(track.Animation.AnimationId)
	end

	return text:find("attack", 1, true)
		or text:find("slash", 1, true)
		or text:find("hit", 1, true)
		or text:find("swing", 1, true)
		or text:find("lunge", 1, true)
		or text:find("stab", 1, true)
end

local function isKillerTryingToHit(killerCharacter, killerHumanoid, killerRoot, myRoot)
	if not killerCharacter or not killerHumanoid or not killerRoot or not myRoot then
		return false
	end

	for _, attributeName in ipairs({ "Attacking", "IsAttacking", "Swinging", "Lunging", "IsLunging" }) do
		if killerCharacter:GetAttribute(attributeName) == true then
			return true
		end
	end

	local animator = killerHumanoid:FindFirstChildOfClass("Animator")
	if animator then
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			if isAnimationAttackTrack(track) then
				return true
			end
		end
	end

	local velocity = killerRoot.AssemblyLinearVelocity
	local speed = velocity.Magnitude
	if speed >= 24 then
		local toLocal = (myRoot.Position - killerRoot.Position)
		if toLocal.Magnitude > 0 then
			local dir = velocity.Unit
			local towardLocal = dir:Dot(toLocal.Unit)
			if towardLocal > 0.55 then
				return true
			end
		end
	end

	return false
end

local function isKillerFacingLocal(killerRoot, myRoot)
	if not killerRoot or not myRoot then
		return false
	end

	local toLocal = myRoot.Position - killerRoot.Position
	if toLocal.Magnitude <= 0 then
		return false
	end

	local facingDot = killerRoot.CFrame.LookVector:Dot(toLocal.Unit)
	return facingDot > 0.5
end

local function tryParryKiller(killerCharacter, killerHumanoid, killerRoot, myRoot, distance)
	if not daggerParryRemote or not myRoot or not killerRoot then
		return false
	end

	if (tick() - parryLastTick) <= 0.1 then
		return false
	end

	local likelyAttack = isKillerTryingToHit(killerCharacter, killerHumanoid, killerRoot, myRoot)
	local emergencyParry = distance <= cfg.parryEmergencyDistance and isKillerFacingLocal(killerRoot, myRoot)
	if not likelyAttack and not emergencyParry then
		return false
	end

	ensureDaggerEquipped()
	safeFire(daggerParryRemote)
	parryLastTick = tick()
	return true
end

local function setActiveGenerator(part)
	if not part or not part:IsA("BasePart") then
		return
	end
	activeGeneratorPart = part
	activeGeneratorTick = tick()
end

local function getHookedSurvivor()
	for _, player in ipairs(Players:GetPlayers()) do
		if isSurvivor(player) then
			local character = player.Character
			local humanoid = getHumanoid(character)
			if character and humanoid and humanoid.Health > 0 then
				if character:GetAttribute("Hooked") == true or player:GetAttribute("Hooked") == true then
					return player
				end

				for _, obj in ipairs(character:GetDescendants()) do
					if obj:IsA("BoolValue") and string.lower(obj.Name):find("hook", 1, true) and obj.Value == true then
						return player
					end
				end

				for _, obj in ipairs(character:GetChildren()) do
					if string.lower(obj.Name):find("hook", 1, true) then
						return player
					end
				end
			end
		end
	end

	return nil
end

local function tryRescueNear(position)
	if not position then
		return false
	end

	local rescued = false
	for _, prompt in ipairs(workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") and prompt.Enabled then
			local promptPart = prompt.Parent
			if promptPart and promptPart:IsA("BasePart") then
				local promptName = string.lower(prompt.Name .. " " .. prompt.ObjectText .. " " .. prompt.ActionText)
				local distance = (promptPart.Position - position).Magnitude
				if distance <= 18 and (
					promptName:find("hook", 1, true)
					or promptName:find("rescue", 1, true)
					or promptName:find("save", 1, true)
					or promptName:find("unhook", 1, true)
				) then
					pcall(function()
						fireproximityprompt(prompt)
					end)
					rescued = true
				end
			end
		end
	end

	return rescued
end

local function rescueHookedSurvivorOnce()
	local targetPlayer = getHookedSurvivor()
	if not targetPlayer then
		notify("Hook Assist", "No hooked survivor found")
		return
	end

	local myRoot = getRoot(LocalPlayer.Character)
	local targetRoot = getRoot(targetPlayer.Character)
	if not myRoot or not targetRoot then
		notify("Hook Assist", "Target is not ready")
		return
	end

	local offset = targetRoot.CFrame.RightVector * 3
	myRoot.CFrame = CFrame.new(targetRoot.Position + offset, targetRoot.Position)

	task.wait(0.12)
	local okRescue = tryRescueNear(targetRoot.Position)
	if okRescue then
		notify("Hook Assist", "Teleported and attempted rescue")
	else
		notify("Hook Assist", "Teleported to hooked survivor")
	end
end

local function stopFly()
	local root = getRoot(LocalPlayer.Character)
	if flyVelocity then
		flyVelocity:Destroy()
		flyVelocity = nil
	end
	if flyGyro then
		flyGyro:Destroy()
		flyGyro = nil
	end
	if root then
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

local function startFly()
	local root = getRoot(LocalPlayer.Character)
	if not root then
		return
	end

	stopFly()

	flyVelocity = Instance.new("BodyVelocity")
	flyVelocity.MaxForce = Vector3.new(1e8, 1e8, 1e8)
	flyVelocity.Velocity = Vector3.zero
	flyVelocity.Parent = root

	flyGyro = Instance.new("BodyGyro")
	flyGyro.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
	flyGyro.P = 9e4
	flyGyro.CFrame = workspace.CurrentCamera.CFrame
	flyGyro.Parent = root
end

local function updateEspForPlayer(player)
	if player == LocalPlayer then
		clearEspForPlayer(player)
		return
	end

	if not flags.playerEsp then
		clearEspForPlayer(player)
		return
	end

	local character = player.Character
	local humanoid = getHumanoid(character)
	local root = getRoot(character)
	if not character or not humanoid or humanoid.Health <= 0 or not root then
		clearEspForPlayer(player)
		return
	end

	local distance = getDistanceFromLocal(root.Position)
	if distance > cfg.espRange then
		clearEspForPlayer(player)
		return
	end

	local highlight = espPool[player]
	if not highlight then
		highlight = Instance.new("Highlight")
		highlight.Name = "VD_EspHighlight"
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.FillTransparency = 0.74
		highlight.OutlineTransparency = 0.28
		highlight.Parent = character
		espPool[player] = highlight
	end

	highlight.Adornee = character
	highlight.FillColor = getEspColor(player)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
end

local function updateAllEsp()
	for _, player in ipairs(Players:GetPlayers()) do
		updateEspForPlayer(player)
	end
end

local function clearAllEsp()
	for player in pairs(espPool) do
		clearEspForPlayer(player)
	end
end

local function clearMapVisuals()
	for object in pairs(mapVisualPool) do
		if object and object.Parent then
			object:Destroy()
		end
		mapVisualPool[object] = nil
	end
end

local function getHighlightAdornee(part)
	if not part or not part:IsA("BasePart") then
		return nil
	end

	local model = part:FindFirstAncestorOfClass("Model")
	if model then
		return model
	end

	return part
end

local function getPromptText(prompt)
	if not prompt then
		return ""
	end
	return string.lower((prompt.Name or "") .. " " .. (prompt.ObjectText or "") .. " " .. (prompt.ActionText or ""))
end

local function getEyesTargetType(promptText, partName)
	local text = string.lower((promptText or "") .. " " .. (partName or ""))

	if text:find("pallet", 1, true) or text:find("slide", 1, true) then
		return "pallet"
	end

	if text:find("vault", 1, true) or text:find("window", 1, true) then
		return "vault"
	end

	return nil
end

local function triggerEyesOfHeavenVisual()
	if tick() - lastMapVisualScan < 1 then
		return
	end

	lastMapVisualScan = tick()
	clearMapVisuals()

	local localRoot = getRoot(LocalPlayer.Character)
	if not localRoot then
		return
	end

	for _, prompt in ipairs(workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") and prompt.Enabled then
			local part = prompt.Parent
			if part and part:IsA("BasePart") then
				local distance = (localRoot.Position - part.Position).Magnitude
				if distance <= cfg.eyesVisualRange then
					local promptText = getPromptText(prompt)
					local targetType = getEyesTargetType(promptText, part.Name)
					if targetType then
						local adornee = getHighlightAdornee(part)
						if adornee then
							local highlight = Instance.new("Highlight")
							highlight.Name = "VD_MapVisual"
							highlight.Adornee = adornee
							highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							highlight.FillTransparency = 0.8
							highlight.OutlineTransparency = 0.05
							highlight.FillColor = targetType == "vault" and Color3.fromRGB(255, 210, 90) or Color3.fromRGB(90, 180, 255)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							highlight.Parent = adornee
							mapVisualPool[highlight] = true
						end
					end
				end
			end
		end
	end
end

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
	if not prompt then
		return
	end

	local part = prompt.Parent
	if not part or not part:IsA("BasePart") then
		return
	end

	local text = string.lower(prompt.Name .. " " .. prompt.ObjectText .. " " .. prompt.ActionText .. " " .. part.Name)
	if text:find("generator", 1, true) or text:find("repair", 1, true) then
		setActiveGenerator(part)
	end
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt)
	if not prompt or not activeGeneratorPart then
		return
	end

	if prompt.Parent == activeGeneratorPart then
		activeGeneratorPart = nil
	end
end)

Players.PlayerRemoving:Connect(function(player)
	clearEspForPlayer(player)
end)

RunService.RenderStepped:Connect(function()
	if flags.playerEsp then
		updateAllEsp()
	end

	if flags.fly and flyVelocity and flyGyro then
		local root = getRoot(LocalPlayer.Character)
		local camera = workspace.CurrentCamera
		if not root or not camera then
			return
		end

		local look = camera.CFrame.LookVector
		local right = camera.CFrame.RightVector
		local up = Vector3.new(0, 1, 0)
		local moveVector = (look * (flyControl.F - flyControl.B)) + (right * (flyControl.R - flyControl.L)) + (up * (flyControl.U - flyControl.D))

		if moveVector.Magnitude > 0 then
			flyVelocity.Velocity = moveVector.Unit * cfg.flySpeed
		else
			flyVelocity.Velocity = Vector3.zero
		end

		flyGyro.CFrame = camera.CFrame
	end
end)

RunService.Stepped:Connect(function()
	if not flags.noclip then
		return
	end

	local character = LocalPlayer.Character
	if not character then
		return
	end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide then
			part.CanCollide = false
		end
	end
end)

RunService.Stepped:Connect(function()
	if not flags.speedKiller then
		return
	end

	local character = LocalPlayer.Character
	local humanoid = getHumanoid(character)
	if not character or not humanoid then
		return
	end

	if humanoid.WalkSpeed > 0 then
		humanoid.WalkSpeed = 16 * cfg.speedMultiplier
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.W then flyControl.F = 1 end
	if input.KeyCode == Enum.KeyCode.S then flyControl.B = 1 end
	if input.KeyCode == Enum.KeyCode.A then flyControl.L = 1 end
	if input.KeyCode == Enum.KeyCode.D then flyControl.R = 1 end
	if input.KeyCode == Enum.KeyCode.Space then flyControl.U = 1 end
	if input.KeyCode == Enum.KeyCode.LeftControl then flyControl.D = 1 end

	if input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonR2 then flyControl.U = 1 end
		if input.KeyCode == Enum.KeyCode.ButtonL2 then flyControl.D = 1 end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then flyControl.F = 0 end
	if input.KeyCode == Enum.KeyCode.S then flyControl.B = 0 end
	if input.KeyCode == Enum.KeyCode.A then flyControl.L = 0 end
	if input.KeyCode == Enum.KeyCode.D then flyControl.R = 0 end
	if input.KeyCode == Enum.KeyCode.Space then flyControl.U = 0 end
	if input.KeyCode == Enum.KeyCode.LeftControl then flyControl.D = 0 end

	if input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonR2 then flyControl.U = 0 end
		if input.KeyCode == Enum.KeyCode.ButtonL2 then flyControl.D = 0 end
	end
end)

task.spawn(function()
	while task.wait(cfg.loopInterval) do
		if flags.autoParry then
			if tick() - equipLastTick > 0.35 then
				ensureDaggerEquipped()
				equipLastTick = tick()
			end

			local myCharacter = LocalPlayer.Character
			local myRoot = getRoot(myCharacter)
			if myRoot and daggerParryRemote then
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and isKiller(player) then
						local enemyCharacter = player.Character
						local enemyHumanoid = getHumanoid(enemyCharacter)
						local enemyRoot = getRoot(enemyCharacter)
						if enemyHumanoid and enemyHumanoid.Health > 0 and enemyRoot then
							local distance = (myRoot.Position - enemyRoot.Position).Magnitude
							if distance <= cfg.parryDistance then
								local didParry = tryParryKiller(enemyCharacter, enemyHumanoid, enemyRoot, myRoot, distance)
								if didParry then
									break
								end
							end
						end
					end
				end
			end
		end

		if flags.autoGenerator and repairEvent then
			if activeGeneratorPart and (tick() - activeGeneratorTick) > 3 then
				activeGeneratorPart = nil
			end

			local localRoot = getRoot(LocalPlayer.Character)
			if activeGeneratorPart and localRoot then
				local distance = (localRoot.Position - activeGeneratorPart.Position).Magnitude
				if distance <= cfg.generatorRange then
					safeFire(repairEvent, activeGeneratorPart, true)
				end
			elseif UserInputService:IsKeyDown(Enum.KeyCode.E) then
				local nearestGenerator, distance = getClosestGenerator()
				if nearestGenerator and distance <= cfg.generatorRange then
					setActiveGenerator(nearestGenerator)
					safeFire(repairEvent, nearestGenerator, true)
				end
			end

			if activeGeneratorPart then
				local localRoot2 = getRoot(LocalPlayer.Character)
				if localRoot2 and (localRoot2.Position - activeGeneratorPart.Position).Magnitude > (cfg.generatorRange + 10) then
					activeGeneratorPart = nil
				end
			end

			if activeGeneratorPart and not activeGeneratorPart.Parent then
				activeGeneratorPart = nil
			end
		end

		if flags.fly then
			local root = getRoot(LocalPlayer.Character)
			if (not flyVelocity or not flyGyro) and root then
				startFly()
			end
		else
			if flyVelocity or flyGyro then
				stopFly()
			end
		end

		if not flags.playerEsp then
			clearAllEsp()
		end
	end
end)

task.spawn(function()
	while task.wait(cfg.healInterval) do
		if flags.autoHeal and healEvent then
			for _, player in ipairs(Players:GetPlayers()) do
				if isSurvivor(player) then
					local character = player.Character
					local humanoid = getHumanoid(character)
					local root = getRoot(character)
					if humanoid and root and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
						safeFire(healEvent, root, true)
					end
				end
			end
		end
	end
end)

task.spawn(function()
	while task.wait(2) do
		if flags.eyePerkVisual then
			triggerEyesOfHeavenVisual()
		end
	end
end)

-- Info Tab
InfoTab:Section({ Title = "Information" })
InfoTab:Paragraph({
	Title = "ZyphraxHub",
	Desc = "Premium farming automation script\nVersion: " .. version,
})

InfoTab:Section({ Title = "Community" })
InfoTab:Button({
	Title = "Join Our Discord",
	Callback = function()
		if setclipboard then
			setclipboard("https://discord.gg/kCReeEVCWw")
			game.StarterGui:SetCore("SendNotification", {
				Title = "Copied!",
				Text = "Discord link copied to clipboard",
				Duration = 3,
			})
		else
			notify("Clipboard", "setclipboard is not available in this executor")
		end
	end,
})

MainTab:Section({ Title = "Combat" })
MainTab:Toggle({
	Title = "Auto Parry Killer (Dagger)",
	Default = false,
	Callback = function(state)
		flags.autoParry = state
		if state then
			ensureDaggerEquipped()
			notify("Auto Parry", "Enabled")
		else
			notify("Auto Parry", "Disabled")
		end
	end,
})

MainTab:Paragraph({
	Title = "Requirement",
	Desc = "Requires Special Item: Parrying Dagger. Auto Parry only works while the dagger is equipped.",
})

MainTab:Toggle({
	Title = "Speed Killer",
	Default = false,
	Callback = function(state)
		flags.speedKiller = state
		if state then
			local humanoid = getHumanoid(LocalPlayer.Character)
			if humanoid then
				humanoid.WalkSpeed = 16 * cfg.speedMultiplier
			end
			notify("Speed Killer", "Enabled")
		else
			local humanoid = getHumanoid(LocalPlayer.Character)
			if humanoid then
				humanoid.WalkSpeed = 16
			end
			notify("Speed Killer", "Disabled")
		end
	end,
})

MainTab:Slider({
	Title = "Speed Multiplier",
	Step = 0.1,
	Value = {
		Min = 1.0,
		Max = 3.0,
		Default = cfg.speedMultiplier,
	},
	Callback = function(value)
		cfg.speedMultiplier = value
		if flags.speedKiller then
			local humanoid = getHumanoid(LocalPlayer.Character)
			if humanoid then
				humanoid.WalkSpeed = 16 * cfg.speedMultiplier
			end
		end
	end,
})

MainTab:Toggle({
	Title = "Fast Attack Killer",
	Default = false,
	Callback = function(state)
		flags.fastAttackKiller = state
		if state then
			notify("Fast Attack Killer", "Enabled - Anti Cooldown Active")
		else
			notify("Fast Attack Killer", "Disabled")
		end
	end,
})

MainTab:Slider({
	Title = "Attack Speed Multiplier",
	Step = 0.1,
	Value = {
		Min = 1.0,
		Max = 3.0,
		Default = cfg.attackSpeedMultiplier,
	},
	Callback = function(value)
		cfg.attackSpeedMultiplier = value
	end,
})

MainTab:Slider({
	Title = "Parry Distance",
	Step = 1,
	Value = {
		Min = 6,
		Max = 30,
		Default = cfg.parryDistance,
	},
	Callback = function(value)
		cfg.parryDistance = value
	end,
})

MainTab:Section({ Title = "Generator" })
MainTab:Toggle({
	Title = "Auto Generator Minigame",
	Default = false,
	Callback = function(state)
		flags.autoGenerator = state
		if not state then
			activeGeneratorPart = nil
		end
		notify("Auto Generator", state and "Enabled" or "Disabled")
	end,
})

MainTab:Slider({
	Title = "Generator Trigger Range",
	Step = 1,
	Value = {
		Min = 8,
		Max = 40,
		Default = cfg.generatorRange,
	},
	Callback = function(value)
		cfg.generatorRange = value
	end,
})

MainTab:Section({ Title = "Support" })
MainTab:Button({
	Title = "Auto Help Hook",
	Callback = function()
		rescueHookedSurvivorOnce()
	end,
})

MainTab:Toggle({
	Title = "Auto Full Heal Survivors",
	Default = false,
	Callback = function(state)
		flags.autoHeal = state
		notify("Auto Heal", state and "Enabled" or "Disabled")
	end,
})

MainTab:Slider({
	Title = "Heal Tick (seconds)",
	Step = 0.05,
	Value = {
		Min = 0.1,
		Max = 1,
		Default = cfg.healInterval,
	},
	Callback = function(value)
		cfg.healInterval = value
	end,
})

MiscTab:Section({ Title = "Player ESP" })
MiscTab:Toggle({
	Title = "ESP Survivor/Killer",
	Default = false,
	Callback = function(state)
		flags.playerEsp = state
		if not state then
			clearAllEsp()
		end
		notify("Player ESP", state and "Enabled" or "Disabled")
	end,
})

MiscTab:Slider({
	Title = "ESP Max Distance",
	Step = 10,
	Value = {
		Min = 100,
		Max = 1000,
		Default = cfg.espRange,
	},
	Callback = function(value)
		cfg.espRange = value
	end,
})

MiscTab:Section({ Title = "Map Visual" })
MiscTab:Toggle({
	Title = "Eyes of Heaven Visual (Nearby Pallet/Vault)",
	Default = false,
	Callback = function(state)
		flags.eyePerkVisual = state
		if not state then
			clearMapVisuals()
		end
		if state then
			triggerEyesOfHeavenVisual()
		end
		notify("Eyes of Heaven", state and "Enabled" or "Disabled")
	end,
})

MiscTab:Slider({
	Title = "Eyes Visual Range",
	Step = 10,
	Value = {
		Min = 80,
		Max = 450,
		Default = cfg.eyesVisualRange,
	},
	Callback = function(value)
		cfg.eyesVisualRange = value
	end,
})

MiscTab:Toggle({
	Title = "Soft Fullbright",
	Default = false,
	Callback = function(state)
		flags.fullbright = state
		applyFullbright(state)
		notify("Fullbright", state and "Enabled" or "Disabled")
	end,
})

MiscTab:Section({ Title = "Movement" })
MiscTab:Toggle({
	Title = "No Clip",
	Default = false,
	Callback = function(state)
		flags.noclip = state
		notify("No Clip", state and "Enabled" or "Disabled")
	end,
})

MiscTab:Toggle({
	Title = "Fly",
	Default = false,
	Callback = function(state)
		flags.fly = state
		if state then
			startFly()
		else
			stopFly()
		end
		notify("Fly", state and "Enabled" or "Disabled")
	end,
})

MiscTab:Slider({
	Title = "Fly Speed",
	Step = 1,
	Value = {
		Min = 25,
		Max = 150,
		Default = cfg.flySpeed,
	},
	Callback = function(value)
		cfg.flySpeed = value
	end,
})

notify("Violent District", "Module loaded successfully")
