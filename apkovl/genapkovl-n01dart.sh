#!/bin/sh -e

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
	echo "usage: $0 hostname"
	exit 1
fi

cleanup() {
	rm -rf "$tmp"
}

makefile() {
	OWNER="$1"
	PERMS="$2"
	FILENAME="$3"
	cat > "$FILENAME"
	chown "$OWNER" "$FILENAME"
	chmod "$PERMS" "$FILENAME"
}

rc_add() {
	mkdir -p "$tmp"/etc/runlevels/"$2"
	ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

workspace=$(find /workspaces/ -name alpine -type d)
workspace=${workspace%/alpine}

mkdir -p "$tmp"/home
cp -r "$workspace/alpine/home/n01dart" "$tmp"/home/
chown -R 1000:1000 "$tmp"/home/n01dart
find "$tmp"/home/n01dart -type d -exec chmod 755 {} \;
find "$tmp"/home/n01dart -type f -exec chmod 644 {} \;
chmod -R 0755 "$tmp"/home/n01dart/.setxkbmap

cp -r "$workspace/alpine/root" "$tmp"/
chown -R root:root "$tmp"/root
find "$tmp"/root -type d -exec chmod 755 {} \;
find "$tmp"/root -type f -exec chmod 644 {} \;
chmod 0700 "$tmp"/root
chmod -R 0755 "$tmp"/root/*.sh

mkdir -p "$tmp"/var/www/localhost/htdocs
unzip -q "$workspace"/n01_web_*.zip -d "$tmp"/var/www/localhost/htdocs/

mkdir -p "$tmp"/etc/apk/protected_paths.d
makefile root:root 0644 "$tmp"/etc/apk/protected_paths.d/lbu.list <"$workspace/alpine/etc/apk/protected_paths.d/lbu.list"

mkdir -p "$tmp"/etc/apk
makefile root:root 0644 "$tmp"/etc/apk/world <"$workspace/alpine/etc/apk/world"


rc_add devfs sysinit
rc_add dmesg sysinit
rc_add modloop sysinit

rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

rc_add darkhttpd default

#set /dev manager
#mdev
#rc_add mdev sysinit
#rc_add hwdrivers sysinit
#udev
rc_add udev sysinit
rc_add udev-settle sysinit
rc_add udev-trigger sysinit
rc_add udev-postmount default

tar -c -C "$tmp" home root var etc | gzip -9n > $HOSTNAME.apkovl.tar.gz
