local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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
})

local Window = WindUI:CreateWindow({
    Title = "Jawa Hub",
    Icon = "house",
    Author = "Jawa",
    Folder = "Jawa",
    Size = UDim2.fromOffset(560, 400),
    Theme = "JawaTheme",
})
