local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/source.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ Windows gagal dimuat, cek link GitHub WindUI!")
    return
else
    print("✓ Windows berhasil dimuat!")
end

wait(1)

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "monitor",
    Author = "KirsiaSC | Blox Fruit v0.00.01 | discord.gg/jdmX43t5mY",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

if not Window then
    warn("❌ Gagal membuat window!")
    return
end

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Tab1:Button({
    Title = "Discord Server",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
            Window:Notify({
                Title = "Discord",
                Description = "Link Discord berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support setclipboard!",
                Duration = 3
            })
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
            Window:Notify({
                Title = "WhatsApp",
                Description = "Link WhatsApp berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support setclipboard!",
                Duration = 3
            })
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
            Window:Notify({
                Title = "Telegram",
                Description = "Link Telegram berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support setclipboard!",
                Duration = 3
            })
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app")
            Window:Notify({
                Title = "Website",
                Description = "Link Website berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support setclipboard!",
                Duration = 3
            })
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

print("✓ STREE HUB berhasil dimuat!")
