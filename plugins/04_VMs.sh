#!/bin/sh
# virt-manager setup

# packages
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables iptables libguestfs ovmf

# add the user to the libvirt group
sudo usermod -a -G libvirt $USER

# change permissions
sudo sed -i '/unix_sock_group = "libvirt"/s/^#//g' /etc/libvirt/libvirtd.conf
sudo sed -i '/unix_sock_rw_perms = "0770"/s/^#//g' /etc/libvirt/libvirtd.conf

# enable nested virtualization
# echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf

