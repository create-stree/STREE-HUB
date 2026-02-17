local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

local Window = StreeHub:Window({
    Title   = "APPLE HUB |",
    Footer  = "Main",
    Images  = "128806139932217",
    Color   = Color3.fromRGB(88, 101, 242),
    Theme   = 122376116281975,
    ThemeTransparency = 0.15,
    ["Tab Width"] = 120,
    Version = 1,
})

local function notify(msg, delay, color, title, desc)
    return StreeHub:MakeNotify({
        Title = title or "APPLE HUB",
        Description = desc or "Notification",
        Content = msg or "Content",
        Color = color or Color3.fromRGB(88, 101, 242),
        Delay = delay or 4
    })
end

local Tabs = {
    Main = Window:AddTab({ Name = "Main", Icon = "user" }),
    Settings = Window:AddTab({ Name = "Settings", Icon = "settings" }),
}

local MainSection = Tabs.Main:AddSection("APPLE HUB | Main")

MainSection:AddParagraph({
    Title = "Welcome to APPLE HUB",
    Content = "APPLE HUB APPLE HUB APPLE HUB",
    Icon = "star",
})

MainSection:AddDivider()

MainSection:AddPanel({
    Title = "APPLE HUB | Discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then
            setclipboard("https://discord.gg/applehub")
            notify("Discord link copied!")
        else
            notify("Clipboard not supported.")
        end
    end,
    SubButtonText = "Open Discord",
    SubButtonCallback = function()
        notify("Opening Discord...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/applehub")
        end)
    end
})

MainSection:AddButton({
    Title = "Rejoin",
    SubTitle = "Server Hop",
    Callback = function()
        notify("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
    SubCallback = function()
        notify("Finding new server...")
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Servers = Http:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(Servers.data) do
            if v.playing < v.maxPlayers then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                return
            end
        end
        notify("No available server found.")
    end
})

local SettingsSection = Tabs.Settings:AddSection("APPLE HUB | Settings", true)

SettingsSection:AddToggle({
    Title = "Show Button",
    Content = "Show APPLE HUB button on screen.",
    Default = true,
    Callback = function(state)
        local button = game:GetService("CoreGui"):FindFirstChild("AppleHubButton")
        if button then
            button.Enabled = state
            notify("Button: " .. (state and "ON" or "OFF"))
        end
    end
})

SettingsSection:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
    end
})

pcall(function()
    local oldGui = game.CoreGui:FindFirstChild("ThunderScreen")
    if oldGui then oldGui:Destroy() end
    local oldNotify = game.CoreGui:FindFirstChild("NotifySystem")
    if oldNotify then oldNotify:Destroy() end
    local oldZenHub = game.CoreGui:FindFirstChild("ZENHUB")
    if oldZenHub then oldZenHub:Destroy() end
end)

notify("APPLE HUB loaded!", 3, Color3.fromRGB(88, 101, 242), "APPLE HUB", "Welcome")
