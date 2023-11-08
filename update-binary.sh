#!/bin/bash
MODDIR=${0%/*}
APKID=com.termux
MODID=${APKID}.binary
PREFIX=/data/data/com.termux/files/usr

if [[ -z "$TERMUX_VERSION" ]] ;then
    echo "Warning: Not termux environment, unexpected result may happen!"
    TERMUX_VERSION=0.118.0
    sleep 1
    echo "Continueing anyway..."
fi

# find bin/lib file under $PREFIX to $MODDIR
find_binary(){
    [[ -e $1 ]] && printf $(realpath $1) && return 0
    local needbin=$(basename $1)
    for binpath in ${PREFIX}/{bin,lib} ;do
        ls "${binpath}/${needbin}" 2>/dev/null &&
        return 0
    done
    return 1
}

# install $1 to bin/lib64 under $MODDIR/system
install_binary(){
    local binfile=$1
    case $(basename $(dirname ${binfile})) in
        bin)
            cp -rvfL ${binfile} ${MODDIR}/system/bin
            ;;
        lib)
            cp -rvfL ${binfile} ${MODDIR}/system/lib64
            ;;
    esac
}

# install libraries in $(ldd $1) to $MODDIR/system/lib64
install_library(){
    for library in $(ldd $(binfind $install_binary) | grep ${APKID} | awk '{print $NF}') ;do
        install_binary $library
    done
}

# find, install ${@} file in $PREFIX to $MODDIR/system
[ -z "${@}" ] && echo "ERROR: Required at least one file to install!" && exit 1
for install_module in ${@} ;do
    install_binary $install_module
    install_library $install_module
done

# module.prop
cat <<EOF > ${MODDIR}/module.prop
id=${MODID}
name=Termux Binary Files
version=${TERMUX_VERSION}
versionCode=1
author=${APKID}
description=Provide termux binary in android shell.
EOF