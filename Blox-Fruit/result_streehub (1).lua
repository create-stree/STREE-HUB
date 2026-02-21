-- [[ Load StreeHub UI ]]
local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

-- [[ Load Window ]]
local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Example",
    Color   = Color3.fromRGB(57, 255, 20),
    Images  = "128806139932217",
    Theme   = 122376116281975,
    ThemeTransparency = 0.15,
    ["Tab Width"] = 120,
    Version = 1,
})

-- [[ Notify Function ]]
local function notify(msg, delay, color, title, desc)
    return StreeHub:MakeNotify({
        Title = title or "StreeHub",
        Description = desc or "Notification",
        Content = msg or "Content",
        Color = color or Color3.fromRGB(57, 255, 20),
        Delay = delay or 4
    })
end

-- [[ Make Tabs ]]
local Tabs = {
    Main = Window:AddTab({ Name = "Main", Icon = "house" }),
    Others = Window:AddTab({ Name = "Others", Icon = "inbox" }),
    Settings = Window:AddTab({ Name = "Settings", Icon = "settings" }),
    Items = Window:AddTab({ Name = "Items", Icon = "box" }),
    Stats = Window:AddTab({ Name = "Stats", Icon = "chart-no-axes-column" }),
    Raid = Window:AddTab({ Name = "Raid", Icon = "zap" }),
    Race = Window:AddTab({ Name = "Race", Icon = "bot" }),
    Teleport = Window:AddTab({ Name = "Teleport", Icon = "map-pin" }),
    Shop = Window:AddTab({ Name = "Shop", Icon = "shopping-cart" }),
    Combat = Window:AddTab({ Name = "Combat", Icon = "sword" }),
    Esp = Window:AddTab({ Name = "Esp", Icon = "eye" }),
    Dragon_Dojo = Window:AddTab({ Name = "Dragon Dojo", Icon = "shield" }),
    Sea_Event = Window:AddTab({ Name = "Sea Event", Icon = "anchor" }),
    Sea_Stack = Window:AddTab({ Name = "Sea Stack", Icon = "waves" }),
    Local_Player = Window:AddTab({ Name = "Local Player", Icon = "user" }),
    Fruit = Window:AddTab({ Name = "Fruit", Icon = "flask-conical" }),
    Misc = Window:AddTab({ Name = "Misc", Icon = "layout-grid" }),
    Server = Window:AddTab({ Name = "Server", Icon = "server" }),
}

-- [[ Main > Info ]]
local Sec_41 = Tabs.Main:AddSection("Info")
Sec_41:AddParagraph({
    Title = "Game Time",
    Content = "0",
})
Sec_41:AddParagraph({
    Title = "Fps",
    Content = "0",
})
Sec_41:AddParagraph({
    Title = "Ping",
    Content = "0",
})
Sec_41:AddParagraph({
    Title = "Discord Server",
    Content = "-",
})
Sec_41:AddButton({
    Title = "Copy Link",
    Callback = function()
    end
})

-- [[ Main > Auto Farm ]]
local Sec_47 = Tabs.Main:AddSection("Auto Farm")
Sec_47:AddDropdown({
    Title = "Weapon",
    Options = {},
    Callback = function(value)
    end
})
Sec_47:AddToggle({
    Title = "Auto Farm Level",
    Default = false,
    Callback = function(state)
    end
})
Sec_47:AddToggle({
    Title = "Auto Farm Nearest",
    Content = "Attack Nearest Mob",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Main > Valentine Event ]]
local Sec_59 = Tabs.Main:AddSection("Valentine Event")
Sec_59:AddToggle({
    Title = "Auto Farm Hearts",
    Content = "Auto Farm Last Island",
    Default = false,
    Callback = function(state)
    end
})
Sec_59:AddParagraph({
    Title = "Cupid Quest",
    Content = "-",
})
Sec_59:AddToggle({
    Title = "Auto Cupid Quest",
    Content = "Auto Complete Cupid Quest",
    Default = false,
    Callback = function(state)
    end
})
Sec_59:AddToggle({
    Title = "Auto Delivery Quest",
    Content = "Auto Complete Delivery Quest",
    Default = false,
    Callback = function(state)
    end
})
Sec_59:AddDivider()
Sec_59:AddParagraph({
    Title = "Hearts",
    Content = "-",
})
Sec_59:AddDropdown({
    Title = "Valentine Shop",
    Options = {},
    Callback = function(value)
    end
})
Sec_59:AddButton({
    Title = "Refresh Shop",
    Callback = function()
    end
})
Sec_59:AddParagraph({
    Title = "Item Price",
    Content = "-",
})
Sec_59:AddButton({
    Title = "Buy Item",
    Callback = function()
    end
})
Sec_59:AddToggle({
    Title = "Auto Valentines Gacha",
    Content = "Need 250 Hearts",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Main > Mastery Farm ]]
local Sec_72 = Tabs.Main:AddSection("Mastery Farm")
Sec_72:AddDropdown({
    Title = "Choose Method",
    Options = {},
    Callback = function(value)
    end
})
Sec_72:AddToggle({
    Title = "Auto Fruit Mastery",
    Content = "Kill Mon With Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_72:AddToggle({
    Title = "Auto Gun Mastery",
    Content = "Kill Mon With Gun",
    Default = false,
    Callback = function(state)
    end
})
Sec_72:AddDropdown({
    Title = "Choose Sword",
    Options = {},
    Callback = function(value)
    end
})
Sec_72:AddToggle({
    Title = "Auto Sword Mastery",
    Content = "Kill Mon With Sword",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Main > Tyrant Of The Skies ]]
local Sec_90 = Tabs.Main:AddSection("Tyrant Of The Skies")
Sec_90:AddParagraph({
    Title = "Eyes",
    Content = "0/4",
})
Sec_90:AddToggle({
    Title = "Auto Boss",
    Content = "Auto Tyrant Of The Skies",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Main > Mon Farm ]]
local Sec_95 = Tabs.Main:AddSection("Mon Farm")
Sec_95:AddDropdown({
    Title = "Choose Mon",
    Options = {},
    Callback = function(value)
    end
})
Sec_95:AddToggle({
    Title = "Auto Farm Mon",
    Content = "Auto Kill Mon When Spawn",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Main > Berry ]]
local Sec_102 = Tabs.Main:AddSection("Berry")
Sec_102:AddToggle({
    Title = "Auto Collect Berry",
    Content = "Auto Collect Berry",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Main > Boss Farm ]]
local Sec_106 = Tabs.Main:AddSection("Boss Farm")
Sec_106:AddParagraph({
    Title = "Boss Status",
    Content = "-",
})
Sec_106:AddDropdown({
    Title = "Choose Boss",
    Options = {},
    Callback = function(value)
    end
})
Sec_106:AddToggle({
    Title = "Auto Farm Boss",
    Content = "Auto Kill Boss When Spawn",
    Default = false,
    Callback = function(state)
    end
})
Sec_106:AddToggle({
    Title = "Auto Farm All Boss",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Others > Elite Hunter ]]
local Sec_117 = Tabs.Others:AddSection("Elite Hunter")
Sec_117:AddParagraph({
    Title = "Elite Hunter Status",
    Content = "-",
})
Sec_117:AddParagraph({
    Title = "Elite Hunter Progress",
    Content = "-",
})
Sec_117:AddToggle({
    Title = "Auto Elite Hunter",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_117:AddToggle({
    Title = "Auto Elite Hunter Hop",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Others > Bone Farm ]]
local Sec_126 = Tabs.Others:AddSection("Bone Farm")
Sec_126:AddDropdown({
    Title = "Choose Method",
    Options = {},
    Callback = function(value)
    end
})
Sec_126:AddParagraph({
    Title = "Bones Owned",
    Content = "-",
})
Sec_126:AddToggle({
    Title = "Auto Farm Bone",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_126:AddToggle({
    Title = "Auto Random Surprise",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Others > Pirate Raid ]]
local Sec_139 = Tabs.Others:AddSection("Pirate Raid")
Sec_139:AddToggle({
    Title = "Auto Pirate Raid",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Others > Chest Farm ]]
local Sec_143 = Tabs.Others:AddSection("Chest Farm")
Sec_143:AddToggle({
    Title = "Auto Farm Chest Tween",
    Content = "Tween to chest",
    Default = false,
    Callback = function(state)
    end
})
Sec_143:AddToggle({
    Title = "Auto Farm Chest Instant",
    Content = "Instant to chest",
    Default = false,
    Callback = function(state)
    end
})
Sec_143:AddToggle({
    Title = "Auto Stop Items",
    Content = "Stop When Get God's Chalice or FoD",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Others > Cake Prince ]]
local Sec_153 = Tabs.Others:AddSection("Cake Prince")
Sec_153:AddParagraph({
    Title = "Cake Prince Status",
    Content = "-",
})
Sec_153:AddToggle({
    Title = "Auto Katakuri",
    Content = "Auto Farm + Kill Cake Prince [ Sea 3 Only ]",
    Default = false,
    Callback = function(state)
    end
})
Sec_153:AddToggle({
    Title = "Auto Spawn Cake Prince",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_153:AddToggle({
    Title = "Auto Kill Cake Prince",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_153:AddToggle({
    Title = "Auto Kill Dough King",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Others > Materials ]]
local Sec_167 = Tabs.Others:AddSection("Materials")
Sec_167:AddDropdown({
    Title = "Choose Material",
    Options = {},
    Callback = function(value)
    end
})
Sec_167:AddToggle({
    Title = "Auto Farm Material",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Settings > Settings ]]
local Sec_176 = Tabs.Settings:AddSection("Settings")
Sec_176:AddToggle({
    Title = "Spin Position",
    Content = "Spin Position When Farm",
    Default = false,
    Callback = function(state)
    end
})
Sec_176:AddSlider({
    Title = "Farm Distance",
    Min = 10,
    Max = 50,
    Increment = 1,
    Default = 35,
    Callback = function(value)
    end
})
Sec_176:AddSlider({
    Title = "Player Tween Speed",
    Min = 50,
    Max = 350,
    Increment = 1,
    Default = 300,
    Callback = function(value)
    end
})
Sec_176:AddToggle({
    Title = "Bring Mob",
    Default = true,
    Callback = function(state)
    end
})
Sec_176:AddDropdown({
    Title = "Bring Mob",
    Options = {},
    Callback = function(value)
    end
})
Sec_176:AddToggle({
    Title = "Atatck Aura",
    Content = "Attack Nearest Enemies",
    Default = true,
    Callback = function(state)
    end
})

-- [[ Settings > Graphic ]]
local Sec_201 = Tabs.Settings:AddSection("Graphic")
Sec_201:AddToggle({
    Title = "Hide Notification",
    Default = false,
    Callback = function(state)
    end
})
Sec_201:AddToggle({
    Title = "Hide Damage Text",
    Default = false,
    Callback = function(state)
    end
})
Sec_201:AddToggle({
    Title = "Black Screen",
    Default = false,
    Callback = function(state)
    end
})
Sec_201:AddToggle({
    Title = "White Screen",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Settings > Mastery ]]
local Sec_212 = Tabs.Settings:AddSection("Mastery")
Sec_212:AddSlider({
    Title = "Mastery Health %",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = 25,
    Callback = function(value)
    end
})
Sec_212:AddParagraph({
    Title = "Devil Fruit Skill",
    Content = "-",
})
Sec_212:AddDropdown({
    Title = "Choose Fruit Skill",
    Options = {},
    Callback = function(value)
    end
})
Sec_212:AddParagraph({
    Title = "Gun Skill",
    Content = "-",
})
Sec_212:AddDropdown({
    Title = "Choose Gun Skill",
    Options = {},
    Callback = function(value)
    end
})

-- [[ Settings > Others ]]
local Sec_226 = Tabs.Settings:AddSection("Others")
Sec_226:AddToggle({
    Title = "Auto Set Spawn Point",
    Default = true,
    Callback = function(state)
    end
})
Sec_226:AddToggle({
    Title = "Auto Observation",
    Default = false,
    Callback = function(state)
    end
})
Sec_226:AddToggle({
    Title = "Auto Haki",
    Default = false,
    Callback = function(state)
    end
})
Sec_226:AddToggle({
    Title = "Auto Rejoin",
    Default = true,
    Callback = function(state)
    end
})

-- [[ Settings > Sea Event ]]
local Sec_239 = Tabs.Settings:AddSection("Sea Event")
Sec_239:AddToggle({
    Title = "Lightning",
    Default = false,
    Callback = function(state)
    end
})
Sec_239:AddDropdown({
    Title = "Tools",
    Options = {},
    Callback = function(value)
    end
})
Sec_239:AddDropdown({
    Title = "Devil Fruit",
    Options = {},
    Callback = function(value)
    end
})
Sec_239:AddDropdown({
    Title = "Melee",
    Options = {},
    Callback = function(value)
    end
})

-- [[ Items > World ]]
local Sec_248 = Tabs.Items:AddSection("World")
Sec_248:AddToggle({
    Title = "Auto Second Sea",
    Content = "Function Sea 1 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_248:AddToggle({
    Title = "Auto Third Sea",
    Content = "Function Sea 2 Only",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Items > Fighting Style ]]
local Sec_255 = Tabs.Items:AddSection("Fighting Style")
Sec_255:AddToggle({
    Title = "Auto Super Human",
    Default = false,
    Callback = function(state)
    end
})
Sec_255:AddToggle({
    Title = "Auto Death Step",
    Default = false,
    Callback = function(state)
    end
})
Sec_255:AddToggle({
    Title = "Auto Sharkman Karate",
    Default = false,
    Callback = function(state)
    end
})
Sec_255:AddToggle({
    Title = "Auto Electric Claw",
    Default = false,
    Callback = function(state)
    end
})
Sec_255:AddToggle({
    Title = "Auto Dragon Talon",
    Default = false,
    Callback = function(state)
    end
})
Sec_255:AddToggle({
    Title = "Auto God Human",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Items > Gun & Sword ]]
local Sec_274 = Tabs.Items:AddSection("Gun & Sword")
Sec_274:AddToggle({
    Title = "Auto Get Saber",
    Content = "Function Sea 1 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Buddy Sword",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Soul Guitar",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Rengoku",
    Content = "Function Sea 2 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Hallow Scythe",
    Content = "Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Warden Sword",
    Content = "Function Sea 1 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Get Yama",
    Content = "Need 30 Elite Hunter, Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Get Yama Hop",
    Content = "Hop If Elite Hunter Not Spawn",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Get Tushita",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddParagraph({
    Title = "Cursed Dual Katana",
    Content = "Status : -",
})
Sec_274:AddToggle({
    Title = "Auto Get CDK",
    Content = "Last Quest",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Quest CDK [ Yama ]",
    Content = "Yama Quest",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Quest CDK [ Tushita ]",
    Content = "Tushita Quest",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Dragon Trident",
    Content = "Function Sea 2 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Greybeard",
    Content = "Function Sea 1 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Shark Saw",
    Content = "Function Sea 1 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Pole",
    Content = "Function Sea 1 Only",
    Default = false,
    Callback = function(state)
    end
})
Sec_274:AddToggle({
    Title = "Auto Dark Dagger",
    Content = "Need Spawn Rip Indra, Function Sea 3 Only",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Stats > Stats ]]
local Sec_327 = Tabs.Stats:AddSection("Stats")
Sec_327:AddParagraph({
    Title = "Stats",
    Content = "0",
})
Sec_327:AddToggle({
    Title = "Add Melee Stats",
    Default = false,
    Callback = function(state)
    end
})
Sec_327:AddToggle({
    Title = "Add Defense Stats",
    Default = false,
    Callback = function(state)
    end
})
Sec_327:AddToggle({
    Title = "Add Sword Stats",
    Default = false,
    Callback = function(state)
    end
})
Sec_327:AddToggle({
    Title = "Add Gun Stats",
    Default = false,
    Callback = function(state)
    end
})
Sec_327:AddToggle({
    Title = "Add Devil Fruit Stats",
    Default = false,
    Callback = function(state)
    end
})
Sec_327:AddSlider({
    Title = "Point",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = 1,
    Callback = function(value)
    end
})

-- [[ Raid > Raid ]]
local Sec_349 = Tabs.Raid:AddSection("Raid")
Sec_349:AddParagraph({
    Title = "Raid Time",
    Content = "-",
})
Sec_349:AddParagraph({
    Title = "Island",
    Content = "-",
})
Sec_349:AddDropdown({
    Title = "Choose Chip",
    Options = {},
    Callback = function(value)
    end
})
Sec_349:AddToggle({
    Title = "Auto Raid",
    Content = "Complete automatically",
    Default = false,
    Callback = function(state)
    end
})
Sec_349:AddToggle({
    Title = "Auto Awaken",
    Default = false,
    Callback = function(state)
    end
})
Sec_349:AddDropdown({
    Title = "Unstore Rarity Fruit",
    Options = {},
    Callback = function(value)
    end
})
Sec_349:AddToggle({
    Title = "Auto Unstore Devil Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_349:AddButton({
    Title = "Teleport To Lab",
    Callback = function()
    end
})

-- [[ Raid > Law Raid ]]
local Sec_368 = Tabs.Raid:AddSection("Law Raid")
Sec_368:AddToggle({
    Title = "Auto Law Raid",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Raid > Dungeon ]]
local Sec_372 = Tabs.Raid:AddSection("Dungeon")
Sec_372:AddButton({
    Title = "Telpeort To Dungeon Hub",
    Callback = function()
    end
})
Sec_372:AddToggle({
    Title = "Auto Attack Mon",
    Content = "Auto Attack Nearest",
    Default = false,
    Callback = function(state)
    end
})
Sec_372:AddToggle({
    Title = "Auto Next Floor",
    Content = "Instant Teleport To Highest Floor",
    Default = false,
    Callback = function(state)
    end
})
Sec_372:AddToggle({
    Title = "Auto Return To Hub",
    Content = "Return To Hub When Dungeon Done",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Race > Teleport ]]
local Sec_377 = Tabs.Race:AddSection("Teleport")
Sec_377:AddDropdown({
    Title = "Selected Place",
    Options = {},
    Callback = function(value)
    end
})
Sec_377:AddToggle({
    Title = "Teleport To Place",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Race > Race ]]
local Sec_382 = Tabs.Race:AddSection("Race")
Sec_382:AddToggle({
    Title = "Auto Buy Gear",
    Default = false,
    Callback = function(state)
    end
})
Sec_382:AddToggle({
    Title = "Tween To Mirage Island",
    Content = "Tween to highest point",
    Default = false,
    Callback = function(state)
    end
})
Sec_382:AddToggle({
    Title = "Find Blue Gear",
    Default = false,
    Callback = function(state)
    end
})
Sec_382:AddToggle({
    Title = "Look Moon & use Ability",
    Default = false,
    Callback = function(state)
    end
})
Sec_382:AddToggle({
    Title = "Auto Train",
    Default = false,
    Callback = function(state)
    end
})
Sec_382:AddButton({
    Title = "Teleport To Race Door",
    Callback = function()
    end
})
Sec_382:AddButton({
    Title = "Buy Acient Quest",
    Callback = function()
    end
})
Sec_382:AddToggle({
    Title = "Auto Trial",
    Default = false,
    Callback = function(state)
    end
})
Sec_382:AddToggle({
    Title = "Auto Kill Player After Trial",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Teleport > World ]]
local Sec_406 = Tabs.Teleport:AddSection("World")
Sec_406:AddButton({
    Title = "Teleport To First Sea",
    Callback = function()
    end
})
Sec_406:AddButton({
    Title = "Teleport To Second Sea",
    Callback = function()
    end
})
Sec_406:AddButton({
    Title = "Teleport To Third Sea",
    Callback = function()
    end
})

-- [[ Shop > Shop ]]
local Sec_410 = Tabs.Shop:AddSection("Shop")
Sec_410:AddToggle({
    Title = "Auto Buy Legendary Sword",
    Default = false,
    Callback = function(state)
    end
})
Sec_410:AddToggle({
    Title = "Auto Buy Haki Color",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Shop > Abilities ]]
local Sec_413 = Tabs.Shop:AddSection("Abilities")
Sec_413:AddButton({
    Title = "Buy Geppo",
    Callback = function()
    end
})
Sec_413:AddButton({
    Title = "Buy Buso Haki",
    Callback = function()
    end
})
Sec_413:AddButton({
    Title = "Buy Soru",
    Callback = function()
    end
})
Sec_413:AddButton({
    Title = "Buy Observation Haki",
    Callback = function()
    end
})

-- [[ Shop > Fighting Style ]]
local Sec_418 = Tabs.Shop:AddSection("Fighting Style")
Sec_418:AddButton({
    Title = "Buy Black Leg",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Electro",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Fishman Karate",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Dragon Claw",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Superhuman",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Death Step",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Sharkman Karate",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Electric Claw",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Dragon Talon",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy God Human",
    Callback = function()
    end
})
Sec_418:AddButton({
    Title = "Buy Sanguine Art",
    Callback = function()
    end
})

-- [[ Shop > Sword ]]
local Sec_430 = Tabs.Shop:AddSection("Sword")
Sec_430:AddButton({
    Title = "Buy Cutlass",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Katana",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Iron Mace",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Dual Katana",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Triple Katana",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Pipe",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Dual Headed Blade",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Bisento",
    Callback = function()
    end
})
Sec_430:AddButton({
    Title = "Buy Soul Cane",
    Callback = function()
    end
})

-- [[ Shop > Gun ]]
local Sec_440 = Tabs.Shop:AddSection("Gun")
Sec_440:AddButton({
    Title = "Buy Slingshot",
    Callback = function()
    end
})
Sec_440:AddButton({
    Title = "Buy Musket",
    Callback = function()
    end
})
Sec_440:AddButton({
    Title = "Buy Flintlock",
    Callback = function()
    end
})
Sec_440:AddButton({
    Title = "Buy Refined Fintlock",
    Callback = function()
    end
})
Sec_440:AddButton({
    Title = "Buy Cannon",
    Callback = function()
    end
})
Sec_440:AddButton({
    Title = "Buy Kabucha",
    Callback = function()
    end
})

-- [[ Shop > Stats ]]
local Sec_447 = Tabs.Shop:AddSection("Stats")
Sec_447:AddButton({
    Title = "Reset Stats",
    Callback = function()
    end
})
Sec_447:AddButton({
    Title = "Random Race",
    Callback = function()
    end
})

-- [[ Shop > Accessories ]]
local Sec_450 = Tabs.Shop:AddSection("Accessories")
Sec_450:AddButton({
    Title = "Buy Black Cape",
    Callback = function()
    end
})
Sec_450:AddButton({
    Title = "Buy Swordsman Hat",
    Callback = function()
    end
})
Sec_450:AddButton({
    Title = "Buy Tomoe Ring",
    Callback = function()
    end
})

-- [[ Combat > Combat ]]
local Sec_454 = Tabs.Combat:AddSection("Combat")
Sec_454:AddParagraph({
    Title = "Players In Server",
    Content = "0",
})
Sec_454:AddDropdown({
    Title = "Choose Player",
    Options = {},
    Callback = function(value)
    end
})
Sec_454:AddButton({
    Title = "Refresh Player",
    Callback = function()
    end
})
Sec_454:AddToggle({
    Title = "Spectate Player",
    Default = false,
    Callback = function(state)
    end
})
Sec_454:AddToggle({
    Title = "Teleport To Player",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Teleport > Island ]]
local Sec_461 = Tabs.Teleport:AddSection("Island")
Sec_461:AddDropdown({
    Title = "Choose Island",
    Options = {},
    Callback = function(value)
    end
})
Sec_461:AddToggle({
    Title = "Teleport To Island",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Teleport > Npc ]]
local Sec_468 = Tabs.Teleport:AddSection("Npc")
Sec_468:AddDropdown({
    Title = "Choose Npc",
    Options = {},
    Callback = function(value)
    end
})
Sec_468:AddToggle({
    Title = "Teleport To Npc",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Esp > Esp ]]
local Sec_475 = Tabs.Esp:AddSection("Esp")
Sec_475:AddToggle({
    Title = "Esp Player",
    Content = "Highlight Player",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Chest",
    Content = "Highlight Chest",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Devil Fruit",
    Content = "Highlight Devil Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Real Fruit",
    Content = "Highlight Real Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Flower",
    Content = "Highlight Flower",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Island",
    Content = "Highlight Island",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Npc",
    Content = "Highlight Npc",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Sea Beast",
    Content = "Highlight SeaBeast",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Monster",
    Content = "Highlight Monster",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Mirage Island",
    Content = "Highlight Mirage Island",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Kitsune Island",
    Content = "Highlight Kitsune Island",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Frozen Dimension",
    Content = "Highlight Frozen Dimension",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Prehistoric Island",
    Content = "Highlight Prehistoric Island",
    Default = false,
    Callback = function(state)
    end
})
Sec_475:AddToggle({
    Title = "Esp Gear",
    Content = "Highlight Gear",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Dragon Dojo > Belt ]]
local Sec_518 = Tabs.Dragon_Dojo:AddSection("Belt")
Sec_518:AddToggle({
    Title = "Auto Dojo Trainer",
    Content = "Upgrade Belt",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Dragon Dojo > Volcanic Magnet ]]
local Sec_520 = Tabs.Dragon_Dojo:AddSection("Volcanic Magnet")
Sec_520:AddToggle({
    Title = "Auto Farm Blaze Ember",
    Content = "Auto Compleate Quest + Collect Blaze Ember [ Sea 3 Only ]",
    Default = false,
    Callback = function(state)
    end
})
Sec_520:AddButton({
    Title = "Craft Volcanic Magnet",
    Callback = function()
    end
})

-- [[ Dragon Dojo > Draco Trial ]]
local Sec_525 = Tabs.Dragon_Dojo:AddSection("Draco Trial")
Sec_525:AddToggle({
    Title = "Upgrade Draco Trial",
    Content = "Teleport and Upgrade Draco Trial",
    Default = false,
    Callback = function(state)
    end
})
Sec_525:AddToggle({
    Title = "Auto Draco V1",
    Content = "Get Dragon Egg & Black Belt",
    Default = false,
    Callback = function(state)
    end
})
Sec_525:AddToggle({
    Title = "Auto Draco V2",
    Content = "Collect Fire Flowers",
    Default = false,
    Callback = function(state)
    end
})
Sec_525:AddToggle({
    Title = "Auto Draco V3",
    Content = "Sail Boat & Attack Terrorshark",
    Default = false,
    Callback = function(state)
    end
})
Sec_525:AddToggle({
    Title = "Teleport To Draco Trials",
    Default = false,
    Callback = function(state)
    end
})
Sec_525:AddToggle({
    Title = "Swap Draco Race",
    Default = false,
    Callback = function(state)
    end
})
Sec_525:AddToggle({
    Title = "Upgrade Dragon Talon",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Event > Sail Boat ]]
local Sec_547 = Tabs.Sea_Event:AddSection("Sail Boat")
Sec_547:AddDropdown({
    Title = "Choose Boat",
    Options = {},
    Callback = function(value)
    end
})
Sec_547:AddDropdown({
    Title = "Choose Zone",
    Options = {},
    Callback = function(value)
    end
})
Sec_547:AddSlider({
    Title = "Boat Tween Speed",
    Min = 50,
    Max = 350,
    Increment = 1,
    Default = 300,
    Callback = function(value)
    end
})
Sec_547:AddToggle({
    Title = "Sail Boat",
    Content = "Auto Sail Boat & Kill Enemies",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Event > Enemies ]]
local Sec_562 = Tabs.Sea_Event:AddSection("Enemies")
Sec_562:AddToggle({
    Title = "Auto Farm Shark",
    Default = false,
    Callback = function(state)
    end
})
Sec_562:AddToggle({
    Title = "Auto Farm Piranha",
    Default = false,
    Callback = function(state)
    end
})
Sec_562:AddToggle({
    Title = "Auto Farm Fish Crew Member",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Event > Boat ]]
local Sec_572 = Tabs.Sea_Event:AddSection("Boat")
Sec_572:AddToggle({
    Title = "Auto Farm Ghost Ship",
    Default = false,
    Callback = function(state)
    end
})
Sec_572:AddToggle({
    Title = "Auto Farm Pirate Brigade",
    Default = false,
    Callback = function(state)
    end
})
Sec_572:AddToggle({
    Title = "Auto Farm Pirate Grand Brigade",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Event > Boss ]]
local Sec_582 = Tabs.Sea_Event:AddSection("Boss")
Sec_582:AddToggle({
    Title = "Auto Farm Terrorshark",
    Default = false,
    Callback = function(state)
    end
})
Sec_582:AddToggle({
    Title = "Auto Farm Seabeasts",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Stack > Prehistoric ]]
local Sec_589 = Tabs.Sea_Stack:AddSection("Prehistoric")
Sec_589:AddParagraph({
    Title = "Prehistoric Status",
    Content = "-",
})
Sec_589:AddToggle({
    Title = "Auto Prehistoric Island",
    Content = "Teleport & Find Prehistoric Island",
    Default = false,
    Callback = function(state)
    end
})
Sec_589:AddToggle({
    Title = "Auto Kill Lava Golem",
    Content = "Teleport and Kill Lava Golem",
    Default = false,
    Callback = function(state)
    end
})
Sec_589:AddToggle({
    Title = "Auto Collect Bone",
    Content = "Auto Collect Dino Bone",
    Default = false,
    Callback = function(state)
    end
})
Sec_589:AddToggle({
    Title = "Auto Collect Egg",
    Content = "Auto Collect Dragon Egg",
    Default = false,
    Callback = function(state)
    end
})
Sec_589:AddToggle({
    Title = "Auto Defend Volcano",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Stack > Frozen Dimension ]]
local Sec_598 = Tabs.Sea_Stack:AddSection("Frozen Dimension")
Sec_598:AddParagraph({
    Title = "Frozen Status",
    Content = "-",
})
Sec_598:AddToggle({
    Title = "Auto Frozen Dimension",
    Content = "Teleport & Find Frozen Deimension",
    Default = false,
    Callback = function(state)
    end
})
Sec_598:AddParagraph({
    Title = "Leviathan Status",
    Content = "0",
})
Sec_598:AddButton({
    Title = "Bribe Leviathan",
    Callback = function()
    end
})
Sec_598:AddToggle({
    Title = "Auto Leviathan",
    Content = "Attack Leviathan",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Stack > Kitsune Island ]]
local Sec_606 = Tabs.Sea_Stack:AddSection("Kitsune Island")
Sec_606:AddParagraph({
    Title = "Kitsune Status",
    Content = "-",
})
Sec_606:AddToggle({
    Title = "Auto Kitsune Island",
    Content = "Teleport & Find Kitsune Island",
    Default = false,
    Callback = function(state)
    end
})
Sec_606:AddToggle({
    Title = "Auto Collect Azure Ember",
    Content = "Tween To Azure Ember When it Appears",
    Default = false,
    Callback = function(state)
    end
})
Sec_606:AddSlider({
    Title = "Set Azure Ember",
    Min = 1,
    Max = 25,
    Increment = 1,
    Default = 20,
    Callback = function(value)
    end
})
Sec_606:AddToggle({
    Title = "Auto Trade Azure Ember",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Stack > Mirage Island ]]
local Sec_622 = Tabs.Sea_Stack:AddSection("Mirage Island")
Sec_622:AddParagraph({
    Title = "Mirage Status",
    Content = "-",
})
Sec_622:AddToggle({
    Title = "Auto Mirage Island",
    Content = "Tween To Mirage Island When it Appears",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Sea Stack > Sea Beasts ]]
local Sec_627 = Tabs.Sea_Stack:AddSection("Sea Beasts")
Sec_627:AddToggle({
    Title = "Auto Attack Seabeasts",
    Content = "Teleport and Attack Seabeasts",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Local Player > Local Player ]]
local Sec_631 = Tabs.Local_Player:AddSection("Local Player")
Sec_631:AddToggle({
    Title = "Active Race V3",
    Default = false,
    Callback = function(state)
    end
})
Sec_631:AddToggle({
    Title = "Active Race V4",
    Default = true,
    Callback = function(state)
    end
})
Sec_631:AddToggle({
    Title = "Walk On Water",
    Default = false,
    Callback = function(state)
    end
})
Sec_631:AddToggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
    end
})

-- [[ Fruit > Fruit ]]
local Sec_644 = Tabs.Fruit:AddSection("Fruit")
Sec_644:AddToggle({
    Title = "Auto Random Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_644:AddDropdown({
    Title = "Store Rarity Fruit",
    Options = {},
    Callback = function(value)
    end
})
Sec_644:AddToggle({
    Title = "Auto Store Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_644:AddToggle({
    Title = "Fruit Notification",
    Default = false,
    Callback = function(state)
    end
})
Sec_644:AddToggle({
    Title = "Teleport To Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_644:AddToggle({
    Title = "Tween To Fruit",
    Default = false,
    Callback = function(state)
    end
})
Sec_644:AddButton({
    Title = "Grab Fruit",
    Callback = function()
    end
})

-- [[ Fruit > Visual ]]
local Sec_662 = Tabs.Fruit:AddSection("Visual")
Sec_662:AddButton({
    Title = "Rain Fruit",
    Callback = function()
    end
})

-- [[ Misc > Teams ]]
local Sec_664 = Tabs.Misc:AddSection("Teams")
Sec_664:AddButton({
    Title = "Join Pirates Team",
    Callback = function()
    end
})
Sec_664:AddButton({
    Title = "Join Marines Team",
    Callback = function()
    end
})

-- [[ Misc > Codes ]]
local Sec_667 = Tabs.Misc:AddSection("Codes")
Sec_667:AddButton({
    Title = "Redeem All Codes",
    Callback = function()
    end
})

-- [[ Misc > Graphics ]]
local Sec_669 = Tabs.Misc:AddSection("Graphics")
Sec_669:AddButton({
    Title = "Fps Boost",
    Callback = function()
    end
})
Sec_669:AddButton({
    Title = "Remove Fog",
    Callback = function()
    end
})
Sec_669:AddButton({
    Title = "Remove Lava",
    Callback = function()
    end
})

-- [[ Server > Server ]]
local Sec_673 = Tabs.Server:AddSection("Server")
Sec_673:AddButton({
    Title = "Rejoin Server",
    Callback = function()
    end
})
Sec_673:AddButton({
    Title = "Server Hop",
    Callback = function()
    end
})
Sec_673:AddParagraph({
    Title = "Job ID",
    Content = "-",
})
Sec_673:AddButton({
    Title = "Copy Job ID",
    Callback = function()
    end
})
Sec_673:AddInput({
    Title = "Enter Job ID",
    Default = "",
    Callback = function(value)
    end
})
Sec_673:AddButton({
    Title = "Join Job ID",
    Callback = function()
    end
})

-- [[ Server > Status Server ]]
local Sec_680 = Tabs.Server:AddSection("Status Server")
Sec_680:AddParagraph({
    Title = "Moon Server",
    Content = "-",
})
Sec_680:AddParagraph({
    Title = "Kitsune Status",
    Content = "-",
})
Sec_680:AddParagraph({
    Title = "Frozen Status",
    Content = "-",
})
Sec_680:AddParagraph({
    Title = "Mirage Status",
    Content = "-",
})
Sec_680:AddParagraph({
    Title = "Haki Dealer Status",
    Content = "-",
})
Sec_680:AddParagraph({
    Title = "Prehistoric Status",
    Content = "-",
})

-- [[ Initial Notification ]]
notify("StreeHub loaded successfully!", 3, Color3.fromRGB(0, 255, 0), "StreeHub", "Welcome!")