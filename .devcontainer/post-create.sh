#!/bin/sh

set -e

BUILDHOME=/home/build

#fix 777 permissions from WSL mount
#doas chmod 755 /workspaces/*
#doas chmod -R 600 $BUILDHOME.ssh

# create signing keys Non-interactive if no already exists
if [ -f $BUILDHOME/.abuild/*.rsa ]; then
  echo "signing key alread there"
else
  abuild-keygen -i -a -n
fi