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

echo "Done!"
