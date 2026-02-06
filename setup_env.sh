#!/usr/bin/env bash

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Requires sudo privileges for setting up the environment"
source "$SCRIPT_DIR/utils.sh"

if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ]; then
        echo "XDG_CONFIG_HOME and/or XDG_DATA_HOME not set."
        exit 1
fi

echo "[$(date '+%H:%M:%S')] ==> Dotfiles directory detected at $DOTFILES_DIR"
echo "[$(date '+%H:%M:%S')] ==> Using XDG_CONFIG_HOME at $XDG_CONFIG_HOME"
echo "[$(date '+%H:%M:%S')] ==> Using ZDOTDIR at $ZDOTDIR"

# Change shell to zsh if not already
if [ "$SHELL" != "$(readlink -f "$(which zsh)")" ]; then
        echo "[$(date '+%H:%M:%S')] ==> Setting default shell to zsh..."
        chsh -s "$(readlink -f "$(which zsh)")"
fi

echo "[$(date '+%H:%M:%S')] ==> Creating configuration directories..."
mkdir -p "$XDG_CONFIG_HOME"/{dunst,ghostty,opencode,tmux,fontconfig/conf.d,hypr,wofi,waybar,environment.d} "$ZDOTDIR" "$XDG_CONFIG_HOME/tmux/plugins/" "$HOME/go"

echo "[$(date '+%H:%M:%S')] ==> Configuring git email addresses..."
echo ""
echo "Personal email will be used for all directories except for $HOME/work/ and its subdirectories."
echo "Work email will be used for $HOME/work/ and its subdirectories."
echo "LEAVE EMPTY TO SKIP GIT CONFIGURATION."
read -rp "Enter your personal email address: " PERSONAL_EMAIL
read -rp "Enter your work email address: " WORK_EMAIL

if [ -n "$PERSONAL_EMAIL" ] && [ -n "$WORK_EMAIL" ]; then
        rm -f "$HOME/.gitconfig" "$HOME/.gitconfig-work"
        cp "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
        cp "$DOTFILES_DIR/git/.gitconfig-work" "$HOME/.gitconfig-work"

        sed -i "s/email = .*/email = $PERSONAL_EMAIL/" "$HOME/.gitconfig"
        sed -i "s/email = .*/email = $WORK_EMAIL/" "$HOME/.gitconfig-work"
fi

echo "[$(date '+%H:%M:%S')] ==> Creating ~/.zshenv for TTY support..."
echo "export ZDOTDIR=\"\$HOME${ZDOTDIR#"$HOME"}\"" >"$HOME/.zshenv"

echo "[$(date '+%H:%M:%S')] ==> Setting up symlinks for configuration files..."
ln -sf "$DOTFILES_DIR/environment.d/xdg.conf" "$XDG_CONFIG_HOME/environment.d/xdg.conf"
ln -sf "$DOTFILES_DIR/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"
ln -sf "$DOTFILES_DIR/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$ZDOTDIR/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/zsh_functions" "$ZDOTDIR/zsh_functions"
ln -sf "$DOTFILES_DIR/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
ln -sf "$DOTFILES_DIR/opencode/opencode.json" "$XDG_CONFIG_HOME/opencode/opencode.json"
ln -sf "$DOTFILES_DIR/opencode/AGENTS.md" "$XDG_CONFIG_HOME/opencode/AGENTS.md"
ln -sf "$DOTFILES_DIR/ideavimrc/.ideavimrc" "$HOME/.ideavimrc"
ln -sf "$DOTFILES_DIR/fontconfig/01-emoji.conf" "$XDG_CONFIG_HOME/fontconfig/conf.d/01-emoji.conf"

echo "[$(date '+%H:%M:%S')] ==> Cloning zsh plugins..."
run_async retry_git_clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZDOTDIR/zsh-autosuggestions"
run_async retry_git_clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZDOTDIR/zsh-syntax-highlighting"
run_async retry_git_clone --depth 1 https://github.com/Aloxaf/fzf-tab.git "$ZDOTDIR/fzf-tab"
run_async retry_git_clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$ZDOTDIR/zsh-completions"

echo "[$(date '+%H:%M:%S')] ==> Cloning tmux plugins..."
run_async retry_git_clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect "$XDG_CONFIG_HOME/tmux/plugins/tmux-resurrect"

echo "[$(date '+%H:%M:%S')] ==> Setting up Hyprland configuration..."
ln -sf "$DOTFILES_DIR/hyprland/hyprland.conf" "$XDG_CONFIG_HOME/hypr/hyprland.conf"
ln -sf "$DOTFILES_DIR/hyprland/hyprlock.conf" "$XDG_CONFIG_HOME/hypr/hyprlock.conf"
ln -sf "$DOTFILES_DIR/hyprland/hypridle.conf" "$XDG_CONFIG_HOME/hypr/hypridle.conf"
ln -sf "$DOTFILES_DIR/hyprland/hyprpaper.conf" "$XDG_CONFIG_HOME/hypr/hyprpaper.conf"
ln -sf "$DOTFILES_DIR/hyprland/border-flash.sh" "$XDG_CONFIG_HOME/hypr/border-flash.sh"
ln -sf "$DOTFILES_DIR/waybar/config" "$XDG_CONFIG_HOME/waybar/config"
ln -sf "$DOTFILES_DIR/waybar/style.css" "$XDG_CONFIG_HOME/waybar/style.css"
ln -sf "$DOTFILES_DIR/wofi/config" "$XDG_CONFIG_HOME/wofi/config"
ln -sf "$DOTFILES_DIR/wofi/style.css" "$XDG_CONFIG_HOME/wofi/style.css"

echo "[$(date '+%H:%M:%S')] ==> Downloading Neovim configuration..."
run_async retry_git_clone https://github.com/samiulsami/nvim.git "$XDG_CONFIG_HOME/nvim"

wait_err
pidof tmux && tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"

echo

echo "[$(date '+%H:%M:%S')] ==> Configuring Docker..."
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"
sudo systemctl start docker 2>/dev/null || true

echo "[$(date '+%H:%M:%S')] ==> Configuring TLP battery charge threshold..."
if command -v tlp >/dev/null 2>&1; then
        sudo mkdir -p /etc/tlp.d
        sudo cp "$DOTFILES_DIR/tlp/tlp.conf" /etc/tlp.d/01-battery.conf
        sudo systemctl daemon-reload
        sudo systemctl enable --now tlp.service
        sudo tlp start
fi

echo "[$(date '+%H:%M:%S')] ==> Configuring Sysstat (sar)..."
if command -v sar >/dev/null 2>&1; then
        sudo mkdir -p /etc/sysstat
        sudo cp "$DOTFILES_DIR/sysstat/sysstat.conf" /etc/sysstat/sysstat
        sudo cp "$DOTFILES_DIR/sysstat/sysstat-collect.timer" /etc/systemd/system/sysstat-collect.timer

        sudo systemctl daemon-reload
        sudo systemctl enable --now sysstat
        sudo systemctl enable --now sysstat-collect.timer
fi

echo "[$(date '+%H:%M:%S')] ==> Configuring Atop..."
if command -v atop >/dev/null 2>&1; then
        sudo mkdir -p /etc/default
        sudo cp "$DOTFILES_DIR/atop/atop" /etc/default/atop

        # ensure the log directory exists (atop sometimes complains)
        sudo mkdir -p /var/log/atop

        sudo systemctl daemon-reload
        sudo systemctl enable --now atop
        sudo systemctl restart atop
fi

if command -v imv >/dev/null 2>&1; then
        echo "[$(date '+%H:%M:%S')] ==> Setting imv as default image viewer..."
        xdg-mime default imv.desktop image/png image/jpeg image/jpg image/gif image/bmp image/tiff image/webp image/svg+xml image/heif image/avif image/jxl image/x-png image/pjpeg image/x-bmp image/x-farbfeld image/tiff-fx image/qoi
fi

echo ""

echo "[$(date '+%H:%M:%S')] ==> Installation complete!"
echo "Please reboot for all changes to take effect."
