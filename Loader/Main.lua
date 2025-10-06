local StarterGui = game:GetService("StarterGui")
local scripts_key = "developer_access"
local placeId = game.PlaceId

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

local function isPremiumKey(key)
    for _, k in ipairs(premiumKeys) do
        if key == k then
            return true
        end
    end
    return false
end

local function safeLoad(url)
    local s, r = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not s then
        warn("Load failed:", r)
    end
    return s
end

local isPremium = isPremiumKey(scripts_key)
local gameData = gameScripts[placeId]

if not gameData then
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Game not supported!",
        Duration = 5
    })
    return
end

if isPremium then
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Premium key detected!",
        Duration = 3
    })
    safeLoad(gameData.premium)
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Free user detected!",
        Duration = 3
    })
    safeLoad(gameData.free)
end
