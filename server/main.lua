local whitelistedPlayers = {}
local whitelistedDirectors = {}

RegisterServerEvent('BLRP_CARWHITELIST:AddPlayers')
AddEventHandler('BLRP_CARWHITELIST:AddPlayers', function()
    for k,v in pairs(Config.ApprovedLicenses) do
        table.insert(whitelistedPlayers, v)
    end
end)

RegisterServerEvent('BLRP_CARWHITELIST:CheckPlayer')
AddEventHandler('BLRP_CARWHITELIST:CheckPlayer', function()
    local license  = GetPlayerIdentifier(source, 0)
    local playerName = GetPlayerName(source)

    for i=1, #whitelistedPlayers do
        for k,v in pairs(whitelistedPlayers) do
            if license == v then
                local canDrive = true
                TriggerClientEvent('BLRP_CARWHITELIST:PlayerReturn', source, canDrive, playerName)
            end
        end
    end
end)

--------- DIRECTORS ---------
RegisterServerEvent('BLRP_CARWHITELIST:AddDirectors')
AddEventHandler('BLRP_CARWHITELIST:AddDirectors', function()
    for k,v in pairs(Config.DirectorLiceneses) do
        table.insert(whitelistedDirectors, v)
    end
end)

RegisterServerEvent('BLRP_CARWHITELIST:CheckDirectors')
AddEventHandler('BLRP_CARWHITELIST:CheckDirectors', function()
    local license  = GetPlayerIdentifier(source, 0)
    local playerName = GetPlayerName(source)

    for i=1, #whitelistedPlayers do
        for k,v in pairs(whitelistedDirectors) do
            if license == v then
                local canDrive = true
                TriggerClientEvent('BLRP_CARWHITELIST:DirectorReturn', source, canDrive, playerName)
            end
        end
    end
end)