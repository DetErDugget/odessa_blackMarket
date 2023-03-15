fx_version 'cerulean'
game  'gta5' 

shared_scripts{
    '@ox_lib/init.lua'
}
client_scripts {
	'config.lua',	
	'client/*'	
}

server_scripts {
	'config.lua',
	"server/*"
}

lua54 'yes'
