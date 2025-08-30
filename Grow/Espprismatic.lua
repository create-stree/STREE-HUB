--[[ =================== STREE HUB - GAG PRISMATIC ESP =================== ]]

-- ====== CONFIG ======
_G.GAG_PrismaticESP_Enabled = (_G.GAG_PrismaticESP_Enabled ~= false) -- default ON kecuali sebelumnya di-set false

local CONFIG = {
    UpdateInterval = 0.08,      -- seberapa cepat warna berganti + update jarak
    ScanInterval   = 2.0,       -- seberapa sering scan Workspace cari target baru
    MaxDistance    = 1500,      -- batasi jarak ESP
    UsePlayersESP  = false,     -- ESP pemain (true/false)
    ShowDistance   = true,      -- tampilkan jarak di label
    FontSize       = 14,        -- ukuran font label
    HeightOffset   = 4,         -- ketinggian label di atas objek
    Keywords = {                -- kata kunci target di nama Instance (case-insensitive)
        "fruit","buah","plant","tanam","tree","seed","benih","crop","pumpkin","melon","straw","apple",
        "orange","banana","carrot","tomato","radish","grape","berry","pear","kiwi","cabbage","corn",
        "gold","rare","epic","legend","loot","bag","box","crate"
    },
    ExcludeKeywords = {         -- pengecualian nama tertentu
        "leaf","grass","rock","stone","terrain","debris","water","fx","effect","particle"
    },
    -- Jika game punya folder khusus (mis: Workspace.Fruits), isi di sini agar scan lebih cepat
    PreferredFolders = { "Fruits", "Plants", "Drops", "Collectibles" }
}

-- ====== SERVICES ======
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local CollectionService  = game:GetService("CollectionService")
local UserInputService   = game:GetService("UserInputService")
local LocalPlayer        = Players.LocalPlayer
local Camera             = workspace.CurrentCamera

-- ====== GUARD: UNIQUE STATE ======
if _G.__GAG_PRISMATIC_ESP and _G.__GAG_PRISMATIC_ESP.Destroy then
    _G.__GAG_PRISMATIC_ESP.Destroy()
end

local state = {
    running = false,
    items = {},        -- [Instance] = { highlight=Highlight, billboard=BillboardGui, hum=HumanoidRootPart?, seed=n }
    lastScan = 0,
}
_G.__GAG_PRISMATIC_ESP = state

-- ====== UTIL ======
local function toLower(s) return string.lower(s or "") end

local function nameHasKeyword(name, list)
    name = toLower(name)
    for _,k in ipairs(list) do
        if string.find(name, toLower(k), 1, true) then
            return true
        end
    end
    return false
end

local function isExcluded(name)
    return nameHasKeyword(name, CONFIG.ExcludeKeywords)
end

local function isKeywordTarget(inst)
    local n = inst.Name
    if isExcluded(n) then return false end
    if nameHasKeyword(n, CONFIG.Keywords) then return true end
    -- cek parent chain sekilas (kadang objek child bernama "Handle" dll)
    local p = inst.Parent
    if p and nameHasKeyword(p.Name, CONFIG.Keywords) and not isExcluded(p.Name) then
        return true
    end
    return false
end

local function getPrimaryPart(inst)
    if inst:IsA("Model") then
        if inst.PrimaryPart then return inst.PrimaryPart end
        -- cari part paling tengah
        for _,c in ipairs(inst:GetDescendants()) do
            if c:IsA("BasePart") then return c end
        end
    elseif inst:IsA("BasePart") then
        return inst
    end
    return nil
end

local function distanceFromCam(pos)
    return (Camera.CFrame.Position - pos).Magnitude
end

local function hashSeedFromInstance(inst)
    -- seed stabil berdasar path/name, biar offset rainbow beda-beda
    local s = inst:GetFullName()
    local h = 0
    for i = 1, #s do
        h = (h * 131 + string.byte(s, i)) % 1e7
    end
    return (h % 1000) / 1000
end

local function createHighlight(targetPart)
    local h = Instance.new("Highlight")
    h.FillTransparency = 1 -- cuma outline
    h.OutlineTransparency = 0
    h.OutlineColor = Color3.fromRGB(255, 255, 255) -- akan diubah tiap frame (HSV)
    h.Adornee = targetPart.Parent:IsA("Model") and targetPart.Parent or targetPart
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Name = "GAG_PrismaticHighlight"
    h.Parent = targetPart -- parent tidak penting, yg penting Adornee
    return h
end

local function createBillboard(targetPart, labelText)
    local bb = Instance.new("BillboardGui")
    bb.Name = "GAG_PrismaticBillboard"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, CONFIG.HeightOffset, 0)
    bb.MaxDistance = CONFIG.MaxDistance + 50

    local tl = Instance.new("TextLabel")
    tl.Name = "Label"
    tl.BackgroundTransparency = 1
    tl.Text = labelText or "Target"
    tl.TextScaled = false
    tl.TextSize = CONFIG.FontSize
    tl.Font = Enum.Font.GothamSemibold
    tl.TextColor3 = Color3.new(1,1,1)
    tl.Size = UDim2.new(1,0,1,0)
    tl.Parent = bb

    bb.Adornee = targetPart
    bb.Parent = targetPart
    return bb
end

local function trackInstance(inst)
    if state.items[inst] then return end
    local pp = getPrimaryPart(inst)
    if not pp then return end
    local seed = hashSeedFromInstance(inst)
    local hl = createHighlight(pp)
    local bb = createBillboard(pp, inst.Name)
    state.items[inst] = {highlight=hl, billboard=bb, part=pp, seed=seed}
    inst.AncestryChanged:Connect(function(_, parent)
        if not parent then
            -- di-destroy
            local t = state.items[inst]
            if t then
                if t.highlight then pcall(function() t.highlight:Destroy() end) end
                if t.billboard then pcall(function() t.billboard:Destroy() end) end
                state.items[inst] = nil
            end
        end
    end)
end

local function untrackAll()
    for inst, t in pairs(state.items) do
        pcall(function() if t.highlight then t.highlight:Destroy() end end)
        pcall(function() if t.billboard then t.billboard:Destroy() end end)
        state.items[inst] = nil
    end
end

local function scanWorkspace()
    -- folder prioritas
    for _,folderName in ipairs(CONFIG.PreferredFolders) do
        local f = workspace:FindFirstChild(folderName)
        if f then
            for _,d in ipairs(f:GetDescendants()) do
                if (d:IsA("Model") or d:IsA("BasePart")) and isKeywordTarget(d.Name) then
                    trackInstance(d)
                end
            end
        end
    end
    -- fallback: scan global (hati-hati performa, tapi disaring keyword)
    for _,d in ipairs(workspace:GetDescendants()) do
        if (d:IsA("Model") or d:IsA("BasePart")) and isKeywordTarget(d.Name) then
            trackInstance(d)
        end
    end
end

local function scanPlayers()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char.Parent then
                trackInstance(char)
            end
        end
    end
end

-- ====== MAIN LOOP ======
local function setLabelText(t, dist)
    if not t or not t.billboard then return end
    local label = t.billboard:FindFirstChild("Label")
    if not label then return end
    if CONFIG.ShowDistance and dist then
        label.Text = string.format("%s  [%.1f]", (t.part.Parent and t.part.Parent.Name) or t.part.Name, dist)
    else
        label.Text = (t.part.Parent and t.part.Parent.Name) or t.part.Name
    end
end

local function rgbFromHSV(h, s, v)
    return Color3.fromHSV(h%1, s, v)
end

local function updateItems(dt, timeNow)
    local camPos = Camera.CFrame.Position
    for inst, t in pairs(state.items) do
        local p = t.part
        if not p or not p.Parent then
            -- cleanup
            if t.highlight then pcall(function() t.highlight:Destroy() end) end
            if t.billboard then pcall(function() t.billboard:Destroy() end) end
            state.items[inst] = nil
        else
            local dist = (p.Position - camPos).Magnitude
            local visible = dist <= CONFIG.MaxDistance
            if t.highlight then t.highlight.Enabled = visible end
            if t.billboard then t.billboard.Enabled = visible end
            if visible then
                -- warna pelangi: timeNow + seed biar beda2
                local hue = (timeNow * 0.12 + t.seed) % 1
                local col = rgbFromHSV(hue, 1, 1)
                if t.highlight then t.highlight.OutlineColor = col end
                setLabelText(t, dist)
            end
        end
    end
end

-- ====== TOGGLE / BIND ======
local function setRunning(on)
    if on and not state.running then
        state.running = true
        state.lastScan = 0
    elseif (not on) and state.running then
        state.running = false
        untrackAll()
    end
end

local toggleKey = Enum.KeyCode.RightShift
local toggleConn
toggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == toggleKey then
        _G.GAG_PrismaticESP_Enabled = not _G.GAG_PrismaticESP_Enabled
        setRunning(_G.GAG_PrismaticESP_Enabled)
    end
end)

-- ====== HEARTBEAT LOOPS ======
local accumUpdate, accumScan = 0, 0
local hbConn = RunService.Heartbeat:Connect(function(dt)
    if not _G.GAG_PrismaticESP_Enabled then return end
    accumUpdate += dt
    accumScan   += dt

    if accumScan >= CONFIG.ScanInterval then
        accumScan = 0
        scanWorkspace()
        if CONFIG.UsePlayersESP then scanPlayers() end
    end

    if accumUpdate >= CONFIG.UpdateInterval then
        local now = tick()
        updateItems(accumUpdate, now)
        accumUpdate = 0
    end
})

-- ====== LIFECYCLE & CLEANUP ======
function state.Destroy()
    _G.GAG_PrismaticESP_Enabled = false
    pcall(function() if hbConn then hbConn:Disconnect() end end)
    pcall(function() if toggleConn then toggleConn:Disconnect() end end)
    untrackAll()
    for _,plr in ipairs(Players:GetPlayers()) do
        -- no-op; tracked via state.items
    end
    state.running = false
end

-- ====== START ======
setRunning(_G.GAG_PrismaticESP_Enabled)
scanWorkspace()
if CONFIG.UsePlayersESP then scanPlayers() end

--[[ =================== END: STREE HUB - GAG PRISMATIC ESP =================== ]]
