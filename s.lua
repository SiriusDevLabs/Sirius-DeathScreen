---@diagnostic disable: undefined-global
RegisterServerEvent("NahRyan:RevivePed")
AddEventHandler("NahRyan:RevivePed", function(plr)
    TriggerClientEvent("NahRyan:HelpUpPlayer", plr)
end)

RegisterCommand("revive", function(source, args, rawCommand)
    if exports["fivem-purge"]:Purge() then
        TriggerClientEvent("fivem-purge:clientRevive", source)
    else
        TriggerClientEvent('codem-notification', source, "Revive is only allowed during an active purge!", 4000, "error")
    end
end)

RegisterCommand('adrev', function(source, args, rawCommand)
    local target = tonumber(args[1])

    if not target then
        target = source
    end
        
    -- if Player(source).state['SASNET:IsStaff'] == "true" then
        local targetName = GetPlayerName(target)
        
        if target then
            TriggerClientEvent('NahRyan:RevivePlayer', target)  
            TriggerClientEvent('codem-notification', source, "Successfully Revived Player: <b>" .. targetName .. "</b>", 4000, "check")
            TriggerEvent('Kratos-Logging:AdrevLogs', source, GetPlayerName(source), targetName)

        else
            TriggerClientEvent('NahRyan:RevivePlayer', source)  
            TriggerClientEvent('codem-notification', source, "You have successfully revived yourself.", 4000, "check")
            TriggerEvent('Kratos-Logging:AdrevLogs', source, GetPlayerName(source), GetPlayerName(source))
        end
    -- else
    --     TriggerClientEvent('codem-notification', source, "You must be clocked in to use this command.", 4000, "error")
    -- end
end)

RegisterCommand('adres', function(source, args, rawCommand)
    local target = tonumber(args[1])
    -- if Player(source).state['SASNET:IsStaff'] == "true" then
        if target then
            local targetPed = GetPlayerPed(target)
            if targetPed and targetPed ~= -1 then
                TriggerClientEvent('NahRyan:RespawnPlayer', target)
                TriggerClientEvent('codem-notification', source, "Successfully respawned player: <b>" .. GetPlayerName(target) .. "</b>", 4000, "check")
                TriggerEvent('Kratos-Logging:AdresLogs', source, GetPlayerName(source), GetPlayerName(target))
            else
                TriggerClientEvent('codem-notification', source, "Invalid target player.", 4000, "error")
            end
        else
            TriggerClientEvent('NahRyan:RespawnPlayer', source)
            TriggerClientEvent('codem-notification', source, "You have successfully respawned yourself.", 4000, "check")
            TriggerEvent('Kratos-Logging:AdresLogs', source, GetPlayerName(source), GetPlayerName(source))
        end
    -- else
    --     TriggerClientEvent('codem-notification', source, "You must be clocked in to use this command.", 4000, "error")
    -- end
end)
