#!/bin/bash

# Simple Dotfiles Installation Script
# Installs Ansible and runs the complete playbook

set -e

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "ERROR: This script should not be run as root"
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    sudo pacman -Sy --noconfirm ansible
fi

# Install required Ansible collections
echo "Installing required Ansible collections..."
ansible-galaxy collection install ansible.posix community.general --force

# Run the playbook
echo "Running dotfiles installation..."
cd ansible
ansible-playbook playbooks/dotfiles.yml --ask-become-pass

echo ""
echo "🎉 Installation complete!"
echo "Please reboot or logout/login to apply all changes."
