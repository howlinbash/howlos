#!/bin/bash

# Add confirms and passphrase
# make reporting infrastructure
# nice colorful outputs
# source vim and install plugins
# ublock origin/devtools
# dev-icons in ranger

echo "Enter your root password:"
read -s PASSWD

mkdir -p src builds corkboard gits sandbox tmp Pictures/screenshots

# Dotfiles
cd src
git clone https://github.com/howlinbash/dotfiles
shopt -s dotglob
mv dotfiles/.config/* ~/.config/
rm -rf dotfiles/.config
mv dotfiles/bin ~/.local/
rm -rf dotfiles/bin
mv dotfiles/* ~/
rm -rf dotfiles
cd ~
