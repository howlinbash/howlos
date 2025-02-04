#!/bin/bash

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
section ranger_plugins 'Extend Ranger'
section init_ssh 'Initialise SSH' 'Did you add it?'
section auth_github 'Authenticate Github'
section push_keys 'Commit new SSH keys'

if [ "$MODE" == "w" ]; then
  section clone_repos 'Clone My Repos'
fi

heading "All Done"
