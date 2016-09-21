#!/bin/sh

cp res/* /koolshare/res/
cp webs/* /koolshare/webs/
cp scripts/* /koolshare/scripts/

chmod a+x /koolshare/scripts/aliddns_*

# add icon into softerware center
dbus set softcenter_module_aliddns_install=1
dbus set softcenter_module_aliddns_version=0.1