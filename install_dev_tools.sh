#!/usr/bin/env bash

# Install development tools

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/check_requirements.sh"
source "$SCRIPT_DIR/utils.sh"

if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ]; then
	echo "XDG_CONFIG_HOME and/or XDG_DATA_HOME not set."
	exit 1
fi

echo "[$(date '+%H:%M:%S')] ==> Setting up Arch Linux Proot for opencode-ai..."
if ! proot-distro list | grep -q "archlinux.*installed"; then
	proot-distro install archlinux
fi

if ! proot-distro login archlinux -- which opencode >/dev/null 2>&1; then
	proot-distro login archlinux -- bash -c "rm -f /var/lib/pacman/db.lck && pacman -Syu --noconfirm nodejs npm && npm install -g opencode-ai"
fi

echo "[$(date '+%H:%M:%S')] ==> Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

echo ""
echo "[$(date '+%H:%M:%S')] ==> Development tools installation complete!"
