local StarterGui = game:GetService("StarterGui")
local scripts_key = "FREE_USER" 
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


local function getUserType(key)
    for _, k in ipairs(premiumKeys) do
        if key == k then
            return "Premium"
        end
    end
    if key == "FREE_USER" then
        return "Free"
    end
    return false
end


local function safeLoadScript(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script: "..url)
        warn(result)
    end
    return success
end


local userType = getUserType(scripts_key)

if not userType then
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Key invalid! Access denied.",
        Duration = 5
    })
    return
end


StarterGui:SetCore("SendNotification", {
    Title = "STREE HUB",
    Text = userType.." key detected! Loading script...",
    Duration = 4
})


local gameData = gameScripts[placeId]
if gameData then
    local url = (userType=="Premium") and gameData.premium or gameData.free
    local loaded = safeLoadScript(url)
    if loaded then
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = gameData.name.." loaded successfully ("..userType..")",
            Duration = 4
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "STREE HUB",
            Text = "Failed to load "..gameData.name.." script.",
            Duration = 4
        })
    end
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = "Game not supported!",
        Duration = 4
    })
end
