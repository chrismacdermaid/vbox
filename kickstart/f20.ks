## Unattended install of minimal fedora 20

install

# Disable anything graphical
skipx
text

url --url=http://mirrors.mit.edu/fedora/linux/releases/20/Everything/x86_64/os/

### Main install repo
#repo --name=released --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-20&arch=x86_64
#
## To include updates, use the following "repo" (enabled by default)
#repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f20&arch=x86_64
#
## To compose against rawhide, use the following "repo" (disabled by default)
##repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch


# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang C

## Network information
# for STATIC IP: uncomment and configure
# network --onboot=yes --device=eth0 --bootproto=static --ip=192.168.###.### --netmask=255.255.255.0 --gateway=192.168.###.### --nameserver=###.###.###.### --noipv6 --hostname=$$$

# for DHCP
network --bootproto=dhcp --device=eth0 --noipv6 --activate --device=eth0 -onboot=on
network --hostname=localhost.localdomain

# Firewall/Security
selinux --disabled
firewall --enabled --service=ssh

# Services
services --enabled=network,sshd

# Root password
rootpw --iscrypted $1$lqtO5Lt6$FY9GNGIWtIio48P2IIiE50

# System authorization information
auth --enableshadow --passalgo=sha512

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

%post

cat <<EOL > /etc/sysconfig/network-scripts/ifcfg-eth0
ONBOOT=yes
DEVICE=eth0
BOOTPROTO=dhcp
EOL

cat <<EOL >> /etc/rc.local
if [ ! -d /root/.ssh ] ; then
    mkdir -p /root/.ssh
    chmod 0700 /root/.ssh
fi

cat <<EOL >> /etc/ssh/sshd_config
UseDNS  no
PermitRootLogin without-password
EOL

%end
