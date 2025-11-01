local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ WindUI loaded successfully!")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local AutoEquipBat = false
local AutoFarm = false
local AutoSell = false
local AutoSellDelay = 1
local AutoEquipBestBrainrot = false
local AutoEquipBestDelay = 1
local AutoBuyGear = false
local AutoBuyItem = false
local AutoSellItem = false
local AutoSellItemDelay = 1

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Fish It",
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

Window:Tag({
    Title = "v0.0.0.1",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Dev",
    Color = Color3.fromRGB(138, 43, 226),
    Radius = 17,
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Info = Window:Tab({ Title = "Info", Icon = "info" })
local Main = Window:Tab({ Title = "Main", Icon = "crown" })
local Shop = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

Info:Button({
    Title = "Copy Link",
    Desc = "Copy Key Link",
    Callback = function()
        setclipboard("https://streehub.vercel.app/key")
    end
})

Main:Toggle({
    Title = "Auto Equip Bat",
    Default = false,
    Callback = function(v)
        AutoEquipBat = v
        task.spawn(function()
            while AutoEquipBat do
                local bat = LocalPlayer.Backpack:FindFirstChild("Basic Bat")
                if bat then
                    bat.Parent = Character
                end
                task.wait(1)
            end
        end)
    end
})

Main:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(v)
        AutoFarm = v
        task.spawn(function()
            while AutoFarm do
                Remotes.EquipBestBrainrots:FireServer()
                task.wait(0.25)
            end
        end)
    end
})

Main:Toggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(v)
        AutoSell = v
        task.spawn(function()
            while AutoSell do
                local args = { [1] = true }
                Remotes.ItemSell:FireServer(unpack(args))
                task.wait(AutoSellDelay)
            end
        end)
    end
})

Main:Slider({
    Title = "Auto Sell Delay",
    Min = 1,
    Max = 60,
    Default = 1,
    Callback = function(v)
        AutoSellDelay = v
    end
})

Shop:Toggle({
    Title = "Auto EquipBestBrainrot",
    Default = false,
    Callback = function(v)
        AutoEquipBestBrainrot = v
        task.spawn(function()
            while AutoEquipBestBrainrot do
                Remotes.EquipBestBrainrots:FireServer()
                task.wait(AutoEquipBestDelay)
            end
        end)
    end
})

Shop:Slider({
    Title = "EquipBest Delay",
    Min = 1,
    Max = 60,
    Default = 1,
    Callback = function(v)
        AutoEquipBestDelay = v
    end
})

Shop:Toggle({
    Title = "Auto Buy Gear",
    Default = false,
    Callback = function(v)
        AutoBuyGear = v
        task.spawn(function()
            while AutoBuyGear do
                Remotes.BuyGear:FireServer()
                task.wait(1)
            end
        end)
    end
})

Shop:Toggle({
    Title = "Auto Buy Item",
    Default = false,
    Callback = function(v)
        AutoBuyItem = v
        task.spawn(function()
            while AutoBuyItem do
                Remotes.BuyItem:FireServer()
                task.wait(1)
            end
        end)
    end
})
