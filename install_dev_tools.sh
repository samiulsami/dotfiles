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

# Java LSP (Eclipse JDTLS). ref: https://github.com/mfussenegger/nvim-jdtls
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

# Scala LSP (Metals via Coursier). ref: https://get-coursier.io/docs/cli-installation
echo "[$(date '+%H:%M:%S')] ==> Installing Metals (Scala LSP) via Coursier..."
download_coursier() {
  curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > /tmp/cs
  chmod +x /tmp/cs
  yes | /tmp/cs setup
  /tmp/cs install metals
  rm /tmp/cs
}
run_async download_coursier

# Go tools
echo "[$(date '+%H:%M:%S')] ==> Installing Go tools..."
run_async go install golang.org/x/tools/gopls@latest

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
