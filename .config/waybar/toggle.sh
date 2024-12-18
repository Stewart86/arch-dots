#!/bin/bash

if [ "$(systemctl --user is-active waybar.service)" = "active" ]; then
    systemctl --user stop waybar.service
else
    systemctl --user start waybar.service
fi
