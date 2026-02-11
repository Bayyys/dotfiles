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

### One-command bootstrap (recommended)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Bayyys/dotfiles/master/bootstrap.sh)"
```

If `curl` is unavailable:

```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/Bayyys/dotfiles/master/bootstrap.sh)"

`bootstrap.sh` installs `chezmoi` by OS policy:
- macOS: Homebrew (`brew install chezmoi`)
- Linux: tries `apt/dnf/yum/pacman/zypper/apk/brew`, then falls back to official install script
```

### Bootstrap via git

```bash
git clone https://github.com/Bayyys/dotfiles.git
cd dotfiles
./bootstrap.sh
```

### Manual chezmoi flow

```bash
chezmoi init <repo-url>
chezmoi apply
```

On first apply, `run_once_10_install_cli_tools.sh.tmpl` and `run_once_20_install_vim_plugins.sh.tmpl` will run automatically.

### Update dotfiles

```bash
chezmoi update
```

### Add / Modify dotfiles

```bash
chezmoi add <file-path>
chezmoi edit <file-path>
```
