# dotfiles (Termux Edition)

**Core**
- <b>Terminal Environment</b>: Termux
- <b>Shell</b>: zsh + tmux
- <b>Editor</b>: neovim

**Utilities**
- fzf, fd, bat, ripgrep, zoxide, lsd, jq, etc.
- Gemini CLI, OpenCode

## Package Installation

### Termux pkg
```bash
set -euo pipefail

shell=(zsh starship tmux fzf fd bat ripgrep zoxide lsd tealdeer jq socat)
dev=(git curl wget nodejs neovim termux-api golang python rust build-essential cmake lua51 luajit lsof tree-sitter-parsers stylua proot-distro)

pkg install -y ${shell[@]} ${dev[@]}

# Install Gemini CLI
npm install -g @google/gemini-cli --ignore-scripts
```

## Environment Setup
### config files, plugins, and tools
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
termux-clipboard-set < "$HOME/.ssh/id_ed25519.pub"
printf "Public key copied. Add it to https://github.com/settings/ssh/new\n(Press enter to open)..."
read
termux-open-url https://github.com/settings/ssh/new
```
rsa (legacy)
```bash
EMAIL=$(git config user.email)
ssh-keygen -t rsa -b 4096 -C "$EMAIL"  # Press enter 3 times
eval "$(ssh-agent -s)" && ssh-add $HOME/.ssh/id_rsa
termux-clipboard-set < "$HOME/.ssh/id_rsa.pub"
printf "Public key copied. Add it to https://github.com/settings/ssh/new\n(Press enter to open)..."
read
termux-open-url https://github.com/settings/ssh/new
```

### restore zsh-shell history (private repo)
```bash
git clone --depth 1 ssh://git@codeberg.org/samiulsami/shell-history-backup.git $XDG_DATA_HOME/shell-history-backup
cp $XDG_DATA_HOME/shell-history-backup/zsh_history "$ZDOTDIR/zsh_history"
```

## Arch Linux Proot (for opencode-ai + LaTeX)

Due to GLIBC incompatibilities in native Termux, tools like `opencode-ai` and `pdflatex` are run inside an Arch Linux container.

### Setup
1.  **Install Arch**:
    ```bash
    proot-distro install archlinux
    ```
2.  **Provision Arch**:
    ```bash
    proot-distro login archlinux -- bash -lc "rm -f /var/lib/pacman/db.lck && pacman -Syu --noconfirm npm texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended && npm install -g opencode-ai"
    ```
3.  **Usage**:
    The `opencode` and `pdflatex` commands are wrapped in `zsh/zsh_functions` to run inside the container automatically while mapping your Termux home directory:
    ```bash
    opencode --help
    pdflatex -output-directory=/tmp samiul_islam_cv.tex && mv /tmp/samiul_islam_cv.pdf .
    ```

## TODO

- [ ] NOT automate this with ansible/stow/chezmoi/etc.
