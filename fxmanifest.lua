fx_version "adamant"
game "gta5"

author "〃Sirius Studios / NahRyan"
description "Full vMenu Framework"
version "BETA"

lua54 "yes"

shared_script {
	'config.lua',
	'@ox_lib/init.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'


ui_page 'html/index.html'
files {
	'html/index.html',
	'html/style.css',
	'html/index.js',
    'html/files/*.png',
    'html/files/*.jpg',
	'html/fonts/*.otf',
	'html/fonts/*.ttf'
}