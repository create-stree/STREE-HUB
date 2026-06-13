repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character
if not game:IsLoaded() then game.Loaded:Wait() end

local gameId = game.GameId
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local ok, val = pcall(function() return scripts_key end)
_G.scripts_key = _G.scripts_key or (ok and val) or "FREE_USER"

local key = _G.scripts_key
local hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
local streeLogo = "rbxassetid://99948086845842"

local success, response = pcall(function()
    return game:HttpGet(
        "https://streehub-api.vercel.app/api/premium?key=" .. key .. "&hwid=" .. hwid,
        true
    )
end)

if not success or not response or response:find("Invalid") or response:find("error") or response:find("Missing") or response:find("expired") or response:find("banned") then
    game.Players.LocalPlayer:Kick("[StreeHub] Invalid Key: " .. tostring(response or "Unknown error"))
    return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 160)
Frame.Position = UDim2.new(0.5, -160, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 0)
UIStroke.Parent = Frame

local Image = Instance.new("ImageLabel")
Image.Image = streeLogo
Image.BackgroundTransparency = 1
Image.Size = UDim2.new(0, 80, 0, 80)
Image.Position = UDim2.new(0.5, -40, 0, 15)
Image.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Text = "STREE HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 105)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Parent = Frame

local Loading = Instance.new("Frame")
Loading.Size = UDim2.new(0, 260, 0, 6)
Loading.Position = UDim2.new(0.5, -130, 1, -20)
Loading.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Loading.BorderSizePixel = 0
Loading.Parent = Frame

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Bar.BorderSizePixel = 0
Bar.Parent = Loading

local UICornerLoading = Instance.new("UICorner")
UICornerLoading.CornerRadius = UDim.new(0, 3)
UICornerLoading.Parent = Loading

local UICornerBar = Instance.new("UICorner")
UICornerBar.CornerRadius = UDim.new(0, 3)
UICornerBar.Parent = Bar

local tween = TweenService:Create(Bar, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()
tween.Completed:Wait()
task.wait(0.3)
ScreenGui:Destroy()

local gameScripts = {
    [7326934954] = {
        name = "99 Night In The Forest",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/99NITF/Premium.lua"
    },
    [8144728961] = {
        name = "Abyss",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Abyss/Premium.lua"
    },
    [111958650] = {
        name = "Arsenal",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Arsenal/Premium.lua"
    },
    [994732206] = {
        name = "Blox Fruits",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Blox-Fruit/Dev.lua"
    },
    [10039338037] = {
        name = "Build Ring Farm",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Build-Ring-Farm/Premium.lua"
    },
    [9344307274] = {
        name = "Break A Lucky Block",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/BALB/Premium.lua"
    },
    [7474367816] = {
        name = "Climb and Jump Tower",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Premium.lua"
    },
    [9363735110] = {
        name = "Escape Tsunami For Brainrot",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/ETFB/Premium.lua"
    },
    [6701277882] = {
        name = "Fish It",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"
    },
    [6331902150] = {
        name = "Forsaken",
        premium = "https://pandadevelopment.net/virtual/file/0ab33cd15eae6790"
    },
    [9509842868] = {
        name = "Garden Horizons",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Garden-Horizons/Premium.lua"
    },
    [10004244222] = {
        name = "Kick A Lucky Block",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/KALB/Premium.lua"
    },
    [7395930870] = {
        name = "Sell Lemon",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Sell-Lemon/Premium.lua"
    },
    [9792947201] = {
        name = "Slime RNG",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Slime-Rng/Premium.lua"
    },
    [7394964165] = {
        name = "Solo Hunter",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Solo-Hunter/Premium.lua"
    },
    [9098570654] = {
        name = "Survive The Apocalypse",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/STA/Premium.lua"
    },
    [6739698191] = {
        name = "Violence District",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Violence-District/Premium.lua"
    }
}

local gameData = gameScripts[gameId]
local gameName = gameData and gameData.name or "Unknown Game"

StarterGui:SetCore("SendNotification", {
    Title = "STREE HUB",
    Text = "Detected: " .. gameName,
    Icon = streeLogo,
    Duration = 3
})

StarterGui:SetCore("SendNotification", {
    Title = "STREE HUB",
    Text = "Premium User Verified",
    Icon = streeLogo,
    Duration = 3
})

task.wait(2)

if gameData then
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Loading " .. gameName .. "...",
        Icon = streeLogo,
        Duration = 3
    })
    loadstring(game:HttpGet(gameData.premium, true))()
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Game not supported!",
        Icon = streeLogo,
        Duration = 4
    })
    game.Players.LocalPlayer:Kick("[StreeHub] Game not supported!")
end
