#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use network installation
url --url="http://http://mirror.cc.vt.edu/pub/fedora/linux/releases/20/Fedora/x86_64/os"
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
# old format: keyboard us
# new format:
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_GB.UTF-8
# Network information
network --bootproto=dhcp --device=eth0 --noipv6 --activate
network --hostname=localhost.localdomain
# Root password
rootpw --iscrypted XXX
# System timezone
timezone Europe/London
user --groups=wheel --homedir=/home/user --name=user --password=XXX "User"
# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
# Partition clearing information
clearpart --none --initlabel
# Disk partitioning information
#part /boot --fstype="ext4" --onpart=sda6 --label=fedora19-boot
#part / --fstype="ext4" --onpart=sda7 --label=fedora19-root
#part swap --fstype="swap" --noformat --onpart=sda8
#part /boot/efi --fstype="efi" --noformat --onpart=sda2 --fsoptions="umask=0077,shortname=winnt"
%packages
@core
%end
