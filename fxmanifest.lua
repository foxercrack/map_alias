fx_version 'adamant'
game 'gta5'

author 'MaP'
description 'Alias command' 
version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

client_scripts {
	'client/main.lua',
}

shared_script 'config.lua'