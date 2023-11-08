#!/bin/bash
termux_cmd=(bash chroot)
arg=--version

for cmd in ${termux_cmd[@]} ;do
    /system/bin/$cmd $arg | diff - <($PREFIX/bin/$cmd $arg) ||
    echo "$cmd $arg diff, you may want upgrade system $cmd!"
done
