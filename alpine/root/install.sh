#!/bin/sh

# Parameter 1 = disk device name without path!

if [ -z "$1" ]; then
  disk="sda"
else
  disk=$1
fi
part=${disk}1
diskdev=/dev/$disk
partdev=/dev/$part

echo "This will install kiosk mode to $part"
echo "!!! All data on $disk will be wiped !!!"
echo
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
echo

umount $partdev 2>/dev/null
swapoff -a 
wipefs --all --force ${diskdev}*
echo '2048,,c,*' | sfdisk --label 'dos' --wipe 'always' $diskdev
mkfs.vfat -n APKOVL $partdev
modprobe vfat

echo
apk fix
echo

setup-bootable /media/cdrom $partdev

echo

#setup-alpine -f setup-answer <- done with individual setup scripts to skip some parts not needed

setup-keymap de de-nodeadkeys
setup-hostname n01dart && rc-service hostname --quiet restart
INTERFACESOPTS="auto lo
iface lo inet loopback
"
printf "$INTERFACESOPTS" | setup-interfaces -i -r
echo "Enter password for root"
	while ! passwd ; do
		echo "Please retry."
	done
setup-timezone Europe/Berlin
rc-update --quiet add networking boot
rc-update --quiet add seedrng boot || rc-update --quiet add urandom boot
svc_list="cron crond"
if [ -e /dev/input/event0 ]; then
	# Only enable acpid for systems with input events entries
	# https://gitlab.alpinelinux.org/alpine/aports/-/issues/12290
	svc_list="$svc_list acpid"
fi
for svc in $svc_list; do
	if rc-service --exists $svc; then
		rc-update --quiet add $svc
	fi
done
setup-user -u -g input,audio,video,netdev n01dart
sed -i -e 's+^tty1:.*+tty1::respawn:/sbin/agetty --autologin n01dart tty1 linux+' /etc/inittab
setup-lbu LABEL=APKOVL
umount $partdev 2>/dev/null
mount -o rw $partdev /media/LABEL=APKOVL 
setup-apkcache /media/LABEL=APKOVL/cache

lbu ci

echo "reboot now for auto login kiosk mode"

exit 0