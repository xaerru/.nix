#!/usr/bin/env /run/current-system/sw/bin/bash
/etc/profiles/per-user/xaerru/bin/feh --bg-fill --no-fehbg $(/etc/profiles/per-user/xaerru/bin/fd --absolute-path -e png -e svg -e bmp -e jpg --full-path . '/home/xaerru/.wallpaper/' | /run/current-system/sw/bin/shuf | /run/current-system/sw/bin/head -n 1)
