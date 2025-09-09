#!/bin/bash

# Dotfiles Ansible Setup Script
# Run this from the ansible directory to install the complete development environment

set -euxo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root"
    exit 1
fi

# Check if we're in the ansible directory
if [[ ! -f "playbooks/dotfiles.yml" ]]; then
    print_error "playbooks/dotfiles.yml not found. Please run this script from the ansible directory."
    print_status "Expected structure:"
    print_status "  ansible/"
    print_status "  ├── playbooks/dotfiles.yml"
    print_status "  ├── roles/"
    print_status "  ├── group_vars/"
    print_status "  └── inventory/"
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    print_status "Installing Ansible..."
    sudo pacman -Sy --noconfirm ansible
fi

# Get the dotfiles directory (parent of ansible directory)
DOTFILES_DIR="$(cd .. && pwd)"
print_status "Dotfiles directory: $DOTFILES_DIR"

# Parse command line arguments
TAGS=""
SKIP_TAGS=""
CHECK_MODE=""
VERBOSE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --tags)
            TAGS="--tags $2"
            shift 2
            ;;
        --skip-tags)
            SKIP_TAGS="--skip-tags $2"
            shift 2
            ;;
        --check)
            CHECK_MODE="--check"
            shift
            ;;
        -v|--verbose)
            VERBOSE="-v"
            shift
            ;;
        -vv)
            VERBOSE="-vv"
            shift
            ;;
        -vvv)
            VERBOSE="-vvv"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --tags TAGS       Only run tasks tagged with these tags"
            echo "  --skip-tags TAGS  Skip tasks tagged with these tags"
            echo "  --check          Run in check mode (dry run)"
            echo "  -v, -vv, -vvv    Increase verbosity"
            echo "  --help           Show this help message"
            echo ""
            echo "Available tags:"
            echo "  system_packages   - Install system packages"
            echo "  desktop_environment - Install desktop environment"
            echo "  shell_config      - Configure shell environment"
            echo "  development_tools - Install development tools"
            echo "  dotfiles_config   - Configure dotfiles"
            echo "  gnome             - GNOME-specific configurations"
            echo ""
            echo "Run from: $DOTFILES_DIR/ansible/"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Ask for sudo password upfront
print_status "Please enter your sudo password:"
sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Run the ansible playbook
print_status "Running Ansible playbook from $(pwd)"
cmd="ansible-playbook playbooks/dotfiles.yml $TAGS $SKIP_TAGS $CHECK_MODE $VERBOSE --ask-become-pass"

if [[ -n "$CHECK_MODE" ]]; then
    print_warning "Running in check mode (dry run)"
fi

print_status "Executing: $cmd"

# Execute the command
eval $cmd

if [[ $? -eq 0 ]]; then
    print_success "Dotfiles installation completed successfully!"
    print_status ""
    print_status "🎉 Setup complete! Next steps:"
    print_status "1. Reboot or logout/login to apply all changes"
    print_status "2. Configure git:"
    print_status "   git config --global user.name 'Your Name'"
    print_status "   git config --global user.email 'your@email.com'"
    print_status "3. Generate SSH keys if needed:"
    print_status "   ssh-keygen -t rsa -C 'your@email.com'"
else
    print_error "Ansible playbook failed!"
    exit 1
fi
