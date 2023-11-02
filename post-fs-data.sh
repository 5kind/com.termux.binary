##########################################################################################
# post-fs-data - install busybox and then delete itself | toybox - busybox - replace
##########################################################################################
MODDIR=${0%/*}
BUSYBOX=/data/adb/magisk/busybox
[ ! -x "$BUSYBOX" ] && BUSYBOX=/data/adb/ksu/bin/busybox
MODBIN=${MODDIR}/system/bin
MODBOX=${MODBIN}/busybox
# replace toybox with busybox
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
# remove next function
REMOVE_LIST="acpid
"
# busybox
# add busybox to $REMOVE_LIST to hide busybox binary
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
done    # use busybox instead toybox
for cmd in $REMOVE_LIST ;do
    rm -f $cmd 2>&1 >/dev/null
done    # remove useless command
##########################################################################################
# End of install, we remove this script, you can delete this line or download it back
##########################################################################################
cd $MODDIR && rm check-system-binary.sh make-module.sh post-fs-data.sh update-binary.sh