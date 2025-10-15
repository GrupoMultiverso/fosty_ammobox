fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Fosty - Converted for QBox by GrupoMultiverso'
description 'AmmoBox script for QBox/QBCore and originally ESX now with ox_inventory support'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_inventory',
    'ox_lib' 
}