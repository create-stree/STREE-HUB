local StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local TeleportService= game:GetService("TeleportService")
local HttpService    = game:GetService("HttpService")
local Workspace      = game:GetService("Workspace")
local Lighting       = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer    = Players.LocalPlayer

local function GetChar() return LocalPlayer.Character end
local function GetHRP()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChild("Humanoid")
end

if not game:IsLoaded() then game.Loaded:Wait() end

local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local VirtualUser = game:GetService("VirtualUser")

local placeId = game.PlaceId
local worldMap = { [2753915549]=true, [4442272183]=true, [7449423635]=true }
local World1, World2, World3 = false, false, false
if placeId == 2753915549 then World1 = true
elseif placeId == 4442272183 then World2 = true
elseif placeId == 7449423635 then World3 = true
end

local EffectContainer = ReplicatedStorage:FindFirstChild("Effect") and ReplicatedStorage.Effect:FindFirstChild("Container")
if EffectContainer then
    local Death = EffectContainer:FindFirstChild("Death")
    if Death then
        local ok, result = pcall(require, Death)
        if ok and type(result) == "function" then pcall(function() hookfunction(result, function() end) end) end
    end
    local Respawn = EffectContainer:FindFirstChild("Respawn")
    if Respawn then
        local ok, result = pcall(require, Respawn)
        if ok and type(result) == "function" then pcall(function() hookfunction(result, function() end) end) end
    end
end

local GuideModule = ReplicatedStorage:FindFirstChild("GuideModule")
if GuideModule then
    local ok, module = pcall(require, GuideModule)
    if ok and module and type(module.ChangeDisplayedNPC) == "function" then
        pcall(function() hookfunction(module.ChangeDisplayedNPC, function() end) end)
    end
end

local Util = ReplicatedStorage:FindFirstChild("Util")
if Util then
    local CameraShaker = Util:FindFirstChild("CameraShaker")
    if CameraShaker then pcall(function() require(CameraShaker):Stop() end) end
end

local _lastNotifyTime = 0

local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Blox Fruits",
    Images  = "139538383104637",
    Color   = Color3.fromRGB(255, 50, 50),
    Version = 1,
})

local function notify(msg, delay, color, title)
    local now = tick()
    if now - _lastNotifyTime < 3 then return end
    _lastNotifyTime = now
    StreeHub:MakeNotify({
        Title       = title or "StreeHub",
        Description = "Notification",
        Content     = msg or "...",
        Color       = color or Color3.fromRGB(255, 50, 50),
        Delay       = delay or 4,
    })
end

local function SafeTween(hrp, target, speed)
    if not hrp then return end
    speed = speed or Settings and Settings.TweenSpeed or 350
    local dist = (hrp.Position - target).Magnitude
    local t = dist / speed
    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(0.05, t), Enum.EasingStyle.Linear), {CFrame = CFrame.new(target)})
    tw:Play()
    tw.Completed:Wait()
end

local function UseSkill(key)
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    end)
end

local tween
local TweenSpeed = 350

local function requestEntrance(pos)
    pcall(function()
        CommF_:InvokeServer("requestEntrance", pos)
        local hrp = GetHRP()
        if hrp then
            hrp.CFrame = CFrame.new(hrp.CFrame.X, hrp.CFrame.Y + 50, hrp.CFrame.Z)
        end
        task.wait(0.5)
    end)
end

local tableLocationsWorld1 = {
    ["Sky Island 1"]             = Vector3.new(-4652, 873, -1754),
    ["Sky Island 2"]             = Vector3.new(-7895, 5547, -380),
    ["Under Water Island"]       = Vector3.new(61164, 5, 1820),
    ["Under Water Island Entrace"]= Vector3.new(3865, 5, -1926),
}
local tableLocationsWorld2 = {
    ["Flamingo Mansion"] = Vector3.new(-317, 331, 597),
    ["Flamingo Room"]    = Vector3.new(2283, 15, 867),
    ["Cursed Ship"]      = Vector3.new(923, 125, 32853),
    ["Zombie Island"]    = Vector3.new(-6509, 83, -133),
}
local tableLocationsWorld3 = {
    ["Mansion"]             = Vector3.new(-12471, 374, -7551),
    ["Hydra"]               = Vector3.new(5659, 1013, -341),
    ["Castle On The Sea"]   = Vector3.new(-5092, 315, -3130),
    ["Floating Turtle"]     = Vector3.new(-12001, 332, -8861),
    ["Beautiful Pirate"]    = Vector3.new(5319, 23, -93),
    ["Temple Of Time"]      = Vector3.new(28286, 14897, 103),
}

local function CheckNearestTeleporter(targetPos)
    local hrp = GetHRP()
    if not hrp then return nil end
    local tbl = World1 and tableLocationsWorld1 or World2 and tableLocationsWorld2 or tableLocationsWorld3
    local chosen, minDist = nil, math.huge
    for _, v in pairs(tbl) do
        local d = (v - targetPos.Position).Magnitude
        if d < minDist then minDist = d; chosen = v end
    end
    if chosen and (chosen - hrp.Position).Magnitude < (targetPos.Position - hrp.Position).Magnitude then
        return chosen
    end
    return nil
end

local function topos(Tween_Pos)
    pcall(function()
        local hrp = GetHRP()
        local hum = GetHum()
        if not hrp or not hum or hum.Health <= 0 then return end
        local speed = TweenSpeed or 350
        local targetPos = Tween_Pos.Position
        local dist = (targetPos - hrp.Position).Magnitude
        if dist < 2 then return end -- sudah di sana

        -- Cek apakah perlu masuk teleporter (pulau terpisah)
        local nearest = CheckNearestTeleporter(Tween_Pos)
        if nearest then
            pcall(function() if tween then tween:Cancel() end end)
            requestEntrance(nearest)
        end

        -- Selalu tween, tidak pernah instant
        local t = math.max(0.1, dist / speed)
        local targetCF = Tween_Pos

        -- Koreksi Y agar tidak nyangkut di tanah
        local DefualtY = Tween_Pos.Y
        local b1 = CFrame.new(hrp.CFrame.X, DefualtY, hrp.CFrame.Z)
        if (b1.Position - CFrame.new(Tween_Pos.X, DefualtY, Tween_Pos.Z).Position).Magnitude > 5 then
            targetCF = CFrame.new(Tween_Pos.X, DefualtY, Tween_Pos.Z)
        end

        tween = TweenService:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = targetCF})
        tween:Play()
        tween.Completed:Wait()
    end)
end

local function TeleportTo(pos)
    topos(CFrame.new(pos + Vector3.new(0, 5, 0)))
end

local function fastpos(Pos)
    pcall(function()
        local hrp = GetHRP()
        if not hrp then return end
        local dist = (Pos.Position - hrp.Position).Magnitude
        local tw = TweenService:Create(hrp, TweenInfo.new(dist / 1000, Enum.EasingStyle.Linear), {CFrame = Pos})
        tw:Play()
    end)
end

local function BTPZ(cf)
    local hrp = GetHRP()
    if hrp then hrp.CFrame = cf end
end

local function BTP(p)
    local hrp = GetHRP()
    local hum = GetHum()
    if not hrp or not hum then return end
    local pg = LocalPlayer.PlayerGui:FindFirstChild("Main")
    local lastPos = hrp.Position
    repeat
        hum.Health = 0
        hrp.CFrame = p
        if pg then pcall(function() pg.Quest.Visible = false end) end
        if (hrp.Position - lastPos).Magnitude > 1 then
            lastPos = hrp.Position
            hrp.CFrame = p
        end
        task.wait(0.5)
    until (p.Position - hrp.Position).Magnitude <= 2000
end

local _lastTPBTime = 0
local function TPB(pos, boat)
    local now = tick()
    if now - _lastTPBTime < 0.5 then return {Stop = function() end} end
    local dist = (boat.CFrame.Position - pos.Position).Magnitude
    local speed = getgenv().SpeedBoat or (Settings and Settings.BoatSpeed) or 50
    if dist <= 25 then return {Stop = function() end} end
    local tw = TweenService:Create(boat, TweenInfo.new(dist / speed, Enum.EasingStyle.Linear), {CFrame = pos})
    tw:Play()
    _lastTPBTime = now
    return {Stop = function() tw:Cancel() end}
end

local function StopTween()
    pcall(function()
        if tween then tween:Cancel(); tween = nil end
        local hrp = GetHRP()
        if hrp then
            hrp.Anchored = true
            task.wait(0.1)
            hrp.CFrame = hrp.CFrame
            hrp.Anchored = false
            local bc = hrp:FindFirstChild("BodyClip")
            if bc then bc:Destroy() end
        end
    end)
end

local lastHakiTime = 0
local function AutoHakiCheck()
    local char = GetChar()
    if not char or char:FindFirstChild("HasBuso") then return end
    local now = tick()
    if now - lastHakiTime >= 1 then
        pcall(function() CommF_:InvokeServer("Buso") end)
        lastHakiTime = now
    end
end

local lastUnEquipTime = 0
local function UnEquipWeapon(weapon)
    local now = tick()
    if now - lastUnEquipTime < 0.5 then return end
    local char = GetChar()
    if char and char:FindFirstChild(weapon) then
        pcall(function()
            char[weapon].Parent = LocalPlayer.Backpack
        end)
    end
    lastUnEquipTime = now
end

local lastEquipTime2 = 0
local function EquipWeapon(toolName)
    local now = tick()
    if now - lastEquipTime2 < 0.5 then return end
    local hum = GetHum()
    local tool = LocalPlayer.Backpack:FindFirstChild(toolName)
    if hum and tool then
        pcall(function() hum:EquipTool(tool) end)
    end
    lastEquipTime2 = now
end

local lastEquipAllTime = 0
local function EquipAllWeapon()
    pcall(function()
        local now = tick()
        if now - lastEquipAllTime < 0.2 then return end
        local hum = GetHum()
        if not hum then return end
        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name ~= "Summon Sea Beast" and v.Name ~= "Water Body" and v.Name ~= "Awakening" then
                hum:EquipTool(v)
            end
        end
        lastEquipAllTime = now
    end)
end

local function AttackNoCoolDown()
    pcall(function()
        local char = GetChar()
        if not char then return end
        local weapon
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then weapon = item; break end
        end
        if not weapon then EquipAllWeapon(); return end
        local storage = ReplicatedStorage
        local enemies = {}
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")
                and not Players:GetPlayerFromCharacter(v) and v ~= char then
                local h = v:FindFirstChild("Humanoid")
                if h and h.Health > 0 then table.insert(enemies, v) end
            end
        end
        if weapon:FindFirstChild("LeftClickRemote") then
            local count = 1
            for _, enemy in ipairs(enemies) do
                local r = enemy:FindFirstChild("HumanoidRootPart")
                if r then
                    local dir = (r.Position - char:GetPivot().Position).Unit
                    pcall(function() weapon.LeftClickRemote:FireServer(dir, count) end)
                    count = count + 1
                end
            end
        else
            local targets, mainTarget = {}, nil
            for _, enemy in ipairs(enemies) do
                if not enemy:GetAttribute("IsBoat") then
                    local head = enemy:FindFirstChild("Head")
                    if head then
                        table.insert(targets, {enemy, head})
                        mainTarget = head
                    end
                end
            end
            if mainTarget then
                local net = storage:FindFirstChild("Modules") and storage.Modules:FindFirstChild("Net")
                if net then
                    local atk = net:FindFirstChild("RE/RegisterAttack")
                    local hit = net:FindFirstChild("RE/RegisterHit")
                    if atk and hit then
                        pcall(function() atk:FireServer(0.1); hit:FireServer(mainTarget, targets) end)
                    end
                end
            end
        end
    end)
end

local Mon, NameMon, NameQuest, LevelQuest, CFrameQuest, CFrameMon
local MMon, MPos, SP

local function CheckQuest()
    local myLevel = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value or 1
    if World1 then
        if myLevel >= 1 and myLevel <= 9 then
            Mon="Bandit" LevelQuest=1 NameQuest="BanditQuest1" NameMon="Bandit"
            CFrameQuest=CFrame.new(1059.37195,15.4495068,1550.4231,0.939700544,0,-0.341998369,0,1,0,0.341998369,0,0.939700544)
            CFrameMon=CFrame.new(1045.962646484375,27.00250816345215,1560.8203125)
        elseif myLevel >= 10 and myLevel <= 14 then
            Mon="Monkey" LevelQuest=1 NameQuest="JungleQuest" NameMon="Monkey"
            CFrameQuest=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,0,-1,0,0)
            CFrameMon=CFrame.new(-1448.51806640625,67.85301208496094,11.46579647064209)
        elseif myLevel >= 15 and myLevel <= 29 then
            Mon="Gorilla" LevelQuest=2 NameQuest="JungleQuest" NameMon="Gorilla"
            CFrameQuest=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,0,-1,0,0)
            CFrameMon=CFrame.new(-1129.8836669921875,40.46354675292969,-525.4237060546875)
        elseif myLevel >= 30 and myLevel <= 39 then
            Mon="Pirate" LevelQuest=1 NameQuest="BuggyQuest1" NameMon="Pirate"
            CFrameQuest=CFrame.new(-1141.07483,4.10001802,3831.5498,0.965929627,0,-0.258804798,0,1,0,0.258804798,0,0.965929627)
            CFrameMon=CFrame.new(-1103.513427734375,13.752052307128906,3896.091064453125)
        elseif myLevel >= 40 and myLevel <= 59 then
            Mon="Brute" LevelQuest=2 NameQuest="BuggyQuest1" NameMon="Brute"
            CFrameQuest=CFrame.new(-1141.07483,4.10001802,3831.5498,0.965929627,0,-0.258804798,0,1,0,0.258804798,0,0.965929627)
            CFrameMon=CFrame.new(-1140.083740234375,14.809885025024414,4322.92138671875)
        elseif myLevel >= 60 and myLevel <= 74 then
            Mon="Desert Bandit" LevelQuest=1 NameQuest="DesertQuest" NameMon="Desert Bandit"
            CFrameQuest=CFrame.new(894.488647,5.14000702,4392.43359,0.819155693,0,-0.573571265,0,1,0,0.573571265,0,0.819155693)
            CFrameMon=CFrame.new(924.7998046875,6.44867467880249,4481.5859375)
        elseif myLevel >= 75 and myLevel <= 89 then
            Mon="Desert Officer" LevelQuest=2 NameQuest="DesertQuest" NameMon="Desert Officer"
            CFrameQuest=CFrame.new(894.488647,5.14000702,4392.43359,0.819155693,0,-0.573571265,0,1,0,0.573571265,0,0.819155693)
            CFrameMon=CFrame.new(1608.2822265625,8.614224433898926,4371.00732421875)
        elseif myLevel >= 90 and myLevel <= 99 then
            Mon="Snow Bandit" LevelQuest=1 NameQuest="SnowQuest" NameMon="Snow Bandit"
            CFrameQuest=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,0.939684391,0,1,0,-0.939684391,0,-0.342042685)
            CFrameMon=CFrame.new(1354.347900390625,87.27277374267578,-1393.946533203125)
        elseif myLevel >= 100 and myLevel <= 119 then
            Mon="Snowman" LevelQuest=2 NameQuest="SnowQuest" NameMon="Snowman"
            CFrameQuest=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,0.939684391,0,1,0,-0.939684391,0,-0.342042685)
            CFrameMon=CFrame.new(1201.6412353515625,144.57958984375,-1550.0670166015625)
        elseif myLevel >= 120 and myLevel <= 149 then
            Mon="Chief Petty Officer" LevelQuest=1 NameQuest="MarineQuest2" NameMon="Chief Petty Officer"
            CFrameQuest=CFrame.new(-5039.58643,27.3500385,4324.68018,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-4881.23095703125,22.65204429626465,4273.75244140625)
        elseif myLevel >= 150 and myLevel <= 174 then
            Mon="Sky Bandit" LevelQuest=1 NameQuest="SkyQuest" NameMon="Sky Bandit"
            CFrameQuest=CFrame.new(-4839.53027,716.368591,-2619.44165,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)
            CFrameMon=CFrame.new(-4953.20703125,295.74420166015625,-2899.22900390625)
        elseif myLevel >= 175 and myLevel <= 189 then
            Mon="Dark Master" LevelQuest=2 NameQuest="SkyQuest" NameMon="Dark Master"
            CFrameQuest=CFrame.new(-4839.53027,716.368591,-2619.44165,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)
            CFrameMon=CFrame.new(-5259.8447265625,391.3976745605469,-2229.035400390625)
        elseif myLevel >= 190 and myLevel <= 209 then
            Mon="Prisoner" LevelQuest=1 NameQuest="PrisonerQuest" NameMon="Prisoner"
            CFrameQuest=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,0.995993316,-2.06384709e-09,-0.0894274712)
            CFrameMon=CFrame.new(5098.9736328125,-0.3204058110713959,474.2373352050781)
        elseif myLevel >= 210 and myLevel <= 249 then
            Mon="Dangerous Prisoner" LevelQuest=2 NameQuest="PrisonerQuest" NameMon="Dangerous Prisoner"
            CFrameQuest=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,0.995993316,-2.06384709e-09,-0.0894274712)
            CFrameMon=CFrame.new(5654.5634765625,15.633401870727539,866.2991943359375)
        elseif myLevel >= 250 and myLevel <= 274 then
            Mon="Toga Warrior" LevelQuest=1 NameQuest="ColosseumQuest" NameMon="Toga Warrior"
            CFrameQuest=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,0.857167721,0,-0.515037298)
            CFrameMon=CFrame.new(-1820.21484375,51.68385696411133,-2740.6650390625)
        elseif myLevel >= 275 and myLevel <= 299 then
            Mon="Gladiator" LevelQuest=2 NameQuest="ColosseumQuest" NameMon="Gladiator"
            CFrameQuest=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,0.857167721,0,-0.515037298)
            CFrameMon=CFrame.new(-1292.838134765625,56.380882263183594,-3339.031494140625)
        elseif myLevel >= 300 and myLevel <= 324 then
            Mon="Military Soldier" LevelQuest=1 NameQuest="MagmaQuest" NameMon="Military Soldier"
            CFrameQuest=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,0.866048813,0,1,0,-0.866048813,0,-0.499959469)
            CFrameMon=CFrame.new(-5411.16455078125,11.081554412841797,8454.29296875)
        elseif myLevel >= 325 and myLevel <= 374 then
            Mon="Military Spy" LevelQuest=2 NameQuest="MagmaQuest" NameMon="Military Spy"
            CFrameQuest=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,0.866048813,0,1,0,-0.866048813,0,-0.499959469)
            CFrameMon=CFrame.new(-5802.8681640625,86.26241302490234,8828.859375)
        elseif myLevel >= 375 and myLevel <= 399 then
            Mon="Fishman Warrior" LevelQuest=1 NameQuest="FishmanQuest" NameMon="Fishman Warrior"
            CFrameQuest=CFrame.new(61122.65234375,18.497442245483,1569.3997802734)
            CFrameMon=CFrame.new(60878.30078125,18.482830047607422,1543.7574462890625)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875)) end)
            end
        elseif myLevel >= 400 and myLevel <= 449 then
            Mon="Fishman Commando" LevelQuest=2 NameQuest="FishmanQuest" NameMon="Fishman Commando"
            CFrameQuest=CFrame.new(61122.65234375,18.497442245483,1569.3997802734)
            CFrameMon=CFrame.new(61922.6328125,18.482830047607422,1493.934326171875)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625,11.6796875,1819.7841796875)) end)
            end
        elseif myLevel >= 450 and myLevel <= 474 then
            Mon="God's Guard" LevelQuest=1 NameQuest="SkyExp1Quest" NameMon="God's Guard"
            CFrameQuest=CFrame.new(-4721.88867,843.874695,-1949.96643,0.996191859,0,-0.0871884301,0,1,0,0.0871884301,0,0.996191859)
            CFrameMon=CFrame.new(-4710.04296875,845.2769775390625,-1927.3079833984375)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275,872.54248,-1667.55688)) end)
            end
        elseif myLevel >= 475 and myLevel <= 524 then
            Mon="Shanda" LevelQuest=2 NameQuest="SkyExp1Quest" NameMon="Shanda"
            CFrameQuest=CFrame.new(-7859.09814,5544.19043,-381.476196,-0.422592998,0,0.906319618,0,1,0,-0.906319618,0,-0.422592998)
            CFrameMon=CFrame.new(-7678.48974609375,5566.40380859375,-497.2156066894531)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813,5547.1416015625,-380.29119873047)) end)
            end
        elseif myLevel >= 525 and myLevel <= 549 then
            Mon="Royal Squad" LevelQuest=1 NameQuest="SkyExp2Quest" NameMon="Royal Squad"
            CFrameQuest=CFrame.new(-7906.81592,5634.6626,-1411.99194,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-7624.25244140625,5658.13330078125,-1467.354248046875)
        elseif myLevel >= 550 and myLevel <= 624 then
            Mon="Royal Soldier" LevelQuest=2 NameQuest="SkyExp2Quest" NameMon="Royal Soldier"
            CFrameQuest=CFrame.new(-7906.81592,5634.6626,-1411.99194,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-7836.75341796875,5645.6640625,-1790.6236572265625)
        elseif myLevel >= 625 and myLevel <= 649 then
            Mon="Galley Pirate" LevelQuest=1 NameQuest="FountainQuest" NameMon="Galley Pirate"
            CFrameQuest=CFrame.new(5259.81982,37.3500175,4050.0293,0.087131381,0,0.996196866,0,1,0,-0.996196866,0,0.087131381)
            CFrameMon=CFrame.new(5551.02197265625,78.90135192871094,3930.412841796875)
        elseif myLevel >= 650 then
            Mon="Galley Captain" LevelQuest=2 NameQuest="FountainQuest" NameMon="Galley Captain"
            CFrameQuest=CFrame.new(5259.81982,37.3500175,4050.0293,0.087131381,0,0.996196866,0,1,0,-0.996196866,0,0.087131381)
            CFrameMon=CFrame.new(5441.95166015625,42.50205993652344,4950.09375)
        end
    elseif World2 then
        if myLevel >= 700 and myLevel <= 724 then
            Mon="Raider" LevelQuest=1 NameQuest="Area1Quest" NameMon="Raider"
            CFrameQuest=CFrame.new(-429.543518,71.7699966,1836.18188,-0.22495985,0,-0.974368095,0,1,0,0.974368095,0,-0.22495985)
            CFrameMon=CFrame.new(-728.3267211914062,52.779319763183594,2345.7705078125)
        elseif myLevel >= 725 and myLevel <= 774 then
            Mon="Mercenary" LevelQuest=2 NameQuest="Area1Quest" NameMon="Mercenary"
            CFrameQuest=CFrame.new(-429.543518,71.7699966,1836.18188,-0.22495985,0,-0.974368095,0,1,0,0.974368095,0,-0.22495985)
            CFrameMon=CFrame.new(-1004.3244018554688,80.15886688232422,1424.619384765625)
        elseif myLevel >= 775 and myLevel <= 799 then
            Mon="Swan Pirate" LevelQuest=1 NameQuest="Area2Quest" NameMon="Swan Pirate"
            CFrameQuest=CFrame.new(638.43811,71.769989,918.282898,0.139203906,0,0.99026376,0,1,0,-0.99026376,0,0.139203906)
            CFrameMon=CFrame.new(1068.664306640625,137.61428833007812,1322.1060791015625)
        elseif myLevel >= 800 and myLevel <= 874 then
            Mon="Factory Staff" LevelQuest=2 NameQuest="Area2Quest" NameMon="Factory Staff"
            CFrameQuest=CFrame.new(632.698608,73.1055908,918.666321,-0.0319722369,8.96074881e-10,-0.999488771,1.36326533e-10,1,8.92172336e-10,0.999488771,-1.07732087e-10,-0.0319722369)
            CFrameMon=CFrame.new(73.07867431640625,81.86344146728516,-27.470672607421875)
        elseif myLevel >= 875 and myLevel <= 899 then
            Mon="Marine Lieutenant" LevelQuest=1 NameQuest="MarineQuest3" NameMon="Marine Lieutenant"
            CFrameQuest=CFrame.new(-2440.79639,71.7140732,-3216.06812,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)
            CFrameMon=CFrame.new(-2821.372314453125,75.89727783203125,-3070.089111328125)
        elseif myLevel >= 900 and myLevel <= 949 then
            Mon="Marine Captain" LevelQuest=2 NameQuest="MarineQuest3" NameMon="Marine Captain"
            CFrameQuest=CFrame.new(-2440.79639,71.7140732,-3216.06812,0.866007268,0,0.500031412,0,1,0,-0.500031412,0,0.866007268)
            CFrameMon=CFrame.new(-1861.2310791015625,80.17658233642578,-3254.697509765625)
        elseif myLevel >= 950 and myLevel <= 974 then
            Mon="Zombie" LevelQuest=1 NameQuest="ZombieQuest" NameMon="Zombie"
            CFrameQuest=CFrame.new(-5497.06152,47.5923004,-795.237061,-0.29242146,0,-0.95628953,0,1,0,0.95628953,0,-0.29242146)
            CFrameMon=CFrame.new(-5657.77685546875,78.96973419189453,-928.68701171875)
        elseif myLevel >= 975 and myLevel <= 999 then
            Mon="Vampire" LevelQuest=2 NameQuest="ZombieQuest" NameMon="Vampire"
            CFrameQuest=CFrame.new(-5497.06152,47.5923004,-795.237061,-0.29242146,0,-0.95628953,0,1,0,0.95628953,0,-0.29242146)
            CFrameMon=CFrame.new(-6037.66796875,32.18463897705078,-1340.6597900390625)
        elseif myLevel >= 1000 and myLevel <= 1049 then
            Mon="Snow Trooper" LevelQuest=1 NameQuest="SnowMountainQuest" NameMon="Snow Trooper"
            CFrameQuest=CFrame.new(609.858826,400.119904,-5372.25928,-0.374604106,0,0.92718488,0,1,0,-0.92718488,0,-0.374604106)
            CFrameMon=CFrame.new(549.1473388671875,427.3870544433594,-5563.69873046875)
        elseif myLevel >= 1050 and myLevel <= 1099 then
            Mon="Winter Warrior" LevelQuest=2 NameQuest="SnowMountainQuest" NameMon="Winter Warrior"
            CFrameQuest=CFrame.new(609.858826,400.119904,-5372.25928,-0.374604106,0,0.92718488,0,1,0,-0.92718488,0,-0.374604106)
            CFrameMon=CFrame.new(1142.7451171875,475.6398010253906,-5199.41650390625)
        elseif myLevel >= 1100 and myLevel <= 1124 then
            Mon="Lab Subordinate" LevelQuest=1 NameQuest="IceSideQuest" NameMon="Lab Subordinate"
            CFrameQuest=CFrame.new(-6064.06885,15.2422857,-4902.97852,0.453972578,0,-0.891015649,0,1,0,0.891015649,0,0.453972578)
            CFrameMon=CFrame.new(-5707.4716796875,15.951709747314453,-4513.39208984375)
        elseif myLevel >= 1125 and myLevel <= 1174 then
            Mon="Horned Warrior" LevelQuest=2 NameQuest="IceSideQuest" NameMon="Horned Warrior"
            CFrameQuest=CFrame.new(-6064.06885,15.2422857,-4902.97852,0.453972578,0,-0.891015649,0,1,0,0.891015649,0,0.453972578)
            CFrameMon=CFrame.new(-6341.36669921875,15.951770782470703,-5723.162109375)
        elseif myLevel >= 1175 and myLevel <= 1199 then
            Mon="Magma Ninja" LevelQuest=1 NameQuest="FireSideQuest" NameMon="Magma Ninja"
            CFrameQuest=CFrame.new(-5428.03174,15.0622921,-5299.43457,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)
            CFrameMon=CFrame.new(-5449.6728515625,76.65874481201172,-5808.20068359375)
        elseif myLevel >= 1200 and myLevel <= 1249 then
            Mon="Lava Pirate" LevelQuest=2 NameQuest="FireSideQuest" NameMon="Lava Pirate"
            CFrameQuest=CFrame.new(-5428.03174,15.0622921,-5299.43457,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)
            CFrameMon=CFrame.new(-5213.33154296875,49.73788070678711,-4701.451171875)
        elseif myLevel >= 1250 and myLevel <= 1274 then
            Mon="Ship Deckhand" LevelQuest=1 NameQuest="ShipQuest1" NameMon="Ship Deckhand"
            CFrameQuest=CFrame.new(1037.80127,125.092171,32911.6016)
            CFrameMon=CFrame.new(1212.0111083984375,150.79205322265625,33059.24609375)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125)) end)
            end
        elseif myLevel >= 1275 and myLevel <= 1299 then
            Mon="Ship Engineer" LevelQuest=2 NameQuest="ShipQuest1" NameMon="Ship Engineer"
            CFrameQuest=CFrame.new(1037.80127,125.092171,32911.6016)
            CFrameMon=CFrame.new(919.4786376953125,43.54401397705078,32779.96875)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125)) end)
            end
        elseif myLevel >= 1300 and myLevel <= 1324 then
            Mon="Ship Steward" LevelQuest=1 NameQuest="ShipQuest2" NameMon="Ship Steward"
            CFrameQuest=CFrame.new(968.80957,125.092171,33244.125)
            CFrameMon=CFrame.new(919.4385375976562,129.55599975585938,33436.03515625)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125)) end)
            end
        elseif myLevel >= 1325 and myLevel <= 1349 then
            Mon="Ship Officer" LevelQuest=2 NameQuest="ShipQuest2" NameMon="Ship Officer"
            CFrameQuest=CFrame.new(968.80957,125.092171,33244.125)
            CFrameMon=CFrame.new(1036.0179443359375,181.4390411376953,33315.7265625)
            if Flags.AutoFarm and (CFrameQuest.Position-GetHRP().Position).Magnitude>10000 then
                pcall(function() CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406,126.9760055542,32852.83203125)) end)
            end
        elseif myLevel >= 1350 and myLevel <= 1374 then
            Mon="Arctic Warrior" LevelQuest=1 NameQuest="FrostQuest" NameMon="Arctic Warrior"
            CFrameQuest=CFrame.new(5667.6582,26.7997818,-6486.08984,-0.933587909,0,-0.358349502,0,1,0,0.358349502,0,-0.933587909)
            CFrameMon=CFrame.new(5966.24609375,62.97002029418945,-6179.3828125)
        elseif myLevel >= 1375 and myLevel <= 1424 then
            Mon="Snow Lurker" LevelQuest=2 NameQuest="FrostQuest" NameMon="Snow Lurker"
            CFrameQuest=CFrame.new(5667.6582,26.7997818,-6486.08984,-0.933587909,0,-0.358349502,0,1,0,0.358349502,0,-0.933587909)
            CFrameMon=CFrame.new(5407.07373046875,69.19437408447266,-6880.88037109375)
        elseif myLevel >= 1425 and myLevel <= 1449 then
            Mon="Sea Soldier" LevelQuest=1 NameQuest="ForgottenQuest" NameMon="Sea Soldier"
            CFrameQuest=CFrame.new(-3054.44458,235.544281,-10142.8193,0.990270376,0,-0.13915664,0,1,0,0.13915664,0,0.990270376)
            CFrameMon=CFrame.new(-3028.2236328125,64.67451477050781,-9775.4267578125)
        elseif myLevel >= 1450 then
            Mon="Water Fighter" LevelQuest=2 NameQuest="ForgottenQuest" NameMon="Water Fighter"
            CFrameQuest=CFrame.new(-3054,240,-10146)
            CFrameMon=CFrame.new(-3291,252,-10501)
        end
    elseif World3 then
        if myLevel >= 1500 and myLevel <= 1524 then
            Mon="Pirate Millionaire" LevelQuest=1 NameQuest="PiratePortQuest" NameMon="Pirate Millionaire"
            CFrameQuest=CFrame.new(-290.074677,42.9034653,5581.58984,0.965929627,0,-0.258804798,0,1,0,0.258804798,0,0.965929627)
            CFrameMon=CFrame.new(-245.9963836669922,47.30615234375,5584.1005859375)
        elseif myLevel >= 1525 and myLevel <= 1574 then
            Mon="Pistol Billionaire" LevelQuest=2 NameQuest="PiratePortQuest" NameMon="Pistol Billionaire"
            CFrameQuest=CFrame.new(-290.074677,42.9034653,5581.58984,0.965929627,0,-0.258804798,0,1,0,0.258804798,0,0.965929627)
            CFrameMon=CFrame.new(-187.3301544189453,86.23987579345703,6013.513671875)
        elseif myLevel >= 1575 and myLevel <= 1599 then
            Mon="Dragon Crew Warrior" LevelQuest=1 NameQuest="DragonCrewQuest" NameMon="Dragon Crew Warrior"
            CFrameQuest=CFrame.new(6738.96142578125,127.81645965576172,-713.511474609375)
            CFrameMon=CFrame.new(6920.71435546875,56.15597152709961,-942.5044555664062)
        elseif myLevel >= 1600 and myLevel <= 1624 then
            Mon="Dragon Crew Archer" LevelQuest=2 NameQuest="DragonCrewQuest" NameMon="Dragon Crew Archer"
            CFrameQuest=CFrame.new(6738.96142578125,127.81645965576172,-713.511474609375)
            CFrameMon=CFrame.new(6817.91259765625,484.804443359375,513.4141235351562)
        elseif myLevel >= 1625 and myLevel <= 1649 then
            Mon="Hydra Enforcer" LevelQuest=1 NameQuest="VenomCrewQuest" NameMon="Hydra Enforcer"
            CFrameQuest=CFrame.new(5213.8740234375,1004.5042724609375,758.6944580078125)
            CFrameMon=CFrame.new(4584.69287109375,1002.6435546875,705.7958984375)
        elseif myLevel >= 1650 and myLevel <= 1699 then
            Mon="Venomous Assailant" LevelQuest=2 NameQuest="VenomCrewQuest" NameMon="Venomous Assailant"
            CFrameQuest=CFrame.new(5213.8740234375,1004.5042724609375,758.6944580078125)
            CFrameMon=CFrame.new(4638.78564453125,1078.94091796875,881.8002319335938)
        elseif myLevel >= 1700 and myLevel <= 1724 then
            Mon="Marine Commodore" LevelQuest=1 NameQuest="MarineTreeIsland" NameMon="Marine Commodore"
            CFrameQuest=CFrame.new(2180.54126,27.8156815,-6741.5498,-0.965929747,0,0.258804798,0,1,0,-0.258804798,0,-0.965929747)
            CFrameMon=CFrame.new(2286.0078125,73.13391876220703,-7159.80908203125)
        elseif myLevel >= 1725 and myLevel <= 1774 then
            Mon="Marine Rear Admiral" LevelQuest=2 NameQuest="MarineTreeIsland" NameMon="Marine Rear Admiral"
            CFrameQuest=CFrame.new(2179.98828125,28.731239318848,-6740.0551757813)
            CFrameMon=CFrame.new(3656.773681640625,160.52406311035156,-7001.5986328125)
        elseif myLevel >= 1775 and myLevel <= 1799 then
            Mon="Fishman Raider" LevelQuest=1 NameQuest="DeepForestIsland3" NameMon="Fishman Raider"
            CFrameQuest=CFrame.new(-10581.6563,330.872955,-8761.18652,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)
            CFrameMon=CFrame.new(-10407.5263671875,331.76263427734375,-8368.5166015625)
        elseif myLevel >= 1800 and myLevel <= 1824 then
            Mon="Fishman Captain" LevelQuest=2 NameQuest="DeepForestIsland3" NameMon="Fishman Captain"
            CFrameQuest=CFrame.new(-10581.6563,330.872955,-8761.18652,-0.882952213,0,0.469463557,0,1,0,-0.469463557,0,-0.882952213)
            CFrameMon=CFrame.new(-10994.701171875,352.38140869140625,-9002.1103515625)
        elseif myLevel >= 1825 and myLevel <= 1849 then
            Mon="Forest Pirate" LevelQuest=1 NameQuest="DeepForestIsland" NameMon="Forest Pirate"
            CFrameQuest=CFrame.new(-13234.04,331.488495,-7625.40137,0.707134247,0,-0.707079291,0,1,0,0.707079291,0,0.707134247)
            CFrameMon=CFrame.new(-13274.478515625,332.3781433105469,-7769.58056640625)
        elseif myLevel >= 1850 and myLevel <= 1899 then
            Mon="Mythological Pirate" LevelQuest=2 NameQuest="DeepForestIsland" NameMon="Mythological Pirate"
            CFrameQuest=CFrame.new(-13234.04,331.488495,-7625.40137,0.707134247,0,-0.707079291,0,1,0,0.707079291,0,0.707134247)
            CFrameMon=CFrame.new(-13680.607421875,501.08154296875,-6991.189453125)
        elseif myLevel >= 1900 and myLevel <= 1924 then
            Mon="Jungle Pirate" LevelQuest=1 NameQuest="DeepForestIsland2" NameMon="Jungle Pirate"
            CFrameQuest=CFrame.new(-12680.3818,389.971039,-9902.01953,-0.0871315002,0,0.996196866,0,1,0,-0.996196866,0,-0.0871315002)
            CFrameMon=CFrame.new(-12256.16015625,331.73828125,-10485.8369140625)
        elseif myLevel >= 1925 and myLevel <= 1974 then
            Mon="Musketeer Pirate" LevelQuest=2 NameQuest="DeepForestIsland2" NameMon="Musketeer Pirate"
            CFrameQuest=CFrame.new(-12680.3818,389.971039,-9902.01953,-0.0871315002,0,0.996196866,0,1,0,-0.996196866,0,-0.0871315002)
            CFrameMon=CFrame.new(-13457.904296875,391.545654296875,-9859.177734375)
        elseif myLevel >= 1975 and myLevel <= 1999 then
            Mon="Reborn Skeleton" LevelQuest=1 NameQuest="HauntedQuest1" NameMon="Reborn Skeleton"
            CFrameQuest=CFrame.new(-9479.2168,141.215088,5566.09277,0,0,1,0,1,0,-1,0,0)
            CFrameMon=CFrame.new(-8763.7236328125,165.72299194335938,6159.86181640625)
        elseif myLevel >= 2000 and myLevel <= 2024 then
            Mon="Living Zombie" LevelQuest=2 NameQuest="HauntedQuest1" NameMon="Living Zombie"
            CFrameQuest=CFrame.new(-9479.2168,141.215088,5566.09277,0,0,1,0,1,0,-1,0,0)
            CFrameMon=CFrame.new(-10144.1318359375,138.62667846679688,5838.0888671875)
        elseif myLevel >= 2025 and myLevel <= 2049 then
            Mon="Demonic Soul" LevelQuest=1 NameQuest="HauntedQuest2" NameMon="Demonic Soul"
            CFrameQuest=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-9505.8720703125,172.10482788085938,6158.9931640625)
        elseif myLevel >= 2050 and myLevel <= 2074 then
            Mon="Posessed Mummy" LevelQuest=2 NameQuest="HauntedQuest2" NameMon="Posessed Mummy"
            CFrameQuest=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-9582.0224609375,6.251527309417725,6205.478515625)
        elseif myLevel >= 2075 and myLevel <= 2099 then
            Mon="Peanut Scout" LevelQuest=1 NameQuest="NutsIslandQuest" NameMon="Peanut Scout"
            CFrameQuest=CFrame.new(-2104.3908691406,38.104167938232,-10194.21875,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-2143.241943359375,47.72198486328125,-10029.9951171875)
        elseif myLevel >= 2100 and myLevel <= 2124 then
            Mon="Peanut President" LevelQuest=2 NameQuest="NutsIslandQuest" NameMon="Peanut President"
            CFrameQuest=CFrame.new(-2104.3908691406,38.104167938232,-10194.21875,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-1859.35400390625,38.10316848754883,-10422.4296875)
        elseif myLevel >= 2125 and myLevel <= 2149 then
            Mon="Ice Cream Chef" LevelQuest=1 NameQuest="IceCreamIslandQuest" NameMon="Ice Cream Chef"
            CFrameQuest=CFrame.new(-820.64825439453,65.819526672363,-10965.795898438,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-872.24658203125,65.81957244873047,-10919.95703125)
        elseif myLevel >= 2150 and myLevel <= 2199 then
            Mon="Ice Cream Commander" LevelQuest=2 NameQuest="IceCreamIslandQuest" NameMon="Ice Cream Commander"
            CFrameQuest=CFrame.new(-820.64825439453,65.819526672363,-10965.795898438,0,0,-1,0,1,0,1,0,0)
            CFrameMon=CFrame.new(-558.06103515625,112.04895782470703,-11290.7744140625)
        elseif myLevel >= 2200 and myLevel <= 2224 then
            Mon="Cookie Crafter" LevelQuest=1 NameQuest="CakeQuest1" NameMon="Cookie Crafter"
            CFrameQuest=CFrame.new(-2021.32007,37.7982254,-12028.7295,0.957576931,-8.80302053e-08,0.288177818,6.9301187e-08,1,7.51931211e-08,-0.288177818,-5.2032135e-08,0.957576931)
            CFrameMon=CFrame.new(-2374.13671875,37.79826354980469,-12125.30859375)
        elseif myLevel >= 2225 and myLevel <= 2249 then
            Mon="Cake Guard" LevelQuest=2 NameQuest="CakeQuest1" NameMon="Cake Guard"
            CFrameQuest=CFrame.new(-2021.32007,37.7982254,-12028.7295,0.957576931,-8.80302053e-08,0.288177818,6.9301187e-08,1,7.51931211e-08,-0.288177818,-5.2032135e-08,0.957576931)
            CFrameMon=CFrame.new(-1598.3070068359375,43.773197174072266,-12244.5810546875)
        elseif myLevel >= 2250 and myLevel <= 2274 then
            Mon="Baking Staff" LevelQuest=1 NameQuest="CakeQuest2" NameMon="Baking Staff"
            CFrameQuest=CFrame.new(-1927.91602,37.7981339,-12842.5391,-0.96804446,4.22142143e-08,0.250778586,4.74911062e-08,1,1.49904711e-08,-0.250778586,2.64211941e-08,-0.96804446)
            CFrameMon=CFrame.new(-1887.8099365234375,77.6185073852539,-12998.3505859375)
        elseif myLevel >= 2275 and myLevel <= 2299 then
            Mon="Head Baker" LevelQuest=2 NameQuest="CakeQuest2" NameMon="Head Baker"
            CFrameQuest=CFrame.new(-1927.91602,37.7981339,-12842.5391,-0.96804446,4.22142143e-08,0.250778586,4.74911062e-08,1,1.49904711e-08,-0.250778586,2.64211941e-08,-0.96804446)
            CFrameMon=CFrame.new(-2216.188232421875,82.884521484375,-12869.2939453125)
        elseif myLevel >= 2300 and myLevel <= 2324 then
            Mon="Cocoa Warrior" LevelQuest=1 NameQuest="ChocQuest1" NameMon="Cocoa Warrior"
            CFrameQuest=CFrame.new(233.22836303710938,29.876001358032227,-12201.2333984375)
            CFrameMon=CFrame.new(-21.55328369140625,80.57499694824219,-12352.3876953125)
        elseif myLevel >= 2325 and myLevel <= 2349 then
            Mon="Chocolate Bar Battler" LevelQuest=2 NameQuest="ChocQuest1" NameMon="Chocolate Bar Battler"
            CFrameQuest=CFrame.new(233.22836303710938,29.876001358032227,-12201.2333984375)
            CFrameMon=CFrame.new(582.590576171875,77.18809509277344,-12463.162109375)
        elseif myLevel >= 2350 and myLevel <= 2374 then
            Mon="Sweet Thief" LevelQuest=1 NameQuest="ChocQuest2" NameMon="Sweet Thief"
            CFrameQuest=CFrame.new(150.5066375732422,30.693693161010742,-12774.5029296875)
            CFrameMon=CFrame.new(165.1884765625,76.05885314941406,-12600.8369140625)
        elseif myLevel >= 2375 and myLevel <= 2399 then
            Mon="Candy Rebel" LevelQuest=2 NameQuest="ChocQuest2" NameMon="Candy Rebel"
            CFrameQuest=CFrame.new(150.5066375732422,30.693693161010742,-12774.5029296875)
            CFrameMon=CFrame.new(134.86563110351562,77.2476806640625,-12876.5478515625)
        elseif myLevel >= 2400 and myLevel <= 2424 then
            Mon="Candy Pirate" LevelQuest=1 NameQuest="CandyQuest1" NameMon="Candy Pirate"
            CFrameQuest=CFrame.new(-1150.0400390625,20.378934860229492,-14446.3349609375)
            CFrameMon=CFrame.new(-1310.5003662109375,26.016523361206055,-14562.404296875)
        elseif myLevel >= 2425 and myLevel <= 2449 then
            Mon="Snow Demon" LevelQuest=2 NameQuest="CandyQuest1" NameMon="Snow Demon"
            CFrameQuest=CFrame.new(-1150.0400390625,20.378934860229492,-14446.3349609375)
            CFrameMon=CFrame.new(-880.2006225585938,71.24776458740234,-14538.609375)
        elseif myLevel >= 2450 and myLevel <= 2474 then
            Mon="Isle Outlaw" LevelQuest=1 NameQuest="TikiQuest1" NameMon="Isle Outlaw"
            CFrameQuest=CFrame.new(-16547.748046875,61.13533401489258,-173.41360473632812)
            CFrameMon=CFrame.new(-16442.814453125,116.13899993896484,-264.4637756347656)
        elseif myLevel >= 2475 and myLevel <= 2524 then
            Mon="Island Boy" LevelQuest=2 NameQuest="TikiQuest1" NameMon="Island Boy"
            CFrameQuest=CFrame.new(-16547.748046875,61.13533401489258,-173.41360473632812)
            CFrameMon=CFrame.new(-16901.26171875,84.06756591796875,-192.88906860351562)
        elseif myLevel >= 2525 and myLevel <= 2550 then
            Mon="Isle Champion" LevelQuest=2 NameQuest="TikiQuest2" NameMon="Isle Champion"
            CFrameQuest=CFrame.new(-16539.078125,55.68632888793945,1051.5738525390625)
            CFrameMon=CFrame.new(-16641.6796875,235.7825469970703,1031.282958984375)
        elseif myLevel >= 2550 and myLevel <= 2574 then
            Mon="Serpent Hunter" LevelQuest=1 NameQuest="TikiQuest3" NameMon="Serpent Hunter"
            CFrameQuest=CFrame.new(-16665.1914,104.596405,1579.69434,0.951068401,0,-0.308980465,0,1,0,0.308980465,0,0.951068401)
            CFrameMon=CFrame.new(-16521.0625,106.09285,1488.78467,0.469467044,0,0.882950008,0,1,0,-0.882950008,0,0.469467044)
        elseif myLevel >= 2575 then
            Mon="Skull Slayer" LevelQuest=2 NameQuest="TikiQuest3" NameMon="Skull Slayer"
            CFrameQuest=CFrame.new(-16665.1914,104.596405,1579.69434,0.951068401,0,-0.308980465,0,1,0,0.308980465,0,0.951068401)
            CFrameMon=CFrame.new(-16855.043,122.457253,1478.15308,-0.999392271,0,-0.0348687991,0,1,0,0.0348687991,0,-0.999392271)
        end
    end
end

local function MaterialMon()
    local hrp = GetHRP()
    if not hrp then return end
    local sel = Settings and Settings.SelectedMaterial or ""
    local function tryEntrance(pos, dist)
        if (hrp.Position - pos).Magnitude >= dist then
            pcall(function() CommF_:InvokeServer("requestEntrance", pos) end)
        end
    end
    if World1 then
        if sel == "Angel Wings" then
            MMon={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"}
            MPos=CFrame.new(-4698,845,-1912) SP="Default"
            tryEntrance(Vector3.new(-4607.82275,872.54248,-1667.55688),10000)
        elseif sel == "Leather + Scrap Metal" then
            MMon={"Brute","Pirate"} MPos=CFrame.new(-1145,15,4350) SP="Default"
        elseif sel == "Magma Ore" then
            MMon={"Military Soldier","Military Spy","Magma Admiral"} MPos=CFrame.new(-5815,84,8820) SP="Default"
        elseif sel == "Fish Tail" then
            MMon={"Fishman Warrior","Fishman Commando","Fishman Lord"} MPos=CFrame.new(61123,19,1569) SP="Default"
            tryEntrance(Vector3.new(61163.8515625,5.342342376708984,1819.7841796875),17000)
        end
    elseif World2 then
        if sel == "Leather + Scrap Metal" then
            MMon={"Marine Captain"} MPos=CFrame.new(-2010.5059814453125,73.00115966796875,-3326.620849609375) SP="Default"
        elseif sel == "Magma Ore" then
            MMon={"Magma Ninja","Lava Pirate"} MPos=CFrame.new(-5428,78,-5959) SP="Default"
        elseif sel == "Ectoplasm" then
            MMon={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"} MPos=CFrame.new(911.35827636719,125.95812988281,33159.5390625) SP="Default"
        elseif sel == "Mystic Droplet" then
            MMon={"Water Fighter"} MPos=CFrame.new(-3385,239,-10542) SP="Default"
        elseif sel == "Radioactive Material" then
            MMon={"Factory Staff"} MPos=CFrame.new(295,73,-56) SP="Default"
        elseif sel == "Vampire Fang" then
            MMon={"Vampire"} MPos=CFrame.new(-6033,7,-1317) SP="Default"
        end
    elseif World3 then
        if sel == "Leather + Scrap Metal" then
            MMon={"Jungle Pirate","Forest Pirate"} MPos=CFrame.new(-11975.78515625,331.7734069824219,-10620.0302734375) SP="Default"
        elseif sel == "Fish Tail" then
            MMon={"Fishman Raider","Fishman Captain"} MPos=CFrame.new(-10993,332,-8940) SP="Default"
        elseif sel == "Conjured Cocoa" then
            MMon={"Chocolate Bar Battler","Cocoa Warrior"} MPos=CFrame.new(620.6344604492188,78.93644714355469,-12581.369140625) SP="Default"
        elseif sel == "Dragon Scale" then
            MMon={"Dragon Crew Warrior"} MPos=CFrame.new(6594,383,139) SP="Default"
        elseif sel == "Gunpowder" then
            MMon={"Pistol Billionaire"} MPos=CFrame.new(-469,74,5904) SP="Default"
        elseif sel == "Mini Tusk" then
            MMon={"Mythological Pirate"} MPos=CFrame.new(-13545,470,-6917) SP="Default"
        end
    end
end

local function FindMobByName(name)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            local h = v:FindFirstChild("Humanoid")
            if h.Health > 0 then return v end
        end
    end
    return nil
end

local function FindNearestMob()
    local hrp = GetHRP()
    if not hrp then return nil end
    local nearest, nearestDist = nil, 9999
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")
            and not Players:GetPlayerFromCharacter(v) and v ~= GetChar() then
            local h = v:FindFirstChild("Humanoid")
            if h.Health > 0 then
                local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < nearestDist then nearestDist = d; nearest = v end
            end
        end
    end
    return nearest
end

local function TweenToMob(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    local hrp = GetHRP()
    if not hrp then return end
    local targetCF = mob.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
    local dist = (hrp.Position - targetCF.Position).Magnitude
    if dist < 1 then return end
    local speed = TweenSpeed or 350
    local tw = TweenService:Create(hrp, TweenInfo.new(math.max(0.05, dist / speed), Enum.EasingStyle.Linear), {CFrame = targetCF})
    tw:Play()
    tw.Completed:Wait()
end

local function KillMob(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    TweenToMob(mob)
    AttackNoCoolDown()
    pcall(function()
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        if tool then
            local re = tool:FindFirstChildWhichIsA("RemoteEvent")
            if re then re:FireServer(mob.HumanoidRootPart.CFrame) end
        end
    end)
end

local function FindFruit()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:GetAttribute("Id") and v:FindFirstChild("Handle") then
            return v
        end
    end
    return nil
end

local function AddStat(statName)
    pcall(function()
        for _ = 1, (Settings and Settings.StatPoint or 1) do
            CommF_:InvokeServer("AddStat", statName)
        end
    end)
end

local function ServerHop()
    task.spawn(function()
        local ok, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and servers and servers.data then
            for _, v in pairs(servers.data) do
                if v.id ~= game.JobId and v.playing < v.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                    return
                end
            end
        end
        notify("Server tidak ditemukan.")
    end)
end

task.spawn(function()
    while task.wait() do
        pcall(function()
            local hrp = GetHRP()
            if not hrp then return end
            local anyActive = Flags.AutoFarm or Flags.AutoFarmLevel or Flags.AutoFarmNearest
                or Flags.AutoFarmMaterial or Flags.AutoFarmBoss or Flags.AutoFarmAllBoss
                or Flags.AutoRaid or Flags.AutoPirateRaid or Flags.AutoEliteHunter
                or Flags.AutoFruitMastery or Flags.AutoGunMastery or Flags.AutoSwordMastery
                or Flags.SailBoat or Flags.AutoFarmSeabeast or Flags.AutoFrozen
                or Flags.AutoLeviathan or Flags.AutoPrehistoric or Flags.AutoKitsuneIsland
                or Flags.AutoDracoV1 or Flags.AutoDracoV2 or Flags.AutoDracoV3
                or Flags.TeleportToFruit or Flags.TweenToFruit
            if anyActive then
                if not hrp:FindFirstChild("BodyClip") then
                    local bc = Instance.new("BodyVelocity")
                    bc.Name = "BodyClip"
                    bc.Parent = hrp
                    bc.MaxForce = Vector3.new(100000,100000,100000)
                    bc.Velocity = Vector3.new(0,0,0)
                end
            else
                local bc = hrp:FindFirstChild("BodyClip")
                if bc then bc:Destroy() end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = GetChar()
            if not char then return end
            local anyActive = Flags.AutoFarm or Flags.AutoFarmLevel or Flags.AutoFarmNearest
                or Flags.AutoFarmMaterial or Flags.AutoFarmBoss or Flags.AutoFarmAllBoss
                or Flags.AutoRaid or Flags.SailBoat or Flags.AutoFarmSeabeast
            if anyActive then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if Flags.AutoFarm or Flags.Kill_Trial_V4 then
                ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
            end
        end)
    end
end)

-- AutoSeaBest random movement position update
task.spawn(function()
    local lastPosUpdate = tick()
    while task.wait(0.1) do
        pcall(function()
            if Flags.AutoFarmSeabeast then
                local now = tick()
                if now - lastPosUpdate >= 0.5 then
                    local Pos = CFrame.new(math.random(-600, 600), math.random(0, 300), math.random(-600, 600))
                    local hrp = GetHRP()
                    if hrp then topos(Pos) end
                    lastPosUpdate = now
                end
            end
        end)
    end
end)

local Flags = {}
Settings = {
    FarmDistance    = 15,
    TweenSpeed      = 30,
    MasteryHealth   = 20,
    StatPoint       = 1,
    BoatSpeed       = 50,
    SelectedWeapon  = "Sword",
    SelectedFruitSkill = "Z",
    SelectedGunSkill   = "Z",
    SelectedMethod  = "Mob",
    SelectedSword   = "Katana",
    SelectedMon     = "Musketeer",
    SelectedBoss    = "Gorilla King",
    SelectedMaterial= "Magma Ore",
    SelectedChip    = "Smoke",
    SelectedPlace   = "Middle Town",
    SelectedBoat    = "Galleon",
    SelectedZone    = "First Sea",
    SelectedBringMob= "All",
    SelectedUnstoreFruit = "Common - Mythical",
    SelectedStoreFruit   = "Common - Mythical",
    AzureEmberAmount= 0,
    SelectedPlayer  = nil,
    SelectedIsland  = "Middle Town",
    SelectedNpc     = "Sword Dealer",
    BoneMethod      = "Cursed Captain",
    ValentineItem   = nil,
    SeaEventFruit   = "Z",
    SeaEventMelee   = "Z",
}

local IslandCoords = {
    ["Marine Starter Island"] = Vector3.new(-1386, 4, -3000),
    ["Pirate Starter Island"] = Vector3.new(-1386, 4, -3000),
    ["Middle Town"]           = Vector3.new(250, 8, -600),
    ["Jungle"]                = Vector3.new(1717, 8, 882),
    ["Pirate Village"]        = Vector3.new(-1413, 8, 1083),
    ["Desert"]                = Vector3.new(938, 8, 3401),
    ["Navy Headquarters"]     = Vector3.new(1005, 8, -2700),
    ["Skylands"]              = Vector3.new(-4947, 905, -1019),
    ["Colosseum"]             = Vector3.new(-1247, 8, 3987),
    ["Impel Down"]            = Vector3.new(3018, -164, 2980),
    ["Marineford"]            = Vector3.new(-4882, 10, 0),
    ["Enies Lobby"]           = Vector3.new(-5390, 10, -2980),
    ["Fishman Island"]        = Vector3.new(61134, 1, 1851),
    ["Green Zone"]            = Vector3.new(4219, 63, 837),
    ["Kingdom of Rose"]       = Vector3.new(-1025, 14, -2549),
    ["Wedding Island"]        = Vector3.new(-1718, 14, 2244),
    ["Chamber of Time"]       = Vector3.new(-157, 105, -2120),
    ["Wano Country"]          = Vector3.new(-5765, 98, -1055),
    ["Haunted Castle"]        = Vector3.new(-6858, 99, -725),
    ["Hydra Island"]          = Vector3.new(6183, 30, 770),
    ["Sea of Treats"]         = Vector3.new(-7038, 14, -3249),
    ["Floating Turtle"]       = Vector3.new(-12830, 250, -5480),
    ["Demon Island"]          = Vector3.new(-14580, 130, -1920),
    ["Tiki Island"]           = Vector3.new(-11400, 30, 1300),
    ["Peanut Island"]         = Vector3.new(-10500, 30, -3300),
    ["First Sea"]             = Vector3.new(250, 8, -600),
    ["Second Sea"]            = Vector3.new(-1025, 14, -2549),
    ["Third Sea"]             = Vector3.new(-12830, 250, -5480),
}

local EspObjects = {}
local function ClearEspAll()
    for _, bb in pairs(EspObjects) do pcall(function() bb:Destroy() end) end
    EspObjects = {}
end

local function CreateEspBillboard(part, label, color)
    if EspObjects[part] then pcall(function() EspObjects[part]:Destroy() end) end
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 100, 0, 30)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
    bb.Adornee = part
    bb.Parent = LocalPlayer.PlayerGui
    local txt = Instance.new("TextLabel", bb)
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = label
    txt.TextColor3 = color or Color3.fromRGB(255, 255, 0)
    txt.TextStrokeTransparency = 0
    txt.TextScaled = true
    EspObjects[part] = bb
end

local function UpdateESP()
    if Flags.EspPlayer then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                CreateEspBillboard(p.Character.HumanoidRootPart, p.Name, Color3.fromRGB(255, 80, 80))
            end
        end
    end
    if Flags.EspChest then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Chest") and v:IsA("BasePart") then
                CreateEspBillboard(v, "Chest", Color3.fromRGB(255, 215, 0))
            end
        end
    end
    if Flags.EspFruit or Flags.EspRealFruit then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:GetAttribute("Id") and v:FindFirstChild("Handle") then
                CreateEspBillboard(v.Handle, v.Name, Color3.fromRGB(128, 0, 255))
            end
        end
    end
    if Flags.EspSeaBeast then
        for _, v in pairs(Workspace:GetDescendants()) do
            if (v.Name:find("Sea Beast") or v.Name:find("SeaBeast")) and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                CreateEspBillboard(v.HumanoidRootPart, v.Name, Color3.fromRGB(0, 200, 255))
            end
        end
    end
    if Flags.EspMonster then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")
                and not Players:GetPlayerFromCharacter(v) and v ~= GetChar() then
                local h = v:FindFirstChild("Humanoid")
                if h and h.Health > 0 then
                    CreateEspBillboard(v.HumanoidRootPart, v.Name, Color3.fromRGB(255, 100, 0))
                end
            end
        end
    end
    if Flags.EspGear then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Gear") and v:IsA("BasePart") then
                CreateEspBillboard(v, v.Name, Color3.fromRGB(0, 150, 255))
            end
        end
    end
    if Flags.EspFlower then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:find("Flower") and v:IsA("BasePart") then
                CreateEspBillboard(v, "Flower", Color3.fromRGB(255, 182, 193))
            end
        end
    end
    if Flags.EspNpc then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")
                and not Players:GetPlayerFromCharacter(v) and v ~= GetChar() then
                local h = v:FindFirstChild("Humanoid")
                if h and h.MaxHealth == math.huge then
                    CreateEspBillboard(v.HumanoidRootPart, v.Name, Color3.fromRGB(0, 255, 100))
                end
            end
        end
    end
end

local NoClipConn, WalkOnWaterConn

local Tabs = {
    Main        = Window:AddTab({ Name = "Main",         Icon = "house" }),
    Others      = Window:AddTab({ Name = "Others",       Icon = "inbox" }),
    Items       = Window:AddTab({ Name = "Items",        Icon = "box" }),
    Settings    = Window:AddTab({ Name = "Settings",     Icon = "settings" }),
    LocalPlayer = Window:AddTab({ Name = "Local Player", Icon = "user" }),
    Stats       = Window:AddTab({ Name = "Stats",        Icon = "bar-chart-2" }),
    SeaEvent    = Window:AddTab({ Name = "Sea Event",    Icon = "anchor" }),
    SeaStack    = Window:AddTab({ Name = "Sea Stack",    Icon = "waves" }),
    DragonDojo  = Window:AddTab({ Name = "Dragon Dojo",  Icon = "shield" }),
    Race        = Window:AddTab({ Name = "Race",         Icon = "bot" }),
    Combat      = Window:AddTab({ Name = "Combat",       Icon = "sword" }),
    Raid        = Window:AddTab({ Name = "Raid",         Icon = "zap" }),
    Esp         = Window:AddTab({ Name = "Esp",          Icon = "eye" }),
    Teleport    = Window:AddTab({ Name = "Teleport",     Icon = "map-pin" }),
    Shop        = Window:AddTab({ Name = "Shop",         Icon = "shopping-cart" }),
    Fruit       = Window:AddTab({ Name = "Fruit",        Icon = "flask-conical" }),
    Misc        = Window:AddTab({ Name = "Misc",         Icon = "layout-grid" }),
    Server      = Window:AddTab({ Name = "Server",       Icon = "server" }),
}

local InfoSection = Tabs.Main:AddSection("StreeHub | Info")
InfoSection:AddParagraph({ Title = "Game Time", Content = "Loading...", Icon = "clock" })
InfoSection:AddParagraph({ Title = "FPS",        Content = "Loading...", Icon = "activity" })
InfoSection:AddParagraph({ Title = "Ping",       Content = "Loading...", Icon = "wifi" })
InfoSection:AddParagraph({ Title = "Discord Server", Content = "discord.gg/streehub", Icon = "discord" })
InfoSection:AddPanel({
    Title = "Join Discord",
    ButtonText = "Copy Link",
    ButtonCallback = function()
        if setclipboard then setclipboard("https://discord.gg/streehub") end
        notify("Discord link copied!")
    end
})

local AutoFarmSection = Tabs.Main:AddSection("StreeHub | Auto Farm")
AutoFarmSection:AddDropdown({
    Title = "Weapon",
    Content = "Choose weapon type for auto farm.",
    Options = { "Sword", "Gun", "Devil Fruit", "Melee" },
    Default = "Sword",
    Callback = function(v) Settings.SelectedWeapon = v end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Level",
    Content = "Otomatis farm mob sesuai level (CheckQuest).",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmLevel = s
        Flags.AutoFarm = s
        notify("Auto Farm Level: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmLevel do
                    pcall(function()
                        CheckQuest()
                        local hrp = GetHRP()
                        local hum = GetHum()
                        if not hrp or not hum or hum.Health <= 0 then task.wait(1) return end

                        if Flags.AutoHaki then AutoHakiCheck() end
                        EquipAllWeapon()

                        -- Cek status quest
                        local hasQuest = false
                        local questDone = false
                        pcall(function()
                            local qb = LocalPlayer.Data.QuestBoard
                            local q = qb:FindFirstChild(NameQuest)
                            if q then
                                hasQuest = true
                                -- Cek apakah quest sudah selesai (count >= required)
                                local count = q:FindFirstChild("Count")
                                local required = q:FindFirstChild("Requirement") or q:FindFirstChild("Required")
                                if count and required and count.Value >= required.Value then
                                    questDone = true
                                end
                            end
                        end)

                        -- Drop quest kalau sudah selesai, lalu balik ke quest giver
                        if questDone then
                            pcall(function() CommF_:InvokeServer("dropQuest", NameQuest) end)
                            task.wait(0.3)
                            hasQuest = false
                        end

                        -- Ambil quest kalau belum punya
                        if not hasQuest and CFrameQuest and NameQuest then
                            topos(CFrameQuest)
                            task.wait(0.5)
                            pcall(function()
                                CommF_:InvokeServer("acceptQuest", NameQuest, LevelQuest)
                            end)
                            task.wait(0.3)
                        end

                        -- Farm mob — selalu pakai tween
                        if NameMon and CFrameMon then
                            local mob = FindMobByName(NameMon)
                            if mob and mob:FindFirstChild("HumanoidRootPart") then
                                -- Tween ke 25 stud di atas mob
                                TweenToMob(mob)
                                task.wait(0.15)
                                AttackNoCoolDown()
                            else
                                -- Mob belum spawn, tween ke area spawn mob
                                topos(CFrameMon)
                                task.wait(0.5)
                            end
                        end
                    end)
                    task.wait(0.05)
                end
                Flags.AutoFarm = false
            end)
        end
    end
})
AutoFarmSection:AddToggle({
    Title = "Auto Farm Nearest",
    Content = "Farm musuh terdekat secara otomatis.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmNearest = s
        notify("Auto Farm Nearest: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmNearest do
                    pcall(function()
                        if Flags.AutoHaki then AutoHakiCheck() end
                        EquipAllWeapon()
                        local mob = FindNearestMob()
                        if mob and mob:FindFirstChild("HumanoidRootPart") then
                            TweenToMob(mob)
                            task.wait(0.1)
                            AttackNoCoolDown()
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end
})

local ValentineSection = Tabs.Main:AddSection("StreeHub | Valentine Event")
ValentineSection:AddToggle({
    Title = "Auto Farm Hearts",
    Content = "Farm hearts for Valentine event.",
    Default = false,
    Callback = function(s) Flags.AutoFarmHearts = s; notify("Auto Farm Hearts: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddParagraph({ Title = "Hearts", Content = "0", Icon = "heart" })
ValentineSection:AddParagraph({ Title = "Cupid Quest", Content = "-", Icon = "info" })
ValentineSection:AddToggle({
    Title = "Auto Cupid Quest",
    Content = "Automatically complete Cupid Quest.",
    Default = false,
    Callback = function(s) Flags.AutoCupidQuest = s; notify("Auto Cupid Quest: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddToggle({
    Title = "Auto Delivery Quest",
    Content = "Automatically complete Delivery Quest.",
    Default = false,
    Callback = function(s) Flags.AutoDeliveryQuest = s; notify("Auto Delivery Quest: " .. (s and "ON" or "OFF")) end
})
ValentineSection:AddDivider()
ValentineSection:AddDropdown({
    Title = "Valentine Shop",
    Content = "Select Valentine Event Item.",
    Options = {},
    Default = nil,
    Callback = function(v) Settings.ValentineItem = v end
})
ValentineSection:AddButton({
    Title = "Refresh Shop",
    Callback = function() notify("Refreshing shop...") end
})
ValentineSection:AddParagraph({ Title = "Item Price", Content = "-", Icon = "tag" })
ValentineSection:AddButton({
    Title = "Buy Item",
    Callback = function()
        if Settings.ValentineItem then
            pcall(function() CommF_:InvokeServer("BuyValentineItem", Settings.ValentineItem) end)
            notify("Buying: " .. tostring(Settings.ValentineItem))
        else
            notify("Select an item first.")
        end
    end
})
ValentineSection:AddToggle({
    Title = "Auto Valentines Gacha",
    Content = "Automatically spin Valentines Gacha.",
    Default = false,
    Callback = function(s)
        Flags.AutoVGacha = s
        notify("Auto Valentines Gacha: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoVGacha do
                    pcall(function() CommF_:InvokeServer("ValentineGacha") end)
                    task.wait(2)
                end
            end)
        end
    end
})

local MasterySection = Tabs.Main:AddSection("StreeHub | Mastery Farm")
MasterySection:AddDropdown({
    Title = "Choose Method",
    Content = "Select mastery farming method.",
    Options = { "Mob", "Sea Beast", "Player" },
    Default = "Mob",
    Callback = function(v) Settings.SelectedMethod = v end
})
MasterySection:AddToggle({
    Title = "Auto Fruit Mastery",
    Content = "Automatically farm Devil Fruit mastery.",
    Default = false,
    Callback = function(s) Flags.AutoFruitMastery = s; notify("Auto Fruit Mastery: " .. (s and "ON" or "OFF")) end
})
MasterySection:AddToggle({
    Title = "Auto Gun Mastery",
    Content = "Automatically farm Gun mastery.",
    Default = false,
    Callback = function(s) Flags.AutoGunMastery = s; notify("Auto Gun Mastery: " .. (s and "ON" or "OFF")) end
})
MasterySection:AddDropdown({
    Title = "Choose Sword",
    Content = "Select sword for mastery farming.",
    Options = { "Katana", "Dual Katana", "Triple Katana", "Bisento", "Saber", "Yama", "Tushita", "CDK" },
    Default = "Katana",
    Callback = function(v) Settings.SelectedSword = v end
})
MasterySection:AddToggle({
    Title = "Auto Sword Mastery",
    Content = "Automatically farm Sword mastery.",
    Default = false,
    Callback = function(s) Flags.AutoSwordMastery = s; notify("Auto Sword Mastery: " .. (s and "ON" or "OFF")) end
})

local TyrantSection = Tabs.Main:AddSection("StreeHub | Tyrant Of The Skies")
TyrantSection:AddParagraph({ Title = "Eyes", Content = "0", Icon = "eye" })
TyrantSection:AddToggle({
    Title = "Auto Boss",
    Content = "Automatically fight Tyrant of the Skies boss.",
    Default = false,
    Callback = function(s) Flags.AutoBoss = s; notify("Auto Boss: " .. (s and "ON" or "OFF")) end
})

local MonFarmSection = Tabs.Main:AddSection("StreeHub | Mon Farm")
MonFarmSection:AddDropdown({
    Title = "Choose Mon",
    Content = "Select a Mon to farm.",
    Options = { "Musketeer", "Imp", "Zombie", "Balloon Pirate", "Pirate", "Swordsman", "Fishman Warrior", "Fishman Commando" },
    Default = "Musketeer",
    Callback = function(v) Settings.SelectedMon = v end
})
MonFarmSection:AddToggle({
    Title = "Auto Farm Mon",
    Content = "Automatically farm selected Mon.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmMon = s
        notify("Auto Farm Mon: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmMon do
                    local mob = FindMobByName(Settings.SelectedMon)
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local BerrySection = Tabs.Main:AddSection("StreeHub | Berry")
BerrySection:AddToggle({
    Title = "Auto Collect Berry",
    Content = "Automatically collect berries on the ground.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectBerry = s
        notify("Auto Collect Berry: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoCollectBerry do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if (v.Name == "Money" or v.Name == "Berry" or v.Name:find("Berry")) and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            break
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local BossFarmSection = Tabs.Main:AddSection("StreeHub | Boss Farm")
BossFarmSection:AddParagraph({ Title = "Boss Status", Content = "-", Icon = "shield" })
BossFarmSection:AddDropdown({
    Title = "Choose Boss",
    Content = "Select boss to farm.",
    Options = { "Gorilla King", "Bobby", "Yeti", "Mob Leader", "Snow Lurker", "Franky", "Fishman Lord", "Wysper", "Thunder God", "Drip Mama", "Fajita", "Don Swan", "Smoke Admiral", "Magma Admiral", "Cursed Captain", "Order", "Stone", "Island Empress", "Pharaoh", "Boss Chief", "Longma", "Jack", "Apoo", "Queen", "King" },
    Default = "Gorilla King",
    Callback = function(v) Settings.SelectedBoss = v end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm Boss",
    Content = "Automatically farm selected boss.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmBoss = s
        notify("Auto Farm Boss: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmBoss do
                    local hum = GetHum()
                    if hum and hum.Health < hum.MaxHealth * 0.2 then task.wait(2) end
                    local mob = FindMobByName(Settings.SelectedBoss)
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
BossFarmSection:AddToggle({
    Title = "Auto Farm All Boss",
    Content = "Automatically cycle through all bosses.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmAllBoss = s
        notify("Auto Farm All Boss: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmAllBoss do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local EliteSection = Tabs.Main:AddSection("StreeHub | Elite Hunter")
EliteSection:AddParagraph({ Title = "Elite Hunter Status", Content = "-", Icon = "user-check" })
EliteSection:AddParagraph({ Title = "Elite Hunter Progress", Content = "-", Icon = "bar-chart-2" })
EliteSection:AddToggle({
    Title = "Auto Elite Hunter",
    Content = "Automatically complete Elite Hunter quests.",
    Default = false,
    Callback = function(s)
        Flags.AutoEliteHunter = s
        notify("Auto Elite Hunter: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoEliteHunter do
                    pcall(function() CommF_:InvokeServer("EliteHunterQuest") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
EliteSection:AddToggle({
    Title = "Auto Elite Hunter Hop",
    Content = "Server hop for Elite Hunter.",
    Default = false,
    Callback = function(s)
        Flags.AutoEliteHunterHop = s
        if s then ServerHop() end
    end
})

local BoneSection = Tabs.Main:AddSection("StreeHub | Bone Farm")
BoneSection:AddDropdown({
    Title = "Choose Method",
    Content = "Select bone farming method.",
    Options = { "Cursed Captain", "Mob", "Boss" },
    Default = "Cursed Captain",
    Callback = function(v) Settings.BoneMethod = v end
})
BoneSection:AddParagraph({ Title = "Bones Owned", Content = "0", Icon = "box" })
BoneSection:AddToggle({
    Title = "Auto Farm Bone",
    Content = "Automatically farm bones.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmBone = s
        notify("Auto Farm Bone: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmBone do
                    local mobName = Settings.BoneMethod == "Cursed Captain" and "Cursed Captain" or Settings.SelectedBoss
                    local mob = FindMobByName(mobName) or FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
BoneSection:AddToggle({
    Title = "Auto Random Surprise",
    Content = "Automatically use Random Surprise Balls.",
    Default = false,
    Callback = function(s)
        Flags.AutoRandomSurprise = s
        notify("Auto Random Surprise: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoRandomSurprise do
                    pcall(function() CommF_:InvokeServer("UseSurpriseBall") end)
                    task.wait(2)
                end
            end)
        end
    end
})

local PirateRaidSection = Tabs.Main:AddSection("StreeHub | Pirate Raid")
PirateRaidSection:AddToggle({
    Title = "Auto Pirate Raid",
    Content = "Automatically complete Pirate Raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoPirateRaid = s
        notify("Auto Pirate Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoPirateRaid do
                    pcall(function() CommF_:InvokeServer("PirateRaid") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local ChestSection = Tabs.Main:AddSection("StreeHub | Chest Farm")
ChestSection:AddToggle({
    Title = "Auto Farm Chest Tween",
    Content = "Tween to chests and open automatically.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmChestTween = s
        notify("Auto Farm Chest Tween: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmChestTween do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name:find("Chest") and v:IsA("BasePart") then
                            local hrp = GetHRP()
                            if hrp then SafeTween(hrp, v.Position, Settings.TweenSpeed) end
                            pcall(function() CommF_:InvokeServer("OpenChest", v) end)
                            break
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
ChestSection:AddToggle({
    Title = "Auto Farm Chest Instant",
    Content = "Teleport to chests instantly.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmChestInst = s
        notify("Auto Farm Chest Instant: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmChestInst do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name:find("Chest") and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            pcall(function() CommF_:InvokeServer("OpenChest", v) end)
                            break
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
ChestSection:AddToggle({
    Title = "Auto Stop Items",
    Content = "Stop picking up items while farming.",
    Default = false,
    Callback = function(s) Flags.AutoStopItems = s end
})

local CakeSection = Tabs.Main:AddSection("StreeHub | Cake Prince")
CakeSection:AddParagraph({ Title = "Cake Prince Status", Content = "-", Icon = "crown" })
CakeSection:AddToggle({
    Title = "Auto Katakuri",
    Content = "Automatically fight Katakuri.",
    Default = false,
    Callback = function(s)
        Flags.AutoKatakuri = s
        notify("Auto Katakuri: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoKatakuri do
                    local mob = FindMobByName("Katakuri")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Spawn Cake Prince",
    Content = "Automatically spawn Cake Prince.",
    Default = false,
    Callback = function(s)
        Flags.AutoSpawnCakePrince = s
        notify("Auto Spawn Cake Prince: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoSpawnCakePrince do
                    pcall(function() CommF_:InvokeServer("SpawnCakePrince") end)
                    task.wait(3)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Kill Cake Prince",
    Content = "Automatically kill Cake Prince.",
    Default = false,
    Callback = function(s)
        Flags.AutoKillCakePrince = s
        notify("Auto Kill Cake Prince: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoKillCakePrince do
                    local mob = FindMobByName("Cake Prince")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
CakeSection:AddToggle({
    Title = "Auto Kill Dough King",
    Content = "Automatically kill Dough King.",
    Default = false,
    Callback = function(s)
        Flags.AutoKillDoughKing = s
        notify("Auto Kill Dough King: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoKillDoughKing do
                    local mob = FindMobByName("Dough King")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local MaterialSection = Tabs.Main:AddSection("StreeHub | Materials")
MaterialSection:AddDropdown({
    Title = "Choose Material",
    Content = "Select material to farm.",
    Options = { "Magma Ore", "Dragon Scale", "Fish Tail", "Mystic Droplet", "Scrap Metal", "Leather", "Meteorite", "Radioactive Material", "Demonic Wisp", "Vampire Fang", "Conjured Cocoa", "Wool", "Gunpowder", "Mini Tusk" },
    Default = "Magma Ore",
    Callback = function(v) Settings.SelectedMaterial = v end
})
MaterialSection:AddToggle({
    Title = "Auto Farm Material",
    Content = "Automatically farm selected material.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmMaterial = s
        notify("Auto Farm Material: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoFarmMaterial do
                    pcall(function()
                        MaterialMon()
                        if Flags.AutoHaki then AutoHakiCheck() end
                        EquipAllWeapon()
                        local hrp = GetHRP()
                        if not hrp then return end

                        if MMon and MPos then
                            local mob = nil
                            for _, name in ipairs(MMon) do
                                mob = FindMobByName(name)
                                if mob then break end
                            end
                            if mob and mob:FindFirstChild("HumanoidRootPart") then
                                TweenToMob(mob)
                                task.wait(0.1)
                                AttackNoCoolDown()
                            else
                                topos(MPos)
                                task.wait(0.3)
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end
})

local SettingsMainSection = Tabs.Main:AddSection("StreeHub | Settings")
SettingsMainSection:AddToggle({
    Title = "Spin Position",
    Content = "Spin around target instead of teleporting directly.",
    Default = false,
    Callback = function(s) Flags.SpinPosition = s end
})
SettingsMainSection:AddSlider({
    Title = "Farm Distance",
    Content = "Distance to maintain from enemy.",
    Min = 5, Max = 60, Increment = 1, Default = 15,
    Callback = function(v) Settings.FarmDistance = v end
})
SettingsMainSection:AddSlider({
    Title = "Player Tween Speed",
    Content = "Speed for tween movement.",
    Min = 10, Max = 250, Increment = 5, Default = 30,
    Callback = function(v) Settings.TweenSpeed = v end
})
SettingsMainSection:AddToggle({
    Title = "Bring Mob",
    Content = "Pull mobs to your position.",
    Default = false,
    Callback = function(s) Flags.BringMob = s end
})
SettingsMainSection:AddDropdown({
    Title = "Bring Mob",
    Content = "Which mobs to bring.",
    Options = { "All", "Quest Mob", "Selected Mob" },
    Default = "All",
    Callback = function(v) Settings.SelectedBringMob = v end
})
SettingsMainSection:AddToggle({
    Title = "Attack Aura",
    Content = "Use attack skills continuously.",
    Default = false,
    Callback = function(s)
        Flags.AttackAura = s
        if s then
            task.spawn(function()
                while Flags.AttackAura do
                    local mob = FindNearestMob()
                    if mob then UseSkill(Settings.SelectedFruitSkill or "Z") end
                    task.wait(0.3)
                end
            end)
        end
    end
})

local GraphicSection = Tabs.Main:AddSection("StreeHub | Graphic")
GraphicSection:AddToggle({
    Title = "Hide Notification",
    Content = "Hide in-game kill notifications.",
    Default = false,
    Callback = function(s)
        Flags.HideNotif = s
        pcall(function()
            local gui = LocalPlayer.PlayerGui:FindFirstChild("NotificationUI")
            if gui then gui.Enabled = not s end
        end)
    end
})
GraphicSection:AddToggle({
    Title = "Hide Damage Text",
    Content = "Hide floating damage numbers.",
    Default = false,
    Callback = function(s) Flags.HideDamage = s end
})
GraphicSection:AddToggle({
    Title = "Black Screen",
    Content = "Black screen for performance.",
    Default = false,
    Callback = function(s)
        Flags.BlackScreen = s
        pcall(function()
            local cam = Workspace.CurrentCamera
            if s then
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = CFrame.new(0, -99999, 0)
            else
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
    end
})
GraphicSection:AddToggle({
    Title = "White Screen",
    Content = "White screen for performance.",
    Default = false,
    Callback = function(s)
        Flags.WhiteScreen = s
        pcall(function()
            Lighting.Ambient = s and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70)
            Lighting.Brightness = s and 10 or 2
        end)
    end
})

local MasterySettSection = Tabs.Main:AddSection("StreeHub | Mastery")
MasterySettSection:AddSlider({
    Title = "Mastery Health %",
    Content = "Minimum health % before retreating.",
    Min = 5, Max = 80, Increment = 5, Default = 20,
    Callback = function(v) Settings.MasteryHealth = v end
})

local FruitSkillSection = Tabs.Main:AddSection("StreeHub | Devil Fruit Skill")
FruitSkillSection:AddDropdown({
    Title = "Choose Fruit Skill",
    Content = "Fruit skill key for auto farm.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) Settings.SelectedFruitSkill = v end
})

local GunSkillSection = Tabs.Main:AddSection("StreeHub | Gun Skill")
GunSkillSection:AddDropdown({
    Title = "Choose Gun Skill",
    Content = "Gun skill key for auto farm.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) Settings.SelectedGunSkill = v end
})

local OthersMainSection = Tabs.Main:AddSection("StreeHub | Others")
OthersMainSection:AddToggle({
    Title = "Auto Set Spawn Point",
    Content = "Set spawn point at current location.",
    Default = false,
    Callback = function(s)
        Flags.AutoSetSpawn = s
        if s then pcall(function() CommF_:InvokeServer("SetSpawnPoint") end) end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Observation",
    Content = "Automatically enable Observation Haki.",
    Default = false,
    Callback = function(s)
        Flags.AutoObservation = s
        if s then
            task.spawn(function()
                while Flags.AutoObservation do
                    pcall(function() CommF_:InvokeServer("UseObservation") end)
                    task.wait(10)
                end
            end)
        end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Haki",
    Content = "Automatically enable Buso Haki.",
    Default = false,
    Callback = function(s)
        Flags.AutoHaki = s
        if s then
            task.spawn(function()
                while Flags.AutoHaki do
                    pcall(function() CommF_:InvokeServer("UseHaki") end)
                    task.wait(10)
                end
            end)
        end
    end
})
OthersMainSection:AddToggle({
    Title = "Auto Rejoin",
    Content = "Rejoin when character dies.",
    Default = false,
    Callback = function(s)
        Flags.AutoRejoin = s
        if s then
            local hum = GetHum()
            if hum then
                hum.Died:Connect(function()
                    task.wait(3)
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end
        end
    end
})

local SeaEventOthersSection = Tabs.Others:AddSection("StreeHub | Sea Event")
SeaEventOthersSection:AddToggle({
    Title = "Lightning",
    Content = "Auto use ability during sea events.",
    Default = false,
    Callback = function(s)
        Flags.Lightning = s
        if s then
            task.spawn(function()
                while Flags.Lightning do
                    UseSkill(Settings.SeaEventFruit)
                    task.wait(0.5)
                end
            end)
        end
    end
})
SeaEventOthersSection:AddDropdown({
    Title = "Tools",
    Content = "Tool to use during sea events.",
    Options = { "Pipe", "Bazooka", "Flintlock", "Cannon", "Flower Minigame" },
    Default = "Pipe",
    Callback = function(v) Settings.SeaEventTool = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Devil Fruit",
    Content = "Fruit skill for sea events.",
    Options = { "Z", "X", "C", "V", "F" },
    Default = "Z",
    Callback = function(v) Settings.SeaEventFruit = v end
})
SeaEventOthersSection:AddDropdown({
    Title = "Melee",
    Content = "Melee skill for sea events.",
    Options = { "Z", "X", "C", "V" },
    Default = "Z",
    Callback = function(v) Settings.SeaEventMelee = v end
})

local WorldSection = Tabs.Others:AddSection("StreeHub | World")
WorldSection:AddToggle({
    Title = "Auto Second Sea",
    Content = "Farm quests to reach Second Sea.",
    Default = false,
    Callback = function(s)
        Flags.AutoSecondSea = s
        notify("Auto Second Sea: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoSecondSea do
                    pcall(function() CommF_:InvokeServer("GetSecondSea") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
WorldSection:AddToggle({
    Title = "Auto Third Sea",
    Content = "Farm quests to reach Third Sea.",
    Default = false,
    Callback = function(s)
        Flags.AutoThirdSea = s
        notify("Auto Third Sea: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoThirdSea do
                    pcall(function() CommF_:InvokeServer("GetThirdSea") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local FightingStyleSection = Tabs.Others:AddSection("StreeHub | Fighting Style")
local fightingStyles = {
    {n="Auto Super Human",     k="AutoSuperHuman",    s="SuperHuman"},
    {n="Auto Death Step",      k="AutoDeathStep",     s="DeathStep"},
    {n="Auto Sharkman Karate", k="AutoSharkmanKarate",s="SharkmanKarate"},
    {n="Auto Electric Claw",   k="AutoElectricClaw",  s="ElectricClaw"},
    {n="Auto Dragon Talon",    k="AutoDragonTalon",   s="DragonTalon"},
    {n="Auto God Human",       k="AutoGodHuman",      s="GodHuman"},
}
for _, style in ipairs(fightingStyles) do
    FightingStyleSection:AddToggle({
        Title = style.n,
        Content = "Auto obtain " .. style.s .. ".",
        Default = false,
        Callback = function(s)
            Flags[style.k] = s
            if s then
                task.spawn(function()
                    while Flags[style.k] do
                        pcall(function() CommF_:InvokeServer("BuyFightingStyle", style.s) end)
                        task.wait(3)
                    end
                end)
            end
        end
    })
end

local GunSwordSection = Tabs.Others:AddSection("StreeHub | Gun & Sword")
local swordItems = {
    {n="Auto Get Saber",      k="AutoGetSaber",      q="GetSaber"},
    {n="Auto Buddy Sword",    k="AutoBuddySword",    q="BuddySword"},
    {n="Auto Soul Guitar",    k="AutoSoulGuitar",    q="SoulGuitar"},
    {n="Auto Rengoku",        k="AutoRengoku",       q="Rengoku"},
    {n="Auto Hallow Scythe",  k="AutoHallowScythe",  q="HallowScythe"},
    {n="Auto Warden Sword",   k="AutoWardenSword",   q="WardenSword"},
    {n="Auto Get Yama",       k="AutoGetYama",       q="GetYama"},
    {n="Auto Get Yama Hop",   k="AutoGetYamaHop",    q=nil},
    {n="Auto Get Tushita",    k="AutoGetTushita",    q="GetTushita"},
}
for _, item in ipairs(swordItems) do
    GunSwordSection:AddToggle({
        Title = item.n,
        Content = item.n,
        Default = false,
        Callback = function(s)
            Flags[item.k] = s
            if s then
                if item.k == "AutoGetYamaHop" then
                    ServerHop()
                elseif item.q then
                    task.spawn(function()
                        while Flags[item.k] do
                            pcall(function() CommF_:InvokeServer(item.q) end)
                            task.wait(2)
                        end
                    end)
                end
            end
        end
    })
end

local CDKSection = Tabs.Others:AddSection("StreeHub | Cursed Dual Katana")
local cdkItems = {
    {n="Auto Get CDK",               k="AutoGetCDK",          q="GetCDK"},
    {n="Auto Quest CDK [ Yama ]",    k="AutoQuestCDKYama",    q="CDKQuestYama"},
    {n="Auto Quest CDK [ Tushita ]", k="AutoQuestCDKTushita", q="CDKQuestTushita"},
    {n="Auto Dragon Trident",        k="AutoDragonTrident",   q="DragonTrident"},
    {n="Auto Greybeard",             k="AutoGreybeard",       mob="Greybeard"},
    {n="Auto Shark Saw",             k="AutoSharkSaw",        mob="Shark"},
    {n="Auto Pole",                  k="AutoPole",            q="GetPole"},
    {n="Auto Dark Dagger",           k="AutoDarkDagger",      q="GetDarkDagger"},
}
for _, item in ipairs(cdkItems) do
    CDKSection:AddToggle({
        Title = item.n,
        Content = item.n,
        Default = false,
        Callback = function(s)
            Flags[item.k] = s
            if s then
                task.spawn(function()
                    while Flags[item.k] do
                        if item.mob then
                            local mob = FindMobByName(item.mob)
                            if mob then KillMob(mob) end
                        elseif item.q then
                            pcall(function() CommF_:InvokeServer(item.q) end)
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

local StatsSection = Tabs.Stats:AddSection("StreeHub | Stats")
local statMap = {
    {n="Add Melee Stats",       k="AddMeleeStats",   s="Melee"},
    {n="Add Defense Stats",     k="AddDefenseStats", s="Defense"},
    {n="Add Sword Stats",       k="AddSwordStats",   s="Sword"},
    {n="Add Gun Stats",         k="AddGunStats",     s="Gun"},
    {n="Add Devil Fruit Stats", k="AddDFStats",      s="Devil Fruit"},
}
for _, st in ipairs(statMap) do
    StatsSection:AddToggle({
        Title = st.n,
        Content = "Auto distribute points to " .. st.s .. ".",
        Default = false,
        Callback = function(s)
            Flags[st.k] = s
            if s then
                task.spawn(function()
                    while Flags[st.k] do
                        AddStat(st.s)
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end
StatsSection:AddSlider({
    Title = "Point",
    Content = "Points per allocation.",
    Min = 1, Max = 100, Increment = 1, Default = 1,
    Callback = function(v) Settings.StatPoint = v end
})

local RaidSection = Tabs.Raid:AddSection("StreeHub | Raid")
RaidSection:AddParagraph({ Title = "Raid Time", Content = "-", Icon = "clock" })
RaidSection:AddParagraph({ Title = "Island",    Content = "-", Icon = "map-pin" })
RaidSection:AddDropdown({
    Title = "Choose Chip",
    Content = "Select raid chip.",
    Options = { "Smoke", "Magma", "Sand", "Ice", "Light", "Rumble", "String", "Quake", "Dark", "Phoenix", "Flame", "Falcon", "Buddha", "Spider", "Sound", "Blizzard", "Gravity", "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune" },
    Default = "Smoke",
    Callback = function(v) Settings.SelectedChip = v end
})
RaidSection:AddToggle({
    Title = "Auto Raid",
    Content = "Automatically complete raids.",
    Default = false,
    Callback = function(s)
        Flags.AutoRaid = s
        notify("Auto Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoRaid do
                    pcall(function() CommF_:InvokeServer("startRaid", Settings.SelectedChip, false) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
RaidSection:AddToggle({
    Title = "Auto Awaken",
    Content = "Auto awaken devil fruit in raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoAwaken = s
        notify("Auto Awaken: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoAwaken do
                    pcall(function() CommF_:InvokeServer("Awaken") end)
                    task.wait(2)
                end
            end)
        end
    end
})
RaidSection:AddDropdown({
    Title = "Unstore Rarity Fruit",
    Content = "Rarity of fruit to unstore before raid.",
    Options = { "Common - Mythical", "Uncommon - Mythical", "Rare - Mythical", "Legendary - Mythical", "Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) Settings.SelectedUnstoreFruit = v end
})
RaidSection:AddToggle({
    Title = "Auto Unstore Devil Fruit",
    Content = "Unstore devil fruit before raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoUnstoreFruit = s
        if s then
            task.spawn(function()
                while Flags.AutoUnstoreFruit do
                    pcall(function() CommF_:InvokeServer("UnstoreFruit", Settings.SelectedUnstoreFruit) end)
                    task.wait(3)
                end
            end)
        end
    end
})
RaidSection:AddButton({
    Title = "Teleport To Lab",
    Callback = function()
        TeleportTo(Vector3.new(-1384, 128, 4228))
        notify("Teleported to Lab!")
    end
})

local LawRaidSection = Tabs.Raid:AddSection("StreeHub | Law Raid")
LawRaidSection:AddToggle({
    Title = "Auto Law Raid",
    Content = "Automatically complete Law Raid.",
    Default = false,
    Callback = function(s)
        Flags.AutoLawRaid = s
        notify("Auto Law Raid: " .. (s and "ON" or "OFF"))
        if s then
            task.spawn(function()
                while Flags.AutoLawRaid do
                    pcall(function() CommF_:InvokeServer("startLawRaid") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local DungeonSection = Tabs.Raid:AddSection("StreeHub | Dungeon")
DungeonSection:AddButton({
    Title = "Teleport To Dungeon Hub",
    Callback = function()
        TeleportTo(Vector3.new(-5765, 98, -1055))
        notify("Teleported to Dungeon Hub!")
    end
})
DungeonSection:AddToggle({
    Title = "Auto Attack Mon",
    Content = "Attack mobs in dungeon.",
    Default = false,
    Callback = function(s)
        Flags.AutoAttackMon = s
        if s then
            task.spawn(function()
                while Flags.AutoAttackMon do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DungeonSection:AddToggle({
    Title = "Auto Next Floor",
    Content = "Proceed to next dungeon floor.",
    Default = false,
    Callback = function(s)
        Flags.AutoNextFloor = s
        if s then
            task.spawn(function()
                while Flags.AutoNextFloor do
                    pcall(function() CommF_:InvokeServer("NextFloor") end)
                    task.wait(2)
                end
            end)
        end
    end
})
DungeonSection:AddToggle({
    Title = "Auto Return To Hub",
    Content = "Return to hub after dungeon.",
    Default = false,
    Callback = function(s)
        Flags.AutoReturnHub = s
        if s then
            task.spawn(function()
                while Flags.AutoReturnHub do
                    pcall(function() CommF_:InvokeServer("ReturnHub") end)
                    task.wait(3)
                end
            end)
        end
    end
})

local RaceSection = Tabs.Race:AddSection("StreeHub | Race")
RaceSection:AddToggle({
    Title = "Auto Buy Gear",
    Content = "Automatically buy gear for race.",
    Default = false,
    Callback = function(s)
        Flags.AutoBuyGear = s
        if s then
            task.spawn(function()
                while Flags.AutoBuyGear do
                    pcall(function() CommF_:InvokeServer("BuyGear") end)
                    task.wait(5)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Tween To Mirage Island",
    Content = "Tween towards Mirage Island.",
    Default = false,
    Callback = function(s)
        Flags.TweenMirageIsland = s
        if s then
            task.spawn(function()
                while Flags.TweenMirageIsland do
                    local hrp = GetHRP()
                    if hrp then SafeTween(hrp, IslandCoords["Floating Turtle"] or Vector3.new(-12830, 250, -5480), Settings.TweenSpeed) end
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Find Blue Gear",
    Content = "Automatically find and collect blue gear.",
    Default = false,
    Callback = function(s)
        Flags.FindBlueGear = s
        if s then
            task.spawn(function()
                while Flags.FindBlueGear do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if (v.Name == "Blue Gear" or v.Name:find("Gear")) and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.5)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Look Moon & use Ability",
    Content = "Look at moon and use race ability.",
    Default = false,
    Callback = function(s)
        Flags.LookMoon = s
        if s then
            task.spawn(function()
                while Flags.LookMoon do
                    pcall(function()
                        local hrp = GetHRP()
                        if hrp then
                            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(0, 1, 0))
                            CommF_:InvokeServer("UseRaceAbility")
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Auto Train",
    Content = "Train for race progression.",
    Default = false,
    Callback = function(s)
        Flags.AutoTrain = s
        if s then
            task.spawn(function()
                while Flags.AutoTrain do
                    pcall(function() CommF_:InvokeServer("TrainRace") end)
                    task.wait(1)
                end
            end)
        end
    end
})
RaceSection:AddButton({
    Title = "Teleport To Race Door",
    Callback = function()
        TeleportTo(Vector3.new(-6917, 105, -1143))
        notify("Teleported to Race Door!")
    end
})
RaceSection:AddButton({
    Title = "Buy Acient Quest",
    Callback = function()
        pcall(function() CommF_:InvokeServer("BuyAncientQuest") end)
        notify("Buying Ancient Quest...")
    end
})
RaceSection:AddToggle({
    Title = "Auto Trial",
    Content = "Automatically complete race trials.",
    Default = false,
    Callback = function(s)
        Flags.AutoTrial = s
        if s then
            task.spawn(function()
                while Flags.AutoTrial do
                    pcall(function() CommF_:InvokeServer("StartTrial") end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
RaceSection:AddToggle({
    Title = "Auto Kill Player After Trial",
    Content = "Kill players after trial.",
    Default = false,
    Callback = function(s) Flags.AutoKillAfterTrial = s end
})

local CombatSection = Tabs.Combat:AddSection("StreeHub | Combat")
CombatSection:AddParagraph({ Title = "Players In Server", Content = tostring(#Players:GetPlayers()), Icon = "users" })
local playerList = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playerList, p.Name) end
end
local CombatPlayerDropdown = CombatSection:AddDropdown({
    Title = "Choose Player",
    Content = "Select a player to target.",
    Options = playerList,
    Default = playerList[1] or nil,
    Callback = function(v) Settings.SelectedPlayer = v end
})
CombatSection:AddButton({
    Title = "Refresh Player",
    Callback = function()
        local newList = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(newList, p.Name) end
        end
        CombatPlayerDropdown:SetValues(newList, newList[1])
        notify("Player list refreshed!")
    end
})
CombatSection:AddButton({
    Title = "Spectate Player",
    Callback = function()
        if Settings.SelectedPlayer then
            local target = Players:FindFirstChild(Settings.SelectedPlayer)
            if target and target.Character then
                pcall(function()
                    Workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
                end)
                notify("Spectating: " .. Settings.SelectedPlayer)
            end
        else
            notify("Select a player first.")
        end
    end
})
CombatSection:AddButton({
    Title = "Teleport To Player",
    Callback = function()
        if Settings.SelectedPlayer then
            local target = Players:FindFirstChild(Settings.SelectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = GetHRP()
                if hrp then
                    hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    notify("Teleported to " .. Settings.SelectedPlayer)
                end
            end
        else
            notify("Select a player first.")
        end
    end
})

local IslandCombatSection = Tabs.Combat:AddSection("StreeHub | Island")
local islandList = {}
for k, _ in pairs(IslandCoords) do table.insert(islandList, k) end
IslandCombatSection:AddDropdown({
    Title = "Choose Island",
    Content = "Select island to teleport to.",
    Options = islandList,
    Default = "Middle Town",
    Callback = function(v) Settings.SelectedIsland = v end
})
IslandCombatSection:AddButton({
    Title = "Teleport To Island",
    Callback = function()
        if Settings.SelectedIsland and IslandCoords[Settings.SelectedIsland] then
            TeleportTo(IslandCoords[Settings.SelectedIsland])
            notify("Teleported to " .. Settings.SelectedIsland)
        end
    end
})

local NpcCombatSection = Tabs.Combat:AddSection("StreeHub | Npc")
NpcCombatSection:AddDropdown({
    Title = "Choose Npc",
    Content = "Select NPC to teleport to.",
    Options = { "Sword Dealer", "Blox Fruit Dealer", "Fancy Sword Dealer", "Special Gear", "Master of Auras" },
    Default = "Sword Dealer",
    Callback = function(v) Settings.SelectedNpc = v end
})
NpcCombatSection:AddButton({
    Title = "Teleport To Npc",
    Callback = function()
        if Settings.SelectedNpc then
            local found = false
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == Settings.SelectedNpc and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    TeleportTo(v.HumanoidRootPart.Position)
                    notify("Teleported to " .. Settings.SelectedNpc)
                    found = true
                    break
                end
            end
            if not found then notify(Settings.SelectedNpc .. " not found.") end
        end
    end
})

local EspSection = Tabs.Esp:AddSection("StreeHub | ESP")
local espItems = {
    {n="Esp Player",            k="EspPlayer"},
    {n="Esp Chest",             k="EspChest"},
    {n="Esp Devil Fruit",       k="EspFruit"},
    {n="Esp Real Fruit",        k="EspRealFruit"},
    {n="Esp Flower",            k="EspFlower"},
    {n="Esp Island",            k="EspIsland"},
    {n="Esp Npc",               k="EspNpc"},
    {n="Esp Sea Beast",         k="EspSeaBeast"},
    {n="Esp Monster",           k="EspMonster"},
    {n="Esp Mirage Island",     k="EspMirageIsland"},
    {n="Esp Kitsune Island",    k="EspKitsuneIsland"},
    {n="Esp Frozen Dimension",  k="EspFrozen"},
    {n="Esp Prehistoric Island",k="EspPrehistoric"},
    {n="Esp Gear",              k="EspGear"},
}
for _, item in ipairs(espItems) do
    EspSection:AddToggle({
        Title = item.n,
        Content = item.n .. " visibility.",
        Default = false,
        Callback = function(s)
            Flags[item.k] = s
            if not s then ClearEspAll() end
        end
    })
end

local TeleportSection = Tabs.Teleport:AddSection("StreeHub | Teleport")
TeleportSection:AddDropdown({
    Title = "Selected Place",
    Content = "Choose a place to teleport to.",
    Options = islandList,
    Default = "Middle Town",
    Callback = function(v) Settings.SelectedPlace = v end
})
TeleportSection:AddButton({
    Title = "Teleport To Place",
    Callback = function()
        if Settings.SelectedPlace and IslandCoords[Settings.SelectedPlace] then
            TeleportTo(IslandCoords[Settings.SelectedPlace])
            notify("Teleported to " .. Settings.SelectedPlace)
        end
    end
})

local WorldTeleportSection = Tabs.Teleport:AddSection("StreeHub | World")
WorldTeleportSection:AddButton({
    Title = "Teleport To First Sea",
    Callback = function() TeleportTo(IslandCoords["First Sea"]); notify("Teleported to First Sea!") end
})
WorldTeleportSection:AddButton({
    Title = "Teleport To Second Sea",
    Callback = function() TeleportTo(IslandCoords["Second Sea"]); notify("Teleported to Second Sea!") end
})
WorldTeleportSection:AddButton({
    Title = "Teleport To Third Sea",
    Callback = function() TeleportTo(IslandCoords["Third Sea"]); notify("Teleported to Third Sea!") end
})

local IslandTeleportSection = Tabs.Teleport:AddSection("StreeHub | Island")
IslandTeleportSection:AddDropdown({
    Title = "Choose Island",
    Content = "Select island to teleport to.",
    Options = islandList,
    Default = "Middle Town",
    Callback = function(v) Settings.SelectedIsland = v end
})
IslandTeleportSection:AddButton({
    Title = "Teleport To Island",
    Callback = function()
        if Settings.SelectedIsland and IslandCoords[Settings.SelectedIsland] then
            TeleportTo(IslandCoords[Settings.SelectedIsland])
            notify("Teleported to " .. Settings.SelectedIsland)
        end
    end
})

local NpcTeleportSection = Tabs.Teleport:AddSection("StreeHub | Npc")
NpcTeleportSection:AddDropdown({
    Title = "Choose Npc",
    Content = "Select NPC to teleport to.",
    Options = { "Sword Dealer", "Blox Fruit Dealer", "Fancy Sword Dealer", "Special Gear", "Master of Auras" },
    Default = "Sword Dealer",
    Callback = function(v) Settings.SelectedNpc = v end
})
NpcTeleportSection:AddButton({
    Title = "Teleport To Npc",
    Callback = function()
        if Settings.SelectedNpc then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == Settings.SelectedNpc and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    TeleportTo(v.HumanoidRootPart.Position)
                    notify("Teleported to " .. Settings.SelectedNpc)
                    return
                end
            end
            notify(Settings.SelectedNpc .. " not found.")
        end
    end
})

local ShopSection = Tabs.Shop:AddSection("StreeHub | Shop")
ShopSection:AddToggle({
    Title = "Auto Buy Legendary Sword",
    Content = "Buy legendary swords from shop.",
    Default = false,
    Callback = function(s)
        Flags.AutoBuyLegSword = s
        if s then
            task.spawn(function()
                while Flags.AutoBuyLegSword do
                    pcall(function() CommF_:InvokeServer("BuyItem", "Legendary Sword") end)
                    task.wait(5)
                end
            end)
        end
    end
})
ShopSection:AddToggle({
    Title = "Auto Buy Haki Color",
    Content = "Buy Haki color upgrades.",
    Default = false,
    Callback = function(s)
        Flags.AutoBuyHakiColor = s
        if s then
            task.spawn(function()
                while Flags.AutoBuyHakiColor do
                    pcall(function() CommF_:InvokeServer("BuyHakiColor") end)
                    task.wait(5)
                end
            end)
        end
    end
})

local AbilityShopSection = Tabs.Shop:AddSection("StreeHub | Abilities")
for _, ab in ipairs({ "Geppo", "Buso Haki", "Soru", "Observation Haki" }) do
    AbilityShopSection:AddButton({
        Title = "Buy " .. ab,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyAbility", ab) end)
            notify("Buying " .. ab .. "...")
        end
    })
end

local FightStyleShopSection = Tabs.Shop:AddSection("StreeHub | Fighting Style Shop")
for _, fs in ipairs({ "Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "God Human", "Sanguine Art" }) do
    FightStyleShopSection:AddButton({
        Title = "Buy " .. fs,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyFightingStyle", fs) end)
            notify("Buying " .. fs .. "...")
        end
    })
end

local SwordShopSection = Tabs.Shop:AddSection("StreeHub | Sword Shop")
for _, sw in ipairs({ "Cutlass", "Katana", "Iron Mace", "Dual Katana", "Triple Katana", "Pipe", "Dual Headed Blade", "Bisento", "Soul Cane" }) do
    SwordShopSection:AddButton({
        Title = "Buy " .. sw,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyItem", sw) end)
            notify("Buying " .. sw .. "...")
        end
    })
end

local GunShopSection = Tabs.Shop:AddSection("StreeHub | Gun Shop")
for _, gn in ipairs({ "Slingshot", "Musket", "Flintlock", "Refined Flintlock", "Cannon", "Kabucha" }) do
    GunShopSection:AddButton({
        Title = "Buy " .. gn,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyItem", gn) end)
            notify("Buying " .. gn .. "...")
        end
    })
end

local StatResetSection = Tabs.Shop:AddSection("StreeHub | Stats Reset")
StatResetSection:AddButton({
    Title = "Reset Stats",
    Callback = function()
        pcall(function() CommF_:InvokeServer("ResetStats") end)
        notify("Resetting stats...")
    end
})
StatResetSection:AddButton({
    Title = "Random Race",
    Callback = function()
        pcall(function() CommF_:InvokeServer("RandomRace") end)
        notify("Spinning for random race...")
    end
})

local AccessoriesSection = Tabs.Shop:AddSection("StreeHub | Accessories")
for _, ac in ipairs({ "Black Cape", "Swordsman Hat", "Tomoe Ring" }) do
    AccessoriesSection:AddButton({
        Title = "Buy " .. ac,
        Callback = function()
            pcall(function() CommF_:InvokeServer("BuyItem", ac) end)
            notify("Buying " .. ac .. "...")
        end
    })
end

local FruitAutoSection = Tabs.Fruit:AddSection("StreeHub | Auto Fruit")
FruitAutoSection:AddToggle({
    Title = "Auto Random Fruit",
    Content = "Spin for random fruits.",
    Default = false,
    Callback = function(s)
        Flags.AutoRandomFruit = s
        if s then
            task.spawn(function()
                while Flags.AutoRandomFruit do
                    pcall(function() CommF_:InvokeServer("SpinFruit") end)
                    task.wait(2)
                end
            end)
        end
    end
})
FruitAutoSection:AddDropdown({
    Title = "Store Rarity Fruit",
    Content = "Minimum rarity of fruit to store.",
    Options = { "Common - Mythical", "Uncommon - Mythical", "Rare - Mythical", "Legendary - Mythical", "Mythical" },
    Default = "Common - Mythical",
    Callback = function(v) Settings.SelectedStoreFruit = v end
})
FruitAutoSection:AddToggle({
    Title = "Auto Store Fruit",
    Content = "Auto store fruits of selected rarity.",
    Default = false,
    Callback = function(s)
        Flags.AutoStoreFruit = s
        if s then
            task.spawn(function()
                while Flags.AutoStoreFruit do
                    pcall(function() CommF_:InvokeServer("StoreFruit", Settings.SelectedStoreFruit) end)
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Fruit Notification",
    Content = "Notify when a fruit spawns.",
    Default = false,
    Callback = function(s)
        Flags.FruitNotif = s
        if s then
            task.spawn(function()
                local last = nil
                while Flags.FruitNotif do
                    local fruit = FindFruit()
                    if fruit and fruit ~= last then
                        last = fruit
                        notify("Fruit: " .. fruit.Name, 6, Color3.fromRGB(128, 0, 255), "Fruit Alert")
                    end
                    if not fruit then last = nil end
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Teleport To Fruit",
    Content = "Teleport to spawned fruits.",
    Default = false,
    Callback = function(s)
        Flags.TeleportToFruit = s
        if s then
            task.spawn(function()
                while Flags.TeleportToFruit do
                    local fruit = FindFruit()
                    if fruit and fruit:FindFirstChild("Handle") then
                        TeleportTo(fruit.Handle.Position)
                    end
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddToggle({
    Title = "Tween To Fruit",
    Content = "Tween smoothly to spawned fruits.",
    Default = false,
    Callback = function(s)
        Flags.TweenToFruit = s
        if s then
            task.spawn(function()
                while Flags.TweenToFruit do
                    local fruit = FindFruit()
                    if fruit and fruit:FindFirstChild("Handle") then
                        local hrp = GetHRP()
                        if hrp then SafeTween(hrp, fruit.Handle.Position, Settings.TweenSpeed) end
                    end
                    task.wait(3)
                end
            end)
        end
    end
})
FruitAutoSection:AddButton({
    Title = "Grab Fruit",
    Callback = function()
        local fruit = FindFruit()
        if fruit and fruit:FindFirstChild("Handle") then
            TeleportTo(fruit.Handle.Position)
            task.wait(0.3)
            pcall(function() CommF_:InvokeServer("GrabFruit", fruit) end)
            notify("Grabbed " .. fruit.Name)
        else
            notify("No fruit found.")
        end
    end
})

local FruitVisualSection = Tabs.Fruit:AddSection("StreeHub | Visual")
FruitVisualSection:AddButton({
    Title = "Rain Fruit",
    Callback = function()
        task.spawn(function()
            for i = 1, 10 do
                pcall(function() CommF_:InvokeServer("SpawnFruit") end)
                task.wait(0.2)
            end
        end)
        notify("Raining fruits!")
    end
})

local TeamSection = Tabs.Misc:AddSection("StreeHub | Teams")
TeamSection:AddButton({
    Title = "Join Pirates Team",
    Callback = function()
        pcall(function() CommF_:InvokeServer("JoinTeam", "Pirates") end)
        notify("Joined Pirates team!")
    end
})
TeamSection:AddButton({
    Title = "Join Marines Team",
    Callback = function()
        pcall(function() CommF_:InvokeServer("JoinTeam", "Marines") end)
        notify("Joined Marines team!")
    end
})

local CodesSection = Tabs.Misc:AddSection("StreeHub | Codes")
CodesSection:AddButton({
    Title = "Redeem All Codes",
    Callback = function()
        notify("Redeeming codes...")
        local codes = { "Sub2Fer999","Sub2NoobMaster123","Sub2Daigrock","Bluxxy","Enyu_is_Pro","Magicbus","JCWK","StrawHatMaine","Sub2Bignews","CHANDLER","Sub2OfficialNoobie","Starcodeheo","Sub2ibemaine","fudd10","fudd10v2","KITT3N","sub2gamerrobot_exp1","sub2gamerrobot_reset1","TantaiGaming","Axiore","StrawHat" }
        task.spawn(function()
            for _, code in ipairs(codes) do
                pcall(function() CommF_:InvokeServer("REDEEM_CODE", code) end)
                task.wait(0.4)
            end
            notify("All codes done!", 4, Color3.fromRGB(0, 255, 0))
        end)
    end
})

local GraphicsMiscSection = Tabs.Misc:AddSection("StreeHub | Graphics")
GraphicsMiscSection:AddButton({
    Title = "Fps Boost",
    Callback = function()
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        for _, v in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                end
            end)
        end
        notify("FPS Boost enabled!")
    end
})
GraphicsMiscSection:AddButton({
    Title = "Remove Fog",
    Callback = function()
        Lighting.FogEnd = 1e9
        Lighting.FogStart = 1e8
        notify("Fog removed!")
    end
})
GraphicsMiscSection:AddButton({
    Title = "Remove Lava",
    Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if v.Name == "Lava" and v:IsA("BasePart") then
                    v.Transparency = 1
                    v.CanCollide = false
                end
            end)
        end
        notify("Lava removed!")
    end
})

local LocalPlayerSection = Tabs.LocalPlayer:AddSection("StreeHub | Local Player")
LocalPlayerSection:AddToggle({
    Title = "Active Race V3",
    Content = "Activate Race V3 ability.",
    Default = false,
    Callback = function(s)
        Flags.ActiveRaceV3 = s
        if s then
            task.spawn(function()
                while Flags.ActiveRaceV3 do
                    pcall(function() CommF_:InvokeServer("UseRaceV3") end)
                    task.wait(0.5)
                end
            end)
        end
    end
})
LocalPlayerSection:AddToggle({
    Title = "Active Race V4",
    Content = "Activate Race V4 ability.",
    Default = false,
    Callback = function(s)
        Flags.ActiveRaceV4 = s
        if s then
            task.spawn(function()
                while Flags.ActiveRaceV4 do
                    pcall(function() CommF_:InvokeServer("UseRaceV4") end)
                    task.wait(0.5)
                end
            end)
        end
    end
})
LocalPlayerSection:AddToggle({
    Title = "Walk On Water",
    Content = "Walk on water surface.",
    Default = false,
    Callback = function(s)
        Flags.WalkOnWater = s
        if WalkOnWaterConn then WalkOnWaterConn:Disconnect(); WalkOnWaterConn = nil end
        if s then
            WalkOnWaterConn = RunService.Heartbeat:Connect(function()
                if not Flags.WalkOnWater then return end
                local hrp = GetHRP()
                if hrp and hrp.Position.Y < 3 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, 3, hrp.Position.Z)
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                end
            end)
        end
    end
})
LocalPlayerSection:AddToggle({
    Title = "No Clip",
    Content = "Walk through walls.",
    Default = false,
    Callback = function(s)
        Flags.NoClip = s
        if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
        if s then
            NoClipConn = RunService.Stepped:Connect(function()
                if not Flags.NoClip then return end
                local char = GetChar()
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        else
            local char = GetChar()
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = true end
                end
            end
        end
    end
})

local SeaEventSection = Tabs.SeaEvent:AddSection("StreeHub | Sea Event")
SeaEventSection:AddToggle({
    Title = "Lightning",
    Content = "Auto handle lightning sea events.",
    Default = false,
    Callback = function(s)
        Flags.Lightning = s
        if s then
            task.spawn(function()
                while Flags.Lightning do
                    UseSkill(Settings.SeaEventFruit)
                    task.wait(0.5)
                end
            end)
        end
    end
})

local SeaStackEnemiesSection = Tabs.SeaStack:AddSection("StreeHub | Enemies")
local seaEnemies = {
    {n="Auto Farm Shark",            k="AutoFarmShark",      mob="Shark"},
    {n="Auto Farm Piranha",          k="AutoFarmPiranha",    mob="Piranha"},
    {n="Auto Farm Fish Crew Member", k="AutoFarmFishCrew",   mob="Fish Crew Member"},
}
for _, se in ipairs(seaEnemies) do
    SeaStackEnemiesSection:AddToggle({
        Title = se.n,
        Content = se.n,
        Default = false,
        Callback = function(s)
            Flags[se.k] = s
            if s then
                task.spawn(function()
                    while Flags[se.k] do
                        local mob = FindMobByName(se.mob)
                        if mob then KillMob(mob) end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

local BoatSection = Tabs.SeaStack:AddSection("StreeHub | Boat")
local boatEnemies = {
    {n="Auto Farm Ghost Ship",           k="AutoFarmGhostShip",  mob="Ghost Ship"},
    {n="Auto Farm Pirate Brigade",       k="AutoFarmPirateBrig", mob="Pirate Brigade"},
    {n="Auto Farm Pirate Grand Brigade", k="AutoFarmGrandBrig",  mob="Pirate Grand Brigade"},
}
for _, be in ipairs(boatEnemies) do
    BoatSection:AddToggle({
        Title = be.n,
        Content = be.n,
        Default = false,
        Callback = function(s)
            Flags[be.k] = s
            if s then
                task.spawn(function()
                    while Flags[be.k] do
                        local mob = FindMobByName(be.mob)
                        if mob then KillMob(mob) end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

local BossSeaSection = Tabs.SeaStack:AddSection("StreeHub | Boss")
BossSeaSection:AddToggle({
    Title = "Auto Farm Terrorshark",
    Content = "Auto farm Terrorshark boss.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmTerror = s
        if s then
            task.spawn(function()
                while Flags.AutoFarmTerror do
                    local mob = FindMobByName("Terrorshark")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
BossSeaSection:AddToggle({
    Title = "Auto Farm Seabeasts",
    Content = "Auto farm Seabeasts.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmSeabeast = s
        if s then
            task.spawn(function()
                while Flags.AutoFarmSeabeast do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if (v.Name:find("Sea Beast") or v.Name:find("SeaBeast")) and v:IsA("Model") then
                            KillMob(v)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local SailBoatSection = Tabs.SeaStack:AddSection("StreeHub | Sail Boat")
SailBoatSection:AddDropdown({
    Title = "Choose Boat",
    Content = "Select boat type.",
    Options = { "Raft", "Dinghy", "Caravel", "Galleon" },
    Default = "Galleon",
    Callback = function(v) Settings.SelectedBoat = v end
})
SailBoatSection:AddDropdown({
    Title = "Choose Zone",
    Content = "Select zone for sailing.",
    Options = { "First Sea", "Second Sea", "Third Sea" },
    Default = "First Sea",
    Callback = function(v) Settings.SelectedZone = v end
})
SailBoatSection:AddSlider({
    Title = "Boat Tween Speed",
    Content = "Boat movement speed.",
    Min = 20, Max = 200, Increment = 10, Default = 50,
    Callback = function(v) Settings.BoatSpeed = v end
})
SailBoatSection:AddButton({
    Title = "Sail Boat",
    Callback = function()
        pcall(function() CommF_:InvokeServer("SpawnBoat", Settings.SelectedBoat) end)
        notify("Sailing with " .. Settings.SelectedBoat)
    end
})
SailBoatSection:AddToggle({
    Title = "Auto Attack Seabeasts",
    Content = "Attack seabeasts while sailing.",
    Default = false,
    Callback = function(s)
        Flags.AutoAttackSeabeast = s
        if s then
            task.spawn(function()
                while Flags.AutoAttackSeabeast do
                    local hrp = GetHRP()
                    if hrp then
                        for _, v in pairs(Workspace:GetDescendants()) do
                            if (v.Name:find("Sea Beast") or v.Name:find("SeaBeast")) and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                                if (hrp.Position - v.HumanoidRootPart.Position).Magnitude < 300 then
                                    KillMob(v)
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local BeltSection = Tabs.DragonDojo:AddSection("StreeHub | Belt")
BeltSection:AddToggle({
    Title = "Auto Dojo Trainer",
    Content = "Auto train at Dragon Dojo.",
    Default = false,
    Callback = function(s)
        Flags.AutoDojoBelt = s
        if s then
            task.spawn(function()
                while Flags.AutoDojoBelt do
                    pcall(function() CommF_:InvokeServer("DojoTrain") end)
                    local mob = FindMobByName("Dojo Trainer") or FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local VolcanicSection = Tabs.DragonDojo:AddSection("StreeHub | Volcanic Magnet")
VolcanicSection:AddToggle({
    Title = "Auto Farm Blaze Ember",
    Content = "Farm Blaze Ember from volcano.",
    Default = false,
    Callback = function(s)
        Flags.AutoFarmBlazeEmber = s
        if s then
            task.spawn(function()
                while Flags.AutoFarmBlazeEmber do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "Blaze Ember" and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.1)
                            pcall(function() CommF_:InvokeServer("CollectEmber", v) end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
VolcanicSection:AddButton({
    Title = "Craft Volcanic Magnet",
    Callback = function()
        pcall(function() CommF_:InvokeServer("CraftItem", "Volcanic Magnet") end)
        notify("Crafting Volcanic Magnet...")
    end
})

local DracoSection = Tabs.DragonDojo:AddSection("StreeHub | Draco Trial")
DracoSection:AddButton({
    Title = "Upgrade Draco Trial",
    Callback = function()
        pcall(function() CommF_:InvokeServer("UpgradeDracoTrial") end)
        notify("Upgrading Draco Trial...")
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V1",
    Content = "Complete Draco V1.",
    Default = false,
    Callback = function(s)
        Flags.AutoDracoV1 = s
        if s then
            task.spawn(function()
                while Flags.AutoDracoV1 do
                    pcall(function() CommF_:InvokeServer("StartDracoTrial", 1) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V2",
    Content = "Complete Draco V2.",
    Default = false,
    Callback = function(s)
        Flags.AutoDracoV2 = s
        if s then
            task.spawn(function()
                while Flags.AutoDracoV2 do
                    pcall(function() CommF_:InvokeServer("StartDracoTrial", 2) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DracoSection:AddToggle({
    Title = "Auto Draco V3",
    Content = "Complete Draco V3.",
    Default = false,
    Callback = function(s)
        Flags.AutoDracoV3 = s
        if s then
            task.spawn(function()
                while Flags.AutoDracoV3 do
                    pcall(function() CommF_:InvokeServer("StartDracoTrial", 3) end)
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
DracoSection:AddButton({
    Title = "Teleport To Draco Trials",
    Callback = function()
        TeleportTo(Vector3.new(-12830, 250, -5480))
        notify("Teleported to Draco Trials!")
    end
})
DracoSection:AddToggle({
    Title = "Swap Draco Race",
    Content = "Swap to Draco race.",
    Default = false,
    Callback = function(s)
        Flags.SwapDraco = s
        if s then pcall(function() CommF_:InvokeServer("SwapRace", "Draco") end) end
    end
})
DracoSection:AddButton({
    Title = "Upgrade Dragon Talon",
    Callback = function()
        pcall(function() CommF_:InvokeServer("UpgradeDragonTalon") end)
        notify("Upgrading Dragon Talon...")
    end
})

local PrehistoricSection = Tabs.Items:AddSection("StreeHub | Prehistoric")
PrehistoricSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "info" })
PrehistoricSection:AddToggle({
    Title = "Auto Prehistoric Island",
    Content = "Auto complete Prehistoric Island.",
    Default = false,
    Callback = function(s)
        Flags.AutoPrehistoric = s
        if s then
            task.spawn(function()
                while Flags.AutoPrehistoric do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Kill Lava Golem",
    Content = "Auto kill Lava Golem.",
    Default = false,
    Callback = function(s)
        Flags.AutoKillLava = s
        if s then
            task.spawn(function()
                while Flags.AutoKillLava do
                    local mob = FindMobByName("Lava Golem")
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Collect Bone",
    Content = "Auto collect bones.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectBone = s
        if s then
            task.spawn(function()
                while Flags.AutoCollectBone do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "Bone" and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.05)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Collect Egg",
    Content = "Auto collect eggs.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectEgg = s
        if s then
            task.spawn(function()
                while Flags.AutoCollectEgg do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name:find("Egg") and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.05)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
PrehistoricSection:AddToggle({
    Title = "Auto Defend Volcano",
    Content = "Auto defend the volcano.",
    Default = false,
    Callback = function(s)
        Flags.AutoDefendVolcano = s
        if s then
            task.spawn(function()
                while Flags.AutoDefendVolcano do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local FrozenSection = Tabs.Items:AddSection("StreeHub | Frozen Dimension")
FrozenSection:AddParagraph({ Title = "Frozen Status", Content = "-", Icon = "info" })
FrozenSection:AddToggle({
    Title = "Auto Frozen Dimension",
    Content = "Auto complete Frozen Dimension.",
    Default = false,
    Callback = function(s)
        Flags.AutoFrozen = s
        if s then
            task.spawn(function()
                while Flags.AutoFrozen do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
FrozenSection:AddParagraph({ Title = "Leviathan Status", Content = "-", Icon = "info" })
FrozenSection:AddButton({
    Title = "Bribe Leviathan",
    Callback = function()
        pcall(function() CommF_:InvokeServer("BribeLeviathan") end)
        notify("Bribing Leviathan...")
    end
})
FrozenSection:AddToggle({
    Title = "Auto Leviathan",
    Content = "Auto fight Leviathan.",
    Default = false,
    Callback = function(s)
        Flags.AutoLeviathan = s
        if s then
            task.spawn(function()
                while Flags.AutoLeviathan do
                    local mob = FindMobByName("Leviathan")
                    if mob then
                        KillMob(mob)
                    else
                        pcall(function() CommF_:InvokeServer("SummonLeviathan") end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local KitsuneSection = Tabs.Items:AddSection("StreeHub | Kitsune Island")
KitsuneSection:AddParagraph({ Title = "Kitsune Status", Content = "-", Icon = "info" })
KitsuneSection:AddToggle({
    Title = "Auto Kitsune Island",
    Content = "Auto complete Kitsune Island.",
    Default = false,
    Callback = function(s)
        Flags.AutoKitsuneIsland = s
        if s then
            task.spawn(function()
                while Flags.AutoKitsuneIsland do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})
KitsuneSection:AddToggle({
    Title = "Auto Collect Azure Ember",
    Content = "Auto collect Azure Ember.",
    Default = false,
    Callback = function(s)
        Flags.AutoCollectAzure = s
        if s then
            task.spawn(function()
                while Flags.AutoCollectAzure do
                    for _, v in pairs(Workspace:GetDescendants()) do
                        if v.Name == "Azure Ember" and v:IsA("BasePart") then
                            TeleportTo(v.Position)
                            task.wait(0.1)
                            pcall(function() CommF_:InvokeServer("CollectAzureEmber", v) end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
KitsuneSection:AddPanel({
    Title = "Azure Ember",
    Placeholder = "Amount (e.g. 50)",
    ButtonText = "Set Azure Ember",
    ButtonCallback = function(v)
        Settings.AzureEmberAmount = tonumber(v) or 0
        notify("Azure Ember set: " .. tostring(Settings.AzureEmberAmount))
    end
})
KitsuneSection:AddToggle({
    Title = "Auto Trade Azure Ember",
    Content = "Auto trade Azure Ember.",
    Default = false,
    Callback = function(s)
        Flags.AutoTradeAzure = s
        if s then
            task.spawn(function()
                while Flags.AutoTradeAzure do
                    pcall(function() CommF_:InvokeServer("TradeAzureEmber", Settings.AzureEmberAmount) end)
                    task.wait(3)
                end
            end)
        end
    end
})

local MirageSection = Tabs.Items:AddSection("StreeHub | Mirage Island")
MirageSection:AddParagraph({ Title = "Mirage Status", Content = "-", Icon = "info" })
MirageSection:AddToggle({
    Title = "Auto Mirage Island",
    Content = "Auto complete Mirage Island.",
    Default = false,
    Callback = function(s)
        Flags.AutoMirageIsland = s
        if s then
            task.spawn(function()
                while Flags.AutoMirageIsland do
                    local mob = FindNearestMob()
                    if mob then KillMob(mob) end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local SettingsTab = Tabs.Settings:AddSection("StreeHub | Settings", true)
SettingsTab:AddToggle({
    Title = "Show Button",
    Content = "Show open/close GUI button.",
    Default = true,
    Callback = function(state)
        notify("Button: " .. (state and "ON" or "OFF"))
    end
})
SettingsTab:AddPanel({
    Title = "UI Color",
    Placeholder = "255,50,50",
    ButtonText = "Apply Color",
    ButtonCallback = function(colorText)
        local r, g, b = colorText:match("(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            notify("Color: RGB(" .. r .. "," .. g .. "," .. b .. ")")
        else
            notify("Format: R,G,B")
        end
    end,
    SubButtonText = "Reset Color",
    SubButtonCallback = function()
        notify("Color reset.")
    end
})
SettingsTab:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:DestroyGui()
    end
})

local ServerSection = Tabs.Server:AddSection("StreeHub | Server")
ServerSection:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        notify("Rejoining...")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})
ServerSection:AddButton({
    Title = "Server Hop",
    Callback = function()
        notify("Finding new server...")
        ServerHop()
    end
})
ServerSection:AddParagraph({ Title = "Job ID", Content = tostring(game.JobId), Icon = "server" })
ServerSection:AddButton({
    Title = "Copy Job ID",
    Callback = function()
        if setclipboard then setclipboard(tostring(game.JobId)) end
        notify("Job ID copied!")
    end
})
ServerSection:AddPanel({
    Title = "Join Specific Server",
    Placeholder = "Enter Job ID...",
    ButtonText = "Join Job ID",
    ButtonCallback = function(jobId)
        if jobId and jobId ~= "" then
            notify("Joining: " .. jobId)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        else
            notify("Enter a valid Job ID.")
        end
    end
})

local StatusServerSection = Tabs.Server:AddSection("StreeHub | Status Server")
StatusServerSection:AddParagraph({ Title = "Moon Server",        Content = "-", Icon = "moon" })
StatusServerSection:AddParagraph({ Title = "Kitsune Status",     Content = "-", Icon = "zap" })
StatusServerSection:AddParagraph({ Title = "Frozen Status",      Content = "-", Icon = "info" })
StatusServerSection:AddParagraph({ Title = "Mirage Status",      Content = "-", Icon = "eye" })
StatusServerSection:AddParagraph({ Title = "Haki Dealer Status", Content = "-", Icon = "user" })
StatusServerSection:AddParagraph({ Title = "Prehistoric Status", Content = "-", Icon = "shield" })

RunService.Heartbeat:Connect(function()
    local anyEsp = Flags.EspPlayer or Flags.EspChest or Flags.EspFruit or Flags.EspRealFruit
        or Flags.EspFlower or Flags.EspIsland or Flags.EspNpc or Flags.EspSeaBeast
        or Flags.EspMonster or Flags.EspGear
    if anyEsp then pcall(UpdateESP) end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Flags.AutoRejoin then
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            task.wait(3)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
    if WalkOnWaterConn then WalkOnWaterConn:Disconnect(); WalkOnWaterConn = nil end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local hrp = GetHRP()
        local hum = GetHum()
        if not hrp or not hum then return end
        if Flags.NoClip then
            for _, v in pairs(GetChar():GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if Flags.WalkOnWater then
            local result = Workspace:Raycast(hrp.Position, Vector3.new(0,-5,0))
            if result and result.Instance and result.Instance.Material == Enum.Material.Water then
                hrp.CFrame = CFrame.new(hrp.Position.X, result.Position.Y+3, hrp.Position.Z)
            end
        end
    end)
end)

notify("StreeHub loaded!", 5, Color3.fromRGB(255, 50, 50), "StreeHub")
