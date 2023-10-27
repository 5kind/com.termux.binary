#!/bin/bash
APKNAME=com.termux
MODNAME=${APKNAME}.binary
PREFIX=/data/data/com.termux/files/usr
MODDIR=${0%/*}

[[ -z "$TERMUX_VERSION" ]] && TERMUX_VERSION=0.118.0

# print binary - environment: PREFIX
binfind(){
    [[ -e $1 ]] && printf $(realpath $1) && return 0
    local needbin=$(basename $1)
    for binpath in ${PREFIX}/{bin,lib} ;do
        ls "${binpath}/${needbin}" 2>/dev/null &&
        return 0
    done
    return 1
}

# print deb file according to absolute path
debfind(){
    local needfile=$(binfind $1)
    debcache=/data/data/com.termux/cache/apt/archives
    debname=$(apt-file search ${needfile}| head -n 1 | sed 's/:.*//')
    ( ls -t ${debcache}/${debname}_*.deb | head -n 1 ) &&
    return 0 || return 1
}

# install module /system -> MODDIR
# environment: tempinstall
module_install(){
    local binfile=$1
    local debfile=$(debfind $1)
    local tempinstall=$(mktemp -d)
    dpkg-deb --extract ${debfile} ${tempinstall}
    case $(basename $(dirname ${binfile})) in
        bin)
            cp -rfL ${binfile} ${MODDIR}/system/bin
            ;;
        lib)
            cp -rfL ${binfile} ${MODDIR}/system/lib64
            ;;
    esac
    rm -rf ${tempinstall}
}

install_binary=$1
[[ -z $install_binary ]] && printf "Require binary file!\n" && exit 1
mkdir -p ${MODDIR}/system/{bin,lib64}
module_install $(command -v $install_binary)
# module_install_lib
for pkglib in $(ldd $(binfind $install_binary) | grep ${APKNAME} | awk '{print $NF}') ;do
    module_install $pkglib
done
# module.prop
cat <<EOF > ${MODDIR}/module.prop
id=${MODNAME}
name=${APKNAME} Binary Files
version=${TERMUX_VERSION}
versionCode=1
author=5kind
description=Provide termux binary in android shell.
EOF
