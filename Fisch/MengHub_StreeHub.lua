-- ============================================================
-- Meng Hub | Fisch — Converted to StreeHub UI Library
-- ============================================================

-- [[ Services ]]
local Players       = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService    = game:GetService("GuiService")
local VirtualUser   = game:GetService("VirtualUser")
local RunService    = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Workspace     = game:GetService("Workspace")
local LocalPlayer   = Players.LocalPlayer
local PlayerGui     = LocalPlayer:WaitForChild("PlayerGui")

-- [[ Anti-AFK ]]
local AntiAFKConnection
AntiAFKConnection = LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    warn("Anti-AFK: Aktivitas terdeteksi, mencegah diskoneksi.")
end)
warn("Anti AFK Automatic On!")

-- [[ Network Optimization ]]
settings().Network.IncomingReplicationLag = 0

-- [[ Anti Gameplay Paused ]]
local RunServicePreSim = game:GetService("RunService").PreSimulation
local AntiPausedConnection
AntiPausedConnection = RunServicePreSim:Connect(function()
    LocalPlayer.GameplayPaused = false
end)
warn("Anti-Gameplay Paused Active!")

-- ============================================================
-- [[ Load StreeHub UI ]]
-- ============================================================
local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

-- [[ Window ]]
local Window = StreeHub:Window({
    Title   = "Meng Hub |",
    Footer  = "[v1.0.0]",
    Images  = "80659354137631",
    Color   = Color3.fromRGB(57, 255, 20),
    ["Tab Width"] = 120,
    Version = 3,
})

-- [[ Notify Helper ]]
local function notify(msg, delay, color, title, desc)
    return StreeHub:MakeNotify({
        Title       = title or "Meng Hub",
        Description = desc or "Notification",
        Content     = msg or "...",
        Color       = color or Color3.fromRGB(57, 255, 20),
        Delay       = delay or 4,
    })
end

-- ============================================================
-- [[ Tabs ]]
-- ============================================================
local Tabs = {
    About         = Window:AddTab({ Name = "About",         Icon = "user"     }),
    Main          = Window:AddTab({ Name = "Main",          Icon = "star"     }),
    Shop          = Window:AddTab({ Name = "Shop",          Icon = ""         }),
    Automatic     = Window:AddTab({ Name = "Automatic",     Icon = ""         }),
    Teleport      = Window:AddTab({ Name = "Teleport",      Icon = "gps"      }),
    Misc          = Window:AddTab({ Name = "Misc",          Icon = "menu"     }),
    Configuration = Window:AddTab({ Name = "Configuration", Icon = "settings" }),
}

-- ============================================================
-- TAB: About
-- ============================================================
local AboutSection = Tabs.About:AddSection("About MengHub?")

AboutSection:AddParagraph({
    Title   = "What is MengHub?",
    Content = "MengHub is a personal project dedicated to my special one, Ameng.\nThis script is built with passion and serves as a milestone in my coding journey.\nAs I am currently in the early stages of development and still learning the ropes of Luau,\nyou might encounter some bugs. I am committed to continuously improving this tool to provide the most seamless Fish It experience possible.\nThank you for being part of my learning process!",
})

AboutSection:AddParagraph({
    Title        = "Meng Hub Discord",
    Content      = "This link discord Meng Hub!",
    Icon         = "discord",
    ButtonText   = "COPY LINK",
    ButtonCallback = function()
        local link = "https://discord.gg/menghub"
        if setclipboard then
            setclipboard(link)
            notify("Discord link copied to clipboard!")
        else
            notify("Executor does not support setclipboard.")
        end
    end,
})

-- [[ Info Event Section (always open) ]]
local InfoEventSection = Tabs.About:AddSection("Info Event", true)

local ActiveEventParagraph = InfoEventSection:AddParagraph({
    Title   = "Active Event",
    Content = "Loading events...",
})

-- Poll active fishing events every 5 seconds
task.spawn(function()
    local eventZoneNames = {
        "Baby Bloop Fish", "Bloop Fish", "Whales Pool", "Orcas Pool",
        "The Kraken Pool", "Animal Pool", "Plesiosaur Hunt", "Goldwraith Hunt",
        "Reef Titan Hunt", "Sunken Reliquary", "Omnithal Hunt",
        "Animal Pool - Second Sea", "Octophant Pool Without Elephant",
        "Sea Leviathan Pool", "Isonade", "Forsaken Veil - Scylla",
        "Blue Moon - Second Sea", "Blue Moon - First Sea", "LEGO",
        "LEGO - Studolodon", "Mosslurker", "Narwhal", "Whale Shark",
        "Birthday Megalodon", "Colossal Blue Dragon", "Colossal Ancient Dragon",
        "Colossal Ethereal Dragon", "Megalodon Ancient", "Megalodon Default",
        "Megalodon Phantom",
    }

    while true do
        local ok, zonesFolder = pcall(function()
            return Workspace:WaitForChild("zones", 5):WaitForChild("fishing", 5)
        end)

        local lines = {}
        for _, name in ipairs(eventZoneNames) do
            local exists = ok and zonesFolder:FindFirstChild(name) ~= nil
            table.insert(lines, name .. ": " .. (exists and "✓" or "✗"))
        end

        if ActiveEventParagraph and ActiveEventParagraph.SetContent then
            ActiveEventParagraph:SetContent(table.concat(lines, "\n"))
        end

        task.wait(5)
    end
end)

-- ============================================================
-- TAB: Main
-- ============================================================

-- [[ Auto Click Safezone (runs inside toggle callbacks) ]]
local autoClickActive = false
task.spawn(function()
    while true do
        if autoClickActive then
            pcall(function()
                local shakeui   = PlayerGui:FindFirstChild("shakeui")
                local safezone  = shakeui and shakeui:FindFirstChild("safezone")
                local button    = safezone and safezone:FindFirstChild("button")
                if button then
                    GuiService.SelectedObject = button
                    VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    task.wait(0.05)
                    GuiService.SelectedObject = nil
                end
            end)
        end
        task.wait(0)
    end
end)

-- ---- Helper Support ----
local HelperSection = Tabs.Main:AddSection("Helper Support")

HelperSection:AddToggle({
    Title    = "Show Real Ping",
    Default  = false,
    Callback = function(state)
        -- stub: show real ping logic
    end,
})

HelperSection:AddToggle({
    Title    = "Auto Equip Rod",
    Default  = false,
    Callback = function(state)
        -- stub: auto equip rod logic
    end,
})

HelperSection:AddToggle({
    Title    = "Auto Equip Best Rod",
    Content  = "Automatically switches to the rod with the highest luck and lure speed",
    Default  = false,
    Callback = function(state)
        -- stub: auto equip best rod logic
    end,
})

HelperSection:AddToggle({
    Title    = "Anti Staff",
    Content  = "Automatically kick if any staff/dev join",
    Default  = true,
    Callback = function(state)
        -- stub: anti staff logic
    end,
})

HelperSection:AddToggle({
    Title    = "Bypass Radar",
    Default  = false,
    Callback = function(state)
        -- stub: bypass radar logic
    end,
})

-- ---- Super Fast Catch ----
local FastCatchSection = Tabs.Main:AddSection("Super Fast Catch")

FastCatchSection:AddToggle({
    Title    = "Auto Cast",
    Default  = false,
    Callback = function(state)
        -- stub: auto cast logic
    end,
})

FastCatchSection:AddToggle({
    Title    = "Auto Shake",
    Default  = false,
    Callback = function(state)
        autoClickActive = state
    end,
})

FastCatchSection:AddToggle({
    Title    = "Auto Reel",
    Default  = false,
    Callback = function(state)
        -- stub: auto reel logic
    end,
})

FastCatchSection:AddDivider()

FastCatchSection:AddToggle({
    Title    = "Instant Bobber",
    Default  = true,
    Callback = function(state)
        -- stub: instant bobber logic
    end,
})

FastCatchSection:AddToggle({
    Title    = "Center Shake",
    Default  = true,
    Callback = function(state)
        -- stub: center shake logic
    end,
})

-- ---- Auto Fishing ----
local AutoFishSection = Tabs.Main:AddSection("Auto Fishing")

local CatchModeDropdown = AutoFishSection:AddDropdown({
    Title    = "Catching Mode",
    Content  = "Choose fishing catching mode",
    Options  = { "Legit", "Fast" },
    Default  = "Legit",
    Callback = function(value)
        _G.MengCatchMode = value
    end,
})

local ShakeDelayInput = AutoFishSection:AddInput({
    Title       = "Shake Click Delay (s)",
    Placeholder = "Write ur input here",
    Default     = "",
    Callback    = function(value)
        _G.MengShakeDelay = tonumber(value) or 0
    end,
})

local CastDelayInput = AutoFishSection:AddInput({
    Title       = "Cast Animation Delay (s)",
    Placeholder = "Write ur input here",
    Default     = "",
    Callback    = function(value)
        _G.MengCastDelay = tonumber(value) or 0
    end,
})

AutoFishSection:AddToggle({
    Title    = "Enable Auto Fishing",
    Default  = false,
    Callback = function(state)
        _G.MengAutoFish = state
        notify("Auto Fishing " .. (state and "enabled." or "disabled."))
    end,
})

AutoFishSection:AddButton({
    Title    = "Cancel Fishing",
    Callback = function()
        _G.MengAutoFish = false
        notify("Fishing cancelled.")
    end,
})

AutoFishSection:AddButton({
    Title    = "Instant Respawn / Reset",
    Callback = function()
        notify("Respawning...")
        LocalPlayer:LoadCharacter()
    end,
})

-- ---- Auto Spear ----
local SpearSection = Tabs.Main:AddSection("Auto Spear")

local SpearLocationDropdown = SpearSection:AddDropdown({
    Title    = "Spear Location",
    Content  = "Select location to teleport",
    Options  = { "Lost Jungle", "Coral Bastion", "Tidefall", "Colapse Ruin", "Crowned Ruins" },
    Default  = "Lost Jungle",
    Callback = function(value)
        _G.MengSpearLocation = value
    end,
})

SpearSection:AddToggle({
    Title    = "Enable Spearfishing",
    Content  = "Teleport and catch spear fish",
    Default  = false,
    Callback = function(state)
        _G.MengSpearFish = state
        notify("Spearfishing " .. (state and "enabled." or "disabled."))
    end,
})

-- ---- Snap Reel ----
local SnapSection = Tabs.Main:AddSection("Snap Reel")

local SnapFilterFishDropdown = SnapSection:AddDropdown({
    Title   = "Snap Filter Fish",
    Content = "Select target fish to keep",
    Multi   = true,
    Options = {
        "Abyss Dart","Abyss Flicker","Abyss Snapper","Abyssacuda","Abyssal Bearded Seadevil",
        "Abyssal Devourer","Abyssal Goliath","Abyssal Grenadier","Abyssal King","Abyssal Maw",
        "Abyssal Slickhead","Abyssborn Monstrosity","Acanthodii","Aetherfin","Akkorokamui",
        "Algae Lurker","Alligator","Alligator Gar","Amberjack","Amblypterus","Anchovy",
        "Ancient Depth Serpent","Ancient Eel","Ancient Kraken","Ancient Megalodon","Ancient Orca",
        "Angelfish","Anglerfish","Anomalocaris","Antarctic Icefish","Apex Leviathan",
        "Aqua Scribe","Arapaima","Arctic Char","Armorhead","Ashclaw","Ashcloud Archerfish",
        "Ashscale Minnow","Atlantean Alchemist","Atlantean Anchovy","Atlantean Guardian",
        "Atlantean Sardine","Atlantic Goliath Grouper","Atlantic Halosaur","Atolla Jellyfish",
        "Aurora Trout","Axolotl","Azure Prowler","Baby Bloop Fish","Baby Pond Emperor",
        "Banditfish","Barbed Shark","Barracuda","Barreleye Fish","Basalt Loach","Basalt Pike",
        "Batfish","Bauble Bass","Beach Ball Pufferfish","Bearded Toadfish","Bellfin","Beluga",
        "Bigeye Houndshark","Bigeye Trevally","Bigfin Squid","Birgeria","Birthday Dumbo Octopus",
        "Birthday Goldfish","Birthday Megalodon","Birthday Squid","Black Dragon Fish",
        "Black Ghost Knifefish","Black Grouper","Black Scabbardfish","Black Snoek",
        "Black Swallower","Black Veil Ray","Blackfin Barracuda","Blackfish","Blackmouth Catshark",
        "Blackspot Tuskfish","Blazebelly","Blind Swamp Eel","Blisterback Blenny","Blistered Eel",
        "Blisterfish","Blobfish","Bloodscript Eel","Bloomtail","Bloop Fish","Blue Foamtail",
        "Blue Langanose","Blue Ribbon Eel","Blue Tang","Blue Whale","Bluefin Tuna","Bluefish",
        "Bluegem Angelfish","Bluegill","Bluehead Wrasse","Bluelip Batfish","Boarfish",
        "Bog Lantern Goby","Bogscale","Bone Lanternfish","Bowfin","Brackscale","Breaker Moth",
        "Bream","Brimstone Angler","Brine Phantom","Brine Sovereign","Bronze Corydoras",
        "Buccaneer Barracuda","Bull Shark","Bumpy Snailfish","Burbot","Burnt Betta","Butterflyfish",
        "Candle Carp","Candy Cane Carp","Candy Cane Cod","Candy Fish","Canopy Tetra","Capybass",
        "Cardinal Tetra","Carol Carp","Carp","Carrot Eel","Carrot Goldfish","Carrot Minnow",
        "Carrot Pufferfish","Carrot Salmon","Carrot Shark","Carrot Snapper","Carrot Turtle",
        "Cataclysm Carp","Catfish","Cathulid","Cathulith","Caustic Starwyrm","Cave Angel Fish",
        "Cave Loach","Celestial Koi","Charybdis","Chasm Leech","Chillback Whitefish",
        "Chillfin Chimaera","Chillfin Herring","Chillshadow Chub","Chinfish","Chinook Salmon",
        "Chronos Deep Swimmer","Chub","Cinder Carp","Cinder Dart","Cindercoil Eel","Cladoselache",
        "Clout Carp","Clowned Triggerfish","Clownfish","Cluckfin","Coalfin Darter",
        "Cobalt Angelfish","Cobia","Cockatoo Squid","Cod","Coelacanth","Coffin Crab",
        "Coin Piranha","Coin Squid","Coin Triggerfish","Colossal Carp","Colossal Saccopharynx",
        "Colossal Squid","Column Crawler","Coney Grouper","Confetti Carp","Confetti Shark",
        "Cookiecutter Shark","Copper Rockfish","Coral Chromis","Coral Emperor","Coral Guard",
        "Coral Turkey","Cornetfish","Corsair Grouper","Countdown Perch","Crag-Crab","Cragscale",
        "Crawling Angler","Crescent Madtom","Crestscale","Crocokoi","Crown Bass",
        "Crowned Anglerfish","Crowned Royal Gramma","Crustal Colossus","Cryo Coelacanth",
        "Cryoshock Serpent",
    },
    Default  = {},
    Callback = function(selected)
        _G.MengSnapFilterFish = selected
    end,
})

local SnapFilterMutationDropdown = SnapSection:AddDropdown({
    Title   = "Snap Filter Mutation",
    Content = "Select target mutation to keep",
    Multi   = true,
    Options = {
        "67","Abyssal","Albino","Alien","Amber","Amped","Anomalous","Ascended","Ashen Fortune",
        "Astraeus","Astral","Atlantean","Atomic","Aureate","Aurelian","Aureolin","Aurora",
        "Aurous","Aurulent","Awesome","Batty","Beachy","Birthday","Blarney","Blessed","Blighted",
        "Bloom","Blue","Blue Moon","Boreal","Botanic","Breezed","Brined","Brother","Brown Wood",
        "Bubblegum","Candy","Carrot","Celestial","Cement","Chaotic","Charred","Chilled",
        "Chlorowoken","Chocolate","Clover","Colossal Ink","Coral","Corvid","Cracked","Crimson",
        "Crystalized","Cursed","Cursed Touch","Darkened","Darkness","Dirty","Distraught",
        "Diurnal","Doomsday","Easter","Eerie","Electric","Electric Shock","Ember","Emberflame",
        "Embraced","Evil","Exploded","Fabulous","Fallen","Female","Festive","Firework","Fixer",
        "Flora","Forgotten","Fortune","Fossilized","Fragmented","Frightful","Frostbitten",
        "Frostnova","Frozen","Fungal","Galactic","Galaxy","Gemstone","Ghastly","Gingerbread",
        "Glacial","Gleebous","Glossy","Glowy","Glyphed","Golden","Gravy","Greedy","Green",
        "Green Leaf","Harmonized","Haunted","Heartburst","Heavenly","Hexed","Honked","Husk",
        "Igneous","Infernal","Jack's Curse","Jackpot","Jingle Bell","Jolly","King's Blessing",
        "Levitas","Lightened","Lightning","Lobster","Lost","Lovely","Lovestruck","Lucid",
        "Luminescent","Lumpy","Lunar","Lustrous","Mace","Madness","Magical","Mango","Mastered",
        "Mayhem","Merry","Midas","Minty","Mission Specialist","Moon-Kissed","Mosaic","Mossy",
        "Mother Nature","Mourned","Mythical","Necrotic","Negative","Neon","New Years",
        "Nico's Nyantics","Nightmare","Noctic","Nocturnal","Nova","Nuclear","Nullified","Oak",
        "Oblivion","Obsidian","Ocean's Ruin","Oscar","Paleontologist","Pancake","Part",
        "Patriotic","Peppermint","Permafrost","Phantom","Pink","Poisoned","Popsicle","Prismize",
        "Purified","Puritas","Putrid","Quiet","Radiant","Rainbow","Rainbow Cluster","Red",
        "Requies","Revitalized","Rockstar","Rooted","Rose","Royal","Rusty","Sacratus",
        "Sandstormy","Sandy","Sanguine","Santa","Scorched","Seasonal","Serene","Shrouded",
        "Silver","Sinister","Siren's Spite","Skrunkly","Sleet","Smurf","Snowy",
    },
    Default  = {},
    Callback = function(selected)
        _G.MengSnapFilterMutation = selected
    end,
})

SnapSection:AddInput({
    Title       = "Target Fish (if it is not in the dropdown)",
    Content     = "Use if no fish name on list",
    Placeholder = "Write ur input here",
    Default     = "",
    Callback    = function(value)
        _G.MengCustomTargetFish = value
    end,
})

SnapSection:AddToggle({
    Title    = "Snap Reel",
    Content  = "Released if the fish does not meet the target",
    Default  = false,
    Callback = function(state)
        _G.MengSnapReel = state
        notify("Snap Reel " .. (state and "enabled." or "disabled."))
    end,
})

-- ---- Sell Features ----
local SellSection = Tabs.Main:AddSection("Sell Features")

SellSection:AddInput({
    Title       = "Sell Interval (s)",
    Placeholder = "Write ur input here",
    Default     = "",
    Callback    = function(value)
        _G.MengSellInterval = tonumber(value) or 30
    end,
})

SellSection:AddToggle({
    Title    = "Auto Sell",
    Default  = false,
    Callback = function(state)
        _G.MengAutoSell = state
        notify("Auto Sell " .. (state and "enabled." or "disabled."))
    end,
})

-- ============================================================
-- TAB: Shop
-- ============================================================

local RodShopSection = Tabs.Shop:AddSection("Rod Shop")

-- Rod names are fetched dynamically at runtime; placeholder list here
local RodShopDropdown = RodShopSection:AddDropdown({
    Title    = "Select Rod",
    Content  = "Select rod u want to buy",
    Options  = { "Loading..." },
    Default  = "Loading...",
    Callback = function(value)
        _G.MengSelectedRod = value
    end,
})

task.spawn(function()
    -- Dynamically populate rod list
    local ok, RodSkins = pcall(function()
        return ReplicatedStorage:WaitForChild("shared", 10):WaitForChild("modules", 10):WaitForChild("RodSkins", 10)
    end)
    if ok and RodSkins then
        local rodNames = {}
        for _, v in pairs(RodSkins:GetChildren()) do
            if v.Name:find("Rod") then
                table.insert(rodNames, v.Name)
            end
        end
        if #rodNames > 0 then
            RodShopDropdown:SetValues(rodNames, rodNames[1])
        end
    end
end)

RodShopSection:AddButton({
    Title    = "Buy Selected Rod",
    Callback = function()
        notify("Buying rod: " .. tostring(_G.MengSelectedRod))
        -- stub: buy rod logic
    end,
})

local BaitShopSection = Tabs.Shop:AddSection("Bait Shop")

BaitShopSection:AddDropdown({
    Title    = "Select Bait",
    Content  = "Choose a Bait to Purchase",
    Options  = {
        "Common Crate","Tropical Bait Crate","Carbon Crate","Bait Crate",
        "Quality Bait Crate","Coral Geode","Volcanic Geode","Festival Bait Crate",
    },
    Default  = {},
    Callback = function(value)
        _G.MengSelectedBait = value
    end,
})

BaitShopSection:AddInput({
    Title       = "Buy Amount (Bait)",
    Content     = "Buy selected Bait as much u want",
    Placeholder = "Write ur input here",
    Default     = "",
    Callback    = function(value)
        _G.MengBaitAmount = tonumber(value) or 1
    end,
})

BaitShopSection:AddButton({
    Title    = "Buy Selected Bait",
    Callback = function()
        notify("Buying bait: " .. tostring(_G.MengSelectedBait))
        -- stub: buy bait logic
    end,
})

local TotemShopSection = Tabs.Shop:AddSection("Totem Shop")

TotemShopSection:AddInput({
    Title       = "Buy Amount (Totem)",
    Content     = "Buy selected Totem as much u want",
    Placeholder = "Write ur input here",
    Default     = "",
    Callback    = function(value)
        _G.MengTotemAmount = tonumber(value) or 1
    end,
})

local TotemList = {
    "Windset Totem","Clearcast Totem","Frost Moon Totem","Frightful Pool Totem",
    "Rainbow Totem","Scylla Hunt Totem","Kraken Hunt Totem","Shiny Totem",
    "Starfall Totem","Dripstone Collapse Totem","Meteor Totem","Cursed Storm Totem",
    "Poseidon Wrath Totem","Zeus Storm Totem","Smokescreen Totem","Tempest Totem",
    "Blizzard Totem","Eclipse Totem","Aurora Totem","Blue Moon Totem",
    "Avalanche Totem","Colossal Dragon Hunt Totem","Mutation Totem",
    "Sparkling Totem","Megalodon Hunt Totem","Sundial Totem",
}

TotemShopSection:AddDropdown({
    Title    = "Select Totem",
    Content  = "Choose a Totem to Purchase",
    Options  = TotemList,
    Default  = {},
    Callback = function(value)
        _G.MengSelectedTotem = value
    end,
})

TotemShopSection:AddButton({
    Title    = "Buy Selected Totem",
    Callback = function()
        notify("Buying totem: " .. tostring(_G.MengSelectedTotem))
        -- stub: buy totem logic
    end,
})

local BoatShopSection = Tabs.Shop:AddSection("Boat Shop")

BoatShopSection:AddButton({
    Title    = "Open/Close Boat Shop UI",
    Callback = function()
        -- stub: open/close boat shop UI
        notify("Toggling Boat Shop UI...")
    end,
})

local BlackMarketSection = Tabs.Shop:AddSection("Black Market")

BlackMarketSection:AddButton({
    Title    = "Open/Close Black Market UI",
    Callback = function()
        -- stub: open/close black market UI
        notify("Toggling Black Market UI...")
    end,
})

local DailyShopSection = Tabs.Shop:AddSection("Daily Shop")

DailyShopSection:AddButton({
    Title    = "Open/Close Daily Shop UI",
    Callback = function()
        -- stub: open/close daily shop UI
        notify("Toggling Daily Shop UI...")
    end,
})

-- ============================================================
-- TAB: Automatic
-- ============================================================

local TotemAutoSection = Tabs.Automatic:AddSection("Totem")

TotemAutoSection:AddDropdown({
    Title    = "Select Day Totem",
    Options  = TotemList,
    Default  = {},
    Callback = function(value)
        _G.MengDayTotem = value
    end,
})

TotemAutoSection:AddDropdown({
    Title    = "Select Night Totem",
    Options  = TotemList,
    Default  = {},
    Callback = function(value)
        _G.MengNightTotem = value
    end,
})

TotemAutoSection:AddSlider({
    Title    = "Use Totem Delay (seconds)",
    Content  = "Re-use totem every X seconds",
    Min      = 1,
    Max      = 120,
    Increment = 1,
    Default  = 60,
    Callback = function(value)
        _G.MengTotemDelay = value
    end,
})

TotemAutoSection:AddToggle({
    Title    = "Auto Totem",
    Default  = false,
    Callback = function(state)
        _G.MengAutoTotem = state
        notify("Auto Totem " .. (state and "enabled." or "disabled."))
    end,
})

local EnchantSection = Tabs.Automatic:AddSection("Enchant")

EnchantSection:AddDropdown({
    Title   = "Select Target",
    Multi   = true,
    Options = {
        "Sea King","Swift","Long","Ghastly","Lucky","Divine","Mutated","Unbreakable",
        "Steady","Blessed","Wormhole","Resilient","Controlled","Storming","Scrapper",
        "Breezed","Insight","Noir","Hasty","Quality","Abyssal","Clever",
    },
    Default  = {},
    Callback = function(selected)
        _G.MengEnchantTargets = selected
    end,
})

EnchantSection:AddToggle({
    Title    = "Auto Enchant Altar",
    Default  = false,
    Callback = function(state)
        _G.MengAutoEnchant = state
        notify("Auto Enchant Altar " .. (state and "enabled." or "disabled."))
    end,
})

EnchantSection:AddButton({
    Title    = "Teleport To Enchant Altar",
    Callback = function()
        notify("Teleporting to Enchant Altar...")
        -- stub: teleport to enchant altar logic
    end,
})

local VialSection = Tabs.Automatic:AddSection("Auto Claim Vial [Cerebra Rod]")

VialSection:AddToggle({
    Title    = "Enable Auto Vial",
    Default  = false,
    Callback = function(state)
        _G.MengAutoVial = state
        notify("Auto Vial " .. (state and "enabled." or "disabled."))
    end,
})

local StarfallSection = Tabs.Automatic:AddSection("Starfall")

local StarCraterParagraph = StarfallSection:AddParagraph({
    Title   = "StarCrater exists:",
    Content = "Loading...",
})

task.spawn(function()
    -- stub: check starfall craters
end)

StarfallSection:AddToggle({
    Title    = "Auto Collect Star Crater",
    Default  = false,
    Callback = function(state)
        _G.MengAutoStarCrater = state
        notify("Auto Collect Star Crater " .. (state and "enabled." or "disabled."))
    end,
})

-- ============================================================
-- TAB: Teleport
-- ============================================================

local TeleportSection = Tabs.Teleport:AddSection("Teleport")

TeleportSection:AddSubSection("Teleport Location")

local TeleportLocationDropdown = TeleportSection:AddDropdown({
    Title   = "Select Location",
    Options = {
        "???","Abyssal Zenith","Ancient Archives","Ancient Isle","Atlantean Storm","Atlantis",
        "Behind Waterfall","Birch Cay","Blue Moon - First Sea","Boreal Pines","Brine Pool",
        "Calm Zone","Carrot Garden","Castaway Cliffs","Challenger's Deep","Collapsed Ruins",
        "Coral Bestion","Crimson Cavern","Crowned Ruins","Cryogenic Canal","Crystal Cove",
        "Crystal Fissure","Cultist Lair","Cultist Lair - Entrance","Cupid's Island",
        "Detonator's Rest","Disolate Deep","Earmark Island","Ethereal Abyss","Ethereal Trial",
        "Executive Headquaters","Forgotten Tample","Forsaken Shores","Frigid Cavern",
        "Ghost Tavern","Glacial Grotto","Grand Reef","Haddock Rock","Half of Whisper",
        "Harvesters Spike","Inner Tidefall Castle","Keepers Altar","Kraken Pool",
        "Liminescent Cavern","Lost Jungle","Merlins Hut","Mineshaft","Mosewood","Mossjaw Rest",
        "Mushgrove","Mysterious Crack","Mysterious River","OverGrowth Caves","Passage of Oaths",
        "Poseidon Tample","Poseidon Trial","Roslit Bay","Roslit Hamlet","Roslit Pond",
        "Roslit Volcano","Scoria Reach","Snow Burrow","Snowcap","Snowcap Cave",
        "Statue Of Sovereignty","Sunken Depths","Sunken Reliquary","Sunken Trial","Sunstone",
        "Sunstone Rift","Sweetheart Shores","Terrapin","Terrapin Island Cave","Thalassar's Secret",
        "The Arch","The Bunker","The Depths","The Depths - Maze","The Keeper's Secret",
        "The Sanctum","The Void","Tidefall","Treasure Island","Trident","Trident Entrance",
        "Underground Music Venue","Underwater Cave","Underwater Opening","Upper Snowcap",
        "Veil of the Forsaken","Vertigo","Vertigo Dip","Zeus Trial","Zeus's Rod Room",
    },
    Default  = "???",
    Callback = function(value)
        _G.MengTeleportLocation = value
    end,
})

TeleportSection:AddInput({
    Title       = "Teleport Coordinate",
    Content     = "u must be input (x, y, z)",
    Placeholder = "Write ur input here",
    Default     = "",
    Callback    = function(value)
        _G.MengTeleportCoords = value
    end,
})

TeleportSection:AddButton({
    Title    = "Teleport to Location",
    Callback = function()
        local loc = _G.MengTeleportLocation
        if not loc or loc == "???" then
            notify("Please select a location first.")
            return
        end
        notify("Teleporting to: " .. loc)
        -- stub: teleport to location logic using CFrame lookup table
    end,
})

TeleportSection:AddSubSection("Teleport Event Zone")

-- ============================================================
-- TAB: Misc
-- ============================================================

local MiscSection = Tabs.Misc:AddSection("Misc")

MiscSection:AddParagraph({
    Title   = "Misc",
    Content = "Miscellaneous features will appear here.",
})

-- ============================================================
-- TAB: Configuration
-- ============================================================

local ConfigSection = Tabs.Configuration:AddSection("Configuration", true)

ConfigSection:AddButton({
    Title    = "Reset Configuration",
    Callback = function()
        local gameName = game.PlaceId
        local configPath = "MengHub/Config/MengHub_" .. gameName .. ".json"
        if isfile and isfile(configPath) then
            delfile(configPath)
            notify("Configuration has been reset!")
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            notify("No configuration file found.")
        end
    end,
})

ConfigSection:AddButton({
    Title    = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
        notify("GUI destroyed.")
    end,
})

-- ============================================================
-- [[ Initial Notify ]]
-- ============================================================
if Window then
    notify("Meng Hub loaded successfully!", 4, Color3.fromRGB(57, 255, 20), "Meng Hub", "Welcome!")
end
