-- Multi-game loader
local placeId = game.PlaceId

if placeId == 79546208627805 then
    -- Game A
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-a-script/main.lua"))()
elseif placeId == 126884695634066 then
    -- Game B
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-b-script/main.lua"))()
elseif placeId == 2753915549 then
    -- Game C
    loadstring(game:HttpGet("https://raw.githubusercontent.com/username/game-c-script/main.lua"))()
else
    warn("Game not supported!")
end
