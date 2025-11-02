--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Kavo UI Theme Changer with Rainbow Support (made by thebiggestpro01, on GitHub!


-- Implement this to your script! Instructions:
-- 1. Copy all the local functions including the rainbowCycle function, which makes the rainbow cycle work (do NOT put the delayed function on the top, it is supposed to be on the VERRYYYYY bottom of the script to make sure the UI loads succesfully) , and paste them all on the top of your script, right after you create the window.

-- 2. The only themes supported are those on the "local themes" function, each table uses the premade theme's from the library RGB scheme, (SchemeColor, Background, Header, TextColor etc), to add one that you want, copy another theme table and add your own RGB stuff, make sure to add the extra } on your new theme, and remove the extra } on other theme tables that are NOT the last table on the function list, and then add your theme button, with the applyTheme("theme name") argument in your script. 


-- 3. Make sure the ThemesSection and Tab for the themes are the LAST ones made, to isolate any errors the buttons might cause, making the rest of the script function right, but making so the Themes stuff won't load in any case of error, like a infinite unexpected loop.

-- 4. If you don't want a function to save or load a saved theme from the written files, do this:
-- Remove "themeSaveFile"
-- Remove the saveTheme function
-- Remove the saveTheme argument from every theme button
-- And other arguments and functions, like loadSavedTheme()
-- ULTRA RECOMMENDED: REMOVE THE FUNCTION WITH A 0.01 DELAY FULLY, OR ELSE IT MIGHT HALT THE WHOLE SCRIPT OR MIGHT CRASH THE LIBRARY

-- Now here's a example you can use


local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/thebiggestpro01/Nexusoritation/refs/heads/main/KNOLib2"))()
local Window = Library.CreateLib("Kavo UI - Theme Changer", "DarkTheme")
local Tab = Window:NewTab("Themes")
local ThemesSection = Tab:NewSection("Choose a theme")
local themeSaveFile = "SavedTheme.txt"

local themes = {
    Private = {
        SchemeColor = Color3.fromRGB(255, 215, 0),
        Background = Color3.fromRGB(31, 41, 43),
        Header = Color3.fromRGB(22, 29, 31),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(22, 29, 31)
    },
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255, 255, 255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    BloodTheme = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    GrapeTheme = {
        SchemeColor = Color3.fromRGB(166, 71, 214),
        Background = Color3.fromRGB(64, 50, 71),
        Header = Color3.fromRGB(36, 28, 41),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(74, 58, 84)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background = Color3.fromRGB(26, 32, 58),
        Header = Color3.fromRGB(38, 45, 71),
        TextColor = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71)
    },
    Sentinel = {
        SchemeColor = Color3.fromRGB(230, 35, 69),
        Background = Color3.fromRGB(32, 32, 32),
        Header = Color3.fromRGB(24, 24, 24),
        TextColor = Color3.fromRGB(119, 209, 138),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Synapse = {
        SchemeColor = Color3.fromRGB(46, 48, 43),
        Background = Color3.fromRGB(13, 15, 12),
        Header = Color3.fromRGB(36, 38, 35),
        TextColor = Color3.fromRGB(152, 99, 53),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Serpent = {
        SchemeColor = Color3.fromRGB(0, 166, 58),
        Background = Color3.fromRGB(31, 41, 43),
        Header = Color3.fromRGB(22, 29, 31),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(22, 29, 31)
    },
    Midnight = {
        SchemeColor = Color3.fromRGB(26, 189, 158),
        Background = Color3.fromRGB(44, 62, 82),
        Header = Color3.fromRGB(57, 81, 105),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(52, 74, 95)
    },
    Rainbow = {
        SchemeColor = Color3.fromHSV(0, 1, 1),
        Background = Color3.fromRGB(31, 41, 43),
        Header = Color3.fromRGB(22, 29, 31),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(22, 29, 31)
    }
}

local function applyTheme(theme)
    if themes[theme] then
        for prop, val in pairs(themes[theme]) do
            Library:ChangeColor(prop, val)
        end
    end
end

local function saveTheme(themeName)
    if writefile then
        writefile(themeSaveFile, themeName)
    elseif pcall(function() setclipboard(themeName) end) then end
end

local function loadSavedTheme()
    if isfile and isfile(themeSaveFile) then
        local savedTheme = readfile(themeSaveFile)
        if themes[savedTheme] then
            return savedTheme
        end
    end
    return "Private"
end

local rainbowRunning = false
local rainbowSpeed = 1
local currentHue = 0
local rainbowConnection

local function startRainbow()
    rainbowRunning = true
    rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if rainbowRunning then
            currentHue = (currentHue + rainbowSpeed / 360) % 1
            local rainbowColor = Color3.fromHSV(currentHue, 1, 1)
            Library:ChangeColor("SchemeColor", rainbowColor)
        end
    end)
end

local function stopRainbow()
    rainbowRunning = false
    if rainbowConnection then
        rainbowConnection:Disconnect()
        rainbowConnection = nil
    end
end

ThemesSection:NewLabel("Credits to thebiggestpro01 on GitHub")
ThemesSection:NewButton("Golden", "Apply Golden Theme", function()
stopRainbow()
    applyTheme("Private")
    saveTheme("Private")
end)

ThemesSection:NewButton("DarkTheme", "Apply Dark Theme", function()
stopRainbow()
    applyTheme("DarkTheme")
    saveTheme("DarkTheme")
end)

ThemesSection:NewButton("LightTheme", "Apply Light Theme", function()
stopRainbow()
    applyTheme("LightTheme")
    saveTheme("LightTheme")
end)

ThemesSection:NewButton("BloodTheme", "Apply Blood Theme", function()
stopRainbow()
    applyTheme("BloodTheme")
    saveTheme("BloodTheme")
end)

ThemesSection:NewButton("GrapeTheme", "Apply Grape Theme", function()
stopRainbow()
    applyTheme("GrapeTheme")
    saveTheme("BloodTheme")
end)

ThemesSection:NewButton("Ocean", "Apply Ocean Theme", function()
stopRainbow()
    applyTheme("Ocean")
    saveTheme("Ocean")
end)

ThemesSection:NewButton("Sentinel", "Apply Sentinel Theme", function()
stopRainbow()
    applyTheme("Sentinel")
    saveTheme("Sentinel")
end)

ThemesSection:NewButton("Synapse", "Apply Synapse Theme", function()
stopRainbow()
    applyTheme("Synapse")
    saveTheme("Synapse")
end)

ThemesSection:NewButton("Serpent", "Apply Serpent Theme", function()
    stopRainbow()
    applyTheme("Serpent")
    saveTheme("Serpent")
end)
ThemesSection:NewButton("Midnight", "Apply Midnight Theme", function()
    stopRainbow()
    applyTheme("Midnight")
    saveTheme("Midnight")
end)
-- Rainbow Theme Button
ThemesSection:NewButton("Rainbow", "Start Rainbow Theme", function()
    stopRainbow()
    applyTheme("Rainbow")
    saveTheme("Rainbow")
    startRainbow()
end)

-- Rainbow Speed TextBox
ThemesSection:NewTextBox("Rainbow Speed (e.g. 1)", "Sets how fast the rainbow cycles", function(input)
    input = input:gsub(",", ".")
    local num = tonumber(input)
    if num and num > 0 and num <= 100 then
        rainbowSpeed = num
    else
        print("Invalid rainbow speed. Must be a number between 0 and 100.")
    end
end)

-- Auto-load saved theme
delay(0.01, function()
    local savedTheme = loadSavedTheme()
    stopRainbow()
    applyTheme(savedTheme)
    print("Loaded saved theme:" .. savedTheme)
    if savedTheme == "Rainbow" then
        startRainbow()
    end
end)-- Line Separator
Window:Line()

-- Another Tab Example
local Extra = Window:Tab({Title = "Extra", Icon = "tag"}) do
    Extra:Section({Title = "About"})
    Extra:Button({
        Title = "Show Message",
        Desc = "Display a popup",
        Callback = function()
            Window:Notify({
                Title = "Fluent UI",
                Desc = "Everything works fine!",
                Time = 3
            })
        end
    })
end
Window:Line()
local Extra = Window:Tab({Title = "Settings", Icon = "wrench"}) do
    Extra:Section({Title = "Config"})
    Extra:Button({
        Title = "Show Message",
        Desc = "Display a popup",
        Callback = function()
            Window:Notify({
                Title = "Fluent UI",
                Desc = "Everything works fine!",
                Time = 3
            })
        end
    })
end
-- Final Notification
Window:Notify({
    Title = "x2zu",
    Desc = "All components loaded successfully! Credits leak: @x2zu",
    Time = 4
})
