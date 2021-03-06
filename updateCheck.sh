#!/bin/bash

GREEN="\033[1;32m"
NOCOLOR="\033[0m"
CYAN="\033[1;36m"

#REF - https://codereview.stackexchange.com/questions/146896/simple-linux-upgrade-script-in-bash
#REF - https://www.raspberrypi.org/documentation/raspbian/updating.md

basic_msg() {
	for i in "$*"; do echo "$i"; done
}

green_msg() {
	STEP=$1
	MSG=$2
	#if only one arg passed in
	if [ -z "$MSG" ]
  	then
    for i in "$*"; do echo -e "${GREEN} $i ${NOCOLOR}"; done	
	else
	echo -e "Step $STEP: ${GREEN}${MSG}${NOCOLOR}";
	fi	
}
red_msg() {
	RED="\033[1;31m"
	for i in "$*"; do echo -e "${RED} $i ${NOCOLOR}"; done
}
info_msg() {	
	for i in "$*"; do echo -e "${CYAN}[i] $i ${NOCOLOR}"; done
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
	VAR=$(pihole -up --check-only)
	SUB='Everything is up to date!'
	str1=${VAR##*]}		
		
if [[ "$str1" == *"$str2"* ]]; then
	pihole -up --check-only
	pihole_flush
	next	
else		
	sudo pihole -up -y
	next
	info_msg "Update Gravity and flush query log in Pihole"
	next
	sudo pihole -g -f 
fi
}

#TODO Improve logic | assumes jq is installed https://wilsonmar.github.io/jq/
#TODO : add logic check for jq
#determine if we need to flush the logs
pihole_flush()
{
info_msg "write domain stat info to temp file and read it for now..."
next
pihole -c -j > output.json
MAX=8000
DNS_QUERIES=$(cat output.json | jq '.dns_queries_today')
if [[ $MAX -lt $DNS_QUERIES ]]; then
	info_msg "Flushing dns update gravity"
	cat output.json | jq '.'	
	sudo pihole -g -f 
	next
else
	info_msg "Flush not needed"
	next
fi
info_msg "Output metrics"
cat output.json | jq '.'
}

#REF - https://codereview.stackexchange.com/questions/146896/simple-linux-upgrade-script-in-bash
next
green_msg "let's hope this works \_(\`.\`)_/"
next

info_msg "Pre-run check...Display server disk space, kill switch will engage if space if under 1gb"
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
green_msg 4 "check if pihole exist on system"
next

if [[ -d "/etc/pihole" ]]; then
	info_msg "Pihole found!...proceed with update check"
	check_pihole
	next
else
	info_msg "Pihole not found on system, moving on"
	next	
fi

#TO Write comment in a file uncomment line below
#echo "Temp log System rebooting -->  Today: ${d}" > templog.txt

next
d=$(date +%Y-%m-%d)
info_msg "Post run - display disk space"
basic_msg "-----------------------------"
green_msg "$d"
basic_msg "-----------------------------"
echo
df -h --total /root /dev
echo
basic_msg "-----------------------------"
next 
basic_msg "Done - Rebooting Pi Server"
next
sudo shutdown -r
