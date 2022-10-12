#!/usr/bin/env bash

# Username Input
echo "[Make sure init.sh is executed as user & located in $home/dots!]"
read -p "[Enter Username]: " user

# Black Arch Repo Sync
sudo curl -O https://blackarch.org/strap.sh
sudo echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
sudo chmod +x strap.sh && ./strap.sh 
sudo rm -f strap.sh

# Package Sync & Init Installation
sudo pacman -Syyu --noconfirm
# Env Installation
sudo pacman -S --noconfirm --needed bspwm sxhkd polybar picom nitrogen kitty lightdm lightdm-gtk-greeter dmenu xorg xorg-utils xorg-drivers xorg-apps
# Misc Installation
sudo pacman -S --noconfirm --needed nano neovim vim htop tree neofetch cmatrix python python-pip python-pywal noto-fonts-cjk noto-fonts-emoji noto-fonts ttf-font-awesome 

# Lightdm Keyboard layout
sudo echo 'Section "InputClass"
    Identifier "keyboard"
    MatchIsKeyboard "yes"
    Option "XkbLayout" "de"
    Option "XkbVariant" "nodeadkeys"
EndSection' > /etc/X11/xorg.conf.d/20-keyboard.conf

# Systemd Symlinks
sudo systemctl enable lightdm.service

# User Privs
sudo chown -Rv $user:$user /home/$user

# Move Configs
cp -r configs/* $HOME/.config
cp -r wallpapers $HOME

# Exec Privs
sudo chmod +x $HOME/.config/bspwmrc
sudo chmod +x $HOME/.config/autostart/*

# YAY
git clone https://aur.archlinux.org/yay.git /opt
cd /opt/yay && makepkg -si --noconfirm && cd $HOME && rm -rf /opt/yay

# Init YAY Installs
yay -S picom-ibhagwan-git
yay -S nerd-fonts-complete

# Spotify
yay -S --noconfirm spotify spicetify-cli
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
sudo chmod +x /opt/spotify
sudo chmod +x /opt/spotify/Apps -R
spicetify backup apply
