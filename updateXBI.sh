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
    echo -e "${GREEN}Preparing the VPS to setup to update $COIN_NAME masternode${NC}"
    echo -e "${GREEN}* Removing old $COIN_NAME cli and deamon${NC}"
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

function prepare_system() {

echo -e "${GREEN}* Making sure system is up to date...${NC}"
apt-get update > /dev/null 2>&1
apt-get -y upgrade > /dev/null 2>&1



export DEBIAN_FRONTEND=noninteractive
aptget_params='--quiet -y'

echo -e "    ${GREEN}> Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin > /dev/null 2>&1
apt-get ${aptget_params} install software-properties-common > /dev/null 2>&1

dpkg --clear-avail > /dev/null 2>&1
apt-get ${aptget_params} update > /dev/null 2>&1
apt-get --quiet -f install > /dev/null 2>&1
dpkg --configure -a > /dev/null 2>&1

# intentional duplicate to avoid some errors
apt-get ${aptget_params} update > /dev/null 2>&1
apt-get ${aptget_params} upgrade > /dev/null 2>&1

echo -e "    ${GREEN}> Installing required packages, it may take some time to finish.${NC}"
package_list="build-essential libtool curl autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 ufw libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libboost-dev libevent-1.4-2 libdb4.8-dev libdb4.8++-dev autoconf libboost-all-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev libminiupnpc-dev git multitail vim unzip unrar htop ntpdate"
apt-get ${aptget_params} install ${package_list} > /dev/null 2>&1 || apt-get ${aptget_params} install ${package_list} > /dev/null 2>&1

apt-get ${aptget_params} install ${package_list} > /dev/null 2>&1 || apt-get ${aptget_params} install ${package_list} > /dev/null 2>&1

apt-get ${aptget_params} update > /dev/null 2>&1
apt-get ${aptget_params} upgrade > /dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5"
 exit 1
fi
echo -e "    ${GREEN}> synchronize time${NC}"; sleep 0.5s
ntpdate -s time.nist.gov

clear
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

##### Main #####
clear

purgeOldInstallation
prepare_system
download_node
add_bootstrap
restart_service
