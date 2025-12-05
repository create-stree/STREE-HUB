print("=== DEBUG UI LIBRARY ===")

-- Coba load library
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/UI.Libry/Window.lua"))()
end)

if success then
    print("✓ Library berhasil di-load")
    if result then
        StreeHub = result
        print("✓ StreeHub dari return value:", type(StreeHub))
    elseif getgenv().StreeHub then
        StreeHub = getgenv().StreeHub
        print("✓ StreeHub dari getgenv():", type(StreeHub))
    else
        warn("✗ StreeHub tidak ditemukan!")
        return
    end
else
    warn("✗ Gagal load library:", result)
    return
end

-- Cek apakah CreateWindow ada
if type(StreeHub.CreateWindow) ~= "function" then
    warn("✗ CreateWindow bukan fungsi!")
    print("Fungsi yang tersedia di StreeHub:")
    for k, v in pairs(StreeHub) do
        print("  " .. k .. ": " .. type(v))
    end
    return
end

print("✓ CreateWindow ditemukan sebagai fungsi")

-- Create window
local Window = StreeHub:CreateWindow({
    Title = "Stree Hub",
    SubTitle = "Premium Cheat Menu",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Theme = "Dark",
    Acrylic = true
})

-- Add tabs
local MainTab = Window:AddTab("Main")
local VisualsTab = Window:AddTab("Visuals")
local MiscTab = Window:AddTab("Misc")

-- Add sections
local CombatSection = MainTab:AddSection("Combat")
local MovementSection = MainTab:AddSection("Movement")

-- Add elements
CombatSection:AddToggle({
    Title = "Aimbot",
    Description = "Auto aim at enemies",
    Default = false,
    Callback = function(value)
        print("Aimbot:", value)
        -- Your aimbot code here
    end
})

CombatSection:AddSlider({
    Title = "Aimbot FOV",
    Description = "Field of view for aimbot",
    Default = 50,
    Min = 1,
    Max = 360,
    Rounding = 0,
    Callback = function(value)
        print("FOV set to:", value)
    end
})

MovementSection:AddToggle({
    Title = "Speed Hack",
    Description = "Increase movement speed",
    Default = false,
    Callback = function(value)
        print("Speed Hack:", value)
        -- Speed hack code
    end
})

-- Add button to open image window
MiscTab:AddSection("Utilities"):AddButton({
    Title = "Open Image Viewer",
    Description = "View custom image",
    Callback = function()
        StreeHub:OpenImageWindow({
            ImageId = "113067683358494",
            Title = "Stree Hub - Logo",
            Size = UDim2.fromOffset(500, 400),
            Position = UDim2.new(0.5, -250, 0.5, -200)
        })
    end
})

-- Add dropdown
MiscTab:AddSection("Settings"):AddDropdown({
    Title = "Theme Selector",
    Description = "Choose UI theme",
    Values = {"Dark", "Light", "Darker", "Rose", "Aqua", "Amethyst"},
    Default = "Dark",
    Callback = function(value)
        StreeHub:SetTheme(value)
    end
})

-- Notifications example
task.spawn(function()
    task.wait(2)
    StreeHub:Notify({
        Title = "Stree Hub",
        Content = "Welcome to the menu!",
        SubContent = "Enjoy your experience",
        Duration = 5
    })
end)
