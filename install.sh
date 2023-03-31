#!/bin/bash

# Add confirms and passphrase
# nice colorful outputs
# ublock origin/devtools

echo "Enter your root password:"
read -s PASSWD
echo "Enter your ssh passphrase:"
read -s PHRASE

mkdir -p src builds corkboard gits sandbox tmp Pictures/screenshots

# Dotfiles
git clone https://github.com/howlinbash/dotfiles
shopt -s dotglob
mv -f dotfiles/.config/gtk-3.0/* ~/.config/gtk-3.0/
rm -rf dotfiles/.config/gtk-3.0
mv dotfiles/.config/* ~/.config/
rm -rf dotfiles/.config
mv dotfiles/.local/* ~/.local/
rm -rf dotfiles/.local
mv dotfiles/* ~/
rm -rf dotfiles

# Remove url gh from gitconfig (will be added back later)
tac .gitconfig | sed '1,2d' | tac > temp && mv temp .gitconfig

# symlinks
ln -s ~/.config/__assets__/wallpaper ~/Pictures/wallpaper

# Make Yay pacman wrapper
cd ~/builds
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar -xvf yay.tar.gz
cd yay
makepkg -sri
cd

echo "$PASSWD" | sudo -S pacman -Syu --noconfirm 
echo "$PASSWD" | sudo -S yay -S --noconfirm $(cat .notes/pkglist.txt)

echo "$PASSWD" | sudo -S tee -a /etc/inputrc > /dev/null <<EOF

# My input settings controls
set editing-mode vi
set keymap vi-command
set show-all-if-ambiguous on
set completion-ignore-case on
EOF

echo "$PASSWD" | sudo -S localectl set-x11-keymap us,fi pc105 "" grp:alt_shift_toggle,caps:swapescape > /dev/null
echo "$PASSWD" | sudo -S sed -i 's/^KEYMAP.*/KEYMAP=us/' /etc/vconsole.conf > /dev/null
echo "$PASSWD" | sudo -S sed -i 's/^XKBLAYOUT.*/XKBLAYOUT="us"/' /etc/defaults/keyboard  > /dev/null

# Ranger icons
mkdir -p ~/.config/ranger/plugins
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# Firefox
cd ~/.mozilla/firefox/*.default-release
rm -rf chrome 
ln -s ~/.config/__assets__/firefox/chrome chrome

# ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_rogers -C rogers -P $PHRASE

echo "$PASSWD" | sudo -S touch /etc/sudoers.d/00_prompt_once
ls /etc/sudoers.d
echo "$PASSWD" | sudo -S tee -a /etc/sudoers.d/00_prompt_once > /dev/null <<EOF

## Only ask for the password once for all TTYs per reboot.
## See https://askubuntu.com/a/1278937/367284 and
##     https://github.com/hopeseekr/BashScripts/
Defaults !tty_tickets
Defaults timestamp_timeout = -1
EOF
