#!/bin/bash -x

{ echo -e "\e[30;48;5;248m⮞⮞ install update.sh ⮜⮜\e[0m"; } 2> /dev/null
sudo chown root:root  update.sh
sudo chmod +x update.sh
sudo cp update.sh /bin/raspi-update

{ echo -e "\n\e[30;48;5;248m⮞⮞ install motd.sh ⮜⮜\e[0m"; } 2> /dev/null
sudo chown root:root motd.sh
sudo chmod +x motd.sh
sudo rm /etc/motd
sudo cp motd.sh ~/.profile
sudo cp motd.sh /etc/profile.d/
sudo sed -i -e 's/PrintMotd yes/PrintMotd no/g' /etc/ssh/sshd_config
sudo sed -i -e 's/#PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo systemctl restart ssh
