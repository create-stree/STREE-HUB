local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local placeId = game.PlaceId

_G.scripts_key = _G.scripts_key or scripts_key or "FREE_USER"
local streeLogo = "rbxassetid://128806139932217"

local premiumKeys = {
    "hRCWybDuIIxXeREImBbvjsEueohPzTfX",
    "kRpXaVnqZyLhTjBfGmWcSdEoUiNpQvJ",
    "YtHqFzPaKrXeBwNuDjMiVsGoClLrSnQe",
    "pZxYvQmAaTrWnGfBqCkJdEoHsLuVtSiN",
    "wJzDnQyGmTcLkVxEoPaFbSgRrUuMiZh",
    "eBtXqNpRzVhLkCmSgJaWiFuTdOyQnPc",
    "qYwRzEbTgLkPmDaVxHnUiFsCoSjMvNQ",
    "ZkWmNtGpQrHxSaJlDyCfVuEbLoPiTnR",
    "vQbJnGzHcTtXoLwFfAqSmPrYiEdKuNM",
    "hZpRkQyUxWaJmTfVnSgCoLdEiBtNsMQ", -- 10
    "hKQZrXvTnMFaJpLwSgDBeEYcUoNiRA",
    "QmYBvDZoTnCwLrHFaXkUJEpSgNiVMQ",
    "XoZKQnYJpLrEHTwSgDMBaFiCvUqRNP",
    "nFvTQwXgYHKEoLaSBDZCUMJpRNiVTF",
    "ZxJvXHnYkSgBLCMTFUpQoDaERwViNP",
    "rTnMZQXvJHLFSCYwBKaUpgDoENiVPM",
    "vBFSHkJXnLZCwQpDgMTUYoaERViNPQ",
    "QpHnZLBkTgXvFMCwSYDoUaJERiVNQP",
    "XQYpJkLCMZBvDgSwnHToFUERNiVPMQ",
    "JXoZkYpLHQwMBnDgCvTFSUERiVNPQM", -- 20
    "MTZLwXHnYkQgJpDCSBFoUvERiNPMQX",
    "ZgYJQXkHnBvTFUoMCSwDLpERiNPMQV",
    "wJXHnZkYFQpDvSLCMToUBgERiNPMQV",
    "XwYkJZHQnMBCgTFDvUSpLoERiNPMQV",
    "QZJXkHMYnLwBTDpCgUSFoERiNPMQVX",
    "HXkZBvJMYQwDnTLpUCSFgERiNPMQVX",
    "JkQHnXMYDvZLBFoCgSwUTpERiNPMQV",
    "YJXQkZHDvMBSgTFLnUwCoERiNPMQVX",
    "XkHnQZJMYpLwTDgCBUSFoERiNPMQVX",
    "QXJZkHnYwMBgDvSCUTLpFERiNPMQVX", -- 30
    "RfbTkLmNqPsAdFhGjKzXcVwQyUtIoPaSd",
    "AzXcVbNmLpOiUyTrEwQqAsDfGhJkLmNbV",
    "QwErTyUiOpAsDfGhJkLzXcVbNmLpOiUyT",
    "MnBvCxZlKjHgFdSaQwErTyUiOpLkJhGfD",
    "VwQyUtIoPaSdFgHjKlMnBvCxZqWeRtYuI",
    "GhJkLmNbVcXzQwErTyUiOpAsDfGhJkLmN",
    "XcVbNmLpOiUyTrEwQqAsDfGhJkLmNbVcX",
    "SdFgHjKlMnBvCxZqWeRtYuIoPaSdFgHjK",
    "LkJhGfDsAqWeRtYuIoPaSdFgHjKlMnBvC",
    "PaSdFgHjKlMnBvCxZqWeRtYuIoPaSdFgH", -- 40
    "xQmZbTnLcVrWpKyJdHsUfGaEiLoPnYtR",
    "BnVcXzQpLmYtRwQkJhGfDsAzXbNmLpOt",
    "YkLmNbVcXzAsDfGhJkLpOiUyTrEwQmNy",
    "tRqWpLnMxKvBsGfHeJzDuQiYcPaLmNkQ",
    "JmQnLpRtYxKvBsGhEfZaWiCuTdOyQnLu",
    "kVxYoPaSdFgHjKlMnBvCxZqWeRtYuIoT",
    "pLnMxKvBsGhEfZaWiCuTdOyQnLkVxYon",
    "XcVbNmLpQrTyUiOpAsDfGhJkLmNbVcXs",
    "sDfGhJkLmNbVcXpLnMxKvBsGhEfZaWig",
    "HeJzDuQiYcPaLmNkVxYoPaSdFgHjKlMp", -- 50
    "developer_access",
    "team_access",
}

local function isPremiumKey(key)
    for _, k in ipairs(premiumKeys) do
        if key == k then
            return true
        end
    end
    return false
end

local userType = isPremiumKey(_G.scripts_key) and "Premium" or "Freemium"

local gameScripts = {
    [127794225497302] = {
        name = "Abyss",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Abyss/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Abyss/Premium.lua"
    },
    [124311897657957] = {
        name = "Break A Lucky Block",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/BALB/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/BALB/Premium.lua"
    },
    [2753915549] = {
        name = "Blox Fruit",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Premium.lua"
    },
    [123921593837160] = {
        name = "Climb and Jump Tower",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Premium.lua"
    },
    [131623223084840] = {
        name = "Escape Tsunami For Brainrot",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/ETFB/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/ETFB/Premium.lua"
    },
    [121864768012064] = {
        name = "Fish It",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"
    },
    [18687417158] = {
        name = "Forsaken",
        free = "https://pandadevelopment.net/virtual/file/510939b1302a5a9c",
        premium = "https://pandadevelopment.net/virtual/file/0ab33cd15eae6790"
    },
    [130594398886540] = {
        name = "Garden Horizons",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Garden-Horizons/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Garden-Horizons/Premium.lua"
    },
    [136599248168660] = {
        name = "Solo Hunter",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Solo-Hunter/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Solo-Hunter/Premium.lua"
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
local gameName = gameData and gameData.name or "Unknown Game"

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

if gameData then
    if userType == "Premium" then
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Loading Premium version for " .. gameName .. "...",
            Icon = streeLogo,
            Duration = 3
        })
        loadstring(game:HttpGet(gameData.premium))()
    else
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Loading Freemium version for " .. gameName .. "...",
            Icon = streeLogo,
            Duration = 3
        })
        loadstring(game:HttpGet(gameData.free))()
    end
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Game not supported!",
        Icon = streeLogo,
        Duration = 4
    })
end
