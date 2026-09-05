#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$HOME/dotfiles"
BACKUP="$HOME/.dotfiles-backup"

info() {
  printf '\n\033[1;36m==>\033[0m %s\n' "$1"
}

warn() {
  printf '\033[1;33mWARN:\033[0m %s\n' "$1"
}

success() {
  printf '\033[1;32mOK:\033[0m %s\n' "$1"
}

backup_and_link() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  # Đã symlink đúng rồi thì bỏ qua
  if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    success "$target already linked"
    return
  fi

  # Backup file/folder cũ
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP"

    local backup_name
    backup_name="$(echo "$target" | sed "s|$HOME/||" | tr '/' '_')"

    warn "Backing up $target"
    mv "$target" "$BACKUP/$backup_name"
  fi

  ln -s "$source" "$target"
  success "$target -> $source"
}

check_command() {
  local command="$1"

  if command -v "$command" >/dev/null 2>&1; then
    success "$command"
  else
    warn "$command not found"
  fi
}

info "Dotfiles bootstrap"
echo "Source: $DOTFILES"

# --------------------------------------------------
# Symlinks
# --------------------------------------------------

info "Creating symlinks"

backup_and_link \
  "$DOTFILES/.tmux.conf" \
  "$HOME/.tmux.conf"

backup_and_link \
  "$DOTFILES/ghostty/config.ghostty" \
  "$HOME/.config/ghostty/config.ghostty"

backup_and_link \
  "$DOTFILES/fish" \
  "$HOME/.config/fish"

backup_and_link \
  "$DOTFILES/bat/config" \
  "$HOME/.config/bat/config"

# ripgrep không tự đọc ~/.config
# path được set bởi fish/conf.d/env.fish
if [[ -f "$DOTFILES/ripgrep/ripgreprc" ]]; then
  success "ripgrep config found"
else
  warn "ripgrep/ripgreprc not found"
fi

# --------------------------------------------------
# Tool checks
# --------------------------------------------------

info "Checking tools"

check_command fish
check_command tmux
check_command ghostty

check_command eza
check_command fzf
check_command rg
check_command fdfind
check_command batcat

check_command git
check_command gh
check_command nvim

# --------------------------------------------------
# Done
# --------------------------------------------------

info "Bootstrap complete"

echo
echo "Backup directory:"
echo "  $BACKUP"
echo
echo "Useful next steps:"
echo "  exec fish"
echo "  dots-help"
echo
