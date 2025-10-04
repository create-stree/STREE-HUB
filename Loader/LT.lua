local placeId = game.PlaceId
local StarterGui = game:GetService("StarterGui")
local gameName, success = nil, false

local scripts_key = "FREE_USER"  -- Tetap FREE_USER

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

function validateKey(key)
    for _, validKey in ipairs(premiumKeys) do
        if key == validKey then
            return true
        end
    end
    return false
end

local isPremiumUser = validateKey(scripts_key)

-- 🎯 FORCE PREMIUM UNTUK TESTING
isPremiumUser = true

if isPremiumUser then
    StarterGui:SetCore("SendNotification", {
        Title = "🎉 PREMIUM USER DETECTED",
        Text = "Welcome back, Premium User!",
        Duration = 3,
        Icon = "rbxassetid://6023426926"
    })
else
    StarterGui:SetCore("SendNotification", {
        Title = "🔓 FREE USER",
        Text = "Limited features available",
        Duration = 3,
        Icon = "rbxassetid://6023426923"
    })
end

wait(2)

function safeLoadScript(url)
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url)
        return loadstring(scriptContent)()
    end)
    
    if not success then
        warn("Failed to load script: " .. url)
        warn("Error: " .. tostring(result))
        return false
    end
    return true
end

-- Mapping game
local gameScripts = {
    [2753915549] = {
        name = "Blox Fruit",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/BloxFruit-Free.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/BloxFruit-Free.lua"
    },
    [79546208627805] = {
        name = "99 Night In The Forest", 
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden.lua"
    },
    [18687417158] = {
        name = "Forsaken",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Main.lua"
    },
    [121864768012064] = {
        name = "Fish It",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"
    },
    [123921593837160] = {
        name = "Climb and Jump Tower",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua"
    }
}

local gameData = gameScripts[placeId]

if gameData then
    gameName = gameData.name
    local url = isPremiumUser and gameData.premium or gameData.free
    success = safeLoadScript(url)
else
    success = false
end

if success and gameName then
    local userType = isPremiumUser and "PREMIUM" or "FREE"
    local featuresText = isPremiumUser and "All features unlocked!" : "Limited features available"
    
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB" .. userType,
        Text = gameName .. " loaded! " .. featuresText,
        Duration = 6,
        Icon = isPremiumUser and "rbxassetid://6023426926" or "rbxassetid://6023426923"
    })
    
    if isPremiumUser then
        wait(1)
        StarterGui:SetCore("SendNotification", {
            Title = "💖 THANK YOU!",
            Text = "Thanks for purchasing Premium!",
            Duration = 4,
            Icon = "rbxassetid://6023426926"
        })
    end
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = (gameName or "Game") .. " Not Supported!",
        Duration = 6,
        Icon = "rbxassetid://6023426923"
    })
end
