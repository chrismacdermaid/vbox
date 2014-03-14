## Unattended install of minimal fedora 20

## Do an install
install

# Disable anything graphical
skipx
text

## URL for installation
url --url=http://mirrors.mit.edu/fedora/linux/releases/20/Fedora/x86_64/os/

## Main repos
repo --name=released --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-20&arch=x86_64

# To include updates, use the following "repo" (enabled by default)
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f20&arch=x86_64

# To compose against rawhide, use the following "repo" (disabled by default)
#repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch

# Lammps Repo
repo --name=lammps --baseurl=http://git.icms.temple.edu/rpm/fedora/20/x86_64

# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang C

## Network information
# for STATIC IP: uncomment and configure
# network --onboot=yes --device=eth0 --bootproto=static --ip=10.42.0.20 --netmask=255.255.255.0 --gateway=10.42.0.1 --nameserver=155.247.225.230 --noipv6

# for DHCP
network --bootproto=dhcp --noipv6 --activate --onboot=on
network --hostname=localhost.localdomain

# Firewall/Security
selinux --disabled
firewall --enabled --service=ssh

# Services
services --enabled=network,sshd

# Root password (letmein)
rootpw --iscrypted $1$lqtO5Lt6$FY9GNGIWtIio48P2IIiE50

# System authorization information
auth --enableshadow --passalgo=sha512

# System timezone (http://vpodzime.fedorapeople.org/timezones_list.txt)
timezone America/New_York

# Partition clearing information
zerombr
clearpart --all
part / --fstype=ext4 --grow --size=4096 --asprimary
part swap --size=512

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda --timeout=5

%packages
@base-x
@core
@guest-desktop-agents
@standard
@lxde-desktop
@lxde-apps
@hardware-support
@input-methods
git
tcl
tcl-devel
screen
net-tools
openmpi
lammps
lammps-openmpi
lammps-python
lammps-common
lammps-doc
emacs
vim
nano

# save some space
-mpage
-sox
-hplip
-hpijs
-numactl
-isdn4k-utils
-autofs
# smartcards won't really work on the livecd.
-coolkey
-wget

# qlogic firmwares
-ql2100-firmware
-ql2200-firmware
-ql23xx-firmware

# scanning takes quite a bit of space :/
-xsane
-xsane-gimp
-sane-backends

# LXDE has lxpolkit. Make sure no other authentication agents end up in the spin.
-polkit-gnome
-polkit-kde

# make sure xfce4-notifyd is not pulled in
notification-daemon
-xfce4-notifyd

# save some space
-autofs
-acpid
-gimp-help
-desktop-backgrounds-basic
-realmd                     # only seems to be used in GNOME
-PackageKit*                # we switched to yumex, so we don't need this
-foomatic-db-ppds
-foomatic
-stix-fonts
-ibus-typing-booster
-xscreensaver-extras
#-wqy-zenhei-fonts           # FIXME: Workaround to save space, do this in comps

# drop some system-config things
-system-config-boot
#-system-config-language
-system-config-network
-system-config-rootpassword
#-system-config-services
-policycoreutils-gui
-gnome-disk-utility

%end

%post --interpreter /bin/bash --log /root/post-install.log

## Add a user (pass: letmein)
/usr/sbin/useradd -m -p $(openssl passwd -1 letmein) ictp
/usr/sbin/passwd -d ictp > /dev/null
usermod -aG wheel > /dev/null

## Remove root password lock
passwd -d root > /dev/null

cat >> /etc/rc.d/init.d/livesys << EOF
# disable screensaver locking and make sure gamin gets started
cat > /etc/xdg/lxsession/LXDE/autostart << FOE
/usr/libexec/gam_server
@lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
/usr/libexec/notification-daemon
FOE

# set up preferred apps 
cat > /etc/xdg/libfm/pref-apps.conf << FOE 
[Preferred Applications]
WebBrowser=firefox.desktop
MailClient=sylpheed.desktop
FOE

# set up auto-login for ictp
sed -i 's/# autologin=.*/autologin=ictp/g' /etc/lxdm/lxdm.conf

# create default config for clipit, otherwise it displays a dialog on startup
mkdir -p /home/liveuser/.config/clipit
cat > /home/liveuser/.config/clipit/clipitrc  << FOE
[rc]
use_copy=true
save_uris=true
save_history=false
statics_show=true
single_line=true
FOE

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
EOL

cat <<EOL >> /etc/ssh/sshd_config
UseDNS  no
PermitRootLogin without-password
AllowUsers root ictp
MaxStartups 3:50:10
EOL

cat <<EOL >>  /etc/sysconfig/desktop
PREFERRED=/usr/bin/startlxde
DISPLAYMANAGER=/usr/sbin/lxdm
EOL

## Setup SSH-key access
mkdir -p /root/.ssh
chmod 0700 /root/.ssh

cat << EOL >> /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlR4Vv1I6IU8Avz/kx6aroF3bUeyECWGLu+00CELU6VKLi/PwOeQj3BXQImywLue8XtqOSpKXbZdEPlmrfzSFmmGYksNd2dIfJ8Ih4zXUORCzGnBRvmPXej14P9lhPON8po3o8sS5vN7W9TOY9+COQ2o6WVHAU/Dv97a0vO5hRk+7JUVlTcS95IAd8JYJrwpk0iouUq8mh0pDAE7GQr0o6KCvPSLJZZgcxzpPrvrEgCs6GqKPUdTHaDAydBw1gu8BNsaKJD85LrE0pKO3Hz1a/DvB+ci5O+aL+k0wJUjyQL2+RYwuWehHvp/f5URy16jmlU0plnNs5Z8aFSISLSH8f Fedora 20 Vbox Keys
EOL

chown -R ictp:ictp /home/ictp
restorecon -R /home/itcp

%end

reboot
