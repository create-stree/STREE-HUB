local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "STREE HUB",
   Icon = earth, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "STREE LOADING",
   LoadingSubtitle = "Made In : Kirsia",
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = STREE, -- Create a custom folder for your hub/game
      FileName = "STREE HUB"
   },

Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/MFzWcQNA", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "STREE HUB",
      Subtitle = "STREE Key System",
      Note = "Enter key to login", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Free Key","Free login"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local UniversalTab = Window:CreateTab("Universal script", "globe-lock")
local Section = UniversalTab:CreateSection("cheating")

local Button = UniversalTab:CreateButton({
   Name = "Farm Bond",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/qE3kiwX4/raw"))()
   end,
})

UniversalTab:CreateButton({
   Name = "Auto Win",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/sBQRgxba/raw"))()
   end,
})

UniversalTab:CreateButton({
   Name = "WalkSpeed",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/QvT5KWcH/raw"))()
   end,
})

UniversalTab:CreateButton({
   Name = "Jump Power",
   Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/mWz3tpuy/raw"))()
   end,
})

local GameTab = Window:CreateTab("Game", "gamepad-2")
local Section = GameTab:CreateSection("Beberapa script Terkenal")

local Button GameTab:CreateButton({
    Name = "Thand Hub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/thiennrb7/Script/main/autobond'))()
    end,
})

GameTab:CreateButton({
    Name = "Null Fire",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/JonasThePogi/DeadRails/main/newloadstring'))()
    end,
})

Rayfield:Notify({
   Title = "STREE LOADING",
   Content = "Semua script Berhasil Dimuat",
   Duration = 3,
   Image = "Check",
})

-- Load Config
Rayfield:LoadConfiguration()
