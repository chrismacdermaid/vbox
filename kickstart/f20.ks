#VERSION=core

install

# Install from a friendly mirror and add updates
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-20&arch=$basearch
repo --name=updates

# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_GB.UTF-8

## Network information
# for STATIC IP: uncomment and configure
# network --onboot=yes --device=eth0 --bootproto=static --ip=192.168.###.### --netmask=255.255.255.0 --gateway=192.168.###.### --nameserver=###.###.###.### --noipv6 --hostname=$$$

# for DHCP
network --bootproto=dhcp --device=eth0 --noipv6 --activate --device=eth0 -onboot=on
network --hostname=localhost.localdomain

# Firewall
firewall --disabled

# Root password
rootpw --iscrypted $1$lqtO5Lt6$FY9GNGIWtIio48P2IIiE50

# System authorization information
auth --enableshadow --passalgo=sha512

# Disable anything graphical
skipx
text

# System timezone (http://vpodzime.fedorapeople.org/timezones_list.txt)
timezone America/New_York

## User Management
user --groups=wheel --homedir=/home/macdercm --name=macdercm --password=$1$RNDbLvyG$bDyopBx/V23517Lzdar7G1 --shell=/bin/bash

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

# Partition clearing information
clearpart --none --initlabel

%packages
@core
%end
