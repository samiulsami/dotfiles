# Dotfiles

## Automated Installation (Ubuntu 24.04 LTS)

```bash
git clone https://github.com/samiulsami/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
./setup.sh
```

See [README-ANSIBLE.md](README-ANSIBLE.md) for details.

---

## Manual Installation

### APT Packages
```bash
sudo apt update && sudo apt install -y \
  build-essential git curl wget zsh tmux fd-find bat ripgrep zoxide npm \
  libnotify-bin rofi picom dunst i3 pavucontrol \
  blueman flameshot brightnessctl git-gui \
  docker.io cmake gettext unzip xclip nvme-cli

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

### Configuration Files & Additional Applications
```bash
# create directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

mkdir -p $XDG_CONFIG_HOME/{rofi,zsh,picom,dunst,i3,ghostty,opencode,tmux} $XDG_CONFIG_HOME/tmux/plugins/

# symlink config files for rofi, picom, dunst, ghostty, tmux, zsh, opencode
sudo ln -sf $HOME/dotfiles/rofi/config.rasi $XDG_CONFIG_HOME/rofi/config.rasi
sudo ln -sf $HOME/dotfiles/picom/picom.conf $XDG_CONFIG_HOME/picom/picom.conf
sudo ln -sf $HOME/dotfiles/dunst/dunstrc $XDG_CONFIG_HOME/dunst/dunstrc
sudo ln -sf $HOME/dotfiles/ghostty/config $XDG_CONFIG_HOME/ghostty/config
sudo ln -sf $HOME/dotfiles/tmux/tmux.conf $XDG_CONFIG_HOME/tmux/tmux.conf
sudo ln -sf $HOME/dotfiles/zsh/zshenv $HOME/.zshenv
sudo ln -sf $HOME/dotfiles/zsh/zshrc $ZDOTDIR/.zshrc
sudo ln -sf $HOME/dotfiles/zsh/zsh_functions_and_widgets $ZDOTDIR/zsh_functions_and_widgets
sudo ln -sf $HOME/dotfiles/zsh/p10k.zsh $ZDOTDIR/p10k.zsh
sudo ln -sf $HOME/dotfiles/opencode/opencode.json $XDG_CONFIG_HOME/opencode/opencode.json

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

# i3wm
sed -i "s|^set \$monitor1 .*|set \$monitor1 $(xrandr | grep ' connected primary' | awk '{print $1}')|" "$HOME/dotfiles/i3wm/config"
sed -i "s|^set \$monitor2 .*|set \$monitor2 $(xrandr | grep ' connected' | grep -v ' connected primary ' | awk '{print $1}')|" "$HOME/dotfiles/i3wm/config"
sudo ln -sf $HOME/dotfiles/i3wm/config $XDG_CONFIG_HOME/i3/config
```

### Java
```bash
java_version=jdk-24
sudo rm -rf /usr/lib/jvm
curl -Lo ${java_version}.tar.gz https://download.oracle.com/java/24/archive/${java_version}_linux-x64_bin.tar.gz
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
go_version=1.25.1
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
npm i -g opencode-ai@latest
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
