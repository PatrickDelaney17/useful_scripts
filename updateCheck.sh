#!/bin/bash

#RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

#REF - https://codereview.stackexchange.com/questions/146896/simple-linux-upgrade-script-in-bash
#REF - https://www.raspberrypi.org/documentation/raspbian/updating.md

echo
echo
echo -e "let's hope this works ${GREEN}¯\_(ツ)_/¯${NOCOLOR}"
echo

#echo -e "step 1: ${GREEN}pre-configuring packages${NOCOLOR}"
#sudo dpkg --configure -a

#echo 

#echo -e "step 2: ${GREEN}fix and attempt to correct a system with broken dependencies${NOCOLOR}"
#sudo apt-get install -f

echo

echo -e "step 1: ${GREEN}update apt cache${NOCOLOR}"
sudo apt-get update -y

echo

echo -e "step 2: ${GREEN}upgrade packages${NOCOLOR}"
sudo apt-get full-upgrade -y

echo

echo -e "step 3: ${GREEN}distribution upgrade${NOCOLOR}"
sudo apt-get dist-upgrade -y

echo

echo -e "step 4: ${GREEN}remove unused packages${NOCOLOR}"
sudo apt-get --purge autoremove -y

echo

echo -e "step 5: ${GREEN}clean up${NOCOLOR}"
sudo apt-get autoclean

#echo -e "Setting temp log before reboot..."
#d=$(date +%Y-%m-%d)

#TO Write comment in a file uncomment line below
#echo "Temp log System rebooting -->  Today: ${d}" > templog.txt

#echo -e "step 6:${GREEN}Check pihole for updates${NOCOLOR}"
#sudo pihole -up -y

#echo

#echo -e "step 9: ${GREEN}Update Gravity and flush query log in Pihole${NOCOLOR}"
#sudo pihole -g -f


echo

echo -e "step 6: ${GREEN} Rebooting Pi Server${NOCOLOR}"
sudo shutdown -r
