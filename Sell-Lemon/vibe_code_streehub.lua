loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

local version = LRM_ScriptVersion and "v" .. table.concat(LRM_ScriptVersion:split(""), ".") or "Dev Version"
local StreeHub = game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua")
local StreeHub = loadstring(StreeHub)()
local IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, game:GetService("UserInputService"):GetPlatform())
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)

local Window = StreeHub:CreateWindow({
    Title = "StreeHub",
    Icon = "rbxassetid://99948086845842",
    Author = (premium and "Premium" or "Sell Lemon") .. " - " .. version,
    Folder = "StreeHub",
    Size = WindowSize,
    LiveSearchDropdown = true,
    FileSaveName = "StreeHub/Config.json"
})

local Tabs = {
	Home  = Window:Tab({ Title = "Home",  Icon = "scan-face" }),
	Main  = Window:Tab({ Title = "Main",  Icon = "landmark" }),
	Auto  = Window:Tab({ Title = "Automatically",  Icon = "play" }),
	Panel = Window:Tab({ Title = "Panel", Icon = "monitor" }),
	Misc = Window:Tab({ Title = "Miscellaneous", Icon = "layout-grid" }),
    Settings = Window:Tab({ Title = "Settings", Icon = "settings"})
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


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function findTycoon()
	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA("Folder") and v.Name:match("Tycoon%d") then
			if v:FindFirstChild("Owner") and v.Owner.Value == LocalPlayer then
				return v
			end
		end
	end
end

local userTycoon
local _tStart = tick()
repeat
	userTycoon = findTycoon()
	if not userTycoon then task.wait(0.5) end
until userTycoon or tick() - _tStart > 30

if not userTycoon then return end

local AutoBuy = false
local AutoUpgrade = false
local AutoFruit = false
local AutoRebirth = false
local AutoEvolve = false
local AutoPowerLevel = false
local AutoAscend = false
local AutoPhoneOffers = false

local stats = { buys = 0, upgrades = 0, fruit = 0, rebirths = 0, evolves = 0, ascends = 0, phone = 0 }

local RS = game:GetService("ReplicatedStorage")
local Tycoon
local CompClass = {}
pcall(function()
	Tycoon = require(RS.Modules.Tycoon.Tycoon)
	CompClass.Balances    = require(RS.Modules.Tycoon.Component.Client.ClientTycoonBalances)
	CompClass.Rebirth     = require(RS.Modules.Tycoon.Component.Client.ClientTycoonRebirth)
	CompClass.Ascension   = require(RS.Modules.Tycoon.Component.Client.ClientTycoonAscension)
	CompClass.PhoneOffers = require(RS.Modules.Tycoon.Component.Client.ClientTycoonPhoneOffers)
end)

local function comp(class)
	if not (Tycoon and class) then return nil end
	local ok, c = pcall(function()
		local lt = Tycoon.getLocal()
		return lt and lt:GetComponent(class)
	end)
	return ok and c or nil
end

local Buying = false

local function buyAllAffordable()
	for _, obj in ipairs(userTycoon.Purchases:GetDescendants()) do
		if obj:IsA("Model") then
			local shown = obj:GetAttribute("Shown")
			local purchased = obj:GetAttribute("Purchased")
			if shown == true and purchased ~= true then
				local purchase = obj:FindFirstChild("Purchase")
				if purchase and purchase:IsA("RemoteFunction") then
					pcall(function() purchase:InvokeServer() end)
					stats.buys = stats.buys + 1
				end
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.05)
		if AutoBuy then
			pcall(buyAllAffordable)
		end
	end
end)

local upgradeRemotes  = {}
local upgradeLevel    = {}
local lastUpgradeScan = 0

local function refreshUpgradeRemotes()
	upgradeRemotes = {}
	upgradeLevel   = {}
	local purchases = userTycoon:FindFirstChild("Purchases")
	if not purchases then return end
	for _, obj in ipairs(purchases:GetDescendants()) do
		if obj:IsA("RemoteFunction") and obj.Name == "Upgrade" then
			upgradeRemotes[#upgradeRemotes + 1] = obj
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.25)
		if AutoUpgrade then
			if tick() - lastUpgradeScan > 3 then
				refreshUpgradeRemotes()
				lastUpgradeScan = tick()
			end
			for _, remote in ipairs(upgradeRemotes) do
				if remote.Parent then
					local lvl = (upgradeLevel[remote] or 0) + 1
					while lvl <= 100 do
						local ok, res = pcall(function() return remote:InvokeServer(lvl) end)
						if (not ok) or res == false then break end
						upgradeLevel[remote] = lvl
						stats.upgrades = stats.upgrades + 1
						lvl = lvl + 1
					end
				end
			end
		end
	end
end)

local function getPowerLevelRemote()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("UpgradePowerLevel")
end

task.spawn(function()
	while true do
		task.wait(0.25)
		if AutoPowerLevel then
			local remote = getPowerLevelRemote()
			if remote then
				pcall(function() remote:InvokeServer() end)
			end
		end
	end
end)

local RebirthGainMultiple = 1.0
local RebirthMultMode         = false
local RebirthInvestorMultiple = 10
local MinPotential        = 1
local RebirthCooldown     = 2
local RebirthTimeout      = 8
local rebirthBusy         = false

local function getRebirthRemote()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Rebirth")
end

local function getRebirthedSignal()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Rebirthed")
end

local NUM_SCALE = {
	thousand=1e3, million=1e6, billion=1e9, trillion=1e12, quadrillion=1e15,
	quintillion=1e18, sextillion=1e21, septillion=1e24, octillion=1e27,
	nonillion=1e30, decillion=1e33, undecillion=1e36, duodecillion=1e39,
	tredecillion=1e42, quattuordecillion=1e45, quindecillion=1e48,
	sexdecillion=1e51, septendecillion=1e54, octodecillion=1e57,
	novemdecillion=1e60, vigintillion=1e63,
	k=1e3, m=1e6, b=1e9, t=1e12, qd=1e15, qn=1e18, sx=1e21, sp=1e24,
}

do
	local BASE = {
		[0]="thousand",[1]="million",[2]="billion",[3]="trillion",[4]="quadrillion",
		[5]="quintillion",[6]="sextillion",[7]="septillion",[8]="octillion",[9]="nonillion",
		[10]="decillion",[11]="undecillion",[12]="duodecillion",[13]="tredecillion",
		[14]="quattuordecillion",[15]="quindecillion",[16]="sexdecillion",
		[17]="septendecillion",[18]="octodecillion",[19]="novemdecillion",
	}
	local ROOT = {
		[2]="vigintillion",[3]="trigintillion",[4]="quadragintillion",[5]="quinquagintillion",
		[6]="sexagintillion",[7]="septuagintillion",[8]="octogintillion",[9]="nonagintillion",
		[10]="centillion",
	}
	local PREFIX = {
		[0]="",[1]="un",[2]="duo",[3]="tres",[4]="quattuor",[5]="quin",
		[6]="sex",[7]="septen",[8]="octo",[9]="novem",
	}
	for n = 0, 100 do
		local name
		if n < 20 then
			name = BASE[n]
		else
			name = PREFIX[n % 10] .. ROOT[n // 10]
		end
		if name and name ~= "" then NUM_SCALE[name] = 10 ^ ((n + 1) * 3) end
	end
end

local function parseNumber(s)
	if not s then return nil end
	s = tostring(s):gsub(",", ""):lower()
	local num = s:match("[%d%.]+")
	local val = num and tonumber(num)
	if not val then return nil end
	local word = s:match("[%d%.%s]+([a-z]+)")
	if word and NUM_SCALE[word] then val = val * NUM_SCALE[word] end
	return val
end

local function investorBody()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local r  = pg and pg:FindFirstChild("Rebirth")
	local im = r and r:FindFirstChild("InvestorsMenu")
	return im and im:FindFirstChild("Body")
end
local function readQuantity(frameName)
	local body  = investorBody()
	local frame = body and body:FindFirstChild(frameName)
	local q     = frame and frame:FindFirstChild("Quantity")
	return q and parseNumber(q.Text)
end
local function getCurrentInvestors()   return readQuantity("Amount")    or 0 end
local function getPotentialInvestors() return readQuantity("Potential")       end

local function getInvestorLogs()
	local bal = comp(CompClass.Balances)
	local reb = comp(CompClass.Rebirth)
	if not (bal and reb) then return nil end
	local okp, p = pcall(function() return reb:GetPotentialInvestors() end)
	local okc, c = pcall(function() return bal:GetInvestors() end)
	if okp and okc and type(p) == "number" and type(c) == "number" then
		return p, c
	end
	return nil
end

task.spawn(function()
	while true do
		task.wait(0.5)
		if AutoRebirth and not rebirthBusy then
			local remote = getRebirthRemote()
			local mult   = RebirthMultMode and RebirthInvestorMultiple or RebirthGainMultiple
			local worthIt = false
			local potLog, curLog = getInvestorLogs()
			if remote and potLog then
				worthIt = potLog >= math.log10(MinPotential)
					and potLog >= curLog + math.log10(mult)
			elseif remote then
				local potential = getPotentialInvestors()
				local current   = getCurrentInvestors()
				worthIt = potential ~= nil
					and potential >= MinPotential
					and potential >= current * mult
			end
			if worthIt then
				rebirthBusy = true
				pcall(function()
					local done   = false
					local signal = getRebirthedSignal()
					local conn
					if signal and signal:IsA("RemoteEvent") then
						conn = signal.OnClientEvent:Connect(function() done = true end)
					end
					remote:InvokeServer()
					stats.rebirths = stats.rebirths + 1
					local t = 0
					while not done and t < RebirthTimeout do
						task.wait(0.1)
						t = t + 0.1
					end
					if conn then conn:Disconnect() end
				end)
				task.wait(RebirthCooldown)
				rebirthBusy = false
			end
		end
	end
end)

local EvolveAt        = 100
local EvolveCooldown  = 2
local EvolveTimeout   = 8
local evolveBusy      = false

local function getEvolveRemote()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Evolve")
end
local function getEvolvedSignal()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Evolved")
end
local function getEvolveProgress()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local r  = pg and pg:FindFirstChild("Rebirth")
	local em = r and r:FindFirstChild("EvolutionMenu")
	local body = em and em:FindFirstChild("Body")
	local p  = body and body:FindFirstChild("Progress")
	if not p then return nil end
	return tonumber(tostring(p.Text):match("[%d%.]+"))
end

task.spawn(function()
	while true do
		task.wait(0.5)
		if AutoEvolve and not evolveBusy then
			local remote   = getEvolveRemote()
			local progress = getEvolveProgress()
			if remote and progress and progress >= EvolveAt then
				evolveBusy = true
				pcall(function()
					local done   = false
					local signal = getEvolvedSignal()
					local conn
					if signal and signal:IsA("RemoteEvent") then
						conn = signal.OnClientEvent:Connect(function() done = true end)
					end
					remote:InvokeServer()
					stats.evolves = stats.evolves + 1
					local t = 0
					while not done and t < EvolveTimeout do
						task.wait(0.1); t = t + 0.1
					end
					if conn then conn:Disconnect() end
				end)
				task.wait(EvolveCooldown)
				evolveBusy = false
			end
		end
	end
end)

local function pullAllLevers()
	local char = LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return 0 end
	local map   = workspace:FindFirstChild("Map")
	local sewer = map and map:FindFirstChild("Sewer")
	local root  = sewer or workspace
	local pulled = 0
	for _, o in ipairs(root:GetDescendants()) do
		if o:IsA("BasePart") and (o.Name == "Lever" or string.find(string.lower(o.Name), "lever", 1, true)) then
			pcall(function()
				firetouchinterest(hrp, o, 0)
				firetouchinterest(hrp, o, 1)
			end)
			pulled = pulled + 1
		end
	end
	if sewer then
		for _, o in ipairs(sewer:GetDescendants()) do
			if o:IsA("BasePart") and (o.Name == "VineKey" or o.Name == "UFOKey") then
				pcall(function()
					firetouchinterest(hrp, o, 0)
					firetouchinterest(hrp, o, 1)
				end)
			end
		end
	end
	return pulled
end

local function touchPart(hrp, part)
	pcall(function()
		firetouchinterest(hrp, part, 0)
		firetouchinterest(hrp, part, 1)
	end)
end

local function doSewerRun()
	local char = LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false, "no character" end
	local map   = workspace:FindFirstChild("Map")
	local sewer = map and map:FindFirstChild("Sewer")
	if not sewer then return false, "sewer not loaded" end
	for _, o in ipairs(sewer:GetDescendants()) do
		if o:IsA("BasePart") and string.find(string.lower(o.Name), "lever", 1, true) then
			touchPart(hrp, o)
		end
	end
	for _, folderName in ipairs({ "CashVine", "SewerAlien" }) do
		local folder = sewer:FindFirstChild(folderName)
		if folder then
			for _, o in ipairs(folder:GetDescendants()) do
				if o:IsA("BasePart") and (o.Name == "VineKey" or o.Name == "UFOKey") then
					touchPart(hrp, o)
				end
			end
		end
	end
	task.wait(0.3)
	local cashVine = sewer:FindFirstChild("CashVine")
	if cashVine then
		local vineDoor = cashVine:FindFirstChild("VineDoor")
		if vineDoor then
			for _, o in ipairs(vineDoor:GetDescendants()) do
				if o:IsA("BasePart") then touchPart(hrp, o) end
			end
		end
	end
	task.wait(0.3)
	if cashVine then
		local vineModel = cashVine:FindFirstChild("CashVine")
		if vineModel then
			local pivot = vineModel:GetPivot()
			pcall(function() hrp.CFrame = pivot + Vector3.new(0, 3, 0) end)
			task.wait(0.2)
			for _, o in ipairs(vineModel:GetDescendants()) do
				if o:IsA("BasePart") then touchPart(hrp, o) end
			end
		end
	end
	return true
end

local SEWER_ALIEN_POS = Vector3.new(-42, -41, 180)
local function teleportToAlien()
	local char = LocalPlayer.Character
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false, "no character" end
	pcall(function() hrp.CFrame = CFrame.new(SEWER_ALIEN_POS) end)
	return true
end

local Trees = {}

local function addTree(obj)
	if obj:IsA("Model") and obj.Name == "LemonTree" then
		if not table.find(Trees, obj) then
			table.insert(Trees, obj)
		end
	end
end

local function removeTree(obj)
	local index = table.find(Trees, obj)
	if index then
		table.remove(Trees, index)
	end
end

for _, v in ipairs(workspace:GetDescendants()) do
	addTree(v)
end

workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(removeTree)

local function noCollisionTree(tree)
	for _, obj in ipairs(tree:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.CanCollide = false
		end
	end
end

local function teleportToTree(tree)
	local character = LocalPlayer.Character
	if not character then return false end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local cf = tree:GetPivot()
	hrp.CFrame = cf + Vector3.new(0, 5, 0)
	return true
end

local function collectFruit(tree)
	noCollisionTree(tree)
	local success = teleportToTree(tree)
	if not success then return end
	for _, obj in ipairs(tree:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Fruit" then
			obj.CanCollide = false
			local clickPart = obj:FindFirstChild("ClickPart")
			if clickPart then
				local detector = clickPart:FindFirstChildOfClass("ClickDetector")
				if detector then
					task.wait(0.45)
					pcall(function()
						fireclickdetector(detector)
					end)
					stats.fruit = stats.fruit + 1
				end
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.1)
		if AutoFruit then
			for _, tree in ipairs(Trees) do
				if not AutoFruit then break end
				if tree and tree.Parent then
					pcall(function() collectFruit(tree) end)
				end
			end
		end
	end
end)

task.spawn(function()
	local remotes = userTycoon:FindFirstChild("Remotes")
	local phone   = remotes and remotes:WaitForChild("PhoneOffer", 30)
	if not phone then return end
	local function accept()
		if AutoPhoneOffers then
			pcall(function() phone:FireServer("Accept") end)
			stats.phone = stats.phone + 1
		end
	end
	phone.OnClientEvent:Connect(function(v)
		if type(v) == "number" then accept() end
	end)
	while true do
		task.wait(0.5)
		if AutoPhoneOffers then
			local po, cur = comp(CompClass.PhoneOffers)
			if po then pcall(function() cur = po:GetCurrentOffer() end) end
			if type(cur) == "number" then accept() end
		end
	end
end)

local AscendCooldown = 2
local AscendTimeout  = 8
local ascendBusy     = false

local function getAscendRemote()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Ascend")
end
local function getAscendedSignal()
	local remotes = userTycoon:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("Ascended")
end

task.spawn(function()
	while true do
		task.wait(0.5)
		if AutoAscend and not ascendBusy then
			local remote   = getAscendRemote()
			local asc      = comp(CompClass.Ascension)
			local progress
			if asc then pcall(function() progress = asc:GetAscensionProgress() end) end
			if remote and progress and progress >= 1 then
				ascendBusy = true
				pcall(function()
					local done   = false
					local signal = getAscendedSignal()
					local conn
					if signal and signal:IsA("RemoteEvent") then
						conn = signal.OnClientEvent:Connect(function() done = true end)
					end
					remote:InvokeServer()
					stats.ascends = stats.ascends + 1
					local t = 0
					while not done and t < AscendTimeout do
						task.wait(0.1); t = t + 0.1
					end
					if conn then conn:Disconnect() end
				end)
				task.wait(AscendCooldown)
				ascendBusy = false
			end
		end
	end
end)

Tabs.Main:Section({ Title = "Buy" })

Tabs.Main:Toggle({
	Title = "Auto Buy",
	Default = false,
	Callback = function(Value)
		AutoBuy = Value
	end,
})

Tabs.Main:Section({ Title = "Upgarde" })

Tabs.Main:Toggle({
	Title = "Auto Upgrade",
	Default = false,
	Callback = function(Value)
		AutoUpgrade = Value
	end,
})

Tabs.Main:Section({ Title = "Fruit" })

Tabs.Main:Toggle({
	Title = "Auto Fruit",
	Default = false,
	Callback = function(Value)
		AutoFruit = Value
	end,
})

Tabs.Main:Section({ Title = "Rebirth" })

Tabs.Main:Toggle({
	Title = "Auto Rebirth",
	Default = false,
	Callback = function(Value)
		AutoRebirth = Value
	end,
})

Tabs.Main:Toggle({
	Title = "Rebirth only at big multiple",
	Default = false,
	Callback = function(Value)
		RebirthMultMode = Value
	end,
})

Tabs.Main:Input({
	Title = "Rebirth at this many x current investors",
	Default = "10",
	Placeholder = "e.g. 10",
	MultiLine = false,
	Callback = function(Text)
		local n = tonumber((tostring(Text):gsub("[^%d%.]", "")))
		if n and n > 0 then
			RebirthInvestorMultiple = n
		end
	end,
})

Tabs.Main:Section({ Title = "Manual" })

Tabs.Main:Button({
	Title = "Pull All Levers",
	Callback = function()
		pullAllLevers()
	end,
})

Tabs.Main:Button({
	Title = "Vine Harvest",
	Callback = function()
		task.spawn(function()
			doSewerRun()
		end)
	end,
})

Tabs.Main:Button({
	Title = "Teleport to Sewer Alien",
	Callback = function()
		teleportToAlien()
	end,
})


Tabs.Auto:Section({ Title = "Auto Evolve" })

Tabs.Auto:Toggle({
	Title = "Auto Evolve",
	Default = false,
	Callback = function(Value)
		AutoEvolve = Value
	end,
})

Tabs.Auto:Section({ Title = "Auto Ascend" })

Tabs.Auto:Toggle({
	Title = "Auto Ascend",
	Default = false,
	Callback = function(Value)
		AutoAscend = Value
	end,
})

Tabs.Auto:Section({ Title = "Auto Offers Phone" })

Tabs.Auto:Toggle({
	Title = "Auto Accept Phone Offers",
	Default = false,
	Callback = function(Value)
		AutoPhoneOffers = Value
	end,
})

Tabs.Main:Toggle({
	Title = "Auto Power Level",
	Default = false,
	Callback = function(Value)
		AutoPowerLevel = Value
	end,
})


local PanelVisible = true
local statusGui = nil
 
local function destroyStatusPanel()
	if statusGui then
		pcall(function() statusGui:Destroy() end)
		statusGui = nil
	end
end
 
local function createStatusPanel()
	destroyStatusPanel()
 
	local parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not parent then
		local okh, hui = pcall(function() return gethui() end)
		parent = (okh and hui) or game:GetService("CoreGui")
	end
 
	local gui = Instance.new("ScreenGui")
	gui.Name = "AutoStatusGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 9999
	gui.Parent = parent
	statusGui = gui
 
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 210, 0, 210)
	frame.Position = UDim2.new(0, 10, 0, 90)
	frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
 
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(57, 255, 20)
	stroke.Thickness = 1.5
	stroke.Transparency = 0
	stroke.Parent = frame
 
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 26)
	title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	title.BorderSizePixel = 0
	title.Text = "AUTO STATUS"
	title.TextColor3 = Color3.fromRGB(57, 255, 20)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.Parent = frame
	Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)
 
	local body = Instance.new("TextLabel")
	body.Size = UDim2.new(1, -14, 1, -32)
	body.Position = UDim2.new(0, 8, 0, 30)
	body.BackgroundTransparency = 1
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.TextYAlignment = Enum.TextYAlignment.Top
	body.RichText = true
	body.Text = "starting..."
	body.TextColor3 = Color3.fromRGB(57, 255, 20)
	body.Font = Enum.Font.Code
	body.TextSize = 12
	body.Parent = frame
 
	local UIS = game:GetService("UserInputService")
	local dragging, ds, sp
	title.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
			dragging, ds, sp = true, i.Position, frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
			or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - ds
			frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
 
	local RunService = game:GetService("RunService")
	local frames, fps, fpsT = 0, 0, tick()
	RunService.RenderStepped:Connect(function()
		frames = frames + 1
		if tick() - fpsT >= 1 then fps, frames, fpsT = frames, 0, tick() end
	end)
 
	local function on(b) return b and "<font color='#39FF14'>ON</font>" or "<font color='#444'>off</font>" end
 
	task.spawn(function()
		while gui.Parent and PanelVisible do
			local cashStr = "?"
			local ls = LocalPlayer:FindFirstChild("leaderstats")
			local c  = ls and ls:FindFirstChild("Cash")
			if c then cashStr = tostring(c.Value) end
			body.Text = string.format(
				"FPS:  %d\nCash: %s\n"
				.. "Buys:  %d  %s\nUpgr:  %d  %s\nFruit: %d  %s\nReb:   %d  %s\nEvo:   %d  %s\n"
				.. "Asc:   %d  %s\nPhone: %d  %s",
				fps, cashStr,
				stats.buys,     on(AutoBuy),
				stats.upgrades, on(AutoUpgrade),
				stats.fruit,    on(AutoFruit),
				stats.rebirths, on(AutoRebirth),
				stats.evolves,  on(AutoEvolve),
				stats.ascends,  on(AutoAscend),
				stats.phone,    on(AutoPhoneOffers)
			)
			task.wait(0.25)
		end
	end)
end
 
createStatusPanel()

Tabs.Panel:Section({ Title = "Live Status Panel" })

Tabs.Panel:Paragraph({
	Title = "Info Panel",
	Desc = "A small on-screen panel that displays live auto counters (buys, upgrades, fruit, etc.). It can be dragged and turned on/off at any time."
})

Tabs.Panel:Toggle({
	Title = "Status Panel",
	Default = true,
	Callback = function(Value)
		PanelVisible = Value
		if Value then
			if not statusGui or not statusGui.Parent then
				createStatusPanel()
			end
		else
			destroyStatusPanel()
		end
	end,
})

Tabs.Panel:Button({
	Title = "Reset Counter Stats",
	Callback = function()
		stats.buys     = 0
		stats.upgrades = 0
		stats.fruit    = 0
		stats.rebirths = 0
		stats.evolves  = 0
		stats.ascends  = 0
		stats.phone    = 0
	end,
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

Tabs.Settings:Paragraph({
    Title = "Current Server",
    Desc = "You are in server: " .. game.JobId
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
            inputObj = input
        end
    end
})

Tabs.Settings:Button({
    Title = "Teleport",
    Callback = function()
        local target = inputObj
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
