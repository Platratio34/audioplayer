local function playAudio(audio, volume, srcPos, pos)
    print('Playing audio "'..audio..'" at volume '..volume)
    SendNUIMessage({
        type = 'playSound',
        file = audio,
        volume = volume,
        srcPos = srcPos,
        pos = pos
    })
end
exports('playAudio', playAudio)

RegisterNetEvent('audioPlayer:playAudio', playAudio)

local distToHalf = 20
local function soundDisp(volume, dist)
    if dist < 1 then return volume end
    di = 20 * math.log(dist, 10)
    return math.min(volume / ( di / 5 ), volume)
    -- return volume / ( (distToHalf / dist) + 1)
end
local function playAudioFrom(audio, volume, sourcePos)
    playAudio(audio, volume, sourcePos, GetEntityCoords(GetPlayerPed(-1)))
    -- sourcePos = vector3(sourcePos.x, sourcePos.y, sourcePos.z)
    -- print(sourcePos)
    -- local myPos = GetEntityCoords(GetPlayerPed(-1))
    -- local dist = #(myPos - sourcePos)
    -- volume = soundDisp(volume, dist)
    -- if volume > 0 then
    --     playAudio(audio, volume, sourcePos)
    -- end
end
RegisterNetEvent('audioPlayer:playAudioFrom', playAudioFrom)

exports('playAudioFrom',function(audio, volume, sourcePos)
    TriggerServerEvent('audioPlayer:playAudioFrom', audio, volume, sourcePos)
end)
exports('playAudioFromPlayer',function(audio, volume, sourcePlayer)
    TriggerServerEvent('audioPlayer:playAudioFromPlayer', audio, volume, sourcePlayer)
end)
exports('playAudioFromSelf', function(audio, volume)
    TriggerServerEvent('audioPlayer:playAudioFromSource', audio, volume)
end)

exports('playAudioAll', function(audio, volume)
    TriggerServerEvent('audioPlayer:playAudioAll', audio, volume)
end)
exports('playAudioOther', function(audio, volume, other)
    TriggerServerEvent('audioPlayer:playAudioOther', audio, volume, other)
end)

local trackedEntities = {}

Citizen.CreateThread(function()
    while true do
        ePos = {}
        for id,ent in pairs(trackedEntities) do
            if NetworkDoesEntityExistWithNetworkId(ent) then
                lid = NetworkGetEntityFromNetworkId(ent)
                ePos[id] = GetEntityCoords(lid)
            end
        end
        SendNUIMessage({
            type = 'updatePos',
            pos = GetEntityCoords(GetPlayerPed(-1)),
            ePos = ePos
        })
        Citizen.Wait(100)
    end
end)


local nextClientId = 1

local function getClientSoundId()
    id = nextClientId
    nextClientId = nextClientId + 1
    return 'cl:' .. id
end
exports('getClientSoundId', getClientSoundId)

RegisterNetEvent('audioPlayer:sound:start', function(id, sound, override)
    srcPos = nil
    if sound._sourceEntity > 0 then
        trackedEntities[id] = sound._sourceEntity
        if NetworkDoesEntityExistWithNetworkId(sound._sourceEntity) then
            lid = NetworkGetEntityFromNetworkId(sound._sourceEntity)
            srcPos = GetEntityCoords(lid)
        end
    else
        trackedEntities[id] = nil
    end
    SendNUIMessage({
        type = 'sound',
        action = 'start',
        id = id,
        sound = sound,
        override = override,
        srcPos = srcPos,
    })
end)
RegisterNetEvent('audioPlayer:sound:pause', function(id)
    SendNUIMessage({
        type = 'sound',
        action = 'pause',
        id = id,
    })
end)
RegisterNetEvent('audioPlayer:sound:stop', function(id)
    SendNUIMessage({
        type = 'sound',
        action = 'stop',
        id = id,
    })
end)
RegisterNetEvent('audioPlayer:sound:update', function(id, sound)
    srcPos = nil
    if sound._sourceEntity > 0 then
        trackedEntities[id] = sound._sourceEntity
        if NetworkDoesEntityExistWithNetworkId(sound._sourceEntity) then
            lid = NetworkGetEntityFromNetworkId(sound._sourceEntity)
            srcPos = GetEntityCoords(lid)
        end
    else
        trackedEntities[id] = nil
    end
    SendNUIMessage({
        type = 'sound',
        action = 'update',
        id = id,
        sound = sound,
        srcPos = srcPos,
    })
end)
RegisterNetEvent('audioPlayer:sound:cleanup', function(id)
    SendNUIMessage({
        type = 'sound',
        action = 'cleanup',
        id = id,
    })
end)

exports('clientSoundEvent', function(data)
    data.type = 'sound'
    SendNUIMessage(data)
end)
-- RegisterNetEvent('audioPlayer:sound:setVolume', function(id, volume)
--     SendNUIMessage({
--         type = 'sound:setVolume',
--         id = id,
--         volume = volume,
--     })
-- end)
-- RegisterNetEvent('audioPlayer:sound:setSourcePos', function(id, sourcePos)
--     SendNUIMessage({
--         type = 'sound:setSourcePos',
--         id = id,
--         sourcePos = sourcePos,
--     })
-- end)