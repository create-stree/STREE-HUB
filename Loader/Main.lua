local placeId = game.PlaceId
local StarterGui = game:GetService("StarterGui")
local gameName, success = nil, false

if placeId == 2753915549 then
    gameName = "Blox Fruit"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-a-script/main.lua"))()
    success = true
elseif placeId == 79546208627805 then
    gameName = "99 Night In The Forest"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden.lua"))()
    success = true
elseif placeId == 18687417158 then
    gameName = "Forsaken"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Forsaken/Main.lua"))()
    success = true
elseif placeId == 121864768012064 then
    gameName = "Fish It"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua"))()
    success = true
elseif placeId == 123921593837160 then
    gameName = "Climb and Jump tower"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua"))()
    success = true
elseif placeId == 109983668079237 then
    gameName = "Steal A Brainrot"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-6/main.lua"))()
    success = true
elseif placeId == 3456789012 then
    gameName = "Plants Vs Brainrot"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-7/main.lua"))()
    success = true
elseif placeId == 4567890123 then
    gameName = "Game 8"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-8/main.lua"))()
    success = true
elseif placeId == 5678901234 then
    gameName = "Game 9"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-9/main.lua"))()
    success = true
elseif placeId == 6789012345 then
    gameName = "Game 10"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-10/main.lua"))()
    success = true
end

if success and gameName then
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB Loaded!",
        Text = gameName .. " script loader!",
        Duration = 6,
        Icon = "rbxassetid://6023426926"
    })
else
    StarterGui:SetCore("SendNotification", {
        Title = "STREE HUB",
        Text = (gameName or "Game") .. " Not Found!",
        Duration = 6,
        Icon = "rbxassetid://6023426923"
    })
end
