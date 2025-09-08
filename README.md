## Automated Installation using Ansible in Ubuntu 24.04 LTS

```bash
git clone https://github.com/samiulsami/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
./setup.sh
```

See [README-ANSIBLE.md](README-ANSIBLE.md) for full automation documentation.

### Customizing Tool Versions

To use different versions of development tools, edit `ansible/group_vars/all.yml`:

```yaml
java_version: "jdk-24"        # Change Java version
maven_version: "3.9.10"       # Change Maven version
go_version: "1.25.0"          # Change Go version
kind_version: "v0.29.0"       # Change Kind version
node_version: "24"            # Change Node.js version
```

You can also enable/disable components by changing the install flags in the same file.

---

## Manual Installation

### Disable Mouse Acceleration (GNOME)
```bash
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
```

### Warp
```bash
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt-get update && sudo apt-get install cloudflare-warp
```

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

### Fix chrome passwords/cookies [persistence issue](https://askubuntu.com/a/1502211)
```bash
cd /usr/share/applications
sudo su
nvim google-chrome.desktop
```
Then add <b><i>-chrome --password-store=gnome-libsecret</i></b> after every <b><i>Exec</i></b> line

OR

run
```bash
mv $HOME/.config/google-chrome/ $HOME/.config/google-chrome-old
```
and import saved passwords

### Increase file watch numbers
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Rofi
```bash
sudo pacman -S rofi
mkdir -p $HOME/.config/rofi/
sudo ln -s  $HOME/dotfiles/rofi/config.rasi $HOME/.config/rofi/config.rasi
```

### Picom
```bash
sudo pacman -S picom
mkdir -p $HOME/.config/picom
sudo ln -s $HOME/dotfiles/picom.conf $HOME/.config/picom/picom.conf
```

### Dunst
```bash
sudo pacman -S dunst libnotify
mkdir -p $HOME/.config/dunst
sudo ln -s $HOME/dotfiles/dunst/dunstrc $HOME/.config/dunst/dunstrc
```

### i3wm + utilities
```bash
sudo pacman -S i3 pavucontrol blueman flameshot brightnessctl
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0
sed -i "s|^set \$monitor1 .*|set \$monitor1 $(xrandr | grep ' connected primary' | awk '{print $1}')|" "$HOME/dotfiles/i3wm/config"
sed -i "s|^set \$monitor2 .*|set \$monitor2 $(xrandr | grep ' connected' | grep -v ' connected primary ' | awk '{print $1}')|" "$HOME/dotfiles/i3wm/config"
sudo ln -s $HOME/dotfiles/i3wm/config $HOME/.config/i3/config
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


* <i>If it isn’t, start it manually:</i>
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

### Git & GitHub
```bash
sudo pacman -S install git git-gui
gh extension install yusukebe/gh-markdown-preview
git config --global user.name <your-name>
git config --global user.email <your-email@domain.com>`
git config --global --add url."git@github.com:".insteadOf "https://github.com/"
```

### GitHub CLI
```bash
#TODO:
gh extension install yusukebe/gh-markdown-preview
```

### Ghostty
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/ghostty 50
sudo update-alternatives --config x-terminal-emulator
sudo ln -s $HOME/dotfiles/ghostty/config $HOME/.config/ghostty/config
```

<b>(Fix terminal not found error)</b>:
```bash
export TERM=xterm-256color
```

### Zsh
```bash
sudo pacman -S zsh
mkdir -p $HOME/.zsh/
git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
git clone https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/powerlevel10k
git clone https://github.com/Aloxaf/fzf-tab.git $HOME/.zsh/fzf-tab
git clone https://github.com/zsh-users/zsh-completions.git $HOME/.zsh/zsh-completions
sudo ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
sudo ln -s $HOME/dotfiles/zsh/.zsh_functions_and_widgets $HOME/.zsh_functions_and_widgets
sudo ln -s $HOME/dotfiles/zsh/.p10k.zsh $HOME/.p10k.zsh
source $HOME/.zshrc
```

### restore zsh-shell history

- Follow the steps here:
[https://github.com/samiulsami/shell-history-backup](https://github.com/samiulsami/shell-history-backup)

### Zoxide
```bash
sudo pacman -S zoxide
```

### Node.js
```bash
sudo pacman -S npm #not sure if this is good practice
```

### Fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install
```

### fd
```bash
sudo pacman -S fd
```

### bat
```bash
sudo pacman -S bat
```

### tmux
```bash
sudo pacman -S tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
sudo ln -s $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
tmux source $HOME/.tmux.conf
```
- Press <b><i>`<C-b> + shift + i`</i></b>

### Neovim
- <b>Follow the steps here</b>: [https://github.com/samiulsami/nvimconfig](https://github.com/samiulsami/nvimconfig)

### Docker
```bash
pacman -S docker
```
* <i>Manage docker as non-root user</i>:
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
sudo systemctl start docker
docker run hello-world
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
sudo pacman -S git curl wget
wget https://go.dev/dl/go${go_version}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go${go_version}.linux-amd64.tar.gz
sudo chown -R $(id -u):$(id -g) /usr/local/go
rm go${go_version}.linux-amd64.tar.gz
mkdir $HOME/go
sudo echo "export GOPATH=$HOME/go" >> $HOME/.zshrc
sudo echo "export PATH=\$GOPATH/bin:/usr/local/go/bin:\$PATH" >> $HOME/.zshrc
source $HOME/.zshrc
go version
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

### Kind
```bash
kind_version=v0.29.0
curl -Lo ./kind https://kind.sigs.k8s.io/dl/${kind_version}/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind create cluster
```

### Kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
source $HOME/.zshrc
```

### Helm
```bash
 curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

### uvx
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Claude Code
```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

### OpenCode
```bash
npm i -g opencode-ai@latest
mkdir -p $HOME/.config/opencode
sudo ln -s $HOME/dotfiles/opencode/opencode.json $HOME/.config/opencode/opencode.json
```

### asdf
```bash
go install github.com/asdf-vm/asdf/cmd/asdf@latest
mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
asdf plugin add yq
asdf install yq 4.2.0
```

### OBS
```bash
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt install obs-studio
```

### References
- [https://github.com/sysdevbd/sysdevbd.github.io/tree/master](https://github.com/sysdevbd/sysdevbd.github.io/tree/master)
- [https://mikeshade.com/posts/keychron-linux-function-keys/](https://mikeshade.com/posts/keychron-linux-function-keys/)
- [https://unix.stackexchange.com/a/530226/732495](https://unix.stackexchange.com/a/530226/732495)
