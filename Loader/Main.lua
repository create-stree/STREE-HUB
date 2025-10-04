local placeId = game.PlaceId
local StarterGui = game:GetService("StarterGui")
local gameName, success = nil, false

local scripts_key = "FREE_USER"

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

if isPremiumUser then
    StarterGui:SetCore("SendNotification", {
        Title = "PREMIUM USER DETECTED",
        Text = "Welcome back, Premium User!",
        Duration = 3,
        Icon = "rbxassetid://6023426926"
    })
else
    StarterGui:SetCore("SendNotification", {
        Title = "FREE USER",
        Text = "Limited features available",
        Duration = 3,
        Icon = "rbxassetid://6023426923"
    })
end

wait(2)

if placeId == 2753915549 then
    gameName = "Blox Fruit"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/BloxFruit-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/BloxFruit-Free.lua"))()
    end
    success = true
    
elseif placeId == 79546208627805 then
    gameName = "99 Night In The Forest"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/99Night-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden.lua"))()
    end
    success = true
    
elseif placeId == 18687417158 then
    gameName = "Forsaken"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/Forsaken-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Main.lua"))()
    end
    success = true
    
elseif placeId == 121864768012064 then
    gameName = "Fish It"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua"))()
    end
    success = true
    
elseif placeId == 123921593837160 then
    gameName = "Climb and Jump Tower"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/ClimbJump-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua"))()
    end
    success = true
    
elseif placeId == 109983668079237 then
    gameName = "Steal A Brainrot"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/Brainrot-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Brainrot-Free.lua"))()
    end
    success = true
    
elseif placeId == 3456789012 then
    gameName = "Plants Vs Brainrot"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/PlantsVsBrainrot-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/PlantsVsBrainrot-Free.lua"))()
    end
    success = true
    
elseif placeId == 4567890123 then
    gameName = "Game 8"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/Game8-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Game8-Free.lua"))()
    end
    success = true
    
elseif placeId == 5678901234 then
    gameName = "Game 9"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/Game9-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Game9-Free.lua"))()
    end
    success = true
    
elseif placeId == 6789012345 then
    gameName = "Game 10"
    if isPremiumUser then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/premium/Game10-Premium.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Game10-Free.lua"))()
    end
    success = true
    
else
    success = false
end

if success and gameName then
    local userType = isPremiumUser and "PREMIUM" or "FREE"
    local featuresText = isPremiumUser and "All features unlocked!" or "Limited features available"
    
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB " .. userType,
        Text = gameName .. " loaded! " .. featuresText,
        Duration = 6,
        Icon = isPremiumUser and "rbxassetid://6023426926" or "rbxassetid://6023426923"
    })
    
    if isPremiumUser then
        wait(1)
        StarterGui:SetCore("SendNotification", {
            Title = "THANK YOU!",
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

if not isPremiumUser then
    wait(3)
    StarterGui:SetCore("SendNotification", {
        Title = "UPGRADE TO PREMIUM",
        Text = "Get full features with Premium key!",
        Duration = 6,
        Icon = "rbxassetid://6023426923"
    })
end
