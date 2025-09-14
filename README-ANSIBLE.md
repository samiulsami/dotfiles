# Automated Dotfiles Installation

Simple Ansible automation to install and configure the complete development environment.

## Installation

```bash
./setup.sh
```

That's it. The script will:
1. Install Ansible if needed
2. Install required Ansible collections
3. Run the complete playbook
4. Install everything

## What Gets Installed

- **System packages**: curl, git, build tools, utilities (fd, bat, ripgrep, etc.)
- **Desktop environment**: i3wm, rofi, picom, dunst, ghostty terminal
- **Shell configuration**: zsh with powerlevel10k, tmux, shell plugins
- **Development tools**: Docker, Java, Go, Node.js, Kubernetes tools
- **Dotfiles**: All configuration files symlinked to home directory
- **SSH**: Key generation and agent configuration

## Requirements

- Arch Linux
- User with sudo privileges
- This dotfiles repository

## After Installation

1. Reboot or logout/login
2. That's it

The playbook is idempotent - you can run it multiple times safely.
