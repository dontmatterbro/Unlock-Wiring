local wiringstatus = nil

--enable singleplayer wiring
Hook.Add("roundStart", "enablesingleplayerwiring", function()

	if CLIENT and not Game.IsMultiplayer then 

		for item in Item.ItemList do		
			
			local connectionPanel = item.GetComponentString("ConnectionPanel")
				
			if connectionPanel then
				connectionPanel.Locked = false
			end
			
		end
		
		print("‖color:0,255,0‖".."All Wires Unlocked!".."‖color:end‖")
	end
	
end)

--multiplayer commands
Hook.Add("chatMessage", "wiringcommand", function (message, client)

	if CLIENT and not Game.IsMultiplayer then return end --don't let this run on singleplayer
	
	if message == "!wiring" then
		
		if CLIENT and Game.IsMultiplayer then return end
			
		if CheckPermission(client) then return end
		
		if wiringstatus == nil then SetWiringStatus() end
		
		--RemoveMessage(message)
		
		Timer.Wait(function()
			local chatMessage = ChatMessage.Create("",
			
					"‖color:255,255,255‖".."Wiring Status: ".."‖color:end‖"..wiringstatus
			.."\n"
			.."\n".."‖color:175,175,255‖".."Commands:".."‖color:end‖"
			.."\n".."‖color:175,175,175‖".."!wiring unlock sub".."‖color:end‖"
			.."\n".."‖color:175,175,175‖".."!wiring unlock".."‖color:end‖"
			.."\n".."‖color:175,175,175‖".."!wiring lock".."‖color:end‖"
			
			,ChatMessageType.Default, nil, nil)

			Game.SendDirectChatMessage(chatMessage, client)
		end, 10)
	end


	if message == "!wiring unlock sub" then 
	
		if CheckPermission(client) then return end
	
		UnlockWiringSub()
		
		if CLIENT and Game.IsMultiplayer then return end
		
		Timer.Wait(function()
			local chatMessage = ChatMessage.Create("",
			
			"‖color:255,255,255‖".."Wiring Status: ".."‖color:end‖".."‖color:0,255,0‖".."Submarine Unlocked".."‖color:end‖"
			
			,ChatMessageType.Default, nil, nil)

			Game.SendDirectChatMessage(chatMessage, client)
		end, 10)
	end
	
	
	if message == "!wiring unlock" then 
	
		if CheckPermission(client) then return end
	
		UnlockWiringAll()
		
		if CLIENT and Game.IsMultiplayer then return end
		
		Timer.Wait(function()
			local chatMessage = ChatMessage.Create("",
			
			"‖color:255,255,255‖".."Wiring Status: ".."‖color:end‖".."‖color:0,255,0‖".."All Unlocked".."‖color:end‖"
			
			,ChatMessageType.Default, nil, nil)

			Game.SendDirectChatMessage(chatMessage, client)
		end, 10)
	end
	
	if message == "!wiring lock" then 
		
		if CheckPermission(client) then return end
	
		LockWiring()
		
		if CLIENT and Game.IsMultiplayer then return end
		
		Timer.Wait(function()
			local chatMessage = ChatMessage.Create("",
			
			"‖color:255,255,255‖".."Wiring Status: ".."‖color:end‖".."‖color:255,0,0‖".."Locked".."‖color:end‖"
			
			,ChatMessageType.Default, nil, nil)

			Game.SendDirectChatMessage(chatMessage, client)
		end, 10)
		
	end
	
end)

function SetWiringStatus()
	if 
		Game.ServerSettings.AllowRewiring 
	then 
		wiringstatus = "‖color:0,255,0‖".."Submarine Unlocked".."‖color:end‖"
	else 
		wiringstatus = "‖color:255,0,0‖".."Locked".."‖color:end‖"
	end
end

function UnlockWiringSub()

    for item in Item.ItemList do

		if item.InPlayerSubmarine then 
		
			local connectionPanel = item.GetComponentString("ConnectionPanel")
			
			if connectionPanel then
			   connectionPanel.Locked = false
			end
		end
		
    end
	
	Game.ServerSettings.AllowRewiring=true
	Game.ServerSettings.LockAllDefaultWires=false
	Game.ServerSettings.ForcePropertyUpdate()
	
	if not wiringstatus=="‖color:0,255,0‖".."All Unlocked".."‖color:end‖" then
	wiringstatus = "‖color:0,255,0‖".."Submarine Unlocked".."‖color:end‖" end
	
end

function UnlockWiringAll()

    for item in Item.ItemList do		
		
		local connectionPanel = item.GetComponentString("ConnectionPanel")
			
		if connectionPanel then
			connectionPanel.Locked = false
		end
		
    end

	Game.ServerSettings.AllowRewiring=true
	Game.ServerSettings.LockAllDefaultWires=false
	Game.ServerSettings.ForcePropertyUpdate()

	wiringstatus = "‖color:0,255,0‖".."All Unlocked".."‖color:end‖"
	
end
	
function LockWiring()

    for item in Item.ItemList do
	
        local connectionPanel = item.GetComponentString("ConnectionPanel")
		
        if connectionPanel then
           connectionPanel.Locked = true
        end
    end
	
	Game.ServerSettings.AllowRewiring=false
	Game.ServerSettings.ForcePropertyUpdate()
	
	wiringstatus = "‖color:255,0,0‖".."Locked".."‖color:end‖"
	
end


function CheckPermission(client)

	if 
		client.HasPermission(512) --ManageSettings
	then 		
		return false
	else 
	
		local chatMessage = ChatMessage.Create("",
		
		"‖color:255,0,0‖".."You do not have permission to change this setting. (Manage Settings)".."‖color:end‖"
		
		,ChatMessageType.Default, nil, nil)

		Game.SendDirectChatMessage(chatMessage, client)
		
		return true 
	end
	
end
