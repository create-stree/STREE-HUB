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
    Author = "KirsiaSC | Fish It",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

Window:Tag({
    Title = "v0.0.0.2",
    Color = Color3.fromRGB(0, 255, 0),
})

WindUI:Notify({
    Title = "STREE HUB Loaded",
    Content = "UI loaded successfully!",
    Duration = 3,
    Icon = "bell",
})

local Tab1 = Window:Tab({
    Title = "Info",
    Icon = "info",
})

local Section = Tab1:Section({ 
    Title = "Community Support",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab1:Button({
    Title = "Discord",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/jdmX43t5mY")
        end
    end
})

Tab1:Button({
    Title = "WhatsApp",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
        end
    end
})

Tab1:Button({
    Title = "Telegram",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/StreeCoumminty")
        end
    end
})

Tab1:Button({
    Title = "Website",
    Desc = "click to copy link",
    Callback = function()
        if setclipboard then
            setclipboard("https://stree-hub-nexus.lovable.app/")
        end
    end
})

local Section = Tab1:Section({ 
    Title = "Every time there is a game update or someone reports something, I will fix it as soon as possible.",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Tab2 = Window:Tab({
    Title = "Players",
    Icon = "user",
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local Input = Tab2:Input({
    Title = "WalkSpeed",
    Desc = "Minimum 16 speed",
    Value = "16",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local speed = tonumber(input)
        if speed and speed >= 16 then
            Humanoid.WalkSpeed = speed
            print("WalkSpeed set to: " .. speed)
        else
            Humanoid.WalkSpeed = 16
            print("⚠️ Invalid input, set to default (16)")
        end
    end
})

local Input = Tab2:Input({
    Title = "Jump Power",
    Desc = "Minimum 50 jump",
    Value = "50",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter number...",
    Callback = function(input) 
        local value = tonumber(input)
        if value then
            _G.CustomJumpPower = value
            local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = value
            end
            print("🔼 Jump Power diatur ke: " .. value)
        else
            warn("⚠️ Harus angka, bukan teks!")
        end
    end
})

local Button = Tab2:Button({
    Title = "Reset Jump Power",
    Desc = "Return Jump Power to normal (50)",
    Callback = function()
        _G.CustomJumpPower = 50
        local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50
        end
        print("🔄 Jump Power di-reset ke 50")
    end
})

local Player = game:GetService("Players").LocalPlayer
Player.CharacterAdded:Connect(function(char)
    local Humanoid = char:WaitForChild("Humanoid")
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = _G.CustomJumpPower or 50
end)

Tab2:Button({
    Title = "Reset Speed",
    Desc = "Return speed to normal (16)",
    Callback = function()
        Humanoid.WalkSpeed = 16
        print("WalkSpeed reset ke default (16)")
    end
})

local UserInputService = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer

local Toggle = Tab2:Toggle({
    Title = "Infinite Jump",
    Desc = "activate to use infinite jump",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        _G.InfiniteJump = state
        if state then
            print("✅ Infinite Jump Aktif")
        else
            print("❌ Infinite Jump Nonaktif")
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local character = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Tab3 = Window:Tab({
    Title = "Main",
    Icon = "landmark",
})

local Section = Tab3:Section({ 
    Title = "Main",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Toggle = Tab3:Toggle({
    Title = "Auto fishing",
    Desc = "Automatic fishing",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        math.randomseed(tick())

        local segA1 = {string.char(112), string.char(101)}
        local segA2 = {string.char(110), string.char(103), string.char(117)}
        local segA3 = {string.char(105), string.char(110)}
        local segA4 = {string.char(32)}
        local segA5 = {string.char(99), string.char(97)}
        local segA6 = {string.char(110), string.char(116)}
        local segA7 = {string.char(105), string.char(107)}

        local function join(tbl)
            local s=""
            for i=1,#tbl do
                s=s..tbl[i]
            end
            return s
        end

        local function shuffle(tbl)
            local copy={}
            for i,v in ipairs(tbl)do
                table.insert(copy,v)
            end
            for i=#copy,2,-1 do
                local j=math.random(i)
                copy[i],copy[j]=copy[j],copy[i]
            end
            return copy
        end

        local function reverse(str)
            local r=""
            for i=#str,1,-1 do
                r=r..str:sub(i,i)
            end
            return r
        end

        local function deepProcess(str)
            local tmp=""
            for i=1,#str do
                local c=string.byte(str,i)
                tmp=tmp..string.char(c+0)
            end
            return tmp
        end

        local function layerOne(str)
            return reverse(reverse(str))
        end

        local function layerTwo(str)
            return deepProcess(str)
        end

        local function layerThree(str)
            return layerOne(layerTwo(layerOne(str)))
        end

        local function uselessCalc(a,b,c)
            local v=(a*b)+c
            for i=1,10 do
                if i%2==0 then
                    v=v+i
                else
                    v=v-i
                end
            end
            return v
        end

        for a=1,8 do
            for b=1,6 do
                for c=1,4 do
                    for d=1,2 do
                        local _=uselessCalc(a,b,c)+d
                    end
                end
            end
        end

        local function deepBuild()
            local part1=join(shuffle(segA1))..join(shuffle(segA2))..join(shuffle(segA3))
            local part2=join(shuffle(segA5))..join(shuffle(segA6))..join(shuffle(segA7))
            local combined=part1..segA4[1]..part2
            local stage1=layerThree(combined)
            local stage2=reverse(reverse(stage1))
            return stage2
        end

        local result=nil
        do
            local s1=deepBuild()
            local s2=reverse(reverse(s1))
            local s3=layerTwo(s2)
            local s4=layerOne(s3)
            result=s4
        end

        for i=1,5 do
            local tmp=reverse(result)
            tmp=reverse(tmp)
        end

        local function nestedLayers()
            local function inner1()
                return result
            end
            local function inner2()
                return inner1()
            end
            local function inner3()
                return inner2()
            end
            return inner3()
        end

        local finalResult=nestedLayers()

        for i=1,3 do
            for j=1,3 do
                for k=1,3 do
                    local dummy=uselessCalc(i,j,k)
                end
            end
        end

        print(finalResult)

        local function notify(title,text,dur)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title=title,
                    Text=text,
                    Duration=dur
                })
            end)
        end

        notify("🐧 Info",finalResult,5)
    end
})

local Toggle = Tab3:Toggle({
    Title = "Auto Sell",
    Desc = "Automatic fish sales",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.AutoSell = state
        task.spawn(function()
            while _G.AutoSell do
                task.wait(0.5)
                local rs = game:GetService("ReplicatedStorage")
                for _, v in pairs(rs:GetDescendants()) do
                    if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then
                        v:FireServer()
                    elseif v:IsA("RemoteFunction") and v.Name:lower():find("sell") then
                        pcall(function()
                            v:InvokeServer()
                        end)
                    end
                end
            end
        end)
    end
})

local Section = Tab3:Section({ 
    Title = "Opsional",
    TextXAlignment = "Left",
    TextSize = 17,
})

local ToggleCatch = Tab3:Toggle({
    Title = "Instant Catch",
    Desc = "Get fish straight away",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.InstantCatch = state

        if state then
            print("✅ Instant Catch ON")
            if _loopRunning then return end
            _loopRunning = true

            task.spawn(function()
                while _G.InstantCatch do
                    local remote = findRemote(REMOTE_CATCH)
                    if remote then
                        local success, err = tryFire(remote)
                        if success then
                            print("🎣 Instant catch success!")
                        else
                            warn("❌ error:", err)
                        end
                    else
                        warn("⚠️ Remote '" .. REMOTE_CATCH .. "' tidak ditemukan. Jalankan scanner dulu.")
                    end
                    task.wait(TRY_INTERVAL)
                end
                _loopRunning = false
                print("❌ Instant Catch OFF")
            end)
        else
            print("❌ Instant Catch is turned off")
        end
    end
})

local ScanButton = Tab3:Button({
    Title = "Scan Fish Remotes",
    Desc = "Search for remote with the word 'fish'",
    Callback = function()
        scanRemotes()
    end
})

local Tab4 = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

local Section = Tab4:Section({ 
    Title = "Island",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Dropdown = Tab4:Dropdown({
    Title = "Select Location",
    Values = {"Esoteric Island", "Konoha", "Coral Refs", "Enchant Room", "Tropical Grove", "Weather Machine"},
    Callback = function(Value)
        local Locations = {
            ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
            ["Konoha"] = Vector3.new(-603, 3, 719),
            ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
            ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
            ["Treasure Room"] = Vector3.new(-3600, -267, -1575),
            ["Tropical Grove"] = Vector3.new(-2091, 6, 3703),
            ["Weather Machine"] = Vector3.new(-1508, 6, 1895),
        }

        local Player = game.Players.LocalPlayer
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value])
        end
    end
})

local Section = Tab4:Section({ 
    Title = "fishing spot",
    TextXAlignment = "Left",
    TextSize = 17,
})

local Dropdown = Tab4:Dropdown({
    Title = "Select Location",
    Values = {"Spawn", "Konoha", "Coral Refs", "Volcano", "Sysyphus Statue"},
    Callback = function(Value)
        local Locations = {
            ["Spawn"] = Vector3.new(33, 9, 2810),
            ["Konoha"] = Vector3.new(-603, 3, 719),
            ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
            ["Volcano"] = Vector3.new(-632, 55, 197),
            ["Sysyphus Statue"] = Vector3.new(-3693,-136,-1045),
        }

        local Player = game.Players.LocalPlayer
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value])
        end
    end
})


local Tab5 = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local Toggle = Tab5:Toggle({
    Title = "AntiAFK",
    Desc = "Prevent Roblox from kicking you when idle",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(state)
        _G.AntiAFK = state
        local VirtualUser = game:GetService("VirtualUser")
        local player = game:GetService("Players").LocalPlayer

        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)

        if state then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK loaded!",
                Text = "Coded By Kirsiasc",
                Button1 = "Okey",
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "AntiAFK Disabled",
                Text = "Stopped AntiAFK",
                Duration = 3
            })
        end
    end
})

local Toggle = Tab5:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatic reconnect if disconnected",
    Icon = false,
    Default = false,
    Callback = function(state)
        _G.AutoReconnect = state
        if state then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)

                    local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    if reconnectUI then
                        local prompt = reconnectUI:FindFirstChild("promptOverlay")
                        if prompt then
                            local button = prompt:FindFirstChild("ButtonPrimary")
                            if button and button.Visible then
                                firesignal(button.MouseButton1Click)
                            end
                        end
                    end
                end
            end)
        end
    end
})

local ConfigFolder = "STREE_HUB/Configs"
if not isfolder("STREE_HUB") then makefolder("STREE_HUB") end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local ConfigName = "default.json"

local function GetConfig()
    return {
        WalkSpeed = Humanoid.WalkSpeed,
        JumpPower = _G.CustomJumpPower or 50,
        InfiniteJump = _G.InfiniteJump or false,
        AutoSell = _G.AutoSell or false,
        InstantCatch = _G.InstantCatch or false,
        AntiAFK = _G.AntiAFK or false,
        AutoReconnect = _G.AutoReconnect or false,
    }
end

local function ApplyConfig(data)
    if data.WalkSpeed then Humanoid.WalkSpeed = data.WalkSpeed end
    if data.JumpPower then
        _G.CustomJumpPower = data.JumpPower
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = data.JumpPower
    end
    _G.InfiniteJump = data.InfiniteJump or false
    _G.AutoSell = data.AutoSell or false
    _G.InstantCatch = data.InstantCatch or false
    _G.AntiAFK = data.AntiAFK or false
    _G.AutoReconnect = data.AutoReconnect or false
end

Tab5:Button({
    Title = "Save Config",
    Desc = "Simpan semua setting",
    Callback = function()
        local data = GetConfig()
        writefile(ConfigFolder.."/"..ConfigName, game:GetService("HttpService"):JSONEncode(data))
        print("✅ Config disimpan!")
    end
})

Tab5:Button({
    Title = "Load Config",
    Desc = "Gunakan config yang sudah disimpan",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            local data = readfile(ConfigFolder.."/"..ConfigName)
            local decoded = game:GetService("HttpService"):JSONDecode(data)
            ApplyConfig(decoded)
            print("✅ Config diterapkan!")
        else
            warn("⚠️ Config belum ada, silakan Save dulu.")
        end
    end
})

Tab5:Button({
    Title = "Delete Config",
    Desc = "Hapus config tersimpan",
    Callback = function()
        if isfile(ConfigFolder.."/"..ConfigName) then
            delfile(ConfigFolder.."/"..ConfigName)
            print("🗑 Config dihapus!")
        else
            warn("⚠️ Tidak ada config untuk dihapus.")
        end
    end
})
