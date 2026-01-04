# dotfiles

Personal dotfiles repository containing shell configurations, vim settings, and development environment setup.

## Changelogs

- v0: started as a fork of https://github.com/apaszke/dotfiles (thanks!)
- v1: Ported claude setup from https://github.com/abatilo/vimrc (thanks!)
- v2: Asked claude to help improve my setup.
- v3: Claude rewrote install script to be more robust with proper error handling and cross-platform support.
- v4: Claude rewrote my vimrc to neovim init.lua, which I would have never done without claude

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
