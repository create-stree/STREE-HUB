local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to loaded!")
    return
else
    print("✓ UI loaded successfully!")
end

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

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://86466533300907",
    Author = "KirsiaSC | The Forge",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },
})

Window:EditOpenButton({
    Enabled = false,
})

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local G2L = {}

G2L["ScreenGui_1"] = Instance.new("ScreenGui")
G2L["ScreenGui_1"].Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
G2L["ScreenGui_1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CollectionService:AddTag(G2L["ScreenGui_1"], "main")

G2L["ButtonRezise_2"] = Instance.new("ImageButton")
G2L["ButtonRezise_2"].Parent = G2L["ScreenGui_1"]
G2L["ButtonRezise_2"].BorderSizePixel = 0
G2L["ButtonRezise_2"].Draggable = true
G2L["ButtonRezise_2"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
G2L["ButtonRezise_2"].Image = "rbxassetid://123032091977400"
G2L["ButtonRezise_2"].Size = UDim2.new(0, 40, 0, 40)
G2L["ButtonRezise_2"].Position = UDim2.new(0.13, 0, 0.03, 0)

local corner = Instance.new("UICorner", G2L["ButtonRezise_2"])
corner.CornerRadius = UDim.new(0, 8)

local neon = Instance.new("UIStroke", G2L["ButtonRezise_2"])
neon.Thickness = 2
neon.Color = Color3.fromRGB(0, 255, 0)
neon.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

G2L["ButtonRezise_2"].MouseButton1Click:Connect(function()
    G2L["ButtonRezise_2"].Visible = false
    Window:Open()
end)

Window:OnClose(function()
    G2L["ButtonRezise_2"].Visible = true
end)

Window:OnDestroy(function()
    G2L["ButtonRezise_2"].Visible = false
end)

G2L["ButtonRezise_2"].Visible = false

G2L["ButtonRezise_2"].Visible = false

Window:Tag({
    Title = "Version",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Dev",
    Color = Color3.fromRGB(0, 0, 0),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info",
})

local Section = Tab1:Section({
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Divider()

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Divider()

Tab1:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tab1:Keybind({
    Title = "Close/Open UI",
    Desc = "Keybind to Close/Open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

local oreFarm = {
	enabled = false,
	tweenSpeed = 120,
	selectedRockTypes = {},
	selectedOreTypes = {},
	rocksESPEnabled = false,
	pickaxeName = "?",
	pickaxeDamage = 0,
	maxRockTime = 4,
	mineInterval = 0.1,
	scanDistance = 500,
}

Tab2:Slider({
    Title = "Scan Distance",
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        oreFarm.scanDistance = value
    end
})

Tab2:Slider({
    Title = "Tween Speed",
    Step = 1,
    Value = {
        Min = 20,
        Max = 100,
        Default = 30,
    },
    Callback = function(value)
        oreFarm.scanDistance = value
    end
})

local function buildRockOptions()
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local rocksFolder = assets and assets:FindFirstChild("Rocks")
	local options = {}
	if rocksFolder then
		for _, rock in ipairs(rocksFolder:GetChildren()) do
			if rock.Name and rock.Name ~= "" then
				table.insert(options, rock.Name)
			end
		end
	end
	table.sort(options)
	if #options == 0 then
		warn("[Forge] No rock templates found in ReplicatedStorage.Assets.Rocks")
	end
	return options
end

local function buildOreOptions()
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local oresFolder = assets and assets:FindFirstChild("Ores")
	local options = {}
	if oresFolder then
		for _, ore in ipairs(oresFolder:GetChildren()) do
			if ore.Name and ore.Name ~= "" then
				table.insert(options, ore.Name)
			end
		end
	end
	table.sort(options)
	return options
end

local rockOptions = buildRockOptions()
local oreOptions = buildOreOptions()

if #rockOptions == 0 then
	table.insert(rockOptions, "Boulder")
end

if #oreOptions == 0 then
	table.insert(oreOptions, "Any")
end

oreFarm.selectedRockTypes = { rockOptions[1] }
oreFarm.selectedOreTypes = { oreOptions[1] }

local function listToSet(list)
	local set = {}
	for _, v in ipairs(list) do
		set[tostring(v)] = true
	end
	return set
end

local RockTypeDropdown

local function RefreshRockOptions()
	rockOptions = buildRockOptions()
	if #rockOptions == 0 then
		rockOptions = { "Boulder" }
	end
	if not oreFarm.selectedRockTypes or #oreFarm.selectedRockTypes == 0 then
		oreFarm.selectedRockTypes = { rockOptions[1] }
	end
	if RockTypeDropdown then
		RockTypeDropdown:Set({
			Options = rockOptions,
			CurrentOption = oreFarm.selectedRockTypes,
		})
	end
end

Tab2:Dropdown({
    Title = "Rock Types to Farm",
    Values = oreFarm.selectedRockTypes,
    Value = rockOptions,
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        if type(opts) == "table" and #opts > 0 then
		    oreFarm.selectedRockTypes = opts
        end
    end
})

Tab2:Button({
    Title = "Refresh Rock Types",
    Locked = false,
    Callback = function()
        RefreshRockOptions()
    end
})

Tab2:Dropdown({
    Title = "Ore Types to Farm",
    Values = oreFarm.selectedOreTypes,
    Value = oreOptions,
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        if type(opts) == "table" and #opts > 0 then
			oreFarm.selectedOreTypes = opts
        end
    end
})

Tab2:Slider({
    Title = "Max Time Per Rock (s)",
    Step = 1,
    Value = {
        Min = 20,
        Max = 100,
        Default = 30,
    },
    Callback = function(value)
        oreFarm.maxRockTime = value
    end
})

Tab2:Slider({
    Title = "Mine Interval (s)",
    Step = 1,
    Value = {
        Min = 20,
        Max = 100,
        Default = 30,
    },
    Callback = function(value)
        oreFarm.mineInterval = value
    end
})
