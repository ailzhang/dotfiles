# dotfiles

Personal dotfiles repository containing shell configurations, vim settings, and development environment setup.

## Installation

```bash
git clone https://github.com/ailzhang/dotfiles.git
cd dotfiles
./install
```

The install script will:
- Detect your OS (macOS/Linux) and install required packages
- Install Oh My Zsh
- Create symlinks for all dotfiles (backing up existing files)
- Set up Claude Code configuration
- Install Vim plugins
- Set up fzf shell integration (completion and key bindings)
- Compile YouCompleteMe for code completion
- Change your default shell to zsh

## Uninstallation

```bash
./uninstall
```

The uninstall script will:
- Remove all symlinks created by the install script
- Optionally restore backups of your original files
- Leave Oh My Zsh and system packages intact

## What's Included

- `.zshrc` - Zsh configuration with Oh My Zsh
- `.vimrc` - Vim configuration with plugins
- `.tmux.conf` - Tmux configuration
- `.gitconfig` - Git configuration
- Claude Code configuration (CLAUDE.md, settings, commands, skills, rules)

## Changelogs

1. v0: started as a fork of https://github.com/apaszke/dotfiles
2. v1: Ported claude setup from https://github.com/abatilo/vimrc
3. v2: Asked claude to help improve my setup.
4. v3: Rewrote install script to be more robust with proper error handling and cross-platform support.
