profile_n01dart() {
        profile_standard
        profile_abbrev="dart"
        title="n01dart"
        desc="add darkhttp, xorg, openbox and firefox to get n01dart in KIOSK mode"
        arch="x86_64"
        boot_addons="amd-ucode intel-ucode"
        initrd_ucode="/boot/amd-ucode.img /boot/intel-ucode.img"
        apks="$apks
                agetty
                darkhttpd
                eudev
                doas
                firefox
                font-awesome
                font-dejavu
                font-inconsolata
                font-noto
                font-noto-cjk
                font-noto-extra
                font-terminus
                mesa-dri-gallium
                obconf-qt
                openbox
                setxkbmap
                xset
                udev-init-scripts
                udev-init-scripts-openrc
                xf86-input-libinput
                xinit
                xorg-server
                xterm
                wipefs
                sfdisk
                dosfstools
                syslinux
                tzdata
                musl-locales
                grub
                grub-bios
                grub-efi
                "

        local _k _a
        for _k in $kernel_flavors; do
                apks="$apks linux-$_k"
                for _a in $kernel_addons; do
                        apks="$apks $_a-$_k"
                done
        done
        apks="$apks linux-firmware linux-firmware-none"
        apkovl="aports/scripts/genapkovl-n01dart.sh"
}