---@class ClientSound
---@field private _audio string Audio file name
---@field private _volume number Volume (0-1)
---@field private _keep boolean If the audio should be keep after finished playing
---@field private _id string Client audio id
local ClientSoundIndex = {
    _keep = false,
}

local ClientSoundMeta = {
    __index = ClientSoundIndex
}

---Initialize the Client Sound
---@param audio string Sound file name and path
---@param volume number Sound volume (0-1)
---@param keep boolean|nil Optional. Keep sound after finished playing
function ClientSoundIndex:__init(audio, volume, keep)
    self._audio = audio
    self._volume = volume
    if keep ~= nil then self._keep = keep end
    self._id = exports.audioplayer:getClientSoundId()
end

---Start playing the sound
---@param override nil|boolean If it should force restart the sound
function ClientSoundIndex:start(override)
    exports.audioplayer:clientSoundEvent({
        action = 'start',
        id = self._id,
        sound = self,
        override = override,
    })
end
---Pause the sound and keep time
function ClientSoundIndex:pause()
    exports.audioplayer:clientSoundEvent({
        action = 'pause',
        id = self._id,
    })
end
---Stop the sound and reset time
function ClientSoundIndex:stop()
    exports.audioplayer:clientSoundEvent({
        action = 'stop',
        id = self._id,
    })
end

---Update the sound in NUI
function ClientSoundIndex:update()
    exports.audioplayer:clientSoundEvent({
        action = 'update',
        id = self._id,
        sound = self,
    })
end 

---Set the volume of the sound
---@param volume number Volume (0-1)
function ClientSoundIndex:setVolume(volume)
    self._volume = volume
    self:update()
end
---Get the current volume (0-1)
---@return number volume
function ClientSoundIndex:getVolume()
    return self._volume
end

---Set if the audio should be keep loaded after done playing
---@param keep boolean|nil If the sound should be keep. Defaults to true
function ClientSoundIndex:setKeep(keep)
    if keep == nil then keep = true end
    self._keep = keep
    self:update()
end
---Get if the sound will be kept when done playing
---@return boolean keep
function ClientSoundIndex:getKeep()
    return self._keep
end

---Get the sound client ID
---@return string id
function ClientSoundIndex:getId()
    return self._id
end
---Get the filename and path of the audio file
---@return string filename
function ClientSoundIndex:getAudio()
    return self._audio
end

---Cleanup the sound side. THIS WILL STOP THE SOUND
function ClientSoundIndex:cleanup()
    exports.audioplayer:clientSoundEvent({
        action = 'cleanup',
        id = self._id,
    })
end

---Create a new client Sound
---@param audio string Sound file name and path
---@param volume number Volume (0-1)
---@param keep nil|boolean Keep sound after finished
---@return ClientSound sound
function ClientSound(audio, volume, keep)
    local o = {}
    setmetatable(o, ClientSoundMeta)
    o:__init(audio, volume, keep)
    return o
end

print('Loaded ClientSound in '..GetCurrentResourceName())