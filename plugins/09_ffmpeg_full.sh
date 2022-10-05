#!/bin/sh
# install ffmpeg-full-git with nvidia-sdk

pacman -Sy --noconfirm --needed cuda cuda-tools
# download nvidia codec from https://developer.nvidia.com/nvidia-video-codec-sdk/
opt2=$(whiptail --title "Installing nvidia-sdk" --inputbox \
"You need to manually download the SDK from https://developer.nvidia.com/nvidia-video-codec-sdk Then provide here the absolute path to the file:"\
20 90 --cancel-button "skip nvidia-sdk installation" 3>&1 1>&2 2>&3)
if [ $? -ne 1 ] && [ -f $opt2 ]; then
    # waring to file does not exist
    sudo -u "$user" yay -S --noconfirm nvidia-sdk
    cp $opt2 "/home/$user/.cache/yay/nvidia-sdk/" || echo "failed to copy file from $opt2 to nvdia-sdk"
    chown -R "$user" /home/$user/.cache/yay/nvidia-sdk/
    cd $home/.cache/yay/nvidia-sdk; sudo -u $user makepkg -si; cd -
    sudo modprobe nvidia_uvm
fi
export PATH=$PATH:/opt/cuda/bin
sudo -u "$user" yay -S ffmpeg-full-git