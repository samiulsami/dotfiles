#!/usr/bin/env sh

dunstctl is-paused | grep -q true &&
    printf '{"text":"󰂛","class":"paused"}\n' ||
    printf '{"text":"󰂚","class":"active"}\n'
