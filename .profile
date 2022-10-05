#!/bin/sh
# make default editor Neovim
export EDITOR=nvim

# visual editor
export SVN_EDITOR=code

# GTK
export GTK_CSD=0

# qt wayland
export QT_QPA_PLATFORM="xcb"
export QT_QPA_PLATFORMTHEME=qt5ct

# set default shell and terminal
export SHELL=/usr/bin/zsh

# qt style
export QT_STYLE_OVERRIDE=kvantum

# adding folders to PATH 
export PATH="$PATH:/opt/cuda/bin/"

#export TERMINAL_COMMAND=/usr/share/sway/scripts/foot.sh

