#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Bayyys/dotfiles.git"
BRANCH=""
FORCE=0
SUDO=""

log() {
  printf '[bootstrap] %s\n' "$1"
}

usage() {
  cat <<'USAGE'
Usage: ./bootstrap.sh [options]

Options:
  --repo <url-or-path>   Dotfiles repository URL/path (default: Bayyys/dotfiles)
  --branch <name>        Git branch for chezmoi init
  --force                Pass --force to chezmoi apply
  -h, --help             Show this help
USAGE
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --repo)
        REPO_URL="${2:-}"
        shift 2
        ;;
      --branch)
        BRANCH="${2:-}"
        shift 2
        ;;
      --force)
        FORCE=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Unknown argument: $1" >&2
        usage
        exit 1
        ;;
    esac
  done
}

init_sudo() {
  if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  fi
}

install_zsh_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS. Install brew first: https://brew.sh/" >&2
    return 1
  fi
  brew install zsh
}

install_zsh_linux() {
  if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update
    $SUDO apt-get install -y zsh
    return 0
  fi
  if command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y zsh
    return 0
  fi
  if command -v yum >/dev/null 2>&1; then
    $SUDO yum install -y zsh
    return 0
  fi
  if command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -Sy --noconfirm --needed zsh
    return 0
  fi
  if command -v zypper >/dev/null 2>&1; then
    $SUDO zypper --non-interactive install zsh
    return 0
  fi
  if command -v apk >/dev/null 2>&1; then
    $SUDO apk add --no-cache zsh
    return 0
  fi
  if command -v brew >/dev/null 2>&1; then
    brew install zsh
    return 0
  fi
  return 1
}

resolve_chsh_shell() {
  local zsh_path="$1"
  local line shell_line

  if [ ! -f /etc/shells ]; then
    printf '%s\n' "$zsh_path"
    return 0
  fi

  while IFS= read -r line; do
    shell_line="${line%%#*}"
    shell_line="${shell_line%%[[:space:]]*}"
    shell_line="${shell_line//$'\r'/}"
    [ -n "$shell_line" ] || continue
    if [ "$shell_line" = "$zsh_path" ]; then
      printf '%s\n' "$shell_line"
      return 0
    fi
  done < /etc/shells

  while IFS= read -r line; do
    shell_line="${line%%#*}"
    shell_line="${shell_line%%[[:space:]]*}"
    shell_line="${shell_line//$'\r'/}"
    [ -n "$shell_line" ] || continue
    if [ "$(basename "$shell_line")" = "$(basename "$zsh_path")" ] && [ -x "$shell_line" ]; then
      printf '%s\n' "$shell_line"
      return 0
    fi
  done < /etc/shells

  printf '%s\n' "$zsh_path"
}

ensure_zsh_ready() {
  local os zsh_path chsh_shell

  if ! command -v zsh >/dev/null 2>&1; then
    os="$(uname -s)"
    log "zsh not found, installing for OS: ${os}"
    case "$os" in
      Darwin)
        install_zsh_macos || true
        ;;
      Linux)
        install_zsh_linux || true
        ;;
      *)
        ;;
    esac
  fi

  if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh installation failed. Please install zsh manually from official website: https://www.zsh.org/" >&2
    exit 1
  fi

  zsh_path="$(command -v zsh)"
  chsh_shell="$(resolve_chsh_shell "$zsh_path")"

  if [ "${SHELL:-}" != "$chsh_shell" ]; then
    if ! command -v chsh >/dev/null 2>&1; then
      echo "Cannot switch to zsh automatically (chsh missing). Please install/configure zsh manually: https://www.zsh.org/" >&2
      exit 1
    fi

    log "switching default shell to: ${chsh_shell}"
    if ! chsh -s "$chsh_shell" "$USER"; then
      echo "Failed to switch default shell to zsh. Please follow official instructions: https://www.zsh.org/" >&2
      exit 1
    fi
  fi
}

install_chezmoi_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS. Please install brew first: https://brew.sh/" >&2
    exit 1
  fi
  brew install chezmoi
}

install_chezmoi_linux() {
  if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update || true
    $SUDO apt-get install -y chezmoi || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi
  if command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y chezmoi || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi
  if command -v yum >/dev/null 2>&1; then
    $SUDO yum install -y chezmoi || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi
  if command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -Sy --noconfirm chezmoi || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi
  if command -v zypper >/dev/null 2>&1; then
    $SUDO zypper --non-interactive install chezmoi || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi
  if command -v apk >/dev/null 2>&1; then
    $SUDO apk add --no-cache chezmoi || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi
  if command -v brew >/dev/null 2>&1; then
    brew install chezmoi || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi

  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$HOME/.local/bin" || true
    command -v chezmoi >/dev/null 2>&1 && return 0
  fi

  return 1
}

install_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    log "chezmoi already installed: $(command -v chezmoi)"
    return 0
  fi

  local os
  os="$(uname -s)"
  log "installing chezmoi for OS: ${os}"
  case "$os" in
    Darwin)
      install_chezmoi_macos
      ;;
    Linux)
      if ! install_chezmoi_linux; then
        echo "Failed to install chezmoi on Linux with available installers." >&2
        exit 1
      fi
      ;;
    *)
      echo "Unsupported OS: $os. Please install chezmoi manually." >&2
      exit 1
      ;;
  esac

  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v chezmoi >/dev/null 2>&1; then
    echo "chezmoi install failed" >&2
    exit 1
  fi
}

init_and_apply() {
  local args=(init --apply)

  if [ -n "$BRANCH" ]; then
    args+=(--branch "$BRANCH")
  fi
  if [ "$FORCE" -eq 1 ]; then
    args+=(--force)
  fi
  args+=("$REPO_URL")

  log "running: chezmoi ${args[*]}"
  chezmoi "${args[@]}"
}

main() {
  parse_args "$@"
  init_sudo
  ensure_zsh_ready
  install_chezmoi
  init_and_apply
  log "done"
}

main "$@"
