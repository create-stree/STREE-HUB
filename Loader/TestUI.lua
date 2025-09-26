local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then return end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://7734068321",
    Size = UDim2.new(0, 600, 0, 360),
    Theme = "Dark"
})

for _, obj in ipairs(Window.Frame:GetDescendants()) do
    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
        obj.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
        obj.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end

local TabInfo = Window:CreateTab({
    Title = "Information",
    Icon = "rbxassetid://6034684946"
})

TabInfo:Label("🌐 STREE HUB v0.0.1")
TabInfo:Button({
    Title = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/xxxx")
    end
})

local TabMain = Window:CreateTab({
    Title = "Main",
    Icon = "rbxassetid://6034509993"
})

TabMain:Toggle({
    Title = "Auto Farm",
    Desc = "Collect otomatis",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
        task.spawn(function()
            while _G.AutoFarm do
                task.wait(1)
                print("🌱 Auto Farming aktif")
            end
        end)
    end
})
