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
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

Options:
  --repo <url-or-path>   Dotfiles repository URL/path (default: Bayyys/dotfiles)
  --branch <name>        Git branch for chezmoi init
  --force                Pass --force to chezmoi apply
  -h, --help             Show this help
EOF
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

install_chezmoi_macos() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS. Please install brew first: https://brew.sh/" >&2
    exit 1
  fi
  brew install chezmoi
}

install_chezmoi_linux() {
  if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  fi

  if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update
    $SUDO apt-get install -y chezmoi
    return 0
  fi
  if command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y chezmoi
    return 0
  fi
  if command -v yum >/dev/null 2>&1; then
    $SUDO yum install -y chezmoi
    return 0
  fi
  if command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -Sy --noconfirm chezmoi
    return 0
  fi
  if command -v zypper >/dev/null 2>&1; then
    $SUDO zypper --non-interactive install chezmoi
    return 0
  fi
  if command -v apk >/dev/null 2>&1; then
    $SUDO apk add --no-cache chezmoi
    return 0
  fi
  if command -v brew >/dev/null 2>&1; then
    brew install chezmoi
    return 0
  fi

  # Fallback: official installer script.
  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$HOME/.local/bin"
    return 0
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
  install_chezmoi
  init_and_apply
  log "done"
}

main "$@"
