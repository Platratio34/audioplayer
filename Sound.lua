---@class Sound
---@field private _audio string Audio file name
---@field private _volume number Base volume
---@field private _sourcePos vector3|nil Audio source position
---@field private _keep boolean If the audio should be keep after finished playing
---@field private _id string Server audio id
---@field private _clients {number: boolean} List of all clients that can here the sound
---@field private _sourceEntity number Source entity
local SoundIndex = {
    _keep = false,
    _clients = {},
    _sourceEntity = -1
}

local SoundMeta = {
    __index = SoundIndex
}

---Initilizes the sound
---@param audio string Sound file name and path
---@param volume number Sound base volume (0-1 for regular, 0-1+ for positional)
---@param source vector3|number|nil Optional. Source for positional audio can be position or entity netowork id
---@param keep boolean|nil Optional. Keep sound after finished playing
function SoundIndex:__init(audio, volume, source, keep)
    self._audio = audio
    self._volume = volume
    if type(source) == 'number' then
        self._sourceEntity = source
    else
        self._sourcePos = source
    end
    if keep ~= nil then self._keep = keep end
    self._id = exports.audioplayer:getServerSoundId()
    self:update()
end

---Add a client to the sound. Will not start on new clients
---@param client number Client id
function SoundIndex:addClient(client)
    self._clients[client] = true
    TriggerClientEvent('audioPlayer:sound:update', client, self._id, self)
end
---Add a list of clients to sound. Will not start on new clients
---@param clients number[] Client ids
function SoundIndex:addClients(clients)
    for _,cl in pairs(clients) do
        self:addClient(cl)
    end
end
---Add all clients to the sound
function SoundIndex:addAllClients()
    self._clients = { [-1] = true }
    TriggerClientEvent('audioPlayer:sound:update', -1, self._id, self)
end
---Remove a client from hearing the sound. THIS WILL STOP THE SOUND ON THE CLIENT
---@param client number Client id
function SoundIndex:removeClient(client)
    self._clients[client] = true
    TriggerClientEvent('audioPlayer:sound:cleanup', client, self._id)
end
---Remove a list of clients from hearing the sound. THIS WILL STOP THE SOUND ON THE CLIENTS
---@param clients number[] Client ids
function SoundIndex:removeClients(clients)
    for _, cl in pairs(clients) do
        self:removeClient(cl)
    end
end
---Remove all clients from hearing the sound. THIS WILL STOP THE SOUND ON ALL CLIENTS
function SoundIndex:removeAllClients()
    self._clients = {}
    TriggerClientEvent('audioPlayer:sound:cleanup', -1, self._id)
end

---Send a message to all clients of this sound
---@param action string Action (appendind to default event type)
---@param ... any Action parrameters
function SoundIndex:__sendToClients(action, ...)
    for cl,_ in pairs(self._clients) do
        TriggerClientEvent('audioPlayer:sound:'..action, cl, self._id, ...)
    end
end

---Start playing the sound
---@param override nil|boolean If it should force restart the sound
function SoundIndex:start(override)
    self:__sendToClients('start', self, override)
end
---Pause the sound and keep time
function SoundIndex:pause()
    self:__sendToClients('pause')
end
---Stop the sound and reset time
function SoundIndex:stop()
    self:__sendToClients('stop')
end

---Update the sound on all clients
function SoundIndex:update()
    self:__sendToClients('update', self)
end

---Set the volume of the sound
---@param volume number Base volume (0-1 for regular, 0-1+ for positional)
function SoundIndex:setVolume(volume)
    self._volume = volume
    self:update()
end
---Get the current base volume
---@return number volume
function SoundIndex:getVolume()
    return self._volume
end

---Set the source position for position audio
---@param source vector3|number|nil Source OR <code>nil</code> to disable position audio
function SoundIndex:setSource(source)
    if type(source) == 'number' then
        self._sourceEntity = source
    else
        self._sourcePos = source
    end
    -- self._sourcePos = sourcePos
    self:update()
end
---Get the current source position or <code>nil<\code> if location based positional audio is not enabled
---@return vector3|nil sourcePos
function SoundIndex:getSourcePos()
    return self._sourcePos
end
---Get the current source entity or <code>-1<\code> if entity based positional audio is not enabled
---@return number sourceEntity
function SoundIndex:getSourceEntity()
    return self._sourceEntity
end

---Set if the audio should be keep loaded client side after done playing
---@param keep boolean|nil If the sound should be keep. Defaults to true
function SoundIndex:setKeep(keep)
    if keep == nil then keep = true end
    self._keep = keep
    self:update()
end
---Get if the sound will be keept when done playing
---@return boolean keep
function SoundIndex:getKeep()
    return self._keep
end

---Get the server sound ID
---@return string id
function SoundIndex:getId()
    return self._id
end
---Get the filename and path of the audio file
---@return string filename
function SoundIndex:getAudio()
    return self._audio
end

---Cleanup the sound client side. THIS WILL STOP SOUND ON ALL CLIENTS
function SoundIndex:cleanup()
    self:__sendToClients('cleanup')
end

---Create a new server Sound
---@param audio string Sound file name and path
---@param volume number Base volume
---@param sourcePos nil|vector3 Source position for positional audio
---@param keep nil|boolean Keep sound after finished
---@return Sound sound
function Sound(audio, volume, sourcePos, keep)
    local o = {}
    setmetatable(o, SoundMeta)
    o:__init(audio, volume, sourcePos, keep)
    return o
end

-- exports('Sound', Sound)
-- exports('SoundMT', function()
--     return SoundMeta
-- end)

-- exports('Sound', Sound)