local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local placeId = tonumber(game.PlaceId)
_G.scripts_key = tostring(_G.scripts_key or scripts_key or "FREE_USER")

local streeLogo = "rbxassetid://128806139932217"

local premiumKeys = {
"hRCWybDuIIxXeREImBbvjsEueohPzTfX","kRpXaVnqZyLhTjBfGmWcSdEoUiNpQvJ",
"YtHqFzPaKrXeBwNuDjMiVsGoClLrSnQe","pZxYvQmAaTrWnGfBqCkJdEoHsLuVtSiN",
"wJzDnQyGmTcLkVxEoPaFbSgRrUuMiZh","eBtXqNpRzVhLkCmSgJaWiFuTdOyQnPc",
"qYwRzEbTgLkPmDaVxHnUiFsCoSjMvNQ","ZkWmNtGpQrHxSaJlDyCfVuEbLoPiTnR",
"vQbJnGzHcTtXoLwFfAqSmPrYiEdKuNM","hZpRkQyUxWaJmTfVnSgCoLdEiBtNsMQ",

"hKQZrXvTnMFaJpLwSgDBeEYcUoNiRA","QmYBvDZoTnCwLrHFaXkUJEpSgNiVMQ",
"XoZKQnYJpLrEHTwSgDMBaFiCvUqRNP","nFvTQwXgYHKEoLaSBDZCUMJpRNiVTF",
"ZxJvXHnYkSgBLCMTFUpQoDaERwViNP","rTnMZQXvJHLFSCYwBKaUpgDoENiVPM",
"vBFSHkJXnLZCwQpDgMTUYoaERViNPQ","QpHnZLBkTgXvFMCwSYDoUaJERiVNQP",
"XQYpJkLCMZBvDgSwnHToFUERNiVPMQ","JXoZkYpLHQwMBnDgCvTFSUERiVNPQM",

"MTZLwXHnYkQgJpDCSBFoUvERiNPMQX","ZgYJQXkHnBvTFUoMCSwDLpERiNPMQV",
"wJXHnZkYFQpDvSLCMToUBgERiNPMQV","XwYkJZHQnMBCgTFDvUSpLoERiNPMQV",
"QZJXkHMYnLwBTDpCgUSFoERiNPMQVX","HXkZBvJMYQwDnTLpUCSFgERiNPMQVX",
"JkQHnXMYDvZLBFoCgSwUTpERiNPMQV","YJXQkZHDvMBSgTFLnUwCoERiNPMQVX",
"XkHnQZJMYpLwTDgCBUSFoERiNPMQVX","QXJZkHnYwMBgDvSCUTLpFERiNPMQVX",

"RfbTkLmNqPsAdFhGjKzXcVwQyUtIoPaSd","AzXcVbNmLpOiUyTrEwQqAsDfGhJkLmNbV",
"QwErTyUiOpAsDfGhJkLzXcVbNmLpOiUyT","MnBvCxZlKjHgFdSaQwErTyUiOpLkJhGfD",
"VwQyUtIoPaSdFgHjKlMnBvCxZqWeRtYuI","GhJkLmNbVcXzQwErTyUiOpAsDfGhJkLmN",
"XcVbNmLpOiUyTrEwQqAsDfGhJkLmNbVcX","SdFgHjKlMnBvCxZqWeRtYuIoPaSdFgHjK",
"LkJhGfDsAqWeRtYuIoPaSdFgHjKlMnBvC","PaSdFgHjKlMnBvCxZqWeRtYuIoPaSdFgH",

"xQmZbTnLcVrWpKyJdHsUfGaEiLoPnYtR","BnVcXzQpLmYtRwQkJhGfDsAzXbNmLpOt",
"YkLmNbVcXzAsDfGhJkLpOiUyTrEwQmNy","tRqWpLnMxKvBsGfHeJzDuQiYcPaLmNkQ",
"JmQnLpRtYxKvBsGhEfZaWiCuTdOyQnLu","kVxYoPaSdFgHjKlMnBvCxZqWeRtYuIoT",
"pLnMxKvBsGhEfZaWiCuTdOyQnLkVxYon","XcVbNmLpQrTyUiOpAsDfGhJkLmNbVcXs",
"sDfGhJkLmNbVcXpLnMxKvBsGhEfZaWig","HeJzDuQiYcPaLmNkVxYoPaSdFgHjKlMp",

"developer_access","ZxCvBnMaSdFgHjKlQwErTyUiOpAsDfGh",
"team_access","MnBvCxZaSdFgHjKlQwErTyUiOpLkJhGf",
"tester_access","QpWoEiRuTyAlSkDjFhGzXcVbNmQaWeRt",
"content_creator","AsDfGhJkLqWeRtYuIoPzXcVbNmLaKsJh"
"reseller_offcial","QwErTyUiOpAsDfGhJkLzXcVbNmLpQrTy"
}

local function isPremiumKey(key)
	for i=1,#premiumKeys do
		if premiumKeys[i]==key then
			return true
		end
	end
	return false
end

local userType = isPremiumKey(_G.scripts_key) and "Premium" or "Freemium"

local gameScripts = {
[127794225497302]={name="Abyss",free="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Abyss/Main.lua",premium="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Abyss/Premium.lua"},
[124311897657957]={name="Break A Lucky Block",free="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/BALB/Main.lua",premium="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/BALB/Premium.lua"},
[2753915549]={name="Blox Fruit",free="https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Main.lua",premium="https://raw.githubusercontent.com/create-stree/STREE-HUB/main/Premium.lua"},
[123921593837160]={name="Climb and Jump Tower",free="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Main.lua",premium="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Climb%20and%20Jump%20Tower/Premium.lua"},
[131623223084840]={name="Escape Tsunami For Brainrot",free="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/ETFB/Main.lua",premium="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/ETFB/Premium.lua"},
[121864768012064]={name="Fish It",free="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Main.lua",premium="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Fish_It/Premium.lua"},
[18687417158]={name="Forsaken",free="https://pandadevelopment.net/virtual/file/510939b1302a5a9c",premium="https://pandadevelopment.net/virtual/file/0ab33cd15eae6790"},
[136599248168660]={name="Solo Hunter",free="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Solo-Hunter/Main.lua",premium="https://raw.githubusercontent.com/create-stree/STREE-HUB/refs/heads/main/Solo-Hunter/Premium.lua"}
}

local function getGameData(id)
	id=tonumber(id)
	if gameScripts[id] then return gameScripts[id] end
	for k,v in pairs(gameScripts) do
		if tonumber(k)==id then return v end
	end
end

local function safeLoad(url)
	local ok,src=pcall(function() return game:HttpGet(url) end)
	if ok and src then
		local f=loadstring(src)
		if f then pcall(f) end
	end
end

local gameData=getGameData(placeId)
local gameName=gameData and gameData.name or "Unknown Game"

pcall(function()
	StarterGui:SetCore("SendNotification",{Title="STREE HUB",Text="Detected game: "..gameName,Icon=streeLogo,Duration=3})
	StarterGui:SetCore("SendNotification",{Title="STREE HUB",Text="User Type: "..userType,Icon=streeLogo,Duration=3})
end)

task.wait(1.5)

if gameData then
	if userType=="Premium" then
		pcall(function()
			StarterGui:SetCore("SendNotification",{Title="STREE HUB",Text="Loading Premium version...",Icon=streeLogo,Duration=3})
		end)
		safeLoad(gameData.premium)
	else
		pcall(function()
			StarterGui:SetCore("SendNotification",{Title="STREE HUB",Text="Loading Freemium version...",Icon=streeLogo,Duration=3})
		end)
		safeLoad(gameData.free)
	end
else
	pcall(function()
		StarterGui:SetCore("SendNotification",{Title="STREE HUB",Text="Game not supported!",Icon=streeLogo,Duration=4})
	end)
end
