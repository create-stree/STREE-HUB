-- Forge main script
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Knit = require(Shared:WaitForChild("Packages").Knit)
local Utils = require(Shared:WaitForChild("Utils"))
local Ore = require(Shared:WaitForChild("Data"):WaitForChild("Ore"))

local function getCharacter()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoidRootPart()
	local char = getCharacter()
	return char:WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
	local char = getCharacter()
	return char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "The Forge Auto Farm V1.0",
	LoadingTitle = "The Forge Automation V1.0",
	LoadingSubtitle = "By Nisulrocks",
	ShowText = "The Forge",
	ToggleUIKeybind = "K",
    Discord = {
      Enabled = true,
      Invite = "wN85KUq6nD",
      RememberJoins = true 
    },
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "TheForgeNisulrocks",
		FileName = "TheForgeConfig_V2"
	}
})

local MainFarmTab = Window:CreateTab("Main Farm", 4483362458)

--[[ TAMBAHAN BARU: AUTO FARM ORC ]]--
local OrcFarmTab = Window:CreateTab("Auto Farm Orc", 4483362458) -- Tab baru untuk Auto Farm Orc

local orcFarm = {
	enabled = false,
	selectedOrc = "Orc Warrior", -- Default orc
	attackInterval = 0.1,
	safeHealthPercent = 30,
	orcESPEnabled = false,
	scanDistance = 500,
	tweenSpeed = 100,
}

-- Build orc dropdown options
local function buildOrcOptions()
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local mobsFolder = assets and assets:FindFirstChild("Mobs")
	local options = {}
	if mobsFolder then
		for _, mob in ipairs(mobsFolder:GetChildren()) do
			local name = mob.Name
			-- Filter hanya orc (nama mengandung "Orc" atau "orc")
			if name and (string.find(string.lower(name), "orc") or string.find(name, "Orc")) then
				table.insert(options, name)
			end
		end
	end
	table.sort(options)
	if #options == 0 then
		table.insert(options, "Orc Warrior") -- Default fallback
	end
	return options
end

local orcOptions = buildOrcOptions()
if not orcFarm.selectedOrc or orcFarm.selectedOrc == "" then
	orcFarm.selectedOrc = orcOptions[1] or "Orc Warrior"
end

-- Section untuk Auto Farm Orc
local OrcFarmSection = OrcFarmTab:CreateSection("Orc Farm Settings")

OrcFarmTab:CreateDropdown({
	Name = "Select Orc Type",
	Options = orcOptions,
	CurrentOption = orcFarm.selectedOrc,
	MultipleOptions = false,
	Flag = "OrcFarm_Type",
	Callback = function(opts)
		local v = type(opts) == "table" and opts[1] or opts
		if v then
			orcFarm.selectedOrc = v
		end
	end,
})

OrcFarmTab:CreateSlider({
	Name = "Scan Distance",
	Range = { 100, 1000 },
	Increment = 50,
	CurrentValue = orcFarm.scanDistance,
	Flag = "OrcFarm_ScanDistance",
	Callback = function(value)
		orcFarm.scanDistance = value
	end,
})

OrcFarmTab:CreateSlider({
	Name = "Tween Speed",
	Range = { 50, 200 },
	Increment = 10,
	CurrentValue = orcFarm.tweenSpeed,
	Flag = "OrcFarm_TweenSpeed",
	Callback = function(value)
		orcFarm.tweenSpeed = value
	end,
})

OrcFarmTab:CreateSlider({
	Name = "Attack Interval (s)",
	Range = { 0.05, 1 },
	Increment = 0.05,
	CurrentValue = orcFarm.attackInterval,
	Flag = "OrcFarm_AttackInterval",
	Callback = function(value)
		orcFarm.attackInterval = value
	end,
})

OrcFarmTab:CreateSlider({
	Name = "Safe HP % (Retreat)",
	Range = { 10, 80 },
	Increment = 5,
	CurrentValue = orcFarm.safeHealthPercent,
	Flag = "OrcFarm_SafeHP",
	Callback = function(value)
		orcFarm.safeHealthPercent = value
	end,
})

-- Helper functions untuk Orc Farm
local function normalizeOrcName(name)
	return tostring(name):gsub("%d+$", "")
end

local function collectOrcs()
	local living = workspace:FindFirstChild("Living")
	local result = {}
	if not living then return result end
	
	for _, model in ipairs(living:GetChildren()) do
		if model:IsA("Model") then
			local baseName = normalizeOrcName(model.Name)
			-- Cek apakah ini orc (case insensitive)
			if string.find(string.lower(baseName), "orc") then
				-- Skip dead mobs
				local deadFlag = model:FindFirstChild("Dead", true)
				if deadFlag and deadFlag:IsA("BoolValue") and deadFlag.Value == true then
					continue
				end
				
				local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("HRP")
				if hrp and hrp:IsA("BasePart") then
					table.insert(result, {
						model = model,
						hrp = hrp,
						orcType = baseName,
						actualName = model.Name
					})
				end
			end
		end
	end
	return result
end

local function getNearestOrc()
	local orcs = collectOrcs()
	if #orcs == 0 then return nil end
	
	local hrp = getHumanoidRootPart()
	if not hrp then return nil end
	
	local best
	local bestDist = math.huge
	local targetOrcType = orcFarm.selectedOrc
	
	for _, info in ipairs(orcs) do
		-- Filter berdasarkan tipe orc yang dipilih
		if info.orcType == targetOrcType or info.actualName == targetOrcType then
			local dist = (info.hrp.Position - hrp.Position).Magnitude
			if dist <= orcFarm.scanDistance and dist < bestDist then
				bestDist = dist
				best = info
			end
		end
	end
	
	return best
end

local function isLowHealthForOrcFarm()
	local hum = getHumanoid()
	if not hum or hum.MaxHealth <= 0 then return false end
	local hpPercent = (hum.Health / hum.MaxHealth) * 100
	local threshold = tonumber(orcFarm.safeHealthPercent) or 30
	return hpPercent <= threshold
end

local function retreatToSafetyOrc()
	local hum = getHumanoid()
	local hrp = getHumanoidRootPart()
	if not hum or not hrp then return end

	local startPos = hrp.Position
	local safeHeight = 50
	local safePos = startPos + Vector3.new(0, safeHeight, 0)

	local previousAnchored = hrp.Anchored
	local previousPlatformStand = hum.PlatformStand

	pcall(function()
		-- Tween ke posisi aman
		local distance = (safePos - hrp.Position).Magnitude
		local time = math.max(0.5, distance / math.max(10, orcFarm.tweenSpeed))
		local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {
			CFrame = CFrame.new(safePos)
		})
		tween:Play()
		tween.Completed:Wait()
		
		hrp.Anchored = true
		hum.PlatformStand = true
		hrp.CFrame = CFrame.new(safePos)
	end)

	local targetPercent = (tonumber(orcFarm.safeHealthPercent) or 30) + 20
	if targetPercent > 100 then targetPercent = 100 end

	while orcFarm.enabled and hum.Health > 0 and hum.MaxHealth > 0 do
		local hpPercent = (hum.Health / hum.MaxHealth) * 100
		if hpPercent >= targetPercent then
			break
		end
		wait(0.5)
	end

	if not orcFarm.enabled or hum.Health <= 0 or hum.MaxHealth <= 0 then
		hrp.Anchored = previousAnchored
		hum.PlatformStand = previousPlatformStand
		return
	end

	hrp.Anchored = previousAnchored
	hum.PlatformStand = previousPlatformStand

	-- Kembali ke posisi awal
	local returnPos = startPos + Vector3.new(0, 5, 0)
	pcall(function()
		local distance = (returnPos - hrp.Position).Magnitude
		local time = math.max(0.5, distance / math.max(10, orcFarm.tweenSpeed))
		local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {
			CFrame = CFrame.new(returnPos)
		})
		tween:Play()
		tween.Completed:Wait()
	end)
end

local function ensureWeaponEquippedOrc()
	local char = getCharacter()
	local hum = getHumanoid()
	
	-- Cari weapon yang sudah equipped
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name == "Weapon" or string.find(string.lower(tool.Name), "weapon")) then
			return tool
		end
	end
	
	-- Cari di backpack
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not backpack then return nil end
	
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name == "Weapon" or string.find(string.lower(tool.Name), "weapon")) then
			pcall(function()
				if hum then
					hum:EquipTool(tool)
				else
					tool.Parent = char
				end
			end)
			task.wait(0.1)
			return tool
		end
	end
	
	return nil
end

local function attackOrc(orcInfo)
	if not orcInfo or not orcInfo.model or not orcInfo.model.Parent then return end
	
	local toolServiceRF = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF")
	local toolActivated = toolServiceRF:WaitForChild("ToolActivated")
	
	pcall(function()
		toolActivated:InvokeServer("Weapon")
	end)
end

-- ESP untuk Orc
local orcEspObjects = {}

local function clearOrcESP()
	for _, data in pairs(orcEspObjects) do
		if data.highlight then pcall(function() data.highlight:Destroy() end) end
		if data.billboard then pcall(function() data.billboard:Destroy() end) end
		if data.beam then pcall(function() data.beam:Destroy() end) end
		if data.attachment then pcall(function() data.attachment:Destroy() end) end
	end
	table.clear(orcEspObjects)
end

local function ensureESPForOrc(orcInfo)
	local model = orcInfo.model
	if not model or not model.Parent then return end
	if orcEspObjects[model] then return end
	
	local hrp = orcInfo.hrp
	if not (hrp and hrp:IsA("BasePart")) then return end
	
	-- Highlight
	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255, 165, 0) -- Orange untuk orc
	highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
	highlight.FillTransparency = 0.3
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = model
	highlight.Parent = workspace
	
	-- Beam effect
	local attachment0 = Instance.new("Attachment")
	attachment0.Parent = hrp
	attachment0.Position = Vector3.new(0, 2, 0)
	
	local attachment1 = Instance.new("Attachment")
	attachment1.Parent = hrp
	attachment1.Position = Vector3.new(0, 15, 0)
	
	local beam = Instance.new("Beam")
	beam.Attachment0 = attachment0
	beam.Attachment1 = attachment1
	beam.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
	beam.Transparency = NumberSequence.new(0.5)
	beam.Width0 = 0.5
	beam.Width1 = 1
	beam.FaceCamera = true
	beam.Parent = hrp
	
	-- Billboard GUI
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 120, 0, 40)
	billboard.Adornee = hrp
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 800
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.Parent = model
	
	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	bg.BackgroundTransparency = 0.4
	bg.BorderSizePixel = 0
	bg.Parent = billboard
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 6)
	uiCorner.Parent = bg
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0.6, 0)
	label.Position = UDim2.new(0, 5, 0, 5)
	label.BackgroundTransparency = 1
	label.Text = "⚔️ " .. orcInfo.orcType
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = bg
	
	local distLabel = Instance.new("TextLabel")
	distLabel.Size = UDim2.new(1, -10, 0.4, 0)
	distLabel.Position = UDim2.new(0, 5, 0.6, 0)
	distLabel.BackgroundTransparency = 1
	distLabel.Text = "..."
	distLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
	distLabel.TextScaled = true
	distLabel.Font = Enum.Font.Gotham
	distLabel.Parent = bg
	
	orcEspObjects[model] = {
		highlight = highlight,
		billboard = billboard,
		beam = beam,
		attachment = attachment0,
		distLabel = distLabel,
		hrp = hrp,
	}
end

local function updateOrcESP()
	if not orcFarm.orcESPEnabled then
		clearOrcESP()
		return
	end
	
	local orcs = collectOrcs()
	local hrp = getHumanoidRootPart()
	
	for _, orcInfo in ipairs(orcs) do
		-- Filter berdasarkan orc yang dipilih
		if orcInfo.orcType == orcFarm.selectedOrc or orcInfo.actualName == orcFarm.selectedOrc then
			ensureESPForOrc(orcInfo)
		end
	end
	
	-- Update distances
	if hrp then
		for model, data in pairs(orcEspObjects) do
			if data.distLabel and data.hrp and data.hrp.Parent then
				local dist = (data.hrp.Position - hrp.Position).Magnitude
				data.distLabel.Text = string.format("%.0f studs", dist)
			end
		end
	end
end

-- Toggle untuk Orc ESP
OrcFarmTab:CreateToggle({
	Name = "Orc ESP",
	CurrentValue = false,
	Flag = "OrcFarm_ESP",
	Callback = function(v)
		orcFarm.orcESPEnabled = v
		if not v then
			clearOrcESP()
		else
			updateOrcESP()
		end
	end,
})

-- Toggle utama Auto Farm Orc
OrcFarmTab:CreateToggle({
	Name = "Enable Auto Farm Orc",
	CurrentValue = false,
	Flag = "OrcFarm_Enable",
	Callback = function(v)
		orcFarm.enabled = v
		if not orcFarm.enabled then return end
		
		task.spawn(function()
			while orcFarm.enabled do
				-- Cek HP rendah
				if isLowHealthForOrcFarm() then
					retreatToSafetyOrc()
					continue
				end
				
				-- Pastikan weapon equipped
				local weapon = ensureWeaponEquippedOrc()
				if not weapon then
					wait(0.5)
					continue
				end
				
				-- Cari orc terdekat
				local target = getNearestOrc()
				if not target then
					wait(1)
					continue
				end
				
				-- Tween ke orc
				local targetPos = target.hrp.Position
				local hrp = getHumanoidRootPart()
				if hrp and (targetPos - hrp.Position).Magnitude > 10 then
					pcall(function()
						local distance = (targetPos - hrp.Position).Magnitude
						local time = math.max(0.5, distance / math.max(10, orcFarm.tweenSpeed))
						local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {
							CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
						})
						tween:Play()
						tween.Completed:Wait()
					end)
				end
				
				-- Attack orc
				attackOrc(target)
				
				-- Tunggu interval
				wait(orcFarm.attackInterval)
			end
		end)
	end,
})

-- Status display untuk Orc Farm
local OrcStatusParagraph = OrcFarmTab:CreateParagraph({
	Title = "Orc Farm Status",
	Content = "Idle",
})

local function setOrcStatus(text)
	if OrcStatusParagraph then
		OrcStatusParagraph:Set({
			Title = "Orc Farm Status",
			Content = text,
		})
	end
end

-- Loop untuk update ESP dan status
task.spawn(function()
	while true do
		if orcFarm.orcESPEnabled then
			updateOrcESP()
		end
		
		-- Update status
		if orcFarm.enabled then
			local target = getNearestOrc()
			if target then
				local hrp = getHumanoidRootPart()
				if hrp then
					local dist = (target.hrp.Position - hrp.Position).Magnitude
					setOrcStatus(string.format("Farming %s\nDistance: %.0f studs", orcFarm.selectedOrc, dist))
				else
					setOrcStatus(string.format("Farming %s", orcFarm.selectedOrc))
				end
			else
				setOrcStatus(string.format("Searching for %s...", orcFarm.selectedOrc))
			end
		else
			setOrcStatus("Idle")
		end
		
		wait(0.5)
	end
end)

--[[ END OF TAMBAHAN AUTO FARM ORC ]]--

-- Kode asli yang sudah ada (Main Farm Tab, Auto Forge Tab, dll) tetap di sini...
-- [KODE ASLI LANJUTAN DARI FILE out.lua.txt]

-- ... (sisa kode dari file asli tetap di sini tanpa perubahan)

end)
