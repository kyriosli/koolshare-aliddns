#!/bin/sh

if [ "`dbus get aliddns_enable`" = "1" ]; then
    dbus delay aliddns_timer `dbus get aliddns_interval` /koolshare/scripts/aliddns_update.sh
else
    dbus remove __delay__aliddns_timer
fi
