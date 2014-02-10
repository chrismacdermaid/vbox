#!/bin/bash
mkdir -p images/Fedora/x86_64
for i in initrd.img vmlinuz; do \
  wget http://mirror.cc.vt.edu/pub/fedora/linux/releases/20/Fedora/x86_64/os/images/pxeboot/$i && mv $i images/Fedora/x86_64/.; done
