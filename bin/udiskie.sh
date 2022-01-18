#!/usr/bin/env bash
if [ $1 = "device_mounted" ]; then
  alacritty -t media -e tmux new -s media -c $2
  udiskie-umount --detach $2
fi
