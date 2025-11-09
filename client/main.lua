local playerblackListed = false
local directorblackListed = false

-- LOAD
print('Blacklist vehicle script by Abel Gaming has been loaded.')
TriggerServerEvent('BLRP_CARWHITELIST:AddPlayers')
TriggerServerEvent('BLRP_CARWHITELIST:CheckPlayer')
TriggerServerEvent('BLRP_CARWHITELIST:AddDirectors')
TriggerServerEvent('BLRP_CARWHITELIST:CheckDirectors')

-------------------- COMMANDS -------------------- (This can be used to grant temporary access to blacklisted vehicles)
RegisterCommand("blacklistpass", function(source, args)
	local password = args[1]
	if password == Config.BlacklistPassword then
		playerblackListed = true
		SuccessMessage('You are now whitelisted!')
	end
end, false)

-------------------- EVENTS --------------------
RegisterNetEvent('BLRP_CARWHITELIST:PlayerReturn')
AddEventHandler('BLRP_CARWHITELIST:PlayerReturn', function(canDrive, playerName)
	if canDrive then
		playerblackListed = true
		--sendChatMessageNormal('Welcome back ~b~' .. playerName .. '~w~! Vehicle whitelist is ~g~approved~w~ for you!')
	end
end)

RegisterNetEvent('BLRP_CARWHITELIST:DirectorReturn')
AddEventHandler('BLRP_CARWHITELIST:DirectorReturn', function(canDrive, playerName)
	if canDrive then
		directorblackListed = true
		--sendChatMessageNormal('Welcome back ~b~' .. playerName .. '~w~! Vehicle whitelist is ~g~approved~w~ for you!')
	end
end)
-------------------- THREADS --------------------
Citizen.CreateThread(function()
	while true do
		Wait(1)
		
		-- Check to see if the player is in a vehicle
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			v = GetVehiclePedIsIn(playerPed, false)
		end
		
		-- Define the playerPed
		playerPed = GetPlayerPed(-1)
		
		-- Check to see if the vehicle is blacklisted
		if playerblackListed == false and playerPed and v then
			if GetPedInVehicleSeat(v, -1) == playerPed then
				checkCar(GetVehiclePedIsIn(playerPed, false))
				checkDirectorCar(GetVehiclePedIsIn(playerPed, false))
			end
		end
	end
end)
-------------------- FUNCTIONS --------------------
function checkCar(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)

		if isCarBlacklisted(carModel) then
			DeleteEntity(car)
			sendChatMessage("This vehicle is blacklisted!")
		end
	end
end

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(Config.BlacklistVehicles) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end
	
	return false
end

function checkDirectorCar(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)

		if isCarBlacklistedForDirector(carModel) then
			DeleteEntity(car)
			sendChatMessage("This vehicle is blacklisted!")
		end
	end
end

function isCarBlacklistedForDirector(model)
	for _, blacklistedCar in pairs(Config.DirectorVehicles) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end
	
	return false
end

function ErrorMessage(errorMessage)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName('~r~[ERROR]~w~ ' .. errorMessage)
	DrawNotification(false, true)
end

function InfoMessage(message)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName('~y~[INFO]~w~ ' .. message)
	DrawNotification(false, true)
end

function SuccessMessage(successMessage)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName('~g~[SUCCESS]~w~ ' .. successMessage)
	DrawNotification(false, true)
end

function sendChatMessage(message)
	TriggerEvent("chatMessage", "", {0, 0, 0}, "^1" .. message)
end

function sendChatMessageNormal(message)
	TriggerEvent("chatMessage", "", {0, 0, 0}, "^7" .. message)
end