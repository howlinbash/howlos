#!/bin/bash

padding() {
  printf '%*s\n' "$1" | tr ' ' '-'
}

line() {
  NC='\033[0m' # No Color
  EDGE=$(padding 47)
  GREEN='\033[1;32m'
  echo -e "${GREEN}+${EDGE}+${NC}"
}

heading() {
  MAX_LENGTH=33
  MESSAGE=$1

  PX=$(($MAX_LENGTH - ${#MESSAGE}))
  IS_ODD=$(($PX % 2 == 1))
  LX=$(($PX / 2))
  RX=$(( IS_ODD ? $PX / 2 + 1 : $PX / 2))

  EDGE=$(padding 47)
  LEFT=$(padding $LX)
  RIGHT=$(padding $RX)

  CYAN='\033[1;36m'
  NC='\033[0m' # No Color
  WARNING="${CYAN}/${NC}!${CYAN}\\"

  echo ""
  line
  echo -e " ${WARNING} ${NC}${LEFT}|  ${CYAN}${MESSAGE^^}${NC}  |${RIGHT}${GREEN} ${WARNING}"
  line
  echo -e "${NC}"
}

get_password() {
  echo "Enter your root password:"
  read -s PASSWD
  echo "Confirm it"
  read -s PASSWD2

  if [ "$PASSWD" != "$PASSWD2" ]; then
    echo "Passwords don't match. Please try again."
    get_password
  fi
}

get_passphrase() {
  echo "Enter your root passphrase:"
  read -s PHRASE
  echo "Confirm it"
  read -s PHRASE2

  if [ "$PHRASE" != "$PHRASE2" ]; then
    echo "Passphrase don't match. Please try again."
    get_passphrase
  fi
}

continue_prompt() {
  echo ""
  echo "Do you want to continue?"
  read
  echo ""
}


heading 'Back for more I see'
get_password
get_passphrase
echo ""


heading 'Restore gitconfig'
cd
git checkout main -- .gitconfig
echo ".gitconfig:"
cat .gitconfig
echo ""


heading 'Authenticate github ssh'
ssh -T gh
continue_prompt


heading 'Download Repos'
cd src
git clone gh:howlinbash/auctioneer
git clone gh:howlinbash/bingo
git clone gh:howlinbash/bisto
git clone gh:howlinbash/blogposts
git clone gh:howlinbash/blower
git clone gh:howlinbash/build-server
git clone gh:howlinbash/config
git clone gh:howlinbash/contact-us
git clone gh:howlinbash/course-clips
git clone gh:howlinbash/cv
git clone gh:howlinbash/heidi
git clone gh:howlinbash/helppy
git clone gh:howlinbash/how
git clone gh:howlinbash/howlinbash
git clone gh:howlinbash/ktv-server
git clone gh:howlinbash/ktv-web
git clone gh:howlinbash/manual
git clone gh:howlinbash/operator
git clone gh:howlinbash/rumba
git clone gh:howlinbash/singer
git clone gh:howlinbash/swayze
git clone gh:howlinbash/talks
git clone gh:howlinbash/todo
git clone gh:howlinbash/toucan
git clone gh:howlinbash/tubesearch
line
echo "auctioneer:    $(basename auctioneer)"
echo "bingo:         $(basename bingo)"
echo "bisto:         $(basename bisto)"
echo "blogposts:     $(basename blogposts)"
echo "blower:        $(basename blower)"
echo "build-server:  $(basename build-server)"
echo "config:        $(basename config)"
echo "contact-us:    $(basename contact-us)"
echo "course-clips:  $(basename course-clips)"
echo "cv:            $(basename cv)"
echo "heidi:         $(basename heidi)"
echo "how:           $(basename how)"
echo "howlinbash:    $(basename howlinbash)"
echo "ktv-server:    $(basename ktv-server)"
echo "ktv-web:       $(basename ktv-web)"
echo "manual:        $(basename manual)"
echo "operator:      $(basename operator)"
echo "rumba:         $(basename rumba)"
echo "singer:        $(basename singer)"
echo "swayze:        $(basename swayze)"
echo "talks:         $(basename talks)"
echo "todo:          $(basename todo)"
echo "toucan:        $(basename toucan)"
echo "tubesearch:    $(basename tubesearch)"
cd
line
continue_prompt


heading 'Symlinks & Todo'
ln -s src/how/Main.py .local/bin/how
ln -s src/todo/main.sh .local/bin/todo
ln -s src/todo/todo.vim .config/nvim/todo/todo.vim
ln -s src/todo/syntax/todo.vim .config/nvim/syntax/todo.vim
mkdir -p ~/.todo
mkdir -p ~/.todo/archive
mkdir -p ~/.todo/cards
mkdir -p ~/.todo/boards
echo "

TODO
====


" > ~/.todo/boards/index.todo

line
echo "How:"
ls -l .local/bin/how
echo "Todo (3):"
ls -l .local/bin/todo
ls -l .config/nvim/todo
ls -l .config/nvim/syntax
echo "Todo dir:"
ls -1 .todo
cat .todo/boards/index.todo
line
echo ""

source ~/.bashrc

heading 'All Done'
