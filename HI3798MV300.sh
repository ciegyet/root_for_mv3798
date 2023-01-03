#!/system/bin/sh

#INIT
busybox --install /system/xbin
mount -o remount "${dev_mount}" /system
mkdir -p /system/bin/.ext && chmod 0755 /system/bin/.ext
mkdir -p /system/etc/init.d && chmod 0755 /system/etc/init.d
echo 1 >/system/etc/.installed_su_daemon && chmod 0644 /system/etc/.installed_su_daemon

#SET EXPORT
export dev_mount="/dev/block/platform/soc/by-name/system" #MOUNT_DEV_DIR
export install_dir="/system/app/"
root_dir="$(
    cd "$(dirname "$0")" || exit
    pwd
)"
export root_dir

#INSTALL SU
for su_list in "${root_dir}"/bin/*; do
    # shellcheck disable=SC2039
    echo -n "[INFO] COPY" "${su_list}"
    cp "${root_dir}"/bin/"${su_list}" /system/xbin/"${su_list}"
    echo "[ OK! ]"
    
done

cp "${root_dir}"/bin/su /system/bin/.ext/.su && chmod 0755 /system/bin/.ext/.su
cp "${root_dir}"/lib/libsupol.so /system/lib/libsupol.so && chmod 0644 /system/lib/libsupol.so
cp "${root_dir}"/etc/99adbd /system/etc/init.d/99adbd && chmod 0755 /system/etc/init.d/99adbd
cp "${root_dir}"/etc/install-recovery.sh /system/etc/install-recovery.sh && chmod 0755 /system/etc/install-recovery.sh
cp "${root_dir}"/etc/install-recovery-2.sh /system/etc/install-recovery-2.sh && chmod 0755 /system/etc/install-recovery-2.sh

#SET UMASK
chmod 0755 /system/xbin/daemonsu
chmod 0755 /system/xbin/supolicy
chmod 06755 /system/xbin/su
chmod 06755 /system/xbin/sugote-mksh

#INSTALL APK
for apk_list in "${root_dir}"/apk/*; do
    if [ -e "$apk_list" ];then
        printf "[INFO] INSTALL %s\n""${apk_list}"
        cp "${root_dir}"/apk/"${apk_list}" ${install_dir}
        chmod 0644 ${install_dir}/"${apk_list}"
        printf "\n [ OK! ]"
    else
        printf "apk file not found"
        break
    fi
done

echo "[INFO] ROOT SUCCESS!"
echo "[INFO] SYSTEM 5S REBOOT"


sleep 5
busybox reboot -f
