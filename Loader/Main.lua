local placeId = game.PlaceId
local StarterGui = game:GetService("StarterGui")
local gameName, success = nil, false

if placeId == 79546208627805 then
    gameName = "Game A"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-a-script/main.lua"))()
    success = true
elseif placeId == 126884695634066 then
    gameName = "Grow A Garden"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Loader/GrowAGarden.lua"))()
    success = true
elseif placeId == 2753915549 then
    gameName = "Game C"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-c-script/main.lua"))()
    success = true
elseif placeId == 121864768012064 then
    gameName = "Fish It"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua"))()
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
        Title = "STREE HUB Loaded!",
        Text = "Scripts Not Found!",
        Duration = 6,
        Icon = "rbxassetid://6023426923"
    })
end
