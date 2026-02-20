local Collection = {}; Collection.__index = Collection

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local flying=false
local bv,bg
local keys={W=false,A=false,S=false,D=false,Space=false,Ctrl=false}
local Joined=false

function Collection:RewriteSynxtaxe(str)
    return string.lower(str or ""):gsub("%s+","")
end

function Collection:InstantTeleportTo(cf)
    local c=LocalPlayer.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame=cf
    end
end

--UI
local Fluent,SaveManager,InterfaceManager=loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()

local Window=Fluent:CreateWindow({
    Title="Forge Hub - Solo Hunter",
    SubTitle="Full Version",
    TitleIcon="rbxassetid://88704482117379",
    Size=UDim2.fromOffset(520,360),
    Acrylic=true,
    Theme="Dark",
    MinimizeKey=Enum.KeyCode.LeftControl
})

-- TABS
local Tabs={
    General=Window:AddTab({Title="Main",Icon="house"}),
    Stats=Window:AddTab({Title="Stats",Icon="bar-chart-2"}),
    Items=Window:AddTab({Title="Items",Icon="sword"}),
    Misc=Window:AddTab({Title="Player",Icon="user"}),
    Settings=Window:AddTab({Title="Settings",Icon="settings"})
}

-- DUNGEON SETUP
local Setup = Tabs.General:AddSection("Dungeon Setup")

Setup:AddDropdown("dungeon",{Title="Dungeon",Values={"Subway","Caves","Desert","Jungle","WolfCave","SpiderCave"}})
:OnChanged(function(v) getgenv().choosendungeon=v end)

Setup:AddDropdown("rank",{Title="Rank",Values={"F","F+","E","E+","D","D+","C","C+","B","B+","A","A+","S","S+","S++"}})
:OnChanged(function(v) getgenv().choosendungeonrank=v end)

local Dungeon = Tabs.General:AddSection("Dungeon")

Dungeon:AddToggle("farm",{Title="Auto Farm Dungeon"})
:OnChanged(function(v) getgenv().autofarmdungeon=v end)

Dungeon:AddToggle("join",{Title="Auto Join"})
:OnChanged(function(v) getgenv().autojoindungeon=v end)

Dungeon:AddToggle("start",{Title="Auto Start"})
:OnChanged(function(v) getgenv().autostartdungeon=v end)

Dungeon:AddToggle("leave",{Title="Auto Leave"})
:OnChanged(function(v) getgenv().autoleavedungeon=v end)

Dungeon:AddToggle("chest",{Title="Auto Open Chest"})
:OnChanged(function(v) getgenv().AutoOpenChest=v end)


-- MONSTER
local Monster = Tabs.General:AddSection("Monster")

Monster:AddToggle("farm",{Title="Auto Farm Monster"})
:OnChanged(function(v) getgenv().AutoFarmMonster=v end)

Monster:AddToggle("fast",{Title="Fast Attack"})
:OnChanged(function(v) getgenv().AutoAttackMonster=v end)

Monster:AddToggle("click",{Title="Click Attack"})
:OnChanged(function(v) getgenv().normalattack=v end)

Monster:AddToggle("aura",{Title="Kill Aura"})
:OnChanged(function(v) getgenv().KillAura=v end)

-- STATS
local Stats = Tabs.Stats:AddSection("Stats")

Stats:AddSlider("points",{Title="Point Amount",Default=1,Min=1,Max=10})
:OnChanged(function(v) getgenv().PointAmount=v end)

Stats:AddDropdown("stat",{Title="Stat",Values={"Magic","Strength","Defense","Agility","Energy"}})
:OnChanged(function(v) getgenv().choosenstats=v end)

Stats:AddToggle("auto",{Title="Auto Stats"})
:OnChanged(function(v) getgenv().autostats=v end)

-- PLAYER
local Player = Tabs.Misc:AddSection("Movement")

Player:AddSlider("speed",{Title="Speed",Default=16,Min=1,Max=300})
:OnChanged(function(v) getgenv().speedchanger=v end)

Player:AddToggle("speedon",{Title="Enable Speed"})
:OnChanged(function(v) getgenv().enablespeed=v end)

Player:AddSlider("jump",{Title="Jump",Default=50,Min=10,Max=300})
:OnChanged(function(v) getgenv().jumppowerchanger=v end)

Player:AddToggle("jumpon",{Title="Enable Jump"})
:OnChanged(function(v) getgenv().enablejumppower=v end)

-- FLY
local Fly = Tabs.Misc:AddSection("Fly")

Fly:AddSlider("flyspd",{Title="Fly Speed",Default=50,Min=10,Max=500})
:OnChanged(function(v) getgenv().FlySpeed=v end)

Fly:AddToggle("fly",{Title="Enable Fly"})
:OnChanged(function(v) getgenv().enablefly=v end)

-- SYSTEM LOOPS
task.spawn(function()
    while task.wait(.2) do
        pcall(function()

            local char=LocalPlayer.Character
            if not char then return end
            local hrp=char:FindFirstChild("HumanoidRootPart")
            local hum=char:FindFirstChildOfClass("Humanoid")

            if getgenv().enablespeed and hum then hum.WalkSpeed=getgenv().speedchanger end
            if getgenv().enablejumppower and hum then hum.JumpPower=getgenv().jumppowerchanger end

            if getgenv().AutoFarmMonster then
                for _,mob in pairs(workspace.Mobs:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") then
                        Collection:InstantTeleportTo(mob.HumanoidRootPart.CFrame)
                    end
                end
            end

            if getgenv().AutoAttackMonster then
                for _,mob in pairs(workspace.Mobs:GetChildren()) do
                    ReplicatedStorage.RemoteServices.CombatService.RF.UseWeapon:InvokeServer(10,{mob},10)
                end
            end

            if getgenv().normalattack then
                VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
                task.wait(.05)
                VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
            end

            if getgenv().KillAura then
                for _,mob in pairs(workspace.Mobs:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") then
                        mob.Humanoid.Health=0
                    end
                end
            end

        end)
    end
end)

-- FLY SYSTEM
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if keys[i.KeyCode.Name]~=nil then keys[i.KeyCode.Name]=true end
end)

UserInputService.InputEnded:Connect(function(i)
    if keys[i.KeyCode.Name]~=nil then keys[i.KeyCode.Name]=false end
end)

RunService.RenderStepped:Connect(function()
    local c=LocalPlayer.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    if getgenv().enablefly and not flying then
        flying=true
        bv=Instance.new("BodyVelocity",c.HumanoidRootPart)
        bv.MaxForce=Vector3.new(1e9,1e9,1e9)
        bg=Instance.new("BodyGyro",c.HumanoidRootPart)
        bg.MaxTorque=Vector3.new(1e9,1e9,1e9)
    end
    if not getgenv().enablefly and flying then
        flying=false
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
    if flying then
        local cam=workspace.CurrentCamera
        local dir=Vector3.zero
        if keys.W then dir+=cam.CFrame.LookVector end
        if keys.S then dir-=cam.CFrame.LookVector end
        if keys.A then dir-=cam.CFrame.RightVector end
        if keys.D then dir+=cam.CFrame.RightVector end
        if keys.Space then dir+=Vector3.new(0,1,0) end
        if keys.LeftControl then dir-=Vector3.new(0,1,0) end
        if dir.Magnitude>0 then dir=dir.Unit*(getgenv().FlySpeed or 50) end
        bv.Velocity=dir
        bg.CFrame=cam.CFrame
    end
end)

Fluent:Notify({
    Title = "Fluent",
    Content = "Example loaded successfully!",
    Duration = 5
})
