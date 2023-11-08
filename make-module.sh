#!/bin/bash
MODDIR=${0%/*}
termux_cmd=(bash chroot)

cd $MODDIR
./update-binary.sh ${termux_cmd[@]}
zip -r install.zip *
