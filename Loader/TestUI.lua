local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "monitor",
    Author = "KirsiaSC | Blox Fruit",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    WindUI:AddTheme({
               Name="ChunkHub",
               Accent="#ffffff",
               Dialog="#ffffff",
               Outline="#5787d2",
               Text="#090909",
               Placeholder="#999999",
               Background="#ffffff",
               Button="#090909",
               Icon="#090909",
               }),
    SideBarWidth = 170,
    HasOutline = true
})
