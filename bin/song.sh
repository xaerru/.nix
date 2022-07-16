#!/bin/sh
song=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>&1)
if [[ $? = 0 ]]; then
    echo ${song}
else
    true
fi
