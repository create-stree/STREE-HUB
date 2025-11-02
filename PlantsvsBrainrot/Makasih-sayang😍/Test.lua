local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer

local success,WindUI=pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local NetPkg
local function FindNetPkg()
    local packages=ReplicatedStorage:WaitForChild("Packages",5)
    if packages and packages:FindFirstChild("_Index")then
        for _,v in pairs(packages._Index:GetChildren())do
            if v:FindFirstChild("net")then NetPkg=v.net;break end
        end
    end
    if not NetPkg and ReplicatedStorage:FindFirstChild("Remotes")then
        NetPkg=ReplicatedStorage.Remotes
    end
end
FindNetPkg()

local FireWeaponAttack,FireSimpleRemote
FireWeaponAttack=function(payload)
    local p1=NetPkg and NetPkg:FindFirstChild("AttacksServer")and NetPkg.AttacksServer:FindFirstChild("WeaponAttack")
    local p2=ReplicatedStorage:FindFirstChild("Remotes")and ReplicatedStorage.Remotes:FindFirstChild("AttacksServer")and ReplicatedStorage.Remotes.AttacksServer:FindFirstChild("WeaponAttack")
    if p1 then p1:FireServer(payload)elseif p2 then p2:FireServer(payload)end
end
FireSimpleRemote=function(name,...)
    local r=NetPkg and NetPkg:FindFirstChild(name)
    if not r and ReplicatedStorage:FindFirstChild("Remotes")then r=ReplicatedStorage.Remotes:FindFirstChild(name)end
    if r then r:FireServer(...)end
end

_G.AutoEquipBat=false
_G.AutoFarm=false
_G.AutoEquipBest=false
_G.AutoFollow=false
_G.Delay=1

local Character,Humanoid,HumanoidRootPart
local function SetupCharacter(c)
    Character=c
    Humanoid=c:WaitForChild("Humanoid")
    HumanoidRootPart=c:WaitForChild("HumanoidRootPart")
end
if LocalPlayer.Character then SetupCharacter(LocalPlayer.Character)end
LocalPlayer.CharacterAdded:Connect(SetupCharacter)

local BrainrotsFolder=Workspace:WaitForChild("ScriptedMap"):WaitForChild("Brainrots")
local BrainrotsCache={}

local function UpdateBrainrotsCache()
    BrainrotsCache={}
    for _,b in ipairs(BrainrotsFolder:GetChildren())do
        if b:FindFirstChild("BrainrotHitbox")then table.insert(BrainrotsCache,b)end
    end
end
BrainrotsFolder.ChildAdded:Connect(UpdateBrainrotsCache)
BrainrotsFolder.ChildRemoved:Connect(UpdateBrainrotsCache)
UpdateBrainrotsCache()

local function GetNearestBrainrot()
    if #BrainrotsCache==0 then return nil end
    local n,d=nil,math.huge
    local p=HumanoidRootPart.Position
    for _,b in ipairs(BrainrotsCache)do
        local h=b:FindFirstChild("BrainrotHitbox")
        if h then
            local dist=(p-h.Position).Magnitude
            if dist<d then d=dist;n=b end
        end
    end
    return n
end

local function EquipBat()
    if not Character or not Humanoid then return end
    local bat=Character:FindFirstChild("Basic Bat")or LocalPlayer:WaitForChild("Backpack"):FindFirstChild("Basic Bat")
    if bat and bat.Parent~=Character then Humanoid:EquipTool(bat)end
end

local function FollowBrainrotPath()
    if not _G.AutoFollow or not HumanoidRootPart then return end
    local pathFolder=Workspace:FindFirstChild("ScriptedMap"):FindFirstChild("BrainrotPath")
    if not pathFolder then return end
    local points={}
    for _,p in ipairs(pathFolder:GetChildren())do
        if p:IsA("BasePart")then table.insert(points,p.Position)end
    end
    if #points==0 then return end
    local pos=HumanoidRootPart.Position
    local closest,dist=nil,math.huge
    for _,pt in ipairs(points)do
        local d=(pos-pt).Magnitude
        if d<dist then dist=d;closest=pt end
    end
    if closest and dist>5 then
        Humanoid:MoveTo(closest)
    end
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | Fish It",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(260, 290),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:SetTheme("Dark")
        end,
    },
})

Window:Tag({Title="Version",Color=Color3.fromRGB(0,255,0),Radius=17})
Window:Tag({Title="Dev",Color=Color3.fromRGB(0,0,0),Radius=17})
WindUI:Notify({Title="STREE HUB Loaded",Content="UI loaded successfully!",Duration=3,Icon="bell"})

local Tab1=Window:Tab({Title="Info",Icon="info"})
local Tab2=Window:Tab({Title="Main",Icon="crown"})
local Tab3=Window:Tab({Title="Shop",Icon="shopping-cart"})
local Tab4=Window:Tab({Title="Settings",Icon="settings"})

Window:SelectTab(2)

Tab1:Section({Title="Info",ContentPadding=6})
Tab3:Section({Title="Shop",ContentPadding=6})
Tab4:Section({Title="Settings",ContentPadding=6})

local batThread, farmThread, bestThread, followThread

local function startBat()
    while _G.AutoEquipBat do
        EquipBat()
        task.wait(_G.Delay)
    end
end

local function startFarm()
    while _G.AutoFarm do
        local t=GetNearestBrainrot()
        if t and t:FindFirstChild("BrainrotHitbox")then
            pcall(function()FireWeaponAttack({{target=t.BrainrotHitbox}})end)
        end
        task.wait(_G.Delay)
    end
end

local function startBest()
    while _G.AutoEquipBest do
        pcall(function()FireSimpleRemote("EquipBestBrainrots")end)
        task.wait(_G.Delay)
    end
end

local function startFollow()
    while _G.AutoFollow do
        FollowBrainrotPath()
        task.wait(0.1)
    end
end

Tab2:Toggle({
    Title="Auto Equip Bat",
    Value=false,
    Callback=function(v)
        _G.AutoEquipBat=v
        if v then
            if batThread then task.cancel(batThread)end
            batThread=task.spawn(startBat)
        else
            _G.AutoEquipBat=false
            if batThread then task.cancel(batThread)end
            batThread=nil
        end
    end
})

Tab2:Toggle({
    Title="Auto Farm (Attack)",
    Value=false,
    Callback=function(v)
        _G.AutoFarm=v
        if v then
            if farmThread then task.cancel(farmThread)end
            farmThread=task.spawn(startFarm)
        else
            _G.AutoFarm=false
            if farmThread then task.cancel(farmThread)end
            farmThread=nil
        end
    end
})

Tab2:Toggle({
    Title="Auto Equip Best Brainrot",
    Value=false,
    Callback=function(v)
        _G.AutoEquipBest=v
        if v then
            if bestThread then task.cancel(bestThread)end
            bestThread=task.spawn(startBest)
        else
            _G.AutoEquipBest=false
            if bestThread then task.cancel(bestThread)end
            bestThread=nil
        end
    end
})

Tab2:Toggle({
    Title="Auto Follow Brainrot Path",
    Value=false,
    Callback=function(v)
        _G.AutoFollow=v
        if v then
            if followThread then task.cancel(followThread)end
            followThread=task.spawn(startFollow)
        else
            _G.AutoFollow=false
            if followThread then task.cancel(followThread)end
            followThread=nil
        end
    end
})

Tab2:Slider({
    Title="Delay (seconds)",
    Step=1,
    Value={Min=1,Max=60,Default=1},
    Callback=function(v)_G.Delay=v end
})

RunService.Heartbeat:Connect(function()
    if tick()%2<0.1 then UpdateBrainrotsCache()end
end)
