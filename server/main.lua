---@diagnostic disable: undefined-global
RegisterServerEvent("SiriusDeath:RevivePed")
AddEventHandler("SiriusDeath:RevivePed", function(plr)
    TriggerClientEvent("SiriusDeath:HelpUpPlayer", plr)
end)

RegisterCommand('adrev', function(source, args, rawCommand)
    local target = tonumber(args[1])

    if not target then
        target = source
    end

    if IsPlayerAceAllowed(source, Config.ReviveAce) then

    if target then
        TriggerClientEvent('SiriusDeath:RevivePlayer', target)
    else
        TriggerClientEvent('SiriusDeath:RevivePlayer', source)
    end
end
end)

RegisterCommand('adres', function(source, args, rawCommand)
    local target = tonumber(args[1])
    if IsPlayerAceAllowed(source, Config.RespawnAce) then
        if target then
            local targetPed = GetPlayerPed(target)
            if targetPed and targetPed ~= -1 then
                TriggerClientEvent('SiriusDeath:RespawnPlayer', target)
            end
        else
            TriggerClientEvent('SiriusDeath:RespawnPlayer', source)
        end
    end
end)
