# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Included configs

- `private_dot_zshrc` - Zsh configuration file, which includes the public `dot_zshrc` and adds private settings.
- `private_dot_zimrc` - Zim configuration file, which includes the public `dot_zimrc` and adds private settings.
- `dot_vimrc` - Vim configuration file.
- `run_once_install_vimplug.sh.tmpl` - A template for a script that installs Vim-Plug, a plugin manager for Vim. This script is intended to be run once to set up Vim-Plug on the system.

## Usage

### Using chezmoi

```bash
chezmoi init <repo-url>
chezmoi apply
```

### Update dotfiles

```bash
chezmoi update
```

### Add / Modify dotfiles

```bash
chezmoi add <file-path>
chezmoi edit <file-path>
```
