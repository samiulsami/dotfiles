# Automated Dotfiles Installation with Ansible

This directory contains Ansible automation to install and configure the entire development environment from the manual instructions in README.md.

## Quick Start

```bash
# Option 1: Use the main setup script (Recommended)
./setup.sh

# Option 2: Run Ansible directly
cd ansible
./run-setup.sh

# Run with specific tags only
cd ansible
./run-setup.sh --tags "system_packages,shell_config"

# Dry run to see what would be done
cd ansible
./run-setup.sh --check

# Run with verbose output
cd ansible
./run-setup.sh -vv
```

## Prerequisites

- Arch Linux
- User with sudo privileges
- Git (to clone this repository)
- Base-devel package group installed

The playbook will automatically install Ansible if not present.

## Configuration

### Customizing Variables

Edit `ansible/group_vars/all.yml` to customize the installation:

```yaml
# Tool versions
java_version: "jdk-24"
go_version: "1.24.3"
node_version: "24"

# Optional installations
install_cloudflare_warp: false
install_claude_code: true
configure_git_defaults: true

# Git configuration (set these before running)
git_name: "Your Name"
git_email: "your@email.com"

# Monitor setup (auto-detected if empty)
monitor1: "DP-1"  # Primary monitor
monitor2: "HDMI-1"  # Secondary monitor
```

### Selective Installation

You can skip certain components by using tags:

```bash
# Install only shell configuration
cd ansible
./run-setup.sh --tags "shell_config"

# Skip desktop environment installation
cd ansible
./run-setup.sh --skip-tags "desktop_environment"
```

## Available Tags

- `system_packages` - Base system packages and utilities
- `desktop_environment` - i3wm, terminal apps, GUI tools
- `shell_config` - Zsh, tmux, shell plugins and tools  
- `development_tools` - Docker, Java, Go, Node.js, Kubernetes tools
- `dotfiles_config` - Symlink dotfiles and configuration
- `gnome` - GNOME-specific settings (optional)

## Roles Overview

### system_packages
- Base packages (curl, git, build tools)
- Utilities (fd, bat, ripgrep, jq)
- System configurations (file watchers, keyboard settings)
- GitHub CLI and optional Cloudflare Warp

### shell_config
- Zsh with Powerlevel10k theme
- Shell plugins (autosuggestions, syntax highlighting, vi-mode)
- Tmux with custom configuration
- Tools: fzf, zoxide
- fnm for Node.js version management

### development_tools
- Docker with user permissions
- Java (Oracle JDK 24) and Maven
- Go with gopls language server
- Kubernetes tools (kubectl, kind, helm)
- AI tools (claude-code)

### desktop_environment
- i3 window manager and utilities
- Terminal emulator (Ghostty)
- Application launcher (rofi)
- Compositor (picom) and notifications (dunst)
- Audio/display controls

### dotfiles_config
- Symlinks all configuration files
- Environment variable setup
- Git configuration defaults
- Dynamic monitor detection for i3

## Directory Structure

```
dotfiles/
├── setup.sh                 # Main setup script with options
├── ansible/                 # Ansible automation directory
│   ├── run-setup.sh         # Ansible execution script
│   ├── ansible.cfg          # Ansible configuration
│   ├── playbooks/
│   │   └── dotfiles.yml     # Main playbook
│   ├── inventory/
│   │   └── inventory.ini    # Inventory file (localhost)
│   ├── group_vars/
│   │   └── all.yml          # Global variables
│   └── roles/
│       ├── system_packages/     # System packages and utilities
│       ├── shell_config/        # Shell and terminal configuration
│       ├── development_tools/   # Programming language tools
│       ├── desktop_environment/ # GUI and desktop tools
│       └── dotfiles_config/     # Configuration file linking
└── [dotfiles directories...]
```

## Troubleshooting

### Common Issues

1. **Ansible not found**: The script will auto-install Ansible
2. **Permission denied**: Make sure your user has sudo privileges
3. **Monitor detection fails**: Manually set monitor variables in `group_vars/all.yml`
4. **Yazi build fails**: Ensure Rust dependencies are installed

### Running Specific Parts

```bash
# Only install system packages
cd ansible && ./run-setup.sh --tags "system_packages"

# Skip the desktop environment
cd ansible && ./run-setup.sh --skip-tags "desktop_environment"

# Check what would be done without making changes
cd ansible && ./run-setup.sh --check
```

### Debug Mode

```bash
# Run with maximum verbosity
cd ansible && ./run-setup.sh -vvv
```

## Post-Installation

After running the playbook:

1. **Reboot or logout/login** to apply all changes
2. **Set git credentials**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```
3. **Generate SSH keys** if needed:
   ```bash
   ssh-keygen -t rsa -C "your@email.com"
   ```
4. **Configure Neovim** (optional):
   ```bash
   git clone https://github.com/samiulsami/nvimconfig ~/.config/nvim
   ```

## Manual Installation Alternative

If you prefer the manual approach, follow the original [README.md](README.md) instructions.

## Customization

The Ansible setup is designed to be idempotent - you can run it multiple times safely. To add your own customizations:

1. Modify variables in `group_vars/all.yml`
2. Add custom tasks to existing roles
3. Create new roles for additional software
4. Use the `--tags` flag to run only specific parts

## Comparison with Manual Installation

| Manual (README.md) | Ansible Automation |
|-------------------|-------------------|
| ~2-3 hours setup | ~30-45 minutes |
| Error-prone | Idempotent & reliable |
| Hard to reproduce | Easily reproducible |
| Manual verification | Automatic verification |
| Step-by-step | One command |

The Ansible automation provides the same end result as the manual installation but with better reliability and repeatability.
