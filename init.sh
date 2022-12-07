#!/usr/bin/env bash
if [ $(id -u) = 0 ]; then
    echo "[x] Script has to be executed as User!"
    exit 1
fi
    echo "[+] Script executed as $USER!"

# Black Arch Repo Sync
sudo curl -O https://blackarch.org/strap.sh
sudo echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
sudo bash strap.sh 
sudo rm -f strap.sh

# Package Sync & Init Installation
sudo pacman -Syyu --noconfirm
# Env Installation
sudo pacman -S --noconfirm --needed bspwm sxhkd lightdm lightdm-gtk-greeter lightdm-webkit2-greeter xorg-server xorg-apps xorg xf86-video-intel polybar 
# Misc1 Installation
sudo pacman -S --noconfirm --needed picom nitrogen kitty dmenu 
# Misc2 Installation
sudo pacman -S --noconfirm --needed nano neovim vim emacs htop btop tree unzip neofetch cmatrix python python-pip python-pywal noto-fonts-cjk noto-fonts-emoji noto-fonts ttf-font-awesome 

# YAY Setup
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm && cd $HOME
# YAY Init Installation
yay -S --noconfirm picom-ibhagwan-git
yay -S --noconfirm nerd-fonts-complete
# yay -S --noconfirm spotify

# Spotify Setup
# curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
# curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
# spicetify backup apply

# Lightdm Setup
sudo sed --in-place=.bak 's/^#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
sudo echo 'Section "InputClass"
    Identifier "keyboard"
    MatchIsKeyboard "yes"
    Option "XkbLayout" "de"
    Option "XkbVariant" "nodeadkeys"
EndSection' > /etc/X11/xorg.conf.d/20-keyboard.conf
sudo systemctl enable lightdm.service

# Move Dots
git clone https://www.github.com/archungus333/dots.git /tmp/dots 
cp -r /tmp/dots/configs/* $HOME/.config
cp -r /tmp/dots/wallpapers $HOME

# Exec Privs
sudo chmod +x $HOME/.config/bspwm/bspwmrc
sudo chmod +x $HOME/.config/autostart/*

# User Privs
sudo chown -R $USER:$USER /home/$USER/.config
