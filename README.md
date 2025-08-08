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
mv ~/.config/google-chrome/ ~/.config/google-chrome-old
```
and import saved passwords

### Increase file watch numbers
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Rofi
```bash
sudo apt install rofi
mkdir -p $HOME/.config/rofi/
sudo ln -s  $HOME/dotfiles/rofi/config.rasi $HOME/.config/rofi/config.rasi
```

### yazi
```bash
sudo apt install ffmpeg 7zip jq imagemagick
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update
git clone https://github.com/sxyazi/yazi.git yazitmp
cd yazitmp
cargo build --release --locked
sudo mv target/release/yazi target/release/ya /usr/local/bin/
ya pkg add yazi-rs/plugins:mount
ya pkg add yazi-rs/flavors:catppuccin-frappe
ya pkg add yazi-rs/plugins:smart-enter
ya pkg add yazi-rs/plugins:no-status
ya pkg add dedukun/relative-motions
mkdir -p "$HOME/.config/yazi" && for f in "$HOME/dotfiles/yazi/"*; do sudo ln -sf "$(realpath "$f")" "$HOME/.config/yazi/$(basename "$f")"; done
cd ..
rm -rf yazitmp
```

### Picom
```bash
sudo apt install picom
mkdir -p $HOME/.config/picom
sudo ln -s $HOME/dotfiles/picom.conf $HOME/.config/picom/picom.conf
```

### Dunst
```bash
sudo apt install dunst
mkdir -p $HOME/.config/dunst
sudo ln -s $HOME/dotfiles/dunst/dunstrc $HOME/.config/dunst/dunstrc
```

### i3wm + utilities
```bash
sudo apt update
sudo apt install i3 pavucontrol blueman flameshot brightnessctl
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
sudo apt install git git-gui
gh extension install yusukebe/gh-markdown-preview
git config --global user.name <your-name>
git config --global user.email <your-email@domain.com>`
git config --global --add url."git@github.com:".insteadOf "https://github.com/"
```

### GitHub CLI
```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

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
sudo apt install zsh
mkdir -p $HOME/.zsh/
git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh/.zsh-vi-mode
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
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

### Node.js
```bash
curl -fsSL https://fnm.vercel.app/install | zsh
source $HOME/.zshrc
fnm install 24
```

### Fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install
```

### fd
```bash
sudo apt install fd-find
sudo ln -s $(which fdfind) /usr/bin/fd
```

### bat
```bash
sudo apt install bat
sudo ln -s $(which batcat) /usr/bin/bat
```

### tmux
```bash
sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
sudo ln -s $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
tmux source $HOME/.tmux.conf
```
- Press <b><i>`<C-b> + shift + i`</i></b>

### Neovim
- <b>Follow the steps here</b>: [https://github.com/samiulsami/nvimconfig](https://github.com/samiulsami/nvimconfig)

### jq & yq
```bash
sudo apt update
sudo apt install python3-pip
sudo apt-get install jq
pip install yq --break-system-packages
```

### Docker
```bash
sudo apt remove docker docker-engine docker.io
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
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
mvn_version=3.9.10
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
go_version=1.24.3
sudo rm -rf /usr/local/go
mkdir -p $HOME/Downloads
cd $HOME/Downloads
sudo apt-get update
sudo apt-get install -y build-essential git curl wget
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

### References
- [https://github.com/sysdevbd/sysdevbd.github.io/tree/master](https://github.com/sysdevbd/sysdevbd.github.io/tree/master)
- [https://mikeshade.com/posts/keychron-linux-function-keys/](https://mikeshade.com/posts/keychron-linux-function-keys/)
- [https://unix.stackexchange.com/a/530226/732495](https://unix.stackexchange.com/a/530226/732495)

## TODO
- [ ] Automate with Ansible
- [ ] Split this document into multiple files
