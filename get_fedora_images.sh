#!/bin/bash
RELEASE="21"
MIRROR="http://mirror.cs.pitt.edu/fedora/linux/releases/${RELEASE}/Server/x86_64/os" 
mkdir -p images/Fedora/x86_64/${RELEASE}
for i in initrd.img vmlinuz; do \
  wget ${MIRROR}/images/pxeboot/$i && mv $i images/Fedora/x86_64/${RELEASE}/.; done
