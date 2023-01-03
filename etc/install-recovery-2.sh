#!/system/bin/sh

# adbd&telnet auto start
setprop persist.sys.usb.config mtp,adb
setprop persist.service.adb.enable 1
busybox telnetd -l /system/bin/sh&
mount -o remount rw /system
# install non market apps
echo "update global set value = 1 where name = 'install_non_market_apps';"| /system/xbin/sqlite3 /data/data/com.android.providers.settings/databases/settings.db

