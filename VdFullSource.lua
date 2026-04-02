-- VIOLENCE DISTRICT DETECTION (PC + Mobile)
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")

local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local VexoraHub
local UI = {}
local NEX_CrosshairGui, NEX_CrossH, NEX_CrossV = nil, nil, nil

local IsOnMobile = isMobile
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(620, 370)

local ok, result = pcall(require, "./src/Init")
if ok and result then
    VexoraHub = result
else
    VexoraHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/kirsiaball-dev/46GhMjd7/refs/heads/main/ui.lua"))()
end

if isMobile then UI.Mobile = true end
print("[Universal] Platform:", isMobile and "MOBILE" or "PC")


local Window
if VexoraHub then
    Window = VexoraHub:CreateWindow({
        Title          = "Luxv'S Hub - Violence District",
        Icon           = "rbxassetid://75522306265517",
        Author         = "developed by Nex",
        Folder         = "LSHub-Univcs",
        Size           = WindowSize,
        LiveSearchDropdown = true,
        FileSaveName   = "LSHub-Univcs/config.json",
    })
end

-- =====================================================
-- PC CURSOR UNLOCK (ALT key toggle)
-- Hanya aktif di PC, tidak mengganggu mobile
-- =====================================================
if not isMobile then
    local _cursorOn = false
    local _cursorManual = false -- aktif setelah ALT pertama kali ditekan

    local function _setCursor(state)
        _cursorOn = state
        _cursorManual = true
        pcall(function()
            UserInputService.MouseIconEnabled = state
            UserInputService.MouseBehavior = state 
                and Enum.MouseBehavior.Default 
                or Enum.MouseBehavior.LockCenter
        end)
        
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = not state
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        -- ALT selalu aktif tanpa cek gameProcessed agar bisa toggle kapanpun
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            _setCursor(not _cursorOn)
        end
    end)

    -- Paksa cursor state sesuai toggle (ON dan OFF), agar game tidak bisa override
    task.spawn(function()
        while true do
            if _cursorManual then
                pcall(function()
                    if _cursorOn then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.MouseIconEnabled = true
                    else
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                        UserInputService.MouseIconEnabled = false
                    end
                end)
            end
            task.wait(0.1)
        end
    end)

    -- Reset saat respawn
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if _cursorOn then _setCursor(true) end
    end)

    print("[VD] ALT Toggle Cursor Ready (PC only)")
end



-- =====================================================
-- SAFE DRAWING UTILS
-- =====================================================
local DrawingAvailable = (function()
    if isMobile then return false end  -- 
    local ok, result = pcall(function()
        return typeof(Drawing) == "table" and Drawing.new ~= nil
    end)
    return ok and result or false
end)()

local function SafeDrawing(typ)
    if not DrawingAvailable then return nil end
    local ok, res = pcall(function() return Drawing.new(typ) end)
    return ok and res or nil
end

local function SafeRemove(obj)
    if obj and obj.Remove then pcall(function() obj:Remove() end) end
end

local MobileESP = {}

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
local function clamp(v, min, max)
    return math.max(min, math.min(max, v))
end

-- =====================================================
-- CONFIG
-- =====================================================
getgenv().VD = getgenv().VD or {
    -- ESP
    ESP                   = false,
    MaxDistance           = 2000,
    ShowDistance          = false,
    -- Generator / AntiFail / Healing
    GeneratorESP          = false,
    GenAntiFail           = false,
    HealAntiFail          = false,
    -- Visual / UI
    HideSkillUI           = false,
    Fullbright            = false,
    -- Movement
    Speed                 = false,
    SpeedValue            = 16,
    Jump                  = false,
    JumpValue             = 50,
    InfiniteJump          = false,
    Noclip                = false,
    -- Internal
    Destroyed             = false,
    -- Auto features

    AUTO_LeaveGen         = false,
    AUTO_LeaveDist        = 18,
    AUTO_Attack           = false,
    AUTO_AttackRange      = 12,
    HITBOX_Enabled        = false,
    HITBOX_Size           = 15,
    AUTO_TeleAway         = false,
    AUTO_TeleAwayDist     = 40,
    AUTO_Parry            = false,
    AUTO_ParrySensitivity = 30,
    AUTO_ParryRange       = 15,
    AUTO_ParryDelay       = 0.5,
    AUTO_SkillCheck       = false,
    SURV_AutoWiggle       = false,
    -- Killer features
    KILLER_DestroyPallets = false,
    KILLER_FullGenBreak   = false,
    KILLER_NoPalletStun   = false,
    KILLER_AutoHook       = false,
    KILLER_AntiBlind      = false,
    KILLER_NoSlowdown     = false,
    KILLER_DoubleTap      = false,
    KILLER_InfiniteLunge  = false,
    -- Speed
    SPEED_Enabled         = false,
    SPEED_Value           = 32,
    SPEED_Method          = "Attribute",
    -- Visual extras
    NO_Fog                = false,
    CAM_FOVEnabled        = false,
    CAM_FOV               = 90,
    CAM_ThirdPerson       = false,
    CAM_ShiftLock         = false,
    -- Config
    FLING_Enabled         = false,
    FLING_Strength        = 10000,
    -- Beat game
    BEAT_Survivor         = false,
    BEAT_Killer           = false,
    TP_Offset             = 3,
    -- Drawing / Advanced ESP
    DRAWING_ESP           = false,
    ESP_PlayerChams       = false,
    ESP_ObjectChams       = false,
    ESP_Obj_Generator     = false,
    ESP_Obj_Gate          = false,
    ESP_Obj_Hook          = false,
    ESP_Obj_Pallet        = false,
    ESP_Obj_Window        = false,
    ESP_Skeleton          = false,
    ESP_Offscreen         = false,
    ESP_Velocity          = false,
    ESP_ClosestHook       = false,
    -- Radar
    RADAR_Enabled         = false,
    RADAR_Size            = 120,
    RADAR_Circle          = false,
    RADAR_Killer          = true,
    RADAR_Survivor        = true,
    RADAR_Generator       = true,
    RADAR_Pallet          = true,
    -- Aimbot
    AIM_Enabled           = false,
    AIM_Crosshair         = false,
    AIM_UseRMB            = true,
    AIM_FOV               = 120,
    AIM_Smooth            = 0.3,
    AIM_TargetPart        = "Head",
    AIM_VisCheck          = true,
    AIM_ShowFOV           = true,
    AIM_Predict           = true,
    -- Spear aimbot
    SPEAR_Aimbot          = false,
    SPEAR_Gravity         = 50,
    SPEAR_Speed           = 100,
    -- Fly
    FLY_Enabled           = false,
    FLY_Speed             = 50,
    FLY_Method            = "Velocity"
}

local VD = getgenv().VD

-- =====================================================
-- CONFIGURATION SYSTEM (Save & Load)
-- =====================================================
local function GetSafeGuiParent()
    if gethui then return gethui() end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:FindFirstChild("PlayerGui")
end

local VD_ChamsFolder = nil
local function GetSafeChamsFolder()
    local pg = GetSafeGuiParent()
    if not pg then return workspace end
    if VD_ChamsFolder and VD_ChamsFolder.Parent then return VD_ChamsFolder end
    
    local f = pg:FindFirstChild("NEX_WorkspaceChams")
    if not f then
        f = Instance.new("Folder")
        f.Name = "NEX_WorkspaceChams"
        f.Parent = pg
    end
    VD_ChamsFolder = f
    return f
end

local ConfigFolderName = "LSHub_VD_Configs"
local HttpService = game:GetService("HttpService")

if makefolder and isfolder and not isfolder(ConfigFolderName) then
    makefolder(ConfigFolderName)
end

getgenv().CurrentConfigName = "Default"

local function GetConfigList()
    local list = {}
    if listfiles and isfolder and isfolder(ConfigFolderName) then
        for _, file in pairs(listfiles(ConfigFolderName)) do
            if file:sub(-5) == ".json" then
                local filename = file:match("([^/\\]+)%.json$")
                if filename then
                    table.insert(list, filename)
                end
            end
        end
    end
    if #list == 0 then table.insert(list, "Default") end
    return list
end

local function NEX_SaveConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if writefile then
            writefile(path, HttpService:JSONEncode(VD))
        end
    end)
end

local function NEX_LoadConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if readfile and isfile and isfile(path) then
            local data = HttpService:JSONDecode(readfile(path))
            for key, value in pairs(data) do
                if VD[key] ~= nil then VD[key] = value end
            end
        end
    end)
end

local function NEX_DeleteConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" or name == "Default" then return end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if isfile and isfile(path) and delfile then
            delfile(path)
            print("[VD Config] Deleted:", name)
        end
    end)
end


pcall(function() NEX_LoadConfig("Default") end)

-- =====================================================
-- SAVE ORIGINAL LIGHTING
-- =====================================================
local originalLighting = {
    Brightness     = Lighting.Brightness,
    ClockTime      = Lighting.ClockTime,
    FogEnd         = Lighting.FogEnd,
    FogStart       = Lighting.FogStart,
    GlobalShadows  = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient
}
do
    local atm  = Lighting:FindFirstChildOfClass("Atmosphere")
    local blur = Lighting:FindFirstChildOfClass("BlurEffect")
    local cc   = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    local sr   = Lighting:FindFirstChildOfClass("SunRaysEffect")
    if atm then
        originalLighting.Atmosphere = {
            Density = atm.Density,
            Offset = atm.Offset,
            Glare = atm.Glare,
            Haze = atm
                .Haze
        }
    end
    if blur then originalLighting.Blur = { Size = blur.Size } end
    if cc then originalLighting.ColorCorrection = { Enabled = cc.Enabled } end
    if sr then originalLighting.SunRays = { Enabled = sr.Enabled } end
end

-- =====================================================
-- CHARACTER REFS
-- =====================================================
local Character, Humanoid, Root

local function updateChar(char)
    Character = char or LocalPlayer.Character
    if Character then
        task.spawn(function()
            Humanoid = Character:WaitForChild("Humanoid", 5)
            Root     = Character:WaitForChild("HumanoidRootPart", 5)
        end)
    else
        Humanoid, Root = nil, nil
    end
end
updateChar()
LocalPlayer.CharacterAdded:Connect(updateChar)
LocalPlayer.CharacterRemoving:Connect(function() Character, Humanoid, Root = nil, nil, nil end)

-- =====================================================
-- HELPERS: TEAM / COLORS
-- =====================================================
local TeamColor  = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)

local function isTeammate(player)
    return LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team
end

local function getPlayerColor(player)
    return isTeammate(player) and TeamColor or EnemyColor
end

-- =====================================================
-- ANTI-FAIL (Generator & Heal)
-- =====================================================
local AntiFailHooked = false
local oldNamecall

local function setupAntiFail()
    if AntiFailHooked then return end
    task.spawn(function()
        local ok, err = pcall(function()
            local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local Events  = ReplicatedStorage:WaitForChild("Events", 10)
            if not Remotes then
                warn("AntiFail: Remotes not found")
                return
            end

            local GenFolder  = Remotes:FindFirstChild("Generator")
            local GenResult  = GenFolder and GenFolder:FindFirstChild("SkillCheckResultEvent")
            local GenFail    = GenFolder and GenFolder:FindFirstChild("SkillCheckFailEvent")
            local HealFolder = Events and Events:FindFirstChild("Healing")
            local HealResult = HealFolder and HealFolder:FindFirstChild("SkillCheckResultEvent")
            local HealFail   = HealFolder and HealFolder:FindFirstChild("SkillCheckFailEvent")

            oldNamecall      = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args   = { ... }

                if GenResult and VD.GenAntiFail then
                    if GenFail and self == GenFail and method == "FireServer" then return nil end
                    if self == GenResult and method == "FireServer" then
                        -- Bypass executor
                        args[1] = true
                        return oldNamecall(self, unpack(args))
                    end
                end

                if HealResult and VD.HealAntiFail then
                    if HealFail and self == HealFail and method == "FireServer" then return nil end
                    if self == HealResult and method == "FireServer" then
                        args[1] = true
                        return oldNamecall(self, unpack(args))
                    end
                end

                return oldNamecall(self, ...)
            end)

            AntiFailHooked   = true
            print("AntiFail: hooked")
        end)
        if not ok then warn("AntiFail setup failed:", err) end
    end)
end
setupAntiFail()

-- =====================================================
-- UNIVERSAL ESP (PC Drawing + Mobile Highlight)
-- =====================================================
local SimpleESP = {}

local function createSimpleESPForCharacter(player, char)
    if not player or not char then return end
    if SimpleESP[player] then
        pcall(function() SimpleESP[player].Folder:Destroy() end)
    end

    local folder = Instance.new("Folder")
    folder.Name = "UniversalESP_" .. player.Name
    folder.Parent = GetSafeChamsFolder()

    -- Always use Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = char
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = getPlayerColor(player)
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = folder

    -- Billboard name (mobile + PC)
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    local billboard, label
    if head then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "NameTag"
        billboard.Size = UDim2.new(0, 160, 0, 30)
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = folder

        label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = getPlayerColor(player)
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0,0,0)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14
        label.Parent = billboard
    end

    SimpleESP[player] = { Folder = folder, Highlight = highlight, Billboard = billboard, Label = label }
end

local function createSimpleESP(player)
    if not player or player == LocalPlayer then return end
    if player.Character then
        createSimpleESPForCharacter(player, player.Character)
    end
    if not SimpleESP[player] or not SimpleESP[player].CharacterListener then
        player.CharacterAdded:Connect(function(char)
            task.wait(0.4)
            if VD.ESP then createSimpleESPForCharacter(player, char) end
        end)
    end
end

local function removeSimpleESP(player)
    if SimpleESP[player] and SimpleESP[player].Folder and SimpleESP[player].Folder.Parent then
        pcall(function() SimpleESP[player].Folder:Destroy() end)
    end
    SimpleESP[player] = nil
end

local function updateSimpleESP()
    Camera = Workspace.CurrentCamera or Camera
    for player, data in pairs(SimpleESP) do
        if not player or not player.Parent or not player.Character then
            removeSimpleESP(player)
        else
            local char   = player.Character
            local hrp    = char:FindFirstChild("HumanoidRootPart")
            local head   = char:FindFirstChild("Head")
            local posRef = head or hrp or char.PrimaryPart
            if not posRef then
                if data.Highlight then pcall(function() data.Highlight.Enabled = false end) end
                if data.Label then pcall(function() data.Label.Visible = false end) end
            else
                local camPos   = Camera and Camera.CFrame.Position or posRef.Position
                local distance = (posRef.Position - camPos).Magnitude
                if distance > VD.MaxDistance then
                    if data.Highlight then pcall(function() data.Highlight.Enabled = false end) end
                    if data.Label then pcall(function() data.Label.Visible = false end) end
                else
                    local _, onScreen = Camera:WorldToViewportPoint(posRef.Position)
                    if data.Label then data.Label.Visible = onScreen end

                    local color = getPlayerColor(player)
                    if data.Highlight then
                        data.Highlight.FillColor    = color
                        data.Highlight.OutlineColor = color
                        data.Highlight.Enabled      = VD.ESP
                    end
                    if data.Label then
                        data.Label.TextColor3 = color
                        data.Label.Text = VD.ShowDistance
                            and string.format("%s [%.0fm]", player.Name, distance)
                            or player.Name
                    end

                    if data.Billboard and (not data.Billboard.Adornee or data.Billboard.Adornee.Parent ~= char) then
                        local newHead = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or
                            char.PrimaryPart
                        data.Billboard.Adornee = newHead
                    end
                end -- distance check
            end     -- posRef check
        end         -- player/character check
    end
end

-- Init simple ESP for current players
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createSimpleESP(p) end
end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createSimpleESP(p) end end)
Players.PlayerRemoving:Connect(removeSimpleESP)

-- =====================================================
-- KOSONG (Generator ESP lama dihapus karena digabung ke Advanced ESP)
-- =====================================================

-- =====================================================
-- FULLBRIGHT
-- =====================================================
task.spawn(function()
    while not VD.Destroyed do
        if VD.Fullbright then
            Lighting.Brightness     = 2
            Lighting.ClockTime      = 14
            Lighting.GlobalShadows  = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.FogStart       = 0
            Lighting.FogEnd         = 100000
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") then
                    v.Density = 0; v.Offset = 0; v.Glare = 0; v.Haze = 0
                end
                if v:IsA("BlurEffect") then v.Size = 0 end
                if v:IsA("ColorCorrectionEffect") then v.Enabled = false end
                if v:IsA("SunRaysEffect") then v.Enabled = false end
            end
        else
            Lighting.Brightness     = originalLighting.Brightness
            Lighting.ClockTime      = originalLighting.ClockTime
            Lighting.FogEnd         = originalLighting.FogEnd
            Lighting.FogStart       = originalLighting.FogStart or 0
            Lighting.GlobalShadows  = originalLighting.GlobalShadows
            Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
            for _, v in pairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") and originalLighting.Atmosphere then
                    v.Density = originalLighting.Atmosphere.Density or 0.3
                    v.Offset  = originalLighting.Atmosphere.Offset or 0.25
                    v.Glare   = originalLighting.Atmosphere.Glare or 0
                    v.Haze    = originalLighting.Atmosphere.Haze or 0
                end
                if v:IsA("BlurEffect") and originalLighting.Blur then v.Size = originalLighting.Blur.Size or 0 end
                if v:IsA("ColorCorrectionEffect") and originalLighting.ColorCorrection then
                    v.Enabled = originalLighting
                        .ColorCorrection.Enabled or false
                end
                if v:IsA("SunRaysEffect") and originalLighting.SunRays then
                    v.Enabled = originalLighting.SunRays.Enabled or
                        false
                end
            end
        end
        task.wait(0.5)
    end
end)

-- =====================================================
-- MOVEMENT & NOCLIP
-- =====================================================
local originalCanCollide = {}

local function enableNoclipOnce()
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            if originalCanCollide[part] == nil then originalCanCollide[part] = part.CanCollide end
            part.CanCollide = false
        end
    end
end

local function disableNoclipRestore()
    for part, val in pairs(originalCanCollide) do
        if part and part.Parent and part:IsA("BasePart") then pcall(function() part.CanCollide = val end) end
    end
    originalCanCollide = {}
end

-- Membersihkan memori noclip ketika karakter hilang/mati
LocalPlayer.CharacterRemoving:Connect(function()
    originalCanCollide = {}
end)

RunService.Heartbeat:Connect(function()
    if Humanoid then
        if VD.Speed then Humanoid.WalkSpeed = VD.SpeedValue end
        if VD.Jump then Humanoid.JumpPower = VD.JumpValue end
    end

    if VD.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not SimpleESP[p] and p.Character then
                createSimpleESPForCharacter(p, p.Character)
            end
        end
    end
    updateSimpleESP()

    if VD.Noclip and LocalPlayer.Character then
        enableNoclipOnce()
    elseif not VD.Noclip and next(originalCanCollide) then
        disableNoclipRestore()
    end
end)

UserInputService.JumpRequest:Connect(function()
    if VD.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- =====================================================
-- HIDE SKILL CHECK UI
-- =====================================================
local cachedPlayerGui = LocalPlayer:WaitForChild("PlayerGui")
RunService.RenderStepped:Connect(function()
    if VD.HideSkillUI then
        if not cachedPlayerGui then cachedPlayerGui = LocalPlayer:FindFirstChild("PlayerGui") end
        local a = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui")
        local b = cachedPlayerGui and cachedPlayerGui:FindFirstChild("SkillCheckPromptGui-con")
        if a and a.Enabled then a.Enabled = false end
        if b and b.Enabled then b.Enabled = false end
    end
end)

-- =====================================================
-- UI TABS
-- =====================================================
local PlayerTab, ESPTab, MapTab, AimTab, FOVTab
local SurvivorTab, KillerTab, GeneratorTab, FlingTab, ResetTab, SettingsTab

if Window then
    PlayerTab    = Window:Tab({ Title = "Player",       Icon = "person-standing",    Desc = "Movement, teleport, and player options." })
    ESPTab       = Window:Tab({ Title = "ESP",          Icon = "eye",                Desc = "Player and object ESP settings." })
    MapTab       = Window:Tab({ Title = "Map",          Icon = "map",                Desc = "Radar and map features." })
    AimTab       = Window:Tab({ Title = "Aim",          Icon = "crosshair",          Desc = "Aimbot and spear aimbot settings." })
    FOVTab       = Window:Tab({ Title = "FOV",          Icon = "video",              Desc = "Camera, FOV, and visual options." })
    SurvivorTab  = Window:Tab({ Title = "Survivor",     Icon = "shield",             Desc = "Survivor-specific features." })
    KillerTab    = Window:Tab({ Title = "Killer",       Icon = "swords",             Desc = "Killer-specific features." })
    GeneratorTab = Window:Tab({ Title = "Generator",    Icon = "zap",                Desc = "Generator automation and visuals." })
    FlingTab     = Window:Tab({ Title = "Fling",        Icon = "wind",               Desc = "Fling features." })
    SettingsTab  = Window:Tab({ Title = "Settings",     Icon = "settings",           Desc = "Config save/load." })
    ResetTab     = Window:Tab({ Title = "Reset",        Icon = "trash-2",            Desc = "Unload the script." })
end

if Window then

do -- Player Tab
    local movSection = PlayerTab:Section({
        Title = "Movement",
    })

    movSection:Toggle({
        Title = "Speed Hack",
        Callback = function(v)
            VD.Speed = v
            if not v then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.WalkSpeed = 16 end) end
            end
        end
    })
    movSection:Slider({
        Title = "Speed Value",
        Value = { Min = 16, Max = 200, Default = 16 },
        Callback = function(v)
            VD.SpeedValue =
                v
        end
    })
    movSection:Toggle({
        Title = "Jump Hack",
        Callback = function(v)
            VD.Jump = v
            if not v then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.JumpPower = 50 end) end
            end
        end
    })
    movSection:Slider({
        Title = "Jump Power",
        Value = { Min = 50, Max = 300, Default = 50 },
        Callback = function(v)
            VD.JumpValue =
                v
        end
    })
    movSection:Toggle({ Title = "Infinite Jump", Callback = function(v) VD.InfiniteJump = v end })
    movSection:Toggle({ Title = "Noclip", Callback = function(v) VD.Noclip = v end })

    local tpSection = PlayerTab:Section({
        Title = "Teleport",
    })

    tpSection:Button({ Title = "TP to Gen", Callback = function() pcall(function() NEX_TeleportToGenerator(1) end) end })
    tpSection:Button({ Title = "TP to Gate", Callback = function() pcall(NEX_TeleportToGate) end })
    tpSection:Button({ Title = "TP to Hook", Callback = function() pcall(NEX_TeleportToHook) end })
end

do -- ESP Tab
    local basicEsp = ESPTab:Section({
        Title = "Basic ESP",
    })

    basicEsp:Toggle({
        Title = "Enable ESP (Highlight + Name)",
        Callback = function(v)
            VD.ESP = v
            if v then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then createSimpleESPForCharacter(p, p.Character) end
                end
            else
                for p, _ in pairs(SimpleESP) do removeSimpleESP(p) end
            end
        end
    })
    basicEsp:Toggle({ Title = "Show Distance", Callback = function(v) VD.ShowDistance = v end })
    basicEsp:Slider({
        Title = "Max ESP Distance",
        Value = { Min = 500, Max = 5000, Default = 2000 },
        Callback = function(v)
            VD.MaxDistance =
                v
        end
    })

    local advEsp = ESPTab:Section({
        Title = "Advanced ESP",
    })

    advEsp:Toggle({ Title = "Master Turn On Object Chams", Callback = function(v) VD.ESP_ObjectChams = v end })
    advEsp:Toggle({ Title = "- Chams: Generator (with %)", Callback = function(v) VD.ESP_Obj_Generator = v end })
    advEsp:Toggle({ Title = "- Chams: Gate", Callback = function(v) VD.ESP_Obj_Gate = v end })
    advEsp:Toggle({ Title = "- Chams: Hook", Callback = function(v) VD.ESP_Obj_Hook = v end })
    advEsp:Toggle({ Title = "- Chams: Pallet", Callback = function(v) VD.ESP_Obj_Pallet = v end })
    advEsp:Toggle({ Title = "- Chams: Window", Callback = function(v) VD.ESP_Obj_Window = v end })
    
    local otherEsp = ESPTab:Section({
        Title = "Other Markers",
    })
    otherEsp:Toggle({ Title = "Player Highlight (Chams)", Callback = function(v) VD.ESP_PlayerChams = v end })
    otherEsp:Toggle({ Title = "ESP Skeleton", Callback = function(v) VD.ESP_Skeleton = v end })
    otherEsp:Toggle({ Title = "ESP Velocity Arrows", Callback = function(v) VD.ESP_Velocity = v end })
    otherEsp:Toggle({ Title = "ESP Offscreen Arrows", Callback = function(v) VD.ESP_Offscreen = v end })
    otherEsp:Toggle({ Title = "Closest Hook Highlight", Callback = function(v) VD.ESP_ClosestHook = v end })
end

do -- Map Tab (Radar)
    local radarSection = MapTab:Section({
        Title = "Radar",
    })

    radarSection:Toggle({ Title = "Radar Enable", Callback = function(v) VD.RADAR_Enabled = v end })
    radarSection:Slider({
        Title = "Radar Size",
        Value = { Min = 80, Max = 300, Default = 120 },
        Callback = function(v)
            VD.RADAR_Size =
                v
        end
    })
    radarSection:Toggle({ Title = "Radar Circle Mode", Callback = function(v) VD.RADAR_Circle = v end })

    local radarFilter = MapTab:Section({
        Title = "Radar Filters",
    })

    radarFilter:Toggle({ Title = "Radar show Killer", Callback = function(v) VD.RADAR_Killer = v end })
    radarFilter:Toggle({ Title = "Radar show Survivor", Callback = function(v) VD.RADAR_Survivor = v end })
    radarFilter:Toggle({ Title = "Radar show Generator", Callback = function(v) VD.RADAR_Generator = v end })
    radarFilter:Toggle({ Title = "Radar show Pallet", Callback = function(v) VD.RADAR_Pallet = v end })
end

do -- Aim Tab
    local aimbotSection = AimTab:Section({
        Title = "Aimbot",
    })

    aimbotSection:Toggle({ Title = "Enable Aimbot", Callback = function(v) VD.AIM_Enabled = v end })
    aimbotSection:Toggle({ Title = "Show Crosshair", Callback = function(v)
        VD.AIM_Crosshair = v
        if NEX_CrossH and NEX_CrossV then
            NEX_CrossH.Visible = v
            NEX_CrossV.Visible = v
        end
    end })
    aimbotSection:Toggle({ Title = "Use RMB to aim", Callback = function(v) VD.AIM_UseRMB = v end })
    aimbotSection:Toggle({ Title = "Show Aim FOV (circle)", Callback = function(v) VD.AIM_ShowFOV = v end })
    aimbotSection:Slider({
        Title = "FOV Size (aim radius on screen)",
        Value = { Min = 20, Max = 400, Default = 120 },
        Callback = function(
            v)
            VD.AIM_FOV = v
        end
    })
    aimbotSection:Slider({
        Title = "Smoothness",
        Value = { Min = 0.1, Max = 1, Default = 0.3, Step = 0.05 },
        Callback = function(v)
            VD.AIM_Smooth = v
        end
    })

    aimbotSection:Toggle({ Title = "Visibility Check", Callback = function(v) VD.AIM_VisCheck = v end })
    aimbotSection:Toggle({ Title = "Prediction", Callback = function(v) VD.AIM_Predict = v end })

    local spearSection = AimTab:Section({
        Title = "Spear Aimbot",
    })

    spearSection:Toggle({ Title = "Spear Aimbot", Callback = function(v) VD.SPEAR_Aimbot = v end })
    spearSection:Toggle({ Title = "Show Crosshair", Callback = function(v)
        VD.AIM_Crosshair = v
        if NEX_CrossH and NEX_CrossV then
            NEX_CrossH.Visible = v
            NEX_CrossV.Visible = v
        end
    end })
    spearSection:Slider({
        Title = "Spear Gravity",
        Value = { Min = 10, Max = 200, Default = 50 },
        Callback = function(v)
            VD.SPEAR_Gravity =
                v
        end
    })
    spearSection:Slider({
        Title = "Spear Speed",
        Value = { Min = 50, Max = 300, Default = 100 },
        Callback = function(v)
            VD.SPEAR_Speed =
                v
        end
    })
end

do -- FOV Tab
    local camSection = FOVTab:Section({
        Title = "Camera",
    })

    camSection:Toggle({ Title = "Enable Camera FOV override", Callback = function(v) VD.CAM_FOVEnabled = v end })
    camSection:Slider({
        Title = "Camera FOV",
        Value = { Min = 30, Max = 140, Default = 90 },
        Callback = function(v)
            VD.CAM_FOV =
                v
        end
    })
    camSection:Toggle({ Title = "Third Person (Killer only)", Callback = function(v) VD.CAM_ThirdPerson = v end })
    camSection:Toggle({ Title = "Shift Lock (auto face camera)", Callback = function(v) VD.CAM_ShiftLock = v end })

    local visualSection = FOVTab:Section({
        Title = "Visual",
    })

    visualSection:Toggle({ Title = "No Fog (remove fog/post effects)", Callback = function(v) VD.NO_Fog = v end })
    visualSection:Toggle({ Title = "Fullbright (lighting preset)", Callback = function(v) VD.Fullbright = v end })
end

do -- Survivor Tab
    local combatSurv = SurvivorTab:Section({
        Title = "Combat",
    })

    combatSurv:Toggle({ Title = "Auto Parry", Callback = function(v) VD.AUTO_Parry = v end })

    combatSurv:Slider({
    Title = "Parry Range (studs)",
    Value = { Min = 5, Max = 30, Default = 15 },
    Callback = function(v)
        VD.AUTO_ParryRange = v
    end
})

    combatSurv:Slider({
    Title = "Face Killer Sensitivity (deg)",
    Value = { Min = 0, Max = 180, Default = 30 },
    Callback = function(v)
        VD.AUTO_ParrySensitivity = v
    end
})

    combatSurv:Slider({
    Title = "Auto Parry Delay (s)",
    Value = { Min = 0.1, Max = 2, Default = 0.5, Step = 0.05 },
    Callback = function(v)
        VD.AUTO_ParryDelay = v
    end
})
    combatSurv:Toggle({ Title = "Auto Wiggle", Callback = function(v) VD.SURV_AutoWiggle = v end })
    combatSurv:Toggle({
        Title = "Auto SkillCheck (QTE)",
        Callback = function(v)
            VD.AUTO_SkillCheck = v; if v then pcall(SetupSkillCheckMonitor) end
        end
    })
    combatSurv:Button({
        Title = "[!] Cancel/Leave Generator [X]",
        Callback = function() pcall(NEX_ForceLeaveGenerator) end
    })
    combatSurv:Toggle({ Title = "No Fall Damage", Callback = function(v) VD.SURV_NoFall = v end })

    local escapeSurv = SurvivorTab:Section({
        Title = "Escape",
    })

    escapeSurv:Toggle({ Title = "Flee Killer (Auto TeleAway)", Callback = function(v) VD.AUTO_TeleAway = v end })
    escapeSurv:Slider({
        Title = "Flee Distance",
        Value = { Min = 20, Max = 120, Default = 40 },
        Callback = function(v)
            VD.AUTO_TeleAwayDist =
                v
        end
    })
    escapeSurv:Toggle({ Title = "Beat Survivor (auto exit)", Callback = function(v) VD.BEAT_Survivor = v end })
end

do -- Killer Tab
    local combatKiller = KillerTab:Section({
        Title = "Combat",
    })

    combatKiller:Toggle({ Title = "Auto Attack", Callback = function(v) VD.AUTO_Attack = v end })
    combatKiller:Slider({
        Title = "Attack Range",
        Value = { Min = 5, Max = 20, Default = 12 },
        Callback = function(v)
            VD.AUTO_AttackRange =
                v
        end
    })
    combatKiller:Toggle({ Title = "Hitbox Expand", Callback = function(v) VD.HITBOX_Enabled = v end })
    combatKiller:Slider({
        Title = "Hitbox Size",
        Value = { Min = 5, Max = 40, Default = 15 },
        Callback = function(v)
            VD.HITBOX_Size =
                v
        end
    })
    combatKiller:Toggle({ Title = "Double Tap", Callback = function(v) VD.KILLER_DoubleTap = v end })
    combatKiller:Toggle({ Title = "Infinite Lunge", Callback = function(v) VD.KILLER_InfiniteLunge = v end })

    local mapKiller = KillerTab:Section({
        Title = "Map Control",
    })

    mapKiller:Toggle({ Title = "Destroy Pallets", Callback = function(v) VD.KILLER_DestroyPallets = v end })
    mapKiller:Toggle({ Title = "Full Gen Break", Callback = function(v) VD.KILLER_FullGenBreak = v end })

    local utilKiller = KillerTab:Section({
        Title = "Utilities",
    })

    utilKiller:Toggle({ Title = "Auto Hook", Callback = function(v) VD.KILLER_AutoHook = v end })
    utilKiller:Toggle({
        Title = "Anti Blind (Flashlight)",
        Callback = function(v)
            VD.KILLER_AntiBlind = v; pcall(SetupAntiBlind)
        end
    })
    utilKiller:Toggle({
        Title = "No Pallet Stun (metamethod)",
        Callback = function(v)
            VD.KILLER_NoPalletStun = v; pcall(SetupNoPalletStun)
        end
    })
    utilKiller:Toggle({ Title = "No Slowdown", Callback = function(v) VD.KILLER_NoSlowdown = v end })
    utilKiller:Toggle({ Title = "Beat Killer (auto kill)", Callback = function(v) VD.BEAT_Killer = v end })
end

do -- Generator Tab
    local genVisual = GeneratorTab:Section({
        Title = "Visual",
    })

    genVisual:Toggle({ Title = "Master Turn On Object Chams", Callback = function(v) VD.ESP_ObjectChams = v end })
    genVisual:Toggle({ Title = "- Chams: Generator (with %)", Callback = function(v) VD.ESP_Obj_Generator = v end })

    local genAuto = GeneratorTab:Section({
        Title = "Automation",
    })

    genAuto:Toggle({ Title = "AntiFail Generator", Callback = function(v) VD.GenAntiFail = v end })
end

do -- Fling Tab
    local flingSection = FlingTab:Section({
        Title = "Fling",
    })

    flingSection:Toggle({ Title = "Enable Fling", Callback = function(v) VD.FLING_Enabled = v end })
    flingSection:Slider({
        Title = "Fling Strength",
        Value = { Min = 1000, Max = 50000, Default = 10000 },
        Callback = function(
            v)
            VD.FLING_Strength = v
        end
    })

    local flingActions = FlingTab:Section({
        Title = "Actions",
    })

    flingActions:Button({ Title = "Fling Nearest", Callback = function() pcall(function() NEX_FlingNearest() end) end })
    flingActions:Button({ Title = "Fling All", Callback = function() pcall(NEX_FlingAll) end })
end

do -- Settings Tab
    local cfgSection = SettingsTab:Section({
        Title = "Configuration",
    })

    local confInput = ""
    local configDropdown

    cfgSection:Input({
        Title = "Config Name",
        Placeholder = "Type name to save...",
        Callback = function(v)
            confInput = v
        end
    })

    cfgSection:Button({
        Title = "Save Config",
        Callback = function() 
            if confInput ~= "" then
                getgenv().CurrentConfigName = confInput
            end
            pcall(function() NEX_SaveConfig(getgenv().CurrentConfigName) end)
            if configDropdown and configDropdown.Refresh then
                pcall(function() configDropdown:Refresh(GetConfigList()) end)
            end
        end
    })

    configDropdown = cfgSection:Dropdown({
        Title = "Select Config",
        Multi = false,
        Values = GetConfigList(),
        Value = GetConfigList()[1] or "Default",
        Callback = function(v)
            if type(v) == "table" then v = v[1] end -- jika multi/array
            getgenv().CurrentConfigName = v
        end
    })

    cfgSection:Button({
        Title = "Load Config",
        Callback = function() 
            pcall(function() NEX_LoadConfig(getgenv().CurrentConfigName) end)
        end
    })
    
    cfgSection:Button({
        Title = "Delete Config",
        Callback = function() 
            pcall(function() NEX_DeleteConfig(getgenv().CurrentConfigName) end)
            getgenv().CurrentConfigName = "Default"
            if configDropdown and configDropdown.Refresh then
                pcall(function() configDropdown:Refresh(GetConfigList()) end)
            end
        end
    })
    
    cfgSection:Button({
        Title = "Refresh Config List",
        Callback = function()
            if configDropdown and configDropdown.Refresh then
                pcall(function() configDropdown:Refresh(GetConfigList()) end)
            end
        end
    })
end

do -- Reset Tab
    local resetSection = ResetTab:Section({
        Title = "Unload",
    })

    resetSection:Button({
        Title = "Unload Script (cleanup)",
        Callback = function()
            VD.Destroyed    = true
            VD.Fullbright   = false
            VD.Noclip       = false
            VD.GenAntiFail  = false
            VD.HealAntiFail = false
            disableNoclipRestore()
            for p, _ in pairs(SimpleESP) do removeSimpleESP(p) end
            for _, folder in pairs(GeneratorESP) do
                if folder and folder.Parent then pcall(function() folder:Destroy() end) end
            end
            GeneratorESP = {}
            if NEX_CrosshairGui then NEX_CrosshairGui:Destroy() end
            if DrawingAvailable then
                pcall(function()
                    for target, _ in pairs(Chams.Objects or {}) do
                        pcall(function()
                            local c = target and target:FindFirstChild("_ViolenceChams"); if c then c:Destroy() end
                        end)
                        pcall(function()
                            local l = target and target:FindFirstChild("_ViolenceLabel"); if l then l:Destroy() end
                        end)
                    end
                end)
            end
            print("NEX HUB Violence District Unloaded")
        end
    })
end -- end last do-Tab block
end -- end if Window then

print("NEX HUB Violence District Loaded (Full Features merged with UI fixes)")

-- =====================================================
-- ROLE HELPERS
-- =====================================================
local function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer" end
    if name == "Survivors" then return "Survivor" end
    return "Lobby"
end

local function IsKiller(player)
    return player and player.Team and player.Team.Name == "Killer"
end

local function IsSurvivor(player)
    return player and player.Team and player.Team.Name == "Survivors"
end

-- =====================================================
-- MAP CACHE (Generators / Gates / Hooks / Pallets / Windows)
-- =====================================================
local NEX_Cache = {
    Generators  = {},
    Gates       = {},
    Hooks       = {},
    Pallets     = {},
    Windows     = {},
    ClosestHook = nil,
    ExitPos     = nil
}

local function NEX_ScanMap()
    local map = Workspace:FindFirstChild("Map")
    if not map then
        NEX_Cache = {
            Generators = {}, Gates = {}, Hooks = {}, Pallets = {}, Windows = {}, ClosestHook = nil, ExitPos = nil
        }
        return
    end

    local newGens, newGates, newHooks, newPallets, newWindows = {}, {}, {}, {}, {}
    local exitPos = nil

    if map:FindFirstChild("churchbell") then
        exitPos = Vector3.new(760.98, -20.14, -78.48)
    end

    local finish = map:FindFirstChild("Finishline") or map:FindFirstChild("FinishLine") or map:FindFirstChild("Fininshline")
    if finish then
        local fp = finish:IsA("BasePart") and finish or (finish:IsA("Model") and finish:FindFirstChildWhichIsA("BasePart"))
        if fp then exitPos = fp.Position end
    end

    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("Model") then
            local part = obj:FindFirstChild("HitBox", true) or obj:FindFirstChild("GeneratorPoint", true) or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
            if part then
                local n = obj.Name
                if n == "Generator" then
                    table.insert(newGens, { model = obj, part = part })
                elseif n == "Gate" then
                    table.insert(newGates, { model = obj, part = part })
                elseif n == "Hook" then
                    table.insert(newHooks, { model = obj, part = part })
                elseif n == "Palletwrong" or n:lower():find("pallet") then
                    table.insert(newPallets, { model = obj, part = part })
                elseif n == "Window" then
                    table.insert(newWindows, { model = obj, part = part })
                end
            end
        elseif obj:IsA("BasePart") then
            if not exitPos and obj.Name:lower():find("finish") then
                exitPos = obj.Position
            end
            if not exitPos and obj:IsA("MeshPart") then
                if obj.Material == Enum.Material.Limestone then
                    exitPos = Vector3.new(-947.90, 152.12, -7579.52)
                elseif obj.Material == Enum.Material.Leather then
                    exitPos = Vector3.new(1546.12, 152.21, -796.72)
                end
            end
        end
    end

    NEX_Cache.Generators = newGens
    NEX_Cache.Gates      = newGates
    NEX_Cache.Hooks      = newHooks
    NEX_Cache.Pallets    = newPallets
    NEX_Cache.Windows    = newWindows
    NEX_Cache.ExitPos    = exitPos
    print("[NEX ScanMap] Generators:", #newGens, "Gates:", #newGates, "Hooks:", #newHooks)

    local root           = Root
    if root and #NEX_Cache.Hooks > 0 then
        local closest, closestDist = nil, math.huge
        for _, hook in ipairs(NEX_Cache.Hooks) do
            if hook.part then
                local d = (hook.part.Position - root.Position).Magnitude
                if d < closestDist then
                    closestDist = d; closest = hook
                end
            end
        end
        NEX_Cache.ClosestHook = closest
    end
end

-- =====================================================
-- TELEPORT HELPERS
-- =====================================================
local originalCanCollide = {}

local function NEX_TeleportToPosition(pos)
    if not pos then return false end
    local root = Root
    if not root then return false end

    if LocalPlayer.Character then
        root.Anchored = true -- Tahan agar tidak jatuh ke luar map saat CanCollide mati
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCanCollide[part] == nil then originalCanCollide[part] = part.CanCollide end
                part.CanCollide = false
            end
        end
    end

    root.CFrame = CFrame.new(pos + Vector3.new(0, VD.TP_Offset, 0))

    task.delay(0.3, function()
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function()
                        part.CanCollide = (originalCanCollide[part] ~= nil) and originalCanCollide[part] or true
                    end)
                end
            end
            root.Anchored = false -- Lepas tahanan setelah collision aktif
        end
        originalCanCollide = {}
    end)
    return true
end

function NEX_TeleportToGenerator(index)
    if not NEX_Cache or not NEX_Cache.Generators or #NEX_Cache.Generators == 0 then print("[NEX HUB] Generator tidak ditemukan") return false end

    local sorted = {}
    for _, gen in ipairs(NEX_Cache.Generators) do
        table.insert(sorted, {gen = gen, dist = (Root and (gen.part.Position - Root.Position).Magnitude) or math.huge})
    end
    table.sort(sorted, function(a, b) return a.dist < b.dist end)

    local target = sorted[index or 1]
    if not target then return false end
    return NEX_TeleportToPosition(target.gen.part.Position)
end

function NEX_TeleportToGate()
    if not NEX_Cache or not NEX_Cache.Gates or #NEX_Cache.Gates == 0 then print("[NEX HUB] Gate tidak ditemukan") return false end

    local closest, closestDist = nil, math.huge
    for _, gate in ipairs(NEX_Cache.Gates) do
        local dist = (Root and (gate.part.Position - Root.Position).Magnitude) or math.huge
        if dist < closestDist then
            closestDist = dist
            closest = gate
        end
    end

    if not closest then return false end
    return NEX_TeleportToPosition(closest.part.Position)
end

function NEX_TeleportToHook()
    if not NEX_Cache or not NEX_Cache.ClosestHook then print("[NEX HUB] Hook tidak ditemukan") return false end
    return NEX_TeleportToPosition(NEX_Cache.ClosestHook.part.Position)
end

-- MAP CHANGE DETECTION
local CurrentMapName = nil
local function CheckMapChange()
    local map = Workspace:FindFirstChild("Map")
    local mapName = map and map.Name or "Unknown"
    if CurrentMapName ~= mapName then
        print("[NEX HUB] Map berubah: " .. tostring(CurrentMapName) .. " -> " .. mapName)
        VD._BeatSurvivorDone = false
        VD._BeatKillerDone = false
        VD._LastTeleAway = 0
        VD._KillerTarget = nil
    end
    CurrentMapName = mapName
    
    NEX_ScanMap()
end

task.spawn(function()
    while not VD.Destroyed do
        CheckMapChange()
        task.wait(2)
    end
end)

-- =====================================================
-- AUTO ATTACK (Killer)
-- =====================================================
local function NEX_AutoAttack()
    if not VD.AUTO_Attack or GetRole() ~= "Killer" then return end
    local root = Root
    if not root then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local tHum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if tRoot and tHum and tHum.MaxHealth > 0 then
                local pct = tHum.Health / tHum.MaxHealth
                if pct > 0.25 and (tRoot.Position - root.Position).Magnitude <= VD.AUTO_AttackRange then
                    pcall(function()
                        local r = ReplicatedStorage:FindFirstChild("Remotes")
                        local a = r and r:FindFirstChild("Attacks")
                        local b = a and a:FindFirstChild("BasicAttack")
                        if b then b:FireServer(false) end
                    end)
                    break
                end
            end
        end
    end
end

-- =====================================================
-- AUTO PARRY (Survivor)
-- =====================================================
local LastParryTime = 0
local LastDebugParry = 0
local function AutoParry()
    if not VD.AUTO_Parry then return end
    if GetRole() ~= "Survivor" then return end
    if tick() - LastParryTime < (VD.AUTO_ParryDelay or 0.5) then return end
    
    local root = Root
    if not root then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) and player.Character then
            local killerRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if killerRoot then
                local dist = (killerRoot.Position - root.Position).Magnitude
                if dist <= (VD.AUTO_ParryRange or 15) then
                    
                    -- 1) CEK SENSITIVITAS (SUDUT PANDANG)
                    local sensitivity = VD.AUTO_ParrySensitivity or 30
                    local dirToKiller = (killerRoot.Position - root.Position).Unit
                    
                    if dirToKiller.Magnitude == dirToKiller.Magnitude then
                        local survivorLook = root.CFrame.LookVector
                        local dotProduct = survivorLook:Dot(dirToKiller)
                        local angle = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))

                        -- 2) VISIBILITY CHECK
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character, workspace.CurrentCamera}
                        local rayHit = workspace:Raycast(root.Position, killerRoot.Position - root.Position, rayParams)

                        if angle <= sensitivity and not rayHit then
                            pcall(function()
                                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                                if remotes then
                                    local items = remotes:FindFirstChild("Items")
                                    if items then
                                        
                                        local dagger = items:FindFirstChild("Parrying Dagger") or items:FindFirstChild("Parry") or items:FindFirstChild("Dagger")
                                        if dagger then
                                            local parry = dagger:FindFirstChild("parry") or dagger:FindFirstChildWhichIsA("RemoteEvent")
                                            if parry then
                                                local targetLook = Vector3.new(killerRoot.Position.X, root.Position.Y, killerRoot.Position.Z)
                                                root.CFrame = CFrame.lookAt(root.Position, targetLook)

                                                parry:FireServer()
                                                LastParryTime = tick()
                                            else
                                                if tick() - LastDebugParry > 2 then warn("AutoParry: Ditemukan item Dagger, tapi tidak ada RemoteEvent parry!"); LastDebugParry = tick() end
                                            end
                                        else
                                            if tick() - LastDebugParry > 2 then warn("AutoParry: Parrying Dagger tidak ditemukan di dalam Remotes.Items!"); LastDebugParry = tick() end
                                        end
                                    else
                                        if tick() - LastDebugParry > 2 then warn("AutoParry: Remotes.Items tidak ditemukan!"); LastDebugParry = tick() end
                                    end
                                end
                            end)
                            break
                        else
                            if tick() - LastDebugParry > 2 then
                                if rayHit then
                                    warn("AutoParry: Gagal, terhalang objek: " .. tostring(rayHit.Instance.Name))
                                else
                                    warn("AutoParry: Gagal, sudut Anda " .. math.floor(angle) .. "° (Maksimal di config: " .. tostring(sensitivity) .. "°). Harap hadap Killer!")
                                end
                                LastDebugParry = tick()
                            end
                        end
                    end
                end
            end
        end
    end
end

-- =====================================================
-- AUTO WIGGLE (Survivor)
-- =====================================================
local LastWiggleTime = 0

local function NEX_AutoWiggle()
    if not VD.SURV_AutoWiggle or GetRole() ~= "Survivor" then return end
    if tick() - LastWiggleTime < 0.3 then return end
    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local c  = r and r:FindFirstChild("Carry")
        local su = c and c:FindFirstChild("SelfUnHookEvent")
        if su then
            su:FireServer(); LastWiggleTime = tick()
        end
    end)
end

-- =====================================================
-- HITBOX EXPAND (Killer)
-- =====================================================
local OriginalHitboxSizes = {}

local function NEX_UpdateHitboxes()
    local function restoreAll()
        for player, originalSize in pairs(OriginalHitboxSizes) do
            if player and player.Character then
                local r = player.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    r.Size = originalSize; r.Transparency = 1; r.CanCollide = true
                end
            end
        end
        OriginalHitboxSizes = {}
    end

    if GetRole() ~= "Killer" or not VD.HITBOX_Enabled then
        restoreAll()
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    if not OriginalHitboxSizes[player] then
                        OriginalHitboxSizes[player] = root.Size
                    end
                    local sz          = VD.HITBOX_Size
                    root.Size         = Vector3.new(sz, sz, sz)
                    root.CanCollide   = false
                    root.Transparency = 0.7
                elseif root and OriginalHitboxSizes[player] then
                    root.Size                   = OriginalHitboxSizes[player]
                    root.Transparency           = 1
                    root.CanCollide             = true
                    OriginalHitboxSizes[player] = nil
                end
            end
        end
    end
end

-- =====================================================
-- DESTROY ALL PALLETS (Killer)
-- =====================================================
local LastPalletDestroyMap = 0

local function NEX_DestroyAllPallets()
    if not VD.KILLER_DestroyPallets or GetRole() ~= "Killer" then return end
    
    if tick() - LastPalletDestroyMap < 1.5 then return end
    
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        local p = r and r:FindFirstChild("Pallet")
        local j = p and p:FindFirstChild("Jason")
        if not j then return end
        
        local dg = j:FindFirstChild("Destroy-Global")
        local d  = j:FindFirstChild("Destroy")
        
        if dg then pcall(function() dg:FireServer() end) end
        
        if d then
            local sentCount = 0
            for _, pallet in ipairs(NEX_Cache.Pallets) do
                if pallet.model then
                    sentCount = sentCount + 1
                    task.spawn(function()
                        pcall(function() d:FireServer(pallet.model) end)
                    end)
                end
            end
        end
    end)
    
    LastPalletDestroyMap = tick()
end

-- =====================================================
-- FULL GEN BREAK (Killer)
-- =====================================================
local LastGenBreakTime = 0

local function NEX_FullGenBreak()
    if not VD.KILLER_FullGenBreak then return end
    if GetRole() ~= "Killer" then return end
    if tick() - LastGenBreakTime < 0.8 then return end
    local root = Root
    if not root then return end
    
    LastGenBreakTime = tick()

    local r = ReplicatedStorage:FindFirstChild("Remotes")
    if not r then return end
    local g = r:FindFirstChild("Generator")
    if not g then return end
    
    local be = g:FindFirstChild("BreakGenEvent")
    if not be then return end
    
    -- Kumpulkan semua generator dari Map
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    
    -- Scan semua children map untuk cari GeneratorPoint parts
    for _, obj in ipairs(map:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:find("GeneratorPoint") then
            task.spawn(function()
                pcall(function() be:FireServer(obj) end)
            end)
        end
    end
end

-- =====================================================
-- DOUBLE TAP (Killer)
-- =====================================================
local LastDoubleTapTime = 0

local function NEX_DoubleTap()
    if not VD.KILLER_DoubleTap or GetRole() ~= "Killer" then return end
    if tick() - LastDoubleTapTime < 0.5 then return end
    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local a  = r and r:FindFirstChild("Attacks")
        local ba = a and a:FindFirstChild("BasicAttack")
        if ba then
            ba:FireServer(false)
            task.wait(0.05)
            ba:FireServer(false)
            LastDoubleTapTime = tick()
        end
    end)
end

-- =====================================================
-- INFINITE LUNGE (Killer)
-- =====================================================
local function NEX_InfiniteLunge()
    if not VD.KILLER_InfiniteLunge or GetRole() ~= "Killer" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = root.CFrame.LookVector * 100 + Vector3.new(0, 10, 0)
    end
end

-- =====================================================
-- FLING
-- =====================================================
function NEX_FlingNearest()
    if not VD.FLING_Enabled then return end
    local root = Root
    if not root then return end
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (tr.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist; closest = player
                end
            end
        end
    end
    if closest and closest.Character then
        local tr = closest.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local originalPos = root.CFrame
            for _ = 1, 10 do
                root.CFrame      = tr.CFrame
                root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength / 2, VD.FLING_Strength)
                root.RotVelocity = Vector3.new(9999, 9999, 9999)
                task.wait()
            end
            root.CFrame      = originalPos
            root.Velocity    = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
    end
end

function NEX_FlingAll()
    if not VD.FLING_Enabled then return end
    local root = Root
    if not root then return end
    local originalPos = root.CFrame
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                for _ = 1, 5 do
                    root.CFrame      = tr.CFrame
                    root.Velocity    = Vector3.new(VD.FLING_Strength, VD.FLING_Strength / 2, VD.FLING_Strength)
                    root.RotVelocity = Vector3.new(9999, 9999, 9999)
                    task.wait()
                end
            end
        end
    end
    root.CFrame      = originalPos
    root.Velocity    = Vector3.zero
    root.RotVelocity = Vector3.zero
end

-- =====================================================
-- TELE AWAY (Survivor flee from killer)
-- =====================================================
local function NEX_GetKillerDistance()
    local root = Root
    if not root then return math.huge, nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) then
            local killerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if killerRoot then
                return (killerRoot.Position - root.Position).Magnitude, killerRoot.Position
            end
        end
    end
    return math.huge, nil
end

local function NEX_TeleportAway()
    if not VD.AUTO_TeleAway then return end
    if GetRole() == "Killer" then return end
    local now = tick()
    if not VD._LastTeleAway then VD._LastTeleAway = 0 end
    if now - VD._LastTeleAway < 3 then return end
    local root = Root
    if not root then return end
    local killerDist, killerPos = NEX_GetKillerDistance()
    if killerDist > VD.AUTO_TeleAwayDist then return end
    VD._LastTeleAway = now
    local bestSpot = nil
    local bestDist = 0
    for _, gate in ipairs(NEX_Cache.Gates) do
        if gate.part and killerPos then
            local gatePos = gate.part.Position
            local distFromKiller = (gatePos - killerPos).Magnitude
            if distFromKiller > bestDist then
                bestDist = distFromKiller
                bestSpot = gatePos
            end
        end
    end
    if not bestSpot then
        for _, gen in ipairs(NEX_Cache.Generators) do
            if gen.part and killerPos then
                local genPos = gen.part.Position
                local distFromKiller = (genPos - killerPos).Magnitude
                if distFromKiller > bestDist then
                    bestDist = distFromKiller
                    bestSpot = genPos
                end
            end
        end
    end
    if not bestSpot and killerPos then
        local direction = (root.Position - killerPos).Unit
        bestSpot = root.Position + direction * 80
    end
    if bestSpot then
        NEX_TeleportToPosition(bestSpot)
    end
end

-- =====================================================
-- BEAT GAME SURVIVOR (teleport to exit)
-- =====================================================
local function NEX_BeatGameSurvivor()
    if not VD.BEAT_Survivor or GetRole() ~= "Survivor" then return end
    local root = Root
    if not root then return end
    local map = Workspace:FindFirstChild("Map")
    if not map then return end

    local exitPos = nil
    local finishPart = nil
    pcall(function()
        if map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop") then
            exitPos = Vector3.new(3098.16, 454.04, -4918.74); return
        end
        if map:FindFirstChild("HooksMeat") then
            exitPos = Vector3.new(1546.12, 152.21, -796.72); return
        end
        if NEX_Cache and NEX_Cache.ExitPos then
            exitPos = NEX_Cache.ExitPos
            return
        end
    end)

    if not exitPos then return end
    VD._LastFinishPos    = VD._LastFinishPos or nil
    VD._BeatSurvivorDone = VD._BeatSurvivorDone or false
    if VD._BeatSurvivorDone then return end

    VD._BeatSurvivorDone = true
    VD._LastFinishPos    = exitPos

    task.spawn(function()
        task.delay(4, function()
            if VD._BeatSurvivorDone then VD._BeatSurvivorDone = false end
        end)

        for i = 1, 10 do
            if not Root or not Root.Parent then break end
            
            pcall(function()
                local event = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Game"):FindFirstChild("PlayerActionEvent")
                if event then
                    if event:IsA("RemoteEvent") then
                        event:FireServer("ESCAPED", 200)
                    elseif event:IsA("BindableEvent") then
                        event:Fire("ESCAPED", 200)
                    end
                end
            end)

            if firetouchinterest and finishPart then
                pcall(function() firetouchinterest(Root, finishPart, 0) end)
                pcall(function() firetouchinterest(Root, finishPart, 1) end)
            end
            
            if i == 1 then
                Root.Velocity = Vector3.zero
                Root.CFrame = CFrame.new(exitPos + Vector3.new(0, 3, 0))
            end

            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:MoveTo(exitPos) --
                end
            end)

            task.wait(0.2)
        end
    end)
end

-- =====================================================
-- BEAT GAME KILLER (auto chase & attack survivors)
-- =====================================================
local function NEX_BeatGameKiller()
    if not VD.BEAT_Killer then
        VD._KillerTarget = nil; return
    end
    if GetRole() ~= "Killer" then
        VD._KillerTarget = nil; return
    end
    local root = Root
    if not root then return end

    local target        = VD._KillerTarget
    local needNewTarget = true
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        local th = target.Character:FindFirstChildOfClass("Humanoid")
        if tr and th and th.Health > 0 then
            needNewTarget = false
        else
            VD._KillerTarget = nil
        end
    end

    if needNewTarget then
        local survivors = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
                local pr = player.Character:FindFirstChild("HumanoidRootPart")
                local ph = player.Character:FindFirstChildOfClass("Humanoid")
                if pr and ph and ph.Health > 0 then table.insert(survivors, player) end
            end
        end
        if #survivors > 0 then
            local closest, closestDist = nil, math.huge
            for _, player in ipairs(survivors) do
                local pr   = player.Character:FindFirstChild("HumanoidRootPart")
                local dist = (pr.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist; closest = player
                end
            end
            VD._KillerTarget = closest
            target           = closest
        else
            VD._KillerTarget = nil; return
        end
    end

    if not target or not target.Character then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    local th = target.Character:FindFirstChildOfClass("Humanoid")
    if not tr or not th then
        VD._KillerTarget = nil; return
    end
    if th.Health <= 0 then
        VD._KillerTarget = nil; return
    end

    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
    end

    local dir = (root.Position - tr.Position).Unit
    if dir.Magnitude ~= dir.Magnitude then dir = Vector3.new(1, 0, 0) end
    root.CFrame = CFrame.new(tr.Position + dir * 3 + Vector3.new(0, 1, 0), tr.Position)

    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local a  = r and r:FindFirstChild("Attacks")
        local ba = a and a:FindFirstChild("BasicAttack")
        if ba then ba:FireServer(false) end
    end)
end

-- =====================================================
-- AUTO HOOK (Killer)
-- =====================================================
local IsAutoHooking = false

local function NEX_AutoHook()
    if not VD.KILLER_AutoHook or GetRole() ~= "Killer" then return end
    if IsAutoHooking then return end
    
    local root = Root
    if not root then return end

    local closestDowned, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tr  = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum then
                local pct = (hum.MaxHealth > 0) and (hum.Health / hum.MaxHealth) or 0
                if pct <= 0.25 and pct > 0 then
                    local isHooked = false
                    if NEX_Cache and NEX_Cache.Hooks then
                        for _, hh in ipairs(NEX_Cache.Hooks) do
                            if hh.part and (hh.part.Position - tr.Position).Magnitude < 4.5 then
                                isHooked = true; break
                            end
                        end
                    end
                    
                    if not isHooked then
                        local dist = (tr.Position - root.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist; closestDowned = tr
                        end
                    end
                end
            end
        end
    end

    if closestDowned then
        local closestHook, hDist = nil, math.huge
        for _, h in ipairs(NEX_Cache.Hooks) do
            if h.part then
                local hd = (h.part.Position - closestDowned.Position).Magnitude
                if hd < hDist then
                    hDist = hd; closestHook = h
                end
            end
        end

        if closestHook then
            IsAutoHooking = true
            task.spawn(function()
                root.CFrame = CFrame.new(closestDowned.Position + Vector3.new(0, 3, 0), closestDowned.Position)
                task.wait(0.3)
                
                pcall(function()
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.05)
                    vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end)
                
                task.wait(0.8)

                if root and root.Parent then
                    root.CFrame = CFrame.new(closestHook.part.Position + Vector3.new(0, 3, 0))
                    task.wait(0.3)
                    
                    pcall(function()
                        local event = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Carry"):FindFirstChild("HookEvent")
                        if event and event:IsA("RemoteEvent") then
                            local hookPoint = nil
                            if closestHook.model then
                                hookPoint = closestHook.model:FindFirstChild("HookPoint") or closestHook.model:FindFirstChild("HookHitbox")
                            end
                            if not hookPoint then hookPoint = closestHook.part end
                            
                            event:FireServer(hookPoint)
                        end
                    end)
                end
                
                task.wait(1)
                IsAutoHooking = false
            end)
        end
    end
end

-- =====================================================
-- MAP SCAN LOOP & MAIN AUTO LOOP
-- =====================================================
task.spawn(function()
    while not VD.Destroyed do
        if Root and NEX_Cache.Hooks and #NEX_Cache.Hooks > 0 then
            local closest, closestDist = nil, math.huge
            for _, hook in ipairs(NEX_Cache.Hooks) do
                if hook.part then
                    local d = (hook.part.Position - Root.Position).Magnitude
                    if d < closestDist then
                        closestDist = d; closest = hook
                    end
                end
            end
            NEX_Cache.ClosestHook = closest
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while not VD.Destroyed do
        pcall(NEX_AutoAttack)
        pcall(AutoParry)
        pcall(NEX_AutoWiggle)
        pcall(NEX_UpdateHitboxes)
        pcall(NEX_DestroyAllPallets)
        pcall(NEX_FullGenBreak)
        pcall(NEX_DoubleTap)
        pcall(NEX_InfiniteLunge)
        pcall(NEX_TeleportAway)
        pcall(NEX_BeatGameSurvivor)
        pcall(NEX_BeatGameKiller)
        pcall(NEX_AutoHook)
        task.wait(0.12)
    end
end)

-- =====================================================
-- CHAMS (Highlight + Billboard)
-- =====================================================
local Chams = { Objects = {} }

function Chams.Create(target, colorData, label)
    if not target or not target:IsA("Instance") then return nil end

    local ex = target:FindFirstChild("_ViolenceChams")
    if ex then ex:Destroy() end

    local highlight               = Instance.new("Highlight")
    highlight.Name                = "_ViolenceChams"
    highlight.Adornee             = target
    highlight.FillColor           = colorData.fill
    highlight.OutlineColor        = colorData.outline
    highlight.FillTransparency    = colorData.fillTrans or 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    -- Coba parent ke target dulu, fallback ke chams folder
    local ok = pcall(function() highlight.Parent = target end)
    if not ok then highlight.Parent = GetSafeChamsFolder() end

    local data                    = { highlight = highlight, target = target }

    if label then
        local rootPart = (target:IsA("Model") and (target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart"))) or
            target
        if rootPart then
            local billboard                  = Instance.new("BillboardGui")
            billboard.Name                   = "_ViolenceLabel"
            billboard.Size                   = UDim2.new(0, 150, 0, 20)
            billboard.AlwaysOnTop            = true
            billboard.StudsOffset            = Vector3.new(0, 3, 0)
            billboard.Adornee                = rootPart
            billboard.Parent                 = GetSafeChamsFolder()

            local textLabel                  = Instance.new("TextLabel")
            textLabel.Size                   = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3             = colorData.outline
            textLabel.TextStrokeColor3       = Color3.new(0, 0, 0)
            textLabel.TextStrokeTransparency = 0
            textLabel.Font                   = Enum.Font.GothamBold
            textLabel.TextSize               = 14
            textLabel.Text                   = label
            textLabel.Parent                 = billboard

            data.billboard                   = billboard
            data.textLabel                   = textLabel
            data.rootPart                    = rootPart
        end
    end

    Chams.Objects[target] = data
    return data
end

function Chams.Update(target, newLabel, newDist)
    local data = Chams.Objects[target]
    if not data then return end
    if data.textLabel then
        if not newLabel and not newDist then
            data.billboard.Enabled = false
        else
            data.billboard.Enabled = true
            data.textLabel.Text = (VD.ShowDistance and newDist)
                and string.format("%s [%.0fm]", newLabel or "", newDist)
                or (newLabel or "")
        end
    end
end

function Chams.SetColor(target, colorData)
    local data = Chams.Objects[target]
    if not data or not data.highlight then return end
    
    if not data.highlight.Parent then
        Chams.Remove(target)
        return
    end
    
    data.highlight.FillColor        = colorData.fill
    data.highlight.OutlineColor     = colorData.outline
    data.highlight.FillTransparency = colorData.fillTrans or 0.5
    if data.textLabel then data.textLabel.TextColor3 = colorData.outline end
end

function Chams.Remove(target)
    local data = Chams.Objects[target]
    if data then
        if data.highlight and data.highlight.Parent then data.highlight:Destroy() end
        if data.billboard and data.billboard.Parent then data.billboard:Destroy() end
        Chams.Objects[target] = nil
    end
    if target then
        local ec = target:FindFirstChild("_ViolenceChams")
        local el = target:FindFirstChild("_ViolenceLabel")
        if ec then ec:Destroy() end
        if el then el:Destroy() end
    end
end

function Chams.ClearAll()
    for target, _ in pairs(Chams.Objects) do Chams.Remove(target) end
    Chams.Objects = {}
end

-- =====================================================
-- DRAWING-BASED ESP (boxes / skeleton / offscreen / velocity)
-- =====================================================
local DrawingESP = { cache = {}, objectCache = {}, velocityData = {} }

local function DrawingESP_create()
    local skel = {}
    for i = 1, 14 do
        skel[i] = SafeDrawing("Line")
        if skel[i] then
            skel[i].Thickness = 1; skel[i].Visible = false
        end
    end
    local box = {}
    for i = 1, 4 do
        box[i] = SafeDrawing("Line")
        if box[i] then
            box[i].Thickness = 1; box[i].Visible = false
        end
    end
    return {
        Box       = box,
        Name      = SafeDrawing("Text"),
        Dist      = SafeDrawing("Text"),
        Skel      = skel,
        HealthBg  = SafeDrawing("Square"),
        HealthBar = SafeDrawing("Square"),
        Offscreen = SafeDrawing("Triangle"),
        VelLine   = SafeDrawing("Line"),
        VelArrow  = SafeDrawing("Triangle")
    }
end

local function DrawingESP_setup(esp)
    if not esp then return end
    for _, l in ipairs(esp.Box) do
        if l then
            l.Thickness = 1; l.Visible = false
        end
    end
    for _, l in ipairs(esp.Skel) do
        if l then
            l.Thickness = 1; l.Visible = false
        end
    end
    if esp.Name then
        esp.Name.Size = 14; esp.Name.Font = Drawing.Fonts.Monospace; esp.Name.Center = true; esp.Name.Outline = true; esp.Name.Visible = false
    end
    if esp.Dist then
        esp.Dist.Size = 12; esp.Dist.Font = Drawing.Fonts.Monospace; esp.Dist.Center = true; esp.Dist.Outline = true; esp.Dist.Color =
            Color3.fromRGB(180, 180, 180); esp.Dist.Visible = false
    end
    if esp.HealthBg then
        esp.HealthBg.Filled = true; esp.HealthBg.Color = Color3.fromRGB(25, 25, 25); esp.HealthBg.Visible = false
    end
    if esp.HealthBar then
        esp.HealthBar.Filled = true; esp.HealthBar.Visible = false
    end
    if esp.Offscreen then
        esp.Offscreen.Filled = true; esp.Offscreen.Visible = false
    end
    if esp.VelLine then
        esp.VelLine.Thickness = 2; esp.VelLine.Color = Color3.fromRGB(0, 255, 255); esp.VelLine.Visible = false
    end
    if esp.VelArrow then
        esp.VelArrow.Filled = true; esp.VelArrow.Color = Color3.fromRGB(0, 255, 255); esp.VelArrow.Visible = false
    end
end

local Bones_R15 = {
    { "Head",       "UpperTorso" }, { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" }
}
local Bones_R6 = {
    { "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" }, { "Torso", "Left Leg" }, { "Torso", "Right Leg" }
}

local function DrawingESP_cleanup()
    local valid = {}
    for _, p in ipairs(Players:GetPlayers()) do valid[p] = true end
    for player, esp in pairs(DrawingESP.cache) do
        if not valid[player] then
            if esp then
                pcall(function()
                    for _, l in ipairs(esp.Box) do if l then SafeRemove(l) end end
                    for _, l in ipairs(esp.Skel) do if l then SafeRemove(l) end end
                    if esp.Name then SafeRemove(esp.Name) end
                    if esp.Dist then SafeRemove(esp.Dist) end
                    if esp.HealthBg then SafeRemove(esp.HealthBg) end
                    if esp.HealthBar then SafeRemove(esp.HealthBar) end
                    if esp.Offscreen then SafeRemove(esp.Offscreen) end
                    if esp.VelLine then SafeRemove(esp.VelLine) end
                    if esp.VelArrow then SafeRemove(esp.VelArrow) end
                end)
            end
            DrawingESP.cache[player]        = nil
            DrawingESP.velocityData[player] = nil
        end
    end
end

local function DrawingESP_hideAll(esp)
    for _, l in ipairs(esp.Box) do if l then l.Visible = false end end
    for _, l in ipairs(esp.Skel) do if l then l.Visible = false end end
    if esp.Name then esp.Name.Visible = false end
    if esp.Dist then esp.Dist.Visible = false end
    if esp.HealthBg then esp.HealthBg.Visible = false end
    if esp.HealthBar then esp.HealthBar.Visible = false end
    if esp.VelLine then esp.VelLine.Visible = false end
    if esp.VelArrow then esp.VelArrow.Visible = false end
end

local function DrawingESP_render(esp, player, char, cam, screenSize, screenCenter)
    if not esp or not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not root or not head then
        DrawingESP_hideAll(esp); return
    end

    local myRoot = Root
    local dist   = myRoot and (root.Position - myRoot.Position).Magnitude or 0
    if dist > VD.MaxDistance then
        DrawingESP_hideAll(esp); return
    end

    local isKillerPlayer = IsKiller(player)
    local visible = true
    if VD.AIM_VisCheck or VD.AIM_Enabled then
        local camPos                      = cam.CFrame.Position
        local params                      = RaycastParams.new()
        params.FilterType                 = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = { cam, LocalPlayer.Character, char }
        local ray                         = workspace:Raycast(camPos, head.Position - camPos, params)
        visible                           = (ray == nil)
    end

    local col      = isKillerPlayer
        and (visible and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(255, 65, 65))
        or (visible and Color3.fromRGB(120, 255, 170) or Color3.fromRGB(65, 220, 130))
    local skelCol  = visible and Color3.fromRGB(150, 255, 150) or Color3.fromRGB(255, 255, 255)

    local headPos  = head.Position + Vector3.new(0, 0.5, 0)
    local feetPos  = root.Position - Vector3.new(0, 3, 0)
    local rs       = cam:WorldToViewportPoint(root.Position)
    local hs       = cam:WorldToViewportPoint(headPos)
    local fs       = cam:WorldToViewportPoint(feetPos)
    local onScreen = rs.Z > 0 and rs.X > 0 and rs.X < screenSize.X and rs.Y > 0 and rs.Y < screenSize.Y

    if not onScreen then
        DrawingESP_hideAll(esp)
        if VD.ESP_Offscreen then
            local dx    = rs.X - screenCenter.X
            local dy    = rs.Y - screenCenter.Y
            local angle = math.atan2(dy, dx)
            local edge  = 50
            local aX    = math.clamp(screenCenter.X + math.cos(angle) * (screenSize.X / 2 - edge), edge,
                screenSize.X - edge)
            local aY    = math.clamp(screenCenter.Y + math.sin(angle) * (screenSize.Y / 2 - edge), edge,
                screenSize.Y - edge)
            local fwd   = Vector2.new(math.cos(angle), math.sin(angle))
            local right = Vector2.new(-fwd.Y, fwd.X)
            local pos   = Vector2.new(aX, aY)
            local sz    = 12
            if esp.Offscreen then
                esp.Offscreen.PointA  = pos + fwd * sz
                esp.Offscreen.PointB  = pos - fwd * sz / 2 - right * sz / 2
                esp.Offscreen.PointC  = pos - fwd * sz / 2 + right * sz / 2
                esp.Offscreen.Color   = col
                esp.Offscreen.Visible = true
            end
        else
            if esp.Offscreen then esp.Offscreen.Visible = false end
        end
        return
    end

    if esp.Offscreen then esp.Offscreen.Visible = false end

    local boxTop    = hs.Y
    local boxBottom = fs.Y
    local boxHeight = math.abs(boxBottom - boxTop)
    local boxWidth  = boxHeight * 0.6
    local cx        = rs.X

    if esp.Box[1] then
        esp.Box[1].From = Vector2.new(cx - boxWidth / 2, boxTop); esp.Box[1].To = Vector2.new(cx + boxWidth / 2, boxTop); esp.Box[1].Color =
            col; esp.Box[1].Visible = true
    end
    if esp.Box[2] then
        esp.Box[2].From = Vector2.new(cx + boxWidth / 2, boxTop); esp.Box[2].To = Vector2.new(cx + boxWidth / 2,
            boxBottom); esp.Box[2].Color = col; esp.Box[2].Visible = true
    end
    if esp.Box[3] then
        esp.Box[3].From = Vector2.new(cx + boxWidth / 2, boxBottom); esp.Box[3].To = Vector2.new(cx - boxWidth / 2,
            boxBottom); esp.Box[3].Color = col; esp.Box[3].Visible = true
    end
    if esp.Box[4] then
        esp.Box[4].From = Vector2.new(cx - boxWidth / 2, boxBottom); esp.Box[4].To = Vector2.new(cx - boxWidth / 2,
            boxTop); esp.Box[4].Color = col; esp.Box[4].Visible = true
    end

    if esp.Name then
        esp.Name.Text = player.Name; esp.Name.Position = Vector2.new(cx, boxTop - 18); esp.Name.Color = col; esp.Name.Visible = true
    end
    if esp.Dist then
        esp.Dist.Text = math.floor(dist) .. "m"; esp.Dist.Position = Vector2.new(cx, boxBottom + 4); esp.Dist.Visible = true
    end

    if VD.ESP_Skeleton and hum then
        local bones = (char:FindFirstChild("Torso") and Bones_R6) or Bones_R15
        for i, b in ipairs(bones) do
            if esp.Skel[i] then
                local p1 = char:FindFirstChild(b[1])
                local p2 = char:FindFirstChild(b[2])
                if p1 and p2 then
                    local s1 = cam:WorldToViewportPoint(p1.Position)
                    local s2 = cam:WorldToViewportPoint(p2.Position)
                    if s1.Z > 0 and s2.Z > 0 then
                        esp.Skel[i].From    = Vector2.new(s1.X, s1.Y)
                        esp.Skel[i].To      = Vector2.new(s2.X, s2.Y)
                        esp.Skel[i].Color   = skelCol
                        esp.Skel[i].Visible = true
                    else
                        esp.Skel[i].Visible = false
                    end
                else
                    esp.Skel[i].Visible = false
                end
            end
        end
    else
        for _, l in ipairs(esp.Skel) do if l then l.Visible = false end end
    end

    -- Velocity arrows
    local vd = DrawingESP.velocityData[player]
    if not vd then
        vd = { pos = root.Position, vel = Vector3.zero, time = tick() }
        DrawingESP.velocityData[player] = vd
    end
    local now = tick()
    local dt  = now - vd.time
    if dt > 0.03 then
        local rawVel = (root.Position - vd.pos) / dt
        vd.vel       = vd.vel * 0.7 + rawVel * 0.3
        vd.pos       = root.Position
        vd.time      = now
    end

    if VD.ESP_Velocity then
        local velFlat = Vector3.new(vd.vel.X, 0, vd.vel.Z)
        local velMag  = velFlat.Magnitude
        if velMag > 2 then
            local futurePos    = root.Position + velFlat.Unit * math.clamp(velMag * 0.4, 5, 20)
            local futureScreen = cam:WorldToViewportPoint(futurePos)
            if futureScreen.Z > 0 then
                if esp.VelLine then
                    esp.VelLine.From = Vector2.new(rs.X, rs.Y); esp.VelLine.To = Vector2.new(futureScreen.X,
                        futureScreen.Y); esp.VelLine.Visible = true
                end
                local dx  = futureScreen.X - rs.X
                local dy  = futureScreen.Y - rs.Y
                local len = math.sqrt(dx * dx + dy * dy)
                if len > 5 and esp.VelArrow then
                    local fx, fy         = dx / len, dy / len
                    esp.VelArrow.PointA  = Vector2.new(futureScreen.X, futureScreen.Y)
                    esp.VelArrow.PointB  = Vector2.new(futureScreen.X - fx * 10 + fy * 5, futureScreen.Y - fy * 10 - fx *
                        5)
                    esp.VelArrow.PointC  = Vector2.new(futureScreen.X - fx * 10 - fy * 5, futureScreen.Y - fy * 10 + fx *
                        5)
                    esp.VelArrow.Visible = true
                elseif esp.VelArrow then
                    esp.VelArrow.Visible = false
                end
            else
                if esp.VelLine then esp.VelLine.Visible = false end
                if esp.VelArrow then esp.VelArrow.Visible = false end
            end
        else
            if esp.VelLine then esp.VelLine.Visible = false end
            if esp.VelArrow then esp.VelArrow.Visible = false end
        end
    else
        if esp.VelLine then esp.VelLine.Visible = false end
        if esp.VelArrow then esp.VelArrow.Visible = false end
    end
end

local function DrawingESP_renderObject(esp, pos, label, color, cam)
    if not esp or not pos then return end
    local myRoot = Root
    local dist   = myRoot and (pos - myRoot.Position).Magnitude or 0
    local function hideAll()
        for _, l in ipairs(esp.Box) do if l then l.Visible = false end end
        if esp.Label then esp.Label.Visible = false end
        if esp.Dist then esp.Dist.Visible = false end
    end
    if dist > VD.MaxDistance then
        hideAll(); return
    end
    local screen = cam:WorldToViewportPoint(pos)
    if screen.Z <= 0 then
        hideAll(); return
    end

    local size = math.clamp(800 / screen.Z, 16, 60)
    local sx, sy = screen.X, screen.Y
    if esp.Box[1] then
        esp.Box[1].From = Vector2.new(sx - size / 2, sy - size / 2); esp.Box[1].To = Vector2.new(sx + size / 2,
            sy - size / 2); esp.Box[1].Color = color; esp.Box[1].Visible = true
    end
    if esp.Box[2] then
        esp.Box[2].From = Vector2.new(sx + size / 2, sy - size / 2); esp.Box[2].To = Vector2.new(sx + size / 2,
            sy + size / 2); esp.Box[2].Color = color; esp.Box[2].Visible = true
    end
    if esp.Box[3] then
        esp.Box[3].From = Vector2.new(sx + size / 2, sy + size / 2); esp.Box[3].To = Vector2.new(sx - size / 2,
            sy + size / 2); esp.Box[3].Color = color; esp.Box[3].Visible = true
    end
    if esp.Box[4] then
        esp.Box[4].From = Vector2.new(sx - size / 2, sy + size / 2); esp.Box[4].To = Vector2.new(sx - size / 2,
            sy - size / 2); esp.Box[4].Color = color; esp.Box[4].Visible = true
    end
    if esp.Label then
        esp.Label.Text = label; esp.Label.Position = Vector2.new(sx, sy - size / 2 - 14); esp.Label.Color = color; esp.Label.Visible = true
    end
    if esp.Dist then
        esp.Dist.Text     = math.floor(dist) .. "m"; esp.Dist.Position = Vector2.new(sx, sy + size / 2 + 2); esp.Dist.Visible = true
    end
end

-- =====================================================
-- RADAR
-- =====================================================
local Radar = {
    bg            = DrawingAvailable and SafeDrawing("Square") or nil,
    circleBg      = DrawingAvailable and SafeDrawing("Circle") or nil,
    border        = DrawingAvailable and SafeDrawing("Square") or nil,
    circleBorder  = DrawingAvailable and SafeDrawing("Circle") or nil,
    cross1        = DrawingAvailable and SafeDrawing("Line") or nil,
    cross2        = DrawingAvailable and SafeDrawing("Line") or nil,
    center        = DrawingAvailable and SafeDrawing("Triangle") or nil,
    dots          = {},
    objectDots    = {},
    palletSquares = {}
}

if DrawingAvailable then
    Radar.bg.Filled              = true; Radar.bg.Color = Color3.fromRGB(20, 20, 20); Radar.bg.Transparency = 0.8
    Radar.circleBg.Filled        = true; Radar.circleBg.Color = Color3.fromRGB(20, 20, 20); Radar.circleBg.Transparency = 0.8; Radar.circleBg.NumSides = 64
    Radar.border.Filled          = false; Radar.border.Color = Color3.fromRGB(255, 65, 65); Radar.border.Thickness = 2
    Radar.circleBorder.Filled    = false; Radar.circleBorder.Color = Color3.fromRGB(255, 65, 65); Radar.circleBorder.Thickness = 2; Radar.circleBorder.NumSides = 64
    Radar.cross1.Color           = Color3.fromRGB(40, 40, 40); Radar.cross1.Thickness = 1
    Radar.cross2.Color           = Color3.fromRGB(40, 40, 40); Radar.cross2.Thickness = 1
    Radar.center.Filled          = true; Radar.center.Color = Color3.fromRGB(0, 255, 0)

    for _ = 1, 100 do
        local d = SafeDrawing("Triangle"); if d then
            d.Filled = true; d.Visible = false
        end; table.insert(Radar.dots, d)
    end
    for _ = 1, 100 do
        local d = SafeDrawing("Circle"); if d then
            d.Filled = true; d.Visible = false; d.NumSides = 16
        end; table.insert(Radar.objectDots, d)
    end
    for _ = 1, 100 do
        local d = SafeDrawing("Square"); if d then
            d.Filled = true; d.Visible = false
        end; table.insert(Radar.palletSquares, d)
    end
end

local function Radar_hideAll()
    if not DrawingAvailable then return end
    Radar.bg.Visible           = false
    Radar.circleBg.Visible     = false
    Radar.border.Visible       = false
    Radar.circleBorder.Visible = false
    Radar.center.Visible       = false
    Radar.cross1.Visible       = false
    Radar.cross2.Visible       = false
    for _, d in pairs(Radar.dots) do if d then d.Visible = false end end
    for _, d in pairs(Radar.objectDots) do if d then d.Visible = false end end
    for _, d in pairs(Radar.palletSquares) do if d then d.Visible = false end end
end

local function Radar_step(cam)
    if not DrawingAvailable then return end
    if not VD.RADAR_Enabled then
        Radar_hideAll(); return
    end

    local size   = VD.RADAR_Size
    local pos    = Vector2.new(cam.ViewportSize.X - size - 20, 20)
    local center = pos + Vector2.new(size / 2, size / 2)

    if VD.RADAR_Circle then
        Radar.bg.Visible = false; Radar.border.Visible = false
        Radar.circleBg.Position = center; Radar.circleBg.Radius = size / 2; Radar.circleBg.Visible = true
        Radar.circleBorder.Position = center; Radar.circleBorder.Radius = size / 2; Radar.circleBorder.Visible = true
    else
        Radar.circleBg.Visible = false; Radar.circleBorder.Visible = false
        Radar.bg.Position = pos; Radar.bg.Size = Vector2.new(size, size); Radar.bg.Visible = true
        Radar.border.Position = pos; Radar.border.Size = Vector2.new(size, size); Radar.border.Visible = true
    end

    Radar.cross1.From = Vector2.new(center.X, pos.Y + 10); Radar.cross1.To = Vector2.new(center.X, pos.Y + size - 10); Radar.cross1.Visible = true
    Radar.cross2.From = Vector2.new(pos.X + 10, center.Y); Radar.cross2.To = Vector2.new(pos.X + size - 10, center.Y); Radar.cross2.Visible = true

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myLook = cam.CFrame.LookVector
    if not myRoot then
        Radar.center.Visible = false
        for _, d in pairs(Radar.dots) do if d then d.Visible = false end end
        for _, d in pairs(Radar.objectDots) do if d then d.Visible = false end end
        for _, d in pairs(Radar.palletSquares) do if d then d.Visible = false end end
        return
    end

    local myAngle                = math.atan2(-myLook.X, -myLook.Z)
    local cosA, sinA             = math.cos(myAngle), math.sin(myAngle)
    local scale                  = (size / 2 - 10) / 150
    local maxD                   = size / 2 - 8
    local idx, objIdx, palletIdx = 1, 1, 1

    local function worldToRadar(px, pz)
        local rx, rz = px - myRoot.Position.X, pz - myRoot.Position.Z
        local dist2D = math.sqrt(rx * rx + rz * rz)
        if dist2D >= 150 then return nil end
        local rotX           = rx * cosA - rz * sinA
        local rotZ           = rx * sinA + rz * cosA
        local radarX, radarY = rotX * scale, rotZ * scale
        local rDist          = math.sqrt(radarX * radarX + radarY * radarY)
        if rDist > maxD then radarX, radarY = radarX / rDist * maxD, radarY / rDist * maxD end
        return center + Vector2.new(radarX, radarY)
    end

    -- Killer dots
    if VD.RADAR_Killer then
        for _, player in ipairs(Players:GetPlayers()) do
            if not (player == LocalPlayer or not IsKiller(player)) then
                if idx > #Radar.dots then break end
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local dotPos = worldToRadar(root.Position.X, root.Position.Z)
                    if dotPos then
                        local dot    = Radar.dots[idx]
                        local head   = char:FindFirstChild("Head")
                        local eAngle = head and
                            math.atan2(-head.CFrame.LookVector.X, -head.CFrame.LookVector.Z) - myAngle or
                            0
                        local eFwd   = Vector2.new(-math.sin(eAngle), -math.cos(eAngle))
                        local eRight = Vector2.new(-eFwd.Y, eFwd.X)
                        if dot then
                            dot.PointA  = dotPos + eFwd * 5
                            dot.PointB  = dotPos - eFwd * 2.5 + eRight * 2.5
                            dot.PointC  = dotPos - eFwd * 2.5 - eRight * 2.5
                            dot.Color   = Color3.fromRGB(255, 65, 65)
                            dot.Visible = true
                        end
                        idx = idx + 1
                    end
                end
            end
        end
    end

    -- Survivor dots
    if VD.RADAR_Survivor then
        for _, player in ipairs(Players:GetPlayers()) do
            if not (player == LocalPlayer or not IsSurvivor(player)) then
                if idx > #Radar.dots then break end
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local dotPos = worldToRadar(root.Position.X, root.Position.Z)
                    if dotPos then
                        local dot    = Radar.dots[idx]
                        local head   = char:FindFirstChild("Head")
                        local eAngle = head and
                            math.atan2(-head.CFrame.LookVector.X, -head.CFrame.LookVector.Z) - myAngle or
                            0
                        local eFwd   = Vector2.new(-math.sin(eAngle), -math.cos(eAngle))
                        local eRight = Vector2.new(-eFwd.Y, eFwd.X)
                        if dot then
                            dot.PointA  = dotPos + eFwd * 5
                            dot.PointB  = dotPos - eFwd * 2.5 + eRight * 2.5
                            dot.PointC  = dotPos - eFwd * 2.5 - eRight * 2.5
                            dot.Color   = Color3.fromRGB(65, 220, 130)
                            dot.Visible = true
                        end
                        idx = idx + 1
                    end
                end
            end
        end
    end
    if VD.RADAR_Generator then
        for _, gen in ipairs(NEX_Cache.Generators) do
            if objIdx > #Radar.objectDots then break end
            if gen.part and gen.part.Parent then
                local dotPos = worldToRadar(gen.part.Position.X, gen.part.Position.Z)
                if dotPos then
                    local dot = Radar.objectDots[objIdx]
                    if dot then
                        dot.Position = dotPos; dot.Radius = 3; dot.Color = Color3.fromRGB(255, 180, 50); dot.Visible = true
                    end
                    objIdx = objIdx + 1
                end
            end
        end
    end

    -- Pallet squares
    if VD.RADAR_Pallet then
        for _, pallet in ipairs(NEX_Cache.Pallets) do
            if palletIdx > #Radar.palletSquares then break end
            if pallet.part and pallet.part.Parent then
                local dotPos = worldToRadar(pallet.part.Position.X, pallet.part.Position.Z)
                if dotPos then
                    local sq = Radar.palletSquares[palletIdx]
                    if sq then
                        sq.Position = dotPos - Vector2.new(2.5, 2.5)
                        sq.Size     = Vector2.new(5, 5)
                        sq.Color    = Color3.fromRGB(220, 180, 100)
                        sq.Visible  = true
                    end
                    palletIdx = palletIdx + 1
                end
            end
        end
    end

    -- Hide unused slots
    for i = idx, #Radar.dots do if Radar.dots[i] then Radar.dots[i].Visible = false end end
    for i = objIdx, #Radar.objectDots do if Radar.objectDots[i] then Radar.objectDots[i].Visible = false end end
    for i = palletIdx, #Radar.palletSquares do if Radar.palletSquares[i] then Radar.palletSquares[i].Visible = false end end

    Radar.center.PointA = center + Vector2.new(0, -8)
    Radar.center.PointB = center + Vector2.new(-4, 4)
    Radar.center.PointC = center + Vector2.new(4, 4)
    Radar.center.Visible = true
end

-- =====================================================
-- AIMBOT (Camera-based) + Spear Aimbot
-- =====================================================
local Aimbot = {}
local State  = { AimTarget = nil, AimHolding = false }

function Aimbot.GetClosestTarget(cam)
    if not cam then return nil end
    if GetRole() ~= "Survivor" then return nil end

    local root = Root
    if not root then return nil end

    local closestPlayer = nil
    local closestDist   = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsKiller(player) and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (tr.Position - root.Position).Magnitude
                
                local passVis = true
                if VD.AIM_VisCheck then
                    local camPos = cam.CFrame.Position
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    params.FilterDescendantsInstances = { cam, LocalPlayer.Character, player.Character }
                    local ray = workspace:Raycast(camPos, tr.Position - camPos, params)
                    passVis = (ray == nil)
                end

                if passVis and dist < closestDist then
                    closestDist = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

function Aimbot.GetPredictedPosition(target, targetPart)
    if not target or not targetPart then return nil end
    local pos = targetPart.Position
    if VD.AIM_Predict then
        local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if root then pos = pos + root.AssemblyLinearVelocity * 0.1 end
    end
    return pos
end

function Aimbot.AimAt(cam, targetPos)
    if not cam or not targetPos then return end
    local cur    = cam.CFrame
    local smooth = VD.AIM_Smooth or 0.3
    cam.CFrame   = cur:Lerp(CFrame.new(cur.Position, targetPos), smooth)
end

function Aimbot.Update(cam, screenSize, screenCenter)
    if not VD.AIM_Enabled or GetRole() ~= "Survivor" then
        State.AimTarget = nil; return
    end
    if VD.AIM_UseRMB and not State.AimHolding then
        State.AimTarget = nil; return
    end
    local target = Aimbot.GetClosestTarget(cam)
    State.AimTarget = target
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local pred = Aimbot.GetPredictedPosition(target, tr)
            if pred then Aimbot.AimAt(cam, pred) end
        end
    end
end

-- Spear Aimbot (gravity compensation)
local function SpearAimbotCalc(targetPos)
    if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return nil end
    local root = Root
    if not root then return nil end
    local startPos = root.Position + Vector3.new(0, 2, 0)
    local distance = (targetPos - startPos).Magnitude
    local gravity  = VD.SPEAR_Gravity or 50
    local speed    = VD.SPEAR_Speed or 100
    local time     = distance / speed
    local drop     = 0.5 * gravity * time * time
    return targetPos + Vector3.new(0, drop, 0)
end

local function UpdateSpearAim()
    if not VD.SPEAR_Aimbot or GetRole() ~= "Killer" then return end
    local root = Root
    if not root then return end
    local closest, closestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsSurvivor(player) and player.Character then
            local tr = player.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local dist = (tr.Position - root.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist; closest = player
                end
            end
        end
    end
    if closest and closest.Character then
        local tr = closest.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local aimPos = SpearAimbotCalc(tr.Position)
            if aimPos then
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, aimPos) end
            end
        end
    end
end

-- Input handling for Aimbot RMB & Touch (Mobile Support)
UserInputService.InputBegan:Connect(function(input, gpe)
    if State.Unloaded then return end
    if VD.AIM_Enabled and VD.AIM_UseRMB then
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            State.AimHolding = true
        elseif input.UserInputType == Enum.UserInputType.Touch and not gpe then
            State.AimHolding = true
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if State.Unloaded then return end
    if VD.AIM_Enabled and VD.AIM_UseRMB then
        if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = false
            State.AimTarget  = nil
        end
    end
end)

-- =====================================================
-- QTE / SKILLCHECK MONITOR (AUTO_SkillCheck) BYPASS
-- =====================================================
local ActiveQTEGenerator = nil
local ActiveQTEPoint     = nil

local function HookIncomingSkillCheck()
    pcall(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
        if not remotes then return end
        local genRemotes = remotes:WaitForChild("Generator", 5)
        if not genRemotes then return end
        local scEvent = genRemotes:WaitForChild("SkillCheckEvent", 5)

        if scEvent then
            scEvent.OnClientEvent:Connect(function(gen, point)
                ActiveQTEGenerator = gen
                ActiveQTEPoint     = point

                if VD.AUTO_SkillCheck and GetRole() == "Survivor" then
                    -- Execute auto skill check after a short realistic delay
                    task.delay(0.2, function()
                        local resEvent = genRemotes:FindFirstChild("SkillCheckResultEvent")
                        if resEvent and ActiveQTEGenerator == gen then
                            warn("QTE: [BERHASIL] Mengeksekusi Remote SkillCheckResultEvent secara langsung!")
                            resEvent:FireServer("success", 1, gen, point)

                            -- Force hide UI locally so they don't see it spinning
                            pcall(function()
                                local pg     = LocalPlayer:FindFirstChild("PlayerGui")
                                local prompt = pg and pg:FindFirstChild("SkillCheckPromptGui")
                                if prompt and prompt:FindFirstChild("Check") then
                                    prompt.Check.Visible = false
                                end
                            end)

                            ActiveQTEGenerator = nil
                            ActiveQTEPoint     = nil
                        end
                    end)
                end
            end)
        end
    end)
end
task.spawn(HookIncomingSkillCheck)

-- =====================================================
-- FORCE LEAVE GENERATOR (Cancel generator interaction)
-- Tekan X (PC) atau klik tombol di UI untuk keluar dari generator
-- =====================================================
function NEX_ForceLeaveGenerator()
    local root = Root
    if not root then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Simpan state dan matikan auto skill check
    local wasAutoSC = VD.AUTO_SkillCheck
    VD.AUTO_SkillCheck = false

    task.spawn(function()
        -- Step 1: Fire RepairEvent dengan false untuk cancel generator
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local genRemotes = remotes and remotes:FindFirstChild("Generator")
            if genRemotes then
                local repairEvent = genRemotes:FindFirstChild("RepairEvent")
                if repairEvent then
                    -- Coba fire untuk ActiveQTEPoint jika ada
                    if ActiveQTEPoint then
                        repairEvent:FireServer(ActiveQTEPoint, false)
                    end
                    
                    -- Coba fire untuk semua Generator dekat pemain sebagai fallback
                    if NEX_Cache and NEX_Cache.Generators then
                        for _, gen in ipairs(NEX_Cache.Generators) do
                            if gen.part and (gen.part.Position - root.Position).Magnitude < 15 then
                                repairEvent:FireServer(gen.part, false)
                                
                                -- Kadang point bernama GeneratorPoint1, GeneratorPoint2, dst
                                local parent = gen.part.Parent
                                if parent then
                                    for _, child in ipairs(parent:GetChildren()) do
                                        if child:IsA("BasePart") and child.Name:find("GeneratorPoint") then
                                            repairEvent:FireServer(child, false)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        -- Bersihkan state QTE aktif
        ActiveQTEGenerator = nil
        ActiveQTEPoint = nil

        -- Step 2: Mundur sedikit dengan menggerakkan Humanoid langsung
        pcall(function()
            hum:Move(Vector3.new(0, 0, -1), true)
        end)
        task.wait(0.2)
        pcall(function()
            hum:Move(Vector3.new(0, 0, 0), true)
        end)

        -- Step 3: Sembunyikan UI skill check
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                local p1 = pg:FindFirstChild("SkillCheckPromptGui")
                local p2 = pg:FindFirstChild("SkillCheckPromptGui-con")
                if p1 then p1.Enabled = false end
                if p2 then p2.Enabled = false end
            end
        end)

        print("[VD] Force Leave Generator executed")

        -- Re-enable auto skill check setelah delay
        if wasAutoSC then
            task.delay(1.5, function()
                VD.AUTO_SkillCheck = true
                print("[VD] Auto SkillCheck aktif kembali")
            end)
        end
    end)
end

-- Keybind X untuk force leave generator (PC only)
if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.X then
            pcall(NEX_ForceLeaveGenerator)
        end
    end)
end

function SetupSkillCheckNamecallHook()
    local ok, mt = pcall(function() return getrawmetatable(game) end)
    if ok and mt and setreadonly then
        pcall(function()
            setreadonly(mt, false)
            local old     = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if not checkcaller() and VD.AUTO_SkillCheck and GetRole() == "Survivor" then
                    local method = getnamecallmethod()
                    if method == "FireServer" and tostring(self) == "SkillCheckResultEvent" then
                        local args = { ... }
                        if args[1] ~= "success" then
                            warn("QTE: [TERTAHAN] Mencegah pengiriman 'fail' ke server, otomatis diubah menjadi 'success'!")
                            args[1] = "success"
                            args[2] = 1
                            if ActiveQTEGenerator and not args[3] then args[3] = ActiveQTEGenerator end
                            if ActiveQTEPoint and not args[4] then args[4] = ActiveQTEPoint end
                        end
                        ActiveQTEGenerator = nil
                        ActiveQTEPoint     = nil
                        return old(self, unpack(args))
                    end
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end)
    end
end
pcall(SetupSkillCheckNamecallHook)

-- =====================================================
-- NO PALLET STUN (metamethod hook)
-- =====================================================
function SetupNoPalletStun()
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        if not r then return end
        local p = r:FindFirstChild("Pallet")
        local j = p and p:FindFirstChild("Jason")
        if not j then return end
        local stun     = j:FindFirstChild("Stun")
        local stunDrop = j:FindFirstChild("StunDrop")
        if not (stun and stun:IsA("RemoteEvent")) then return end

        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local old = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    if VD.KILLER_NoPalletStun and (self == stun or self == stunDrop) then
                        return nil
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
pcall(SetupNoPalletStun)

-- =====================================================
-- ANTI FALL DAMAGE (metamethod hook)
-- =====================================================
function SetupAntiFallDamage()
    pcall(function()
        local r = ReplicatedStorage:FindFirstChild("Remotes")
        if not r then return end
        local m = r:FindFirstChild("Mechanics")
        local fallEvent = m and m:FindFirstChild("Fall")
        if not (fallEvent and fallEvent:IsA("RemoteEvent")) then return end

        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local old = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    if not checkcaller() and VD.SURV_NoFall and self == fallEvent then
                        local method = getnamecallmethod()
                        if method == "FireServer" then
                            return nil -- Block fall damage report ke server
                        end
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
pcall(SetupAntiFallDamage)-- =====================================================
-- ANTI BLIND (Flashlight)
-- =====================================================
function SetupAntiBlind()
    pcall(function()
        local r  = ReplicatedStorage:FindFirstChild("Remotes")
        local i  = r and r:FindFirstChild("Items")
        local fl = i and i:FindFirstChild("Flashlight")
        local gb = fl and fl:FindFirstChild("GotBlinded")
        if not (gb and gb:IsA("RemoteEvent")) then return end
        
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local old = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    if not checkcaller() and VD.KILLER_AntiBlind and self == gb then
                        local method = getnamecallmethod()
                        if method == "FireServer" and GetRole() == "Killer" then
                            return nil -- Block pengiriman sinyal buta
                        end
                    end
                    return old(self, ...)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
pcall(SetupAntiBlind)

-- =====================================================
-- CAMERA / FOV / THIRD PERSON / SHIFT LOCK
-- =====================================================
local OriginalFOV          = nil
local OriginalCameraType   = nil
local ThirdPersonWasActive = false

local function UpdateCameraFOV()
    local cam = workspace.CurrentCamera
    if not cam then return end
    if not OriginalFOV then OriginalFOV = cam.FieldOfView end
    cam.FieldOfView = VD.CAM_FOVEnabled and (VD.CAM_FOV or 90) or OriginalFOV
end

local function UpdateThirdPerson()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local shouldBeActive = VD.CAM_ThirdPerson and GetRole() == "Killer"
    if shouldBeActive then
        if not ThirdPersonWasActive then OriginalCameraType = cam.CameraType end
        cam.CameraType = Enum.CameraType.Custom
        local char     = LocalPlayer.Character
        local hum      = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.new(2, 1, 8) end
        ThirdPersonWasActive = true
    elseif ThirdPersonWasActive then
        if OriginalCameraType then
            cam.CameraType = OriginalCameraType; OriginalCameraType = nil
        end
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
        ThirdPersonWasActive = false
    end
end

local function UpdateShiftLock()
    if not VD.CAM_ShiftLock then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local cam  = workspace.CurrentCamera
    if not root or not cam then return end
    local flatLook = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit
    root.CFrame    = CFrame.new(root.Position, root.Position + flatLook)
end

-- =====================================================
-- NO FOG
-- =====================================================
local FogCache = {}

local function RemoveFog()
    pcall(function()
        local map = Workspace:FindFirstChild("Map")
        if map then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name:lower():find("fog") or obj:IsA("Atmosphere") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                    if not FogCache[obj] then
                        FogCache[obj] = {
                            enabled = obj:IsA("PostEffect") and obj.Enabled or true,
                            parent =
                                obj.Parent
                        }
                    end
                    if obj:IsA("PostEffect") then obj.Enabled = false else obj.Parent = nil end
                end
            end
        end
    end)
    pcall(function()
        local lt = game:GetService("Lighting")
        for _, obj in ipairs(lt:GetChildren()) do
            if obj:IsA("Atmosphere") or obj.Name:lower():find("fog") then
                if not FogCache[obj] then FogCache[obj] = { enabled = true, parent = obj.Parent } end
                if obj:IsA("Atmosphere") then obj.Density = 0 else obj.Parent = nil end
            end
        end
        lt.FogEnd   = 100000
        lt.FogStart = 0
    end)
end

local function RestoreFog()
    pcall(function()
        for obj, data in pairs(FogCache) do
            if obj and data.parent then
                if obj:IsA("PostEffect") then obj.Enabled = data.enabled else obj.Parent = data.parent end
            end
        end
        FogCache = {}
        game:GetService("Lighting").FogEnd = 1000
    end)
end

-- =====================================================
-- NO FALL / NO SLOWDOWN
-- =====================================================
local function UpdateNoFall()
    if not VD.SURV_NoFall then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end
end

local function UpdateNoSlowdown()
    if not VD.KILLER_NoSlowdown or GetRole() ~= "Killer" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed < 16 then hum.WalkSpeed = VD.SPEED_Value or 16 end
end

-- =====================================================
-- KUNCI KECEPATAN / ANTI BEKU (__newindex Hook)
-- =====================================================
function SetupAntiStunSlowdown()
    pcall(function()
        local ok, mt = pcall(function() return getrawmetatable(game) end)
        if ok and mt and setreadonly then
            pcall(function()
                setreadonly(mt, false)
                local oldNI = mt.__newindex
                mt.__newindex = newcclosure(function(t, k, v)
                    if not checkcaller() and VD.KILLER_NoSlowdown and GetRole() == "Killer" then
                        -- Cegah perintah yang mengurangi WalkSpeed drastis (Efek Stun/Kesandung)
                        if k == "WalkSpeed" and typeof(v) == "number" and v < 16 and typeof(t) == "Instance" and t:IsA("Humanoid") then
                            return oldNI(t, k, VD.SPEED_Value or 16)
                        end
                        -- Cegah perintah yang membekukan posisi karakter (Anchored Stun)
                        if k == "Anchored" and v == true and typeof(t) == "Instance" and t:IsA("BasePart") and t.Name == "HumanoidRootPart" then
                            return oldNI(t, k, false)
                        end
                    end
                    return oldNI(t, k, v)
                end)
                setreadonly(mt, true)
            end)
        end
    end)
end
task.spawn(SetupAntiStunSlowdown)

-- =====================================================
-- FLY
-- =====================================================
local FlyBodyVelocity = nil
local FlyBodyGyro     = nil

local function UpdateFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if VD.FLY_Enabled then
        hum.PlatformStand = true
        if not FlyBodyVelocity then
            FlyBodyVelocity          = Instance.new("BodyVelocity")
            FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyVelocity.Velocity = Vector3.zero
            FlyBodyVelocity.Parent   = root
        end
        if not FlyBodyGyro then
            FlyBodyGyro           = Instance.new("BodyGyro")
            FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlyBodyGyro.P         = 9e4
            FlyBodyGyro.Parent    = root
        end
        local cam     = workspace.CurrentCamera
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * (VD.FLY_Speed or 50) end

        if VD.FLY_Method == "Velocity" then
            FlyBodyVelocity.Velocity = moveDir
        else
            FlyBodyVelocity.Velocity = Vector3.zero
            if moveDir.Magnitude > 0 then root.CFrame = root.CFrame + moveDir * 0.05 end
        end
        FlyBodyGyro.CFrame = cam.CFrame
    else
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy(); FlyBodyVelocity = nil
        end
        if FlyBodyGyro then
            FlyBodyGyro:Destroy(); FlyBodyGyro = nil
        end
        hum.PlatformStand = false
    end
end

-- =====================================================
-- FOV CIRCLE
-- =====================================================
local FOVCircle = nil
if DrawingAvailable then
    FOVCircle = SafeDrawing("Circle")
    if FOVCircle then
        FOVCircle.Thickness    = 1
        FOVCircle.Color        = Color3.fromRGB(220, 70, 70)
        FOVCircle.Filled       = false
        FOVCircle.NumSides     = 64
        FOVCircle.Transparency = 0.8
        FOVCircle.Visible      = false
    end
end

-- =====================================================
-- RENDERSTEP: Drawing ESP / Radar / Aimbot / Camera
-- =====================================================
local function OnRenderStep()
    if VD.Destroyed then
        if DrawingAvailable then
            for _, esp in pairs(DrawingESP.cache) do
                if esp then
                    for _, l in ipairs(esp.Box) do if l then SafeRemove(l) end end
                    for _, l in ipairs(esp.Skel) do if l then SafeRemove(l) end end
                    if esp.Name then SafeRemove(esp.Name) end
                    if esp.Dist then SafeRemove(esp.Dist) end
                    if esp.HealthBg then SafeRemove(esp.HealthBg) end
                    if esp.HealthBar then SafeRemove(esp.HealthBar) end
                    if esp.Offscreen then SafeRemove(esp.Offscreen) end
                    if esp.VelLine then SafeRemove(esp.VelLine) end
                    if esp.VelArrow then SafeRemove(esp.VelArrow) end
                end
            end
            DrawingESP.cache = {}
            Chams.ClearAll()
            Radar_hideAll()
            if FOVCircle then SafeRemove(FOVCircle) end
        end
        return
    end

    Camera = Workspace.CurrentCamera or Camera
    local cam = Camera
    if not cam then return end
    local screenSize   = cam.ViewportSize
    local screenCenter = Vector2.new(screenSize.X / 2, screenSize.Y / 2)

    -- Drawing ESP & Chams
    if DrawingAvailable then
        if VD.DRAWING_ESP then
            DrawingESP_cleanup()

            -- Players
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not DrawingESP.cache[player] then
                        DrawingESP.cache[player] = DrawingESP_create()
                        DrawingESP_setup(DrawingESP.cache[player])
                    end
                    DrawingESP_render(DrawingESP.cache[player], player, player.Character, cam, screenSize, screenCenter)
                end
            end

            -- Object ESP helper
            local function renderObj(cacheList, objList, label, fillCol, outlineCol, fillTrans, espCol)
                for _, obj in ipairs(objList) do
                    local target = obj.model or obj.part
                    local dist   = Root and (obj.part.Position - Root.Position).Magnitude or 0
                    if VD.ESP_ObjectChams then
                        local cd = { fill = fillCol, outline = outlineCol, fillTrans = fillTrans }
                        if not Chams.Objects[target] then
                            Chams.Create(target, cd, label)
                        else
                            Chams.SetColor(target, cd)
                        end
                        Chams.Update(target, label, dist)
                    else
                        local key = tostring(target)
                        if not cacheList[key] then
                            cacheList[key] = DrawingESP_create()
                            DrawingESP_setup(cacheList[key])
                        end
                        DrawingESP_renderObject(cacheList[key], obj.part.Position, label, espCol, cam)
                        Chams.Remove(target)
                    end
                end
            end

            local oc = DrawingESP.objectCache
            renderObj(oc, NEX_Cache.Generators, "GEN", Color3.fromRGB(200, 140, 30), Color3.fromRGB(255, 200, 80), 0.5,
                Color3.fromRGB(255, 180, 50))
            renderObj(oc, NEX_Cache.Gates, "GATE", Color3.fromRGB(150, 150, 170), Color3.fromRGB(220, 220, 255), 0.5,
                Color3.fromRGB(200, 200, 220))
            renderObj(oc, NEX_Cache.Pallets, "PALLET", Color3.fromRGB(180, 140, 70), Color3.fromRGB(255, 210, 130), 0.5,
                Color3.fromRGB(220, 180, 100))
            renderObj(oc, NEX_Cache.Windows, "WINDOW", Color3.fromRGB(60, 140, 200), Color3.fromRGB(120, 200, 255), 0.5,
                Color3.fromRGB(100, 180, 255))

            -- Hooks (special: closest gets different color/label)
            for _, obj in ipairs(NEX_Cache.Hooks) do
                local target    = obj.model or obj.part
                local isClosest = VD.ESP_ClosestHook and obj == NEX_Cache.ClosestHook
                local label     = isClosest and "HOOK!" or "HOOK"
                local fillCol   = isClosest and Color3.fromRGB(200, 180, 40) or Color3.fromRGB(180, 60, 60)
                local outCol    = isClosest and Color3.fromRGB(255, 240, 100) or Color3.fromRGB(255, 100, 100)
                local espCol    = isClosest and Color3.fromRGB(255, 230, 80) or Color3.fromRGB(255, 100, 100)
                local trans     = isClosest and 0.4 or 0.5
                local dist      = Root and (obj.part.Position - Root.Position).Magnitude or 0
                if VD.ESP_ObjectChams then
                    local cd = { fill = fillCol, outline = outCol, fillTrans = trans }
                    if not Chams.Objects[target] then
                        Chams.Create(target, cd, label)
                    else
                        Chams.SetColor(target, cd)
                    end
                    Chams.Update(target, label, dist)
                else
                    local key = tostring(target)
                    if not DrawingESP.objectCache[key] then
                        DrawingESP.objectCache[key] = DrawingESP_create()
                        DrawingESP_setup(DrawingESP.objectCache[key])
                    end
                    DrawingESP_renderObject(DrawingESP.objectCache[key], obj.part.Position, label, espCol, cam)
                    Chams.Remove(target)
                end
            end
        else
            -- Clear all drawing objects when Drawing ESP is disabled
            for _, esp in pairs(DrawingESP.cache) do
                if esp then
                    pcall(function()
                        for _, l in ipairs(esp.Box) do if l then SafeRemove(l) end end
                        for _, l in ipairs(esp.Skel) do if l then SafeRemove(l) end end
                        if esp.Name then SafeRemove(esp.Name) end
                        if esp.Dist then SafeRemove(esp.Dist) end
                        if esp.HealthBg then SafeRemove(esp.HealthBg) end
                        if esp.HealthBar then SafeRemove(esp.HealthBar) end
                        if esp.Offscreen then SafeRemove(esp.Offscreen) end
                        if esp.VelLine then SafeRemove(esp.VelLine) end
                        if esp.VelArrow then SafeRemove(esp.VelArrow) end
                    end)
                end
            end
            DrawingESP.cache       = {}
            DrawingESP.objectCache = {}
            -- JANGAN clear Chams disini: dikelola oleh UpdateObjectChams() di Heartbeat
            -- Chams.ClearAll() -- ini penyebab Object Chams hilang di PC
        end

        Radar_step(cam)
    else
        Chams.ClearAll()
        if DrawingAvailable then Radar_hideAll() end
    end

    -- Aimbot
    pcall(function()
        if VD.AIM_Enabled then
            Aimbot.Update(cam, cam.ViewportSize, Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2))
        end
    end)

    pcall(UpdateSpearAim)
    UpdateCameraFOV()
    UpdateThirdPerson()
    UpdateShiftLock()

    -- FOV circle
    if FOVCircle and DrawingAvailable then
        if VD.AIM_Enabled and VD.AIM_ShowFOV then
            FOVCircle.Position = screenCenter
            FOVCircle.Radius   = VD.AIM_FOV or 120
            FOVCircle.Color    = State.AimTarget and Color3.fromRGB(90, 220, 120) or Color3.fromRGB(220, 70, 70)
            FOVCircle.Visible  = true
        else
            FOVCircle.Visible = false
        end
    end
end

-- =====================================================
-- OBJECT CHAMS UPDATE (Highlight-based, bekerja di PC & Mobile)
-- =====================================================
local function UpdateObjectChams()
    if not VD.ESP_ObjectChams then
        Chams.ClearAll(); return
    end

    local function chamObj(objList, isOn, fCol, oCol, fTrans)
        for _, obj in ipairs(objList) do
            local target = obj.model or obj.part
            if target then
                if isOn and target.Parent then
                    local cd = { fill = fCol, outline = oCol, fillTrans = fTrans }
                    if not Chams.Objects[target] then Chams.Create(target, cd, " ")
                    else Chams.SetColor(target, cd) end
                    
                    local activeLabel = nil
                    if obj.model and obj.model.Name == "Generator" then
                        local progress = tonumber(obj.model:GetAttribute("RepairProgress")) or 0
                        activeLabel = math.floor(progress) .. "%"
                        if progress >= 100 then
                            cd.fill = Color3.new(0, 1, 0)
                            Chams.SetColor(target, cd)
                        end
                    end
                    
                    Chams.Update(target, activeLabel, nil)
                else
                    if Chams.Objects[target] then Chams.Remove(target) end
                end
            end
        end
    end

    chamObj(NEX_Cache.Generators, VD.ESP_Obj_Generator, Color3.fromRGB(0, 255, 255), Color3.new(1,1,1), 0.5)
    chamObj(NEX_Cache.Gates,      VD.ESP_Obj_Gate,      Color3.fromRGB(150,150,170), Color3.fromRGB(220,220,255), 0.5)
    chamObj(NEX_Cache.Pallets,    VD.ESP_Obj_Pallet,    Color3.fromRGB(180,140,70),  Color3.fromRGB(255,210,130), 0.5)
    chamObj(NEX_Cache.Windows,    VD.ESP_Obj_Window,    Color3.fromRGB(60,140,200),  Color3.fromRGB(120,200,255), 0.5)

    -- Hook has logic for closest hook
    for _, obj in ipairs(NEX_Cache.Hooks) do
        local target = obj.model or obj.part
        if VD.ESP_Obj_Hook and target and target.Parent then
            local isClose  = VD.ESP_ClosestHook and obj == NEX_Cache.ClosestHook
            local cd = {
                fill     = isClose and Color3.fromRGB(200,180,40)  or Color3.fromRGB(180,60,60),
                outline  = isClose and Color3.fromRGB(255,240,100) or Color3.fromRGB(255,100,100),
                fillTrans = isClose and 0.4 or 0.5
            }
            if not Chams.Objects[target] then Chams.Create(target, cd, " ")
            else Chams.SetColor(target, cd) end
            Chams.Update(target, nil, nil)
        else
            if Chams.Objects[target] then Chams.Remove(target) end
        end
    end
end

-- =====================================================
-- MOBILE GUI (Radar + Aimbot Button + FOV Circle)
-- =====================================================
local MobileGui = { RadarFrame=nil, RadarDots={}, RadarObjDots={}, AimBtn=nil, FOVFrame=nil, FOVStroke=nil }

local function CreateMobileUI()
    local pg = GetSafeGuiParent()
    if not pg then return end

    -- === MAIN SCREENGUI ===
    local sg = Instance.new("ScreenGui")
    sg.Name           = "NEX_MobileUI"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 100
    sg.Parent         = pg

    -- === RADAR ===
    local RS = VD.RADAR_Size or 130
    local radarF = Instance.new("Frame")
    radarF.Name                    = "Radar"
    radarF.Size                    = UDim2.new(0, RS, 0, RS)
    radarF.Position                = UDim2.new(0, 20, 0, 120) -- Pindah ke Kiri agar tak tertutup Perks
    radarF.BackgroundColor3        = Color3.fromRGB(15,15,15)
    radarF.BackgroundTransparency  = 0.3
    radarF.BorderSizePixel         = 0
    radarF.Visible                 = false
    radarF.Parent                  = sg
    local radarCorner = Instance.new("UICorner", radarF)
    radarCorner.Name = "RCorner"
    radarCorner.CornerRadius = UDim.new(0, 5) -- Default kotak
    local rStroke = Instance.new("UIStroke")
    rStroke.Color = Color3.fromRGB(220,60,60); rStroke.Thickness = 2; rStroke.Parent = radarF
    -- Crosshair
    local ch = Instance.new("Frame")
    ch.Size = UDim2.new(1,-20,0,1); ch.Position = UDim2.new(0,10,0.5,0)
    ch.BackgroundColor3 = Color3.fromRGB(45,45,45); ch.BorderSizePixel = 0; ch.Parent = radarF
    local cv = Instance.new("Frame")
    cv.Size = UDim2.new(0,1,1,-20); cv.Position = UDim2.new(0.5,0,0,10)
    cv.BackgroundColor3 = Color3.fromRGB(45,45,45); cv.BorderSizePixel = 0; cv.Parent = radarF
    -- Center player dot
    local cdot = Instance.new("Frame")
    cdot.Size = UDim2.new(0,10,0,10); cdot.Position = UDim2.new(0.5,-5,0.5,-5)
    cdot.BackgroundColor3 = Color3.fromRGB(0,255,0); cdot.BorderSizePixel = 0
    cdot.ZIndex = 5; cdot.Parent = radarF
    Instance.new("UICorner", cdot).CornerRadius = UDim.new(1,0)
    MobileGui.RadarFrame = radarF
    -- Player dots (20)
    for i = 1, 20 do
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0,8,0,8); d.BackgroundColor3 = Color3.fromRGB(255,65,65)
        d.BorderSizePixel = 0; d.ZIndex = 4; d.Visible = false; d.Parent = radarF
        Instance.new("UICorner", d).CornerRadius = UDim.new(1,0)
        MobileGui.RadarDots[i] = d
    end
    -- Object dots (30)
    for i = 1, 30 do
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0,6,0,6); d.BackgroundColor3 = Color3.fromRGB(255,180,50)
        d.BorderSizePixel = 0; d.ZIndex = 3; d.Visible = false; d.Parent = radarF
        Instance.new("UICorner", d).CornerRadius = UDim.new(1,0)
        MobileGui.RadarObjDots[i] = d
    end

    -- === FOV CIRCLE ===
    local fovF = Instance.new("Frame")
    fovF.Name                 = "FOVCircle"
    fovF.BackgroundTransparency = 1
    fovF.AnchorPoint          = Vector2.new(0.5,0.5)
    fovF.Position             = UDim2.new(0.5,0,0.5,0)
    fovF.Size                 = UDim2.new(0,240,0,240)
    fovF.Visible              = false
    fovF.Parent               = sg
    Instance.new("UICorner", fovF).CornerRadius = UDim.new(1,0)
    local fovStk = Instance.new("UIStroke")
    fovStk.Color = Color3.fromRGB(220,70,70); fovStk.Thickness = 1.5; fovStk.Transparency = 0.2
    fovStk.Parent = fovF
    MobileGui.FOVFrame = fovF; MobileGui.FOVStroke = fovStk

    -- === AIMBOT BUTTON (ScreenGui terpisah agar AlwaysOnTop) ===
    local aimSG = Instance.new("ScreenGui")
    aimSG.Name           = "NEX_AimBtn"
    aimSG.ResetOnSpawn   = false
    aimSG.IgnoreGuiInset = true
    aimSG.ZIndexBehavior = Enum.ZIndexBehavior.AlwaysOnTop
    aimSG.Parent         = pg
    local btn = Instance.new("TextButton")
    btn.Name                = "AimHold"
    btn.Size                = UDim2.new(0,75,0,75)
    btn.Position            = UDim2.new(1,-95,1,-170)
    btn.BackgroundColor3    = Color3.fromRGB(200,55,55)
    btn.BackgroundTransparency = 0.2
    btn.Text                = "🎯\nAIM"
    btn.TextColor3          = Color3.new(1,1,1)
    btn.TextSize            = 14
    btn.Font                = Enum.Font.GothamBold
    btn.Visible             = false
    btn.ZIndex              = 20
    btn.Parent              = aimSG
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local aStk = Instance.new("UIStroke")
    aStk.Color = Color3.fromRGB(255,100,100); aStk.Thickness = 2; aStk.Parent = btn

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = true
            btn.BackgroundColor3 = Color3.fromRGB(50,200,80)
            aStk.Color = Color3.fromRGB(50,230,80)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = false; State.AimTarget = nil
            btn.BackgroundColor3 = Color3.fromRGB(200,55,55)
            aStk.Color = Color3.fromRGB(255,100,100)
        end
    end)
    MobileGui.AimBtn = btn
end

local function UpdateMobileRadar(cam)
    if not MobileGui.RadarFrame then return end
    if not VD.RADAR_Enabled then MobileGui.RadarFrame.Visible = false; return end
    MobileGui.RadarFrame.Visible = true

    local rc = MobileGui.RadarFrame:FindFirstChild("RCorner")
    if rc then
        rc.CornerRadius = VD.RADAR_Circle and UDim.new(1,0) or UDim.new(0,5)
    end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myLook  = cam.CFrame.LookVector
    local myAngle = math.atan2(-myLook.X, -myLook.Z)
    local cosA, sinA = math.cos(myAngle), math.sin(myAngle)
    local RS   = VD.RADAR_Size or 130
    MobileGui.RadarFrame.Size = UDim2.new(0, RS, 0, RS)
    local half = RS / 2
    local scale = (half - 10) / 150
    local maxD  = half - 8

    local function worldToRadar(px, pz)
        local rx = px - myRoot.Position.X
        local rz = pz - myRoot.Position.Z
        if math.sqrt(rx*rx+rz*rz) >= 150 then return nil end
        local rotX = rx*cosA - rz*sinA
        local rotZ = rx*sinA + rz*cosA
        local radarX, radarY = rotX*scale, rotZ*scale
        local rDist = math.sqrt(radarX*radarX + radarY*radarY)
        if rDist > maxD then radarX,radarY = radarX/rDist*maxD, radarY/rDist*maxD end
        return Vector2.new(half+radarX, half+radarY)
    end

    local idx = 1
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and idx <= #MobileGui.RadarDots then
            local pr = player.Character:FindFirstChild("HumanoidRootPart")
            if pr then
                local isK = IsKiller(player); local isS = IsSurvivor(player)
                if (isK and VD.RADAR_Killer) or (isS and VD.RADAR_Survivor) then
                    local p = worldToRadar(pr.Position.X, pr.Position.Z)
                    if p then
                        local d = MobileGui.RadarDots[idx]
                        d.BackgroundColor3 = isK and Color3.fromRGB(255,65,65) or Color3.fromRGB(65,220,130)
                        d.Position = UDim2.new(0, p.X-4, 0, p.Y-4); d.Visible = true; idx = idx+1
                    end
                end
            end
        end
    end
    for i = idx, #MobileGui.RadarDots do MobileGui.RadarDots[i].Visible = false end

    local objIdx = 1
    if VD.RADAR_Generator then
        for _, gen in ipairs(NEX_Cache.Generators) do
            if gen.part and objIdx <= #MobileGui.RadarObjDots then
                local p = worldToRadar(gen.part.Position.X, gen.part.Position.Z)
                if p then
                    local d = MobileGui.RadarObjDots[objIdx]
                    d.BackgroundColor3 = Color3.fromRGB(255,180,50)
                    d.Position = UDim2.new(0,p.X-3,0,p.Y-3); d.Visible = true; objIdx = objIdx+1
                end
            end
        end
    end
    for i = objIdx, #MobileGui.RadarObjDots do MobileGui.RadarObjDots[i].Visible = false end
end

local function UpdateMobileFOV()
    if not MobileGui.FOVFrame then return end
    if VD.AIM_Enabled and VD.AIM_ShowFOV then
        local r = (VD.AIM_FOV or 120)
        MobileGui.FOVFrame.Size = UDim2.new(0, r*2, 0, r*2)
        MobileGui.FOVStroke.Color = State.AimTarget and Color3.fromRGB(90,220,120) or Color3.fromRGB(220,70,70)
        MobileGui.FOVFrame.Visible = true
    else
        MobileGui.FOVFrame.Visible = false
    end
end

function CreateUniversalCrosshair()
    local function GetSafeGuiParent()
        if gethui then return gethui() end
        local ok, core = pcall(function() return game:GetService("CoreGui") end)
        if ok and core then return core end
        return LocalPlayer:FindFirstChild("PlayerGui")
    end
    local pg = GetSafeGuiParent()
    if not pg then return end
    NEX_CrosshairGui = Instance.new("ScreenGui")
    NEX_CrosshairGui.Name = "NEX_Crosshair"
    NEX_CrosshairGui.ResetOnSpawn = false
    NEX_CrosshairGui.IgnoreGuiInset = true
    NEX_CrosshairGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    NEX_CrosshairGui.Parent = pg

    NEX_CrossH = Instance.new("Frame")
    NEX_CrossH.Size = UDim2.new(0, 16, 0, 2)
    NEX_CrossH.AnchorPoint = Vector2.new(0.5, 0.5)
    NEX_CrossH.Position = UDim2.new(0.5, 0, 0.5, 0)
    NEX_CrossH.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    NEX_CrossH.BorderSizePixel = 0
    NEX_CrossH.Visible = VD.AIM_Crosshair
    NEX_CrossH.Parent = NEX_CrosshairGui

    NEX_CrossV = Instance.new("Frame")
    NEX_CrossV.Size = UDim2.new(0, 2, 0, 16)
    NEX_CrossV.AnchorPoint = Vector2.new(0.5, 0.5)
    NEX_CrossV.Position = UDim2.new(0.5, 0, 0.5, 0)
    NEX_CrossV.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    NEX_CrossV.BorderSizePixel = 0
    NEX_CrossV.Visible = VD.AIM_Crosshair
    NEX_CrossV.Parent = NEX_CrosshairGui
end

task.spawn(function()
    task.wait(2)
    pcall(CreateUniversalCrosshair)
    pcall(CreateMobileUI)
end)

-- =====================================================
-- RENDER LOOP: PC (RenderStepped, pakai Drawing)
-- =====================================================
if DrawingAvailable then
    RunService.RenderStepped:Connect(OnRenderStep)
end

-- =====================================================
-- HEARTBEAT UNIVERSAL: Berjalan di PC & Mobile
-- =====================================================
RunService.Heartbeat:Connect(function()
    if VD.Destroyed then return end
    local cam = workspace.CurrentCamera
    if not cam then return end

    if not NEX_CrosshairGui or not NEX_CrosshairGui.Parent then
        pcall(CreateUniversalCrosshair)
    end
    if not DrawingAvailable and (not MobileGui.RadarFrame or not MobileGui.RadarFrame.Parent) then
        pcall(CreateMobileUI)
    end

    if not DrawingAvailable then
        UpdateCameraFOV()
        UpdateThirdPerson()
        UpdateShiftLock()
        pcall(UpdateSpearAim)
    end

    if not DrawingAvailable and VD.AIM_Enabled and State.AimHolding then
        local sc = cam.ViewportSize
        pcall(function() Aimbot.Update(cam, sc, Vector2.new(sc.X/2, sc.Y/2)) end)
    end

    pcall(UpdateObjectChams)

    if not DrawingAvailable then
        pcall(UpdateMobileRadar, cam)
        if MobileGui.AimBtn then MobileGui.AimBtn.Visible = VD.AIM_Enabled end
        pcall(UpdateMobileFOV)
    end
end)

-- End of file
