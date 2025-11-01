# dotfiles

**Core**
- <b>WM</b>: i3wm
- <b>Terminal</b>: ghostty
- <b>Shell</b>: zsh + tmux
- <b>Editor</b>: Neovim

**Desktop**
- <b>Launcher</b>: rofi
- <b>Compositor</b>: picom
- <b>Notifications</b>: dunst
- <b>Screenshots</b>: flameshot
- <b>Files</b>: thunar

**System**
- <b>Audio</b>: pavucontrol
- <b>Bluetooth</b>: blueman
- <b>Network</b>: iwd
- <b>VPN</b>: Cloudflare Warp

**Utilities**
- fzf, fd, bat, ripgrep, zoxide, lsd, etc.

## Package Installation

### pacman and yay
```bash
set -euo pipefail

sudo pacman -Syu --disable-download-timeout \
  base-devel git curl lsd wget zsh tmux fd bat ripgrep zoxide npm \
  libnotify obs-studio rofi picom dunst i3 pavucontrol \
  blueman flameshot brightnessctl thunar thunar-volman \
  gvfs ghostty docker jdk-openjdk maven go golangci-lint rustup \
  kubectl helm cmake gettext unzip xclip nvme-cli \
  texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended

git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd && rm -rf /tmp/yay

yay -S --noconfirm --needed --removemake --cleanafter cloudflare-warp-bin kind-bin opencode-bin
sudo warp-cli registration new
```

## Environment Setup
### config files, plugins, and tools
<i>Unattended installation after providing sudo password and email(s)</i>
```bash
chsh -s $(readlink -f $(which zsh))
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
cat "$HOME/.ssh/id_ed25519.pub" | xclip -selection clipboard
printf "Public key copied. Add it to https://github.com/settings/ssh/new\n(Press enter to open)..."
read
xdg-open https://github.com/settings/ssh/new
```

### restore zsh-shell history (private repo)
```bash
source $HOME/.zshrc
set -euo pipefail
sudo -k

git clone --depth 1 git@github.com:samiulsami/shell-history-backup.git
cp shell-history-backup/.zsh_history "$ZDOTDIR/zsh_history"
rm -rf shell-history-backup
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
