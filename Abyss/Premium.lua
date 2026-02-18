local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Knit = ReplicatedStorage:WaitForChild("common"):WaitForChild("packages"):WaitForChild("Knit"):WaitForChild("Services")
local KnitServices = {
	BackpackService = Knit:WaitForChild("BackpackService"),
	MinigameService = Knit:WaitForChild("MinigameService"),
	HarpoonService = Knit:WaitForChild("HarpoonService"),
	FishService = Knit:WaitForChild("FishService"),
	SellService = Knit:WaitForChild("SellService"),
	PurchaseService = Knit:WaitForChild("PurchaseService"),
	RaceService = Knit:WaitForChild("RaceService"),
	InventoryService = Knit:WaitForChild("InventoryService"),
}

local KnitCtrl = require(ReplicatedStorage.common.packages.Knit)
local FishController = KnitCtrl.GetController("FishController")
local Replica = KnitCtrl.GetController("DataController"):GetReplica()
task.wait(1)

local Remotes = {
	Equip = KnitServices.BackpackService:WaitForChild("RF"):WaitForChild("Equip"),
	Favorite = KnitServices.BackpackService:WaitForChild("RF"):WaitForChild("Favorite"),
	UpdateMinigame = KnitServices.MinigameService:WaitForChild("RF"):WaitForChild("Update"),
	CancelMinigame = KnitServices.MinigameService:WaitForChild("RF"):WaitForChild("CancelMinigame"),
	StartCatching = KnitServices.HarpoonService:WaitForChild("RF"):WaitForChild("StartCatching"),
	CollectFish = KnitServices.FishService:WaitForChild("RF"):WaitForChild("CollectFish"),
	SellInventory = KnitServices.SellService:WaitForChild("RF"):WaitForChild("SellInventory"),
	BuyItem = KnitServices.PurchaseService:WaitForChild("RF"):WaitForChild("BuyItem"),
	Reroll = KnitServices.RaceService:WaitForChild("RF"):WaitForChild("Reroll"),
	EquipItem = KnitServices.InventoryService:WaitForChild("RF"):WaitForChild("EquipItem"),
	UnlockChest = Knit:WaitForChild("ChestService"):WaitForChild("RF"):WaitForChild("UnlockChest"),
	CancelMinigame = KnitServices.MinigameService:WaitForChild("RF"):WaitForChild("CancelMinigame"),
}

local CM = require(ReplicatedStorage.common.lib.modules.CatchingMinigame)
local _new = CM.new
CM.new = function(c, cfg)
	local i = _new(c, cfg)
	i.controlBarScale = 5
	i.progressGravity = 0
	return i
end

local Assets = {
	Fish = ReplicatedStorage.common.assets.fish,
}

local FishList = (function()
	local names = {}
	for _, v in ipairs(Assets.Fish:GetChildren()) do
		if v.Name ~= "fish_loot" then
			if v:IsA("Model") then
				table.insert(names, v.Name)
			elseif v:IsA("Folder") then
				for _, m in ipairs(v:GetChildren()) do
					if m:IsA("Model") then table.insert(names, m.Name) end
				end
			end
		end
	end
	table.sort(names, function(a, b) return a:lower() < b:lower() end)
	return names
end)()



local MutationList = (function()
	local names = {}
	for _, m in ipairs(ReplicatedStorage.common.presets.fish.mutations:GetChildren()) do
		table.insert(names, m.Name)
	end
	table.sort(names)
	return names
end)()

local RarityModule = require(ReplicatedStorage.common.presets.rarity)

local RarityList = (function()
	local names = {}
	for name in pairs(RarityModule) do
		table.insert(names, name)
	end
	table.sort(names, function(a, b) return RarityModule[a].index < RarityModule[b].index end)
	return names
end)()

local _rarityCache = {}
local function getFishRarity(name)
	if _rarityCache[name] then return _rarityCache[name] end
	for _, folder in ipairs(ReplicatedStorage.common.presets.items.fish:GetChildren()) do
		local m = folder:FindFirstChild(name)
		if m then
			_rarityCache[name] = require(m).rarity
			return _rarityCache[name]
		end
	end
end

local LocFarm = {
	["Ancient Sands"] = CFrame.new(-1466, 4567, 60),
	["Forgotten Deep"] = CFrame.new(-471, 4855, -212),
	["Spirit Roots"] = CFrame.new(1697, 4183, -1885),
}

local LocIsland = {
	["Ancient Sands"] = CFrame.new(-1816.78296, 4407.16748, 186.031281, 0.999990165, 4.3731248e-08, -0.00444009714, -4.37342358e-08, 1, -5.75861858e-10, 0.00444009714, 7.70040476e-10, 0.999990165),
	["Forgotten Deep"] = CFrame.new(-76.0209732, 4882.86279, -8.5775671, 0.148726657, 0, -0.988878369, 0, 1, 0, 0.988878369, 0, 0.148726657),
	["Spirit Roots"] = CFrame.new(1611.78833, 4030.64551, -1871.85132, 1, 1.04574973e-07, -2.62624259e-16, -1.04574973e-07, 1, -1.28840461e-09, 1.27889389e-16, 1.28840461e-09, 1),
}

local OxygenCordinat = {
	CFrame.new(120, 4883, 15),
	CFrame.new(-3, 4883, 122),
	CFrame.new(-124, 4883, -10),
	CFrame.new(-4, 4883, -125),
}

local SellCordinat = {
	CFrame.new(120, 4883, 15),
	CFrame.new(-3, 4883, 122),
	CFrame.new(-124, 4883, -10),
	CFrame.new(-4, 4883, -125),
}

local st = {
	SelectedMutations = {},
	SelectRarity = {},
	TweenTime = 0.3,
	MaxRange = 25,
	IsUnfavoriting = false,
	Monitor = nil,
	MonitorConns = {},
	WebhookURL = "",
	WebhookRarity = {},
	WebhookRunning = false,
	WebhookStatsURL = "",
	WebhookStatsEnabled = false,
	WebhookStatsMessageId = nil,
	ESPEnabled = false,
	ESPFilterRarity = {},
	ESPFilterFish = {},
	ESPFilterMutation = {},
	ESPConnection = nil,
	ESPBillboards = {},
	AutoRespawn = false,
	AutoRespawnToken = 0,
	LowGraphics = false,
	ExtremeGraphics = false,
	AutoFarm = false,
	SelectedFarm = nil,
	CurrentTween = nil,
	IsTweening = false,
	IsBusy = false,
	IsGoingSafe = false,
	InstantCatch = false,
	CatchMode = "Legit",
	AutoSell = false,
	IsSelling = false,
	SellAt = "90%",
	AutoRefillOxygen = false,
	Priority1 = {},
	Priority2 = {},
	Priority3 = {},
	AutoTreasure = false,
	SelectedTier = "Tier 1",
	TreasureRunning = false,
	ChestBlacklist = {},
	ChestsFarmed = 0,
	HideIdentifier = false,
	FakeName = "",
	FakeLevel = "",
	FakeLevel = "",
	NoclipEnabled = true,
	SelectedIsland = "Ancient Sands",
}

local _thread, _favConnection, _webhookConnection, _statsWebhookLoop = nil, nil, nil, nil
local _caughtListener = nil
local function has(tbl, val) return tbl[val] or table.find(tbl, val) end

local function SetNoclip(enabled)
	local char = LocalPlayer.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not enabled
		end
	end
end

local function DisableAllCollisions()
	local char = LocalPlayer.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

RunService.Stepped:Connect(function()
	if st.NoclipEnabled or st.IsTweening or st.AutoFarm then
		SetNoclip(true)
		DisableAllCollisions()
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if st.NoclipEnabled or st.AutoFarm then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
	char.DescendantAdded:Connect(function(desc)
		if (st.NoclipEnabled or st.AutoFarm) and desc:IsA("BasePart") then
			desc.CanCollide = false
		end
	end)
end)

local function CancelCurrentTween()
	if st.CurrentTween then
		st.CurrentTween:Cancel()
		st.CurrentTween = nil
	end
	st.IsTweening = false
end

local function TweenTo(cf)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	CancelCurrentTween()
	st.IsTweening = true
	local time = math.max(tonumber(st.TweenTime) or 0.1, 0.05)
	local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = cf })
	st.CurrentTween = tween
	tween:Play()
	tween.Completed:Once(function()
		if st.CurrentTween == tween then
			st.IsTweening = false
		end
	end)
end

local function TweenToWithSpeed(cf, speed)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	CancelCurrentTween()
	st.IsTweening = true
	local distance = (hrp.Position - cf.Position).Magnitude
	local time = math.max(distance / speed, 0.05)
	local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { CFrame = cf })
	st.CurrentTween = tween
	tween:Play()
end

local function TweenToAndWait(cf, speed)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	CancelCurrentTween()
	st.IsTweening = true
	local spd = speed or 500
	local dist = (hrp.Position - cf.Position).Magnitude
	local time = math.max(dist / math.max(spd, 0.01), 0.05)
	local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), { CFrame = cf })
	st.CurrentTween = tween
	tween:Play()
	tween.Completed:Wait()
	while (hrp.Position - cf.Position).Magnitude > 3 do task.wait(0.001) end
	st.CurrentTween = nil
	st.IsTweening = false
	return true
end

local function GetEquippedTubeMaxOxygen()
	local ok, result = pcall(function()
		local scroll = PlayerGui.Main.TopLeft.Menus.Inventory.Frame.Scroll_Tubes
		for _, tube in ipairs(scroll:GetChildren()) do
			local eq = tube:FindFirstChild("Equipped")
			if eq and eq.Visible then
				local lbl = tube.StatList.oxygen.TextLabel
				return tonumber(lbl.Text:match("[%d%.]+"))
			end
		end
	end)
	return ok and result or nil
end

local function GetCurrentOxygen()
	local ok, result = pcall(function()
		local lbl = PlayerGui.Main.Oxygen.CanvasGroup:FindFirstChild("Oxygen")
		return lbl and tonumber(lbl.Text)
	end)
	return ok and result or nil
end

local function GetCurrentWeight()
	local ok, result = pcall(function()
		local lbl = PlayerGui.Main.Oxygen.RightStats.Frame.Weight:FindFirstChild("Wght")
		return lbl and tonumber(lbl.Text) or 0
	end)
	return ok and result or 0
end

local function GetMaxWeight()
	local ok, result = pcall(function()
		local lbl = PlayerGui.Main.Oxygen.RightStats.Frame.Weight:FindFirstChild("Max")
		if not lbl then return 0 end
		local n = lbl.Text:match("[%d%.]+")
		return tonumber(n) or 0
	end)
	return ok and result or 0
end

local function GetPlayerCash()
	local ok, result = pcall(function()
		local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
		if leaderstats then
			local cash = leaderstats:FindFirstChild("Cash")
			if cash then return tostring(cash.Value) end
		end
		return "0"
	end)
	return ok and result or "0"
end

local function GetPlayerLevel()
	local ok, result = pcall(function()
		local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
		if leaderstats then
			local level = leaderstats:FindFirstChild("Level")
			if level then return tostring(level.Value) end
		end
		return "1"
	end)
	return ok and result or "1"
end

local function GetCurrentLocation()
	if st.SelectedFarm then return st.SelectedFarm end
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return "Unknown" end
	local minDist = math.huge
	local closestLoc = "Unknown"
	for name, cf in pairs(LocFarm) do
		local dist = (hrp.Position - cf.Position).Magnitude
		if dist < minDist then minDist = dist; closestLoc = name end
	end
	if minDist < 500 then return closestLoc end
	return "Roaming"
end

local function GetPlayerStatus()
	if st.IsSelling then return "Selling Fish"
	elseif st.IsGoingSafe then return "Refilling Oxygen"
	elseif st.AutoFarm then return "Auto Farming"
	else return "Idle" end
end

local function GetSellThreshold()
	local max = GetMaxWeight()
	if st.SellAt == "max" then return max end
	local num = tonumber(st.SellAt)
	if num then return num end
	local percent = tonumber((st.SellAt or ""):match("(%d+)%s*%%"))
	if percent then return max * (percent / 100) end
	return max * 0.9
end

local function GetNearestOxygenCFrame()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	local best, dist = nil, math.huge
	for _, cf in ipairs(OxygenCordinat) do
		local d = (hrp.Position - cf.Position).Magnitude
		if d < dist then dist, best = d, cf end
	end
	return best
end

local function GetNearestSellCFrame()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	local nearest, dist = nil, math.huge
	for _, cf in ipairs(SellCordinat) do
		local d = (hrp.Position - cf.Position).Magnitude
		if d < dist then dist = d; nearest = cf end
	end
	return nearest
end

local function GetReturnFarmCFrame()
	if st.SelectedFarm then return LocFarm[st.SelectedFarm] end
	return nil
end

local function GetFishInfoFromModel(fishModel)
	local head = fishModel:FindFirstChild("Head")
	if not head then return nil end
	local stats = head:FindFirstChild("stats")
	if not stats then return nil end
	local fishLabel = stats:FindFirstChild("Fish")
	if not fishLabel then return nil end
	local name = fishLabel.Text
	local root = fishModel:FindFirstChild("RootPart")
	if not root then return nil end
	if root:FindFirstChild("block") then return nil end
	local mutations = {}
	local mutLabel = stats:FindFirstChild("Mutation")
	if mutLabel and mutLabel.Text and mutLabel.Text ~= "" then
		for m in mutLabel.Text:gmatch("[^,]+") do
			table.insert(mutations, m:match("^%s*(.-)%s*$"))
		end
	end
	return { name = name, mutations = mutations, root = root, cframe = root.CFrame }
end

local function findTarget()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local pos = hrp.Position

	local cacheHasData = false
	if FishController and FishController.fish_cache then
		for _ in pairs(FishController.fish_cache) do
			cacheHasData = true
			break
		end
	end

	if cacheHasData then
		local function nearest(filter)
			local best, bd
			for id, f in pairs(FishController.fish_cache) do
				if not f.dead and f.health > 0 and filter(f) then
					local fishPos = f.cframe.Position
					if st.SelectedFarm then
						local farmCF = LocFarm[st.SelectedFarm]
						if farmCF and (fishPos - farmCF.Position).Magnitude > 350 then continue end
					end
					local d = (fishPos - pos).Magnitude
					if not bd or d < bd then
						best, bd = { id = id, pos = fishPos, cframe = f.cframe, source = "cache" }, d
					end
				end
			end
			return best
		end

		if next(st.SelectedMutations) then
			local t = nearest(function(f)
				for _, m in ipairs(f.mutations) do
					if has(st.SelectedMutations, m) then return true end
				end
			end)
			if t then return t end
		end
		for _, list in ipairs({ st.Priority1, st.Priority2, st.Priority3 }) do
			if next(list) then
				local t = nearest(function(f) return has(list, f.name) end)
				if t then return t end
			end
		end
		if next(st.SelectRarity) then
			local t = nearest(function(f)
				local r = getFishRarity(f.name)
				return r and has(st.SelectRarity, r)
			end)
			if t then return t end
		end
	end

	local fishClient = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Fish") and workspace.Game.Fish:FindFirstChild("client")
	if not fishClient then return nil end

	local function nearestWS(filter)
		local best, bd
		for _, fishModel in ipairs(fishClient:GetChildren()) do
			local info = GetFishInfoFromModel(fishModel)
			if not info then continue end
			if not filter(info) then continue end
			local fishPos = info.cframe.Position
			if st.SelectedFarm then
				local farmCF = LocFarm[st.SelectedFarm]
				if farmCF and (fishPos - farmCF.Position).Magnitude > 350 then continue end
			end
			local d = (fishPos - pos).Magnitude
			if not bd or d < bd then
				best, bd = { id = fishModel.Name, pos = fishPos, cframe = info.cframe, source = "workspace" }, d
			end
		end
		return best
	end

	if next(st.SelectedMutations) then
		local t = nearestWS(function(info)
			for _, m in ipairs(info.mutations) do
				if has(st.SelectedMutations, m) then return true end
			end
		end)
		if t then return t end
	end
	for _, list in ipairs({ st.Priority1, st.Priority2, st.Priority3 }) do
		if next(list) then
			local t = nearestWS(function(info) return has(list, info.name) end)
			if t then return t end
		end
	end
	if next(st.SelectRarity) then
		local t = nearestWS(function(info)
			local r = getFishRarity(info.name)
			return r and has(st.SelectRarity, r)
		end)
		if t then return t end
	end

	return nil
end

local function HandleOxygenRefill()
	if st.IsGoingSafe or not st.AutoRefillOxygen then return end
	local ok, low = pcall(function()
		return PlayerGui.Main.Backpack.Folder.LowOxygen
	end)
	if not (ok and low and low.Visible) then return end

	st.IsGoingSafe = true
	st.IsBusy = true
	CancelCurrentTween()

	local maxOxy = GetEquippedTubeMaxOxygen()
	if not maxOxy then
		st.IsGoingSafe = false
		st.IsBusy = false
		return
	end

	local cf = GetNearestOxygenCFrame()
	if not cf then
		st.IsGoingSafe = false
		st.IsBusy = false
		return
	end

	TweenToWithSpeed(cf, 500)
	if st.CurrentTween then st.CurrentTween.Completed:Wait() end
	st.CurrentTween = nil
	st.IsTweening = false

	while st.AutoFarm do
		local cur = GetCurrentOxygen()
		if cur and cur >= maxOxy then break end
		task.wait(0.1)
	end

	local returnCF = GetReturnFarmCFrame()
	if returnCF and st.SelectedFarm ~= "Forgotten Deep" then
		TweenToWithSpeed(returnCF, 500)
		if st.CurrentTween then st.CurrentTween.Completed:Wait() end
		st.CurrentTween = nil
		st.IsTweening = false
	end

	st.IsGoingSafe = false
	st.IsBusy = false
end

local function HandleSell()
	if st.IsSelling then return end
	local current = GetCurrentWeight()
	local threshold = GetSellThreshold()
	if threshold <= 0 or current < threshold then return end

	st.IsSelling = true
	st.IsBusy = true
	CancelCurrentTween()

	local cf = GetNearestSellCFrame()
	if cf then
		TweenToAndWait(cf, 500)
		task.wait(0.5)
		while st.AutoSell do
			local before = GetCurrentWeight()
			pcall(function() Remotes.SellInventory:InvokeServer() end)
			task.wait(0.3)
			local now = GetCurrentWeight()
			if now < threshold then break end
			if now >= before then task.wait(0.3) end
		end
	end

	local returnCF = GetReturnFarmCFrame()
	if returnCF and st.SelectedFarm ~= "Forgotten Deep" then
		TweenToAndWait(returnCF, 500)
	end

	st.IsSelling = false
	st.IsBusy = false
end

local function collectNearestFish()
	local fishFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Fish") and workspace.Game.Fish:FindFirstChild("client")
	if not fishFolder then return false end

	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end

	for _, fish in pairs(fishFolder:GetChildren()) do
		local root = fish:FindFirstChild("RootPart")
		local prompt = root and root:FindFirstChildOfClass("ProximityPrompt")
		if prompt and (root.Position - hrp.Position).Magnitude <= 15 then
			hrp.CFrame = root.CFrame
			prompt.HoldDuration = 0
			prompt.MaxActivationDistance = math.huge
			prompt.RequiresLineOfSight = false
			task.spawn(function()
				if fireproximityprompt then fireproximityprompt(prompt) end
				prompt:InputHoldBegin()
				task.wait()
				prompt:InputHoldEnd()
			end)
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			return true
		end
	end
	return false
end

local function StartAutoFarm()
	if st.AutoFarm then return end
	st.AutoFarm = true

	if st.SelectedFarm and st.SelectedFarm ~= "Forgotten Deep" then
		local farmCF = LocFarm[st.SelectedFarm]
		if farmCF then
			TweenToAndWait(farmCF, 500)
		end
	end

	_thread = task.spawn(function()
		while st.AutoFarm do
			if LocalPlayer:GetAttribute("catching") then
				repeat task.wait() until not LocalPlayer:GetAttribute("catching") or not st.AutoFarm
				continue
			end

			if st.IsBusy then
				repeat task.wait() until not st.IsBusy or not st.AutoFarm
				if not st.AutoFarm then break end
				continue
			end

			if st.AutoRefillOxygen then
				local ok, low = pcall(function()
					return PlayerGui.Main.Backpack.Folder.LowOxygen
				end)
				if ok and low and low.Visible then
					HandleOxygenRefill()
					continue
				end
			end

			if st.AutoSell then
				local current = GetCurrentWeight()
				local threshold = GetSellThreshold()
				if threshold > 0 and current >= threshold then
					HandleSell()
					continue
				end
			end

			local target = findTarget()
			if target then
				if st.IsBusy then
					task.wait()
					continue
				end
				local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not hrp then
					task.wait()
					continue
				end
				local dist = (hrp.Position - target.pos).Magnitude
				if dist > st.MaxRange then
					TweenTo(target.cframe)
					task.wait()
					continue
				end

				if st.CatchMode == "Instant" or st.InstantCatch then
					local timeout = tick()
					while tick() - timeout < 1 and st.AutoFarm do
						if not LocalPlayer:GetAttribute("catching") then
							pcall(function() Remotes.StartCatching:InvokeServer(target.id) end)
						end
						task.wait()
						pcall(function() Remotes.CancelMinigame:InvokeServer() end)
						if collectNearestFish() then break end
						task.wait()
					end
				elseif st.CatchMode == "Blatant" then
					task.spawn(function()
						pcall(function() Remotes.StartCatching:InvokeServer(target.id) end)
					end)

					task.wait(0.01)

					task.spawn(function()
						pcall(function() Remotes.CancelMinigame:InvokeServer() end)
						pcall(function() Remotes.CollectFish:InvokeServer(target.id) end)
					end)
				else
					local success = pcall(function()
						Remotes.StartCatching:InvokeServer(target.id)
					end)

					if success then
						pcall(function() Remotes.CollectFish:InvokeServer(target.id) end)
						if LocalPlayer:GetAttribute("catching") then
							repeat task.wait() until not LocalPlayer:GetAttribute("catching") or not st.AutoFarm
						end
					else
						task.wait(0.1)
					end
				end
				task.wait()
			else
				task.wait(0.1)
			end
		end
	end)
end

local function StopAutoFarm()
	st.AutoFarm = false
	st.IsBusy = false
	st.IsSelling = false
	st.IsGoingSafe = false
	CancelCurrentTween()
	if _thread then task.cancel(_thread); _thread = nil end
end

local function shouldFavorite(item)
	if item.class ~= "fish" or item.favorited then return false end
	local fishMatch = next(st.SelectFish) and has(st.SelectFish, item.name)
	local mutMatch = false
	if next(st.SelectMutation) then
		for _, m in ipairs(item.mutations or {}) do
			if has(st.SelectMutation, m) then mutMatch = true; break end
		end
	end
	local rarityMatch = next(st.SelectFavRarity) and has(st.SelectFavRarity, getFishRarity(item.name))
	if st.StrictMode then return fishMatch and mutMatch and rarityMatch end
	return fishMatch or mutMatch or rarityMatch
end

local function scanInventory()
	for uuid, item in pairs(Replica.Data.inventory) do
		if shouldFavorite(item) then
			Remotes.Favorite:InvokeServer(uuid)
			task.wait(2)
		end
	end
end

local function StartFavorite()
	if st.FavRunning then return end
	st.FavRunning = true
	local Notifications = PlayerGui:WaitForChild("Top"):WaitForChild("Notifications")
	_favConnection = Notifications.ChildAdded:Connect(function(child)
		if not st.FavRunning then return end
		local label = child:FindFirstChild("Frame") and child.Frame:FindFirstChild("Label")
		if label and string.find(label.Text, "Caught") then
			task.spawn(function() task.wait(1); scanInventory() end)
		end
	end)
	task.spawn(scanInventory)
end

local function StopFavorite()
	st.FavRunning = false
	if _favConnection then _favConnection:Disconnect(); _favConnection = nil end
end

local function UnfavoriteAll()
	st.IsUnfavoriting = true
	task.spawn(function()
		for uuid, item in pairs(Replica.Data.inventory) do
			if not st.IsUnfavoriting then break end
			if item.class == "fish" and item.favorited then
				Remotes.Favorite:InvokeServer(uuid)
				task.wait(1)
			end
		end
		st.IsUnfavoriting = false
	end)
end

local function StopUnfavorite() st.IsUnfavoriting = false end

local function parseNotif(child)
	local fullName, weight
	for _, desc in ipairs(child:GetDescendants()) do
		if desc:IsA("TextLabel") then
			local clean = desc.Text:gsub("<.->", "")
			local n = string.match(clean, "Caught a (.+) weighing")
			if n then fullName = n end
			local w = string.match(clean, "([%d%.]+)kg")
			if w then weight = w .. " kg" end
		end
	end
	if not fullName then return end
	local name = fullName
	local mutation = nil
	if not getFishRarity(name) then
		local mut, fish = string.match(name, "^(%S+)%s+(.+)$")
		if fish and getFishRarity(fish) then mutation = mut; name = fish end
	end
	return name, weight or "?", mutation
end

local function WebhookSend(name, rarity, weight)
	local c = RarityModule[rarity] and RarityModule[rarity].color
	local color = c and math.floor(c.R * 255) * 65536 + math.floor(c.G * 255) * 256 + math.floor(c.B * 255) or 5814783
	local req = request or http_request or (syn and syn.request)
	if not req then return end
	local iconUrl = "https://cdn.discordapp.com/attachments/1458820220339753084/1470950568846561434/IMG-20260207-WA0026.jpg"
	pcall(req, {
		Url = st.WebhookURL,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({
			username = "VoraHUB Abyss",
			avatar_url = iconUrl,
			embeds = {{
				title = "Fish Caught!",
				description = "**" .. name .. "** has been caught!",
				color = color,
				fields = {
					{ name = "Fish Name", value = "```" .. name .. "```", inline = true },
					{ name = "Rarity", value = "```" .. rarity .. "```", inline = true },
					{ name = "Weight", value = "```" .. weight .. "```", inline = true },
				},
				thumbnail = { url = iconUrl },
				footer = { text = "VoraHUB", icon_url = iconUrl },
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
			}},
		}),
	})
end

local function SendStatsWebhook()
	if st.WebhookStatsURL == "" then return end
	local req = request or http_request or (syn and syn.request)
	if not req then return end
	local playerName = LocalPlayer.Name
	local cash = GetPlayerCash()
	local level = GetPlayerLevel()
	local status = GetPlayerStatus()
	local location = GetCurrentLocation()
	local weight = GetCurrentWeight()
	local maxWeight = GetMaxWeight()
	local oxygen = GetCurrentOxygen() or 0
	local maxOxygen = GetEquippedTubeMaxOxygen() or 100
	local statusColor = 3447003
	if status:find("Farming") then statusColor = 3066993
	elseif status:find("Selling") then statusColor = 15844367
	elseif status:find("Refilling") then statusColor = 5793266 end
	local iconUrl = "https://cdn.discordapp.com/attachments/1458820220339753084/1470950568846561434/IMG-20260207-WA0026.jpg"
	local embedData = {
		title = "Player Statistics - " .. playerName,
		description = "**Real-time farming statistics**",
		color = statusColor,
		fields = {
			{ name = "Player", value = "```" .. playerName .. "```", inline = true },
			{ name = "Level", value = "```" .. level .. "```", inline = true },
			{ name = "Cash", value = "```$" .. cash .. "```", inline = true },
			{ name = "Status", value = status, inline = false },
			{ name = "Location", value = "```" .. location .. "```", inline = true },
			{ name = "Weight", value = "```" .. weight .. " / " .. maxWeight .. " kg```", inline = true },
			{ name = "Oxygen", value = "```" .. math.floor(oxygen) .. " / " .. math.floor(maxOxygen) .. "```", inline = true },
		},
		thumbnail = { url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png" },
		footer = { text = "VoraHUB Auto-Update", icon_url = iconUrl },
		timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
	}
	local webhookBody = { username = "VoraHUB Statistics", avatar_url = iconUrl, embeds = { embedData } }
	if st.WebhookStatsMessageId then
		pcall(req, {
			Url = st.WebhookStatsURL .. "/messages/" .. st.WebhookStatsMessageId,
			Method = "PATCH",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(webhookBody),
		})
	else
		local success, response = pcall(req, {
			Url = st.WebhookStatsURL .. "?wait=true",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(webhookBody),
		})
		if success and response and response.Body then
			local decoded = HttpService:JSONDecode(response.Body)
			if decoded and decoded.id then st.WebhookStatsMessageId = decoded.id end
		end
	end
end

local function StartStatsWebhook()
	if st.WebhookStatsEnabled then return end
	st.WebhookStatsEnabled = true
	st.WebhookStatsMessageId = nil
	_statsWebhookLoop = task.spawn(function()
		while st.WebhookStatsEnabled do
			SendStatsWebhook()
			task.wait(15)
		end
	end)
end

local function StopStatsWebhook()
	st.WebhookStatsEnabled = false
	if _statsWebhookLoop then task.cancel(_statsWebhookLoop); _statsWebhookLoop = nil end
	st.WebhookStatsMessageId = nil
end

local function StartWebhook()
	if st.WebhookRunning then return end
	st.WebhookRunning = true
	local Notifications = PlayerGui:WaitForChild("Top"):WaitForChild("Notifications")
	_webhookConnection = Notifications.ChildAdded:Connect(function(child)
		if not st.WebhookRunning then return end
		task.wait(0.1)
		local label = child:FindFirstChild("Frame") and child.Frame:FindFirstChild("Label")
		if not label or not string.find(label.Text, "Caught") then return end
		local name, weight, mutation = parseNotif(child)
		if not name then return end
		local rarity = getFishRarity(name)
		if not rarity then return end
		if not next(st.WebhookRarity) or not has(st.WebhookRarity, rarity) then return end
		local display = mutation and (mutation .. " " .. name) or name
		WebhookSend(display, rarity, weight)
	end)
end

local function StopWebhook()
	st.WebhookRunning = false
	if _webhookConnection then _webhookConnection:Disconnect(); _webhookConnection = nil end
end

local function WebhookTest()
	if st.WebhookURL == "" then return end
	WebhookSend("Test Fish", "Legendary", "99 kg")
end

local function GetRealPing()
	local ok, ping = pcall(function()
		local net = Stats:FindFirstChild("Network")
		if net then
			local ss = net:FindFirstChild("ServerStatsItem")
			if ss then
				local dp = ss:FindFirstChild("Data Ping")
				if dp then return math.floor(dp:GetValue()) end
			end
		end
		return math.floor(LocalPlayer:GetNetworkPing() * 1000)
	end)
	return ok and ping or 0
end

local fpsHistory, lastFrameTime = {}, tick()
local function GetFPS()
	local now = tick()
	local dt = now - lastFrameTime
	lastFrameTime = now
	table.insert(fpsHistory, dt > 0 and (1 / dt) or 0)
	if #fpsHistory > 20 then table.remove(fpsHistory, 1) end
	local sum = 0
	for _, f in ipairs(fpsHistory) do sum = sum + f end
	return math.floor(math.clamp(sum / #fpsHistory, 0, 240))
end

local function ColorByRange(value, thresholds)
	for _, t in ipairs(thresholds) do if t[1](value) then return t[2] end end
	return Color3.fromRGB(255, 255, 255)
end

local pingColors = {
	{ function(v) return v <= 50 end, Color3.fromRGB(100, 255, 200) },
	{ function(v) return v <= 100 end, Color3.fromRGB(150, 200, 255) },
	{ function(v) return v <= 150 end, Color3.fromRGB(180, 140, 255) },
	{ function() return true end, Color3.fromRGB(255, 100, 150) },
}
local fpsColors = {
	{ function(v) return v >= 55 end, Color3.fromRGB(100, 255, 200) },
	{ function(v) return v >= 40 end, Color3.fromRGB(150, 200, 255) },
	{ function(v) return v >= 25 end, Color3.fromRGB(180, 140, 255) },
	{ function() return true end, Color3.fromRGB(255, 100, 150) },
}

local function MakeElement(class, props, parent)
	local obj = Instance.new(class)
	for k, v in pairs(props) do obj[k] = v end
	obj.Parent = parent
	return obj
end

local function CreateStreePanel()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "StreeMiniPanel"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 210, 0, 70)
    main.Position = UDim2.new(0.5, -105, 1, -120)
    main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    main.BackgroundTransparency = 0.25
    main.BorderSizePixel = 0
    main.Active = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(0,255,0)
    stroke.Thickness = 2

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,26)
    header.BackgroundTransparency = 1

    local logo = Instance.new("ImageLabel", header)
    logo.Image = "rbxassetid://128806139932217"
    logo.Size = UDim2.new(0,18,0,18)
    logo.Position = UDim2.new(0,6,0.5,-9)
    logo.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1,-30,1,0)
    title.Position = UDim2.new(0,28,0,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "STREE HUB PANEL"
    title.TextColor3 = Color3.fromRGB(0,255,120)

    local statsFrame = Instance.new("Frame", main)
    statsFrame.Position = UDim2.new(0,6,0,30)
    statsFrame.Size = UDim2.new(1,-12,1,-34)
    statsFrame.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", statsFrame)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0,6)

    local function makeStat()
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0,60,1,0)
        box.BackgroundColor3 = Color3.fromRGB(20,20,20)
        box.BackgroundTransparency = 0.2
        box.BorderSizePixel = 0
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

        local stroke = Instance.new("UIStroke", box)
        stroke.Color = Color3.fromRGB(60,60,60)

        local label = Instance.new("TextLabel", box)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextWrapped = true
        label.TextColor3 = Color3.new(1,1,1)

        box.Parent = statsFrame
        return label
    end

    local cpuLabel = makeStat()
    local pingLabel = makeStat()
    local fpsLabel = makeStat()

    local dragging = false
    local dragStart, startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local frames = 0
    local fps = 0
    local last = tick()

    RunService.RenderStepped:Connect(function()
        frames += 1
        if tick() - last >= 1 then
            fps = frames
            frames = 0
            last = tick()
        end
    end)

    local function getPing()
        local net = Stats:FindFirstChild("Network")
        if net and net:FindFirstChild("ServerStatsItem") then
            local item = net.ServerStatsItem:FindFirstChild("Data Ping")
            if item then return math.floor(item:GetValue()) end
        end
        return 0
    end

    local function getCPU()
        local perf = Stats:FindFirstChild("PerformanceStats")
        if perf then
            local cpu = perf:FindFirstChild("CPU")
            if cpu then return math.floor(cpu:GetValue()) end
        end
        return 0
    end

    local function color(label, v, y, r)
        if v >= r then
            label.TextColor3 = Color3.fromRGB(255,80,80)
        elseif v >= y then
            label.TextColor3 = Color3.fromRGB(255,220,0)
        else
            label.TextColor3 = Color3.fromRGB(0,255,120)
        end
    end

    task.spawn(function()
        while gui.Parent do
            local ping = getPing()
            local cpu = getCPU()

            cpuLabel.Text = "CPU\n"..cpu.."%"
            pingLabel.Text = "PING\n"..ping.."ms"
            fpsLabel.Text = "FPS\n"..fps

            color(cpuLabel, cpu, 60, 85)
            color(pingLabel, ping, 120, 200)
            color(fpsLabel, fps, 40, 90)

            task.wait(1)
        end
    end)

    return gui
end

local StreePanel = CreateStreePanel()

local function GetRarityColor(rarityName)
	local info = RarityModule[rarityName]
	return (info and info.color) or Color3.fromRGB(255, 255, 255)
end



local _savedLighting = {}
local _lowGfxConnection = nil

local function ApplyLowGraphics()
	local lighting = game:GetService("Lighting")
	_savedLighting.Brightness = lighting.Brightness; _savedLighting.GlobalShadows = lighting.GlobalShadows; _savedLighting.FogEnd = lighting.FogEnd
	_savedLighting.EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale; _savedLighting.EnvironmentSpecularScale = lighting.EnvironmentSpecularScale
	settings().Rendering.QualityLevel = 1; lighting.GlobalShadows = false; lighting.FogEnd = 100000; lighting.EnvironmentDiffuseScale = 0; lighting.EnvironmentSpecularScale = 0
	_savedLighting.PostEffects = {}
	for _, effect in ipairs(lighting:GetChildren()) do
		if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") then
			_savedLighting.PostEffects[effect] = effect.Enabled; effect.Enabled = false
		end
	end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		_savedLighting.WaterWaveSize = terrain.WaterWaveSize; _savedLighting.WaterWaveSpeed = terrain.WaterWaveSpeed
		_savedLighting.WaterReflectance = terrain.WaterReflectance; _savedLighting.WaterTransparency = terrain.WaterTransparency
		terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0; terrain.WaterReflectance = 0; terrain.WaterTransparency = 0; terrain.Decoration = false
	end
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			if obj:GetAttribute("_voraOrigEnabled") == nil then obj:SetAttribute("_voraOrigEnabled", obj.Enabled) end; obj.Enabled = false
		end
		if obj:IsA("Decal") or obj:IsA("Texture") then
			if obj:GetAttribute("_voraOrigTransparency") == nil then obj:SetAttribute("_voraOrigTransparency", obj.Transparency) end; obj.Transparency = 1
		end
		if obj:IsA("MeshPart") then obj.RenderFidelity = Enum.RenderFidelity.Performance end
	end
	_lowGfxConnection = workspace.DescendantAdded:Connect(function(obj)
		if not st.LowGraphics then return end
		task.defer(function()
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj:SetAttribute("_voraOrigEnabled", obj.Enabled); obj.Enabled = false end
			if obj:IsA("Decal") or obj:IsA("Texture") then obj:SetAttribute("_voraOrigTransparency", obj.Transparency); obj.Transparency = 1 end
			if obj:IsA("MeshPart") then obj.RenderFidelity = Enum.RenderFidelity.Performance end
		end)
	end)
end

local function RestoreGraphics()
	local lighting = game:GetService("Lighting")
	settings().Rendering.QualityLevel = 21
	if _savedLighting.GlobalShadows ~= nil then lighting.GlobalShadows = _savedLighting.GlobalShadows end
	if _savedLighting.FogEnd then lighting.FogEnd = _savedLighting.FogEnd end
	if _savedLighting.EnvironmentDiffuseScale then lighting.EnvironmentDiffuseScale = _savedLighting.EnvironmentDiffuseScale end
	if _savedLighting.EnvironmentSpecularScale then lighting.EnvironmentSpecularScale = _savedLighting.EnvironmentSpecularScale end
	if _savedLighting.PostEffects then for effect, enabled in pairs(_savedLighting.PostEffects) do if effect and effect.Parent then effect.Enabled = enabled end end end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		if _savedLighting.WaterWaveSize then terrain.WaterWaveSize = _savedLighting.WaterWaveSize end
		if _savedLighting.WaterWaveSpeed then terrain.WaterWaveSpeed = _savedLighting.WaterWaveSpeed end
		if _savedLighting.WaterReflectance then terrain.WaterReflectance = _savedLighting.WaterReflectance end
		if _savedLighting.WaterTransparency then terrain.WaterTransparency = _savedLighting.WaterTransparency end
		terrain.Decoration = true
	end
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then local orig = obj:GetAttribute("_voraOrigEnabled"); if orig ~= nil then obj.Enabled = orig end end
		if obj:IsA("Decal") or obj:IsA("Texture") then local orig = obj:GetAttribute("_voraOrigTransparency"); if orig ~= nil then obj.Transparency = orig end end
		if obj:IsA("MeshPart") then obj.RenderFidelity = Enum.RenderFidelity.Automatic end
	end
	if _lowGfxConnection then _lowGfxConnection:Disconnect(); _lowGfxConnection = nil end
	_savedLighting = {}
end

local _extremeGfxConnection = nil
local function IsPlayerOrFish(obj)
	local char = LocalPlayer.Character
	if char and (obj == char or obj:IsDescendantOf(char)) then return true end
	for _, p in ipairs(Players:GetPlayers()) do local c = p.Character; if c and (obj == c or obj:IsDescendantOf(c)) then return true end end
	local fishClient = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Fish") and workspace.Game.Fish:FindFirstChild("client")
	if fishClient and (obj == fishClient or obj:IsDescendantOf(fishClient)) then return true end
	return false
end
local function IsGUIRelated(obj)
	if obj:IsDescendantOf(CoreGui) then return true end
	if PlayerGui and obj:IsDescendantOf(PlayerGui) then return true end
	local parent = obj.Parent
	while parent do if parent:IsA("ScreenGui") or parent:IsA("BillboardGui") or parent:IsA("SurfaceGui") then return true end; parent = parent.Parent end
	return false
end
local function NukePart(obj)
	if obj:GetAttribute("_voraExtremeMat") == nil then obj:SetAttribute("_voraExtremeMat", obj.Material.Name); obj:SetAttribute("_voraExtremeColor", obj.Color:ToHex()); if obj:IsA("BasePart") then obj:SetAttribute("_voraExtremeCastShadow", obj.CastShadow) end end
	obj.Material = Enum.Material.SmoothPlastic; obj.CastShadow = false
	if obj:IsA("MeshPart") then obj.RenderFidelity = Enum.RenderFidelity.Performance; if obj.TextureID and obj:GetAttribute("_voraExtremeTexID") == nil then obj:SetAttribute("_voraExtremeTexID", obj.TextureID) end; obj.TextureID = "" end
	if obj:IsA("UnionOperation") then obj.RenderFidelity = Enum.RenderFidelity.Performance end
end
local function NukeEffect(obj)
	if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then if obj:GetAttribute("_voraExtremeEnabled") == nil then obj:SetAttribute("_voraExtremeEnabled", obj.Enabled) end; obj.Enabled = false; return end
	if obj:IsA("Decal") or obj:IsA("Texture") then if obj:GetAttribute("_voraExtremeTransp") == nil then obj:SetAttribute("_voraExtremeTransp", obj.Transparency) end; obj.Transparency = 1; return end
	if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then if obj:GetAttribute("_voraExtremeEnabled") == nil then obj:SetAttribute("_voraExtremeEnabled", obj.Enabled) end; obj.Enabled = false; return end
	if obj:IsA("Sound") then if obj:GetAttribute("_voraExtremeVol") == nil then obj:SetAttribute("_voraExtremeVol", obj.Volume) end; obj.Volume = 0 end
end

local function ApplyExtremeGraphics()
	local lighting = game:GetService("Lighting")
	if not next(_savedLighting) then _savedLighting.Brightness = lighting.Brightness; _savedLighting.GlobalShadows = lighting.GlobalShadows; _savedLighting.FogEnd = lighting.FogEnd; _savedLighting.EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale; _savedLighting.EnvironmentSpecularScale = lighting.EnvironmentSpecularScale end
	settings().Rendering.QualityLevel = 1; lighting.GlobalShadows = false; lighting.FogEnd = 100000; lighting.EnvironmentDiffuseScale = 0; lighting.EnvironmentSpecularScale = 0; lighting.Brightness = 2
	if not _savedLighting.PostEffects then _savedLighting.PostEffects = {} end
	for _, effect in ipairs(lighting:GetChildren()) do if effect:IsA("PostEffect") then if not _savedLighting.PostEffects[effect] then _savedLighting.PostEffects[effect] = effect.Enabled end; effect.Enabled = false end end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		if not _savedLighting.WaterWaveSize then _savedLighting.WaterWaveSize = terrain.WaterWaveSize; _savedLighting.WaterWaveSpeed = terrain.WaterWaveSpeed; _savedLighting.WaterReflectance = terrain.WaterReflectance; _savedLighting.WaterTransparency = terrain.WaterTransparency end
		terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0; terrain.WaterReflectance = 0; terrain.WaterTransparency = 0; terrain.Decoration = false
	end
	for _, obj in ipairs(workspace:GetDescendants()) do if IsPlayerOrFish(obj) or IsGUIRelated(obj) then continue end; if obj:IsA("BasePart") then NukePart(obj) end; NukeEffect(obj) end
	_extremeGfxConnection = workspace.DescendantAdded:Connect(function(obj) if not st.ExtremeGraphics then return end; task.defer(function() if IsPlayerOrFish(obj) or IsGUIRelated(obj) then return end; if obj:IsA("BasePart") then NukePart(obj) end; NukeEffect(obj) end) end)
end

local function RestoreExtremeGraphics()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			local mat = obj:GetAttribute("_voraExtremeMat"); if mat then pcall(function() obj.Material = Enum.Material[mat] end) end
			local col = obj:GetAttribute("_voraExtremeColor"); if col then pcall(function() obj.Color = Color3.fromHex(col) end) end
			local cs = obj:GetAttribute("_voraExtremeCastShadow"); if cs ~= nil then obj.CastShadow = cs end
			if obj:IsA("MeshPart") then obj.RenderFidelity = Enum.RenderFidelity.Automatic; local tid = obj:GetAttribute("_voraExtremeTexID"); if tid then obj.TextureID = tid end end
			if obj:IsA("UnionOperation") then obj.RenderFidelity = Enum.RenderFidelity.Automatic end
		end
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then local orig = obj:GetAttribute("_voraExtremeEnabled"); if orig ~= nil then obj.Enabled = orig end end
		if obj:IsA("Decal") or obj:IsA("Texture") then local orig = obj:GetAttribute("_voraExtremeTransp"); if orig ~= nil then obj.Transparency = orig end end
		if obj:IsA("Sound") then local orig = obj:GetAttribute("_voraExtremeVol"); if orig ~= nil then obj.Volume = orig end end
	end
	RestoreGraphics()
	if _extremeGfxConnection then _extremeGfxConnection:Disconnect(); _extremeGfxConnection = nil end
end

local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Abyss",
    Images  = "128806139932217",
    Color   = Color3.fromRGB(57, 255, 20),
    Theme   = 9542022979,
    ThemeTransparency = 0.15,
    ["Tab Width"] = 120,
    Version = 1,
})

local Tabs = {
	Home = Window:AddTab({ Name = "Home", Icon = "info" }),
	Main = Window:AddTab({ Name = "Main", Icon = "landmark" }),
	Farm = Window:AddTab({ Name = "Auto", Icon = "next" }),
	Teleport = Window:AddTab({ Name = "Teleport", Icon = "map" }),
	Backpack = Window:AddTab({ Name = "Backpack", Icon = "bag" }),
	Shop = Window:AddTab({ Name = "Shop", Icon = "shop" }),
	Webhook = Window:AddTab({ Name = "Webhook", Icon = "web" }),
}

local x1 = Tabs.Home:AddSection("Information")
x1:AddParagraph({
    Title = "Join Our Discord",
    Content = "Join Us!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/jdmX43t5mY"
        if setclipboard then
            setclipboard(link)
        end
    end
})

local x2 = Tabs.Main:AddSection("Helper Features")
x2:AddToggle({
	Title = "Show Ping / FPS Monitor",
	SubText = "Draggable overlay showing real-time Ping & FPS.",
	Default = false,
	Callback = function(v) if StreePanel then StreePanel.Enabled = v end end
})

x2:AddToggle({
	Title = "Auto Equip Gun",
	SubText = "Automatically equip gun if not equipped.",
	Default = false,
	Callback = function(v)
		st.AutoEquipGun = v
		if not v then return end
		task.spawn(function()
			while st.AutoEquipGun do
				local debris = workspace:FindFirstChild("debris")
				local folder = debris and debris:FindFirstChild(LocalPlayer.Name)
				local hasTool = false
				if folder then
					for _, child in ipairs(folder:GetChildren()) do
						if child:IsA("Tool") then hasTool = true; break end
					end
				end
				if not hasTool then pcall(function() Remotes.Equip:InvokeServer("1") end) end
				task.wait(0.5)
			end
		end)
	end
})

x2:AddToggle({
	Title = "Always Noclip",
	SubText = "Keep noclip enabled at all times to prevent kicks.",
	Default = true,
	Callback = function(v) st.NoclipEnabled = v end
})



local x6 = Tabs.Main:AddSection("Improvement")
x6:AddToggle({
	Title = "Low Graphics",
	SubText = "Set all graphics to lowest.",
	Default = false,
	Callback = function(v)
		st.LowGraphics = v
		if v then
			if st.ExtremeGraphics then st.ExtremeGraphics = false; RestoreExtremeGraphics() end
			ApplyLowGraphics()
		else RestoreGraphics() end
	end
})

x6:AddToggle({
	Title = "Extreme Low Graphics",
	SubText = "Strip textures, materials, lights, sounds.",
	Default = false,
	Callback = function(v)
		st.ExtremeGraphics = v
		if v then
			if st.LowGraphics then st.LowGraphics = false; RestoreGraphics() end
			ApplyExtremeGraphics()
		else RestoreExtremeGraphics() end
	end
})

local x7 = Tabs.Main:AddSection("Auto Farm")

x7:AddDropdown({
	Title = "Select Rarity to Catch",
	Options = RarityList,
    Multi = true,
	Default = {},
	Callback = function(v) st.SelectRarity = v end
})

x7:AddDropdown({
	Title = "Mutation to Catch",
	Options = MutationList,
    Multi = true,
	Default = {},
	Callback = function(v) st.SelectedMutations = v end
})

x7:AddInput({
	Title = "Speed Delay (seconds)",
	Placeholder = "0.3",
	Default = "0.3",
	Callback = function(v)
		local n = tonumber(v)
		if n then st.TweenTime = n end
	end
})

x7:AddInput({
	Title = "Catch Range",
	Placeholder = "25",
	Default = "25",
	Callback = function(v)
		local n = tonumber(v)
		if n then st.MaxRange = n end
	end
})

x7:AddDropdown({
	Title = "Catch Mode",
	Options = {"Legit", "Instant", "Blatant"},
	Default = "Legit",
	Callback = function(v) st.CatchMode = v end
})

x7:AddToggle({
	Title = "Start Auto Farm",
	SubText = "",
	Default = false,
	Callback = function(v) if v then StartAutoFarm() else StopAutoFarm() end end
})

x7:AddToggle({
	Title = "Auto Refill Oxygen",
	Default = false,
	Callback = function(v) st.AutoRefillOxygen = v end
})

local x8 = Tabs.Farm:AddSection("Auto Sell")

x8:AddInput({
	Title = "Sell At (number / % / max)",
	Placeholder = "90%",
	Default = "90%",
	Callback = function(v) st.SellAt = string.lower(v) end
})

x8:AddToggle({
	Title = "Auto Sell",
	SubText = "Auto sell when weight reaches threshold.",
	Default = false,
	Callback = function(v) st.AutoSell = v end
})

local x9 = Tabs.Farm:AddSection("Auto Respawn")

x9:AddToggle({
	Title = "Auto Respawn",
	SubText = "Automatically respawn when dead.",
	Default = false,
	Callback = function(state)
		st.AutoRespawn = state
		st.AutoRespawnToken = st.AutoRespawnToken + 1
		local token = st.AutoRespawnToken
		if not state then GuiService.SelectedObject = nil; return end
		task.spawn(function()
			while st.AutoRespawn and token == st.AutoRespawnToken do
				local deathGui = PlayerGui:FindFirstChild("DeathScreen")
				if deathGui and deathGui.Enabled then
					local btn = deathGui:FindFirstChild("Frame", true)
						and deathGui.Frame.Frame.Buttons.Respawn
						and deathGui.Frame.Frame.Buttons.Respawn:FindFirstChild("Button")
					if btn and btn.Visible then
						GuiService.SelectedObject = btn
						task.wait(0.05)
						if not st.AutoRespawn or token ~= st.AutoRespawnToken then break end
						VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
						task.wait(0.02)
						VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
					else
						GuiService.SelectedObject = nil
					end
				end
				task.wait(0.1)
			end
			if token == st.AutoRespawnToken then GuiService.SelectedObject = nil end
		end)
	end
})

local x10 = Tabs.Teleport:AddSection("Island")
x10:AddDropdown({
	Title = "Select Island",
	Options = { "Ancient Sands", "Forgotten Deep", "Spirit Roots" },
	Default = "Ancient Sands",
	Callback = function(v) st.SelectedIsland = v end
})

x10:AddButton({
	Title = "Teleport",
	Callback = function()
		if st.SelectedIsland and LocIsland[st.SelectedIsland] then
			TweenToAndWait(LocIsland[st.SelectedIsland], 300)
		end
	end
})

local x11 = Tabs.Backpack:AddSection("Favorite")
x11:AddDropdown({
	Title = "Select Rarity to Auto Favorite",
	Options = RarityList,
    Multi = true,
	Default = {},
	Callback = function(v) st.SelectFavRarity = v end
})

x11:AddDropdown({
	Title = "Select Fish to Auto Favorite",
	Options = FishList,
    Multi = true,
	Default = {},
	Callback = function(v) st.SelectFish = v end
})

x11:AddToggle({
	Title = "Strict Mode",
	SubText = "Only favorite fish that match ALL selected criteria.",
	Default = false,
	Callback = function(v) st.StrictMode = v end
})

x11:AddToggle({
	Title = "Auto Favorite",
	SubText = "Automatically favorite selected fish when caught.",
	Default = false,
	Callback = function(v) if v then StartFavorite() else StopFavorite() end end
})

x11:AddToggle({
	Title = "Unfavorite All Fish",
	SubText = "Automatically unfavorite all favorited fish.",
	Default = false,
	Callback = function(v) if v then UnfavoriteAll() else StopUnfavorite() end end
})

local x12 = Tabs.Shop:AddSection("Reroll Features")
x12:AddButton({
	Title = "Auto Reroll Race",
	Callback = function() pcall(function() Remotes.Reroll:InvokeServer() end) end
})

local x13 = Tabs.Webhook:AddSection("Fish Caught Webhook")
x13:AddInput({
	Title = "Webhook URL",
	Placeholder = "https://discord.com/api/webhooks/...",
	Default = "",
	Callback = function(v) st.WebhookURL = v end
})

x13:AddDropdown({
	Title = "Select Rarity to Send",
	Options = RarityList,
    Multi = true,
	Default = {},
	Callback = function(v) st.WebhookRarity = v end
})

x13:AddToggle({
	Title = "Enable Fish Caught Webhook",
	SubText = "Send webhook notification when catching selected rarity fish.",
	Default = false,
	Callback = function(v) if v then StartWebhook() else StopWebhook() end end
})

x13:AddButton({
	Title = "Test Fish Webhook",
	Callback = function()
		WebhookTest()
		Window:Notify({ Title = "Webhook", Content = "Webhook test sent!", Duration = 3 })
	end
})

local x14 = Tabs.Webhook:AddSection("Player Stats Webhook")
x14:AddInput({
	Title = "Stats Webhook URL",
	Placeholder = "https://discord.com/api/webhooks/...",
	Default = "",
	Callback = function(v) st.WebhookStatsURL = v end
})

x14:AddToggle({
	Title = "Enable Stats Webhook",
	SubText = "Auto-update player statistics every 15 seconds.",
	Default = false,
	Callback = function(v) if v then StartStatsWebhook() else StopStatsWebhook() end end
})

x14:AddButton({
	Title = "Test Stats Webhook",
	Callback = function()
		SendStatsWebhook()
		Window:Notify({ Title = "Stats Webhook", Content = "Stats webhook sent!", Duration = 3 })
	end
})

task.spawn(function()
	while true do
		local Camera = workspace.CurrentCamera
		if Camera then
			VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
			task.wait(1)
			VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
		end
		task.wait(300)
	end
end)

local function notify(msg, delay, color, title, desc)
    return StreeHub:MakeNotify({
        Title = title or "StreeHub",
        Description = desc or "Notification",
        Content = msg or "Content",
        Color = color or Color3.fromRGB(57, 255, 20),
        Delay = delay or 4
    })
end

task.defer(function()
	task.wait(0.1)
StreeHub:MakeNotify({
    Title = "StreeHub",
    Description = "Notification",
    Content = "Script loaded successfully!",
    bColor = Color3.fromRGB(57, 255, 20),
    Delay = 4
})
end)
