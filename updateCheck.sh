#!/bin/bash

start=`date +%s`
GREEN="\033[1;32m"
NOCOLOR="\033[0m"
CYAN="\033[1;36m"
d=$(date +%Y-%m-%d)
ip=$(hostname -I | cut -d' ' -f1)
logPath=~/$laLogPath

basic_msg() {
	for i in "$*"; do echo "$i"; done
}

green_msg() {
	STEP=$1
	MSG=$2
	#if only one arg passed in
	if [ -z "$MSG" ]
  	then
    for i in "$*"; do echo -e "${GREEN}$i ${NOCOLOR}"; done	
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

calc_runtime()
{
  STARTTIME=$1
  ENDTIME=$2 
  let DURATION=${ENDTIME}-${STARTTIME} 
  local SECONDS H M S MM H_TAG M_TAG S_TAG
  SECONDS=$DURATION
  let S=${SECONDS}%60
  let MM=${SECONDS}/60 # Total number of minutes
  let M=${MM}%60
  let H=${MM}/60
  info_msg "Script duration info"
  next
   # Display "01h02m03s" format
   [ "$H" -gt "0" ] && printf "%02d%s" $H "h"
   [ "$M" -gt "0" ] && printf "%02d%s" $M "m"    
   printf "%02d%s\n" $S "s"
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

verify_dependency(){
HasJQ=$(command jq -Version)
info_msg "verify dependencies"
# check if null or empty, if variable has a length = 0 if jq is missing then prompt to install
if [ -z "$HasJQ" ]
then
red_msg "JQ dependency missing!"
info_msg "Attempting to install JQ package"
next
sudo apt install -y jq
next
green_msg "JQ installment attempt done."
next
confim_install
else
green_msg "JQ Version Installed: $HasJQ"
fi
}

confim_install(){
HasJQ=$(command jq -Version)
info_msg "verify installment"
next
# check if null or empty, if variable has a length = 0 if jq is missing then prompt to install
if [ -z "$HasJQ" ]
then
red_msg "|0_0| Unable to verify JQ installed script cancelled"
		exit 130
else
green_msg "JQ Version Installed: $HasJQ"
fi
}
show_core_banner(){
basic_msg "-----------------------------"
basic_msg "Server hostname: $HOSTNAME"
basic_msg "IP: $ip"
green_msg "Date: $d"
basic_msg "-----------------------------"
next
}

# Check if updates are available
check_pihole() {	
	
	VAR=$(pihole -up --check-only)
	SUB='available'

if [[ "$VAR" == *"$SUB"* ]]; then  	

	sudo pihole -up -y
	next
	info_msg "Now update gravity and flush query log in Pihole"
	next
	sudo pihole -g -f 
else
	pihole -up --check-only	
	next
fi
}

#TODO Improve logic 
# Determine if we need to flush the logs
pihole_flush()
{
#TODO make log path param option 
pihole -c -j > $logPath/dns_output.json
MAX=12000
info_msg "Flush if query count above $MAX"
DNS_QUERIES=$(cat $logPath/dns_output.json | jq '.dns_queries_today')
if [[ $MAX -lt $DNS_QUERIES ]]; then
	info_msg "Flushing dns update gravity"
	cat $logPath/dns_output.json | jq '.'
	sudo pihole -g -f 
	next
else
	info_msg "Flush not needed"
fi
info_msg "Display DNS Stats"
cat $logPath/dns_output.json | jq '.'
}

check_git() {	
	info_msg "checking if latest script has been pulled"
	next
	VAR=$(git pull)
	SUB='Already up to date.'
#TODO Does not restart
if [[ "$VAR" != "$SUB" ]]; then
	git pull
	info_msg "Latest changes needed to be pulled, script cancelled, re-run script to use latest version."
	exit 130
else 
	green_msg "Script already up to date!"
fi

}

pihole_mgmt()
{
	verify_dependency
	next	
	check_pihole	
	next
	pihole_flush
}

next
green_msg "let's hope this works \_(\`.\`)_/"
next

show_core_banner
info_msg "Pre-run check...Display server disk space, kill switch will engage if space if under 1gb"
disk_spc
next
check_git
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
green_msg 4 "run pihole management methods"
next
pihole_mgmt


info_msg "Post run - Display Disk Space"
show_core_banner
df -h --total /root /dev
echo
basic_msg "-----------------------------"
next 
end=`date +%s`
calc_runtime $start $end
next
info_msg "Rebooting Pi Server"


next
sudo shutdown -r
