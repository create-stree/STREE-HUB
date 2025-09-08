-- 🌊 STREE HUB - Teleport Blox Fruits (WindUI + Search)
-- By Kirsia

-- Load WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ WindUI gagal dimuat, cek link raw GitHub WindUI!")
    return
end

-- Buat Window
local Window = WindUI:CreateWindow({
    Title = "STREE HUB - Teleport",
    Icon = "map",
    Author = "Kirsia"
})

-- Buat Tab Teleport
local TeleportTab = Window:CreateTab({
    Title = "Teleport",
    Icon = "compass"
})

-- Fungsi Teleport
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function teleportTo(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    end
end

-- Daftar Teleport
local Teleports = {
    ["Sea 1"] = {
        ["Starter Island"] = CFrame.new(973, 16, 1412),
        ["Marine"] = CFrame.new(-2607, 72, 2095),
        ["Middle Town"] = CFrame.new(-655, 7, 1576),
        ["Jungle"] = CFrame.new(-1423, 13, 18),
        ["Pirate Village"] = CFrame.new(-1163, 45, 3845),
        ["Desert"] = CFrame.new(1095, 17, 4284),
        ["Frozen Village"] = CFrame.new(1122, 16, -1453),
        ["Colosseum"] = CFrame.new(-1668, 40, 3815),
        ["Prison"] = CFrame.new(4854, 97, 740),
        ["Magma Village"] = CFrame.new(-5231, 20, 8465),
        ["Sky Island"] = CFrame.new(-4813, 717, -2637),
    },
    ["Sea 2"] = {
        ["Dock"] = CFrame.new(-6509, 8, -132),
        ["Kingdom of Rose"] = CFrame.new(-394, 72, 1086),
        ["Green Zone"] = CFrame.new(-2370, 72, -2758),
        ["Graveyard"] = CFrame.new(-5552, 16, -708),
        ["Snow Mountain"] = CFrame.new(564, 401, -5372),
        ["Hot and Cold"] = CFrame.new(-6080, 15, -5245),
        ["Cursed Ship"] = CFrame.new(902, 125, 32873),
        ["Dark Arena"] = CFrame.new(3464, 13, -3360),
    },
    ["Sea 3"] = {
        ["Port Town"] = CFrame.new(-289, 8, 5387),
        ["Hydra Island"] = CFrame.new(5228, 603, 345),
        ["Great Tree"] = CFrame.new(2334, 28, -6768),
        ["Floating Turtle"] = CFrame.new(-12463, 376, -7561),
        ["Mansion"] = CFrame.new(-12472, 374, -7555),
        ["Haunted Castle"] = CFrame.new(-9506, 142, 6078),
        ["Sea of Treats"] = CFrame.new(-10036, 14, -8322),
    }
}

-- Wadah tombol biar gampang diatur ulang saat search
local Buttons = {}

-- Search bar
TeleportTab:CreateTextbox({
    Title = "Cari Pulau",
    Placeholder = "Contoh: Jungle, Hydra, Rose",
    Callback = function(text)
        local query = string.lower(text)

        for seaName, islands in pairs(Buttons) do
            for islandName, button in pairs(islands) do
                if query == "" or string.find(string.lower(islandName), query) then
                    button.Instance.Visible = true
                else
                    button.Instance.Visible = false
                end
            end
        end
    end
})

-- Generate tombol teleport
for seaName, islands in pairs(Teleports) do
    TeleportTab:CreateSection({
        Title = seaName
    })

    Buttons[seaName] = {}

    for islandName, cframe in pairs(islands) do
        local btn = TeleportTab:CreateButton({
            Title = islandName,
            Description = "Teleport ke " .. islandName,
            Callback = function()
                teleportTo(cframe)
            end
        })

        Buttons[seaName][islandName] = btn
    end
end


myConfig:Load()
