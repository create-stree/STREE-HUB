local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()
local Window = StreeHub:Window({
    Title   = "Meng Hub | Fisch",
    Footer  = "[v1.0.0]",
    Images  = "80659354137631",
    Color   = Color3.fromRGB(57, 255, 20),
    Theme   = nil,
    ThemeTransparency = 0.15,
    ["Tab Width"] = 120,
    Version = 3,
})
local function notify(msg, delay, color, title, desc)
    return StreeHub:MakeNotify({
        Title = title or "Meng Hub",
        Description = desc or "Notification",
        Content = msg or "Content",
        Color = color or Color3.fromRGB(57, 255, 20),
        Delay = delay or 4
    })
end
local VirtualUser = game:GetService("VirtualUser")
local Connection = game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    warn("Anti-AFK: Aktivitas terdeteksi, mencegah diskoneksi.")
end)
warn("Anti AFK Automatic On!")
settings().Network.IncomingReplicationLag = 0
game:GetService("RunService").Heartbeat:Connect(function() end)
local Connection_2 = game:GetService("RunService").PreSimulation:Connect(function()
    game.Players.LocalPlayer.GameplayPaused = false
end)
warn("Anti-Gameplay Paused Active!")
local Tabs = {
    About       = Window:AddTab({ Name = "About", Icon = "user" }),
    Main        = Window:AddTab({ Name = "Main", Icon = "star" }),
    Shop        = Window:AddTab({ Name = "Shop", Icon = "" }),
    Automatic   = Window:AddTab({ Name = "Automatic", Icon = "" }),
    Teleport    = Window:AddTab({ Name = "Teleport", Icon = "gps" }),
    Misc        = Window:AddTab({ Name = "Misc", Icon = "settings" }),
    Config      = Window:AddTab({ Name = "Configuration", Icon = "menu" }),
}
local AboutSec = Tabs.About:AddSection("About MengHub?")
AboutSec:AddParagraph({
    Title = "What is MengHub?",
    Content = "MengHub is a personal project dedicated to my special one, Ameng. \nThis script is built with passion and serves as a milestone in my coding journey. \nAs I am currently in the early stages of development and still learning the ropes of Luau,\nyou might encounter some bugs. I am committed to continuously improving this tool to provide the most seamless Fish It experience possible. \nThank you for being part of my learning process!",
    Icon = nil,
})
AboutSec:AddParagraph({
    Title = "Meng Hub Discord",
    Content = "This link discord Meng Hub!",
    Icon = "discord",
    ButtonText = "COPY LINK",
    ButtonCallback = function()
        local link = "https://discord.gg/menghub"
        if setclipboard then
            setclipboard(link)
            notify("Discord link copied!")
        end
    end
})
local InfoEventSec = Tabs.About:AddSection("Info Event", true)
local EventParagraph = InfoEventSec:AddParagraph({
    Title = "Active Event",
    Content = "Loading events...",
})
task.spawn(function()
    while true do
        local zones = workspace:WaitForChild("zones")
        local fishing = zones:WaitForChild("fishing")
        local pools = {
            "Baby Bloop Fish", "Bloop Fish", "Whales Pool", "Orcas Pool", "The Kraken Pool",
            "Animal Pool", "Plesiosaur Hunt", "Goldwraith Hunt", "Reef Titan Hunt", "Sunken Reliquary",
            "Omnithal Hunt", "Animal Pool - Second Sea", "Octophant Pool Without Elephant",
            "Sea Leviathan Pool", "Isonade", "Forsaken Veil - Scylla", "Blue Moon - Second Sea",
            "Blue Moon - First Sea", "LEGO", "LEGO - Studolodon", "Mosslurker", "Narwhal",
            "Whale Shark", "Birthday Megalodon", "Colossal Blue Dragon", "Colossal Ancient Dragon",
            "Colossal Ethereal Dragon", "Megalodon Ancient", "Megalodon Default", "Megalodon Phantom",
        }
        local content = ""
        for _, name in ipairs(pools) do
            local exists = fishing:FindFirstChild(name) and "✓" or "✗"
            content = content .. name .. ": " .. exists .. "\n"
        end
        EventParagraph:SetContent(content)
        task.wait(5)
    end
end)
local HelperSec = Tabs.Main:AddSection("Helper Support")
HelperSec:AddToggle({
    Title = "Show Real Ping",
    Default = false,
    Callback = function(state) _G.ShowPing = state end
})
HelperSec:AddToggle({
    Title = "Auto Equip Rod",
    Default = false,
    Callback = function(state) _G.AutoEquipRod = state end
})
HelperSec:AddToggle({
    Title = "Auto Equip Best Rod",
    Content = "Automatically switches to the rod with the highest luck and lure speed",
    Default = false,
    Callback = function(state) _G.AutoEquipBest = state end
})
HelperSec:AddToggle({
    Title = "Anti Staff",
    Content = "Automatically kick if any staff/dev join",
    Default = true,
    Callback = function(state) _G.AntiStaff = state end
})
HelperSec:AddToggle({
    Title = "Bypass Radar",
    Default = false,
    Callback = function(state) _G.BypassRadar = state end
})
local FastCatchSec = Tabs.Main:AddSection("Super Fast Catch")
FastCatchSec:AddToggle({
    Title = "Auto Cast",
    Default = false,
    Callback = function(state) _G.AutoCast = state end
})
FastCatchSec:AddToggle({
    Title = "Auto Shake",
    Default = false,
    Callback = function(state) _G.AutoShake = state end
})
FastCatchSec:AddToggle({
    Title = "Auto Reel",
    Default = false,
    Callback = function(state) _G.AutoReel = state end
})
FastCatchSec:AddDivider()
FastCatchSec:AddToggle({
    Title = "Instant Bobber",
    Default = true,
    Callback = function(state) _G.InstantBobber = state end
})
FastCatchSec:AddToggle({
    Title = "Center Shake",
    Default = true,
    Callback = function(state) _G.CenterShake = state end
})
local AutoFishSec = Tabs.Main:AddSection("Auto Fishing")
AutoFishSec:AddDropdown({
    Title = "Catching Mode",
    Options = { "Legit", "Fast" },
    Default = "Legit",
    Callback = function(value) _G.CatchingMode = value end
})
AutoFishSec:AddInput({
    Title = "Shake Click Delay (s)",
    Placeholder = "e.g. 0.1",
    Default = "",
    Callback = function(value) _G.ShakeDelay = tonumber(value) or 0.1 end
})
AutoFishSec:AddInput({
    Title = "Cast Animation Delay (s)",
    Placeholder = "e.g. 1.5",
    Default = "",
    Callback = function(value) _G.CastDelay = tonumber(value) or 1.5 end
})
AutoFishSec:AddToggle({
    Title = "Enable Auto Fishing",
    Default = false,
    Callback = function(state) _G.AutoFishing = state end
})
AutoFishSec:AddButton({
    Title = "Cancel Fishing",
    Callback = function() notify("Fishing cancelled") end
})
AutoFishSec:AddButton({
    Title = "Instant Respawn / Reset",
    Callback = function() game.Players.LocalPlayer.Character:BreakJoints() end
})
local AutoSpearSec = Tabs.Main:AddSection("Auto Spear")
AutoSpearSec:AddDropdown({
    Title = "Spear Location",
    Content = "Select location to teleport",
    Options = { "Lost Jungle", "Coral Bastion", "Tidefall", "Colapse Ruin", "Crowned Ruins" },
    Default = "Lost Jungle",
    Callback = function(value) _G.SpearLocation = value end
})
AutoSpearSec:AddToggle({
    Title = "Enable Spearfishing",
    Content = "Teleport and catch spear fish",
    Default = false,
    Callback = function(state) _G.SpearFishing = state end
})
local SnapReelSec = Tabs.Main:AddSection("Snap Reel")
SnapReelSec:AddDropdown({
    Title = "Snap Filter Fish",
    Multi = true,
    Options = {
        "Abyss Dart", "Abyss Flicker", "Abyss Snapper", "Abyssacuda", "Abyssal Bearded Seadevil",
        "Abyssal Devourer", "Abyssal Goliath", "Abyssal Grenadier", "Abyssal King", "Abyssal Maw",
        "Abyssal Slickhead", "Abyssborn Monstrosity", "Acanthodii", "Aetherfin", "Akkorokamui",
        "Algae Lurker", "Alligator", "Alligator Gar", "Amberjack", "Amblypterus", "Anchovy",
        "Ancient Depth Serpent", "Ancient Eel", "Ancient Kraken", "Ancient Megalodon", "Ancient Orca",
        "Angelfish", "Anglerfish", "Anomalocaris", "Antarctic Icefish", "Apex Leviathan", "Aqua Scribe",
        "Arapaima", "Arctic Char", "Armorhead", "Ashclaw", "Ashcloud Archerfish", "Ashscale Minnow",
        "Atlantean Alchemist", "Atlantean Anchovy", "Atlantean Guardian", "Atlantean Sardine",
        "Atlantic Goliath Grouper", "Atlantic Halosaur", "Atolla Jellyfish", "Aurora Trout", "Axolotl",
        "Azure Prowler", "Baby Bloop Fish", "Baby Pond Emperor", "Banditfish", "Barbed Shark",
        "Barracuda", "Barreleye Fish", "Basalt Loach", "Basalt Pike", "Batfish", "Bauble Bass",
        "Beach Ball Pufferfish", "Bearded Toadfish", "Bellfin", "Beluga", "Bigeye Houndshark",
        "Bigeye Trevally", "Bigfin Squid", "Birgeria", "Birthday Dumbo Octopus", "Birthday Goldfish",
        "Birthday Megalodon", "Birthday Squid", "Black Dragon Fish", "Black Ghost Knifefish",
        "Black Grouper", "Black Scabbardfish", "Black Snoek", "Black Swallower", "Black Veil Ray",
        "Blackfin Barracuda", "Blackfish", "Blackmouth Catshark", "Blackspot Tuskfish", "Blazebelly",
        "Blind Swamp Eel", "Blisterback Blenny", "Blistered Eel", "Blisterfish", "Blobfish",
        "Bloodscript Eel", "Bloomtail", "Bloop Fish", "Blue Foamtail", "Blue Langanose", "Blue Ribbon Eel",
        "Blue Tang", "Blue Whale", "Bluefin Tuna", "Bluefish", "Bluegem Angelfish", "Bluegill",
        "Bluehead Wrasse", "Bluelip Batfish", "Boarfish", "Bog Lantern Goby", "Bogscale", "Bone Lanternfish",
        "Bowfin", "Brackscale", "Breaker Moth", "Bream", "Brimstone Angler", "Brine Phantom", "Brine Sovereign",
        "Bronze Corydoras", "Buccaneer Barracuda", "Bull Shark", "Bumpy Snailfish", "Burbot", "Burnt Betta",
        "Butterflyfish", "Candle Carp", "Candy Cane Carp", "Candy Cane Cod", "Candy Fish", "Canopy Tetra",
        "Capybass", "Cardinal Tetra", "Carol Carp", "Carp", "Carrot Eel", "Carrot Goldfish", "Carrot Minnow",
        "Carrot Pufferfish", "Carrot Salmon", "Carrot Shark", "Carrot Snapper", "Carrot Turtle",
        "Cataclysm Carp", "Catfish", "Cathulid", "Cathulith", "Caustic Starwyrm", "Cave Angel Fish",
        "Cave Loach", "Celestial Koi", "Charybdis", "Chasm Leech", "Chillback Whitefish", "Chillfin Chimaera",
        "Chillfin Herring", "Chillshadow Chub", "Chinfish", "Chinook Salmon", "Chronos Deep Swimmer", "Chub",
        "Cinder Carp", "Cinder Dart", "Cindercoil Eel", "Cladoselache", "Clout Carp", "Clowned Triggerfish",
        "Clownfish", "Cluckfin", "Coalfin Darter", "Cobalt Angelfish", "Cobia", "Cockatoo Squid", "Cod",
        "Coelacanth", "Coffin Crab", "Coin Piranha", "Coin Squid", "Coin Triggerfish", "Colossal Carp",
        "Colossal Saccopharynx", "Colossal Squid", "Column Crawler", "Coney Grouper", "Confetti Carp",
        "Confetti Shark", "Cookiecutter Shark", "Copper Rockfish", "Coral Chromis", "Coral Emperor",
        "Coral Guard", "Coral Turkey", "Cornetfish", "Corsair Grouper", "Countdown Perch", "Crag-Crab",
        "Cragscale", "Crawling Angler", "Crescent Madtom", "Crestscale", "Crocokoi", "Crown Bass",
        "Crowned Anglerfish", "Crowned Royal Gramma", "Crustal Colossus", "Cryo Coelacanth", "Cryoshock Serpent",
    },
    Default = {},
    Callback = function(selected) _G.SnapFilterFish = selected end
})
SnapReelSec:AddDropdown({
    Title = "Snap Filter Mutation",
    Multi = true,
    Options = {
        "67", "Abyssal", "Albino", "Alien", "Amber", "Amped", "Anomalous", "Ascended", "Ashen Fortune",
        "Astraeus", "Astral", "Atlantean", "Atomic", "Aureate", "Aurelian", "Aureolin", "Aurora", "Aurous",
        "Aurulent", "Awesome", "Batty", "Beachy", "Birthday", "Blarney", "Blessed", "Blighted", "Bloom",
        "Blue", "Blue Moon", "Boreal", "Botanic", "Breezed", "Brined", "Brother", "Brown Wood", "Bubblegum",
        "Candy", "Carrot", "Celestial", "Cement", "Chaotic", "Charred", "Chilled", "Chlorowoken", "Chocolate",
        "Clover", "Colossal Ink", "Coral", "Corvid", "Cracked", "Crimson", "Crystalized", "Cursed",
        "Cursed Touch", "Darkened", "Darkness", "Dirty", "Distraught", "Diurnal", "Doomsday", "Easter",
        "Eerie", "Electric", "Electric Shock", "Ember", "Emberflame", "Embraced", "Evil", "Exploded",
        "Fabulous", "Fallen", "Female", "Festive", "Firework", "Fixer", "Flora", "Forgotten", "Fortune",
        "Fossilized", "Fragmented", "Frightful", "Frostbitten", "Frostnova", "Frozen", "Fungal", "Galactic",
        "Galaxy", "Gemstone", "Ghastly", "Gingerbread", "Glacial", "Gleebous", "Glossy", "Glowy", "Glyphed",
        "Golden", "Gravy", "Greedy", "Green", "Green Leaf", "Harmonized", "Haunted", "Heartburst", "Heavenly",
        "Hexed", "Honked", "Husk", "Igneous", "Infernal", "Jack's Curse", "Jackpot", "Jingle Bell", "Jolly",
        "King's Blessing", "Levitas", "Lightened", "Lightning", "Lobster", "Lost", "Lovely", "Lovestruck",
        "Lucid", "Luminescent", "Lumpy", "Lunar", "Lustrous", "Mace", "Madness", "Magical", "Mango",
        "Mastered", "Mayhem", "Merry", "Midas", "Minty", "Mission Specialist", "Moon-Kissed", "Mosaic",
        "Mossy", "Mother Nature", "Mourned", "Mythical", "Necrotic", "Negative", "Neon", "New Years",
        "Nico's Nyantics", "Nightmare", "Noctic", "Nocturnal", "Nova", "Nuclear", "Nullified", "Oak",
        "Oblivion", "Obsidian", "Ocean's Ruin", "Oscar", "Paleontologist", "Pancake", "Part", "Patriotic",
        "Peppermint", "Permafrost", "Phantom", "Pink", "Poisoned", "Popsicle", "Prismize", "Purified",
        "Puritas", "Putrid", "Quiet", "Radiant", "Rainbow", "Rainbow Cluster", "Red", "Requies",
        "Revitalized", "Rockstar", "Rooted", "Rose", "Royal", "Rusty", "Sacratus", "Sandstormy", "Sandy",
        "Sanguine", "Santa", "Scorched", "Seasonal", "Serene", "Shrouded", "Silver", "Sinister",
        "Siren's Spite", "Skrunkly", "Sleet", "Smurf", "Snowy",
    },
    Default = {},
    Callback = function(selected) _G.SnapFilterMutation = selected end
})
SnapReelSec:AddInput({
    Title = "Target Fish (if it is not in the dropdown)",
    Placeholder = "Fish name",
    Default = "",
    Callback = function(value) _G.SnapTargetFish = value end
})
SnapReelSec:AddToggle({
    Title = "Snap Reel",
    Content = "Released if the fish does not meet the target",
    Default = false,
    Callback = function(state) _G.SnapReel = state end
})
local SellSec = Tabs.Main:AddSection("Sell Features")
SellSec:AddInput({
    Title = "Sell Interval (s)",
    Placeholder = "e.g. 60",
    Default = "",
    Callback = function(value) _G.SellInterval = tonumber(value) or 60 end
})
SellSec:AddToggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(state) _G.AutoSell = state end
})
local RodSkins = game:GetService("ReplicatedStorage").shared.modules.RodSkins
local rodOptions = {}
for _, v in ipairs(RodSkins:GetChildren()) do
    if v.Name:find("Rod") then
        table.insert(rodOptions, v.Name)
    end
end
local RodShopSec = Tabs.Shop:AddSection("Rod Shop")
local RodDropdown = RodShopSec:AddDropdown({
    Title = "Select Rod",
    Content = "Select rod u want to buy",
    Options = rodOptions,
    Default = rodOptions[1] or "",
    Callback = function(value) _G.SelectedRod = value end
})
RodShopSec:AddButton({
    Title = "Buy Selected Rod",
    Callback = function() notify("Buying " .. (_G.SelectedRod or "unknown rod")) end
})
local BaitShopSec = Tabs.Shop:AddSection("Bait Shop")
BaitShopSec:AddDropdown({
    Title = "Select Bait",
    Content = "Choose a Bait to Purchase",
    Options = {
        "Common Crate", "Tropical Bait Crate", "Carbon Crate", "Bait Crate",
        "Quality Bait Crate", "Coral Geode", "Volcanic Geode", "Festival Bait Crate"
    },
    Default = "Common Crate",
    Callback = function(value) _G.SelectedBait = value end
})
BaitShopSec:AddInput({
    Title = "Buy Ammount (Bait)",
    Placeholder = "e.g. 10",
    Default = "",
    Callback = function(value) _G.BaitAmount = tonumber(value) or 1 end
})
BaitShopSec:AddButton({
    Title = "Buy Selected Bait",
    Callback = function() notify("Buying " .. (_G.BaitAmount or 1) .. " of " .. (_G.SelectedBait or "bait")) end
})
local TotemShopSec = Tabs.Shop:AddSection("Totem Shop")
TotemShopSec:AddInput({
    Title = "Buy Ammount (Totem)",
    Placeholder = "e.g. 5",
    Default = "",
    Callback = function(value) _G.TotemAmount = tonumber(value) or 1 end
})
TotemShopSec:AddDropdown({
    Title = "Select Totem",
    Content = "Choose a Totem to Purchase",
    Options = {
        "Windset Totem", "Clearcast Totem", "Frost Moon Totem", "Frightful Pool Totem",
        "Rainbow Totem", "Scylla Hunt Totem", "Kraken Hunt Totem", "Shiny Totem", "Starfall Totem",
        "Dripstone Collapse Totem", "Meteor Totem", "Cursed Storm Totem", "Poseidon Wrath Totem",
        "Zeus Storm Totem", "Smokescreen Totem", "Tempest Totem", "Blizzard Totem", "Eclipse Totem",
        "Aurora Totem", "Blue Moon Totem", "Avalanche Totem", "Colossal Dragon Hunt Totem",
        "Mutation Totem", "Sparkling Totem", "Megalodon Hunt Totem", "Sundial Totem"
    },
    Default = "Windset Totem",
    Callback = function(value) _G.SelectedTotem = value end
})
TotemShopSec:AddButton({
    Title = "Buy Selected Totem",
    Callback = function() notify("Buying " .. (_G.TotemAmount or 1) .. " of " .. (_G.SelectedTotem or "totem")) end
})
local BoatShopSec = Tabs.Shop:AddSection("Boat Shop")
BoatShopSec:AddButton({
    Title = "Open/Close Boat Shop UI",
    Callback = function() notify("Toggling Boat Shop") end
})

local BlackMarketSec = Tabs.Shop:AddSection("Black Market")
BlackMarketSec:AddButton({
    Title = "Open/Close Black Market UI",
    Callback = function() notify("Toggling Black Market") end
})

local DailyShopSec = Tabs.Shop:AddSection("Daily Shop")
DailyShopSec:AddButton({
    Title = "Open/Close Daily Shop UI",
    Callback = function() notify("Toggling Daily Shop") end
})

local TotemAutoSec = Tabs.Automatic:AddSection("Totem")
TotemAutoSec:AddDropdown({
    Title = "Select Day Totem",
    Options = {
        "Windset Totem", "Clearcast Totem", "Frost Moon Totem", "Frightful Pool Totem",
        "Rainbow Totem", "Scylla Hunt Totem", "Kraken Hunt Totem", "Shiny Totem", "Starfall Totem",
        "Dripstone Collapse Totem", "Meteor Totem", "Cursed Storm Totem", "Poseidon Wrath Totem",
        "Zeus Storm Totem", "Smokescreen Totem", "Tempest Totem", "Blizzard Totem", "Eclipse Totem",
        "Aurora Totem", "Blue Moon Totem", "Avalanche Totem", "Colossal Dragon Hunt Totem",
        "Mutation Totem", "Sparkling Totem", "Megalodon Hunt Totem", "Sundial Totem"
    },
    Default = "Windset Totem",
    Callback = function(value) _G.DayTotem = value end
})

TotemAutoSec:AddDropdown({
    Title = "Select Night Totem",
    Options = {
        "Windset Totem", "Clearcast Totem", "Frost Moon Totem", "Frightful Pool Totem",
        "Rainbow Totem", "Scylla Hunt Totem", "Kraken Hunt Totem", "Shiny Totem", "Starfall Totem",
        "Dripstone Collapse Totem", "Meteor Totem", "Cursed Storm Totem", "Poseidon Wrath Totem",
        "Zeus Storm Totem", "Smokescreen Totem", "Tempest Totem", "Blizzard Totem", "Eclipse Totem",
        "Aurora Totem", "Blue Moon Totem", "Avalanche Totem", "Colossal Dragon Hunt Totem",
        "Mutation Totem", "Sparkling Totem", "Megalodon Hunt Totem", "Sundial Totem"
    },
    Default = "Frost Moon Totem",
    Callback = function(value) _G.NightTotem = value end
})

TotemAutoSec:AddSlider({
    Title = "Use Totem Delay (seconds)",
    Content = "Re-use totem every X seconds",
    Min = 1,
    Max = 120,
    Increment = 1,
    Default = 60,
    Callback = function(value) _G.TotemDelay = value end
})

TotemAutoSec:AddToggle({
    Title = "Auto Totem",
    Default = false,
    Callback = function(state) 
        _G.AutoTotem = state 
    end
})

local EnchantSec = Tabs.Automatic:AddSection("Enchant")
EnchantSec:AddDropdown({
    Title = "Select Target",
    Multi = true,
    Options = {
        "Sea King", "Swift", "Long", "Ghastly", "Lucky", "Divine", "Mutated", "Unbreakable",
        "Steady", "Blessed", "Wormhole", "Resilient", "Controlled", "Storming", "Scrapper",
        "Breezed", "Insight", "Noir", "Hasty", "Quality", "Abyssal", "Clever"
    },
    Default = {},
    Callback = function(selected) _G.EnchantTargets = selected end
})
EnchantSec:AddToggle({
    Title = "Auto Enchant Altar",
    Default = false,
    Callback = function(state) _G.AutoEnchant = state end
})
EnchantSec:AddButton({
    Title = "Teleport To Enchant Altar",
    Callback = function()
        local altarPos = Vector3.new(0,0,0)
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(altarPos))
    end
})
local VialSec = Tabs.Automatic:AddSection("Auto Claim Vial [Cerebra Rod]")
VialSec:AddToggle({
    Title = "Enable Auto Vial",
    Default = false,
    Callback = function(state) _G.AutoVial = state end
})
local StarfallSec = Tabs.Automatic:AddSection("Starfall")
local StarfallPara = StarfallSec:AddParagraph({
    Title = "StarCrater exists:",
    Content = "Loading...",
})
StarfallSec:AddToggle({
    Title = "Auto Collect Star Crater",
    Default = false,
    Callback = function(state) _G.AutoStarCrater = state end
})
task.spawn(function()
    while true do
        local zones = workspace:WaitForChild("zones")
        local fishing = zones:WaitForChild("fishing")
        local crater = fishing:FindFirstChild("Star Crater")
        StarfallPara:SetContent(crater and "Yes" or "No")
        task.wait(5)
    end
end)
local TeleportSec = Tabs.Teleport:AddSection("Teleport")
TeleportSec:AddDropdown({
    Title = "Select Location",
    Options = {
        "???", "Abyssal Zenith", "Ancient Archives", "Ancient Isle", "Atlantean Storm",
        "Atlantis", "Behind Waterfall", "Birch Cay", "Blue Moon - First Sea", "Boreal Pines",
        "Brine Pool", "Calm Zone", "Carrot Garden", "Castaway Cliffs", "Challenger's Deep",
        "Collapsed Ruins", "Coral Bestion", "Crimson Cavern", "Crowned Ruins", "Cryogenic Canal",
        "Crystal Cove", "Crystal Fissure", "Cultist Lair", "Cultist Lair - Entrance", "Cupid's Island",
        "Detonator's Rest", "Disolate Deep", "Earmark Island", "Ethereal Abyss", "Ethereal Trial",
        "Executive Headquaters", "Forgotten Tample", "Forsaken Shores", "Frigid Cavern", "Ghost Tavern",
        "Glacial Grotto", "Grand Reef", "Haddock Rock", "Half of Whisper", "Harvesters Spike",
        "Inner Tidefall Castle", "Keepers Altar", "Kraken Pool", "Liminescent Cavern", "Lost Jungle",
        "Merlins Hut", "Mineshaft", "Mosewood", "Mossjaw Rest", "Mushgrove", "Mysterious Crack",
        "Mysterious River", "OverGrowth Caves", "Passage of Oaths", "Poseidon Tample", "Poseidon Trial",
        "Roslit Bay", "Roslit Hamlet", "Roslit Pond", "Roslit Volcano", "Scoria Reach", "Snow Burrow",
        "Snowcap", "Snowcap Cave", "Statue Of Sovereignty", "Sunken Depths", "Sunken Reliquary",
        "Sunken Trial", "Sunstone", "Sunstone Rift", "Sweetheart Shores", "Terrapin",
        "Terrapin Island Cave", "Thalassar's Secret", "The Arch", "The Bunker", "The Depths",
        "The Depths - Maze", "The Keeper's Secret", "The Sanctum", "The Void", "Tidefall",
        "Treasure Island", "Trident", "Trident Entrance", "Underground Music Venue", "Underwater Cave",
        "Underwater Opening", "Upper Snowcap", "Veil of the Forsaken", "Vertigo", "Vertigo Dip",
        "Zeus Trial", "Zeus's Rod Room"
    },
    Default = "???",
    Callback = function(value) _G.TeleportLocation = value end
})
TeleportSec:AddInput({
    Title = "Teleport Cordinate",
    Content = "u must be input (x, y, z)",
    Placeholder = "x, y, z",
    Default = "",
    Callback = function(value) _G.TeleportCoord = value end
})
TeleportSec:AddButton({
    Title = "Teleport to Location",
    Callback = function()
        if _G.TeleportCoord and _G.TeleportCoord ~= "" then
            local x,y,z = _G.TeleportCoord:match("([%d.-]+),%s*([%d.-]+),%s*([%d.-]+)")
            if x and y and z then
                local pos = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(pos))
            else
                notify("Invalid coordinate format!")
            end
        elseif _G.TeleportLocation then
            notify("Teleport to " .. _G.TeleportLocation)
        end
    end
})
TeleportSec:AddSubSection("Teleport Event Zone")
local MiscSec = Tabs.Misc:AddSection("Misc")
MiscSec:AddParagraph({
    Title = "Coming Soon",
    Content = "Misc features will be added later."
})
local ConfigSec = Tabs.Config:AddSection("Configuration")
ConfigSec:AddParagraph({
    Title = "Configuration",
    Content = "Settings will be saved automatically."
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = ReplicatedStorage:WaitForChild("client")
local legacyControllers = client:WaitForChild("legacyControllers")
local ReelController = require(legacyControllers:FindFirstChild("ReelController"))
ReelController.EndMinigame = function(...) end
ReelController.StartReel = function(...) end
ReelController.new = ReelController._OldNew
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local function autoShakeClick()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local shakeui = playerGui:FindFirstChild("shakeui")
    if not shakeui then return end
    local safezone = shakeui:FindFirstChild("safezone")
    if not safezone then return end
    local button = safezone:FindFirstChild("button")
    if not button then return end
    GuiService.SelectedObject = button
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    task.wait(0.05)
    GuiService.SelectedObject = nil
end
task.spawn(function()
    while true do
        if _G.AutoShake then
            autoShakeClick()
        end
        task.wait(0.1)
    end
end)
task.spawn(function()
    while true do
        if _G.AutoFishing then
        end
        task.wait(0.5)
    end
end)
notify("Meng Hub loaded successfully!", 3, Color3.fromRGB(0,255,0), "Meng Hub", "Welcome")
