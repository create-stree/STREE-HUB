local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/source.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ Windows gagal dimuat, cek loadstringnya!")
    return
else
    print("✓ Windows berhasil dimuat!")
end

wait(1)

if not WindUI or not WindUI.CreateWindow then
    warn("⚠️ WindUI tidak memiliki fungsi CreateWindow!")
    return
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "monitor",
    Author = "KirsiaSC | Blox Fruit v0.00.01 | discord.gg/jdmX43t5mY",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Green",
    SideBarWidth = 170,
    HasOutline = true
})

if not Window then
    warn("⚠️ Gagal membuat window!")
    return
end

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif writeclipboard then
        writeclipboard(text)
        return true
    elseif toclipboard then
        toclipboard(text)
        return true
    else
        return false
    end
end

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Tab1:Button({
    Title = "Discord Server",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://discord.gg/jdmX43t5mY") then
            Window:Notify({
                Title = "Discord",
                Description = "Link Discord berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support clipboard!",
                Duration = 3
            })
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N") then
            Window:Notify({
                Title = "WhatsApp",
                Description = "Link WhatsApp berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support clipboard!",
                Duration = 3
            })
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://t.me/StreeCoumminty") then
            Window:Notify({
                Title = "Telegram",
                Description = "Link Telegram berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support clipboard!",
                Duration = 3
            })
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Klik untuk salin link",
    Callback = function()
        if copyToClipboard("https://stree-hub-nexus.lovable.app") then
            Window:Notify({
                Title = "Website",
                Description = "Link Website berhasil disalin!",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Executor tidak support clipboard!",
                Duration = 3
            })
        end
    end
})

local Tab2 = Window:Tab({Title = "Main", Icon = "gamepad-2"})
local Tab3 = Window:Tab({Title = "Raid", Icon = "shield"})
local Tab4 = Window:Tab({Title = "Shop", Icon = "landmark"})
local Tab5 = Window:Tab({Title = "Teleport", Icon = "telescope"})
local Tab6 = Window:Tab({Title = "PVP", Icon = "swords"})
local Tab7 = Window:Tab({Title = "Visual", Icon = "eye"})
local Tab8 = Window:Tab({Title = "Settings", Icon = "settings"})
local Tab9 = Window:Tab({Title = "Misc", Icon = "list"})

print("✓ STREE HUB berhasil dimuat!")
