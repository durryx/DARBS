#!/bin/sh

# load nvidia modules
sudo modprobe nvidia_uvm
sudo modprobe nvidia_drm

# workaround to activate wifi after suspension in MSI laptops
sudo sed -i $'s@GRUB_CMDLINE_LINUX_DEFAULT=.*@GRUB_CMDLINE_LINUX_DEFAULT="acpi_osi=! acpi_osi=\'Windows 2009\' quiet splash intel_pstate=disable"@' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo update-grub
sudo sed -i 's@HandleSuspendKey.*@HandleSuspendKey=hibernate@;s@HandleLidSwitch.*@HandleLidSwitch=hibernate@' /etc/systemd/logind.conf

# improve battery life
sudo systemctl enable intel-undervolt
sudo systemctl enable auto-cpufreq
