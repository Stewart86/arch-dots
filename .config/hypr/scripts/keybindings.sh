#!/bin/bash

config_file=~/.config/hypr/conf/keybinding.conf
echo "Reading from: $config_file"

mod_key=$(rg "^*mainMod =" <"$config_file" | awk '{print $3}')
binds=$(rg "^bind* =" <"$config_file" |
    awk -F, '{print $1,"+", toupper($2), "\r#",$3,$4}' |
    sed 's/bind* = //g' |
    sed "s/\$mainMod/$mod_key/g" |
    sed 's/#.*#//g')

rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" -config ~/.config/rofi/config-compact.rasi <<<"$binds"
