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
section setup_docker 'Setup Docker'

if [ "$MODE" == "w" ]; then
  section clone_repos 'Clone My Repos'
fi

if [ "$MODE" == "w" ]; then
  heading 'Run amount in a second terminal'
  continue_prompt 'Did it work?'
elif [ "$MODE" == "s" ]; then
  continue_prompt 'Is elephant and dumbledore connected?'
  section load_cargo 'Load Cargo' 'Did you export the nfs?'
fi

section install_backup 'Setup backup routines'

if [ "$MODE" == "w" ]; then
  section install_todo 'Install Todo'
fi

passwd
sudo passwd root

heading "All Done"
