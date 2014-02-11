#!/bin/bash
# Create a fedora VM. Intended to be run in TFTP directory in ~/.VirtualBox VMs

VBOX=`which VirtualBox`
VBOXMANAGE=`which VBoxManage`
VBOXBASE='/data/VirtualBox VMs'
VBOXTFTP="${VBOXBASE}/TFTP"

RELEASE="20"
RANDSTR=`cat /dev/urandom|tr -cd "[:alnum:]" |head -c 5`
PXELINUX="./pxelinux.0"

## Make a random VM name if none is specified
[ "$1" == "" ] && VM="f${RELEASE}${RANDSTR}" || VM=${1}

## Did the user specify a different kickstart file to use?
[ "$2" == "" ] && KS="f20.ks" || KS=${2}

echo "Creating ${VM}"
VBOXINFO="${VBOXMANAGE} showvminfo ${VM}"

## Create necessary symbolic link required by vbox for pxeboot
ln -rs ${PXELINUX} ./${VM}.pxe

## VB
${VBOXMANAGE} createvm --name "${VM}" --ostype "Fedora_64" --register && \
${VBOXMANAGE} createhd --filename "${VBOXBASE}/${VM}/${VM}.vdi" --size 4096 && \
${VBOXMANAGE} storagectl "${VM}" --name "SATA Controller" --add sata \
    --controller IntelAHCI && \
${VBOXMANAGE} storageattach "${VM}" --storagectl "SATA Controller" --port 0 \
   --device 0 --type hdd --medium "${VBOXBASE}/${VM}/${VM}.vdi" && \
${VBOXMANAGE} modifyvm "${VM}" --memory 768 && \
${VBOXMANAGE} modifyvm "${VM}" --boot1 disk --boot2 net --boot3 none --boot4 none

## Create the boot configuration (need machine UUID)
UUID=`${VBOXINFO} |awk '/UUID/ {print $2}'|head -n 1`
ln -rs ./pxelinux.cfg/f20.cfg ./pxelinux.cfg/${UUID}

## Start it up
${VBOX} --startvm "${VM}"

## Cleanup
rm -f ./pxelinux.cfg/${UUID}
rm -f ${VM}.pxe


