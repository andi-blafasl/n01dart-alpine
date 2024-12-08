# Alpine image with all tools to build a custiom ISO
FROM alpine:latest

LABEL name="Alpine ISO creator" \
      description="This image contains all tools needed to create a custiom ISO. See: https://wiki.alpinelinux.org/wiki/How_to_make_a_custom_ISO_image_with_mkimage" \
      vendor="Andreas H." \
      version="0.1"

# Upgrade all Packages
RUN apk upgrade --no-cache

# Install Packages
RUN apk add --no-cache alpine-sdk alpine-conf syslinux xorriso squashfs-tools grub grub-efi doas mtools dosfstools 
#tmux

# Create build user
RUN adduser build -G abuild; \
    echo 'build:build' | chpasswd; \
    echo 'permit nopass :abuild' > /etc/doas.d/doas.conf

# Switch to user
USER build

# Config tmux
#RUN echo 'set -g mouse on' >/home/build/.tmux.conf; \
#    echo 'set -g history-limit 30000' >>/home/build/.tmux.conf
