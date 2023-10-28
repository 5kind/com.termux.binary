#!/system/bin/sh
MODDIR=${0%/*}
INFO=/data/adb/modules/.busybox-files
MODID=busybox
LIBDIR=/system
MODPATH=$MODDIR
MODDIR=${0%/*}
BUSYBOX=/data/adb/magisk/busybox
[ ! -x "$BUSYBOX" ] && BUSYBOX=/data/adb/ksu/bin/busybox
MODBIN=${MODDIR}/system/bin
MODBOX=${MODBIN}/busybox
BUSY_LIST=$($BUSYBOX --list)
TOY_LIST=$(toybox)
REPLACE_LIST="cal
chcon
chgrp
chmod
chown
date
dd
env
expand
getopt
gunzip
gzip
head
microcom
mkfifo
mknod
mount
mountpoint
nsenter
od
rmmod
runcon
stat
swapoff
time
uname
unshare
vi
wc
whoami
xargs
"
REMOVE_LIST="acpid
chroot
"
install -Dm755 $BUSYBOX ${MODBOX}
cd ${MODBIN}
for cmd in $TOY_LIST ;do
    [ ! -x "/system/bin/$cmd" ] &&
    ln -sf toybox $cmd 2>&1 >/dev/null
done    # install toybox
for cmd in $BUSY_LIST ;do
    [ ! -x "/system/bin/$cmd" ] &&
    ln -n busybox $cmd 2>&1 >/dev/null
done    # install busybox
for cmd in $REPLACE_LIST ;do
    ln -f busybox $cmd 2>&1 >/dev/null
done    # use busybox instead toybox
for cmd in $REMOVE_LIST ;do
    rm -f $cmd 2>&1 >/dev/null
done    # remove useless command

