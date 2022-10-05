#!/bin/sh
# setting fish as default shell
sudo -u "$user" chsh -s /usr/bin/fish
echo /usr/bin/fish | tee -a /etc/shells
fish -c "set -U fish_user_paths $home/scripts"

# oh-my-fish setup
pacman -Q | grep -q fish || printf "fish is not installed, installing\n" && pacman -Sy --noconfirm fish
whiptail --title "oh-my-fish" --msgbox "exit from fish shell to return to the postinstallation script" 24 60 3>&1 1>&2 2>&3
sudo -u "$user" sh -c "curl -L 'https://get.oh-my.fish' > install"
chmod +x install
sudo -u "$user" termite -e "fish install --path=~/.local/share/omf --config=~/.config/omf"
rm install
sudo -u $user fish -c "omf install aight"

