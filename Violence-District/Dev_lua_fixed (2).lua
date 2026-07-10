loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
repeat wait() until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")

local LocalPlayer       = Players.LocalPlayer
local Camera            = Workspace.CurrentCamera

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local StreeHub
local UI = {}
local STREE_CrosshairGui, STREE_CrossH, STREE_CrossV = nil, nil, nil

local IsOnMobile = isMobile
local WindowSize = IsOnMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(620, 370)

StreeHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/VFmkY17j/refs/heads/main/.lua"))()

if isMobile then UI.Mobile = true end
print("[Universal] Platform:", isMobile and "MOBILE" or "PC")

local Window
if StreeHub then
    Window = StreeHub:CreateWindow({
        Title = "StreeHub",
        Icon = "rbxassetid://99948086845842",
        Author = "Violence Distrik",
        Folder = "StreeHub",
        Size = WindowSize,
        LiveSearchDropdown = true,
        FileSaveName = "StreeHub/config.json",
    })
end

if not isMobile then
    local _cursorOn = false
    local _cursorManual = false

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
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            _setCursor(not _cursorOn)
        end
    end)

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

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if _cursorOn then _setCursor(true) end
    end)

    print("[VD] ALT Toggle Cursor Ready (PC only)")
end

local DrawingAvailable = (function()
    if isMobile then return false end
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

local function clamp(v, min, max)
    return math.max(min, math.min(max, v))
end

getgenv().VD = getgenv().VD or {
    ESP                   = false,
    MaxDistance           = 2000,
    ShowDistance          = false,
    GeneratorESP          = false,
    GenAntiFail           = false,
    HealAntiFail          = false,
    HideSkillUI           = false,
    Fullbright            = false,
    Speed                 = false,
    SpeedValue            = 16,
    Jump                  = false,
    JumpValue             = 50,
    InfiniteJump          = false,
    Noclip                = false,
    Destroyed             = false,

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
    KILLER_DestroyPallets = false,
    KILLER_FullGenBreak   = false,
    KILLER_NoPalletStun   = false,
    KILLER_AutoHook       = false,
    KILLER_AntiBlind      = false,
    KILLER_NoSlowdown     = false,
    KILLER_DoubleTap      = false,
    KILLER_InfiniteLunge  = false,
    SPEED_Enabled         = false,
    SPEED_Value           = 32,
    SPEED_Method          = "Attribute",
    NO_Fog                = false,
    CAM_FOVEnabled        = false,
    CAM_FOV               = 90,
    CAM_ThirdPerson       = false,
    CAM_ShiftLock         = false,
    FLING_Enabled         = false,
    FLING_Strength        = 10000,
    BEAT_Survivor         = false,
    BEAT_Killer           = false,
    TP_Offset             = 3,
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
    RADAR_Enabled         = false,
    RADAR_Size            = 120,
    RADAR_Circle          = false,
    RADAR_Killer          = true,
    RADAR_Survivor        = true,
    RADAR_Generator       = true,
    RADAR_Pallet          = true,
    AIM_Enabled           = false,
    AIM_Crosshair         = false,
    AIM_UseRMB            = true,
    AIM_FOV               = 120,
    AIM_Smooth            = 0.3,
    AIM_TargetPart        = "Head",
    AIM_VisCheck          = true,
    AIM_ShowFOV           = true,
    AIM_Predict           = true,
    SPEAR_Aimbot          = false,
    SPEAR_Gravity         = 50,
    SPEAR_Speed           = 100,
    FLY_Enabled           = false,
    FLY_Speed             = 50,
    FLY_Method            = "Velocity"
}

local VD = getgenv().VD

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

    local f = pg:FindFirstChild("STREE_WorkspaceChams")
    if not f then
        f = Instance.new("Folder")
        f.Name = "STREE_WorkspaceChams"
        f.Parent = pg
    end
    VD_ChamsFolder = f
    return f
end

local ConfigFolderName = "StreeHub_VD_Configs"
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

local function STREE_SaveConfig(name)
    name = (name and name ~= "") and name or getgenv().CurrentConfigName
    if not name or name == "" then name = "Default" end
    local path = ConfigFolderName .. "/" .. name .. ".json"
    pcall(function()
        if writefile then
            writefile(path, HttpService:JSONEncode(VD))
        end
    end)
end

local function STREE_LoadConfig(name)
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

local function STREE_DeleteConfig(name)
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

pcall(function() STREE_LoadConfig("Default") end)

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
            Offset  = atm.Offset,
            Glare   = atm.Glare,
            Haze    = atm.Haze
        }
    end
    if blur then originalLighting.Blur = { Size = blur.Size } end
    if cc then originalLighting.ColorCorrection = { Enabled = cc.Enabled } end
    if sr then originalLighting.SunRays = { Enabled = sr.Enabled } end
end

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

local TeamColor  = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)

local function isTeammate(player)
    return LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team
end

local function getPlayerColor(player)
    return isTeammate(player) and TeamColor or EnemyColor
end

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

            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args   = { ... }

                if GenResult and VD.GenAntiFail then
                    if GenFail and self == GenFail and method == "FireServer" then return nil end
                    if self == GenResult and method == "FireServer" then
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

            AntiFailHooked = true
            print("AntiFail: hooked")
        end)
        if not ok then warn("AntiFail setup failed:", err) end
    end)
end

setupAntiFail()

local SimpleESP = {}

local function createSimpleESPForCharacter(player, char)
    if not player or not char then return end
    if SimpleESP[player] then
        pcall(function() SimpleESP[player].Folder:Destroy() end)
    end

    local folder = Instance.new("Folder")
    folder.Name = "UniversalESP_" .. player.Name
    folder.Parent = GetSafeChamsFolder()

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.Adornee = char
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = getPlayerColor(player)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = folder

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
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
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
                        local newHead = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                        data.Billboard.Adornee = newHead
                    end
                end
            end
        end
    end
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createSimpleESP(p) end
end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createSimpleESP(p) end end)
Players.PlayerRemoving:Connect(removeSimpleESP)

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
                if v:IsA("BlurEffect") and originalLighting.Blur then
                    v.Size = originalLighting.Blur.Size or 0
                end
                if v:IsA("ColorCorrectionEffect") and originalLighting.ColorCorrection then
                    v.Enabled = originalLighting.ColorCorrection.Enabled or false
                end
                if v:IsA("SunRaysEffect") and originalLighting.SunRays then
                    v.Enabled = originalLighting.SunRays.Enabled or false
                end
            end
        end
        task.wait(0.5)
    end
end)

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
        if part and part.Parent and part:IsA("BasePart") then
            pcall(function() part.CanCollide = val end)
        end
    end
    originalCanCollide = {}
end

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

local HomeTab, PlayersTab, ESPTab, MapTab, AimTab, FOVTab
local SurvivorTab, KillerTab, GeneratorTab, FlingTab, SettingsTab

if Window then
    HomeTab      = Window:Tab({ Title = "Home",      Icon = "house" })
    PlayersTab   = Window:Tab({ Title = "Players",   Icon = "person-standing" })
    ESPTab       = Window:Tab({ Title = "Visual",    Icon = "eye" })
    MapTab       = Window:Tab({ Title = "Map",       Icon = "map" })
    AimTab       = Window:Tab({ Title = "Aim",       Icon = "crosshair" })
    FOVTab       = Window:Tab({ Title = "FOV",       Icon = "video" })
    SurvivorTab  = Window:Tab({ Title = "Survivor",  Icon = "shield" })
    KillerTab    = Window:Tab({ Title = "Killer",    Icon = "swords" })
    GeneratorTab = Window:Tab({ Title = "Generator", Icon = "zap" })
    FlingTab     = Window:Tab({ Title = "Fling",     Icon = "wind" })
    SettingsTab  = Window:Tab({ Title = "Settings",  Icon = "settings" })
end

local function MakeSection(tabRef, sectionData)
    local section = tabRef:Section(sectionData)
    if not section then return nil end

    function section:Toggle(cfg)    return tabRef:Toggle(cfg)    end
    function section:Slider(cfg)    return tabRef:Slider(cfg)    end
    function section:Button(cfg)    return tabRef:Button(cfg)    end
    function section:Dropdown(cfg)  return tabRef:Dropdown(cfg)  end
    function section:Input(cfg)     return tabRef:Input(cfg)     end
    function section:Paragraph(cfg) return tabRef:Paragraph(cfg) end

    return section
end

if Window then

    do
        HomeTab:Section({ Title = "Information" })

        HomeTab:Button({
            Title = "Discord",
            Desc = "Copy Discord Link",
            Callback = function()
                local link = "https://discord.gg/jdmX43t5mY"
                if setclipboard then
                    setclipboard(link)
                end
            end
        })

        HomeTab:Paragraph({
            Title = "Join Us",
            Desc = "Every Update Will Be On Discord"
        })

        HomeTab:Paragraph({
            Title = "Support",
            Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
        })
    end

    do
        local movSection = MakeSection(PlayersTab, { Title = "Movement" })

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
            Callback = function(v) VD.SpeedValue = v end
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
            Callback = function(v) VD.JumpValue = v end
        })
        movSection:Toggle({ Title = "Infinite Jump", Callback = function(v) VD.InfiniteJump = v end })
        movSection:Toggle({ Title = "Noclip",        Callback = function(v) VD.Noclip = v end })

        local tpSection = MakeSection(PlayersTab, { Title = "Teleport" })

        tpSection:Button({ Title = "TP to Gen",  Callback = function() pcall(function() STREE_TeleportToGenerator(1) end) end })
        tpSection:Button({ Title = "TP to Gate", Callback = function() pcall(STREE_TeleportToGate) end })
        tpSection:Button({ Title = "TP to Hook", Callback = function() pcall(STREE_TeleportToHook) end })
    end

    do
        local basicEsp = MakeSection(ESPTab, { Title = "Basic ESP" })

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
            Callback = function(v) VD.MaxDistance = v end
        })

        local advEsp = MakeSection(ESPTab, { Title = "Advanced ESP" })

        advEsp:Toggle({ Title = "Master Turn On Object Chams",  Callback = function(v) VD.ESP_ObjectChams  = v end })
        advEsp:Toggle({ Title = "- Chams: Generator (with %)", Callback = function(v) VD.ESP_Obj_Generator = v end })
        advEsp:Toggle({ Title = "- Chams: Gate",               Callback = function(v) VD.ESP_Obj_Gate      = v end })
        advEsp:Toggle({ Title = "- Chams: Hook",               Callback = function(v) VD.ESP_Obj_Hook      = v end })
        advEsp:Toggle({ Title = "- Chams: Pallet",             Callback = function(v) VD.ESP_Obj_Pallet    = v end })
        advEsp:Toggle({ Title = "- Chams: Window",             Callback = function(v) VD.ESP_Obj_Window    = v end })

        local otherEsp = MakeSection(ESPTab, { Title = "Other Markers" })

        otherEsp:Toggle({ Title = "Player Highlight (Chams)", Callback = function(v) VD.ESP_PlayerChams = v end })
        otherEsp:Toggle({ Title = "ESP Skeleton",             Callback = function(v) VD.ESP_Skeleton    = v end })
        otherEsp:Toggle({ Title = "ESP Velocity Arrows",      Callback = function(v) VD.ESP_Velocity    = v end })
        otherEsp:Toggle({ Title = "ESP Offscreen Arrows",     Callback = function(v) VD.ESP_Offscreen   = v end })
        otherEsp:Toggle({ Title = "Closest Hook Highlight",   Callback = function(v) VD.ESP_ClosestHook = v end })
    end

    do
        local radarSection = MakeSection(MapTab, { Title = "Radar" })

        radarSection:Toggle({ Title = "Radar Enable",      Callback = function(v) VD.RADAR_Enabled = v end })
        radarSection:Slider({
            Title = "Radar Size",
            Value = { Min = 80, Max = 300, Default = 120 },
            Callback = function(v) VD.RADAR_Size = v end
        })
        radarSection:Toggle({ Title = "Radar Circle Mode", Callback = function(v) VD.RADAR_Circle = v end })

        local radarFilter = MakeSection(MapTab, { Title = "Radar Filters" })

        radarFilter:Toggle({ Title = "Radar show Killer",    Callback = function(v) VD.RADAR_Killer    = v end })
        radarFilter:Toggle({ Title = "Radar show Survivor",  Callback = function(v) VD.RADAR_Survivor  = v end })
        radarFilter:Toggle({ Title = "Radar show Generator", Callback = function(v) VD.RADAR_Generator = v end })
        radarFilter:Toggle({ Title = "Radar show Pallet",    Callback = function(v) VD.RADAR_Pallet    = v end })
    end

    do
        local aimbotSection = MakeSection(AimTab, { Title = "Aimbot" })

        aimbotSection:Toggle({ Title = "Enable Aimbot",         Callback = function(v) VD.AIM_Enabled  = v end })
        aimbotSection:Toggle({
            Title = "Show Crosshair",
            Callback = function(v)
                VD.AIM_Crosshair = v
                if STREE_CrossH and STREE_CrossV then
                    STREE_CrossH.Visible = v
                    STREE_CrossV.Visible = v
                end
            end
        })
        aimbotSection:Toggle({ Title = "Use RMB to aim",        Callback = function(v) VD.AIM_UseRMB  = v end })
        aimbotSection:Toggle({ Title = "Show Aim FOV (circle)", Callback = function(v) VD.AIM_ShowFOV = v end })
        aimbotSection:Slider({
            Title = "FOV Size (aim radius on screen)",
            Value = { Min = 20, Max = 400, Default = 120 },
            Callback = function(v) VD.AIM_FOV = v end
        })
        aimbotSection:Slider({
            Title = "Smoothness",
            Value = { Min = 0.1, Max = 1, Default = 0.3, Step = 0.05 },
            Callback = function(v) VD.AIM_Smooth = v end
        })
        aimbotSection:Toggle({ Title = "Visibility Check", Callback = function(v) VD.AIM_VisCheck = v end })
        aimbotSection:Toggle({ Title = "Prediction",       Callback = function(v) VD.AIM_Predict  = v end })

        local spearSection = MakeSection(AimTab, { Title = "Spear Aimbot" })

        spearSection:Toggle({ Title = "Spear Aimbot", Callback = function(v) VD.SPEAR_Aimbot = v end })
        spearSection:Toggle({
            Title = "Show Crosshair",
            Callback = function(v)
                VD.AIM_Crosshair = v
                if STREE_CrossH and STREE_CrossV then
                    STREE_CrossH.Visible = v
                    STREE_CrossV.Visible = v
                end
            end
        })
        spearSection:Slider({
            Title = "Spear Gravity",
            Value = { Min = 10, Max = 200, Default = 50 },
            Callback = function(v) VD.SPEAR_Gravity = v end
        })
        spearSection:Slider({
            Title = "Spear Speed",
            Value = { Min = 50, Max = 300, Default = 100 },
            Callback = function(v) VD.SPEAR_Speed = v end
        })
    end

    do
        local camSection = MakeSection(FOVTab, { Title = "Camera" })

        camSection:Toggle({ Title = "Enable Camera FOV override",    Callback = function(v) VD.CAM_FOVEnabled  = v end })
        camSection:Slider({
            Title = "Camera FOV",
            Value = { Min = 30, Max = 140, Default = 90 },
            Callback = function(v) VD.CAM_FOV = v end
        })
        camSection:Toggle({ Title = "Third Person (Killer only)",    Callback = function(v) VD.CAM_ThirdPerson = v end })
        camSection:Toggle({ Title = "Shift Lock (auto face camera)", Callback = function(v) VD.CAM_ShiftLock   = v end })

        local visualSection = MakeSection(FOVTab, { Title = "Visual" })

        visualSection:Toggle({ Title = "No Fog (remove fog/post effects)", Callback = function(v) VD.NO_Fog     = v end })
        visualSection:Toggle({ Title = "Fullbright (lighting preset)",     Callback = function(v) VD.Fullbright = v end })
    end

    do
        local combatSurv = MakeSection(SurvivorTab, { Title = "Combat" })

        combatSurv:Toggle({ Title = "Auto Parry", Callback = function(v) VD.AUTO_Parry = v end })
        combatSurv:Slider({
            Title = "Parry Range (studs)",
            Value = { Min = 5, Max = 30, Default = 15 },
            Callback = function(v) VD.AUTO_ParryRange = v end
        })
        combatSurv:Slider({
            Title = "Face Killer Sensitivity (deg)",
            Value = { Min = 0, Max = 180, Default = 30 },
            Callback = function(v) VD.AUTO_ParrySensitivity = v end
        })
        combatSurv:Slider({
            Title = "Auto Parry Delay (s)",
            Value = { Min = 0.1, Max = 2, Default = 0.5, Step = 0.05 },
            Callback = function(v) VD.AUTO_ParryDelay = v end
        })
        combatSurv:Toggle({ Title = "Auto Wiggle", Callback = function(v) VD.SURV_AutoWiggle = v end })
        combatSurv:Toggle({
            Title = "Auto SkillCheck (QTE)",
            Callback = function(v)
                VD.AUTO_SkillCheck = v
                if v then pcall(SetupSkillCheckMonitor) end
            end
        })
        combatSurv:Button({
            Title = "[!] Cancel/Leave Generator [X]",
            Callback = function() pcall(STREE_ForceLeaveGenerator) end
        })
        combatSurv:Toggle({ Title = "No Fall Damage", Callback = function(v) VD.SURV_NoFall = v end })

        local escapeSurv = MakeSection(SurvivorTab, { Title = "Escape" })

        escapeSurv:Toggle({ Title = "Flee Killer (Auto TeleAway)", Callback = function(v) VD.AUTO_TeleAway = v end })
        escapeSurv:Slider({
            Title = "Flee Distance",
            Value = { Min = 20, Max = 120, Default = 40 },
            Callback = function(v) VD.AUTO_TeleAwayDist = v end
        })
        escapeSurv:Toggle({ Title = "Beat Survivor (auto exit)", Callback = function(v) VD.BEAT_Survivor = v end })
    end

    do
        local combatKiller = MakeSection(KillerTab, { Title = "Combat" })

        combatKiller:Toggle({ Title = "Auto Attack",    Callback = function(v) VD.AUTO_Attack    = v end })
        combatKiller:Slider({
            Title = "Attack Range",
            Value = { Min = 5, Max = 20, Default = 12 },
            Callback = function(v) VD.AUTO_AttackRange = v end
        })
        combatKiller:Toggle({ Title = "Hitbox Expand", Callback = function(v) VD.HITBOX_Enabled  = v end })
        combatKiller:Slider({
            Title = "Hitbox Size",
            Value = { Min = 5, Max = 40, Default = 15 },
            Callback = function(v) VD.HITBOX_Size = v end
        })
        combatKiller:Toggle({ Title = "Double Tap",     Callback = function(v) VD.KILLER_DoubleTap     = v end })
        combatKiller:Toggle({ Title = "Infinite Lunge", Callback = function(v) VD.KILLER_InfiniteLunge = v end })

        local mapKiller = MakeSection(KillerTab, { Title = "Map Control" })

        mapKiller:Toggle({ Title = "Destroy Pallets", Callback = function(v) VD.KILLER_DestroyPallets = v end })
        mapKiller:Toggle({ Title = "Full Gen Break",  Callback = function(v) VD.KILLER_FullGenBreak   = v end })

        local utilKiller = MakeSection(KillerTab, { Title = "Utilities" })

        utilKiller:Toggle({ Title = "Auto Hook", Callback = function(v) VD.KILLER_AutoHook = v end })
        utilKiller:Toggle({
            Title = "Anti Blind (Flashlight)",
            Callback = function(v)
                VD.KILLER_AntiBlind = v
                pcall(SetupAntiBlind)
            end
        })
        utilKiller:Toggle({
            Title = "No Pallet Stun (metamethod)",
            Callback = function(v)
                VD.KILLER_NoPalletStun = v
                pcall(SetupNoPalletStun)
            end
        })
        utilKiller:Toggle({ Title = "No Slowdown",             Callback = function(v) VD.KILLER_NoSlowdown = v end })
        utilKiller:Toggle({ Title = "Beat Killer (auto kill)", Callback = function(v) VD.BEAT_Killer       = v end })
    end

    do
        local genVisual = MakeSection(GeneratorTab, { Title = "Visual" })

        genVisual:Toggle({ Title = "Master Turn On Object Chams",  Callback = function(v) VD.ESP_ObjectChams  = v end })
        genVisual:Toggle({ Title = "- Chams: Generator (with %)", Callback = function(v) VD.ESP_Obj_Generator = v end })

        local genAuto = MakeSection(GeneratorTab, { Title = "Automation" })

        genAuto:Toggle({ Title = "AntiFail Generator", Callback = function(v) VD.GenAntiFail = v end })
    end

    do
        local flingSection = MakeSection(FlingTab, { Title = "Fling" })

        flingSection:Toggle({ Title = "Enable Fling", Callback = function(v) VD.FLING_Enabled = v end })
        flingSection:Slider({
            Title = "Fling Strength",
            Value = { Min = 1000, Max = 50000, Default = 10000 },
            Callback = function(v) VD.FLING_Strength = v end
        })

        local flingActions = MakeSection(FlingTab, { Title = "Actions" })

        flingActions:Button({ Title = "Fling Nearest", Callback = function() pcall(function() STREE_FlingNearest() end) end })
        flingActions:Button({ Title = "Fling All",     Callback = function() pcall(STREE_FlingAll) end })
    end

    do
        local cfgSection = MakeSection(SettingsTab, { Title = "Configuration" })

        local confInput = ""
        local configDropdown

        cfgSection:Input({
            Title = "Config Name",
            Placeholder = "Type name to save...",
            Callback = function(v) confInput = v end
        })

        cfgSection:Button({
            Title = "Save Config",
            Callback = function()
                if confInput ~= "" then
                    getgenv().CurrentConfigName = confInput
                end
                pcall(function() STREE_SaveConfig(getgenv().CurrentConfigName) end)
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
                if type(v) == "table" then v = v[1] end
                getgenv().CurrentConfigName = v
            end
        })

        cfgSection:Button({
            Title = "Load Config",
            Callback = function()
                pcall(function() STREE_LoadConfig(getgenv().CurrentConfigName) end)
            end
        })

        cfgSection:Button({
            Title = "Delete Config",
            Callback = function()
                pcall(function() STREE_DeleteConfig(getgenv().CurrentConfigName) end)
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

    do
        local resetSection = MakeSection(SettingsTab, { Title = "Unload" })

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
                if STREE_CrosshairGui then STREE_CrosshairGui:Destroy() end
                if DrawingAvailable then
                    pcall(function()
                        for target, _ in pairs(Chams.Objects or {}) do
                            pcall(function()
                                local c = target and target:FindFirstChild("_ViolenceChams")
                                if c then c:Destroy() end
                            end)
                            pcall(function()
                                local l = target and target:FindFirstChild("_ViolenceLabel")
                                if l then l:Destroy() end
                            end)
                        end
                    end)
                end
                print("STREE HUB Violence District Unloaded")
            end
        })
    end

end

print("STREE HUB Violence District Loaded (Full Features merged with UI fixes)")

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

local STREE_Cache = {
    Generators  = {},
    Gates       = {},
    Hooks       = {},
    Pallets     = {},
    Windows     = {},
    ClosestHook = nil,
    ExitPos     = nil
}

local function STREE_ScanMap()
    local map = Workspace:FindFirstChild("Map")
    if not map then
        STREE_Cache = {
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

    STREE_Cache.Generators = newGens
    STREE_Cache.Gates      = newGates
    STREE_Cache.Hooks      = newHooks
    STREE_Cache.Pallets    = newPallets
    STREE_Cache.Windows    = newWindows
    STREE_Cache.ExitPos    = exitPos
    print("[STREE ScanMap] Generators:", #newGens, "Gates:", #newGates, "Hooks:", #newHooks)

    local root = Root
    if root and #STREE_Cache.Hooks > 0 then
        local closest, closestDist = nil, math.huge
        for _, hook in ipairs(STREE_Cache.Hooks) do
            if hook.part then
                local d = (hook.part.Position - root.Position).Magnitude
                if d < closestDist then
                    closestDist = d; closest = hook
                end
            end
        end
        STREE_Cache.ClosestHook = closest
    end
end

local function STREE_TeleportToPosition(pos)
    if not pos then return false end
    local root = Root
    if not root then return false end

    if LocalPlayer.Character then
        root.Anchored = true
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
            root.Anchored = false
        end
        originalCanCollide = {}
    end)
    return true
end

function STREE_TeleportToGenerator(index)
    if not STREE_Cache or not STREE_Cache.Generators or #STREE_Cache.Generators == 0 then
        print("[STREE HUB] Generator tidak ditemukan")
        return false
    end

    local sorted = {}
    for _, gen in ipairs(STREE_Cache.Generators) do
        table.insert(sorted, { gen = gen, dist = (Root and (gen.part.Position - Root.Position).Magnitude) or math.huge })
    end
    table.sort(sorted, function(a, b) return a.dist < b.dist end)

    local target = sorted[index or 1]
    if not target then return false end
    return STREE_TeleportToPosition(target.gen.part.Position)
end

function STREE_TeleportToGate()
    if not STREE_Cache or not STREE_Cache.Gates or #STREE_Cache.Gates == 0 then
        print("[STREE HUB] Gate tidak ditemukan")
        return false
    end

    local closest, closestDist = nil, math.huge
    for _, gate in ipairs(STREE_Cache.Gates) do
        local dist = (Root and (gate.part.Position - Root.Position).Magnitude) or math.huge
        if dist < closestDist then
            closestDist = dist
            closest = gate
        end
    end

    if not closest then return false end
    return STREE_TeleportToPosition(closest.part.Position)
end

function STREE_TeleportToHook()
    if not STREE_Cache or not STREE_Cache.ClosestHook then
        print("[STREE HUB] Hook tidak ditemukan")
        return false
    end
    return STREE_TeleportToPosition(STREE_Cache.ClosestHook.part.Position)
end

local CurrentMapName = nil
local function CheckMapChange()
    local map = Workspace:FindFirstChild("Map")
    local mapName = map and map.Name or "Unknown"
    if CurrentMapName ~= mapName then
        print("[STREE HUB] Map berubah: " .. tostring(CurrentMapName) .. " -> " .. mapName)
        VD._BeatSurvivorDone = false
        VD._BeatKillerDone   = false
        VD._LastTeleAway     = 0
        VD._KillerTarget     = nil
    end
    CurrentMapName = mapName
    STREE_ScanMap()
end

task.spawn(function()
    while not VD.Destroyed do
        CheckMapChange()
        task.wait(2)
    end
end)

local MobileGui = {
    RadarFrame   = nil,
    RadarDots    = {},
    RadarObjDots = {},
    FOVFrame     = nil,
    FOVStroke    = nil,
    AimBtn       = nil,
}

local State = {
    AimHolding = false,
    AimTarget  = nil,
}

local function CreateMobileUI()
    local pg = GetSafeGuiParent()
    if not pg then return end

    local sg = Instance.new("ScreenGui")
    sg.Name           = "STREE_MobileUI"
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.AlwaysOnTop
    sg.Parent         = pg

    local radarF = Instance.new("Frame")
    radarF.Name                   = "RadarFrame"
    radarF.BackgroundColor3       = Color3.fromRGB(10, 10, 10)
    radarF.BackgroundTransparency = 0.4
    radarF.BorderSizePixel        = 0
    radarF.Position               = UDim2.new(0, 10, 0, 10)
    radarF.Size                   = UDim2.new(0, 120, 0, 120)
    radarF.Visible                = false
    radarF.ZIndex                 = 5
    radarF.Parent                 = sg
    local rc = Instance.new("UICorner", radarF)
    rc.Name = "RCorner"
    rc.CornerRadius = UDim.new(0, 5)
    MobileGui.RadarFrame = radarF

    for i = 1, 20 do
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0, 8, 0, 8); d.BackgroundColor3 = Color3.fromRGB(65, 220, 130)
        d.BorderSizePixel = 0; d.ZIndex = 4; d.Visible = false; d.Parent = radarF
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
        MobileGui.RadarDots[i] = d
    end
    for i = 1, 30 do
        local d = Instance.new("Frame")
        d.Size = UDim2.new(0, 6, 0, 6); d.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
        d.BorderSizePixel = 0; d.ZIndex = 3; d.Visible = false; d.Parent = radarF
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
        MobileGui.RadarObjDots[i] = d
    end

    local fovF = Instance.new("Frame")
    fovF.Name                   = "FOVCircle"
    fovF.BackgroundTransparency = 1
    fovF.AnchorPoint            = Vector2.new(0.5, 0.5)
    fovF.Position               = UDim2.new(0.5, 0, 0.5, 0)
    fovF.Size                   = UDim2.new(0, 240, 0, 240)
    fovF.Visible                = false
    fovF.Parent                 = sg
    Instance.new("UICorner", fovF).CornerRadius = UDim.new(1, 0)
    local fovStk = Instance.new("UIStroke")
    fovStk.Color = Color3.fromRGB(220, 70, 70); fovStk.Thickness = 1.5; fovStk.Transparency = 0.2
    fovStk.Parent = fovF
    MobileGui.FOVFrame = fovF; MobileGui.FOVStroke = fovStk

    local aimSG = Instance.new("ScreenGui")
    aimSG.Name           = "STREE_AimBtn"
    aimSG.ResetOnSpawn   = false
    aimSG.IgnoreGuiInset = true
    aimSG.ZIndexBehavior = Enum.ZIndexBehavior.AlwaysOnTop
    aimSG.Parent         = pg
    local btn = Instance.new("TextButton")
    btn.Name                   = "AimHold"
    btn.Size                   = UDim2.new(0, 75, 0, 75)
    btn.Position               = UDim2.new(1, -95, 1, -170)
    btn.BackgroundColor3       = Color3.fromRGB(200, 55, 55)
    btn.BackgroundTransparency = 0.2
    btn.Text                   = "🎯\nAIM"
    btn.TextColor3             = Color3.new(1, 1, 1)
    btn.TextSize               = 14
    btn.Font                   = Enum.Font.GothamBold
    btn.Visible                = false
    btn.ZIndex                 = 20
    btn.Parent                 = aimSG
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local aStk = Instance.new("UIStroke")
    aStk.Color = Color3.fromRGB(255, 100, 100); aStk.Thickness = 2; aStk.Parent = btn

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = true
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
            aStk.Color = Color3.fromRGB(50, 230, 80)
        end
    end)
    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            State.AimHolding = false; State.AimTarget = nil
            btn.BackgroundColor3 = Color3.fromRGB(200, 55, 55)
            aStk.Color = Color3.fromRGB(255, 100, 100)
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
        rc.CornerRadius = VD.RADAR_Circle and UDim.new(1, 0) or UDim.new(0, 5)
    end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myLook  = cam.CFrame.LookVector
    local myAngle = math.atan2(-myLook.X, -myLook.Z)
    local cosA, sinA = math.cos(myAngle), math.sin(myAngle)
    local RS   = VD.RADAR_Size or 130
    MobileGui.RadarFrame.Size = UDim2.new(0, RS, 0, RS)
    local half  = RS / 2
    local scale = (half - 10) / 150
    local maxD  = half - 8

    local function worldToRadar(px, pz)
        local rx = px - myRoot.Position.X
        local rz = pz - myRoot.Position.Z
        if math.sqrt(rx * rx + rz * rz) >= 150 then return nil end
        local rotX = rx * cosA - rz * sinA
        local rotZ = rx * sinA + rz * cosA
        local radarX, radarY = rotX * scale, rotZ * scale
        local rDist = math.sqrt(radarX * radarX + radarY * radarY)
        if rDist > maxD then radarX, radarY = radarX / rDist * maxD, radarY / rDist * maxD end
        return Vector2.new(half + radarX, half + radarY)
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
                        d.BackgroundColor3 = isK and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(65, 220, 130)
                        d.Position = UDim2.new(0, p.X - 4, 0, p.Y - 4); d.Visible = true; idx = idx + 1
                    end
                end
            end
        end
    end
    for i = idx, #MobileGui.RadarDots do MobileGui.RadarDots[i].Visible = false end

    local objIdx = 1
    if VD.RADAR_Generator then
        for _, gen in ipairs(STREE_Cache.Generators) do
            if gen.part and objIdx <= #MobileGui.RadarObjDots then
                local p = worldToRadar(gen.part.Position.X, gen.part.Position.Z)
                if p then
                    local d = MobileGui.RadarObjDots[objIdx]
                    d.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
                    d.Position = UDim2.new(0, p.X - 3, 0, p.Y - 3); d.Visible = true; objIdx = objIdx + 1
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
        MobileGui.FOVFrame.Size = UDim2.new(0, r * 2, 0, r * 2)
        MobileGui.FOVStroke.Color = State.AimTarget and Color3.fromRGB(90, 220, 120) or Color3.fromRGB(220, 70, 70)
        MobileGui.FOVFrame.Visible = true
    else
        MobileGui.FOVFrame.Visible = false
    end
end

function CreateUniversalCrosshair()
    local pg = GetSafeGuiParent()
    if not pg then return end
    STREE_CrosshairGui = Instance.new("ScreenGui")
    STREE_CrosshairGui.Name           = "STREE_Crosshair"
    STREE_CrosshairGui.ResetOnSpawn   = false
    STREE_CrosshairGui.IgnoreGuiInset = true
    STREE_CrosshairGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    STREE_CrosshairGui.Parent         = pg

    STREE_CrossH = Instance.new("Frame")
    STREE_CrossH.Size             = UDim2.new(0, 16, 0, 2)
    STREE_CrossH.AnchorPoint      = Vector2.new(0.5, 0.5)
    STREE_CrossH.Position         = UDim2.new(0.5, 0, 0.5, 0)
    STREE_CrossH.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    STREE_CrossH.BorderSizePixel  = 0
    STREE_CrossH.Visible          = VD.AIM_Crosshair
    STREE_CrossH.Parent           = STREE_CrosshairGui

    STREE_CrossV = Instance.new("Frame")
    STREE_CrossV.Size             = UDim2.new(0, 2, 0, 16)
    STREE_CrossV.AnchorPoint      = Vector2.new(0.5, 0.5)
    STREE_CrossV.Position         = UDim2.new(0.5, 0, 0.5, 0)
    STREE_CrossV.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    STREE_CrossV.BorderSizePixel  = 0
    STREE_CrossV.Visible          = VD.AIM_Crosshair
    STREE_CrossV.Parent           = STREE_CrosshairGui
end

task.spawn(function()
    task.wait(2)
    pcall(CreateUniversalCrosshair)
    pcall(CreateMobileUI)
end)

if DrawingAvailable then
    RunService.RenderStepped:Connect(OnRenderStep)
end

RunService.Heartbeat:Connect(function()
    if VD.Destroyed then return end
    local cam = workspace.CurrentCamera
    if not cam then return end

    if not STREE_CrosshairGui or not STREE_CrosshairGui.Parent then
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
        pcall(function() Aimbot.Update(cam, sc, Vector2.new(sc.X / 2, sc.Y / 2)) end)
    end

    pcall(UpdateObjectChams)

    if not DrawingAvailable then
        pcall(UpdateMobileRadar, cam)
        if MobileGui.AimBtn then MobileGui.AimBtn.Visible = VD.AIM_Enabled end
        pcall(UpdateMobileFOV)
    end
end)
