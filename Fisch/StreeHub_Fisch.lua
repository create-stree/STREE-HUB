-- ============================================================
-- StreeHub | Fisch — Full Script
-- ============================================================

-- [[ Services ]]
local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService          = game:GetService("GuiService")
local VirtualUser         = game:GetService("VirtualUser")
local RunService          = game:GetService("RunService")
local TeleportService     = game:GetService("TeleportService")
local HttpService         = game:GetService("HttpService")
local Workspace           = game:GetService("Workspace")
local LocalPlayer         = Players.LocalPlayer
local PlayerGui           = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- [[ Anti-AFK ]]
-- ============================================================
local AntiAFKConnection
AntiAFKConnection = LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    warn("Anti-AFK: Aktivitas terdeteksi, mencegah diskoneksi.")
end)
warn("Anti AFK Automatic On!")

-- ============================================================
-- [[ Anti Gameplay Paused ]]
-- ============================================================
RunService.PreSimulation:Connect(function()
    LocalPlayer.GameplayPaused = false
end)
warn("Anti-Gameplay Paused Active!")

-- ============================================================
-- [[ Network Optimization ]]
-- ============================================================
settings().Network.IncomingReplicationLag = 0

-- ============================================================
-- [[ Load StreeHub UI ]]
-- ============================================================
local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

-- ============================================================
-- [[ Window ]]
-- ============================================================
local Window = StreeHub:Window({
    Title             = "StreeHub |",
    Footer            = "[v1.0.0]",
    Images            = "128806139932217",
    Color             = Color3.fromRGB(57, 255, 20),
    ["Tab Width"]     = 120,
    Version           = 1,
})

-- ============================================================
-- [[ Notify Helper ]]
-- ============================================================
local function notify(msg, delay, color, title, desc)
    return StreeHub:MakeNotify({
        Title       = title or "StreeHub",
        Description = desc  or "Notification",
        Content     = msg   or "...",
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
    Shop          = Window:AddTab({ Name = "Shop",          Icon = "bag"      }),
    Automatic     = Window:AddTab({ Name = "Automatic",     Icon = "player"   }),
    Teleport      = Window:AddTab({ Name = "Teleport",      Icon = "gps"      }),
    Misc          = Window:AddTab({ Name = "Misc",          Icon = "menu"     }),
    Settings      = Window:AddTab({ Name = "Settings",      Icon = "settings" }),
}

-- ============================================================
-- TAB: About
-- ============================================================

local AboutSection = Tabs.About:AddSection("About StreeHub?")

AboutSection:AddParagraph({
    Title   = "What is StreeHub?",
    Content = "StreeHub is a personal project dedicated to the community.\nThis script is built with passion and serves as a milestone in our coding journey.\nAs we are continuously developing and improving this tool,\nyou might encounter some bugs. We are committed to providing the most seamless Fisch experience possible.\nThank you for being part of this journey!",
    Icon    = "star",
})

AboutSection:AddParagraph({
    Title          = "StreeHub Discord",
    Content        = "Join our Discord community!",
    Icon           = "discord",
    ButtonText     = "COPY LINK",
    ButtonCallback = function()
        local link = "https://discord.gg/streehub"
        if setclipboard then
            setclipboard(link)
            notify("Discord link copied to clipboard!")
        else
            notify("Executor does not support setclipboard.")
        end
    end,
})

AboutSection:AddDivider()

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
            local exists = ok and zonesFolder and zonesFolder:FindFirstChild(name) ~= nil
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

-- Internal auto-shake loop (used by toggle)
local _autoShakeActive = false
task.spawn(function()
    while true do
        if _autoShakeActive then
            pcall(function()
                local shakeui  = PlayerGui:FindFirstChild("shakeui")
                local safezone = shakeui and shakeui:FindFirstChild("safezone")
                local button   = safezone and safezone:FindFirstChild("button")
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
local HelperSection = Tabs.Main:AddSection("StreeHub | Helper Support")

HelperSection:AddToggle({
    Title    = "Show Real Ping",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_ShowPing = state
        notify("Real Ping: " .. (state and "ON" or "OFF"))
    end,
})

HelperSection:AddToggle({
    Title    = "Auto Equip Rod",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoEquipRod = state
        notify("Auto Equip Rod: " .. (state and "ON" or "OFF"))
    end,
})

HelperSection:AddToggle({
    Title    = "Auto Equip Best Rod",
    Content  = "Automatically switches to the rod with the highest luck and lure speed",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoBestRod = state
        notify("Auto Equip Best Rod: " .. (state and "ON" or "OFF"))
    end,
})

HelperSection:AddToggle({
    Title    = "Anti Staff",
    Content  = "Automatically kick if any staff/dev join",
    Default  = true,
    Callback = function(state)
        _G.StreeHub_AntiStaff = state
        notify("Anti Staff: " .. (state and "ON" or "OFF"))
    end,
})

HelperSection:AddToggle({
    Title    = "Bypass Radar",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_BypassRadar = state
        notify("Bypass Radar: " .. (state and "ON" or "OFF"))
    end,
})

-- ---- Super Fast Catch ----
local FastCatchSection = Tabs.Main:AddSection("StreeHub | Super Fast Catch")

FastCatchSection:AddToggle({
    Title    = "Auto Cast",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoCast = state
        notify("Auto Cast: " .. (state and "ON" or "OFF"))
    end,
})

FastCatchSection:AddToggle({
    Title    = "Auto Shake",
    Default  = false,
    Callback = function(state)
        _autoShakeActive = state
        notify("Auto Shake: " .. (state and "ON" or "OFF"))
    end,
})

FastCatchSection:AddToggle({
    Title    = "Auto Reel",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoReel = state
        notify("Auto Reel: " .. (state and "ON" or "OFF"))
    end,
})

FastCatchSection:AddDivider()

FastCatchSection:AddToggle({
    Title    = "Instant Bobber",
    Default  = true,
    Callback = function(state)
        _G.StreeHub_InstantBobber = state
        notify("Instant Bobber: " .. (state and "ON" or "OFF"))
    end,
})

FastCatchSection:AddToggle({
    Title    = "Center Shake",
    Default  = true,
    Callback = function(state)
        _G.StreeHub_CenterShake = state
        notify("Center Shake: " .. (state and "ON" or "OFF"))
    end,
})

-- ---- Auto Fishing ----
local AutoFishSection = Tabs.Main:AddSection("StreeHub | Auto Fishing")

AutoFishSection:AddDropdown({
    Title    = "Catching Mode",
    Content  = "Choose fishing catching mode",
    Options  = { "Legit", "Fast" },
    Default  = "Legit",
    Callback = function(value)
        _G.StreeHub_CatchMode = value
        notify("Catching Mode: " .. value)
    end,
})

AutoFishSection:AddInput({
    Title       = "Shake Click Delay (s)",
    Placeholder = "e.g. 0.1",
    Default     = "",
    Callback    = function(value)
        _G.StreeHub_ShakeDelay = tonumber(value) or 0
    end,
})

AutoFishSection:AddInput({
    Title       = "Cast Animation Delay (s)",
    Placeholder = "e.g. 0.5",
    Default     = "",
    Callback    = function(value)
        _G.StreeHub_CastDelay = tonumber(value) or 0
    end,
})

AutoFishSection:AddToggle({
    Title    = "Enable Auto Fishing",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoFish = state
        notify("Auto Fishing: " .. (state and "ON" or "OFF"))
    end,
})

AutoFishSection:AddButton({
    Title    = "Cancel Fishing",
    Callback = function()
        _G.StreeHub_AutoFish = false
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
local SpearSection = Tabs.Main:AddSection("StreeHub | Auto Spear")

SpearSection:AddDropdown({
    Title    = "Spear Location",
    Content  = "Select location to teleport for spear fishing",
    Options  = { "Lost Jungle", "Coral Bastion", "Tidefall", "Colapse Ruin", "Crowned Ruins" },
    Default  = "Lost Jungle",
    Callback = function(value)
        _G.StreeHub_SpearLocation = value
    end,
})

SpearSection:AddToggle({
    Title    = "Enable Spearfishing",
    Content  = "Teleport and catch spear fish",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_SpearFish = state
        notify("Spearfishing: " .. (state and "ON" or "OFF"))
    end,
})

-- ---- Snap Reel ----
local SnapSection = Tabs.Main:AddSection("StreeHub | Snap Reel")

SnapSection:AddDropdown({
    Title   = "Snap Filter Fish",
    Content = "Select target fish to keep",
    Multi   = true,
    Options = {
        "Abyss Dart","Abyss Flicker","Abyss Snapper","Abyssacuda",
        "Abyssal Bearded Seadevil","Abyssal Devourer","Abyssal Goliath",
        "Abyssal Grenadier","Abyssal King","Abyssal Maw","Abyssal Slickhead",
        "Abyssborn Monstrosity","Acanthodii","Aetherfin","Akkorokamui",
        "Algae Lurker","Alligator","Alligator Gar","Amberjack","Amblypterus",
        "Anchovy","Ancient Depth Serpent","Ancient Eel","Ancient Kraken",
        "Ancient Megalodon","Ancient Orca","Angelfish","Anglerfish","Anomalocaris",
        "Antarctic Icefish","Apex Leviathan","Aqua Scribe","Arapaima","Arctic Char",
        "Armorhead","Ashclaw","Ashcloud Archerfish","Ashscale Minnow",
        "Atlantean Alchemist","Atlantean Anchovy","Atlantean Guardian",
        "Atlantean Sardine","Atlantic Goliath Grouper","Atlantic Halosaur",
        "Atolla Jellyfish","Aurora Trout","Axolotl","Azure Prowler",
        "Baby Bloop Fish","Baby Pond Emperor","Banditfish","Barbed Shark",
        "Barracuda","Barreleye Fish","Basalt Loach","Basalt Pike","Batfish",
        "Bauble Bass","Beach Ball Pufferfish","Bearded Toadfish","Bellfin",
        "Beluga","Bigeye Houndshark","Bigeye Trevally","Bigfin Squid","Birgeria",
        "Birthday Dumbo Octopus","Birthday Goldfish","Birthday Megalodon",
        "Birthday Squid","Black Dragon Fish","Black Ghost Knifefish","Black Grouper",
        "Black Scabbardfish","Black Snoek","Black Swallower","Black Veil Ray",
        "Blackfin Barracuda","Blackfish","Blackmouth Catshark","Blackspot Tuskfish",
        "Blazebelly","Blind Swamp Eel","Blisterback Blenny","Blistered Eel",
        "Blisterfish","Blobfish","Bloodscript Eel","Bloomtail","Bloop Fish",
        "Blue Foamtail","Blue Langanose","Blue Ribbon Eel","Blue Tang","Blue Whale",
        "Bluefin Tuna","Bluefish","Bluegem Angelfish","Bluegill","Bluehead Wrasse",
        "Bluelip Batfish","Boarfish","Bog Lantern Goby","Bogscale","Bone Lanternfish",
        "Bowfin","Brackscale","Breaker Moth","Bream","Brimstone Angler",
        "Brine Phantom","Brine Sovereign","Bronze Corydoras","Buccaneer Barracuda",
        "Bull Shark","Bumpy Snailfish","Burbot","Burnt Betta","Butterflyfish",
        "Candle Carp","Candy Cane Carp","Candy Cane Cod","Candy Fish","Canopy Tetra",
        "Capybass","Cardinal Tetra","Carol Carp","Carp","Carrot Eel","Carrot Goldfish",
        "Carrot Minnow","Carrot Pufferfish","Carrot Salmon","Carrot Shark",
        "Carrot Snapper","Carrot Turtle","Cataclysm Carp","Catfish","Cathulid",
        "Cathulith","Caustic Starwyrm","Cave Angel Fish","Cave Loach","Celestial Koi",
        "Charybdis","Chasm Leech","Chillback Whitefish","Chillfin Chimaera",
        "Chillfin Herring","Chillshadow Chub","Chinfish","Chinook Salmon",
        "Chronos Deep Swimmer","Chub","Cinder Carp","Cinder Dart","Cindercoil Eel",
        "Cladoselache","Clout Carp","Clowned Triggerfish","Clownfish","Cluckfin",
        "Coalfin Darter","Cobalt Angelfish","Cobia","Cockatoo Squid","Cod",
        "Coelacanth","Coffin Crab","Coin Piranha","Coin Squid","Coin Triggerfish",
        "Colossal Carp","Colossal Saccopharynx","Colossal Squid","Column Crawler",
        "Coney Grouper","Confetti Carp","Confetti Shark","Cookiecutter Shark",
        "Copper Rockfish","Coral Chromis","Coral Emperor","Coral Guard","Coral Turkey",
        "Cornetfish","Corsair Grouper","Countdown Perch","Crag-Crab","Cragscale",
        "Crawling Angler","Crescent Madtom","Crestscale","Crocokoi","Crown Bass",
        "Crowned Anglerfish","Crowned Royal Gramma","Crustal Colossus",
        "Cryo Coelacanth","Cryoshock Serpent",
    },
    Default  = {},
    Callback = function(selected)
        _G.StreeHub_SnapFilterFish = selected
    end,
})

SnapSection:AddDropdown({
    Title   = "Snap Filter Mutation",
    Content = "Select target mutation to keep",
    Multi   = true,
    Options = {
        "67","Abyssal","Albino","Alien","Amber","Amped","Anomalous","Ascended",
        "Ashen Fortune","Astraeus","Astral","Atlantean","Atomic","Aureate","Aurelian",
        "Aureolin","Aurora","Aurous","Aurulent","Awesome","Batty","Beachy","Birthday",
        "Blarney","Blessed","Blighted","Bloom","Blue","Blue Moon","Boreal","Botanic",
        "Breezed","Brined","Brother","Brown Wood","Bubblegum","Candy","Carrot",
        "Celestial","Cement","Chaotic","Charred","Chilled","Chlorowoken","Chocolate",
        "Clover","Colossal Ink","Coral","Corvid","Cracked","Crimson","Crystalized",
        "Cursed","Cursed Touch","Darkened","Darkness","Dirty","Distraught","Diurnal",
        "Doomsday","Easter","Eerie","Electric","Electric Shock","Ember","Emberflame",
        "Embraced","Evil","Exploded","Fabulous","Fallen","Female","Festive","Firework",
        "Fixer","Flora","Forgotten","Fortune","Fossilized","Fragmented","Frightful",
        "Frostbitten","Frostnova","Frozen","Fungal","Galactic","Galaxy","Gemstone",
        "Ghastly","Gingerbread","Glacial","Gleebous","Glossy","Glowy","Glyphed",
        "Golden","Gravy","Greedy","Green","Green Leaf","Harmonized","Haunted",
        "Heartburst","Heavenly","Hexed","Honked","Husk","Igneous","Infernal",
        "Jack's Curse","Jackpot","Jingle Bell","Jolly","King's Blessing","Levitas",
        "Lightened","Lightning","Lobster","Lost","Lovely","Lovestruck","Lucid",
        "Luminescent","Lumpy","Lunar","Lustrous","Mace","Madness","Magical","Mango",
        "Mastered","Mayhem","Merry","Midas","Minty","Mission Specialist","Moon-Kissed",
        "Mosaic","Mossy","Mother Nature","Mourned","Mythical","Necrotic","Negative",
        "Neon","New Years","Nico's Nyantics","Nightmare","Noctic","Nocturnal","Nova",
        "Nuclear","Nullified","Oak","Oblivion","Obsidian","Ocean's Ruin","Oscar",
        "Paleontologist","Pancake","Part","Patriotic","Peppermint","Permafrost",
        "Phantom","Pink","Poisoned","Popsicle","Prismize","Purified","Puritas",
        "Putrid","Quiet","Radiant","Rainbow","Rainbow Cluster","Red","Requies",
        "Revitalized","Rockstar","Rooted","Rose","Royal","Rusty","Sacratus",
        "Sandstormy","Sandy","Sanguine","Santa","Scorched","Seasonal","Serene",
        "Shrouded","Silver","Sinister","Siren's Spite","Skrunkly","Sleet","Smurf","Snowy",
    },
    Default  = {},
    Callback = function(selected)
        _G.StreeHub_SnapFilterMutation = selected
    end,
})

SnapSection:AddInput({
    Title       = "Target Fish (if not in dropdown)",
    Content     = "Use if fish name is not in the list above",
    Placeholder = "Write fish name here",
    Default     = "",
    Callback    = function(value)
        _G.StreeHub_CustomTargetFish = value
    end,
})

SnapSection:AddToggle({
    Title    = "Snap Reel",
    Content  = "Released if the fish does not meet the target",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_SnapReel = state
        notify("Snap Reel: " .. (state and "ON" or "OFF"))
    end,
})

-- ---- Sell Features ----
local SellSection = Tabs.Main:AddSection("StreeHub | Sell Features")

SellSection:AddInput({
    Title       = "Sell Interval (s)",
    Placeholder = "e.g. 30",
    Default     = "",
    Callback    = function(value)
        _G.StreeHub_SellInterval = tonumber(value) or 30
    end,
})

SellSection:AddToggle({
    Title    = "Auto Sell",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoSell = state
        notify("Auto Sell: " .. (state and "ON" or "OFF"))
    end,
})

-- ============================================================
-- TAB: Shop
-- ============================================================

-- ---- Rod Shop ----
local RodShopSection = Tabs.Shop:AddSection("StreeHub | Rod Shop")

local RodShopDropdown = RodShopSection:AddDropdown({
    Title    = "Select Rod",
    Content  = "Select rod you want to buy",
    Options  = { "Loading..." },
    Default  = "Loading...",
    Callback = function(value)
        _G.StreeHub_SelectedRod = value
    end,
})

task.spawn(function()
    local ok, RodSkins = pcall(function()
        return ReplicatedStorage
            :WaitForChild("shared", 10)
            :WaitForChild("modules", 10)
            :WaitForChild("RodSkins", 10)
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
        if not _G.StreeHub_SelectedRod then
            notify("Please select a rod first.")
            return
        end
        notify("Buying rod: " .. tostring(_G.StreeHub_SelectedRod))
        -- buy rod logic here
    end,
})

-- ---- Bait Shop ----
local BaitShopSection = Tabs.Shop:AddSection("StreeHub | Bait Shop")

BaitShopSection:AddDropdown({
    Title    = "Select Bait",
    Content  = "Choose a Bait to Purchase",
    Options  = {
        "Common Crate", "Tropical Bait Crate", "Carbon Crate", "Bait Crate",
        "Quality Bait Crate", "Coral Geode", "Volcanic Geode", "Festival Bait Crate",
    },
    Default  = {},
    Callback = function(value)
        _G.StreeHub_SelectedBait = value
    end,
})

BaitShopSection:AddInput({
    Title       = "Buy Amount (Bait)",
    Content     = "Buy selected Bait as much as you want",
    Placeholder = "e.g. 10",
    Default     = "",
    Callback    = function(value)
        _G.StreeHub_BaitAmount = tonumber(value) or 1
    end,
})

BaitShopSection:AddButton({
    Title    = "Buy Selected Bait",
    Callback = function()
        notify("Buying bait: " .. tostring(_G.StreeHub_SelectedBait or "none"))
        -- buy bait logic here
    end,
})

-- ---- Totem Shop ----
local TotemList = {
    "Windset Totem","Clearcast Totem","Frost Moon Totem","Frightful Pool Totem",
    "Rainbow Totem","Scylla Hunt Totem","Kraken Hunt Totem","Shiny Totem",
    "Starfall Totem","Dripstone Collapse Totem","Meteor Totem","Cursed Storm Totem",
    "Poseidon Wrath Totem","Zeus Storm Totem","Smokescreen Totem","Tempest Totem",
    "Blizzard Totem","Eclipse Totem","Aurora Totem","Blue Moon Totem",
    "Avalanche Totem","Colossal Dragon Hunt Totem","Mutation Totem",
    "Sparkling Totem","Megalodon Hunt Totem","Sundial Totem",
}

local TotemShopSection = Tabs.Shop:AddSection("StreeHub | Totem Shop")

TotemShopSection:AddInput({
    Title       = "Buy Amount (Totem)",
    Content     = "Buy selected Totem as much as you want",
    Placeholder = "e.g. 5",
    Default     = "",
    Callback    = function(value)
        _G.StreeHub_TotemAmount = tonumber(value) or 1
    end,
})

TotemShopSection:AddDropdown({
    Title    = "Select Totem",
    Content  = "Choose a Totem to Purchase",
    Options  = TotemList,
    Default  = {},
    Callback = function(value)
        _G.StreeHub_SelectedTotem = value
    end,
})

TotemShopSection:AddButton({
    Title    = "Buy Selected Totem",
    Callback = function()
        notify("Buying totem: " .. tostring(_G.StreeHub_SelectedTotem or "none"))
        -- buy totem logic here
    end,
})

-- ---- Boat Shop ----
local BoatShopSection = Tabs.Shop:AddSection("StreeHub | Boat Shop")

BoatShopSection:AddButton({
    Title    = "Open/Close Boat Shop UI",
    Callback = function()
        notify("Toggling Boat Shop UI...")
        -- open/close boat shop UI logic here
    end,
})

-- ---- Black Market ----
local BlackMarketSection = Tabs.Shop:AddSection("StreeHub | Black Market")

BlackMarketSection:AddButton({
    Title    = "Open/Close Black Market UI",
    Callback = function()
        notify("Toggling Black Market UI...")
        -- open/close black market UI logic here
    end,
})

-- ---- Daily Shop ----
local DailyShopSection = Tabs.Shop:AddSection("StreeHub | Daily Shop")

DailyShopSection:AddButton({
    Title    = "Open/Close Daily Shop UI",
    Callback = function()
        notify("Toggling Daily Shop UI...")
        -- open/close daily shop UI logic here
    end,
})

-- ============================================================
-- TAB: Automatic
-- ============================================================

-- ---- Totem ----
local TotemAutoSection = Tabs.Automatic:AddSection("StreeHub | Totem")

TotemAutoSection:AddDropdown({
    Title    = "Select Day Totem",
    Options  = TotemList,
    Default  = {},
    Callback = function(value)
        _G.StreeHub_DayTotem = value
    end,
})

TotemAutoSection:AddDropdown({
    Title    = "Select Night Totem",
    Options  = TotemList,
    Default  = {},
    Callback = function(value)
        _G.StreeHub_NightTotem = value
    end,
})

TotemAutoSection:AddSlider({
    Title     = "Use Totem Delay (seconds)",
    Content   = "Re-use totem every X seconds",
    Min       = 1,
    Max       = 120,
    Increment = 1,
    Default   = 60,
    Callback  = function(value)
        _G.StreeHub_TotemDelay = value
    end,
})

TotemAutoSection:AddToggle({
    Title    = "Auto Totem",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoTotem = state
        notify("Auto Totem: " .. (state and "ON" or "OFF"))
    end,
})

-- ---- Enchant ----
local EnchantSection = Tabs.Automatic:AddSection("StreeHub | Enchant")

EnchantSection:AddDropdown({
    Title   = "Select Target Enchant",
    Multi   = true,
    Options = {
        "Sea King","Swift","Long","Ghastly","Lucky","Divine","Mutated","Unbreakable",
        "Steady","Blessed","Wormhole","Resilient","Controlled","Storming","Scrapper",
        "Breezed","Insight","Noir","Hasty","Quality","Abyssal","Clever",
    },
    Default  = {},
    Callback = function(selected)
        _G.StreeHub_EnchantTargets = selected
    end,
})

EnchantSection:AddToggle({
    Title    = "Auto Enchant Altar",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoEnchant = state
        notify("Auto Enchant Altar: " .. (state and "ON" or "OFF"))
    end,
})

EnchantSection:AddButton({
    Title    = "Teleport To Enchant Altar",
    Callback = function()
        notify("Teleporting to Enchant Altar...")
        -- teleport to enchant altar logic here
    end,
})

-- ---- Auto Claim Vial ----
local VialSection = Tabs.Automatic:AddSection("StreeHub | Auto Claim Vial [Cerebra Rod]")

VialSection:AddToggle({
    Title    = "Enable Auto Vial",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoVial = state
        notify("Auto Vial: " .. (state and "ON" or "OFF"))
    end,
})

-- ---- Starfall ----
local StarfallSection = Tabs.Automatic:AddSection("StreeHub | Starfall")

local StarCraterParagraph = StarfallSection:AddParagraph({
    Title   = "StarCrater exists:",
    Content = "Loading...",
})

task.spawn(function()
    while true do
        local ok, zonesFolder = pcall(function()
            return Workspace:WaitForChild("zones", 5):WaitForChild("fishing", 5)
        end)
        local exists = ok and zonesFolder and zonesFolder:FindFirstChild("StarCrater") ~= nil
        if StarCraterParagraph and StarCraterParagraph.SetContent then
            StarCraterParagraph:SetContent(exists and "✓ StarCrater found!" or "✗ Not found.")
        end
        task.wait(5)
    end
end)

StarfallSection:AddToggle({
    Title    = "Auto Collect Star Crater",
    Default  = false,
    Callback = function(state)
        _G.StreeHub_AutoStarCrater = state
        notify("Auto Collect Star Crater: " .. (state and "ON" or "OFF"))
    end,
})

-- ============================================================
-- TAB: Teleport
-- ============================================================

local TeleportSection = Tabs.Teleport:AddSection("StreeHub | Teleport")

TeleportSection:AddSubSection("Teleport Location")

local TeleportLocationDropdown = TeleportSection:AddDropdown({
    Title   = "Select Location",
    Options = {
        "???","Abyssal Zenith","Ancient Archives","Ancient Isle","Atlantean Storm",
        "Atlantis","Behind Waterfall","Birch Cay","Blue Moon - First Sea","Boreal Pines",
        "Brine Pool","Calm Zone","Carrot Garden","Castaway Cliffs","Challenger's Deep",
        "Collapsed Ruins","Coral Bestion","Crimson Cavern","Crowned Ruins",
        "Cryogenic Canal","Crystal Cove","Crystal Fissure","Cultist Lair",
        "Cultist Lair - Entrance","Cupid's Island","Detonator's Rest","Disolate Deep",
        "Earmark Island","Ethereal Abyss","Ethereal Trial","Executive Headquaters",
        "Forgotten Tample","Forsaken Shores","Frigid Cavern","Ghost Tavern",
        "Glacial Grotto","Grand Reef","Haddock Rock","Half of Whisper",
        "Harvesters Spike","Inner Tidefall Castle","Keepers Altar","Kraken Pool",
        "Liminescent Cavern","Lost Jungle","Merlins Hut","Mineshaft","Mosewood",
        "Mossjaw Rest","Mushgrove","Mysterious Crack","Mysterious River",
        "OverGrowth Caves","Passage of Oaths","Poseidon Tample","Poseidon Trial",
        "Roslit Bay","Roslit Hamlet","Roslit Pond","Roslit Volcano","Scoria Reach",
        "Snow Burrow","Snowcap","Snowcap Cave","Statue Of Sovereignty","Sunken Depths",
        "Sunken Reliquary","Sunken Trial","Sunstone","Sunstone Rift",
        "Sweetheart Shores","Terrapin","Terrapin Island Cave","Thalassar's Secret",
        "The Arch","The Bunker","The Depths","The Depths - Maze","The Keeper's Secret",
        "The Sanctum","The Void","Tidefall","Treasure Island","Trident",
        "Trident Entrance","Underground Music Venue","Underwater Cave",
        "Underwater Opening","Upper Snowcap","Veil of the Forsaken","Vertigo",
        "Vertigo Dip","Zeus Trial","Zeus's Rod Room",
    },
    Default  = "???",
    Callback = function(value)
        _G.StreeHub_TeleportLocation = value
    end,
})

TeleportSection:AddInput({
    Title       = "Teleport Coordinate",
    Content     = "Input format: x, y, z",
    Placeholder = "e.g. 100, 50, -200",
    Default     = "",
    Callback    = function(value)
        _G.StreeHub_TeleportCoords = value
    end,
})

TeleportSection:AddButton({
    Title    = "Teleport to Location",
    Callback = function()
        local loc = _G.StreeHub_TeleportLocation
        if not loc or loc == "???" then
            -- try coords
            local coords = _G.StreeHub_TeleportCoords or ""
            local x, y, z = coords:match("([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)")
            if x and y and z then
                local char = LocalPlayer.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
                    notify("Teleported to: " .. coords)
                else
                    notify("Character not found.")
                end
            else
                notify("Please select a location or enter valid coordinates.")
            end
            return
        end
        notify("Teleporting to: " .. loc)
        -- CFrame lookup table teleport logic here
    end,
})

TeleportSection:AddDivider()
TeleportSection:AddSubSection("Teleport Event Zone")

-- ============================================================
-- TAB: Misc
-- ============================================================

local MiscSection = Tabs.Misc:AddSection("StreeHub | Misc")

MiscSection:AddParagraph({
    Title   = "Miscellaneous",
    Content = "Additional miscellaneous features will appear here in future updates.",
    Icon    = "star",
})

MiscSection:AddButton({
    Title    = "Server Hop",
    Callback = function()
        notify("Looking for a new server...")
        task.spawn(function()
            local ok, result = pcall(function()
                local Servers = HttpService:JSONDecode(
                    game:HttpGetAsync("https://games.roblox.com/v1/games/" ..
                        game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                for _, v in pairs(Servers.data) do
                    if v.playing < v.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                        return
                    end
                end
                notify("No empty server found.")
            end)
            if not ok then
                notify("Server hop failed: " .. tostring(result))
            end
        end)
    end,
})

MiscSection:AddButton({
    Title    = "Rejoin Server",
    Callback = function()
        notify("Rejoining server...")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

-- ============================================================
-- TAB: Settings
-- ============================================================

local SettingsSection = Tabs.Settings:AddSection("StreeHub | Settings", true)

SettingsSection:AddToggle({
    Title    = "Show Button",
    Content  = "Show StreeHub button on screen.",
    Default  = true,
    Callback = function(state)
        local button = game:GetService("CoreGui"):FindFirstChild("StreeHubButton")
        if button then
            button.Enabled = state
        end
        notify("Button visibility: " .. (state and "ON" or "OFF"))
    end,
})

SettingsSection:AddButton({
    Title    = "Reset Configuration",
    Callback = function()
        local configPath = "StreeHub/Config/StreeHub_" .. tostring(game.PlaceId) .. ".json"
        if isfile and isfile(configPath) then
            delfile(configPath)
            notify("Configuration has been reset!")
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            notify("No configuration file found.")
        end
    end,
})

SettingsSection:AddButton({
    Title    = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
        notify("GUI has been destroyed.")
    end,
})

SettingsSection:AddPanel({
    Title          = "UI Color",
    Placeholder    = "255,0,0",
    ButtonText     = "Apply Color",
    ButtonCallback = function(colorText)
        local r, g, b = colorText:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            notify("UI Color changed to RGB(" .. r .. "," .. g .. "," .. b .. ")")
        else
            notify("Invalid color format! Use: R,G,B (e.g. 255,0,0)")
        end
    end,
    SubButtonText     = "Reset Color",
    SubButtonCallback = function()
        notify("UI Color reset to default.")
    end,
})

-- ============================================================
-- [[ Auto Save Config on Leave ]]
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    -- SaveConfig() -- uncomment if SaveConfig is defined
end)

game:BindToClose(function()
    -- SaveConfig() -- uncomment if SaveConfig is defined
end)

-- ============================================================
-- [[ Initial Notify ]]
-- ============================================================
if Window then
    notify(
        "StreeHub loaded successfully!",
        4,
        Color3.fromRGB(57, 255, 20),
        "StreeHub",
        "Welcome!"
    )
end

-- [[ Config Auto Load ]]
-- This library is auto save / load all element without any additional code
-- If you got bug in saved config, use SaveConfig() manually
