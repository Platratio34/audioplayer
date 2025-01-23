local function playAudioFrom(audio, volume, sourcePos)
    TriggerClientEvent('audioPlayer:playAudioFrom', -1, audio, volume, sourcePos)
end
RegisterNetEvent('audioPlayer:playAudioFrom', playAudioFrom)
exports('playAudioFrom', playAudioFrom)

local function playAudioFromPlayer(audio, volume, sourcePlayer)
    local sourcePos = GetEntityCoords(GetPlayerPed(sourcePlayer))
    TriggerClientEvent('audioPlayer:playAudioFrom', -1, audio, volume, sourcePos)
end
RegisterNetEvent('audioPlayer:playAudioFromPlayer', playAudioFromPlayer)
RegisterNetEvent('audioPlayer:playAudioFromSource', function(audio, volume)
    playAudioFromPlayer(audio, volume, source)
end)
exports('playAudioFromPlayer', playAudioFromPlayer)

local function playAudioAll(audio, volume)
    print(audio, volume)
    TriggerClientEvent('audioPlayer:playAudio', -1, audio, volume)
end
RegisterNetEvent('audioPlayer:playAudioAll', playAudioAll)
exports('playAudioForAll', playAudioAll)

local function playAudioOther(audio, volume, other)
    print(audio, volume, tostring(other))
    if not other then
        error('Must provide destination for audio')
        return false
    end
    if type(other) == 'table' then
        for _,o in pairs(other) do
            TriggerClientEvent('audioPlayer:playAudio', o, audio, volume)
        end
    else
        TriggerClientEvent('audioPlayer:playAudio', other, audio, volume)
    end
end
RegisterNetEvent('audioPlayer:playAudioOther', playAudioOther)
exports('playAudioFor', playAudioOther)

--- Sound class stuff

local nextServerId = 1

local function getServerSoundId()
    id = nextServerId
    nextServerId = nextServerId + 1
    return 'sv:' .. id
end
exports('getServerSoundId', getServerSoundId)

local sounds = {} ---@type { string: Sound }
exports('createSound', function(audio, volume, sourcePos, keep)
    sound = Sound(audio, volume, sourcePos, keep)
    sounds[sound:getId()] = sound
    return sound:getId()
end)
exports('soundSetVolume', function(soundId, volume)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:setVolume(volume)
end)
exports('soundSetSourcePos', function(soundId, sourcePos)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:setSource(sourcePos)
end)
exports('soundSetKeep', function(soundId, keep)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:setKeep(keep)
end)

exports('soundStart', function(soundId, override)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:start(override)
end)
exports('soundPause', function(soundId)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:pause()
end)
exports('soundStop', function(soundId)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:stop()
end)

exports('soundAddClient', function(soundId, client)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:addClient(client)
end)
exports('soundAddClients', function(soundId, clients)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:addClients(clients)
end)
exports('soundAddAllClients', function(soundId)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:addAllClients()
end)

exports('soundRemoveClient', function(soundId, client)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:removeClient(client)
end)
exports('soundRemoveClients', function(soundId, clients)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:removeClients(clients)
end)
exports('soundRemoveAllClients', function(soundId)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:removeAllClients()
end)

exports('soundCleanup', function(soundId)
    if not sounds[soundId] then
        print('Tried to perform action on unknown sound id "'..soundId..'"')
        return
    end
    sounds[soundId]:cleanup()
end)
-- Testing thing
-- Citizen.CreateThread(function()
--     -- while true do
--         -- playAudioFrom('demo.ogg', 1.0, vector3(-109.3, 6464.04, 31.62))
--         -- Citizen.Wait(2000)
--     -- end
--     Citizen.Wait(500)
--     playAudioFrom('KevinMacLeodDistrictFour.mp3', 1.0, vector3(-109.3, 6464.04, 31.62))
-- end)