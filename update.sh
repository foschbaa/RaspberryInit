#!/bin/bash -x

# Update all packages of operating system to latest.
# It will also update the Static Motd File [20-update]
# for displaying upgradeable package count at startup

{ echo -e "\e[30;48;5;248m⮞⮞ Update Packages ⮜⮜\e[0m"; } 2> /dev/null
sudo apt update -y

{ echo -e "\n\e[30;48;5;248m⮞⮞ Full Upgrade Packages ⮜⮜\e[0m"; } 2> /dev/null
sudo apt full-upgrade -y

{ echo -e "\n\e[30;48;5;248m⮞⮞ Remove Dependency Packages That Are No Longer Needed ⮜⮜\e[0m"; } 2> /dev/null
sudo apt --purge autoremove

{ echo -e "\n\e[30;48;5;248m⮞⮞ Clean apt Cache ⮜⮜\e[0m"; } 2> /dev/null
sudo apt clean

