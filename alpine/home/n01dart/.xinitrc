#~/.setxkbmap &
#set keymap
/bin/ash -c 'setxkbmap $(basename /etc/keymap/* | cut -c1-2)'
#disable screensaver
xset s off -dpms 
#start openbox
exec openbox-session
