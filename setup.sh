#!/bin/bash

# Simple Dotfiles Installation Script
# Installs Ansible and runs the complete playbook

set -e

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "ERROR: This script should not be run as root"
    exit 1
fi

# Prompt for user configuration
echo "=== Dotfiles Setup Configuration ==="
echo ""

read -p "Enter your Git username: " git_name
read -p "Enter your Git email: " git_email

read -p "Install Cloudflare Warp? (y/n, default: y): " install_warp
install_warp=${install_warp:-y}
[[ "$install_warp" =~ ^[Yy]$ ]] && install_cloudflare_warp=true || install_cloudflare_warp=false

read -p "Install Neovim from source? (y/n, default: y): " install_nvim
install_nvim=${install_nvim:-y}
[[ "$install_nvim" =~ ^[Yy]$ ]] && install_neovim=true || install_neovim=false

read -p "Install OpenCode? (y/n, default: y): " install_oc
install_oc=${install_oc:-y}
[[ "$install_oc" =~ ^[Yy]$ ]] && install_opencode=true || install_opencode=false

echo ""
echo "Configuration Summary:"
echo "  Git Username: $git_name"
echo "  Git Email: $git_email"
echo "  Docker Registry: $docker_registry"
echo "  Install Cloudflare Warp: $install_cloudflare_warp"
echo "  Install Neovim: $install_neovim"
echo "  Install OpenCode: $install_opencode"
echo ""
read -p "Proceed with installation? (y/n): " proceed
if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible
fi

# Install required Ansible collections
echo "Installing required Ansible collections..."
ansible-galaxy collection install ansible.posix community.general --force

# Run the playbook with extra vars
echo "Running dotfiles installation..."
cd ansible
ansible-playbook playbooks/dotfiles.yml --ask-become-pass \
    --extra-vars "git_name=$git_name" \
    --extra-vars "git_email=$git_email" \
    --extra-vars "install_cloudflare_warp=$install_cloudflare_warp" \
    --extra-vars "install_neovim=$install_neovim" \
    --extra-vars "install_opencode=$install_opencode"

echo ""
echo "🎉 Installation complete!"
echo "Please reboot or logout/login to apply all changes."
