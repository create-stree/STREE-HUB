local success, StreeHub = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/create-stree/UI.Library/refs/heads/main/StreeHub.lua"))()
end)

if not success or not StreeHub then
    warn("⚠️ UI failed to load!")
    return
else
    print("✓ UI loaded successfully!")
end

local Window = StreeHub:Window({
    Title   = "StreeHub |",
    Footer  = "Escape Tsunami For Brainrot",
    Images  = "128806139932217",
    Color   = Color3.fromRGB(57, 255, 20),
    Theme   = 122376116281975,
    ThemeTransparency = 0.15,
    ["Tab Width"] = 120,
    Version = 1,
})

local function notify(msg, delay, color, title, desc)

    return StreeHub:MakeNotify({

        Title = title or "StreeHub",

        Description = desc or "Notification",

        Content = msg or "Content",

        Color = color or Color3.fromRGB(57, 255, 20),

        Delay = delay or 4

    })

end



local Tabs = {

    Info = Window:AddTab({ Name = "Information", Icon = "info" }),

    Player = Window:AddTab({ Name = "Player", Icon = "user" }),

    Main = Window:AddTab({ Name = "Main", Icon = "landmark" }),

    Gaps = Window:AddTab({ Name = "Gaps", Icon = "gps" }),

    Shop = Window:AddTab({ Name = "Shop", Icon = "shop" }),

}



v1 = Tabs.Info:AddSection("Discord", true)



v1:AddParagraph({

    Title = "Join Our Discord",

    Content = "Join Us!",

    Icon = "discord",

    ButtonText = "Copy Discord Link",

    ButtonCallback = function()

        local link = "https://discord.gg/VU2mCHg59"

        if setclipboard then

            setclipboard(link)

            notify("Successfully Copied!")

        end

    end

})



x1 = Tabs.Player:AddSection("Player")



local P = game.Players.LocalPlayer

local UIS = game:GetService("UserInputService")

_G.InfiniteJump = false



x1:AddToggle({

    Title = "Infinite Jump",

    Content = "Makes you jump without limits",

    Default = false,

    Callback = function(state)

        _G.InfiniteJump = state

    end

})



UIS.JumpRequest:Connect(function()

    if _G.InfiniteJump then

        local h = P.Character and P.Character:FindFirstChildOfClass("Humanoid")

        if h then

            h:ChangeState(Enum.HumanoidStateType.Jumping)

        end

    end

end)



local P = game:GetService("Players").LocalPlayer

local Z = {P.CameraMaxZoomDistance, P.CameraMinZoomDistance}



x1:AddToggle({

    Title = "Infinite Zoom",

    Default = false,

    Callback=function(s)

        if s then

            P.CameraMaxZoomDistance=math.huge

            P.CameraMinZoomDistance=.5

        else

            P.CameraMaxZoomDistance=Z[1] or 128

            P.CameraMinZoomDistance=Z[2] or .5

        end

    end

})



x2 = Tabs.Main:AddSection("Main")



local ProximityPromptService = game:GetService("ProximityPromptService")



local InstantPrompt = false

local cache = {} -- simpan HoldDuration asli



-- apply ke 1 prompt

local function applyPrompt(prompt)

	if not cache[prompt] then

		cache[prompt] = prompt.HoldDuration

	end



	prompt.HoldDuration = 0

	prompt.RequiresLineOfSight = false

end



-- restore 1 prompt

local function restorePrompt(prompt)

	if cache[prompt] then

		prompt.HoldDuration = cache[prompt]

	end

end



x2:AddToggle({

	Title = "Instant Interact",

	Default = false,

	Callback = function(state)

		InstantPrompt = state



		for _, v in ipairs(workspace:GetDescendants()) do

			if v:IsA("ProximityPrompt") then

				if state then

					applyPrompt(v)

				else

					restorePrompt(v)

				end

			end

		end

	end

})



-- detect prompt baru

workspace.DescendantAdded:Connect(function(v)

	if InstantPrompt and v:IsA("ProximityPrompt") then

		task.wait()

		applyPrompt(v)

	end

end)



x2:AddDivider()



local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")



local Player = Players.LocalPlayer



local Remote = ReplicatedStorage

    :WaitForChild("Packages")

    :WaitForChild("Net")

    :WaitForChild("RF/Plot.PlotAction")



local AutoCollect = false



local SlotList = {}

for i = 1,20 do

    table.insert(SlotList, tostring(i))

end



local function GetMyBaseName()

    local basesFolder = workspace:WaitForChild("Bases")

    local character = Player.Character

    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then return nil end



    local closestBase = nil

    local shortestDistance = math.huge



    for _, base in pairs(basesFolder:GetChildren()) do

        if base:IsA("Model") and base.PrimaryPart then

            local distance = (base.PrimaryPart.Position - root.Position).Magnitude

            if distance < shortestDistance then

                shortestDistance = distance

                closestBase = base

            end

        end

    end



    if closestBase then

        return closestBase.Name

    end



    return nil

end



task.spawn(function()

    while task.wait(1) do

        if AutoCollect then



            local BaseName = GetMyBaseName()

            if not BaseName then continue end



            for _, slot in ipairs(SlotList) do

                if not AutoCollect then break end



                pcall(function()

                    Remote:InvokeServer(

                        "Collect Money",

                        BaseName,

                        slot

                    )

                end)



                task.wait(0.05)

            end

        end

    end

end)



x2:AddToggle({

    Title = "Auto Collect Cash",

    Content = "must be near the base",

    Default = false,

    Callback = function(state)

        AutoCollect = state

    end

})





x2:AddDivider()



local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RebirthRemote = ReplicatedStorage

    :WaitForChild("RemoteFunctions")

    :WaitForChild("Rebirth")



_G.AutoRebirth = false



task.spawn(function()

    while task.wait(1) do

        if _G.AutoRebirth then

            pcall(function()

                RebirthRemote:InvokeServer()

            end)

        end

    end

end)



x2:AddToggle({

    Title = "Auto Rebirth",

    Default = false,

    Callback = function(state)

        _G.AutoRebirth = state

    end

})



x2:AddDivider()



local AutoSellTool = false

local SellDelay = 1



x2:AddInput({

    Title = "Sell Tool Delay",

    Default = "1",

    Content = "Input Delay (seconds)",

    Numeric = true,

    Callback = function(val)

        local num = tonumber(val)

        if num then

            SellDelay = num

            notify("Sell Tool delay set to " .. num .. " Seconds")

        else

            notify("Invalid delay input")

        end

    end

})



x2:AddToggle({

    Title = "Auto Sell Tool",

    Default = false,

    Callback = function(state)

        AutoSellTool = state

        

        if state then

            notify("Auto Sell Tool ON")

            

            task.spawn(function()

                while AutoSellTool do

                    game:GetService("ReplicatedStorage")

                        :WaitForChild("RemoteFunctions")

                        :WaitForChild("SellTool")

                        :InvokeServer()



                    task.wait(SellDelay)

                end

            end)

        else

            notify("Auto Sell Tool OFF")

        end

    end

})



x2:AddButton({

    Title = "Sell All Inventory",

    Callback = function()

        game:GetService("ReplicatedStorage")

            :WaitForChild("RemoteFunctions")

            :WaitForChild("SellAll")

            :InvokeServer()



        notify("Successfully Sold All Inventory")

    end

})



x2 = Tabs.Main:AddSection("Gamepass")



local RunService = game:GetService("RunService")



local Enabled = false

local Backup = {}

local Connection



local function getVIP()

    local map = workspace:FindFirstChild("DefaultMap_SharedInstances", true)

    if not map then return end

    return map:FindFirstChild("VIPWalls")

end



local function backupVIP(vip)

    Backup = {}

    for _, v in ipairs(vip:GetChildren()) do

        table.insert(Backup, v:Clone())

    end

end



local function restoreVIP(vip)

    vip:ClearAllChildren()

    for _, v in ipairs(Backup) do

        v:Clone().Parent = vip

    end

end



local function enableVIP()

    local vip = getVIP()

    if not vip then return end



    if #Backup == 0 then

        backupVIP(vip)

    end



    Connection = RunService.Heartbeat:Connect(function()

        for _, v in ipairs(vip:GetDescendants()) do

            if v:IsA("BasePart") then

                v.CanCollide = false

            end

            if v:IsA("GuiObject")

            or v:IsA("Decal")

            or v:IsA("Texture")

            or v.Name:lower():match("vip") then

                pcall(function()

                    v:Destroy()

                end)

            end

        end

    end)

end



local function disableVIP()

    if Connection then

        Connection:Disconnect()

        Connection = nil

    end



    local vip = getVIP()

    if vip and #Backup > 0 then

        restoreVIP(vip)

    end

end



x2:AddButton({

    Title = "Unlock Vip And Vip+",

    Callback = function()

        Enabled = not Enabled



        if Enabled then

            notify("VIP Walls Disabled")

            enableVIP()

        else

            notify("VIP Walls Restored")

            disableVIP()

        end

    end

})



x11 = Tabs.Gaps:AddSection("Gaps")



x11:AddParagraph({

    Title = "Read this! ",

    Content = "You must go to gaps one by one. \nnot directly to a far gaps because there is an anti teleport meassure",

    Icon = "alert",

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(206, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.00000000000001, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 1",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(289, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.0000001, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 2",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(399, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.00001, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 3",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(548, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.00001, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 4",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(761, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.00001, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 5",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(1078, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.005, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 6",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(1574, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.08, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 7",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(2279, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.7, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 8",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(2984, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.8, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end



x11:AddButton({

    Title = "Teleport to Gap 9",

    Callback = function()

        TweenToPosition(targetPos)

    end

})



local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")

local player = Players.LocalPlayer



local targetPos = Vector3.new(3339, -3, -1)



local function TweenToPosition(pos)

    local char = player.Character or player.CharacterAdded:Wait()

    local hrp = char:WaitForChild("HumanoidRootPart")



    local tweenInfo = TweenInfo.new(

        0.08, -- durasi (detik)

        Enum.EasingStyle.Quad,

        Enum.EasingDirection.Out

    )



    local goal = {

        CFrame = CFrame.new(pos)

    }



    local tween = TweenService:Create(hrp, tweenInfo, goal)

    tween:Play()

end

x11:AddButton({
    Title = "Teleport to Gap 10",
    Callback = function()
        TweenToPosition(targetPos)
    end
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local targetPos = Vector3.new(3694, -3, -1)

local function TweenToPosition(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local tweenInfo = TweenInfo.new(
        0.08, -- durasi (detik)
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    local goal = {
        CFrame = CFrame.new(pos)
    }

    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
end

x11:AddButton({
    Title = "Teleport to Gap 11",
    Callback = function()
        TweenToPosition(targetPos)
    end
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local targetPos = Vector3.new(4049, -3, -1)

local function TweenToPosition(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local tweenInfo = TweenInfo.new(
        0.08,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    local goal = {
        CFrame = CFrame.new(pos)
    }

    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
end

x11:AddButton({
    Title = "Teleport to Gap 12",
    Callback = function()
        TweenToPosition(targetPos)
    end
})

x3 = Tabs.Shop:AddSection("Upgrade Speed")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradeRemote = ReplicatedStorage
    :WaitForChild("RemoteFunctions")
    :WaitForChild("UpgradeSpeed")

_G.AutoUpgradeSpeed = false

task.spawn(function()
    while task.wait(0.1) do 
        if _G.AutoUpgradeSpeed then
            pcall(function()
				UpgradeRemote:InvokeServer(1)
            end)
        end
    end
end)

x3:AddToggle({
    Title = "Auto Upgrade Speed +1",
    Default = false,
    Callback = function(state)
        _G.AutoUpgradeSpeed = state
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradeRemote = ReplicatedStorage
    :WaitForChild("RemoteFunctions")
    :WaitForChild("UpgradeSpeed")

_G.AutoUpgradeSpeed = false

task.spawn(function()
    while task.wait(0.1) do 
        if _G.AutoUpgradeSpeed then
            pcall(function()
                UpgradeRemote:InvokeServer(10)
            end)
        end
    end
end)

x3:AddToggle({
    Title = "Auto Upgrade Speed +10",
    Default = false,
    Callback = function(state)
        _G.AutoUpgradeSpeed = state
    end
})

x3:AddButton({
	Title = "Upgrade Speed +1",
	Callback = function()
		game:GetService("ReplicatedStorage")
			:WaitForChild("RemoteFunctions")
			:WaitForChild("UpgradeSpeed")
			:InvokeServer(1)
	end
})

x3:AddButton({
	Title = "Upgrade Speed +10",
	Callback = function()
		game:GetService("ReplicatedStorage")
			:WaitForChild("RemoteFunctions")
			:WaitForChild("UpgradeSpeed")
			:InvokeServer(3)
	end
})

x3 = Tabs.Shop:AddSection("Upgrade Carry")

x3:AddButton({
	Title = "Upgrade Carry",
	Callback = function()
		game:GetService("ReplicatedStorage")
			:WaitForChild("RemoteFunctions")
			:WaitForChild("UpgradeCarry")
			:InvokeServer()
	end
})

if Window then
    notify("Thanks For Using Premium StreeHub!")
end

--// ANTI AFK 
local VIM=game:GetService("VirtualInputManager")
task.spawn(function()
 while true do
  task.wait(math.random(600,700))
  local k={{Enum.KeyCode.LeftShift,Enum.KeyCode.E},{Enum.KeyCode.LeftControl,Enum.KeyCode.F},{Enum.KeyCode.LeftShift,Enum.KeyCode.Q},{Enum.KeyCode.E,Enum.KeyCode.F}}
  local c=k[math.random(#k)]
  pcall(function()
   for _,x in pairs(c)do VIM:SendKeyEvent(true,x,false,nil)end
   task.wait(.1)
   for _,x in pairs(c)do VIM:SendKeyEvent(false,x,false,nil)end
  end)
 end
end)
