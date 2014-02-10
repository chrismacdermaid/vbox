#!/bin/bash
MERROR="" 
RELEASE="20"
mkdir -p images/Fedora/x86_64/${RELEASE}
for i in initrd.img vmlinuz; do \
  wget http://mirror.cc.vt.edu/pub/fedora/linux/releases/${RELEASE}\/Fedora/x86_64/os/images/pxeboot/$i && mv $i images/Fedora/x86_64/${RELEASE}\/.; done
