local function checkIdentity()
	Framework.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)	
		if not skin or skin == nil or skin == {} then
			TriggerEvent("Identity:showRegisterIdentity")
		else
			TriggerEvent("skinchanger:loadSkin", skin)
		end
	end)
end

AddEventHandler("Framework:loadingScreenOff", function()
	checkIdentity()
end)

local guiEnabled, isDead = false, false

AddEventHandler("Framework:onPlayerDeath", function(data)
	isDead = true
end)

AddEventHandler("Framework:onPlayerSpawn", function(spawn)
	isDead = false
end)

local function EnableGui(state)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = "enableui",
		enable = state
	})
end

AddEventHandler("Identity:showRegisterIdentity", function()
	if not isDead then
		EnableGui(true)
		disableControls()
		Framework.SetTimeout(5000, function() -- force the nui mouse to show
			SetNuiFocus(false, false)
			SetNuiFocus(true, true)
		end)
	end
end)

RegisterNUICallback("register", function(data, cb)
	Framework.TriggerServerCallback("Identity:registerIdentity", function(callback)
		if callback then
			Framework.ShowNotification(_U("thank_you_for_registering"))
			EnableGui(false)
			TriggerEvent("esx_skin:playerRegistered")
		else
			Framework.ShowNotification(_U("registration_error"))
		end
	end, data)
end)

function disableControls()
	CreateThread(function()
		while guiEnabled do 
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30, true) -- MoveLeftRight
			DisableControlAction(0, 31, true) -- MoveUpDown
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
			Wait(0)
		end
	end)
end