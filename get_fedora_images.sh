#!/bin/bash
MIRROR="http://mirror.cc.vt.edu/pub/fedora/linux/releases/${RELEASE}\/Fedora/x86_64/os" 
RELEASE="20"
mkdir -p images/Fedora/x86_64/${RELEASE}
for i in initrd.img vmlinuz; do \
  wget ${MIRROR}\/images/pxeboot/$i && mv $i images/Fedora/x86_64/${RELEASE}\/.; done
