#!/usr/bin/env bash

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Requires sudo privileges for setting up the environment"
source "$SCRIPT_DIR/utils.sh"

echo "[$(date '+%H:%M:%S')] ==> Dotfiles directory detected at $DOTFILES_DIR"
echo "[$(date '+%H:%M:%S')] ==> Using XDG_CONFIG_HOME at $XDG_CONFIG_HOME"
echo "[$(date '+%H:%M:%S')] ==> Using ZDOTDIR at $ZDOTDIR"

# create directories
echo "[$(date '+%H:%M:%S')] ==> Creating configuration directories..."
mkdir -p "$XDG_CONFIG_HOME"/{rofi,picom,dunst,i3,ghostty,opencode,tmux} "$ZDOTDIR" "$XDG_CONFIG_HOME/tmux/plugins/" "$HOME/go"

echo "[$(date '+%H:%M:%S')] ==> Configuring git email addresses..."
echo ""
echo "Personal email will be used for all directories except for $HOME/work/ and its subdirectories."
echo "Work email will be used for $HOME/work/ and its subdirectories."
read -rp "Enter your personal email address: " PERSONAL_EMAIL
read -rp "Enter your work email address: " WORK_EMAIL

rm -f "$HOME/.gitconfig" "$HOME/.gitconfig-work"
cp "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
cp "$DOTFILES_DIR/git/.gitconfig-work" "$HOME/.gitconfig-work"

sed -i "s/email = .*/email = $PERSONAL_EMAIL/" "$HOME/.gitconfig"
sed -i "s/email = .*/email = $WORK_EMAIL/" "$HOME/.gitconfig-work"

echo "[$(date '+%H:%M:%S')] ==> Setting up symlinks for configuration files..."
# symlink config files for rofi, picom, dunst, ghostty, tmux, zsh, opencode, ideavim
ln -sf "$DOTFILES_DIR/rofi/config.rasi" "$XDG_CONFIG_HOME/rofi/config.rasi"
ln -sf "$DOTFILES_DIR/picom/picom.conf" "$XDG_CONFIG_HOME/picom/picom.conf"
ln -sf "$DOTFILES_DIR/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"
ln -sf "$DOTFILES_DIR/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$ZDOTDIR/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/zsh_functions_and_widgets" "$ZDOTDIR/zsh_functions_and_widgets"
ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" "$ZDOTDIR/p10k.zsh"
ln -sf "$DOTFILES_DIR/opencode/opencode.json" "$XDG_CONFIG_HOME/opencode/opencode.json"
ln -sf "$DOTFILES_DIR/ideavimrc/.ideavimrc" "$HOME/.ideavimrc"

# zsh plugins
echo "[$(date '+%H:%M:%S')] ==> Cloning zsh plugins..."
run_async retry_git_clone --depth 1 https://github.com/jeffreytse/zsh-vi-mode.git "$ZDOTDIR/zsh-vi-mode"
run_async retry_git_clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZDOTDIR/zsh-autosuggestions"
run_async retry_git_clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZDOTDIR/zsh-syntax-highlighting"
run_async retry_git_clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$ZDOTDIR/powerlevel10k"
run_async retry_git_clone --depth 1 https://github.com/Aloxaf/fzf-tab.git "$ZDOTDIR/fzf-tab"
run_async retry_git_clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$ZDOTDIR/zsh-completions"
wait_err

# tmux plugins
echo "[$(date '+%H:%M:%S')] ==> Cloning tmux plugins..."
retry_git_clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect "$XDG_CONFIG_HOME/tmux/plugins/tmux-resurrect"
tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"
# set proper monitor names in i3wm config

echo "[$(date '+%H:%M:%S')] ==> Configuring i3wm monitors..."
sed -i "s|^set \$monitor2 .*|set \$monitor2 $(xrandr | grep ' connected primary' | awk '{print $1}')|" "$DOTFILES_DIR/i3wm/config"
sed -i "s|^set \$monitor1 .*|set \$monitor1 $(xrandr | grep ' connected' | grep -v ' connected primary ' | awk '{print $1}')|" "$DOTFILES_DIR/i3wm/config"

# i3wm config
echo "[$(date '+%H:%M:%S')] ==> Setting up i3wm configuration..."
ln -sf "$DOTFILES_DIR/i3wm/config" "$XDG_CONFIG_HOME/i3/config"

echo "[$(date '+%H:%M:%S')] ==> Downloading Neovim configuration..."
retry_git_clone https://github.com/samiulsami/nvimconfig.git "$XDG_CONFIG_HOME/nvim"

echo "[$(date '+%H:%M:%S')] ==> Configuring Docker..."
sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker
sudo systemctl start docker

echo ""

echo "[$(date '+%H:%M:%S')] ==> Installation complete!"
echo "Please reboot for all changes to take effect."
