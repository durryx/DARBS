#!/bin/bash

read -p "Press enter to install C++ related tools, ctrl-c to cancel" x

sudo pacman -Syu --noconfirm --needed gcc git python-pip cppcheck clang ccache vscode cmake ninja vscode jq moreutils make gdb
pip install --user conan

code --install-extension ms-vscode.cpptools-extension-pack --install-extension jeff-hykin.better-cpp-syntax --install-extension eamodio.gitlens --install-extension jdinhlife.gruvbox --install-extension xaver.clang-format --install-extension asvetliakov.vscode-neovim --install-extension slevesque.shader --install-extension stevensona.shader-toy --install-extension EliverLara.andromeda --install-extension SreetamD.karma --install-extension twxs.cmake --install-extension ms-vscode.cmake-tools --install-extension MatthewEvers.compiler-explorer --install-extension ecmel.vscode-html-css --install-extension astro-build.astro-vscode --install-extension redhat.vscode-yaml  --install-extension ms-toolsai.jupyter --install-extension justusadam.language-haskell --install-extension QiuMingGe.cpp-check-lint --install-extension matthew-jin.infersharp-ext --install-extension notskm.clang-tidy --install-extension xaver.clang-format

test -f ~/.config/Code\ -\ OSS/User/settings.json && jq -r '."terminal.integrated.minimumContrastRatio" |= 1' ~/.config/Code\ -\ OSS/User/settings.json | sponge ~/.config/Code\ -\ OSS/User/settings.json || echo "{ \"terminal.integrated.minimumContrastRatio\": 1 }" > ~/.config/Code\ -\ OSS/User/settings.json
