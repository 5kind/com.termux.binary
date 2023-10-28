#!/bin/bash
MODDIR=${0%/*}

cd $MODDIR
./update-binary.sh bash
./update-binary.sh chroot
zip -r install.zip *
