#!/usr/bin/env bash

set -euo pipefail

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

setup_opencode() {
	local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
	echo "[$(date '+%H:%M:%S')] ==> Setting up OpenCode configuration..."
	mkdir -p "$config_dir/commands"
	for file in AGENTS.md opencode.json cli.json opencode-notifier.json; do
		ln -sfnT "$SCRIPT_DIR/opencode/$file" "$config_dir/$file"
	done
	ln -sfnT "$SCRIPT_DIR/opencode/agents" "$config_dir/agents"
	ln -sfnT "$SCRIPT_DIR/opencode/skills" "$config_dir/skills"
	ln -sfnT "$SCRIPT_DIR/opencode/commands/research.md" "$config_dir/commands/research.md"
	if [[ -L "$config_dir/tui.json" && $(readlink "$config_dir/tui.json") == "$SCRIPT_DIR/opencode/tui.json" ]]; then
		rm "$config_dir/tui.json"
	fi
}

if [[ ${1:-} == --opencode-only ]]; then
	setup_opencode
	echo "Quit and restart OpenCode to load the configuration."
	exit 0
fi

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
mkdir -p "$XDG_CONFIG_HOME"/{tmux,environment.d} \
	"$ZDOTDIR" \
	"$XDG_CONFIG_HOME/tmux/plugins/" \
	"$HOME/go" \
	"$HOME/.gemini/policies"

EXISTING_GLOBAL_GIT_EMAIL=$(git config --global --get user.email || true)
if [ -n "$EXISTING_GLOBAL_GIT_EMAIL" ]; then
	echo "[$(date '+%H:%M:%S')] ==> Global git email already set to '$EXISTING_GLOBAL_GIT_EMAIL'. Skipping git email setup."
else
	echo "[$(date '+%H:%M:%S')] ==> Configuring git email addresses..."
	echo ""
	echo "Personal email will be used for all directories except for $HOME/work/ and its subdirectories."
	echo "Work email will be used for $HOME/work/ and its subdirectories."
	echo "LEAVE EMPTY TO SKIP GIT CONFIGURATION."

	read -rp "Enter your personal email address: " PERSONAL_EMAIL
	read -rp "Enter your work email address: " WORK_EMAIL

	if [ -n "$PERSONAL_EMAIL" ] && [ -z "$WORK_EMAIL" ]; then
		WORK_EMAIL="$PERSONAL_EMAIL"
	fi

	if [ -n "$PERSONAL_EMAIL" ]; then
		rm -f "$HOME/.gitconfig"
		cp "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
		sed -i "s/email = .*/email = $PERSONAL_EMAIL/" "$HOME/.gitconfig"
	fi

	if [ -n "$WORK_EMAIL" ]; then
		rm -f "$HOME/.gitconfig-work"
		cp "$DOTFILES_DIR/git/.gitconfig-work" "$HOME/.gitconfig-work"
		sed -i "s/email = .*/email = $WORK_EMAIL/" "$HOME/.gitconfig-work"
	fi
fi

echo "[$(date '+%H:%M:%S')] ==> Setting system-wide ZDOTDIR for Termux..."
echo "export ZDOTDIR=\"\$HOME${ZDOTDIR#"$HOME"}\"" >"$PREFIX/etc/zshenv"

echo "[$(date '+%H:%M:%S')] ==> Setting up symlinks for configuration files..."
ln -sf "$DOTFILES_DIR/environment.d/xdg.conf" "$XDG_CONFIG_HOME/environment.d/xdg.conf"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$ZDOTDIR/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/zsh_functions" "$ZDOTDIR/zsh_functions"
ln -sf "$DOTFILES_DIR/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
ln -sf "$DOTFILES_DIR/gemini/settings.json" "$HOME/.gemini/settings.json"
ln -sf "$DOTFILES_DIR/gemini/gemini-rules.toml" "$HOME/.gemini/policies/gemini-rules.toml"
setup_opencode

echo "[$(date '+%H:%M:%S')] ==> Cloning zsh plugins..."
run_async "clone zsh-autosuggestions" git_clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZDOTDIR/zsh-autosuggestions"
run_async "clone zsh-syntax-highlighting" git_clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZDOTDIR/zsh-syntax-highlighting"
run_async "clone fzf-tab" git_clone --depth 1 https://github.com/Aloxaf/fzf-tab.git "$ZDOTDIR/fzf-tab"
run_async "clone zsh-completions" git_clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$ZDOTDIR/zsh-completions"

echo "[$(date '+%H:%M:%S')] ==> Cloning tmux plugins..."
run_async "clone tmux-resurrect" git_clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect "$XDG_CONFIG_HOME/tmux/plugins/tmux-resurrect"

echo "[$(date '+%H:%M:%S')] ==> Downloading Neovim configuration..."
run_async "clone nvim config" git_clone https://github.com/samiulsami/nvim.git "$XDG_CONFIG_HOME/nvim"

wait_all
pidof tmux && tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"

echo

echo "[$(date '+%H:%M:%S')] ==> Installation complete!"
echo "Please restart Termux for all changes to take effect."
