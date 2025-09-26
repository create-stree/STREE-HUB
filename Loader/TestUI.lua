local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://123032091977400",
    Author = "KirsiaSC | Plants Vs Zombie",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    SideBarWidth = 170,
    Background = WindUI:Gradient({
    ["0"] = { Color = Color3.fromHex("#0f0c29"), Transparency = 1 },
    ["100"] = { Color = Color3.fromHex("#302b63"), Transparency = 0.9 },
}, {
    Rotation = 45,
}),
})
