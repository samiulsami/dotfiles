#!/bin/bash

# Ansible Dotfiles Runner
# Simple script to run the ansible playbook

set -e

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "ERROR: This script should not be run as root"
    exit 1
fi

# Check if we're in the ansible directory
if [[ ! -f "playbooks/dotfiles.yml" ]]; then
    echo "ERROR: playbooks/dotfiles.yml not found. Run this script from the ansible directory."
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    sudo pacman -Sy --noconfirm ansible
fi

# Install required collections
ansible-galaxy collection install ansible.posix community.general --force

# Run the playbook
ansible-playbook playbooks/dotfiles.yml --ask-become-pass "$@"

echo ""
echo "🎉 Installation complete!"