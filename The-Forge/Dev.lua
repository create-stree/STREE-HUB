local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not success or not WindUI then
    warn("⚠️ UI failed to loaded!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    Author = "KirsiaSC | The Forge",
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

Window:EditOpenButton({
    Title = "STREE HUB",
    Icon = "rbxassetid://122683047852451",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("#000000"), 
        Color3.fromHex("#39FF14")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:Tag({
    Title = "Version",
    Color = Color3.fromRGB(0, 255, 0),
    Radius = 17,
})

Window:Tag({
    Title = "Dev",
    Color = Color3.fromRGB(0, 0, 0),
    Radius = 17,
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

Tab1:Divider()

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

Tab1:Divider()

Tab1:Paragraph({
    Title = "Support",
    Desc = "Every time there is a game update or someone reports something, I will fix it as soon as possible."
})

Tab1:Keybind({
    Title = "Close/Open UI",
    Desc = "Keybind to Close/Open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local Tab2 = Window:Tab({
    Title = "Main",
    Icon = "landmark"
})

local Section = Tab2:Section({
    Title = "Mining Farm",
    TextXAlignment = "Left",
    TextSize = 17,
})

Tab2:Divider()

local SelectedRocks = {}

Tab2:Dropdown({
    Title = "Select",
    Desc = "Select Rock",
    Values = { "Basalt", "Basalt Core", "Basalt Rock", "Basalt Vein", "Boulder", "Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Lava Rock", "Lucky Block", "Light Crystal", "Pebble", "Rock", "Violet Crystal", "Volcanic Rock" },
    Value = { "Pebble" },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        if typeof(option) == "table" then
            SelectedRocks = option
        elseif typeof(option) == "string" then
            SelectedRocks = { option }
        else
            SelectedRocks = {}
        end
    end
})

_G.AutoMine = false
local ownDebounce = false
local noclipConnection = nil
local miningToolNames = {"Pickaxe", "Drill", "Hammer", "Axe", "Tool"}

local function enableNoclip()
    if noclipConnection then return end
    noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        local plr = game.Players.LocalPlayer
        if not plr then return end
        local char = plr.Character
        if not char then return end
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

local function equipBestMiningTool()
    local plr = game.Players.LocalPlayer
    if not plr then return nil end
    
    local char = plr.Character
    if not char then return nil end
    
    local bestTool = nil
    local bestToolValue = 0
    
    for _, tool in ipairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolName = tool.Name:lower()
            local isMiningTool = false
            
            for _, name in ipairs(miningToolNames) do
                if toolName:find(name:lower()) then
                    isMiningTool = true
                    break
                end
            end
            
            if isMiningTool then
                local toolValue = 0
                if toolName:find("pickaxe") then toolValue = 100
                elseif toolName:find("drill") then toolValue = 90
                elseif toolName:find("hammer") then toolValue = 80
                elseif toolName:find("axe") then toolValue = 70
                else toolValue = 10 end
                
                if toolValue > bestToolValue then
                    bestToolValue = toolValue
                    bestTool = tool
                end
            end
        end
    end
    
    if bestTool then
        bestTool.Parent = char
        return bestTool
    end
    
    for _, tool in ipairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = char
            return tool
        end
    end
    
    return nil
end

Tab2:Toggle({
    Title = "Auto Farm",
    Desc = "Automatic Farm Mine",
    Value = false,
    Callback = function(state)
        _G.AutoMine = state
        
        if _G.AutoMine then
            -- Aktifkan Noclip
            enableNoclip()
            
            -- Auto equip tool
            local plr = game.Players.LocalPlayer
            if plr and plr.Character then
                equipBestMiningTool()
            end
        else
            -- Matikan Noclip saja
            disableNoclip()
        end
        
        if _G.AutoMine and ownDebounce then
            return
        end
        
        task.spawn(function()
            ownDebounce = true
            
            -- Pastikan noclip aktif
            if _G.AutoMine then
                enableNoclip()
            end
            
            while _G.AutoMine do
                task.wait(0.5)
                
                local plr = game.Players.LocalPlayer
                if not plr then break end
                
                local char = plr.Character
                if not char then
                    char = plr.CharacterAdded:Wait()
                    task.wait(0.5)
                end
                
                local hrp = char:WaitForChild("HumanoidRootPart", 5)
                local hum = char:WaitForChild("Humanoid", 5)
                
                if not hrp or not hum then
                    task.wait(1)
                    continue
                end
                
                -- Auto equip alat mining
                local equipped = char:FindFirstChildOfClass("Tool")
                if not equipped then
                    equipped = equipBestMiningTool()
                end
                
                if #SelectedRocks == 0 then
                    SelectedRocks = {"Pebble"}
                end
                
                -- DEBUG: Print untuk melihat apa yang dipilih
                print("Mencari objek dengan nama:", SelectedRocks)
                
                -- Cari semua objek yang cocok
                local validTargets = {}
                for _, obj in ipairs(workspace:GetChildren()) do
                    for _, rockName in ipairs(SelectedRocks) do
                        if obj.Name == rockName then
                            table.insert(validTargets, obj)
                            print("Found:", obj.Name, "at:", obj:GetPivot().Position)
                        end
                    end
                end
                
                -- Juga cari di dalam folder-folder
                for _, folder in ipairs(workspace:GetChildren()) do
                    if folder:IsA("Folder") or folder:IsA("Model") then
                        for _, obj in ipairs(folder:GetDescendants()) do
                            for _, rockName in ipairs(SelectedRocks) do
                                if obj.Name == rockName then
                                    table.insert(validTargets, obj)
                                    print("Found in folder:", obj.Name, "at:", obj:GetPivot().Position)
                                end
                            end
                        end
                    end
                end
                
                if #validTargets == 0 then
                    print("Tidak ditemukan objek yang cocok!")
                    task.wait(2)
                    continue
                end
                
                -- Cari objek terdekat
                local nearestObj = nil
                local nearestDist = math.huge
                
                for _, obj in ipairs(validTargets) do
                    local targetPart = nil
                    local targetPos = nil
                    
                    if obj:IsA("Model") then
                        targetPart = obj.PrimaryPart
                        if not targetPart then
                            -- Cari part pertama yang ada
                            for _, part in ipairs(obj:GetChildren()) do
                                if part:IsA("BasePart") then
                                    targetPart = part
                                    break
                                end
                            end
                        end
                        if targetPart then
                            targetPos = targetPart.Position
                        end
                    elseif obj:IsA("BasePart") then
                        targetPart = obj
                        targetPos = obj.Position
                    end
                    
                    if targetPos then
                        local distance = (hrp.Position - targetPos).Magnitude
                        print("Distance to", obj.Name, ":", distance)
                        
                        if distance < nearestDist then
                            nearestDist = distance
                            nearestObj = {
                                model = obj,
                                part = targetPart,
                                position = targetPos
                            }
                        end
                    end
                end
                
                if not nearestObj then
                    print("Tidak ada objek yang valid ditemukan!")
                    task.wait(2)
                    continue
                end
                
                print("Menuju ke:", nearestObj.model.Name, "jarak:", nearestDist)
                
                -- Posisi di dalam tanah (10 stud di bawah objek)
                local undergroundPos = Vector3.new(
                    nearestObj.position.X,
                    nearestObj.position.Y - 10,  -- DI BAWAH TANAH
                    nearestObj.position.Z
                )
                
                -- TELEPORT langsung ke posisi bawah tanah
                hrp.CFrame = CFrame.new(undergroundPos) * CFrame.Angles(math.rad(-90), 0, 0)  -- MENGHADAP KE ATAS
                
                print("Teleport ke bawah tanah, menghadap ke atas")
                
                -- Mining loop
                local miningTime = 0
                local maxMiningTime = 10  -- 10 detik mining per objek
                
                while _G.AutoMine and miningTime < maxMiningTime do
                    if not nearestObj.model or not nearestObj.model.Parent then
                        print("Objek sudah hancur")
                        break
                    end
                    
                    -- Update posisi jika objek bergerak
                    if nearestObj.part and nearestObj.part.Parent then
                        local newPos = nearestObj.part.Position
                        undergroundPos = Vector3.new(newPos.X, newPos.Y - 10, newPos.Z)
                        hrp.CFrame = CFrame.new(undergroundPos) * CFrame.Angles(math.rad(-90), 0, 0)
                    end
                    
                    -- Auto click mining
                    if equipped and equipped.Parent == char then
                        pcall(function()
                            equipped:Activate()
                            print("Mining...")
                        end)
                    else
                        -- Re-equip jika tool hilang
                        equipped = equipBestMiningTool()
                    end
                    
                    task.wait(0.5)
                    miningTime = miningTime + 0.5
                    
                    -- Cek jika objek sudah hancur
                    if not nearestObj.model.Parent then
                        print("Objek hancur, cari yang baru")
                        break
                    end
                    
                    -- Cek transparansi/ukuran objek
                    if nearestObj.part then
                        if nearestObj.part.Transparency >= 1 or nearestObj.part.Size.Magnitude < 0.1 then
                            print("Objek sudah tidak visible")
                            break
                        end
                    end
                end
                
                print("Selesai mining objek ini, cari yang baru...")
                task.wait(1)
            end
            
            ownDebounce = false
            print("Auto Farm dihentikan")
        end)
    end
})

-- Handle character respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)  -- Tunggu karakter fully loaded
    
    if _G.AutoMine then
        print("Karakter respawn, aktifkan ulang Auto Farm...")
        enableNoclip()
        
        -- Tunggu HRP dan Humanoid
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        
        if hrp and hum then
            -- Auto equip tool
            task.wait(0.5)
            equipBestMiningTool()
            
            -- Set posisi ke atas
            hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
        end
    end
end)

-- Cleanup saat keluar
game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    if noclipConnection then
        disableNoclip()
    end
end)
