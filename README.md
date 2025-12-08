# dotfiles

**Core**
- <b>Display Manager</b>: gdm
- <b>Window Manager</b>: hyprland
- <b>Desktop Environment</b>: gnome
- <b>Terminal</b>: ghostty
- <b>Shell</b>: zsh + tmux
- <b>Editor</b>: Neovim

**Desktop**
- <b>Launcher</b>: wofi
- <b>Notifications</b>: dunst
- <b>Screenshots</b>: flameshot
- <b>Files</b>: nautilus

**System**
- <b>Audio</b>: pavucontrol
- <b>Bluetooth</b>: bluez
- <b>Network</b>: NetworkManager
- <b>VPN</b>: Cloudflare Warp

**Utilities**
- fzf, fd, bat, ripgrep, zoxide, lsd, etc.

## Package Installation

### pacman and yay
```bash
set -euo pipefail

sudo pacman -Syu --disable-download-timeout --needed \
  base-devel git curl lsd wget fzf zsh starship tmux fd bat ripgrep zoxide npm \
  libnotify imv obs-studio wofi dunst pipewire wireplumber pavucontrol \
  gdm gnome-shell gnome-system-monitor gnome-shell-extension-dash-to-panel gnome-keyring gnome-control-center nautilus networkmanager \
  hyprland hyprpaper hypridle hyprlock hyprpolkitagent waybar grim slurp swappy wl-clipboard xdg-desktop-portal-wlr\
  bluez bluez-utils brightnessctl ttf-jetbrains-mono-nerd \
  gvfs ghostty docker docker-buildx jdk-openjdk maven go gopls golangci-lint gofumpt rustup clang \
  kubectl helm cmake gettext unzip nvme-cli \
  texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended \
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
  stylua lua-language-server bash-language-server shellcheck shfmt \
  terraform tflint jq tree-sitter-cli yaml-language-server

sudo systemctl enable gdm

git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd && rm -rf /tmp/yay

yay -S --noconfirm --needed --removemake --cleanafter cloudflare-warp-bin kind-bin opencode-bin coursier
sudo warp-cli registration new
sudo systemctl disable warp-svc.service
coursier setup --env
coursier install metals
```

## Environment Setup
### config files, plugins, and tools
<i>Unattended installation after providing sudo password and email(s)</i>
```bash
chmod +x ./setup_env.sh ./install_dev_tools.sh
./setup_env.sh
./install_dev_tools.sh
```

### ssh keys
```bash
set -euo pipefail
EMAIL=$(git config user.email)
ssh-keygen -t ed25519 -C "$EMAIL"  # Press enter 3 times
eval "$(ssh-agent -s)" && ssh-add $HOME/.ssh/id_ed25519
wl-copy < "$HOME/.ssh/id_ed25519.pub"
printf "Public key copied. Add it to https://github.com/settings/ssh/new\n(Press enter to open)..."
read
xdg-open https://github.com/settings/ssh/new
```

### restore zsh-shell history (private repo)
```bash
git clone --depth 1 git@github.com:samiulsami/shell-history-backup.git
cp shell-history-backup/.zsh_history "$ZDOTDIR/zsh_history"
```

## Additional Notes

For additional configuration and troubleshooting guides, see the [notes/](notes/) directory:
- [Storage configuration](notes/storage/)
- [Hardware configuration](notes/hardware/)
- [System configuration](notes/system/)

## TODO

- [ ] NOT automate this with ansible/stow/chezmoi/etc.
- [ ] Add support for Debian based distros.
- [ ] Consider wrapping the ```notes``` directory using Obsidian.

### References
- [https://github.com/sysdevbd/sysdevbd.github.io/tree/master](https://github.com/sysdevbd/sysdevbd.github.io/tree/master)
