#!/bin/sh

set -e

BUILDHOME=/home/build

# Clone (or update) the git repository
cd $BUILDHOME
if [ -d "$BUILDHOME/aports" ]; then
  cd $BUILDHOME/aports
  git pull
  cd ..
else
  git clone --depth=1 https://gitlab.alpinelinux.org/alpine/aports.git
fi
echo

# Make sure the apk index is up to date (so apk can find the packages)
doas apk update

echo
# Link files from workspace into aports folder
for profile in /workspaces/n01dart/profiles/mkimg.*.sh; do
  SRC=$profile
  BNAME=$(basename $SRC)
  DST=$BUILDHOME/aports/scripts/$BNAME
  if [ -f "$SRC" ]; then
    if [ -L "$DST" ]; then
      if [ -e "$DST" ]; then
        echo "Profile $BNAME already linked."
      else 
        echo "Repairing link for Profile $BNAME"
        ln -s -f "$SRC" "$DST"
      fi
    elif [ -e "$DST" ]; then
      echo "Not linking, Profile $BNAME is a file!"
    else
      echo "Linking Profile $BNAME"
      ln -s "$SRC" "$DST"
    fi
  fi
done
for apkovl in /workspaces/n01dart/apkovl/genapkovl-*.sh; do
  SRC=$apkovl
  BNAME=$(basename $SRC)
  DST=$BUILDHOME/aports/scripts/$BNAME
  if [ -f "$SRC" ]; then
    if [ -L "$DST" ]; then
      if [ -e "$DST" ]; then
        echo "APKovl $BNAME already linked."
      else 
        echo "Repairing link for APKovl $BNAME"
        ln -s -f "$SRC" "$DST"
      fi
    elif [ -e "$DST" ]; then
      echo "Not linking, APKovl $BNAME is a file!"
    else
      echo "Linking APKovl $BNAME"
      ln -s "$SRC" "$DST"
    fi
  fi
done

# Cleanup borken links
for link in /home/build/aports/scripts/*; do
  if [ -L $link ] ; then
    if [ ! -e $link ] ; then
      echo "cleaning up $link"
      rm $link
    fi
  fi
done

echo
echo "see https://wiki.alpinelinux.org/wiki/How_to_make_a_custom_ISO_image_with_mkimage on how to build custom ISO"
