-- Load WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI gagal dimuat!")
    return
end

-- Buat Window
local Window = WindUI:CreateWindow("Climb & Jump Tower Hub")

-- Tab Gameplay
local Tab = Window:CreateTab("Gameplay")

-- Infinite Jump
_G.InfiniteJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

Tab:CreateToggle("Infinite Jump", false, function(v)
    _G.InfiniteJump = v
end)

-- Speed Hack
_G.SpeedHack = false
local speed = 50
Tab:CreateToggle("Speed Hack", false, function(v)
    _G.SpeedHack = v
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = v and speed or 16
    end
end)

-- NoClip
_G.NoClip = false
game:GetService("RunService").Stepped:Connect(function()
    if _G.NoClip then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

Tab:CreateToggle("NoClip", false, function(v)
    _G.NoClip = v
end)

-- Teleport ke atas
Tab:CreateButton("Teleport to Top", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 200, 0) -- ubah angka Y biar langsung ke atas tower
    end
end)
