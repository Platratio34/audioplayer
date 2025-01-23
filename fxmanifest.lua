fx_version 'cerulean'
games {'gta5'}

title 'Audio Player'
description 'Simple exports for other scripts to play audio, including "positional" audio'
author 'Peter Crall'
version 'v1.0.0'

client_scripts {
    'client.lua',
    'ClientSound.lua',
}

server_scripts {
    'server.lua',
    'Sound.lua',
}

files {
    "nui/*",
    "nui/sounds/*"
}

ui_page "nui/index.html"