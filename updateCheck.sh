#!/bin/bash

GREEN="\033[1;32m"
NOCOLOR="\033[0m"

#REF - https://codereview.stackexchange.com/questions/146896/simple-linux-upgrade-script-in-bash
#REF - https://www.raspberrypi.org/documentation/raspbian/updating.md

basic_msg() {
	for i in "$*"; do echo "$i"; done
}

green_msg() {
	STEP=$1
	MSG=$2
	echo -e "Step $STEP: ${GREEN}${MSG}${NOCOLOR}";
	#for i in "$*"; do echo -e "${GREEN} $i ${NOCOLOR}"; done
}
red_msg() {
	RED="\033[1;31m"
	for i in "$*"; do echo -e "${RED} $i ${NOCOLOR}"; done
}

next(){
echo
echo	
}

disk_spc() {
	# Total available
	AVAIL=$(df -k --total --output=avail "$PWD" | tail -n1)
	#1 GB in block size
	GB=2097152
	#If we have more than a gb continue
	if [[ $AVAIL -lt $GB ]]; then
		red_msg "|0_0| Killing the script not enough space on disk"
		exit 130
	else
		green_msg "^_^ Disk space looks good no action needed!"
		next
	fi
}

check_pihole() {

	echo
	STR=$(pihole -up --check-only)
	SUB='Everything is up to date'

	green_msg "step 8:Check pihole for updates"
	if [["$STR"==*"$SUB"*]]; then
		echo
		basic_msg "No Pihole updates needed"
	else
		echo
		red_msg "Updates available for install"

		sudo pihole -up -y
		echo
		green_msg "Update Gravity and flush query log in Pihole"
		sudo pihole -g -f
	fi
}

#REF - https://codereview.stackexchange.com/questions/146896/simple-linux-upgrade-script-in-bash
next
green_msg "let's hope this works \_(\`.\`)_/"
next


basic_msg "Pre-run check...Display server disk space, kill switch will engage if space if under 1gb"

next

disk_spc

next

green_msg 1 "update apt cache && upgrade packages"
sudo apt-get update -y && sudo apt-get full-upgrade -y

next

green_msg 2 "Distribution upgrade && Remove unused packages"
sudo apt-get dist-upgrade -y && sudo apt-get --purge autoremove -y
next

green_msg 3 "run auto clean up"
sudo apt-get autoclean
next
basic_msg "check if pihole exist on system"
next

if [[ -d "/etc/pihole" ]]; then
	basic_msg "Pihole found...proceed with update check"
	check_pihole
else
	basic_msg "Pihole not found on system, moving on"

fi

#TO Write comment in a file uncomment line below
#echo "Temp log System rebooting -->  Today: ${d}" > templog.txt

next
d=$(date +%Y-%m-%d)
basic_msg "Post run...display disk space"
basic_msg "-----------------------------"
green_msg "$d"
basic_msg "-----------------------------"
echo
df -h --total /root /dev
echo
basic_msg "-----------------------------"
next 
basic_msg "Done - Rebooting Pi Server"
sudo shutdown -r
