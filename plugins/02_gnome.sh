#/bin/sh

gnome_setup(){
	# natural scrolling
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
	# tap to click
	gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
	# volume above 100
	gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
	# themes
	gsettings set org.gnome.desktop.interface gtk-theme Matcha-azul
	gsettings set org.gnome.desktop.interface icon-theme Surfn-Arch-Blue
	# enable extensions
	gsettings set org.gnome.shell disable-user-extensions false
	gnome-extensions enable pop-shell@system76.com
	gnome-extensions enable workspace-indicator@gnome-shell-extensions.gcampax.github.com
	gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com
	gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
	
	#paru gnome-shell-extension-sound-output-device-chooser gnome-shell-extension-appindicator gnome-shell-extension-lockkeys-git
	#see https://itsfoss.com/fix-right-click-touchpad-ubuntu/ for gnome tweak tools	
	# pass shortscuts 	TODO
}

