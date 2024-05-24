fx_version 'adamant'
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
    "public/index.html",
    "public/**.css",
    "public/**.js",
    "public/fonts/**.ttf",
    "public/img/**.png",
    "public/img/**.jpg",
    "public/img/**.jpeg",
    "public/img/**.gif",
    "public/img/**.svg",
    "public/img/**.webp",
}
