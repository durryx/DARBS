
# l.a.s. by Durryx

checkinternet(){
    # check if connection can be established
	wget -q --spider 'https://google.com'
	pacman -S --noconfirm libnewt
	if [ $? -ne 0 ]; then
		whiptail --title "No internet connection" --ok-button "exit" \
		--msgbox "Internet connection is needed in order to install all packages, refer to your distro's documentation to access the network" 20 40 3>&1 1>&2 2>&3
		exit 1
	else
		printf "Internet connection available\n"
	fi
}

checkroot(){
	# check if user ID is 0 (root)
	if [[ $(id -u) != 0 ]]; then
		whiptail --title "Run as root" --ok-button "next"\
		--msgbox "Please run the script as root, the current user is $(whoami)" 20 40 3>&1 1>&2 2>&3
		exit 1
	else
		printf "Running the script as root\n"
	fi
}

selectuser(){ select x in "${userlist[@]}"; do echo "$x"; break; done; }

checkuser(){
	# get list of users from 1000 to 6000, normal users
	local userstring=$(getent passwd {1000..6000} | cut -d: -f1)
	# check if at least one normal user exists
	[ -z "$userstring" ] && printf "no normal user detected, exiting\n" && exit 1
	userlist=( $userstring )
	while true; do
		clear
		# setting prompt string
		PS3="Choose user, enter option's number: "
		echo -e "\n\t\tAvailable users\n"
		user=$(selectuser)
		[[ ! -z "$user" ]] && break
	done
	home=/home/$user
}

syntaxerr(){ printf "\e[1;31m Invalid syntax of config.yml \e[1;31m"; exit 1; }
nofile(){ printf "\e[1;31m File or directory indicated in config.yml not found \e[1;31m"; exit 1; }
noconfig(){ printf "\e[1;31m No config.yml file found \e[1;31m"; exit 1; } 
checkconfig(){
	# check if config.yml exists
	[[ ! -f config.yml ]] && noconfig  
	pacman -S --noconfirm yamllint yq base-devel sed
	# check if YAML syntax file is correct
	yamllint config.yml
	[[ $? != 0 ]] && syntaxerr
	# if you have put an odd number of paths in the files field then a paste path misses
	local var=$(yq '.files | .[]' config.yml | wc -l)
	[[ $((var % 2 )) == 0 ]] || syntaxerr	
	while IFS= read -r string; do
		 # check if file or directory indicated exists
		 [[ ! -e $string ]] && nofile
	done <<< "$(yq '.files | .[]' config.yml | sed -n 'p;n' | tr -d '"')" #'
}

message(){
	# whiptail --title "Welcome" --ok-button "next" --msgbox "Welcome to Durry's auto-ricing script!\\n\\nYour going to install a fully \
		# configured Arch system with xmonad window manager along with other software." 20 40 3>&1 1>&2 2>&3
	printf "\t\t\tWELCOME TO LINUX AUTO-RICING SCRIPT\n\texecuting now necessary internet, user, root and config checks..."
	checkinternet
	checkroot
	checkuser
	checkconfig
}

installpkg(){
	clear
	# set lists of the various packages to be installed
	local PACMAN=$(yq '.pacman' config.yml | tr -d '[],"')
	local YAY=$(yq '.yay' config.yml | tr -d '[],"')
	local PIP=$(yq '.pip' config.yml | tr -d '[],"')
	pacman -Sy --overwrite \* --needed $PACMAN
	if ! command -v yay; then
		# install yay AUR helper
		mkdir /opt/yay-git/
		git clone "https://aur.archlinux.org/yay-git.git" /opt/yay-git/
		chown -R $user:$user /opt/yay-git
		cd /opt/yay-git/; sudo -u $user "makepkg" -si --noconfirm; cd -
	fi
	sudo -u $user yay -S $YAY
	pip install $PIP
}

copy_dotfiles(){
	# copy configuration files	
	for (( c=1; c<$(yq '.files | .[]' config.yml | wc -l); c=$((c+2)) )); do
		COPY=$(yq '.files | .[]' config.yml | sed -n "$c{p;q}" | sed "s|\"||g;s|~|$home|g")
		PASTE=$(yq '.files | .[]' config.yml | sed -n "$((c+1)){p;q}" | sed "s|\"||g;s|~|$home|g")
		cp -rfbv "$COPY" "$PASTE"
	done
}

document(){
    # generating documentation from latex file	
	pdflatex -interaction nonstopmode -file-line-error -output-directory=.. dance-doc.tex
	# removes garbage outputs	
	rm -f ../dance-doc.aux ../dance-doc.log ../dance-doc.out
}

main()
{
	message

	# use all cores and ccache when compiling with makepkg
	sed -i "s-/-j2/j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/;s|!ccache|ccache|" /etc/makepkg.conf

	# run package installation
	installpkg

	# increase keys sensitivity
	# xset r rate 150 30

	# flameshot config - disable tray icon
	sudo -u "$user" flameshot config -t false

	# create config folder for yakuake
	mkdir --parents $home/.local/share/konsole

	# set ZSH as default $SHELL
	sudo -u "$user" chsh -s $(which zsh)

	# deploy dotfiles
	copy_dotfiles

	# time settings
	timedatectl set-ntp 1

	# enable sshd
	sudo systemctl enable sshd

	# autostart libinout-gestures
	usermod -aG input $user
	sudo -u "$user" libinput-gestures-setup autostart

	# xfce customization
	sudo -u "$user" xfconf-query -c xfwm4 -p /general/use_compositing -s false
	xfconf-query -c xfce4-notifyd -p /applications/muted_applications -n -t bool -s true
	xfconf-query -c xfce4-session -p /general/SaveOnExit -s false
	# see this https://forum.xfce.org/viewtopic.php?id=8485 recopy xfce folder

	# execute shell scripts faster with dash
	ln -sf /bin/sh /bin/dash

	# enable icons for ranger
	git clone "https://github.com/alexanderjeurissen/ranger_devicons" $home/.config/ranger/plugins/ranger_devicons
	echo "default_linemode devicons" >> $home/.config/ranger/rc.conf
	chmod -R u+rw $home
	chown -R $user:$user $home

	# themes
	kvantummanager --set Fluent-greenDark
	xfconf-query -c xsettings -p /Net/ThemeName -s "Flat-Remix-GTK-Teal-Dark"
	kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme adwaita_cursors
	gsettings set org.gnome.desktop.interface icon-theme 'Tela'

	# use vim as man pager
	export MANPAGER="vim -M +MANPAGER - "

	# enable lightdm as display manager, cups for printers
	systemctl enable sddm
	systemctl enable cups

	# patch dmenu to make it display emoji
	sudo -u "$user" yay -S libxft-bgra-git

	# remove loud beep sound
	rmmod pcspkr
	echo "blacklist pcspkr" | tee /etc/modprobe.d/nobeep.conf

	# execute plugins
	declare -a plugin_list
	for file in plugins/*
	do
		plugin_list=( ${plugin_list[*]} "$file" "_" OFF )
	done
	choices=$(whiptail --title "Select Plugins" --separate-output --checklist "Choose options" 10 45 5 "${plugin_list[@]}" 3>&1 1>&2 2>&3)
	for command in "${choices[@]}"
	do
		sudo -u $user sh -c "$command"
	done
}

# run script with "sudo script -c install.sh -O logfile.txt"
main 

exiting=$(whiptail --title "Installation ended" --menu "Everything has been set up correctly.\\n-Durry" 15 50 4 \
	"1" "exit" "2" "reboot"	3>&1 1>&2 2>&3)
[[ $exiting == "2" ]] && reboot
