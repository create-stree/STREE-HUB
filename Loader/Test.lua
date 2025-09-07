local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ Windows gagal dimuat, cek link raw GitHub WindUI!")
    return
else
    print("✓ Windows berhasil dimuat!")
end

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

local function showNotification(title, message)
    if Window and Window.Notify then
        Window:Notify({
            Title = STREE HUB,
            Message = UI loaded,
            Time = 5
        })
    end
end

local Tab1 = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Tab1:Button({
    Title = "Discord",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
            showNotification("Discord", "Link Discord berhasil disalin!")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
            showNotification("WhatsApp", "Link WhatsApp berhasil disalin!")
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
            showNotification("Telegram", "Link Telegram berhasil disalin!")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "Klik untuk salin link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app")
            showNotification("Website", "Link Website berhasil disalin!")
        end
    end
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "gamepad-2",
})

Tab2:Label({
    Title = "Fitur Utama",
    Desc = "Pilih fitur yang ingin digunakan"
})

Tab2:Toggle({
    Title = "Auto Farm",
    Desc = "Menjalankan farm otomatis",
    Default = false,
    Callback = function(value)
        showNotification("Auto Farm", value and "Diaktifkan" or "Dinonaktifkan")
    end
})

local Tab3 = Window:Tab({
    Title = "Raid",
    Icon = "shield",
})

Tab3:Label({
    Title = "Fitur Raid",
    Desc = "Pengaturan untuk raid"
})

local Tab4 = Window:Tab({
    Title = "Shop",
    Icon = "landmark",
})

local Tab5 = Window:Tab({
    Title = "Teleport",
    Icon = "telescope",
})

local Tab6 = Window:Tab({
    Title = "PVP",
    Icon = "swords",
})

local Tab7 = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local Tab8 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

-- Tambahkan beberapa pengaturan
Tab8:Slider({
    Title = "UI Transparency",
    Desc = "Mengatur transparansi UI",
    Default = 50,
    Min = 0,
    Max = 100,
    Callback = function(value)
        if Window and Window.ChangeTransparency then
            Window:ChangeTransparency(value/100)
        end
    end
})

local Tab9 = Window:Tab({
    Title = "Misc",
    Icon = "list",
})

Tab9:Button({
    Title = "Refresh UI",
    Desc = "Muat ulang antarmuka",
    Callback = function()
        showNotification("Refresh", "UI akan dimuat ulang...")
        -- Tambahkan logika refresh di sini
    end
})

Window:SelectTab(1)
showNotification("STREE HUB", "Berhasil dimuat! Selamat menggunakan.")
