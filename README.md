# Dotfiles

### APT Packages
```bash
sudo apt update && sudo apt install -y \
  build-essential libunwind-dev binutils-dev git curl wget zsh fd-find bat ripgrep zoxide npm \
  libnotify-bin pass wofi dunst pavucontrol blueman brightnessctl git-gui \
  docker.io cmake gettext unzip xclip nvme-cli \
  sway swaylock swayidle swaybg waybar grim slurp wl-clipboard cliphist xdg-desktop-portal-wlr

sudo ln -sf $(which fdfind) /usr/bin/fd
sudo ln -sf $(which batcat) /usr/bin/bat
```

### GitHub CLI
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
sudo apt update && sudo apt install gh -y
```

### OBS Studio
```bash
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update && sudo apt install obs-studio -y
```

### Cloudflare Warp
```bash
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt update && sudo apt install cloudflare-warp -y
sudo warp-cli registration new
```

### Ghostty
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/ghostty 50
sudo update-alternatives --config x-terminal-emulator
```

### WezTerm
```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo "deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *"| sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install wezterm -y
```

### Tmux (with SIXEL support)
```bash
git clone --depth 1 https://github.com/tmux/tmux.git $HOME/tmux
cd $HOME/tmux
./autogen.sh
./configure --enable-sixel
make
sudo make install
cd $HOME/dotfiles
```

Verify SIXEL support:
```bash
tmux display-message -p '#{sixel_support}'
```

### Starship
```bash
curl -sS https://starship.rs/install.sh | sh
```

### Configuration Files & Additional Applications
```bash
# create directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

mkdir -p $XDG_CONFIG_HOME/{wofi,zsh,dunst,sway,waybar,ghostty,wezterm,opencode,tmux} $XDG_CONFIG_HOME/tmux/plugins/

# symlink config files for wofi, dunst, ghostty, wezterm, tmux, zsh, starship, opencode
sudo ln -sf $HOME/dotfiles/wofi/config $XDG_CONFIG_HOME/wofi/config
sudo ln -sf $HOME/dotfiles/dunst/dunstrc $XDG_CONFIG_HOME/dunst/dunstrc
sudo ln -sf $HOME/dotfiles/ghostty/config $XDG_CONFIG_HOME/ghostty/config
sudo ln -sf $HOME/dotfiles/wezterm/wezterm.lua $XDG_CONFIG_HOME/wezterm/wezterm.lua
sudo ln -sf $HOME/dotfiles/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
sudo ln -sf $HOME/dotfiles/zsh/zshenv $HOME/.zshenv
sudo ln -sf $HOME/dotfiles/zsh/zshrc $ZDOTDIR/.zshrc
sudo ln -sf $HOME/dotfiles/starship/starship.toml $XDG_CONFIG_HOME/starship.toml
sudo ln -sf $HOME/dotfiles/zsh/zsh_functions $ZDOTDIR/zsh_functions
sudo ln -sf $HOME/dotfiles/opencode/opencode.json $XDG_CONFIG_HOME/opencode/opencode.json
sudo ln -sf $HOME/dotfiles/opencode/opencode-notifier.json "$XDG_CONFIG_HOME/opencode/opencode-notifier.json"

# zsh plugins
git clone --depth 1 https://github.com/jeffreytse/zsh-vi-mode.git $ZDOTDIR/.zsh/zsh-vi-mode
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git $ZDOTDIR/.zsh/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZDOTDIR/.zsh/zsh-syntax-highlighting
git clone --depth 1 https://github.com/romkatv/powerlevel10k.git $ZDOTDIR/.zsh/powerlevel10k
git clone --depth 1 https://github.com/Aloxaf/fzf-tab.git $ZDOTDIR/.zsh/fzf-tab
git clone --depth 1 https://github.com/zsh-users/zsh-completions.git $ZDOTDIR/.zsh/zsh-completions

# tmux plugins
git clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect $XDG_CONFIG_HOME/tmux/plugins/tmux-resurrect
tmux source $XDG_CONFIG_HOME/tmux/tmux.conf

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $XDG_DATA_HOME/.fzf
$XDG_DATA_HOME/.fzf/install
source $ZDOTDIR/.zshrc

# sway
sudo ln -sf $HOME/dotfiles/sway/config $XDG_CONFIG_HOME/sway/config

# waybar
sudo ln -sf $HOME/dotfiles/waybar/config $XDG_CONFIG_HOME/waybar/config
sudo ln -sf $HOME/dotfiles/waybar/style.css $XDG_CONFIG_HOME/waybar/style.css
```

### Setup pass with gpg key
```bash
gpg --full-generate-key --keyid-format long # follow the prompts to generate a new key
pass init < press tab to complete with gpg key> # or copy paste the key id (below sec)
```

### JetBrainsMono Nerd Font
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip
rm JetBrainsMono.zip
cd -
fc-cache -fv
```

### Java
```bash
java_version=jdk-25
sudo rm -rf /usr/lib/jvm
curl -Lo ${java_version}.tar.gz https://download.oracle.com/java/25/archive/${java_version}_linux-x64_bin.tar.gz
tar -zxvf ${java_version}.tar.gz
rm ${java_version}.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo mv ${java_version} /usr/lib/jvm/jdk
echo "export JAVA_HOME=/usr/lib/jvm/jdk" >> $HOME/.zshrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> $HOME/.zshrc
source $HOME/.zshrc
java -version
```

### Maven
```bash
mvn_version=3.9.11
mvn_name=maven-${mvn_version}
sudo rm -rf /usr/lib/mvn
curl -Lo ${mvn_name}.tar.gz https://dlcdn.apache.org/maven/maven-3/${mvn_version}/binaries/apache-${mvn_name}-bin.tar.gz
tar -zxvf ${mvn_name}.tar.gz
rm  ${mvn_name}.tar.gz
sudo mkdir -p /usr/lib/mvn
sudo mv apache-${mvn_name} /usr/lib/mvn/maven
sudo echo "export MAVEN_HOME=/usr/lib/mvn/maven" >> $HOME/.zshrc
sudo echo "export PATH=\$MAVEN_HOME/bin:\$PATH" >> $HOME/.zshrc
source $HOME/.zshrc
mvn -version
```

### Golang
```bash
go_version=1.25.7
sudo rm -rf /usr/local/go
mkdir -p $HOME/Downloads
cd $HOME/Downloads
wget https://go.dev/dl/go${go_version}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go${go_version}.linux-amd64.tar.gz
sudo chown -R $(id -u):$(id -g) /usr/local/go
rm go${go_version}.linux-amd64.tar.gz
cd $HOME/dotfiles
mkdir -p $HOME/go
echo "export GOPATH=$HOME/go" >> $HOME/.zshrc
echo "export PATH=\$GOPATH/bin:/usr/local/go/bin:\$PATH" >> $HOME/.zshrc
source $HOME/.zshrc
go version
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

### Scala
```bash
# On x86-64 (aka AMD64)
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs
chmod +x cs
./cs setup
cs install metals
```

### kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

### kind
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

### helm
```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### OpenCode
```bash
curl -fsSL https://opencode.ai/install | bash
```

### Git & GitHub
```bash
gh extension install yusukebe/gh-markdown-preview
git config --global user.name <your-name>
git config --global user.email <your-email@domain.com>
git config --global --add url."git@github.com:".insteadOf "https://github.com/"
```

### Docker
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl start docker
docker run hello-world
```

### Neovim
```bash
# Download and extract Eclipse JDTLS (optional for Java development)
wget https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz -O /tmp/jdtls.tar.gz
mkdir -p $HOME/.eclipse_jdtls
tar -xzf /tmp/jdtls.tar.gz -C $HOME/.eclipse_jdtls
rm /tmp/jdtls.tar.gz

# Build Neovim from source
git clone https://github.com/neovim/neovim.git $HOME/neovim
cd $HOME/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd $HOME/dotfiles

# Clone configuration
git clone https://github.com/samiulsami/nvimconfig.git $HOME/.config/nvim

# Set as default git editor
git config --global core.editor 'nvim -f'
```

### SSH Keys
```bash
ssh -v
ssh-keygen -t rsa -C "<your-email>"
```

* <i>press enter 3 times</i>

* <i>check if agent is running</i>
```bash
ps -e  | grep [s]sh-agent
```

* <i>If it isn't, start it manually:</i>
```bash
ssh-agent /bin/bash
```

* <i>Load the identity into ssh-agent:</i>
```bash
ssh-add $HOME/.ssh/id_rsa
```

* <i>Install the public key on your Github account</i>

* <i>Get the key:</i>
```bash
cat $HOME/.ssh/id_rsa.pub
```
* <i>Install it here</i>: [https://github.com/settings/ssh/new](https://github.com/settings/ssh/new)

### restore zsh-shell history
- Follow the steps here:
[https://github.com/samiulsami/shell-history-backup](https://github.com/samiulsami/shell-history-backup)

### Connect to bluetooth device manually
```bash
hcitool scan  # to get the MAC address of your device
bluetoothctl
power on  # in case the bluez controller power is off
agent on
scan on  # wait for your device's address to show up here
scan off
trust MAC_ADDRESS
pair MAC_ADDRRESS
connect MAC_ADDRESS
```

### Fix keyboard Fn keys not-registering issue
```bash
echo "options hid_apple fnmode=0" | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u
```

### Increase file watch numbers
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### References
- [https://github.com/sysdevbd/sysdevbd.github.io/tree/master](https://github.com/sysdevbd/sysdevbd.github.io/tree/master)
- [https://mikeshade.com/posts/keychron-linux-function-keys/](https://mikeshade.com/posts/keychron-linux-function-keys/)
- [https://unix.stackexchange.com/a/530226/732495](https://unix.stackexchange.com/a/530226/732495)
