local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/source.lua", true))()
end)

if not success or not WindUI then
    warn("⚠️ Windows gagal dimuat!")
    return
else
    print("✓ Windows berhasil dimuat!")
end

task.wait(1)

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "monitor",
    Author = "KirsiaSC | Blox Fruit",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(500, 400),
    Theme = "Dark"
})

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Tab1:Button({
    Title = "Discord Server",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://discord.gg/jdmX43t5mY") then
            if Window.Notify then
                Window:Notify({
                    Title = "Discord",
                    Description = "Link Discord berhasil disalin!",
                    Duration = 3
                })
            else
                warn("Link Discord berhasil disalin!")
            end
        else
            if Window.Notify then
                Window:Notify({
                    Title = "Error",
                    Description = "Executor tidak support clipboard!",
                    Duration = 3
                })
            else
                warn("Executor tidak support clipboard!")
            end
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N") then
            if Window.Notify then
                Window:Notify({
                    Title = "WhatsApp",
                    Description = "Link WhatsApp berhasil disalin!",
                    Duration = 3
                })
            else
                warn("Link WhatsApp berhasil disalin!")
            end
        else
            if Window.Notify then
                Window:Notify({
                    Title = "Error",
                    Description = "Executor tidak support clipboard!",
                    Duration = 3
                })
            else
                warn("Executor tidak support clipboard!")
            end
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://t.me/StreeCoumminty") then
            if Window.Notify then
                Window:Notify({
                    Title = "Telegram",
                    Description = "Link Telegram berhasil disalin!",
                    Duration = 3
                })
            else
                warn("Link Telegram berhasil disalin!")
            end
        else
            if Window.Notify then
                Window:Notify({
                    Title = "Error",
                    Description = "Executor tidak support clipboard!",
                    Duration = 3
                })
            else
                warn("Executor tidak support clipboard!")
            end
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://stree-hub-nexus.lovable.app") then
            if Window.Notify then
                Window:Notify({
                    Title = "Website",
                    Description = "Link Website berhasil disalin!",
                    Duration = 3
                })
            else
                warn("Link Website berhasil disalin!")
            end
        else
            if Window.Notify then
                Window:Notify({
                    Title = "Error",
                    Description = "Executor tidak support clipboard!",
                    Duration = 3
                })
            else
                warn("Executor tidak support clipboard!")
            end
        end
    end
})

-- Buat tab lainnya
local Tab2 = Window:Tab({Title = "Main", Icon = "gamepad-2"})
local Tab3 = Window:Tab({Title = "Raid", Icon = "shield"})
local Tab4 = Window:Tab({Title = "Shop", Icon = "landmark"})
local Tab5 = Window:Tab({Title = "Teleport", Icon = "telescope"})
local Tab6 = Window:Tab({Title = "PVP", Icon = "swords"})
local Tab7 = Window:Tab({Title = "Visual", Icon = "eye"})
local Tab8 = Window:Tab({Title = "Settings", Icon = "settings"})
local Tab9 = Window:Tab({Title = "Misc", Icon = "list"})
