#!/bin/bash

# Add confirms and passphrase
# make reporting infrastructure
# nice colorful outputs
# source vim and install plugins
# ublock origin/devtools
# dev-icons in ranger

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
mkdir -p extensions
cd extensions
curl -L https://addons.mozilla.org/firefox/downloads/file/4086892/ublock_origin-1.48.0.xpi > ublock_origin1.xpi
curl -L https://addons.mozilla.org/firefox/downloads/file/4064595/privacy_badger17-2023.1.31.xpi > privacy_badger.xpi
curl -L https://addons.mozilla.org/firefox/downloads/file/4040280/react_devtools-4.27.1.xpi > react_devtools.xpi
curl -L https://addons.mozilla.org/firefox/downloads/file/4047244/reddit_enhancement_suite-5.22.15.xpi > reddit_enhancement_suite.xpi
curl -L https://addons.mozilla.org/firefox/downloads/file/4079806/reduxdevtools-3.0.19.xpi > reduxdevtools.xpi

# Chromium
# cd ~/.config/chromium/Default
# mkdir -p Extensions
# cd Extensions
# curl -L -o ublock-origin.crx "$(curl -sL "https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en" | jq -r '.[].url')"
# ORIGIN_ID=$(unzip -qc ublock-origin.crx manifest.json | jq -r '.key')
# mv ublock-origin.crx $ORIGIN_ID.crx
# chmod 644 $ORIGIN_ID.crx
# curl -L -o react.crx "$(curl -sL "https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en-GB" | jq -r '.[].url')"
# REACT_ID=$(unzip -qc react.crx manifest.json | jq -r '.key')
# mv react.crx $REACT_ID.crx
# chmod 644 $REACT_ID.crx
# curl -L -o redux.crx "$(curl -sL "https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd?hl=en-GB" | jq -r '.[].url')"
# REDUX_ID=$(unzip -qc redux.crx manifest.json | jq -r '.key')
# mv redux.crx $REDUX_ID.crx
# chmod 644 $REDUX_ID.crx
# git clone https://github.com/ken107/chromium-slinky-elegant-theme.git


# ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_rogers -C rogers -P $PHRASE

echo "$PASSWD" | sudo -S tee -a /etc/sudoers.d/00_prompt_once > /dev/null <<EOF

## Only ask for the password once for all TTYs per reboot.
## See https://askubuntu.com/a/1278937/367284 and
##     https://github.com/hopeseekr/BashScripts/
Defaults !tty_tickets
Defaults timestamp_timeout = -1
EOF
