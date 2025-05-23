### Disable Mouse Acceleration (GNOME)
```bash
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
```
### Connect to bluetooth device manually
```
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
```
echo "options hid_apple fnmode=0" | sudo tee -a /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u
```
### Fix chrome passwords/cookies [persistence issue](https://askubuntu.com/a/1502211)
```
cd /usr/share/applications
sudo su
nvim google-chrome.desktop
```
### i3wm

```bash
sudo apt update
sudo apt install i3 picom rofi pavucontrol blueman dunst flameshot brightnessctl
cp ./i3wm/config ~/.config/i3/config
```

### Picom
```bash
cp ./picom/picom.conf ~/.config/picom/picom.conf
```
Then add <b><i>-chrome --password-store=gnome-libsecret</i></b> after every <b><i>Exec</i></b> line

### Dunst
```
mkdir -p ~/.config/dunst

cp ./dunst/dunstrc ~/.config/dunst/dunstrc
```
### Git
```bash
sudo apt install git git-gui

git config --global user.name <your-name>

git config --global user.email <your-email@domain.com>`

git config --global --add url."git@github.com:".insteadOf "https://github.com/"
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
ssh-add ~/.ssh/id_rsa
```

* <i>Install the public key on your Github account</i>

* <i>Get the key:</i>
```bash
cat ~/.ssh/id_rsa.pub
```
* <i>Install it here</i>: [https://github.com/settings/ssh/new](https://github.com/settings/ssh/new)

### Ghostty
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/ghostty 50

sudo update-alternatives --config x-terminal-emulator

cp ./ghostty/config ~/.config/ghostty/config
```

<b>(Fix terminal not found error)</b>:
```bash
export TERM=xterm-256color
```

### fish
```bash
sudo apt-add-repository ppa:fish-shell/release-3

sudo apt-get update && sudo apt-get upgrade

sudo apt-get install fish
```


### restore fish-shell history

- Follow the steps here:
[https://github.com/samiulsami/fish-shell-history](https://github.com/samiulsami/fish-shell-history)

### Zoxide
```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

sudo echo "export PATH=~/.local/bin:\$PATH" >> ~/.bashrc

echo "zoxide init fish | source" >> ~/.config/fish/config.fish
```

### Neovim
- <b>Follow the steps here</b>: [https://github.com/samiulsami/nvimconfig](https://github.com/samiulsami/nvimconfig)

### Fzf and Bat
```bash
sudo apt install fzf bat fd-find

sudo ln -s $(which fdfind) /usr/bin/fd

sudo ln -s $(which batcat) /usr/bin/bat

echo "alias fzfp=\"fzf -m --preview 'bat --color=always --style=numbers --line-range=:500 {}'\"" >> ~/.config/fish/config.fish

echo "set fzf_fd_opts --hidden --max-depth 5 --color=always" >> ~/.config/fish/config.fish

echo "set fzf_preview_file_cmd bat --color=always --style=numbers --line-range=:500" >> ~/.config/fish/config.fish

fish

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install PatrickF1/fzf.fish
```


### tmux
```bash
sudo apt install tmux

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cp ./tmux/.tmux.conf ~/.tmux.conf

tmux source ~/.tmux.conf
```
- Press <b><i>`<C-b> + shift + i`</i></b>

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


### Increase file watch numbers
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Java

```bash
java_version=jdk-22.0.2

sudo rm -rf /usr/lib/jvm

sudo curl -Lo ${java_version}.tar.gz https://download.oracle.com/java/22/archive/${java_version}_linux-x64_bin.tar.gz

tar -zxvf ${java_version}.tar.gz

rm ${java_version}.tar.gz

sudo mkdir -p /usr/lib/jvm

sudo mv ${java_version} /usr/lib/jvm/jdk

sudo echo "export JAVA_HOME=/usr/lib/jvm/jdk" >> ~/.bashrc

sudo echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc

source ~/.bashrc

java -version
```

### Maven
```bash
mvn_version=maven-3.9.9

sudo rm -rf /usr/lib/mvn

curl -Lo ${mvn_version}.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-${mvn_version}-bin.tar.gz

tar -zxvf ${mvn_version}.tar.gz

rm  ${mvn_version}.tar.gz

sudo mkdir -p /usr/lib/mvn

sudo mv apache-${mvn_version} /usr/lib/mvn/maven

sudo echo "export MAVEN_HOME=/usr/lib/mvn/maven" >> ~/.bashrc

sudo echo "export PATH=\$MAVEN_HOME/bin:\$PATH" >> ~/.bashrc

source ~/.bashrc

mvn -version
```

### Golang

```bash
go_version=1.24.1

sudo rm -rf /usr/local/go

mkdir -p ~/Downloads

cd ~/Downloads

sudo apt-get update

sudo apt-get install -y build-essential git curl wget

wget https://go.dev/dl/go${go_version}.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go${go_version}.linux-amd64.tar.gz

sudo chown -R $(id -u):$(id -g) /usr/local/go

rm go${go_version}.linux-amd64.tar.gz

mkdir $HOME/go

sudo echo "export GOPATH=$HOME/go" >> ~/.bashrc

sudo echo "export PATH=\$GOPATH/bin:/usr/local/go/bin:\$PATH" >> ~/.bashrc

source ~/.bashrc

go version

go install golang.org/x/tools/gopls@latest
```

### Kind

```bash
kind_version=v0.23.0

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

sudo echo "alias kc=\"kubectl\"" >> ~/.bashrc

sudo echo "alias kc 'kubectl'" >> ~/.config/fish/config.fish

sudo echo "export KUBE_EDITOR='nvim -f'" >> ~/.bashrc

source ~/.bashrc
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
- [ ] continue resisting the urge to automate these
