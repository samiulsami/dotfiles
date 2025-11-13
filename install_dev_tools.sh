#!/usr/bin/env bash

# Install development tools (language servers, debuggers, etc.)

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Requires sudo privileges for installing some development tools"
source "$SCRIPT_DIR/utils.sh"

if [ -z "$XDG_CONFIG_HOME" ] || [ -z "$XDG_DATA_HOME" ]; then
  echo "XDG_CONFIG_HOME and/or XDG_DATA_HOME not set."
  exit 1
fi

echo "[$(date '+%H:%M:%S')] ==> Installing development tools..."

# Java LSP (Eclipse JDTLS)
echo "[$(date '+%H:%M:%S')] ==> Downloading Eclipse JDTLS..."

download_eclipse_jdtls() {
  rm -f "$XDG_DATA_HOME/tmp_jdtls.tar.gz"
  wget --retry-connrefused --waitretry=1 --timeout=20 -t 3 \
    https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz -O "$XDG_DATA_HOME/tmp_jdtls.tar.gz"
  rm -rf "$XDG_DATA_HOME/eclipse_jdtls"
  mkdir -p "$XDG_DATA_HOME/eclipse_jdtls"
  tar -xzf "$XDG_DATA_HOME/tmp_jdtls.tar.gz" -C "$XDG_DATA_HOME/eclipse_jdtls"
  rm -f "$XDG_DATA_HOME/tmp_jdtls.tar.gz"
}
run_async download_eclipse_jdtls

# Go tools
echo "[$(date '+%H:%M:%S')] ==> Installing Go tools..."
run_async go install golang.org/x/tools/gopls@latest

# Claude Code CLI
echo "[$(date '+%H:%M:%S')] ==> Installing Claude Code..."
install_claude_code() {
  curl -fsSL https://claude.ai/install.sh | bash
}
run_async install_claude_code

# Build Neovim from source
echo "[$(date '+%H:%M:%S')] ==> Cloning Neovim repository..."
retry_git_clone --depth 1 https://github.com/neovim/neovim.git "$XDG_DATA_HOME/neovim"
cd "$XDG_DATA_HOME/neovim" || exit 1

echo "[$(date '+%H:%M:%S')] ==> Building Neovim from source..."
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd "$DOTFILES_DIR"
sudo rm -rf "$XDG_DATA_HOME/neovim"

wait_err
echo "[$(date '+%H:%M:%S')] ==> Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

echo ""
echo "[$(date '+%H:%M:%S')] ==> Development tools installation complete!"
