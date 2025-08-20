#!/bin/bash

# Dotfiles Setup Script
# This script provides easy access to both manual and automated installation

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "=================================="
    echo "  Dotfiles Installation Options"
    echo "=================================="
    echo -e "${NC}"
}

print_option() {
    echo -e "${GREEN}$1${NC} $2"
}

print_note() {
    echo -e "${YELLOW}Note:${NC} $1"
}

print_header

echo "Choose your installation method:"
echo ""
print_option "1." "Automated installation (Recommended)"
print_option "   " "└── Uses Ansible for one-command setup"
echo ""
print_option "2." "Manual installation"
print_option "   " "└── Follow step-by-step instructions in README.md"
echo ""

read -p "Select option (1 or 2): " choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}Starting automated installation...${NC}"
        echo ""
        print_note "This will run the Ansible playbook from ./ansible/run-setup.sh"
        echo ""
        read -p "Continue? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            cd ansible
            ./run-setup.sh "$@"
        else
            echo "Installation cancelled."
        fi
        ;;
    2)
        echo ""
        echo -e "${BLUE}Manual installation selected${NC}"
        echo ""
        echo "Please follow the instructions in README.md"
        echo "The manual installation section starts after the 'Manual Installation (Original)' heading."
        echo ""
        print_note "You can also view the file with: cat README.md | less"
        ;;
    *)
        echo ""
        echo "Invalid option. Please choose 1 or 2."
        exit 1
        ;;
esac