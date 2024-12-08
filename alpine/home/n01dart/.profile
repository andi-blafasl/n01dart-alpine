LANG=de_DE.UTF-8
LC_ALL=de_DE.UTF-8

if [ -z "$DISPLAY" ] && [ "$(tty)" == "/dev/tty1" ]; then
  exec startx
fi
