-- Contoh penggunaan WindUI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/WindUI/main/source.lua"))()

local Window = Library:Window("My Hub", "WindUI Example", Enum.KeyCode.RightControl)

local Tab = Window:Tab("Main")

Tab:Button("Click Me", function()
    print("Button clicked!")
end)

Tab:Toggle("Enable Feature", false, function(value)
    print("Feature: ", value)
end)

Tab:Slider("WalkSpeed", 16, 100, 16, function(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)
