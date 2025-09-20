local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://123032091977400",
    Author = "KirsiaSC | Forsaken",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info"
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user"
})

local Section1 = Tab2:Section({
    Title = "Movement",
    TextXAlignment = "Left",
    TextSize = 17
})

Section1:Slider({
    Title = "WalkSpeed",
    Description = "Adjust WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

Section1:Slider({
    Title = "JumpPower",
    Description = "Adjust JumpPower",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

local Tab3 = Window:Tab({
    Title = "Visual",
    Icon = "eye"
})

local Tab4 = Window:Tab({
    Title = "World",
    Icon = "globe"
})

local Tab5 = Window:Tab({
    Title = "Setting",
    Icon = "settings"
})

local Section2 = Tab5:Section({
    Title = "System",
    TextXAlignment = "Left",
    TextSize = 17
})

Section2:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = false,
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)
                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})
