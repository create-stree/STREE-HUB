Tab3:Toggle({
    Title = "Auto Fishing",
    Desc = "Automatic Auto Fishing v1",
    Icon = false,
    Type = false,
    Default = false,
    Callback = function(value)
        _G.AutoFishing = value
    end
})

local RepStorage = game:GetService("ReplicatedStorage")

spawn(function()
    while wait() do
        if _G.AutoFishing then
            repeat
                pcall(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    if char:FindFirstChild("!!!FISHING_VIEW_MODEL!!!") then
                        RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]:FireServer(1)
                    end
                    local cosmeticFolder = workspace:FindFirstChild("CosmeticFolder")
                    if cosmeticFolder and not cosmeticFolder:FindFirstChild(tostring(player.UserId)) then
                        RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]:InvokeServer(2)
                        wait(0.5)
                        RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]:InvokeServer(1,1)
                    end
                end)
                wait(0.2)
            until not _G.AutoFishing
        end
    end
end)

spawn(function()
    while wait() do
        if _G.AutoFishing then
            repeat
                pcall(function()
                    RepStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]:FireServer()
                end)
                wait(0.2)
            until not _G.AutoFishing
        end
    end
end)

local RunService = game:GetService("RunService")    
local Workspace = game:GetService("Workspace")    
local VirtualInputManager = game:GetService("VirtualInputManager")    
local ReplicatedStorage = game:GetService("ReplicatedStorage")    
local camera = Workspace.CurrentCamera    
    
local REEquipToolFromHotbar = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]    
local REFishingCompleted = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]

local autoHoldEnabled = false
Tab3:Toggle({
    Title = "Auto Fishing",
    Desc = "Automatic Fishing v2",
    Value = false,
    Callback = function(state)
        autoHoldEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Fishing V2",
                Content = "Enabled",
                Duration = 3
            })
            task.spawn(function()
                local holdDuration = 0.4
                local loopDelay = 0.2
                while autoHoldEnabled do
                    pcall(function()
                        REEquipToolFromHotbar:FireServer(1)
                        local clickX = 5
                        local clickY = camera.ViewportSize.Y - 5
                        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                        task.wait(holdDuration)
                        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                    end)
                    task.wait(loopDelay)
                    RunService.Heartbeat:Wait()
                end
            end)
        else
            WindUI:Notify({
                Title = "Auto Fishing V2",
                Content = "Disabled",
                Duration = 3
            })
        end
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

local autoInstantFishEnabled = true
local delayTime = 0.1

local function startAutoFish()
    task.spawn(function()
        while autoInstantFishEnabled do
            pcall(function()
                REFishingCompleted:FireServer()
            end)
            task.wait(delayTime)
        end
    end)
end

Toggle = Tab3:Toggle({
    Title = "Auto Instant complete Fishing",
    Desc = "Instant Fishing (It is mandatory to turn it on if you want to use Auto Fishing V2)",
    Value = autoInstantFishEnabled,
    Callback = function(state)
        autoInstantFishEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Instant Fish",
                Content = "Enabled (Delay: " .. delayTime .. "s)",
                Duration = 3
            })
            startAutoFish()
        else
            WindUI:Notify({
                Title = "Auto Instant Fish",
                Content = "Disabled",
                Duration = 3
            })
        end
    end
})
