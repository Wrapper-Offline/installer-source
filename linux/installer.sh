#!/usr/bin/env bash

# Wrapper: Offline Installer
# Author: sparrkz#0001
# License: MIT

grep '^ID' /etc/os-release

##########################
##   Dependency Check   ##
##########################

printf '\033]2;Wrapper: Offline Installer [Checking for Git...]\a'
echo 'Checking for Git installation...'

# Preload variables
GIT_DETECTED="n"

# Git check

output=$(git --version)
if [ $output -gt 0 ]; then
    echo "Git is installed."
	GIT_DETECTED="y"
else
    echo "Git could not be found"
fi

##########################
##  Dependency Install  ##
##########################

if [ $GIT_DETECTED -eq "n" ]; then
	# Install Git
	declare -A osInfo;
	osInfo[/etc/redhat-release]=yum
	osInfo[/etc/arch-release]=pacman
	osInfo[/etc/gentoo-release]=emerge
	osInfo[/etc/SuSE-release]=zypp
	osInfo[/etc/debian_version]=apt-get
	osInfo[/etc/alpine-release]=apk
	for f in ${!osInfo[@]}
	do
		if [[ -f $f ]];then
			sudo ${osInfo[$f]} git
		fi
	done
	
	echo "Git has been installed."
	GIT_DETECTED="y"
fi

###########################
##  Post-Initialization  ##
###########################

printf '\033]2;Wrapper: Offline Installer\a'
clear

echo ''
echo 'Wrapper: Offline Installer'
echo 'A project from VisualPlugin adapted by the Wrapper: Offline team'
echo ''
echo 'Enter 1 to install from the main branch'
echo 'Enter 2 to install from the beta branch'
echo 'Enter 0 to close the installer'
echo 'Default: close the installer'

###############
##  Choices  ##
###############

read Choice
if [ $Choice = '0' ] 
then 
	read unused
	exit
elif [ $Choice = '1' ] 
then
	clear
	echo 'Cloning repository from GitHub...'
	git clone https://github.com/Wrapper-Offline/Wrapper-Offline.git
	clear
	echo 'Wrapper: Offline has been installed! Feel free to move it wherever you want.'
	xdg-open ./Wrapper-Offline
elif [ $Choice = '2' ] 
then
	clear
	echo 'Cloning repository from GitHub...'
	git clone --single-branch --branch beta https://github.com/Wrapper-Offline/Wrapper-Offline.git
	clear
	echo 'Wrapper: Offline has been installed! Feel free to move it wherever you want.'
	xdg-open ~/Wrapper-Offline
elif [ $Choice = 'shutup' ] 
then
	echo 'Nobody care and who aks'
	echo 'Who care'
else
	read unused
	exit
fi
