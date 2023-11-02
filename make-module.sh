#!/bin/bash
MODDIR=${0%/*}
termux_cmd=(bash chroot)

cd $MODDIR
for cmd in ${termux_cmd[@]} ;do
    ./update-binary.sh $cmd
done
zip -r install.zip *
