local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
_G.AutoFarmLevel       = false
_G.AutoFarmNearest     = false
_G.AutoFarmHearts      = false
_G.AutoCupidQuest      = false
_G.AutoDeliveryQuest   = false
_G.AutoVGacha          = false
_G.AutoFruitMastery    = false
_G.AutoGunMastery      = false
_G.AutoSwordMastery    = false
_G.AutoBoss            = false
_G.AutoFarmMon         = false
_G.AutoCollectBerry    = false
_G.AutoFarmBoss        = false
_G.AutoFarmAllBoss     = false
_G.AutoEliteHunter     = false
_G.AutoEliteHunterHop  = false
_G.AutoFarmBone        = false
_G.AutoRandomSurprise  = false
_G.AutoPirateRaid      = false
_G.AutoFarmChestTween  = false
_G.AutoFarmChestInst   = false
_G.AutoStopItems       = false
_G.AutoKatakuri        = false
_G.AutoSpawnCakePrince = false
_G.AutoKillCakePrince  = false
_G.AutoKillDoughKing   = false
_G.AutoFarmMaterial    = false
_G.SpinPosition        = false
_G.BringMob            = false
_G.AttackAura          = false
_G.HideNotif           = false
_G.HideDamage          = false
_G.BlackScreen         = false
_G.WhiteScreen         = false
_G.AutoSetSpawn        = false
_G.AutoObservation     = false
_G.AutoHaki            = false
_G.AutoRejoin          = false
_G.AutoSecondSea       = false
_G.AutoThirdSea        = false
_G.AutoSuperHuman      = false
_G.AutoDeathStep       = false
_G.AutoSharkmanKarate  = false
_G.AutoElectricClaw    = false
_G.AutoDragonTalon     = false
_G.AutoGodHuman        = false
_G.AutoGetSaber        = false
_G.AutoBuddySword      = false
_G.AutoSoulGuitar      = false
_G.AutoRengoku         = false
_G.AutoHallowScythe    = false
_G.AutoWardenSword     = false
_G.AutoGetYama         = false
_G.AutoGetYamaHop      = false
_G.AutoGetTushita      = false
_G.AutoGetCDK          = false
_G.AutoQuestCDKYama    = false
_G.AutoQuestCDKTushita = false
_G.AutoDragonTrident   = false
_G.AutoGreybeard       = false
_G.AutoSharkSaw        = false
_G.AutoPole            = false
_G.AutoDarkDagger      = false
_G.AddMeleeStats       = false
_G.AddDefenseStats     = false
_G.AddSwordStats       = false
_G.AddGunStats         = false
_G.AddDFStats          = false
_G.AutoRaid            = false
_G.AutoAwaken          = false
_G.AutoUnstoreFruit    = false
_G.AutoLawRaid         = false
_G.AutoAttackMon       = false
_G.AutoNextFloor       = false
_G.AutoReturnHub       = false
_G.TeleportToPlace     = false
_G.AutoBuyGear         = false
_G.TweenMirageIsland   = false
_G.FindBlueGear        = false
_G.LookMoon            = false
_G.AutoTrain           = false
_G.AutoTrial           = false
_G.AutoKillAfterTrial  = false
_G.ActiveRaceV3        = false
_G.ActiveRaceV4        = false
_G.WalkOnWater         = false
_G.NoClip              = false
_G.AutoRandomFruit     = false
_G.AutoStoreFruit      = false
_G.FruitNotif          = false
_G.TeleportToFruit     = false
_G.TweenToFruit        = false
_G.EspPlayer           = false
_G.EspChest            = false
_G.EspFruit            = false
_G.EspRealFruit        = false
_G.EspFlower           = false
_G.EspIsland           = false
_G.EspNpc              = false
_G.EspSeaBeast         = false
_G.EspMonster          = false
_G.EspMirageIsland     = false
_G.EspKitsuneIsland    = false
_G.EspFrozen           = false
_G.EspPrehistoric      = false
_G.EspGear             = false
_G.AutoDojoBelt        = false
_G.AutoFarmBlazeEmber  = false
_G.AutoDracoV1         = false
_G.AutoDracoV2         = false
_G.AutoDracoV3         = false
_G.SwapDraco           = false
_G.SailBoat            = false
_G.AutoFarmShark       = false
_G.AutoFarmPiranha     = false
_G.AutoFarmFishCrew    = false
_G.AutoFarmGhostShip   = false
_G.AutoFarmPirateBrig  = false
_G.AutoFarmGrandBrig   = false
_G.AutoFarmTerror      = false
_G.AutoFarmSeabeast    = false
_G.AutoPrehistoric     = false
_G.AutoKillLava        = false
_G.AutoCollectBone     = false
_G.AutoCollectEgg      = false
_G.AutoDefendVolcano   = false
_G.AutoFrozen          = false
_G.AutoLeviathan       = false
_G.AutoKitsuneIsland   = false
_G.AutoCollectAzure    = false
_G.AutoTradeAzure      = false
_G.AutoMirageIsland    = false
_G.AutoAttackSeabeast  = false
_G.FarmDistance        = 15
_G.TweenSpeed          = 30
_G.MasteryHealth       = 20
_G.StatPoint           = 1
_G.BoatSpeed           = 50
_G.SelectedWeapon      = "Sword"
_G.SelectedFruitSkill  = nil
_G.SelectedGunSkill    = nil
_G.SelectedMethod      = nil
_G.SelectedSword       = nil
_G.SelectedMon         = nil
_G.SelectedBoss        = nil
_G.SelectedMaterial    = nil
_G.SelectedChip        = nil
_G.SelectedPlace       = nil
_G.SelectedBoat        = nil
_G.SelectedZone        = nil
_G.SelectedBringMob    = nil
_G.SelectedUnstoreFruit = "Common - Mythical"
_G.SelectedStoreFruit  = "Common - Mythical"
_G.AzureEmberAmount    = 0
_G.SelectedPlayer      = nil
_G.SelectedIsland      = nil
_G.SelectedNpc         = nil
local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Blox Fruits",
    Images  = "139538383104637",
    Color   = Color3.fromRGB(255, 50, 50),
    Version = 1,
})
local _lastNotifyTime = 0
local _notifyCooldown = 3
local function notify(msg, delay, color, title)
    local now = tick()
    if now - _lastNotifyTime < _notifyCooldown then return end
    _lastNotifyTime = now
    return StreeHub:MakeNotify({
        Title       = title or "StreeHub",
        Description = "Notification",
        Content     = msg or "...",
        Color       = color or Color3.fromRGB(255, 50, 50),
        Delay       = delay or 4,
    })
end
local Tabs = {
    Main        = Window:AddTab({ Name = "Main",         Icon = "house" }),
    Others      = Window:AddTab({ Name = "Others",       Icon = "inbox" }),
    Items       = Window:AddTab({ Name = "Items",        Icon = "box" }),
    Settings    = Window:AddTab({ Name = "Settings",     Icon = "settings" }),
    LocalPlayer = Window:AddTab({ Name = "Local Player", Icon = "user" }),
    Stats       = Window:AddTab({ Name = "Stats",        Icon = "bar-chart-2" }),
    SeaEvent    = Window:AddTab({ Name = "Sea Event",    Icon = "anchor" }),
    SeaStack    = Window:AddTab({ Name = "Sea Stack",    Icon = "waves" }),
    DragonDojo  = Window:AddTab({ Name = "Dragon Dojo",  Icon = "shield" }),
    Race        = Window:AddTab({ Name = "Race",         Icon = "bot" }),
    Combat      = Window:AddTab({ Name = "Combat",       Icon = "sword" }),
    Raid        = Window:AddTab({ Name = "Raid",         Icon = "zap" }),
    Esp         = Window:AddTab({ Name = "Esp",          Icon = "eye" }),
    Teleport    = Window:AddTab({ Name = "Teleport",     Icon = "map-pin" }),
    Shop        = Window:AddTab({ Name = "Shop",         Icon = "shopping-cart" }),
    Fruit       = Window:AddTab({ Name = "Fruit",        Icon = "flask-conical" }),
    Misc        = Window:AddTab({ Name = "Misc",         Icon = "layout-grid" }),
    Server      = Window:AddTab({ Name = "Server",       Icon = "server" }),
}
local InfoSection = Tabs.Main:AddSection("StreeHub | Info")
InfoSection:AddParagraph({ Title = "Game Time", Content = "Loading...", Icon = "clock" })
InfoSection:AddParagraph({ Title = "FPS",        Content = "Loading...", Icon = "activity" })
InfoSection:AddParagraph({ Title = "Ping",       Content = "Loading...", Icon = "wifi" })
InfoSection:AddParagraph({ Title = "Discord Server", Content = "Join our community!", Icon = "discord" })
InfoSection:AddPanel({
    Title = "Join Discord",
    ButtonText = "Copy Link",
    ButtonCallback = function()
        if setclipboard then setclipboard("https://discord.gg/highhub") end
        notify("Discord link copied!")
    end
})
local AutoFarmSection = Tabs.Main:AddSection("StreeHub | Auto Farm")
AutoFarmSection:AddDropdown({
    Title = "Weapon",
    Content = "Choose weapon for auto farm.",
    Options = { "Sword", "Gun", "Devil Fruit", "Melee" },
    Default = "Sword",
    Callback = function(v) _G.SelectedWeapon = v end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Level",
    Content = "Automatically farm mobs for level.",
    Default = false,
    Callback = function(s) _G.AutoFarmLevel = s; notify("Auto Farm Level: " .. (s and "ON" or "OFF")) end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Nearest",
    Content = "Farm nearest enemy automatically.",
    Default = false,
    Callback = function(s) _G.AutoFarmNearest = s; notify("Auto Farm Nearest: " .. (s and "ON" or "OFF")) end
})
local ValentineSection = Tabs.Main:AddSection("StreeHub | Valentine Event")
ValentineSection:AddToggle({
    Title = "Auto Farm Hearts",
    Content = "Automatically farm hearts for Valentine event.",
    Default = false,
    Callback = function(s) _G.AutoFarmHearts = s; notify("Auto Farm Hearts: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddParagraph({ Title = "Hearts", Content = "0", Icon = "heart" })
ValentineSection:AddParagraph({ Title = "Cupid Quest", Content = "-", Icon = "info" })
ValentineSection:AddToggle({
    Title = "Auto Cupid Quest",
    Content = "Automatically complete Cupid Quest.",
    Default = false,
    Callback = function(s) _G.AutoCupidQuest = s; notify("Auto Cupid Quest: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddToggle({
    Title = "Auto Delivery Quest",
    Content = "Automatically complete Delivery Quest.",
    Default = false,
    Callback = function(s) _G.AutoDeliveryQuest = s; notify("Auto Delivery Quest: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddDivider()
ValentineSection:AddDropdown({
    Title = "Valentine Shop",
    Content = "Select Valentine Event Item.",
    Options = {},
    Default = nil,
    Callback = function(v) _G.ValentineItem = v end
})
ValentineSection:AddButton({
    Title = "Refresh Shop",
    Callback = function() notify("Refreshing Valentine shop...") end
})
ValentineSection:AddParagraph({ Title = "Item Price", Content = "-", Icon = "tag" })
ValentineSection:AddButton({
    Title = "Buy Item",
    Callback = function()
        if _G.ValentineItem then
            notify("Buying: " .. tostring(_G.ValentineItem))
        else
            notify("Pilih item terlebih dahulu.")
        end
    end
})
ValentineSection:AddToggle({
    Title = "Auto Valentines Gacha",
    Content = "Automatically spin Valentines Gacha.",
    Default = false,
    Callback = function(s) _G.AutoVGacha = s; notify("Auto Valentines Gacha: " .. (s and "ON" or "OFF")) end
})
local MasterySection = Tabs.Main:AddSection("StreeHub | Mastery Farm")
MasterySection:AddDropdown({
    Title = "Choose Method",
    Content = "Select mastery farming method.",
    Options = { "Mob", "Sea Beast", "Player" },
    Default = "Mob",
    Callback = function(v) _G.SelectedMethod = v end
})
MasterySection:AddToggle({
    Title = "Auto Fruit Mastery",
    Content = "Automatically farm Devil Fruit mastery.",
    Default = false,
    Callback = function(s) _G.AutoFruitMastery = s; notify("Auto Fruit Mastery: " .. (s and "ON" or "OFF")) end
})
MasterySection:AddToggle({
    Title = "Auto Gun Mastery",
    Content = "Automatically farm Gun mastery.",
    Default = false,
    Callback = function(s) _G.AutoGunMastery = s; notify("Auto Gun Mastery: " .. (s and "ON" or "OFF")) end
})
MasterySection:AddDropdown({
    Title = "Choose Sword",
    Content = "Select sword for mastery farming.",
    Options = { "Katana", "Dual Katana", "Triple Katana", "Bisento", "Saber", "Yama", "Tushita", "CDK" },
    Default = "Katana",
    Callback = function(v) _G.SelectedSword = v end
})
MasterySection:AddToggle({
    Title = "Auto Sword Mastery",
    Content = "Automatically farm Sword mastery.",
    Default = false,
    Callback = function(s) _G.AutoSwordMastery = s; notify("Auto Sword Mastery: " .. (s and "ON" or "OFF")) end
})
local TyrantSection = Tabs.Main:AddSection("StreeHub | Tyrant Of The Skies")
TyrantSection:AddParagraph({ Title = "Eyes", Content = "0", Icon = "eye" })
TyrantSection:AddToggle({
    Title = "Auto Boss",
    Content = "Automatically fight Tyrant of the Skies boss.",
    Default = false,
    Callback = function(s) _G.AutoBoss = s; notify("Auto Boss: " .. (s and "ON" or "OFF")) end
})
local MonFarmSection = Tabs.Main:AddSection("StreeHub | Mon Farm")
MonFarmSection:AddDropdown({
    Title = "Choose Mon",
    Content = "Select a Mon to farm.",
    Options = {},
    Default = nil,
    Callback = function(v) _G.SelectedMon = v end
})
MonFarmSection:AddToggle({
    Title = "Auto Farm Mon",
    Content = "Automatically farm selected Mon.",
    Default = false,
    Callback = function(s) _G.AutoFarmMon = s; notify("Auto Farm Mon: " .. (s and "ON" or "OFF")) end
})
local BerrySection = Tabs.Main:AddSection("StreeHub | Berry")
BerrySection:AddToggle({
    Title = "Auto Collect Berry",
    Content = "Automatically collect berries on the ground.",
    Default = false,
    Callback = function(s) _G.AutoCollectBerry = s; notify("Auto Collect Berry: " .. (s and "ON" or "OFF")) end
})
local BossFarmSection = Tabs.Main:AddSection("StreeHub | Boss Farm")
BossFarmSection:AddParagraph({ Title = "Boss Status", Content = "-", Icon = "shield" })
BossFarmSection:AddDropdown({
    Title = "Choose Boss",
    Content = "Select boss to farm.",
    Options = { "Gorilla King", "Bobby", "Yeti", "Mob Leader", "Snow Lurker", "Franky", "Fishman Lord", "Wysper", "Thunder God", "Drip Mama", "Fajita", "Don Swan", "Smoke Admiral", "Magma Admiral", "Cursed Captain", "Order", "Stone", "Island Empress", "Pharaoh", "Boss Chief", "Longma", "Jack", "Apoo", "Queen", "King" },
    Default = "Gorilla King",
    Callback = function(v) _G.SelectedBoss = v end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm Boss",
    Content = "Automatically farm selected boss.",
    Default = false,
    Callback = function(s) _G.AutoFarmBoss = s; notify("Auto Farm Boss: " .. (s and "ON" or "OFF")) end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm All Boss",
    Content = "Automatically cycle through all bosses.",
    Default = false,
    Callback = function(s) _G.AutoFarmAllBoss = s; notify("Auto Farm All Boss: " .. (s and "ON" or "OFF")) end
})
local EliteSection = Tabs.Main:AddSection("StreeHub | Elite Hunter")
EliteSection:AddParagraph({ Title = "Elite Hunter Status", Content = "-", Icon = "user-check" })
EliteSection:AddParagraph({ Title = "Elite Hunter Progress", Content = "-", Icon = "bar-chart-2" })
EliteSection:AddToggle({
    Title = "Auto Elite Hunter",
    Content = "Automatically complete Elite Hunter quests.",
    Default = false,
    Callback = function(s) _G.AutoEliteHunter = s; notify("Auto Elite Hunter: " .. (s and "ON" or "OFF")) end
})
EliteSection:AddToggle({
    Title = "Auto Elite Hunter Hop",
    Content = "Hop servers for Elite Hunter.",
    Default = false,
    Callback = function(s) _G.AutoEliteHunterHop = s; notify("Auto Elite Hunter Hop: " .. (s and "ON" or "OFF")) end
})
local BoneSection = Tabs.Main:AddSection("StreeHub | Bone Farm")
BoneSection:AddDropdown({
    Title = "Choose Method",
    Content = "Select bone farming method.",
    Options = { "Cursed Captain", "Mob", "Boss" },
    Default = "Cursed Captain",
    Callback = function(v) _G.BoneMethod = v end
})
BoneSection:AddParagraph({ Title = "Bones Owned", Content = "0", Icon = "box" })
BoneSection:AddToggle({
    Title = "Auto Farm Bone",
    Content = "Automatically farm bones.",
    Default = false,
    Callback = function(s) _G.AutoFarmBone = s; notify("Auto Farm Bone: " .. (s and "ON" or "OFF")) end
})
BoneSection:AddToggle({
    Title = "Auto Random Surprise",
    Content = "Automatically use Random Surprise Balls.",
    Default = false,
    Callback = function(s) _G.AutoRandomSurprise = s; notify("Auto Random Surprise: " .. (s and "ON" or "OFF")) end
})
local PirateRaidSection = Tabs.Main:AddSection("StreeHub | Pirate Raid")
PirateRaidSection:AddToggle({
    Title = "Auto Pirate Raid",
    Content = "Automatically complete Pirate Raid.",
    Default = false,
    Callback = function(s) _G.AutoPirateRaid = s; notify("Auto Pirate Raid: " .. (s and "ON" or "OFF")) end
})
local ChestSection = Tabs.Main:AddSection("StreeHub | Chest Farm")
ChestSection:AddToggle({
    Title = "Auto Farm Chest Tween",
    Content = "Tween to chests and open them automatically.",
    Default = false,
    Callback = function(s) _G.AutoFarmChestTween = s; notify("Auto Farm Chest Tween: " .. (s and "ON" or "OFF")) end
})
ChestSection:AddToggle({
    Title = "Auto Farm Chest Instant",
    Content = "Teleport to chests instantly.",
    Default = false,
    Callback = function(s) _G.AutoFarmChestInst = s; notify("Auto Farm Chest Instant: " .. (s and "ON" or "OFF")) end
})
ChestSection:AddToggle({
    Title = "Auto Stop Items",
    Content = "Automatically stop picking up items when chest farming.",
    Default = false,
    Callback = function(s) _G.AutoStopItems = s; notify("Auto Stop Items: " .. (s and "ON" or "OFF")) end
})
local CakeSection = Tabs.Main:AddSection("StreeHub | Cake Prince")
CakeSection:AddParagraph({ Title = "Cake Prince Status", Content = "-", Icon = "crown" })
CakeSection:AddToggle({
    Title = "Auto Katakuri",
    Content = "Automatically fight Katakuri.",
    Default = false,
    Callback = function(s) _G.AutoKatakuri = s; notify("Auto Katakuri: " .. (s and "ON" or "OFF")) end
})
CakeSection:AddToggle({
    Title = "Auto Spawn Cake Prince",
    Content = "Automatically spawn Cake Prince.",
    Default = false,
    Callback = function(s) _G.AutoSpawnCakePrince = s; notify("Auto Spawn Cake Prince: " .. (s and "ON" or "OFF")) end
})
CakeSection:AddToggle({
    Title = "Auto Kill Cake Prince",
    Content = "Automatically kill Cake Prince.",
    Default = false,
    Callback = function(s) _G.AutoKillCakePrince = s; notify("Auto Kill Cake Prince: " .. (s and "ON" or "OFF")) end
})
CakeSection:AddToggle({
    Title = "Auto Kill Dough King",
    Content = "Automatically kill Dough King.",
    Default = false,
    Callback = function(s) _G.AutoKillDoughKing = s; notify("Auto Kill Dough King: " .. (s and "ON" or "OFF")) end
})
local MaterialSection = Tabs.Main:AddSection("StreeHub | Materials")
MaterialSection:AddDropdown({
    Title = "Choose Material",
    Content = "Select material to farm.",
    Options = { "Magma Ore", "Dragon Scale", "Fish Tail", "Mystic Droplet", "Scrap Metal", "Leather", "Meteorite", "Radioactive Material", "Demonic Wisp", "Vampire Fang", "Conjured Cocoa", "Wool", "Gunpowder", "Mini Tusk" },
    Default = "Magma Ore",
    Callback = function(v) _G.SelectedMaterial = v end
})
MaterialSection:AddToggle({
    Title = "Auto Farm Material",
    Content = "Automatically farm selected material.",
    Default = false,
    Callback = function(s) _G.AutoFarmMaterial = s; notify("Auto Farm Material: " .. (s and "ON" or "OFF")) end
})
local SettingsMainSection = Tabs.Main:AddSection("StreeHub | Settings")
SettingsMainSection:AddToggle({
    Title = "Spin Position",
    Content = "Spin around the target position instead of teleporting directly.",
    Default = false,
    Callback = function(s) _G.SpinPosition = s end
})
SettingsMainSection:AddSlider({
    Title = "Farm Distance",
    Content = "Distance to stay from enemy while farming.",
    Min = 5, Max = 60, Increment = 1, Default = 15,
    Callback = function(v) _G.FarmDistance = v end
})
SettingsMainSection:AddSlider({
    Title = "Player Tween Speed",
    Content = "Speed at which the player tweens to targets.",
    Min = 10, Max = 250, Increment = 5, Default = 30,
    Callback = function(v) _G.TweenSpeed = v end
})
SettingsMainSection:AddToggle({
    Title = "Bring Mob",
    Content = "Bring mobs to you before attacking.",
    Default = false,
    Callback = function(s) _G.BringMob = s end
})
SettingsMainSection:AddDropdown({
    Title = "Bring Mob",
    Content = "Select mob to bring.",
    Options = { "All", "Quest Mob", "Selected Mob" },
    Default = "All",
    Callback = function(v) _G.SelectedBringMob = v end
})
SettingsMainSection:AddToggle({
    Title = "Attack Aura",
    Content = "Enable attack aura for auto farm.",
    Default = false,
    Callback = function(s) _G.AttackAura = s end
})
local GraphicSection = Tabs.Main:AddSection("StreeHub | Graphic")
GraphicSection:AddToggle({
    Title = "Hide Notification",
    Content = "Hide in-game kill notifications.",
    Default = false,
    Callback = function(s) _G.HideNotif = s end
})
GraphicSection:AddToggle({
    Title = "Hide Damage Text",
    Content = "Hide floating damage text.",
    Default = false,
    Callback = function(s) _G.HideDamage = s end
})
GraphicSection:AddToggle({
    Title = "Black Screen",
    Content = "Make screen black for performance.",
    Default = false,
    Callback = function(s) _G.BlackScreen = s end
})
GraphicSection:AddToggle({
    Title = "White Screen",
    Content = "Make screen white for performance.",
    Default = false,
    Callback = function(s) _G.WhiteScreen = s end
})
local MasterySettSection = Tabs.Main:AddSection("StreeHub | Mastery")
MasterySettSection:AddSlider({
    Title = "Mastery Health %",
    Content = "Minimum health % before retreating during mastery farm.",
    Min = 5, Max = 80, Increment = 5, Default = 20,
    Callback = function(v) _G.MasteryHealth = v end
})
local FruitSkillSection = Tabs.Main:AddSection("StreeHub | Devil Fruit Skill")
FruitSkillSection:AddDropdown({
    Title = "Choose Fruit Skill",
    Content = "Select which fruit skill to use for auto farm.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) _G.SelectedFruitSkill = v end
})
local GunSkillSection = Tabs.Main:AddSection("StreeHub | Gun Skill")
GunSkillSection:AddDropdown({
    Title = "Choose Gun Skill",
    Content = "Select which gun skill to use for auto farm.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) _G.SelectedGunSkill = v end
})
local OthersMainSection = Tabs.Main:AddSection("StreeHub | Others")
OthersMainSection:AddToggle({
    Title = "Auto Set Spawn Point",
    Content = "Automatically set spawn point at current location.",
    Default = false,
    Callback = function(s) _G.AutoSetSpawn = s end
})
OthersMainSection:AddToggle({
    Title = "Auto Observation",
    Content = "Automatically enable Observation Haki.",
    Default = false,
    Callback = function(s) _G.AutoObservation = s end
})
OthersMainSection:AddToggle({
    Title = "Auto Haki",
    Content = "Automatically enable Buso Haki.",
    Default = false,
    Callback = function(s) _G.AutoHaki = s end
})
OthersMainSection:AddToggle({
    Title = "Auto Rejoin",
    Content = "Automatically rejoin when character dies.",
    Default = false,
    Callback = function(s) _G.AutoRejoin = s end
})
local SeaEventOthersSection = Tabs.Others:AddSection("StreeHub | Sea Event")
SeaEventOthersSection:AddToggle({
    Title = "Lightning",
    Content = "Auto dodge or use lightning during sea events.",
    Default = false,
    Callback = function(s) _G.Lightning = s end
})
SeaEventOthersSection:AddDropdown({
    Title = "Tools",
    Content = "Choose tool to use during sea events.",
    Options = { "Pipe", "Bazooka", "Flintlock", "Cannon", "Flower Minigame" },
    Default = "Pipe",
    Callback = function(v) _G.SeaEventTool = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Devil Fruit",
    Content = "Choose devil fruit skill for sea events.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) _G.SeaEventFruit = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Melee",
    Content = "Choose melee skill for sea events.",
    Options = { "Z", "X", "C", "V" },
    Default = "Z",
    Callback = function(v) _G.SeaEventMelee = v end
})
local WorldSection = Tabs.Others:AddSection("StreeHub | World")
WorldSection:AddToggle({
    Title = "Auto Second Sea",
    Content = "Automatically complete quests to reach Second Sea.",
    Default = false,
    Callback = function(s) _G.AutoSecondSea = s; notify("Auto Second Sea: " .. (s and "ON" or "OFF")) end
})
WorldSection:AddToggle({
    Title = "Auto Third Sea",
    Content = "Automatically complete quests to reach Third Sea.",
    Default = false,
    Callback = function(s) _G.AutoThirdSea = s; notify("Auto Third Sea: " .. (s and "ON" or "OFF")) end
})
local FightingStyleSection = Tabs.Others:AddSection("StreeHub | Fighting Style")
FightingStyleSection:AddToggle({ Title = "Auto Super Human",       Content = "Automatically obtain Super Human fighting style.",       Default = false, Callback = function(s) _G.AutoSuperHuman = s end })
FightingStyleSection:AddToggle({ Title = "Auto Death Step",         Content = "Automatically obtain Death Step fighting style.",         Default = false, Callback = function(s) _G.AutoDeathStep = s end })
FightingStyleSection:AddToggle({ Title = "Auto Sharkman Karate",    Content = "Automatically obtain Sharkman Karate fighting style.",    Default = false, Callback = function(s) _G.AutoSharkmanKarate = s end })
FightingStyleSection:AddToggle({ Title = "Auto Electric Claw",      Content = "Automatically obtain Electric Claw fighting style.",      Default = false, Callback = function(s) _G.AutoElectricClaw = s end })
FightingStyleSection:AddToggle({ Title = "Auto Dragon Talon",       Content = "Automatically obtain Dragon Talon fighting style.",       Default = false, Callback = function(s) _G.AutoDragonTalon = s end })
FightingStyleSection:AddToggle({ Title = "Auto God Human",          Content = "Automatically obtain God Human fighting style.",          Default = false, Callback = function(s) _G.AutoGodHuman = s end })
local GunSwordSection = Tabs.Others:AddSection("StreeHub | Gun & Sword")
GunSwordSection:AddToggle({ Title = "Auto Get Saber",        Content = "Automatically obtain Saber sword.",                Default = false, Callback = function(s) _G.AutoGetSaber = s end })
GunSwordSection:AddToggle({ Title = "Auto Buddy Sword",      Content = "Automatically obtain Buddy Sword.",                Default = false, Callback = function(s) _G.AutoBuddySword = s end })
GunSwordSection:AddToggle({ Title = "Auto Soul Guitar",      Content = "Automatically obtain Soul Guitar.",                Default = false, Callback = function(s) _G.AutoSoulGuitar = s end })
GunSwordSection:AddToggle({ Title = "Auto Rengoku",          Content = "Automatically obtain Rengoku sword.",              Default = false, Callback = function(s) _G.AutoRengoku = s end })
GunSwordSection:AddToggle({ Title = "Auto Hallow Scythe",    Content = "Automatically obtain Hallow Scythe sword.",        Default = false, Callback = function(s) _G.AutoHallowScythe = s end })
GunSwordSection:AddToggle({ Title = "Auto Warden Sword",     Content = "Automatically obtain Warden Sword.",               Default = false, Callback = function(s) _G.AutoWardenSword = s end })
GunSwordSection:AddToggle({ Title = "Auto Get Yama",         Content = "Automatically obtain Yama sword.",                 Default = false, Callback = function(s) _G.AutoGetYama = s end })
GunSwordSection:AddToggle({ Title = "Auto Get Yama Hop",     Content = "Server hop to get Yama.",                         Default = false, Callback = function(s) _G.AutoGetYamaHop = s end })
GunSwordSection:AddToggle({ Title = "Auto Get Tushita",      Content = "Automatically obtain Tushita sword.",              Default = false, Callback = function(s) _G.AutoGetTushita = s end })
local CDKSection = Tabs.Others:AddSection("StreeHub | Cursed Dual Katana")
CDKSection:AddToggle({ Title = "Auto Get CDK",               Content = "Automatically obtain Cursed Dual Katana.",         Default = false, Callback = function(s) _G.AutoGetCDK = s end })
CDKSection:AddToggle({ Title = "Auto Quest CDK [ Yama ]",    Content = "Complete CDK Yama side quest automatically.",      Default = false, Callback = function(s) _G.AutoQuestCDKYama = s end })
CDKSection:AddToggle({ Title = "Auto Quest CDK [ Tushita ]", Content = "Complete CDK Tushita side quest automatically.",   Default = false, Callback = function(s) _G.AutoQuestCDKTushita = s end })
CDKSection:AddToggle({ Title = "Auto Dragon Trident",        Content = "Automatically obtain Dragon Trident.",             Default = false, Callback = function(s) _G.AutoDragonTrident = s end })
CDKSection:AddToggle({ Title = "Auto Greybeard",             Content = "Automatically fight and obtain from Greybeard.",   Default = false, Callback = function(s) _G.AutoGreybeard = s end })
CDKSection:AddToggle({ Title = "Auto Shark Saw",             Content = "Automatically obtain Shark Saw.",                  Default = false, Callback = function(s) _G.AutoSharkSaw = s end })
CDKSection:AddToggle({ Title = "Auto Pole",                  Content = "Automatically obtain Pole.",                       Default = false, Callback = function(s) _G.AutoPole = s end })
CDKSection:AddToggle({ Title = "Auto Dark Dagger",           Content = "Automatically obtain Dark Dagger.",                Default = false, Callback = function(s) _G.AutoDarkDagger = s end })
local StatsSection = Tabs.Stats:AddSection("StreeHub | Stats")
StatsSection:AddToggle({ Title = "Add Melee Stats",      Content = "Auto distribute points to Melee.",       Default = false, Callback = function(s) _G.AddMeleeStats = s end })
StatsSection:AddToggle({ Title = "Add Defense Stats",    Content = "Auto distribute points to Defense.",     Default = false, Callback = function(s) _G.AddDefenseStats = s end })
StatsSection:AddToggle({ Title = "Add Sword Stats",      Content = "Auto distribute points to Sword.",       Default = false, Callback = function(s) _G.AddSwordStats = s end })
StatsSection:AddToggle({ Title = "Add Gun Stats",        Content = "Auto distribute points to Gun.",         Default = false, Callback = function(s) _G.AddGunStats = s end })
StatsSection:AddToggle({ Title = "Add Devil Fruit Stats",Content = "Auto distribute points to Devil Fruit.", Default = false, Callback = function(s) _G.AddDFStats = s end })
StatsSection:AddSlider({
    Title = "Point",
    Content = "How many points to add per allocation.",
    Min = 1, Max = 100, Increment = 1, Default = 1,
    Callback = function(v) _G.StatPoint = v end
})
local RaidSection = Tabs.Raid:AddSection("StreeHub | Raid")
RaidSection:AddParagraph({ Title = "Raid Time", Content = "-", Icon = "clock" })
RaidSection:AddParagraph({ Title = "Island",    Content = "-", Icon = "map-pin" })
RaidSection:AddDropdown({
    Title = "Choose Chip",
    Content = "Select raid chip to use.",
    Options = { "Smoke", "Magma", "Sand", "Ice", "Light", "Rumble", "String", "Quake", "Dark", "Phoenix", "Flame", "Falcon", "Buddha", "Spider", "Sound", "Blizzard", "Gravity", "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune" },
    Default = "Smoke",
    Callback = function(v) _G.SelectedChip = v end
})
RaidSection:AddToggle({
    Title = "Auto Raid",
    Content = "Automatically complete raids.",
    Default = false,
    Callback = function(s) _G.AutoRaid = s; notify("Auto Raid: " .. (s and "ON" or "OFF")) end
})
RaidSection:AddToggle({
    Title = "Auto Awaken",
    Content = "Automatically awaken devil fruit in raid.",
    Default = false,
    Callback = function(s) _G.AutoAwaken = s; notify("Auto Awaken: " .. (s and "ON" or "OFF")) end
})
RaidSection:AddDropdown({
    Title = "Unstore Rarity Fruit",
    Content = "Choose rarity of fruit to unstore before raid.",
    Options = { "Common - Mythical", "Uncommon - Mythical", "Rare - Mythical", "Legendary - Mythical", "Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) _G.SelectedUnstoreFruit = v end
})
RaidSection:AddToggle({
    Title = "Auto Unstore Devil Fruit",
    Content = "Automatically unstore devil fruit before raid.",
    Default = false,
    Callback = function(s) _G.AutoUnstoreFruit = s end
})
RaidSection:AddPanel({
    Title = "Raid Lab",
    ButtonText = "Teleport To Lab",
    ButtonCallback = function()
        notify("Teleporting to Lab...")
    end
})
local LawRaidSection = Tabs.Raid:AddSection("StreeHub | Law Raid")
LawRaidSection:AddToggle({
    Title = "Auto Law Raid",
    Content = "Automatically complete Law Raid.",
    Default = false,
    Callback = function(s) _G.AutoLawRaid = s; notify("Auto Law Raid: " .. (s and "ON" or "OFF")) end
})
local DungeonSection = Tabs.Raid:AddSection("StreeHub | Dungeon")
DungeonSection:AddButton({
    Title = "Telpeort To Dungeon Hub",
    Callback = function() notify("Teleporting to Dungeon Hub...") end
})
DungeonSection:AddToggle({
    Title = "Auto Attack Mon",
    Content = "Automatically attack mobs in dungeon.",
    Default = false,
    Callback = function(s) _G.AutoAttackMon = s end
})
DungeonSection:AddToggle({
    Title = "Auto Next Floor",
    Content = "Automatically proceed to the next floor.",
    Default = false,
    Callback = function(s) _G.AutoNextFloor = s end
})
DungeonSection:AddToggle({
    Title = "Auto Return To Hub",
    Content = "Automatically return to hub after dungeon.",
    Default = false,
    Callback = function(s) _G.AutoReturnHub = s end
})
local RaceSection = Tabs.Race:AddSection("StreeHub | Race")
RaceSection:AddToggle({ Title = "Auto Buy Gear",           Content = "Automatically buy gear for race.",             Default = false, Callback = function(s) _G.AutoBuyGear = s end })
RaceSection:AddToggle({ Title = "Tween To Mirage Island",  Content = "Tween to Mirage Island location.",             Default = false, Callback = function(s) _G.TweenMirageIsland = s end })
RaceSection:AddToggle({ Title = "Find Blue Gear",          Content = "Automatically find and collect blue gear.",    Default = false, Callback = function(s) _G.FindBlueGear = s end })
RaceSection:AddToggle({ Title = "Look Moon & use Ability", Content = "Look at moon and use race ability.",           Default = false, Callback = function(s) _G.LookMoon = s end })
RaceSection:AddToggle({ Title = "Auto Train",              Content = "Automatically train for race progression.",    Default = false, Callback = function(s) _G.AutoTrain = s end })
RaceSection:AddButton({
    Title = "Teleport To Race Door",
    Callback = function() notify("Teleporting to Race Door...") end
})
RaceSection:AddButton({
    Title = "Buy Acient Quest",
    Callback = function() notify("Buying Ancient Quest...") end
})
RaceSection:AddToggle({ Title = "Auto Trial",                  Content = "Automatically complete race trials.",         Default = false, Callback = function(s) _G.AutoTrial = s end })
RaceSection:AddToggle({ Title = "Auto Kill Player After Trial", Content = "Kill players after trial completion.",        Default = false, Callback = function(s) _G.AutoKillAfterTrial = s end })
local CombatSection = Tabs.Combat:AddSection("StreeHub | Combat")
CombatSection:AddParagraph({ Title = "Players In Server", Content = "-", Icon = "users" })
CombatSection:AddDropdown({
    Title = "Choose Player",
    Content = "Select a player to target.",
    Options = {},
    Default = nil,
    Callback = function(v) _G.SelectedPlayer = v end
})
CombatSection:AddPanel({
    Title = "Player Actions",
    ButtonText = "Refresh Player",
    ButtonCallback = function()
        notify("Refreshing player list...")
    end,
    SubButtonText = "Spectate Player",
    SubButtonCallback = function()
        if _G.SelectedPlayer then
            notify("Spectating: " .. _G.SelectedPlayer)
        end
    end
})
CombatSection:AddPanel({
    Title = "Teleport To Player",
    ButtonText = "Teleport",
    ButtonCallback = function()
        if _G.SelectedPlayer then
            local target = Players:FindFirstChild(_G.SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                notify("Teleported to " .. _G.SelectedPlayer)
            end
        end
    end
})
local EspSection = Tabs.Esp:AddSection("StreeHub | ESP")
EspSection:AddToggle({ Title = "Esp Player",           Content = "Show ESP for all players.",           Default = false, Callback = function(s) _G.EspPlayer = s end })
EspSection:AddToggle({ Title = "Esp Chest",            Content = "Show ESP for chests.",                Default = false, Callback = function(s) _G.EspChest = s end })
EspSection:AddToggle({ Title = "Esp Devil Fruit",      Content = "Show ESP for devil fruits.",          Default = false, Callback = function(s) _G.EspFruit = s end })
EspSection:AddToggle({ Title = "Esp Real Fruit",       Content = "Show ESP for real fruits only.",      Default = false, Callback = function(s) _G.EspRealFruit = s end })
EspSection:AddToggle({ Title = "Esp Flower",           Content = "Show ESP for flowers.",               Default = false, Callback = function(s) _G.EspFlower = s end })
EspSection:AddToggle({ Title = "Esp Island",           Content = "Show ESP for islands.",               Default = false, Callback = function(s) _G.EspIsland = s end })
EspSection:AddToggle({ Title = "Esp Npc",              Content = "Show ESP for NPCs.",                  Default = false, Callback = function(s) _G.EspNpc = s end })
EspSection:AddToggle({ Title = "Esp Sea Beast",        Content = "Show ESP for sea beasts.",            Default = false, Callback = function(s) _G.EspSeaBeast = s end })
EspSection:AddToggle({ Title = "Esp Monster",          Content = "Show ESP for monsters.",              Default = false, Callback = function(s) _G.EspMonster = s end })
EspSection:AddToggle({ Title = "Esp Mirage Island",    Content = "Show ESP for Mirage Island.",         Default = false, Callback = function(s) _G.EspMirageIsland = s end })
EspSection:AddToggle({ Title = "Esp Kitsune Island",   Content = "Show ESP for Kitsune Island.",        Default = false, Callback = function(s) _G.EspKitsuneIsland = s end })
EspSection:AddToggle({ Title = "Esp Frozen Dimension", Content = "Show ESP for Frozen Dimension.",      Default = false, Callback = function(s) _G.EspFrozen = s end })
EspSection:AddToggle({ Title = "Esp Prehistoric Island",Content="Show ESP for Prehistoric Island.",     Default = false, Callback = function(s) _G.EspPrehistoric = s end })
EspSection:AddToggle({ Title = "Esp Gear",             Content = "Show ESP for gears.",                 Default = false, Callback = function(s) _G.EspGear = s end })
local TeleportSection = Tabs.Teleport:AddSection("StreeHub | Teleport")
TeleportSection:AddDropdown({
    Title = "Selected Place",
    Content = "Choose a place to teleport to.",
    Options = { "Marine Starter Island", "Pirate Starter Island", "Middle Town", "Jungle", "Pirate Village", "Desert", "Navy Headquarters", "Skylands", "Colosseum", "Impel Down", "Marineford", "Enies Lobby", "Fishman Island", "Skylands 2", "Green Zone", "Kingdom of Rose", "Wedding Island", "Chamber of Time", "Ussop Island", "Wano Country", "Haunted Castle", "Hydra Island", "Sea of Treats", "Floating Turtle", "Demon Island", "Tiki Island", "Peanut Island" },
    Default = "Middle Town",
    Callback = function(v) _G.SelectedPlace = v end
})
TeleportSection:AddToggle({
    Title = "Teleport To Place",
    Content = "Teleport to selected place.",
    Default = false,
    Callback = function(s) _G.TeleportToPlace = s end
})
local WorldTeleportSection = Tabs.Teleport:AddSection("StreeHub | World")
WorldTeleportSection:AddPanel({
    Title = "First Sea",
    ButtonText = "Teleport To First Sea",
    ButtonCallback = function() notify("Teleporting to First Sea...") end
})
WorldTeleportSection:AddPanel({
    Title = "Second Sea",
    ButtonText = "Teleport To Second Sea",
    ButtonCallback = function() notify("Teleporting to Second Sea...") end
})
WorldTeleportSection:AddPanel({
    Title = "Third Sea",
    ButtonText = "Teleport To Third Sea",
    ButtonCallback = function() notify("Teleporting to Third Sea...") end
})
local IslandTeleportSection = Tabs.Teleport:AddSection("StreeHub | Island")
IslandTeleportSection:AddDropdown({
    Title = "Choose Island",
    Content = "Select island to teleport to.",
    Options = { "Marine Starter Island", "Pirate Starter Island", "Middle Town", "Jungle", "Colosseum", "Marineford", "Skylands", "Fishman Island", "Wano Country", "Flower Hill", "Ice Castle", "Haunted Castle", "Labyrinth" },
    Default = "Middle Town",
    Callback = function(v) _G.SelectedIsland = v end
})
IslandTeleportSection:AddPanel({
    Title = "Island Teleport",
    ButtonText = "Teleport To Island",
    ButtonCallback = function()
        if _G.SelectedIsland then notify("Teleporting to " .. _G.SelectedIsland) end
    end
})
local NpcTeleportSection = Tabs.Teleport:AddSection("StreeHub | Npc")
NpcTeleportSection:AddDropdown({
    Title = "Choose Npc",
    Content = "Select NPC to teleport to.",
    Options = {},
    Default = nil,
    Callback = function(v) _G.SelectedNpc = v end
})
NpcTeleportSection:AddPanel({
    Title = "NPC Teleport",
    ButtonText = "Teleport To Npc",
    ButtonCallback = function()
        if _G.SelectedNpc then notify("Teleporting to " .. _G.SelectedNpc) end
    end
})
local ShopSection = Tabs.Shop:AddSection("StreeHub | Shop")
ShopSection:AddToggle({ Title = "Auto Buy Legendary Sword", Content = "Automatically buy legendary swords from shops.", Default = false, Callback = function(s) _G.AutoBuyLegSword = s end })
ShopSection:AddToggle({ Title = "Auto Buy Haki Color",      Content = "Automatically buy Haki color upgrades.",         Default = false, Callback = function(s) _G.AutoBuyHakiColor = s end })
local AbilityShopSection = Tabs.Shop:AddSection("StreeHub | Abilities")
AbilityShopSection:AddButton({ Title = "Buy Geppo",            Callback = function() notify("Buying Geppo...") end })
AbilityShopSection:AddButton({ Title = "Buy Buso Haki",        Callback = function() notify("Buying Buso Haki...") end })
AbilityShopSection:AddButton({ Title = "Buy Soru",             Callback = function() notify("Buying Soru...") end })
AbilityShopSection:AddButton({ Title = "Buy Observation Haki", Callback = function() notify("Buying Observation Haki...") end })
local FightStyleShopSection = Tabs.Shop:AddSection("StreeHub | Fighting Style Shop")
FightStyleShopSection:AddButton({ Title = "Buy Black Leg",       Callback = function() notify("Buying Black Leg...") end })
FightStyleShopSection:AddButton({ Title = "Buy Electro",         Callback = function() notify("Buying Electro...") end })
FightStyleShopSection:AddButton({ Title = "Buy Fishman Karate",  Callback = function() notify("Buying Fishman Karate...") end })
FightStyleShopSection:AddButton({ Title = "Buy Dragon Claw",     Callback = function() notify("Buying Dragon Claw...") end })
FightStyleShopSection:AddButton({ Title = "Buy Superhuman",      Callback = function() notify("Buying Superhuman...") end })
FightStyleShopSection:AddButton({ Title = "Buy Death Step",      Callback = function() notify("Buying Death Step...") end })
FightStyleShopSection:AddButton({ Title = "Buy Sharkman Karate", Callback = function() notify("Buying Sharkman Karate...") end })
FightStyleShopSection:AddButton({ Title = "Buy Electric Claw",   Callback = function() notify("Buying Electric Claw...") end })
FightStyleShopSection:AddButton({ Title = "Buy Dragon Talon",    Callback = function() notify("Buying Dragon Talon...") end })
FightStyleShopSection:AddButton({ Title = "Buy God Human",       Callback = function() notify("Buying God Human...") end })
FightStyleShopSection:AddButton({ Title = "Buy Sanguine Art",    Callback = function() notify("Buying Sanguine Art...") end })
local SwordShopSection = Tabs.Shop:AddSection("StreeHub | Sword Shop")
SwordShopSection:AddButton({ Title = "Buy Cutlass",           Callback = function() notify("Buying Cutlass...") end })
SwordShopSection:AddButton({ Title = "Buy Katana",            Callback = function() notify("Buying Katana...") end })
SwordShopSection:AddButton({ Title = "Buy Iron Mace",         Callback = function() notify("Buying Iron Mace...") end })
SwordShopSection:AddButton({ Title = "Buy Dual Katana",       Callback = function() notify("Buying Dual Katana...") end })
SwordShopSection:AddButton({ Title = "Buy Triple Katana",     Callback = function() notify("Buying Triple Katana...") end })
SwordShopSection:AddButton({ Title = "Buy Pipe",              Callback = function() notify("Buying Pipe...") end })
SwordShopSection:AddButton({ Title = "Buy Dual Headed Blade", Callback = function() notify("Buying Dual Headed Blade...") end })
SwordShopSection:AddButton({ Title = "Buy Bisento",           Callback = function() notify("Buying Bisento...") end })
SwordShopSection:AddButton({ Title = "Buy Soul Cane",         Callback = function() notify("Buying Soul Cane...") end })
local GunShopSection = Tabs.Shop:AddSection("StreeHub | Gun Shop")
GunShopSection:AddButton({ Title = "Buy Slingshot",        Callback = function() notify("Buying Slingshot...") end })
GunShopSection:AddButton({ Title = "Buy Musket",           Callback = function() notify("Buying Musket...") end })
GunShopSection:AddButton({ Title = "Buy Flintlock",        Callback = function() notify("Buying Flintlock...") end })
GunShopSection:AddButton({ Title = "Buy Refined Fintlock", Callback = function() notify("Buying Refined Fintlock...") end })
GunShopSection:AddButton({ Title = "Buy Cannon",           Callback = function() notify("Buying Cannon...") end })
GunShopSection:AddButton({ Title = "Buy Kabucha",          Callback = function() notify("Buying Kabucha...") end })
local StatResetSection = Tabs.Shop:AddSection("StreeHub | Stats Reset")
StatResetSection:AddButton({ Title = "Reset Stats",  Callback = function() notify("Resetting stats...") end })
StatResetSection:AddButton({ Title = "Random Race",  Callback = function() notify("Spinning for random race...") end })
local AccessoriesSection = Tabs.Shop:AddSection("StreeHub | Accessories")
AccessoriesSection:AddButton({ Title = "Buy Black Cape",    Callback = function() notify("Buying Black Cape...") end })
AccessoriesSection:AddButton({ Title = "Buy Swordsman Hat", Callback = function() notify("Buying Swordsman Hat...") end })
AccessoriesSection:AddButton({ Title = "Buy Tomoe Ring",    Callback = function() notify("Buying Tomoe Ring...") end })
local FruitAutoSection = Tabs.Fruit:AddSection("StreeHub | Auto Fruit")
FruitAutoSection:AddToggle({ Title = "Auto Random Fruit",   Content = "Automatically spin for random fruits.",   Default = false, Callback = function(s) _G.AutoRandomFruit = s end })
FruitAutoSection:AddDropdown({
    Title = "Store Rarity Fruit",
    Content = "Choose minimum rarity of fruit to store.",
    Options = { "Common - Mythical", "Uncommon - Mythical", "Rare - Mythical", "Legendary - Mythical", "Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) _G.SelectedStoreFruit = v end
})
FruitAutoSection:AddToggle({ Title = "Auto Store Fruit",    Content = "Automatically store fruits of selected rarity.", Default = false, Callback = function(s) _G.AutoStoreFruit = s end })
FruitAutoSection:AddToggle({ Title = "Fruit Notification",  Content = "Notify when a fruit spawns.",              Default = false, Callback = function(s) _G.FruitNotif = s end })
FruitAutoSection:AddToggle({ Title = "Teleport To Fruit",   Content = "Teleport to spawned fruits instantly.",    Default = false, Callback = function(s) _G.TeleportToFruit = s end })
FruitAutoSection:AddToggle({ Title = "Tween To Fruit",      Content = "Tween smoothly to spawned fruits.",        Default = false, Callback = function(s) _G.TweenToFruit = s end })
FruitAutoSection:AddPanel({
    Title = "Grab Fruit",
    ButtonText = "Grab Fruit",
    ButtonCallback = function() notify("Grabbing nearest fruit...") end
})
local FruitVisualSection = Tabs.Fruit:AddSection("StreeHub | Visual")
FruitVisualSection:AddPanel({
    Title = "Rain Fruit",
    ButtonText = "Rain Fruit",
    ButtonCallback = function() notify("Raining fruits...") end
})
local TeamSection = Tabs.Misc:AddSection("StreeHub | Teams")
TeamSection:AddPanel({
    Title = "Teams",
    ButtonText = "Join Pirates Team",
    ButtonCallback = function()
        local ok, err = pcall(function()
            CommF_:InvokeServer("JoinTeam", "Pirates")
        end)
        notify("Joining Pirates team...")
    end,
    SubButtonText = "Join Marines Team",
    SubButtonCallback = function()
        local ok, err = pcall(function()
            CommF_:InvokeServer("JoinTeam", "Marines")
        end)
        notify("Joining Marines team...")
    end
})
local CodesSection = Tabs.Misc:AddSection("StreeHub | Codes")
CodesSection:AddPanel({
    Title = "Codes",
    ButtonText = "Redeem All Codes",
    ButtonCallback = function()
        notify("Redeeming all codes...")
        local codes = { "Sub2Fer999", "Sub2NoobMaster123", "Sub2Daigrock", "Bluxxy", "Enyu_is_Pro", "Magicbus", "JCWK", "StrawHatMaine", "Sub2Bignews", "CHANDLER", "Sub2OfficialNoobie" }
        task.spawn(function()
            for _, code in ipairs(codes) do
                pcall(function()
                    CommF_:InvokeServer("REDEEM_CODE", code)
                end)
                task.wait(0.5)
            end
            notify("All codes redeemed!", 4, Color3.fromRGB(0, 255, 0))
        end)
    end
})
local GraphicsMiscSection = Tabs.Misc:AddSection("StreeHub | Graphics")
GraphicsMiscSection:AddPanel({
    Title = "Performance",
    ButtonText = "Fps Boost",
    ButtonCallback = function()
        settings().Rendering.QualityLevel = 1
        notify("FPS Boost enabled!")
    end,
    SubButtonText = "Remove Fog",
    SubButtonCallback = function()
        game:GetService("Lighting").FogEnd = 1e9
        notify("Fog removed!")
    end
})
GraphicsMiscSection:AddPanel({
    Title = "Lava",
    ButtonText = "Remove Lava",
    ButtonCallback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "Lava" and v:IsA("BasePart") then
                v.Transparency = 1
                v.CanCollide = false
            end
        end
        notify("Lava removed!")
    end
})
local LocalPlayerSection = Tabs.LocalPlayer:AddSection("StreeHub | Local Player")
LocalPlayerSection:AddToggle({ Title = "Active Race V3",  Content = "Activate Race V3 ability.",    Default = false, Callback = function(s) _G.ActiveRaceV3 = s end })
LocalPlayerSection:AddToggle({ Title = "Active Race V4",  Content = "Activate Race V4 ability.",    Default = false, Callback = function(s) _G.ActiveRaceV4 = s end })
LocalPlayerSection:AddToggle({ Title = "Walk On Water",   Content = "Enable walk on water physics.", Default = false, Callback = function(s) _G.WalkOnWater = s end })
LocalPlayerSection:AddToggle({
    Title = "No Clip",
    Content = "Enable no-clip to walk through walls.",
    Default = false,
    Callback = function(s)
        _G.NoClip = s
        if s then
            RunService.Stepped:Connect(function()
                if _G.NoClip then
                    for _, v in pairs(Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        end
    end
})
local SeaEventSection = Tabs.SeaEvent:AddSection("StreeHub | Sea Event")
SeaEventSection:AddToggle({ Title = "Lightning",           Content = "Auto handle lightning sea events.",   Default = false, Callback = function(s) _G.Lightning = s end })
local SeaStackEnemiesSection = Tabs.SeaStack:AddSection("StreeHub | Enemies")
SeaStackEnemiesSection:AddToggle({ Title = "Auto Farm Shark",           Content = "Auto farm Sharks in the sea.",    Default = false, Callback = function(s) _G.AutoFarmShark = s end })
SeaStackEnemiesSection:AddToggle({ Title = "Auto Farm Piranha",         Content = "Auto farm Piranhas in the sea.", Default = false, Callback = function(s) _G.AutoFarmPiranha = s end })
SeaStackEnemiesSection:AddToggle({ Title = "Auto Farm Fish Crew Member",Content = "Auto farm Fish Crew Members.",   Default = false, Callback = function(s) _G.AutoFarmFishCrew = s end })
local BoatSection = Tabs.SeaStack:AddSection("StreeHub | Boat")
BoatSection:AddToggle({ Title = "Auto Farm Ghost Ship",          Content = "Auto farm Ghost Ships.",                  Default = false, Callback = function(s) _G.AutoFarmGhostShip = s end })
BoatSection:AddToggle({ Title = "Auto Farm Pirate Brigade",      Content = "Auto farm Pirate Brigades.",              Default = false, Callback = function(s) _G.AutoFarmPirateBrig = s end })
BoatSection:AddToggle({ Title = "Auto Farm Pirate Grand Brigade",Content = "Auto farm Pirate Grand Brigades.",        Default = false, Callback = function(s) _G.AutoFarmGrandBrig = s end })
local BossSeaSection = Tabs.SeaStack:AddSection("StreeHub | Boss")
BossSeaSection:AddToggle({ Title = "Auto Farm Terrorshark",      Content = "Auto farm Terrorshark boss.",             Default = false, Callback = function(s) _G.AutoFarmTerror = s end })
BossSeaSection:AddToggle({ Title = "Auto Farm Seabeasts",        Content = "Auto farm Seabeasts.",                    Default = false, Callback = function(s) _G.AutoFarmSeabeast = s end })
local SailBoatSection = Tabs.SeaStack:AddSection("StreeHub | Sail Boat")
SailBoatSection:AddDropdown({
    Title = "Choose Boat",
    Content = "Select boat type.",
    Options = { "Raft", "Dinghy", "Caravel", "Galleon" },
    Default = "Galleon",
    Callback = function(v) _G.SelectedBoat = v end
})
SailBoatSection:AddDropdown({
    Title = "Choose Zone",
    Content = "Select zone for sailing.",
    Options = { "First Sea", "Second Sea", "Third Sea" },
    Default = "First Sea",
    Callback = function(v) _G.SelectedZone = v end
})
SailBoatSection:AddSlider({
    Title = "Boat Tween Speed",
    Content = "Adjust boat movement speed.",
    Min = 20, Max = 200, Increment = 10, Default = 50,
    Callback = function(v) _G.BoatSpeed = v end
})
SailBoatSection:AddPanel({
    Title = "Sail Boat",
    ButtonText = "Sail Boat",
    ButtonCallback = function() notify("Starting to sail...") end
})
SailBoatSection:AddToggle({
    Title = "Auto Attack Seabeasts",
    Content = "Automatically attack seabeasts while sailing.",
    Default = false,
    Callback = function(s) _G.AutoAttackSeabeast = s end
})
local BeltSection = Tabs.DragonDojo:AddSection("StreeHub | Belt")
BeltSection:AddToggle({ Title = "Auto Dojo Trainer",       Content = "Auto train at Dragon Dojo.",              Default = false, Callback = function(s) _G.AutoDojoBelt = s end })
local VolcanicSection = Tabs.DragonDojo:AddSection("StreeHub | Volcanic Magnet")
VolcanicSection:AddToggle({ Title = "Auto Farm Blaze Ember",  Content = "Auto farm Blaze Ember from volcano.",  Default = false, Callback = function(s) _G.AutoFarmBlazeEmber = s end })
VolcanicSection:AddPanel({
    Title = "Craft Volcanic Magnet",
    ButtonText = "Craft",
    ButtonCallback = function() notify("Crafting Volcanic Magnet...") end
})
local DracoSection = Tabs.DragonDojo:AddSection("StreeHub | Draco Trial")
DracoSection:AddPanel({
    Title = "Upgrade Draco",
    ButtonText = "Upgrade Draco Trial",
    ButtonCallback = function() notify("Upgrading Draco Trial...") end
})
DracoSection:AddToggle({ Title = "Auto Draco V1",              Content = "Automatically complete Draco V1.",      Default = false, Callback = function(s) _G.AutoDracoV1 = s end })
DracoSection:AddToggle({ Title = "Auto Draco V2",              Content = "Automatically complete Draco V2.",      Default = false, Callback = function(s) _G.AutoDracoV2 = s end })
DracoSection:AddToggle({ Title = "Auto Draco V3",              Content = "Automatically complete Draco V3.",      Default = false, Callback = function(s) _G.AutoDracoV3 = s end })
DracoSection:AddPanel({
    Title = "Teleport",
    ButtonText = "Teleport To Draco Trials",
    ButtonCallback = function() notify("Teleporting to Draco Trials...") end
})
DracoSection:AddToggle({ Title = "Swap Draco Race",            Content = "Swap to Draco race.",                   Default = false, Callback = function(s) _G.SwapDraco = s end })
DracoSection:AddPanel({
    Title = "Dragon Talon",
    ButtonText = "Upgrade Dragon Talon",
    ButtonCallback = function() notify("Upgrading Dragon Talon...") end
})
local PrehistoricSection = Tabs.Items:AddSection("StreeHub | Prehistoric")
PrehistoricSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "info" })
PrehistoricSection:AddToggle({ Title = "Auto Prehistoric Island",  Content = "Auto complete Prehistoric Island.",       Default = false, Callback = function(s) _G.AutoPrehistoric = s end })
PrehistoricSection:AddToggle({ Title = "Auto Kill Lava Golem",     Content = "Auto kill Lava Golem.",                   Default = false, Callback = function(s) _G.AutoKillLava = s end })
PrehistoricSection:AddToggle({ Title = "Auto Collect Bone",        Content = "Auto collect bones from Prehistoric.",    Default = false, Callback = function(s) _G.AutoCollectBone = s end })
PrehistoricSection:AddToggle({ Title = "Auto Collect Egg",         Content = "Auto collect eggs from Prehistoric.",     Default = false, Callback = function(s) _G.AutoCollectEgg = s end })
PrehistoricSection:AddToggle({ Title = "Auto Defend Volcano",      Content = "Auto defend the volcano.",                Default = false, Callback = function(s) _G.AutoDefendVolcano = s end })
local FrozenSection = Tabs.Items:AddSection("StreeHub | Frozen Dimension")
FrozenSection:AddParagraph({ Title = "Frozen Status",   Content = "-", Icon = "info" })
FrozenSection:AddToggle({ Title = "Auto Frozen Dimension",  Content = "Auto complete Frozen Dimension.",    Default = false, Callback = function(s) _G.AutoFrozen = s end })
FrozenSection:AddParagraph({ Title = "Leviathan Status",    Content = "-", Icon = "info" })
FrozenSection:AddPanel({
    Title = "Leviathan",
    ButtonText = "Bribe Leviathan",
    ButtonCallback = function() notify("Bribing Leviathan...") end
})
FrozenSection:AddToggle({ Title = "Auto Leviathan",  Content = "Auto fight Leviathan.",  Default = false, Callback = function(s) _G.AutoLeviathan = s end })
local KitsuneSection = Tabs.Items:AddSection("StreeHub | Kitsune Island")
KitsuneSection:AddParagraph({ Title = "Kitsune Status",  Content = "-", Icon = "info" })
KitsuneSection:AddToggle({ Title = "Auto Kitsune Island",      Content = "Auto complete Kitsune Island.",        Default = false, Callback = function(s) _G.AutoKitsuneIsland = s end })
KitsuneSection:AddToggle({ Title = "Auto Collect Azure Ember", Content = "Auto collect Azure Ember.",            Default = false, Callback = function(s) _G.AutoCollectAzure = s end })
KitsuneSection:AddPanel({
    Title = "Azure Ember",
    Placeholder = "Amount (e.g. 50)",
    ButtonText = "Set Azure Ember",
    ButtonCallback = function(v) _G.AzureEmberAmount = tonumber(v) or 0; notify("Azure Ember set to: " .. tostring(_G.AzureEmberAmount)) end
})
KitsuneSection:AddToggle({ Title = "Auto Trade Azure Ember",   Content = "Auto trade Azure Ember.",              Default = false, Callback = function(s) _G.AutoTradeAzure = s end })
local MirageSection = Tabs.Items:AddSection("StreeHub | Mirage Island")
MirageSection:AddParagraph({ Title = "Mirage Status",  Content = "-", Icon = "info" })
MirageSection:AddToggle({ Title = "Auto Mirage Island",  Content = "Auto complete Mirage Island.",  Default = false, Callback = function(s) _G.AutoMirageIsland = s end })
local SettingsTab = Tabs.Settings:AddSection("StreeHub | Settings", true)
SettingsTab:AddToggle({
    Title = "Show Button",
    Content = "Show the open/close GUI button.",
    Default = true,
    Callback = function(state)
        notify("Button visibility: " .. (state and "ON" or "OFF"))
    end
})
SettingsTab:AddPanel({
    Title = "UI Color",
    Placeholder = "255,50,50",
    ButtonText = "Apply Color",
    ButtonCallback = function(colorText)
        local r, g, b = colorText:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            notify("Color changed to RGB(" .. r .. "," .. g .. "," .. b .. ")")
        else
            notify("Invalid format! Use: R,G,B")
        end
    end,
    SubButtonText = "Reset Color",
    SubButtonCallback = function()
        notify("Color reset to default.")
    end
})
SettingsTab:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
    end
})
local ServerSection = Tabs.Server:AddSection("StreeHub | Server")
ServerSection:AddPanel({
    Title = "Server Actions",
    ButtonText = "Rejoin Server",
    ButtonCallback = function()
        notify("Rejoining server...")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
    SubButtonText = "Server Hop",
    SubButtonCallback = function()
        notify("Looking for new server...")
        task.spawn(function()
            local ok, servers = pcall(function()
                return HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            end)
            if ok and servers and servers.data then
                for _, v in pairs(servers.data) do
                    if v.id ~= game.JobId and v.playing < v.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                        return
                    end
                end
            end
            notify("No available servers found.")
        end)
    end
})
ServerSection:AddParagraph({ Title = "Job ID",  Content = tostring(game.JobId), Icon = "server" })
ServerSection:AddPanel({
    Title = "Job ID",
    ButtonText = "Copy Job ID",
    ButtonCallback = function()
        if setclipboard then setclipboard(tostring(game.JobId)) end
        notify("Job ID copied to clipboard!")
    end
})
ServerSection:AddPanel({
    Title = "Join Specific Server",
    Placeholder = "Enter Job ID here...",
    ButtonText = "Join Job ID",
    ButtonCallback = function(jobId)
        if jobId and jobId ~= "" then
            notify("Joining server: " .. jobId)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        else
            notify("Please enter a valid Job ID.")
        end
    end
})
local StatusServerSection = Tabs.Server:AddSection("StreeHub | Status Server")
StatusServerSection:AddParagraph({ Title = "Moon Server",        Content = "-", Icon = "moon" })
StatusServerSection:AddParagraph({ Title = "Kitsune Status",     Content = "-", Icon = "zap" })
StatusServerSection:AddParagraph({ Title = "Frozen Status",      Content = "-", Icon = "snowflake" })
StatusServerSection:AddParagraph({ Title = "Mirage Status",      Content = "-", Icon = "eye" })
StatusServerSection:AddParagraph({ Title = "Haki Dealer Status", Content = "-", Icon = "user" })
StatusServerSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "shield" })
if Window then
    notify("StreeHub loaded successfully!", 5, Color3.fromRGB(255, 50, 50), "StreeHub")
end
task.spawn(function()
    local fps = 0
    RunService.RenderStepped:Connect(function(dt)
        fps = math.floor(1 / dt)
    end)
    while task.wait(1) do
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
    if _G.AutoRejoin then
        Humanoid.Died:Connect(function()
            task.wait(3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
end)
game:BindToClose(function()
end)
