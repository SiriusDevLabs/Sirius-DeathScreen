fx_version 'cerulean'
game 'gta5'
shared_script {
	'config.lua',
	--'@qb-ambulancejob/config.lua'
	'@ox_lib/init.lua',
	
}

lua54 'yes'

escrow_ignore 'config.lua'
client_script 'c.lua'
server_script 's.lua'
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