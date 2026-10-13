#!/usr/bin/env bash

set -euo pipefail

# Install development tools

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ${1:-} != --opencode-only ]]; then
	source "$SCRIPT_DIR/utils.sh"
fi

echo "[$(date '+%H:%M:%S')] ==> Installing OpenCode v2 in PRoot..."

arch_packages=(opencode nodejs npm git ripgrep fd ast-grep)
if [[ ${1:-} != --opencode-only ]]; then
	arch_packages+=(texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended)
fi

if [[ ! -d "$PREFIX/var/lib/proot-distro/containers/archlinux/rootfs" &&
	! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/archlinux" ]]; then
	proot-distro install --name archlinux https://ca.us.mirror.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
fi

proot-distro login archlinux -- bash -c '
set -euo pipefail
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syu --noconfirm --needed "$@"
opencode --version
' bash "${arch_packages[@]}"

if [[ ${1:-} == --opencode-only ]]; then
	exit 0
fi

echo "[$(date '+%H:%M:%S')] ==> Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

echo ""
echo "[$(date '+%H:%M:%S')] ==> Development tools installation complete!"
