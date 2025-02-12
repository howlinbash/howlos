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
  line
  echo ""

  if [ "$1" == "" ]; then
    echo "Ready to move on? [Y/n]: "
  else
    echo "$1 [Y/n]: "
  fi

  read INPUT

  if [ "$INPUT" == "n" ] || [ "$INPUT" == "q" ]; then
    echo "bye then"
    exit 0
  fi
}

ask_is_skipping() {
  echo "Execute section [Y/n]: "
  read INPUT

  if [ "$INPUT" == "n" ]; then
    return 1
  else
    return 0
  fi
}

section() {
  local func=$1
  heading "$2"
  ask_is_skipping
  is_skipping=$?

  if [ "$is_skipping" -eq 0 ]; then
    $func
    continue_prompt "$3"
  elif [ "$is_skipping" -eq 1 ]; then
    return
  else
    echo "ERROR: Section skipping failed"
    exit 1
  fi
}

get_mode() {
  if [ "$HOSTNAME" == "howlin" ] || [ "$HOSTNAME" == "bass" ] || [ "$HOSTNAME" == "wolf" ]; then
    MODE="w"
  elif [ "$HOSTNAME" == "the" ]; then
    MODE="s"
  else
    echo "ERROR: Unknown Host"
    exit 1
  fi
}

cleanup() {
  echo "Cleaning up..."
  kill "$bg_pid" 2>/dev/null
}

auth_sudo() {
  sudo -v
  trap cleanup EXIT
  (while true; do sleep 60; sudo -v; done) &
  bg_pid=$!
}
