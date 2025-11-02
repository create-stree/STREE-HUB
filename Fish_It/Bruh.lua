_G.AutoFishing = false
_G.AutoEquipRod = false
_G.Instant = false
_G.InstantDelay = _G.InstantDelay or 0.35
_G.CallMinDelay = _G.CallMinDelay or 0.18
_G.CallBackoff = _G.CallBackoff or 1.5

local lastCall = {}
local function safeCall(k, f)
    local n = os.clock()
    local d = _G.CallMinDelay
    local b = _G.CallBackoff
    if lastCall[k] and n - lastCall[k] < d then 
        task.wait(d - (n - lastCall[k])) 
    end
    local o, r = pcall(f)
    lastCall[k] = os.clock()
    if not o then
        local m = tostring(r):lower()
        task.wait(m:find("429") or m:find("too many requests") and b or 0.2)
    end
    return o, r
end

local RS = game:GetService("ReplicatedStorage")
local net = RS.Packages._Index["sleitnick_net@0.2.0"].net

local function rod()
    safeCall("rod", function()
        net["RE/EquipToolFromHotbar"]:FireServer(1)
    end)
end

local function autoon()
    safeCall("autoon", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(true)
    end)
end

local function autooff()
    safeCall("autooff", function()
        net["RF/UpdateAutoFishingState"]:InvokeServer(false)
    end)
end

local function catch()
    safeCall("catch", function()
        net["RE/FishingCompleted"]:FireServer()
    end)
end

local function charge()
    safeCall("charge", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function lempar()
    safeCall("lempar", function()
        net["RF/RequestFishingMinigameStarted"]:InvokeServer(-1.233, 0.996, 1761532005.497)
    end)
    safeCall("charge2", function()
        net["RF/ChargeFishingRod"]:InvokeServer()
    end)
end

local function instant_cycle()
    charge()
    lempar()
    task.wait(_G.InstantDelay)
    catch()
end

local Main = Window:Tab{Title = "Main", Icon = "landmark"}
Main:Section{Title = "Fishing", Icon = "anchor", TextXAlignment = "Left", TextSize = 17}
Main:Divider()

Main:Toggle{
    Title = "Auto Equip Rod", 
    Value = false, 
    Callback = function(v)
        _G.AutoEquipRod = v 
        if v then 
            rod()
        end 
    end
}

local mode = "Instant"
local fishThread

Main:Dropdown{
    Title = "Mode", 
    Values = {"Instant", "Legit"}, 
    Value = "Instant", 
    Callback = function(v)
        mode = v 
        WindUI:Notify{Title = "Mode", Content = "Mode: " .. v, Duration = 3}
    end
}

Main:Toggle{
    Title = "Auto Fishing", 
    Value = false,
    Callback = function(v)
        _G.AutoFishing = v
        if v then
            if mode == "Instant" then 
                _G.Instant = true 
                WindUI:Notify{Title = "Auto Fishing", Content = "Instant ON", Duration = 3}
                if fishThread then 
                    fishThread = nil 
                end
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Instant" do 
                        instant_cycle()
                        task.wait(0.35)
                    end 
                end)
            else 
                WindUI:Notify{Title = "Auto Fishing", Content = "Legit ON", Duration = 3}
                if fishThread then 
                    fishThread = nil 
                end
                fishThread = task.spawn(function()
                    while _G.AutoFishing and mode == "Legit" do 
                        autoon()
                        task.wait(1)
                    end 
                end)
            end
        else 
            WindUI:Notify{Title = "Auto Fishing", Content = "OFF", Duration = 3} 
            autooff()
            _G.Instant = false 
            if fishThread then 
                task.cancel(fishThread)
            end 
            fishThread = nil
        end
    end
}

Main:Slider{
    Title = "Instant Fishing Delay",
    Step = 0.01,
    Value = {Min = 0.2, Max = 1, Default = 0.35},
    Callback = function(v)
        _G.InstantDelay = v 
        WindUI:Notify{Title = "Delay", Content = "Instant Delay: " .. v .. "s", Duration = 2}
    end
}
