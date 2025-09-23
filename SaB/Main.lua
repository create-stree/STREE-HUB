local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://123032091977400",
    Author = "KirsiaSC | Steal A Brainrot ",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({  
    Title = "v0.0.0.1",  
    Color = Color3.fromRGB(0, 255, 0),  
})

WindUI:Notify({  
    Title = "STREE HUB Loaded",  
    Content = "UI loaded successfully!",  
    Duration = 3,  
    Icon = "bell",  
})
