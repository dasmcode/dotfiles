#!/usr/bin/env bash
set -euo pipefail

# Install the declarative Pi setup without touching sessions or credentials.
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PI_AGENT_DIR="${PI_AGENT_DIR:-$HOME/.pi/agent}"

mkdir -p "$PI_AGENT_DIR"

backup_existing() {
  local destination="$1"
  if [ -L "$destination" ]; then
    rm -f "$destination"
  elif [ -e "$destination" ]; then
    local backup="${destination}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$destination" "$backup"
    printf 'Backed up %s to %s\n' "$destination" "$backup"
  fi
}

link_managed() {
  local source="$1"
  local destination="$2"
  backup_existing "$destination"
  ln -s "$source" "$destination"
  printf 'Linked %s -> %s\n' "$destination" "$source"
}

link_managed "$REPO_DIR/settings.json" "$PI_AGENT_DIR/settings.json"
link_managed "$REPO_DIR/extensions" "$PI_AGENT_DIR/extensions"
link_managed "$REPO_DIR/zentui.json" "$PI_AGENT_DIR/zentui.json"

# Pi package resources are declared in settings.json and installed explicitly
# here so a clean machine is ready immediately.
packages=(
  "npm:pi-zentui@0.24.0"
  "npm:@firstpick/pi-themes-bundle@0.1.6"
  "npm:pi-markdown-preview@0.17.1"
  "npm:@gotgenes/pi-permission-system@32.1.0"
  "npm:pi-web-access@0.29.0"
  "npm:pi-herdr-subagents@0.2.0"
)

for package in "${packages[@]}"; do
  pi install "$package"
done

if ! command -v leaf >/dev/null 2>&1; then
  curl -fsSL https://leaf.rivolink.mg/install.sh | sh
fi

printf '\nPi configuration installed.\n'
printf 'Sessions and secrets were intentionally not copied.\n'
