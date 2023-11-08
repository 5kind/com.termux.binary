##########################################################################################
# Busybox function install Script - Install Magisk/KernelSU magisk function to /system/bin
##########################################################################################
MODDIR=${0%/*}
# Use magisk busybox first, and ksu busybox when failback
BUSYBOX=/data/adb/magisk/busybox
[ ! -x "$BUSYBOX" ] && BUSYBOX=/data/adb/ksu/bin/busybox
MODBIN=${MODDIR}/system/bin
MODBOX=${MODBIN}/busybox
# Replace toybox with busybox, fuck the disgusting toybox.
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
# Remove next function
REMOVE_LIST="busybox
"   # hide busybox since some annoying apps will try to look for it.
##########################################################################################
# End of config - Start of install - post-fs-data - install *box - remove files
##########################################################################################
install -Dm755 $BUSYBOX ${MODBOX}
cd ${MODBIN}
# install *box link
for cmd in $(toybox) ;do
    [ ! -x "/system/bin/$cmd" ] &&
    ln -s toybox $cmd 2>&1 >/dev/null
done    # install toybox
for cmd in $($BUSYBOX --list) ;do
    [ ! -x "/system/bin/$cmd" ] &&
    ln -n busybox $cmd 2>&1 >/dev/null
done    # install busybox
for cmd in $REPLACE_LIST ;do
    ln -f busybox $cmd 2>&1 >/dev/null
done    # use busybox replace toybox
for cmd in $REMOVE_LIST ;do
    rm -f $cmd 2>&1 >/dev/null
done    # remove useless command
##########################################################################################
# End of install - you can keep post-fs-data.sh in case update busybox, see you. :)
##########################################################################################
cd $MODDIR && rm -f check-binary.sh make-module.sh post-fs-data.sh update-binary.sh
