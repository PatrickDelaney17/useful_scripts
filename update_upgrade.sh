echo "checking for updates"

sudo apt-get update -y

echo -e "update command --> finished \n~~~~~~~~~~~~~~~~~~~~~ "

echo "checking for upgrade --> follow with reboot either way..."

sudo apt-get dist-upgrade -y && sudo shutdown -r
