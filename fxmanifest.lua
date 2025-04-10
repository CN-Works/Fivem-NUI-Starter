fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script {
    'client/**.lua',
}

server_script {
    'server/**.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_script {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua',
}

ui_page "public/index.html"

files {
    "public/**",
    "public/**/**",
}
