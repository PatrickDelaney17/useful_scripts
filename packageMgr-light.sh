#!/bin/bash

sudo apt-get update -y && sudo apt-get full-upgrade -y
echo
sudo apt-get dist-upgrade -y && sudo apt-get --purge autoremove -y
echo
sudo apt-get autoclean
echo
sudo shutdown -r