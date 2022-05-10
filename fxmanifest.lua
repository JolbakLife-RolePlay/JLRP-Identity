fx_version 'cerulean'

game 'gta5'

name 'JLRP-Identity'
author 'Mahan Moulaei'
discord 'Mahan#8183'
description 'JolbakLifeRP Identity'

version '0.0'


shared_script {
	'@JLRP-Framework/imports.lua',
	'@JLRP-Framework/shared/locale.lua',
	'locales/en.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	'config.lua',
	'server/main.lua'
}

client_scripts {
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

files {
	'html/**'
}

dependencies {
	'oxmysql',
	'JLRP-Framework'
}
