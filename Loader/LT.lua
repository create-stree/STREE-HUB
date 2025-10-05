local placeId = game.PlaceId
local StarterGui = game:GetService("StarterGui")
local gameName, success = nil, false

-- 🎯 GUNAKAN KEY YANG VALID UNTUK PREMIUM
local scripts_key = "developer_access"  -- <- GANTI JADI KEY PREMIUM

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
    "developer_access"  -- KEY INI VALID
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

-- 🎯 PERBAIKI URL UNTUK SETIAP GAME
if placeId == 2753915549 then
    gameName = "Blox Fruit"
    if isPremiumUser then
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/BloxFruit-Premium.lua")
    else
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/BloxFruit-Free.lua")
    end
    
elseif placeId == 79546208627805 then
    gameName = "99 Night In The Forest"
    if isPremiumUser then
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden-Premium.lua")
    else
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden.lua")
    end
    
elseif placeId == 18687417158 then
    gameName = "Forsaken"
    if isPremiumUser then
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Premium.lua")
    else
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Main.lua")
    end
    
elseif placeId == 121864768012064 then
    gameName = "Fish It"
    if isPremiumUser then
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua")
    else
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua")
    end
    
elseif placeId == 123921593837160 then
    gameName = "Climb and Jump Tower"
    if isPremiumUser then
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Premium.lua")
    else
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua")
    end
    
elseif placeId == 109983668079237 then
    gameName = "Steal A Brainrot"
    if isPremiumUser then
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/StealABrainrot-Premium.lua")
    else
        success = safeLoadScript("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/StealABrainrot-Free.lua")
    end
    
else
    success = false
end

if success and gameName then
    local userType = isPremiumUser and "PREMIUM" or "FREE"
    local featuresText = isPremiumUser and "All features unlocked!" or "Limited features available"
    
    StarterGui:SetCore("SendNotification", {
        Title = "🎯 STREE HUB " .. userType,
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
        Title = "❌ STREE HUB",
        Text = (gameName or "Game") .. " Not Supported!",
        Duration = 6,
        Icon = "rbxassetid://6023426923"
    })
end

if not isPremiumUser then
    wait(3)
    StarterGui:SetCore("SendNotification", {
        Title = "💎 UPGRADE TO PREMIUM",
        Text = "Get full features with Premium key!",
        Duration = 5,
        Icon = "rbxassetid://6023426923"
    })
end
