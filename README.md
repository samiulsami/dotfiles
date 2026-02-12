# dotfiles

**Core**
- <b>Display Manager</b>: gdm
- <b>Window Manager</b>: hyprland
- <b>Desktop Environment</b>: gnome
- <b>Terminal</b>: ghostty
- <b>Shell</b>: zsh + tmux
- <b>Editor</b>: neovim

**Desktop**
- <b>Launcher</b>: wofi
- <b>Notifications</b>: dunst
- <b>Screenshots</b>: grim + slurp + swappy/satty
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

shell=(zsh starship tmux ghostty fzf fd bat ripgrep zoxide lsd tealdeer ouch jq socat)
hypr=(hyprland hyprpaper hypridle hyprlock hyprpolkitagent waybar wofi dunst libnotify grim slurp swappy satty wl-clipboard cliphist xdg-desktop-portal-wlr)
gnome=(gdm gnome-shell gnome-control-center gnome-keyring gnome-shell-extension-dash-to-panel nautilus gvfs)
system=(pipewire wireplumber pavucontrol bluez bluez-utils networkmanager brightnessctl tlp nvme-cli)
apps=(atop btop systat imv obs-studio zathura zathura-pdf-mupdf)
dev=(base-devel git curl wget npm cmake gettext docker docker-buildx kubectl helm terraform tree-sitter-cli aws-cli-v2 eksctl)
lang=(go jdk-openjdk maven rustup clang)
lsp=(gopls bash-language-server yaml-language-server)
linter=(golangci-lint shellcheck tflint)
formatter=(gofumpt stylua shfmt)
fonts=(ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra)
tex=(texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended)

sudo pacman -Syu --disable-download-timeout --needed ${shell[@]} ${hypr[@]} ${gnome[@]} ${system[@]} ${apps[@]} ${dev[@]} ${lang[@]} ${lsp[@]} ${linter[@]} ${formatter[@]} ${fonts[@]} ${tex[@]}

sudo systemctl enable gdm

git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd - && rm -rf /tmp/yay

yay -S --noconfirm --needed --removemake --cleanafter google-chrome cloudflare-warp-bin kind-bin coursier
sudo warp-cli registration new
sudo systemctl disable warp-svc.service
coursier setup --env
coursier install metals

curl -fsSL https://opencode.ai/install | bash
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
ed25519 (preferred)
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
rsa (legacy)
```bash
EMAIL=$(git config user.email)
ssh-keygen -t rsa -b 4096 -C "$EMAIL"  # Press enter 3 times
eval "$(ssh-agent -s)" && ssh-add $HOME/.ssh/id_rsa
wl-copy < "$HOME/.ssh/id_rsa.pub"
printf "Public key copied. Add it to https://github.com/settings/ssh/new\n(Press enter to open)..."
read
xdg-open https://github.com/settings/ssh/new
```

### restore zsh-shell history (private repo)
```bash
git clone --depth 1 ssh://git@codeberg.org/samiulsami/shell-history-backup.git $XDG_DATA_HOME/shell-history-backup
cp $XDG_DATA_HOME/shell-history-backup/zsh_history "$ZDOTDIR/zsh_history"
```

### setup wallpapers directory (private repo)
```bash
git clone --depth 1 git@github.com:samiulsami/wallpapers.git $XDG_DATA_HOME/wallpapers
```

## TODO

- [ ] NOT automate this with ansible/stow/chezmoi/etc.
- [ ] Add support for Debian based distros.

### References
- [https://github.com/sysdevbd/sysdevbd.github.io/tree/master](https://github.com/sysdevbd/sysdevbd.github.io/tree/master)
