--[[
  ____  _  _  _____ _____ ______   _    _  ____  _    _ 
 / ___|| || || ____|_   _|  _ \ \ / \  | |/ ___|| |  | |
 \___ \| || ||  _|   | | | |_) \ V /  | | |  _ | |  | |
  ___) |__   _| |___  | | |  _ < | |   | | |_| || |__| |
 |____/   |_| |_____| |_| |_| \_\|_|   |_|\____| \____/ 
                                                         
  _    _ _   _ ____    _    _   _ ____  ____  
 | |  | | \ | |  _ \  / \  | \ | | __ )/ ___| 
 | |  | |  \| | | | |/ _ \ |  \| |  _ \\___ \ 
 | |__| | |\  | |_| / ___ \| |\  | |_) |___) |
  \____/|_| \_|____/_/   \_\_| \_|____/|____/ 
                                              
  _______  _______  _______  _______  _______ 
 (  ____ \(  ___  )(  ____ )(  ____ )(  ____ \
 | (    \/| (   ) || (    )|| (    )|| (    \/
 | |      | |   | || (____)|| (____)|| (____  
 | | ____ | |   | ||     __)|     __)|  _____)
 | | \_  )| |   | || (\ (   | (\ (   | (      
 | (___) || (___) || ) \ \__| ) \ \__| )      
 (_______)(_______)|/   \__/|/   \__/|/       
                                            
]]--

local function _s(t)local r={}for i=1,#t do r[i]="\\"..t:byte(i) end;return table.concat(r) end
local function _u(s)return loadstring(s)()end
local _fetch = _u("return \"".._s("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua").."\"")
local _ok,_run = pcall(function() return loadstring(game:HttpGet(_fetch))() end)
local WindUI = (_ok and _run) or nil
if not WindUI then return end
local _win = WindUI:CreateWindow({
    Title = "STREE HUB",
    Icon = "rbxassetid://"..("123032091977400"),
    Author = "KirsiaSC | Fish It",
    Folder = "STREE_HUB",
    Size = UDim2.fromOffset(270,300),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})
WindUI:Notify({
    Title = _u("return \"".._s("STREE HUB Loaded").."\""),
    Content = _u("return \"".._s("UI loaded successfully!").."\""),
    Duration = 3,
    Icon = "bell",
})
_win:Tag({Title = "v0.0.0.1", Color = Color3.fromRGB(0,255,0)})
local Players = game:GetService("Players")
local LocalP = Players.LocalPlayer
local Character = LocalP.Character or LocalP.CharacterAdded:Wait()
local Hum = Character:WaitForChild("Humanoid")
local Tab1 = _win:Tab({Title = "Home", Icon = "house"})
Tab1:Section({Title = "Community Support", TextXAlignment = "Left", TextSize = 17})
Tab1:Button({Title = _u("return \"".._s("Discord").."\""), Desc = _u("return \"".._s("click to copy link").."\""), Callback = function() if setclipboard then setclipboard(_u("return \"".._s("https://discord.gg/jdmX43t5mY").."\"")) end end})
Tab1:Section({Title = _u("return \"".._s("Every time there is a game update or someone reports something, I will fix it as soon as possible.").."\""), TextXAlignment = "Left", TextSize = 17})
local Tab2 = _win:Tab({Title = "Players", Icon = "user"})
Tab2:Input({Title = _u("return \"".._s("WalkSpeed").."\""), Desc = _u("return \"".._s("Minimum 16 speed").."\""), Value = "16", InputIcon = "bird", Type = "Input", Placeholder = _u("return \"".._s("Enter number...").."\""), Callback = function(input)local sp=tonumber(input) if sp and sp>=16 then Hum.WalkSpeed = sp else Hum.WalkSpeed = 16 end end})
Tab2:Input({Title = _u("return \"".._s("Jump Power").."\""), Desc = _u("return \"".._s("Minimum 50 jump").."\""), Value = "50", InputIcon = "bird", Type = "Input", Placeholder = _u("return \"".._s("Enter number...").."\""), Callback = function(input)local v=tonumber(input) if v then _G.CustomJumpPower = v local h = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true; h.JumpPower = v end end end})
Tab2:Button({Title = _u("return \"".._s("Reset Jump Power").."\""), Desc = _u("return \"".._s("Return Jump Power to normal (50)").."\""), Callback = function() _G.CustomJumpPower = 50 local h = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower=true; h.JumpPower = 50 end end})
game.Players.LocalPlayer.CharacterAdded:Connect(function(c)local H = c:WaitForChild("Humanoid") H.UseJumpPower = true H.JumpPower = _G.CustomJumpPower or 50 end)
Tab2:Button({Title = _u("return \"".._s("Reset Speed").."\""), Desc = _u("return \"".._s("Return speed to normal (16)").."\""), Callback = function() Hum.WalkSpeed = 16 end})
local UIS = game:GetService("UserInputService")
Tab2:Toggle({Title = _u("return \"".._s("Infinite Jump").."\""), Desc = _u("return \"".._s("activate to use infinite jump").."\""), Icon = "bird", Type = "Checkbox", Default = false, Callback = function(state) _G.InfiniteJump = state end})
UIS.JumpRequest:Connect(function() if _G.InfiniteJump then local ch = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait() local h = ch:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)
local Tab3 = _win:Tab({Title = "Main", Icon = "landmark"})
Tab3:Section({Title = "Main", TextXAlignment = "Left", TextSize = 17})
Tab3:Toggle({Title = _u("return \"".._s("Auto Sell").."\""), Desc = _u("return \"".._s("Automatic fish sales").."\""), Icon = "coins", Type = "Checkbox", Default = false, Callback = function(state) _G.AutoSell = state task.spawn(function() while _G.AutoSell do task.wait(0.5) local rs = game:GetService("ReplicatedStorage") for _,v in pairs(rs:GetDescendants()) do if v:IsA("RemoteEvent") and v.Name:lower():find("sell") then v:FireServer() elseif v:IsA("RemoteFunction") and v.Name:lower():find("sell") then pcall(function() v:InvokeServer() end) end end end end) end})
Tab3:Section({Title = _u("return \"".._s("Opsional").."\""), TextXAlignment = "Left", TextSize = 17})
Tab3:Toggle({Title = _u("return \"".._s("Instant Catch").."\""), Desc = _u("return \"".._s("Get fish straight away").."\""), Icon = "fish", Type = "Checkbox", Default = false, Callback = function(state) _G.InstantCatch = state if state then if _loopRunning then return end _loopRunning = true task.spawn(function() while _G.InstantCatch do local remote = findRemote(REMOTE_NAME) if remote then local ok,err = tryFire(remote) if not ok then warn(err) end else warn("remote not found") end task.wait(TRY_INTERVAL) end _loopRunning=false end) end end})
Tab3:Button({Title = _u("return \"".._s("Scan Fish Remotes").."\""), Desc = _u("return \"".._s("Search for remote with the word 'fish'").."\""), Callback = function() scanRemotes() end})
local Tab4 = _win:Tab({Title = "Teleport", Icon = "map-pin"})
Tab4:Section({Title = "Island", TextXAlignment = "Left", TextSize = 17})
Tab4:Dropdown({Title = _u("return \"".._s("Select Location").."\""), Values = { "Esoteric Island","Konoha","Coral Refs","Enchant Room","Tropical Grove","Weather Machine" }, Callback = function(Value) local Locations = { ["Esoteric Island"]=Vector3.new(1990,5,1398), ["Konoha"]=Vector3.new(-603,3,719), ["Coral Refs"]=Vector3.new(-2855,47,1996), ["Enchant Room"]=Vector3.new(3221,-1303,1406), ["Treasure Room"]=Vector3.new(-3600,-267,-1575), ["Tropical Grove"]=Vector3.new(-2091,6,3703), ["Weather Machine"]=Vector3.new(-1508,6,1895) } local P = game.Players.LocalPlayer if P.Character and P.Character:FindFirstChild("HumanoidRootPart") then P.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value]) end end})
Tab4:Section({Title = "fishing spot", TextXAlignment = "Left", TextSize = 17})
Tab4:Dropdown({Title = _u("return \"".._s("Select Location").."\""), Values = {"Spawn","Konoha","Coral Refs","Volcano","Sysyphus Statue"}, Callback = function(Value) local Locations = { ["Spawn"]=Vector3.new(33,9,2810), ["Konoha"]=Vector3.new(-603,3,719), ["Coral Refs"]=Vector3.new(-2855,47,1996), ["Volcano"]=Vector3.new(-632,55,197), ["Sysyphus Statue"]=Vector3.new(-3693,-136,-1045) } local P=game.Players.LocalPlayer if P.Character and P.Character:FindFirstChild("HumanoidRootPart") then P.Character.HumanoidRootPart.CFrame = CFrame.new(Locations[Value]) end end})
local Tab5 = _win:Tab({Title = "Settings", Icon = "settings"})
Tab5:Toggle({Title = _u("return \"".._s("AntiAFK").."\""), Desc = _u("return \"".._s("Prevent Roblox from kicking you when idle").."\""), Icon = false, Type = false, Default = false, Callback = function(state) _G.AntiAFK = state task.spawn(function() while _G.AntiAFK do task.wait(60) pcall(function() local V = game:GetService("VirtualUser") V:CaptureController() V:ClickButton2(Vector2.new()) end) end end) if state then game:GetService("StarterGui"):SetCore("SendNotification",{Title=_u("return \"".._s("AntiAFK loaded!").."\""), Text=_u("return \"".._s("Coded By Kirsiasc").."\""), Button1="Okey", Duration=5}) else game:GetService("StarterGui"):SetCore("SendNotification",{Title=_u("return \"".._s("AntiAFK Disabled").."\""), Text=_u("return \"".._s("Stopped AntiAFK").."\""), Duration=3}) end end})
Tab5:Toggle({Title = _u("return \"".._s("Auto Reconnect").."\""), Desc = _u("return \"".._s("Automatic reconnect if disconnected").."\""), Icon = false, Default = false, Callback = function(state) _G.AutoReconnect = state if state then task.spawn(function() while _G.AutoReconnect do task.wait(2) local reconnectUI = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui") if reconnectUI then local prompt = reconnectUI:FindFirstChild("promptOverlay") if prompt then local button = prompt:FindFirstChild("ButtonPrimary") if button and button.Visible then firesignal(button.MouseButton1Click) end end end end end) end end})
