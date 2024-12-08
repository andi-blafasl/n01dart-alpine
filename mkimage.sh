#!/bin/sh

outdir=$(find /workspaces/ -name iso -type d)

if [ -z "$1" ]; then
	prof=n01dart
else
	prof=$1
fi

cd ~
sh aports/scripts/mkimage.sh --tag edge \
	--outdir $outdir \
	--arch x86_64 \
	--repository https://dl-cdn.alpinelinux.org/alpine/edge/main \
	--repository https://dl-cdn.alpinelinux.org/alpine/edge/community \
	--profile $prof
