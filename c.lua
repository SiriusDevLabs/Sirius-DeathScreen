---@diagnostic disable: undefined-global
local isDead = false
local canrespawn = false
local deadCheck = false
local PedCoords = nil
local unarmed = GetHashKey("weapon_unarmed")
currentAOP = "Sandy Shores"

function OpenDeathScreen(time, type)
    isDead = true
    SetCurrentPedWeapon(cache.ped, unarmed, true)
    SendNUIMessage({action = "DSMenu", open = true, time = time, deadtype = type})
    if Config.Blur then
        TriggerScreenblurFadeIn()
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(true)
    while isDead do
        Citizen.Wait(0)
    end
end

AddEventHandler('onClientMapStart', function()
	Citizen.Trace("RPRevive: Disabling le autospawn.")
	exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("RPRevive: Autospawn is disabled.")
end)

CreateThread(function()
    Citizen.Wait(500)
    local accent_colour = exports['sasrp-ui']:GetAccentColour()
    SendNUIMessage({action = "updatecolor", color = accent_colour})
end)

Citizen.CreateThread(function()

    -- exports.ox_target:addGlobalPlayer({
    --     name = "help_up_knockedoutplayer",
    --     icon = "fa-solid fa-handshake-angle",
    --     label = "Help Up",
    --     canInteract = function(entity, distance, coords)
    --         local DeathSource = GetPedCauseOfDeath(entity)
    --         if distance > 2.0 then
    --             return false
    --         end
    --         if not IsMelee(DeathSource)  then
    --             return false
    --         end
    --         if not IsEntityDead(ped) then
    --             return false
    --         end
    
    --         return true
    --     end,
    --     onSelect = function(data)
    --         local targetPed = data.entity
    --         local targetNetworkId = NetworkGetPlayerIndexFromPed(targetPed)
    --         local targetServerId = GetPlayerServerId(targetNetworkId)

    --             TaskTurnPedToFaceEntity(ped, cache.ped, 500)
    --             ExecuteCommand("e medic")
    
    --             if lib.progressBar({
    --                 duration = 5000,
    --                 label = "Helping Up...",
    --                 useWhileDead = false,
    --                 allowRagdoll = false,
    --                 allowCuffed = false,
    --                 allowFalling = false,
    --                 canCancel = true,
    --                 disable = {
    --                     car = true
    --                 }
    --             }) then
    --                 ExecuteCommand("me helps up")
    --                 TriggerServerEvent("NahRyan:RevivePed", targetServerId)
    --                 Wait(1000)
    --                 ExecuteCommand("e c")
    --             else
    --                 ExecuteCommand("e c")
    --             end
    --     end
    -- })



    while true do
        Citizen.Wait(100)
        local ped = GetPlayerPed(-1)
        PedCoords = GetEntityCoords(cache.ped, true)
        if IsEntityDead(ped) then
            if not deadCheck then
                deadCheck = true
                local DeathSource = GetPedCauseOfDeath(ped)
                if IsMelee(DeathSource) then
                    OpenDeathScreen(5, "knockout")
                else
                    OpenDeathScreen(5, "none")
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = GetPlayerPed(-1)
        if not IsEntityDead(ped) then
            if deadCheck then
                deadCheck = false
                isDead = false
                SendNUIMessage({action = "DSMenu", open = false})
                if Config.Blur then
                    TriggerScreenblurFadeOut()
                end
            end

        end
    end

end)

RegisterNetEvent('NahRyan:RevivePlayer')
	AddEventHandler('NahRyan:RevivePlayer', function()
	local ped = GetPlayerPed(-1);
    local playerPos = GetEntityCoords(ped, true)
	if IsEntityDead(ped) then 
        SetCurrentPedWeapon(cache.ped, unarmed, true)
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
		SetPlayerInvincible(ped, false)
		ClearPedBloodDamage(ped)
        TriggerEvent("s4-cuff:client:removeall")
	end
end)

RegisterNetEvent('NahRyan:RespawnPlayer')
	AddEventHandler('NahRyan:RespawnPlayer', function()
	local ped = GetPlayerPed(-1);
    local playerPos = GetEntityCoords(ped, true)
	if IsEntityDead(ped) then 
        SetCurrentPedWeapon(cache.ped, unarmed, true)
        RespawnPed(GetPlayerPed(-1))
        TriggerEvent("s4-cuff:client:removeall")
	end
end)

RegisterNetEvent("fivem-purge:clientRevive")
AddEventHandler("fivem-purge:clientRevive", function()
    RevivePed(GetPlayerPed(-1))
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local DeathSource = GetPedCauseOfDeath(GetPlayerPed(-1))
        if IsMelee(DeathSource) and IsEntityDead(GetPlayerPed(-1)) then
            if canrespawn and IsControlJustPressed(1, 85) and IsEntityDead(GetPlayerPed(-1)) then
                RevivePed(GetPlayerPed(-1))
                canrespawn = false
            end
        else
            if canrespawn and IsControlJustPressed(1, 38) and IsEntityDead(GetPlayerPed(-1)) then
                RespawnPed(GetPlayerPed(-1))
                canrespawn = false
            end
        end
    end
end)

RegisterNetEvent(
	"NahRyan:HelpUpPlayer",
	function(src)
		RevivePed()
	end
)

local UNARMED_HASH = GetHashKey("weapon_unarmed")
function IsMelee(hash)
	if hash == UNARMED_HASH then
		return true
	end
	local WeaponGroup = GetWeapontypeGroup(hash)
	if (WeaponGroup == -728555052 or WeaponGroup == 1548507267) and not Config.DeadlyMelee[hash] then
		return true
	end
	return false
end

function RevivePed()
    SetCurrentPedWeapon(cache.ped, unarmed, true)
    isDead = false
    SendNUIMessage({action = "DSMenu", open = false})
    if Config.Blur then
        TriggerScreenblurFadeOut()
    end
    local playerPed = cache.ped
    local playerPos = GetEntityCoords(playerPed)
    local playerHead = GetEntityHeading(playerPed)
    local player = cache.ped

    FreezeEntityPosition(playerPed, true)

    local x, y, z = table.unpack(GetEntityCoords(playerPed, true)) -- Get player position
    local foundGround, groundZ = GetGroundZFor_3dCoord(x, y, z, false) -- Attempt to find the ground Z

    if foundGround then
    

    NetworkResurrectLocalPlayer(vector3(playerPos.x, playerPos.y, groundZ), true, true, false)
    SetEntityMaxHealth(player, 200)
    SetEntityHealth(player, 200)
    ClearPedBloodDamage(player)
    ResetPedMovementClipset(player, 0.0)

    local dict = "anim@scripted@heist@ig25_beach@male@"
    RequestAnimDict(dict)
    repeat Wait(0) until HasAnimDictLoaded(dict)

    NetworkSetLocalPlayerInvincibleTime(16000)
    

    local scene = NetworkCreateSynchronisedScene(playerPos.x, playerPos.y, groundZ, 0.0, 0.0, playerHead, 2, false, false, 8.0, 1000.0, 1.0)
    NetworkAddPedToSynchronisedScene(playerPed, scene, dict, "action", 1000.0, 8.0, 0, 0, 1000.0, 8192)
    NetworkAddSynchronisedSceneCamera(scene, dict, "action_camera")
    
    NetworkStartSynchronisedScene(scene)
    FreezeEntityPosition(playerPed, false)
    end
end

function RespawnPed()
    SetCurrentPedWeapon(cache.ped, unarmed, true)
    TriggerEvent("s4-cuff:client:removeall")
    isDead = false
            SendNUIMessage({action = "DSMenu", open = false})
            if Config.Blur then
                TriggerScreenblurFadeOut()
            end
            Wait(500)
            local player = cache.ped
            
            SetEntityMaxHealth(player, 200)
            SetEntityHealth(player, 200)
            ClearPedBloodDamage(player)
            SetPlayerSprint(PlayerId(), true)
            ResetPedMovementClipset(player, 0.0)
            SetPlayerInvincible(player, false)
                local closestLocation = getClosestRespawnLocation(PedCoords.x, PedCoords.y, PedCoords.z)
                if closestLocation then
                    InitialSetup()

                    DoScreenFadeOut(200)
                    while IsScreenFadingOut() do
                        Citizen.Wait(0)
                    end

                    SwitchOutPlayer(cache.ped, 0, 1)

                    SetEntityCoords(player, closestLocation.x, closestLocation.y, closestLocation.z, false, false, false, false)
                    Wait(200)

                    DoScreenFadeIn(200)
                    while IsScreenFadingIn() do
                        Citizen.Wait(0)
                    end

                    Wait(1000)
                    SwitchInPlayer(cache.ped)

                    while GetPlayerSwitchState() ~= 12 do
                        Citizen.Wait(0)
                    end

                    NetworkResurrectLocalPlayer(PedCoords, true, true, false)
                end
            
            canrespawn = false
end

function getClosestRespawnLocation(deathX, deathY, deathZ)
    local closestLocation = nil
    local closestDistance = math.huge -- Start with the largest possible number

    for name, location in pairs(Config.RespawnLocations) do
        -- Calculate the distance using the Pythagorean theorem
        local distance = math.sqrt(
            (location.x - deathX)^2 +
            (location.y - deathY)^2 +
            (location.z - deathZ)^2
        )
        
        if distance < closestDistance then
            closestDistance = distance
            closestLocation = location
        end
    end

    return closestLocation
end


RegisterNUICallback('response', function(data, cb)
    canrespawn = true
end)

RegisterNetEvent('sasrp-ui:accentChanged')
AddEventHandler('sasrp-ui:accentChanged', function(data)
    accent_colour = data
    SendNUIMessage({action = "updatecolor", color = accent_colour})
    print(data)
end)