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
    for _, k in ipairs(premiumKeys) do
        if key == k then
            return true
        end
    end
    return false
end

local userType = isPremiumKey(_G.scripts_key) and "Premium" or "Freemium"

local gameData = {
    [2753915549] = {name = "Blox Fruit", free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Main.lua", premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Premium.lua"},
    [1239215938] = {name = "Climb and Jump Tower", free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua", premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Premium.lua"},
    [121864768012064] = {name = "Fish It", free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua", premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"},
    [18687417158] = {name = "Forsaken", free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua", premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"}
}

local gameName = gameData[placeId] and gameData[placeId].name or "Unknown Game"

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

if gameData[placeId] then
    if userType == "Premium" then
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Loading Premium version for " .. gameName .. "...",
            Icon = streeLogo,
            Duration = 3
        })
        loadstring(game:HttpGet(gameData[placeId].premium))()
    else
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Loading Freemium version for " .. gameName .. "...",
            Icon = streeLogo,
            Duration = 3
        })
        loadstring(game:HttpGet(gameData[placeId].free))()
    end
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Game not supported!",
        Icon = streeLogo,
        Duration = 4
    })
end
