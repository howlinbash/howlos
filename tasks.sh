#!/bin/bash

home_dirs() {
  if [ "$MODE" == "w" ]; then
    mkdir -p src gits sandbox tmp Pictures/screenshots

    echo "src:           $(basename src)"
    echo "gits:          $(basename gits)"
    echo "sandbox:       $(basename sandbox)"
    echo "tmp:           $(basename tmp)"
    echo "screenshots:   $(basename Pictures/screenshots)"
  fi

  mkdir -p builds .notes
  touch ".notes/pkglist.txt"

  echo "builds:        $(basename builds)"
  echo "pkglist.txt:   $(basename .notes/pkglist)"
  echo ""

  echo "Home Directories:"
  ls
  continue_prompt

  echo 'Inputrc'
  sudo tee -a /etc/inputrc > /dev/null <<EOF

# My input settings controls
set editing-mode vi
set keymap vi-command
set show-all-if-ambiguous on
set completion-ignore-case on
EOF
  cat /etc/inputrc | tail
  line
  echo ""

  echo 'Keyboard Settings'
  sudo localectl set-x11-keymap us,fi pc105 "" grp:alt_shift_toggle,caps:swapescape > /dev/null
  sudo sed -i 's/^KEYMAP.*/KEYMAP=us/' /etc/vconsole.conf > /dev/null
  sudo sed -i 's/^XKBLAYOUT.*/XKBLAYOUT="us"/' /etc/default/keyboard  > /dev/null
  sudo cat /etc/vconsole.conf
  echo ""
  sudo cat /etc/default/keyboard
  line
  echo ""

  echo 'Single Sudo'
  sudo touch /etc/sudoers.d/00_prompt_once
  sudo tee -a /etc/sudoers.d/00_prompt_once > /dev/null <<EOF

## Only ask for the password once for all TTYs per reboot.
## See https://askubuntu.com/a/1278937/367284 and
##     https://github.com/hopeseekr/BashScripts/
Defaults !tty_tickets
Defaults timestamp_timeout = -1
EOF
  sudo cat /etc/sudoers.d/00_prompt_once
  line
  echo ""

  if [ "$HOSTNAME" == "the" ]; then
    echo 'Export shared dir'
    sudo tee -a /etc/exports > /dev/null <<EOF
/run/media/dells/elephant/shared 192.168.101.0/24(rw,sync,no_subtree_check)
EOF

    cat /etc/exports | tail
  fi

  if [ "$MODE" == "w" ]; then
    echo 'Add shared dir to fstab'
    sudo tee -a /etc/exports > /dev/null <<EOF
the:/run/media/dells/elephant/shared /mnt/shared nfs defaults,nofail 0 0
EOF

    sudo cat /etc/fstab | tail
  fi
}

dotfiles() {
  git clone https://github.com/howlinbash/dotfiles
  shopt -s dotglob
  mv dotfiles/.git ./
  git reset HEAD --hard
  git checkout -b "$HOSTNAME" "origin/$HOSTNAME"
  rm -rf dotfiles
}

symlinks() {
  ln -s ~/.config/__assets__/wallpaper ~/Pictures/wallpaper

  cd .local/bin
  if [ "$HOSTNAME" == "the" ]; then
    ln -s /run/media/dells/elephant/shared/src/fang/main.py fang
  elif [ "$MODE" == "w" ]; then
    ln -s /mnt/shared/src/bud/old.py bud
    ln -s /mnt/shared/src/drop/init.sh drop
    ln -s /mnt/shared/src/fang/main.py fang
    ln -s /mnt/shared/src/ktv-scripts/howl.py howl
    ln -s ~/.todo/bin/main.sh todo
  else
    echo "Unsuported mode"
    exit 1
  fi
  echo ""
  echo "wallpaper:"
  ls ~/Pictures/wallpaper
  echo ""
  echo "bins"
  ls -l
  cd
}

install_yay() {
  # Remove url gh from gitconfig (will be added back later)
  tac .gitconfig | sed '1,4d' | tac > temp && mv temp .gitconfig

  # Make Yay pacman wrapper
  cd ~/builds
  curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
  tar -xvf yay.tar.gz
  cd yay
  makepkg -sri
  cd
  yay --version
}

install_pacs() {
  git clone https://github.com/howlinbash/fang
  sudo pacman -Syu --noconfirm 
  sudo yay -S --noconfirm $(cat fang/0101_main.txt)
  if [ "$MODE" == "w" ]; then
    sudo yay -S --noconfirm $(cat fang/0202_worker.txt)
    yay -S --noconfirm $(cat fang/0202_worker_aur.txt)
    if [ "$HOSTNAME" == "howlin" ]; then
      sudo yay -S --noconfirm $(cat fang/0302_howlin.txt)
    elif [ "$HOSTNAME" == "bass" ]; then
      sudo yay -S --noconfirm $(cat fang/0303_bass.txt)
    fi
  fi
}

setup_firefox() {
  cd ~/.mozilla/firefox/*.default-release
  rm -rf chrome 
  ln -s ~/.config/__assets__/firefox/chrome chrome
  cd

  mkdir extensions
  cd extensions
  curl -L https://addons.mozilla.org/firefox/downloads/file/4412673/ublock_origin-1.62.0.xpi > ublock.xpi
  curl -L https://addons.mozilla.org/firefox/downloads/file/4427769/privacy_badger17-2025.1.29.xpi > badger.xpi
  curl -L https://addons.mozilla.org/firefox/downloads/file/4357190/reddit_enhancement_suite-5.24.7.xpi > reddit.xpi
  curl -L https://addons.mozilla.org/firefox/downloads/file/4064884/clearurls-1.26.1.xpi > urls.xpi
  if [ "$MODE" == "w" ]; then
    curl -L https://addons.mozilla.org/firefox/downloads/file/4360002/react_devtools-6.0.0.xpi > react.xpi
    curl -L https://addons.mozilla.org/firefox/downloads/file/4209147/reduxdevtools-3.1.6.xpi > redux.xpi
    firefox react.xpi
    continue_prompt 'Installing react extension'
    firefox redux.xpi
    continue_prompt 'Installing redux extension'
  fi
  firefox ublock.xpi
  continue_prompt 'Installing ublock extension'
  firefox badger.xpi
  continue_prompt 'Installing badger extension'
  firefox reddit.xpi
  continue_prompt 'Installing reddit extension'
  firefox urls.xpi
  continue_prompt 'Installing urls extension'
  cd
  rm -rf extensions
}

init_ssh() {
  sudo systemctl start sshd.service
  sudo systemctl enable sshd.service
  sudo systemctl status sshd.service
  get_passphrase
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_git -C "git-$HOSTNAME" -P $PHRASE

  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa_git

  xclip -sel c ~/.ssh/id_rsa_git.pub

  continue_prompt 'Add your key to github!'
}

auth_github() {
  source .bashrc
  git checkout .gitconfig
  ssh -T gh
}

push_keys() {
  git clone gh:howlinbash/dotfiles
  cd dotfiles
  ./../fang/main.py '-i'

  sed -i "/git-$HOSTNAME$/d" .ssh/authorized_keys 
  sed -i "/^$HOSTNAME\ /d" .ssh/known_hosts
  ssh-keyscan -t rsa,ecdsa,ed25519 $HOSTNAME >> .ssh/known_hosts
  sed -i "/^#\ $HOSTNAME/d" .ssh/known_hosts
  cat .ssh/id_rsa_git.pub >> .ssh/authorized_keys

  echo ""
  echo "Auth Keys"
  cat .ssh/authorized_keys
  echo ""
  echo "Known Hosts"
  cat .ssh/known_hosts

  continue_prompt 'Keys lookin good?'

  ./../fang/main.py "Add new keys for $HOSTNAME"

  line
  cd
  echo ""
  echo "Pull new changes"
  git pull
  rm -rf fang dotfiles
}

node_ranger() {
  mkdir -p ~/.config/ranger/plugins
  git clone gh:alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
  nvm install --lts
  node -v
}

setup_docker() {
  sudo systemctl enable --now docker
  sudo usermod -aG docker $USER
}

clone_repos() {
  git clone gh:howlinbash/grdocs greenroom

  cd src
  git clone gh:howlinbash/ktv-scripts
  git clone gh:howlinbash/ktv-server
  git clone gh:howlinbash/ktv-web
  git clone gh:howlinbash/greenroom
  git clone gh:howlinbash/grd
  git clone gh:howlinbash/grlib
  git clone gh:howlinbash/gr-scripts
  line
  echo "ktv-scripts):  $(basename ktv-scripts)"
  echo "ktv-server):   $(basename ktv-server)"
  echo "ktv-web:       $(basename ktv-web)"
  echo "greenroom:     $(basename greenroom)"
  echo "grd:           $(basename grd)"
  echo "grlib:         $(basename grlib)"
  echo "gr-scripts:    $(basename gr-scripts)"
  cd
  echo "todo-main:     $(basename .todo)"
  echo "todo:          $(basename .todo/bin)"
  echo "gr-docs:       $(basename greenroom)"
}

load_cargo() {
  ./.local/bin/cargo
}

install_backup() {
  ./../../mnt/shared/src/backup/install.sh
}

install_todo() {
  ./../../mnt/shared/src/todo/install.sh
}
