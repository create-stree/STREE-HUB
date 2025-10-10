local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local placeId = game.PlaceId

_G.scripts_key = _G.scripts_key or scripts_key or "FREE_USER"
local streeLogo = "rbxassetid://122683047852451"

local premiumKeys = {
    "hRCWybDuIIxXeREImBbvjsEueohPzTfX",
    "kRpXaVnqZyLhTjBfGmWcSdEoUiNpQvJ",
    "YtHqFzPaKrXeBwNuDjMiVsGoClLrSnQe",
    "pZxYvQmAaTrWnGfBqCkJdEoHsLuVtSiN",
    "wJzDnQyGmTcLkVxEoPaFbSgRrUuMiZh",
    "eBtXqNpRzVhLkCmSgJaWiFuTdOyQnPc",
    "qYwRzEbTgLkPmDaVxHnUiFsCoSjMvN",
    "ZkWmNtGpQrHxSaJlDyCfVuEbLoPiTn",
    "vQbJnGzHcTtXoLwFfAqSmPrYiEdKuN",
    "hZpRkQyUxWaJmTfVnSgCoLdEiBtNsM",
    "rYpXvQzNaHkBtMfLcWgJoSdEuPiVnT",
    "developer_access"
}

local function isPremiumKey(key)
    if type(key) ~= "string" then return false end
    for _, k in ipairs(premiumKeys) do
        if key == k then return true end
    end
    return false
end

local userType = isPremiumKey(_G.scripts_key) and "Premium" or "Freemium"

local gameScripts = {
    [2753915549] = {
        name = "Blox Fruit",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Premium.lua"
    },
    [1239215938] = {
        name = "Climb and Jump Tower",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Premium.lua"
    },
    [121864768012064] = {
        name = "Fish It",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"
    },
    [18687417158] = {
        name = "Forsaken",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"
    }
}

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

local tween = TweenService:Create(Bar, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()
tween.Completed:Wait()
task.wait(0.3)
ScreenGui:Destroy()

local gameData = gameScripts[placeId]
local gameName = (gameData and gameData.name) or "Unknown Game"

StarterGui:SetCore("SendNotification", {
    Title = "STREE HUB",
    Text = "Detected game: " .. gameName,
    Icon = streeLogo,
    Duration = 3
})

StarterGui:SetCore("SendNotification", {
    Title = "STREE HUB",
    Text = "User Type: " .. userType,
    Icon = streeLogo,
    Duration = 3
})

task.wait(2)

local function tryHttpGet(url)
    local ok, body
    ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 10 then return true, body end
    ok, body = pcall(function() return (game.HttpGetAsync and game:HttpGetAsync(url)) end)
    if ok and type(body) == "string" and #body > 10 then return true, body end
    if syn and syn.request then
        ok, body = pcall(function() local r = syn.request({Url = url, Method = "GET"}) return r and r.Body end)
        if ok and type(body) == "string" and #body > 10 then return true, body end
    end
    if http and http.request then
        ok, body = pcall(function() local r = http.request({Url = url, Method = "GET"}) return r and r.Body end)
        if ok and type(body) == "string" and #body > 10 then return true, body end
    end
    if request then
        ok, body = pcall(function() local r = request({Url = url, Method = "GET"}) return r and r.Body end)
        if ok and type(body) == "string" and #body > 10 then return true, body end
    end
    return false, nil
end

local function safeLoadLink(link)
    local ok, body = tryHttpGet(link)
    if not ok or type(body) ~= "string" then
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Failed to fetch script",
            Icon = streeLogo,
            Duration = 4
        })
        return false
    end
    local fn, err = loadstring(body)
    if type(fn) ~= "function" then
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Failed to compile script",
            Icon = streeLogo,
            Duration = 4
        })
        return false
    end
    local ok2, res = pcall(fn)
    if not ok2 then
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Script runtime error",
            Icon = streeLogo,
            Duration = 4
        })
        return false
    end
    return true
end

if gameData then
    local link = (isPremiumKey(_G.scripts_key) and gameData.premium) or gameData.free
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = (isPremiumKey(_G.scripts_key) and "Loading Premium version for " or "Loading Freemium version for ") .. gameName .. "...",
        Icon = streeLogo,
        Duration = 3
    })
    local ok = safeLoadLink(link)
    if not ok and isPremiumKey(_G.scripts_key) then
        local fallback = gameData.free
        safeLoadLink(fallback)
    end
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Game not supported!",
        Icon = streeLogo,
        Duration = 4
    })
end
