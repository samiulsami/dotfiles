# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for a Linux development environment. The repository includes configurations for shell environments (zsh/fish), window management (i3wm), terminal applications (tmux, ghostty), and various development tools.

## Directory Structure

- `zsh/` - Zsh shell configuration with Powerlevel10k theme and extensive key bindings
- `fish/` - Fish shell configuration as an alternative
- `tmux/` - Tmux configuration with custom key bindings and plugin management
- `ghostty/` - Ghostty terminal emulator configuration  
- `i3wm/` - i3 window manager configuration

- `rofi/` - Rofi application launcher configuration
- `picom/` - Picom compositor configuration
- `dunst/` - Dunst notification daemon configuration

## Key Shell Functions and Tools

The zsh configuration includes several custom functions in `.zsh_functions_and_widgets`:

### Docker Management
- `dockerclean()` - Kill all containers and prune all images
- `dockerrmi()` - Remove images matching patterns
- `killports()` - Kill processes on specific ports

### Development Workflow  
- `gb()` - Fuzzy search and checkout git branches (local/remote)
- `exactgrep()` - Search for strings in files with exact matching
- `fuzzygrep()` - Fuzzy search through file contents
- `tns()` - Create and switch to new tmux session

### Navigation & File Management
- `fzf-dir-widget()` - Fuzzy search directories (Ctrl+Alt+D)

- `extract()` - Universal archive extraction function

## Installation Commands

The repository includes comprehensive setup instructions in the README.md. Key installation patterns:
- Most configs are symlinked: `sudo ln -s $HOME/dotfiles/<config> <target>`
- Tools are installed via package managers (apt, cargo, npm, go install)
- Shell plugins are cloned to specific directories

## Development Environment

### Shell Environment
- **Primary Shell**: Zsh with Powerlevel10k theme
- **Key Tools**: fzf, fd, bat, ripgrep, zoxide
- **Navigation**: Extensive fzf integration for files, directories, and history

### Development Tools
- **Languages**: Go, Java, Node.js, Docker
- **Kubernetes**: kubectl, helm, kind
- **Editor**: Neovim (referenced but config in separate repo)

### Tmux Configuration
- **Prefix**: Ctrl+B (default)
- **Session Management**: Plugin-based with session wizard
- **Navigation**: Vim-style pane navigation with Neovim integration
- **Plugins**: tmux-resurrect, tmux-session-wizard, tmux-fzf

## Key Bindings

### Zsh Vi-mode Bindings
- `Ctrl+O` - Accept autosuggestion
- `Alt+R` - History search with fzf
- `Alt+F` - File search with fzf  
- `Alt+D` - Directory search with fzf
- `Alt+G` - Content search with exactgrep
- `Ctrl+G` - Fuzzy content search

- `Ctrl+Z` - Suspend/resume jobs

### Tmux Bindings
- `Prefix + p` - Session wizard
- `Prefix + f` - Tmux-fzf menu
- `Prefix + e/o` - Split panes
- `Ctrl+H/J/K/L` - Navigate panes (Neovim aware)

## Common Maintenance Tasks

When working with this repository:
1. Configuration changes are made directly to files in the dotfiles directory
2. Symlinks automatically reflect changes in the target locations
3. Shell functions are extensively used for common development tasks
4. The setup is designed for a single-user Linux environment with i3wm

## Dependencies

Critical dependencies that must be installed for full functionality:
- fzf, fd, bat, ripgrep (search and navigation)
- tmux with plugin manager

- zoxide for directory jumping
- Docker and Kubernetes tools (kubectl, helm, kind)
