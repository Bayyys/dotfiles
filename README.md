# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Included configs

- `private_dot_zshrc` - Zsh configuration file, which includes the public `dot_zshrc` and adds private settings.
- `private_dot_zimrc` - Zim configuration file, which includes the public `dot_zimrc` and adds private settings.
- `dot_vimrc` - Vim configuration file.
- `dot_ideavimrc` - IdeaVim configuration file for JetBrains IDEs.
- `run_once_10_install_cli_tools.sh.tmpl` - Install required CLI tools, ensure `zsh` exists, install/init `zimfw`, install `nvm`, and set default Node to LTS.
- `run_once_20_install_vim_plugins.sh.tmpl` - Install `vim-plug` and plugins declared in `dot_vimrc`.

## Install order

The scripts are prefixed with numbers to enforce execution order:

1. `run_once_10_install_cli_tools.sh.tmpl`
2. `run_once_20_install_vim_plugins.sh.tmpl`

Notes:
- `dot_ideavimrc` requires JetBrains IDE + IdeaVim plugin.
- IdeaVim extension capabilities (easymotion/sneak/surround/commentary/which-key) still need corresponding IDE plugins enabled manually.
- CLI installer supports `brew` (macOS/Linux) and Linux package managers: `apt`, `dnf`, `yum`, `pacman`, `zypper`, `apk`.
- CLI installer includes `nvm`, `tree`, and `tldr`; it also installs Node LTS via `nvm` and sets it as the default alias.
- Both install scripts print an execution summary at the end: Installed / Updated / Skipped / Failed.

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
