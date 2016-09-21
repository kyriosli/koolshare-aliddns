#!/bin/sh

if [ "`dbus get aliddns_enable`" = "1" ]; then
    # 设置定时脚本
    dbus delay aliddns_timer 120 /koolshare/scripts/aliddns_update.sh
fi