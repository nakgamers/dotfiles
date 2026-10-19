#!/bin/bash
set -e
D="$(cd "$(dirname "$0")" && pwd)"
echo "=== 1/7 Packages ==="
sudo apt update && sudo apt install -y kitty conky-all fonts-jetbrains-mono ffmpeg chafa gnome-shell-extension-manager gnome-tweaks papirus-icon-theme curl wget git
echo "=== 2/7 Fastfetch ==="
cd /tmp && wget -q https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb && sudo apt install -y ./fastfetch-linux-amd64.deb
echo "=== 3/7 Starship ==="
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo "=== 4/7 Colloid theme ==="
[ -d /tmp/Colloid-gtk-theme ] || git clone --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme.git /tmp/Colloid-gtk-theme
cd /tmp/Colloid-gtk-theme && ./install.sh -c dark -t grey --tweaks dracula
echo "=== 5/7 Configs ==="
mkdir -p ~/.config ~/.local/share/backgrounds ~/.local/share/gnome-shell/extensions
cp -r $D/configs/kitty ~/.config/ && cp $D/configs/starship.toml ~/.config/
cp -r $D/configs/fastfetch ~/.config/ && cp -r $D/configs/conky ~/.config/
cp -r $D/configs/autostart ~/.config/ && chmod +x ~/.config/fastfetch/splash.sh
cp -r $D/configs/gnome-extensions/* ~/.local/share/gnome-shell/extensions/ 2>/dev/null || true
echo "=== 6/7 Wallpaper + GNOME ==="
cp $D/configs/wallpaper.webp ~/.local/share/backgrounds/
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/backgrounds/wallpaper.webp"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.local/share/backgrounds/wallpaper.webp"
dconf load /org/gnome/desktop/ < $D/gnome/gnome-desktop.dconf
dconf load /org/gnome/shell/ < $D/gnome/gnome-shell.dconf
echo "=== 7/7 Bashrc ==="
grep -q "splash.sh" ~/.bashrc || cat $D/configs/bashrc-additions.txt >> ~/.bashrc
echo "=== 8/8 Keybinding Ctrl+Alt+T ==="
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Kitty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'kitty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Primary><Alt>t'
echo "Selesai! Restart untuk efek penuh."
