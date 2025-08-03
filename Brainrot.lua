local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "STREE HUB | Steal A Brainrot | v0.00.06", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "STREE HUB",
    IntroEnabled = true,
    IntroText = "Welcome To Script STREE",
    Icon = "rbxassetid://123032091977400",
    CloseCallback = function()
        print("Window closed.")
    end,
})

local HomeTab = Window:MakeTab({
	Name = "Home",
	Icon = "rbxassetid://0",
	PremiumOnly = false
})

HomeTab:AddSection({Name = "Information"})

HomeTab:AddButton({
	Name = "Discord",
	Callback = function()
		setclipboard("https://discord.gg/jdmX43t5mY")
		OrionLib:MakeNotification({
			Name = "STREE HUB",
			Content = "Link Discord sudah disalin ke clipboard!",
			Image = "rbxassetid://11347112419",
			Time = 3
		})
	end    
})

HomeTab:AddButton({
	Name = "WhatsApp",
	Callback = function()
		setclipboard("https://whatsapp.com/channel/0029VbAwRihKAwEtwyowt62N")
		OrionLib:MakeNotification({
			Name = "STREE HUB",
			Content = "Link WhatsApp sudah disalin ke clipboard!",
			Image = "rbxassetid://11347112419",
			Time = 3
		})
	end    
})

HomeTab:AddButton({
	Name = "Telegram",
	Callback = function()
		setclipboard("https://t.me/StreeCoumminty")
		OrionLib:MakeNotification({
			Name = "STREE HUB",
			Content = "Link Telegram sudah disalin ke clipboard!",
			Image = "rbxassetid://11347112419",
			Time = 3
		})
	end    
})

HomeTab:AddSection({Name = "Website STREE Community"})

HomeTab:AddButton({
	Name = "Website",
	Callback = function()
		setclipboard("https://STREEHUB.NETLIFY.APP")
		OrionLib:MakeNotification({
			Name = "STREE HUB",
			Content = "Link Website sudah disalin ke clipboard!",
			Image = "rbxassetid://11347112419",
			Time = 3
		})
	end    
})

local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://11347112419",
	PremiumOnly = false
})

MainTab:AddSection({Name = "Players"})

local GameTab = Window:MakeTab({
	Name = "Game",
	Icon = "rbxassetid://96170009430978",
	PremiumOnly = false
})

GameTab:AddSection({Name = "Game Features"})

-- Noclip Toggle
GameTab:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(Value)
		_G.NoclipON = Value
		if Value then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/Noclip.lua"))()
		end
	end
})

-- Inf Jump Toggle
GameTab:AddToggle({
	Name = "InfJump",
	Default = false,
	Callback = function(Value)
		_G.InfJumpON = Value
		if Value then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Kirsiasc/STREE-HUB/main/InfiniteJump.lua"))()
		end
	end
})
