#!/bin/bash


GREEN="\033[1;32m"
NOCOLOR="\033[0m"

#REF - https://codereview.stackexchange.com/questions/146896/simple-linux-upgrade-script-in-bash
#REF - https://www.raspberrypi.org/documentation/raspbian/updating.md

function show_msg(){
	printf "Usage: $0 [options [parameters]]\n";
	printf "\n"
	printf "Options:\n"
	printf "-s|--skip [skips one of the optional checks within the update check] <parameter value> , dc(disk space check), pi (pihole upgrade check), all (non-essential) \n"
	printf "-h|--help, print help\n"

	return 0;
}

basic_msg(){
   for i in "$*"; do echo "$i"; done;
}

green_msg(){
 for i in "$*"; do echo -e "${GREEN} $i ${NOCOLOR}"; done;
}
red_msg()
{
RED="\033[1;31m"
for i in "$*"; do echo -e "${RED} $i ${NOCOLOR}"; done;
}

disk_spc(){
	# Total available
	AVAIL=`df -k --total --output=avail "$PWD" | tail -n1`
	#1 GB in block size
	GB=2097152
	#If we have more than a gb continue
	if [$AVAIL -lt $GB]
		then 
		red_msg "|0_0| Killing the script not enough space on disk"
		exit 130
		else		
		green_msg "^_^ Disk space looks good no action needed!"
		echo
		fi;
}

check_pihole(){

	echo
	STR=$(pihole -up --check-only)
	SUB='Everything is up to date'

	green_msg "step 8:Check pihole for updates"
	if [[ "$STR" == *"$SUB"* ]]; then
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
echo
echo
green_msg "let's hope this works \_(\`.\`)_/"
echo

echo
basic_msg "Pre-run check...Display server disk space, kill switch will engage if space if under 1gb"
echo
echo
disk_spc

echo

green_msg "step 1: update apt cache"
sudo apt-get update -y

echo

green_msg "step 2: upgrade packages"
sudo apt-get full-upgrade -y

echo

green_msg "step 3: distribution upgrade"
sudo apt-get dist-upgrade -y

echo

green_msg "step 4: remove unused packages"
sudo apt-get --purge autoremove -y

echo

green_msg "step 5: clean up"
sudo apt-get autoclean

#echo -e "Setting temp log before reboot..."
#d=$(date +%Y-%m-%d)
basic_msg "check if pihole exist on system"
echo

if [[ -d "/etc/pihole" ]]
then
    basic_msg "Pihole found...proceed with update check"
	check_pihole
	else
	basic_msg "Pihole not found on system, moving on"
	
fi

#TO Write comment in a file uncomment line below
#echo "Temp log System rebooting -->  Today: ${d}" > templog.txt

echo
echo
basic_msg "Post run...display disk space"
basic_msg "-----------------------------"
echo
df -h --total /root /dev
echo
basic_msg "-----------------------------"
echo 
echo
basic_msg "step 6: Rebooting Pi Server"
sudo shutdown -r
