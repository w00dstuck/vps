#!/bin/bash

CONFIG_FILE='xbi.conf'
CONFIGFOLDER='/root/.XBI'
COIN_DAEMON='xbid'
COIN_CLI='xbi-cli'
COIN_PATH='/usr/local/bin/'
COIN_REPO="https://github.com/XBIncognito/xbi-4.3.2.1/releases/download/4.4.0/"
BOOTSTRAP="https://github.com/sub307/XBI-bootstrap/releases/download/1095150/1095150.rar"
COIN_ZIPFILE="Xbi-linux.zip"
COIN_TGZ="${COIN_REPO}${COIN_ZIPFILE}"
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_NAME='XBI'

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m" 
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

function purgeOldInstallation() {
    echo -e "${GREEN}Preparing the VPS to setup to install $COIN_NAME masternode${NC}"
    echo -e "${GREEN}* Searching and removing old $COIN_NAME files and configurations${NC}"
#kill wallet daemon
    systemctl stop $COIN_NAME.service > /dev/null 2>&1
    killall $COIN_DAEMON > /dev/null 2>&1
    killall $COIN_DAEMON > /dev/null 2>&1
#remove old files
    rm -- "$0" > /dev/null 2>&1
    rm -rf /usr/local/bin/$COIN_CLI /usr/local/bin/$COIN_DAEMON> /dev/null 2>&1
    rm -rf /usr/bin/$COIN_CLI /usr/bin/$COIN_DAEMON > /dev/null 2>&1
    echo -e "    ${YELLOW}> Done${NC}";
}

function download_node() {
  echo -e "${GREEN}* Downloading and Installing VPS $COIN_NAME Daemon${NC}"
  cd ~ > /dev/null 2>&1
  echo -e "    ${YELLOW}> Downloading...${NC}"
  wget -q $COIN_TGZ 
  echo -e "    ${YELLOW}> Extracting...${NC}"
  unzip $COIN_ZIP > /dev/null 2>&1
  strip $COIN_DAEMON
  strip $COIN_CLI
  chmod +x $COIN_DAEMON $COIN_CLI
  mv $COIN_DAEMON $COIN_CLI $COIN_PATH
  cd ~ > /dev/null 2>&1
  echo -e "    ${YELLOW}> Removing zipfile...${NC}"
  rm xbi-tx
  rm $COIN_ZIP > /dev/null 2>&1
  clear
  echo -e "    ${YELLOW}> Done${NC}"
}

function add_bootstrap(){
 echo -e "${GREEN}* Downloading bootstrap"
 cd $CONFIGFOLDER > /dev/null 2>&1
 echo -e "    ${YELLOW}> Downloading...${NC}"
 wget -q $BOOTSTRAP -O 1095150.rar
 echo -e "    ${YELLOW}> Extracting...${NC}"
 rm -rf chainstate > /dev/null 2>&1
 rm -rf blocks > /dev/null 2>&1
 rm peers.dat > /dev/null 2>&1
 unrar x 1095150.rar >/dev/null 2>&1
 echo -e "    ${YELLOW}> Removing zipfile...${NC}"
 rm 1095150.rar > /dev/null 2>&1
 cd ~ > /dev/null 2>&1
 echo -e "    ${YELLOW}> Done${NC}"
}

function restart_service() {
  systemctl daemon-reload
  sleep 3
  systemctl enable $COIN_NAME.service > /dev/null 2>&1
  systemctl start $COIN_NAME.service

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}

function important_information() {
 echo
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${BLUE}Windows Wallet Guide. https://github.com/sub307/Bitcoin_Incognito/blob/master/README.md${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${GREEN}$COIN_NAME Masternode is up and running listening on port${NC}${PURPLE}$COIN_PORT${NC}."
 echo -e "${GREEN}Configuration file is:${NC}${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
 echo -e "${GREEN}Start:${NC}${RED}systemctl start $COIN_NAME.service${NC}"
 echo -e "${GREEN}Stop:${NC}${RED}systemctl stop $COIN_NAME.service${NC}"
 echo -e "${GREEN}VPS_IP:${NC}${GREEN}$NODEIP:$COIN_PORT${NC}"
 echo -e "${GREEN}MASTERNODE GENKEY is:${NC}${PURPLE}$COINKEY${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${RED}Ensure Node is fully SYNCED with BLOCKCHAIN before starting your Node :).${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
 echo -e "${GREEN}Usage Commands.${NC}"
 echo -e "${GREEN}xbi-cli masternode status${NC}"
 echo -e "${GREEN}xbi-cli getinfo.${NC}"
 echo -e "${BLUE}================================================================================================================================${NC}"
}

##### Main #####
clear

purgeOldInstallation
download_node
add_bootstrap
restart_service
important_information
