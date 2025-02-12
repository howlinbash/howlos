#!/bin/bash

cd "$(dirname "$0")"
source ./lib.sh
source ./tasks.sh
cd

heading 'Greetings Nerd'

get_mode
auth_sudo

section home_dirs 'Home Directories and Settings'
section dotfiles 'Dotfiles'
section symlinks 'Symlinks'
section install_yay 'Yay' 'Did you get a yay version number'
section install_pacs 'Install Packages'
section setup_firefox 'Setup Firefox'
section init_ssh 'Initialise SSH' 'Did you add it?'
section auth_github 'Authenticate Github'
section push_keys 'Commit new SSH keys'
section node_ranger 'Install node and extend Ranger' 'Did you get a node version number'

if [ "$MODE" == "w" ]; then
  section clone_repos 'Clone My Repos'
fi

passwd
sudo passwd root

heading "All Done (consider enabling backups/mounting dirs)"

# Add function to run these commands next
# - cargo
# - ./backup/install

# Setup docker
# sudo systemctl enable --now docker
# sudo usermod -aG docker $USER
# logout login
