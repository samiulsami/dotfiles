# Ansible Directory

This directory contains the Ansible automation for installing the dotfiles environment.

## Structure

```
ansible/
├── run-setup.sh         # Main execution script
├── ansible.cfg          # Ansible configuration
├── playbooks/
│   └── dotfiles.yml     # Main playbook
├── inventory/
│   └── inventory.ini    # Localhost inventory
├── group_vars/
│   └── all.yml          # Global variables (customize here)
└── roles/
    ├── system_packages/     # Base system packages
    ├── shell_config/        # Shell configuration
    ├── development_tools/   # Programming tools
    ├── desktop_environment/ # GUI applications  
    └── dotfiles_config/     # Config file linking
```

## Usage

```bash
# Run full setup
./run-setup.sh

# Run specific parts only
./run-setup.sh --tags "shell_config,development_tools"

# Skip certain parts
./run-setup.sh --skip-tags "desktop_environment"

# Dry run (preview changes)
./run-setup.sh --check

# Verbose output
./run-setup.sh -vv
```

## Customization

Edit `group_vars/all.yml` to customize:
- Tool versions (Go, Java, Node.js, etc.)
- Optional components (Cloudflare Warp, etc.)
- Git configuration
- Monitor settings

## Documentation

See [../README-ANSIBLE.md](../README-ANSIBLE.md) for complete documentation.