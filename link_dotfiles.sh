#! /bin/bash

echo "Linking dotfiles..."

rm -rf ~/.config/hypr
ln -s ~/.dotfiles/hypr ~/.config/hypr

rm -rf ~/.config/kitty
ln -s ~/.dotfiles/kitty ~/.config/kitty

rm -rf ~/.config/neofetch 
ln -s ~/.dotfiles/neofetch ~/.config/neofetch

rm -rf ~/.config/waybar 
ln -s ~/.dotfiles/waybar ~/.config/waybar

rm -rf ~/.config/sway 
ln -s ~/.dotfiles/sway ~/.config/sway

rm -rf ~/.config/rofi 
ln -s ~/.dotfiles/rofi ~/.config/

rm -rf ~/.config/wlogout 
ln -s ~/.dotfiles/wlogout ~/.config/wlogout

echo "Done!"
