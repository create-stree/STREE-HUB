local placeId = game.PlaceId
local StarterGui = game:GetService("StarterGui")
local gameName, success = nil, false

-- 🎯 LANGSUNG SET PREMIUM
local isPremiumUser = true

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
        local loadedFunction = loadstring(scriptContent)
        if loadedFunction then
            return loadedFunction()
        else
            return false
        end
    end)
    
    if not success then
        warn("Failed to load script: " .. url)
        warn("Error: " .. tostring(result))
        return false
    end
    return true
end

-- Mapping game dengan URL premium dan free
local gameScripts = {
    [2753915549] = { -- Blox Fruit
        name = "Blox Fruit",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/BloxFruit-Free.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/main/BloxFruit-Premium.lua"
    },
    [79546208627805] = { -- 99 Night In The Forest
        name = "99 Night In The Forest", 
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden-Premium.lua"
    },
    [18687417158] = { -- Forsaken
        name = "Forsaken",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Premium.lua"
    },
    [121864768012064] = { -- Fish It
        name = "Fish It",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"
    },
    [123921593837160] = { -- Climb and Jump Tower
        name = "Climb and Jump Tower",
        free = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua",
        premium = "https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Premium.lua"
    }
}

local gameData = gameScripts[placeId]

if gameData then
    gameName = gameData.name
    local url = isPremiumUser and gameData.premium or gameData.free
    print("Loading " .. (isPremiumUser and "PREMIUM" or "FREE") .. " script for: " .. gameName)
    print("URL: " .. url)
    success = safeLoadScript(url)
else
    print("Game not supported. PlaceId: " .. placeId)
    success = false
end

-- ✅ TAMBAHKAN BAGIAN INI:
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

-- Debug info
print("=== DEBUG INFO ===")
print("PlaceId: " .. placeId)
print("Game Name: " .. (gameName or "Unknown"))
print("Premium User: " .. tostring(isPremiumUser))
print("Load Success: " .. tostring(success))
