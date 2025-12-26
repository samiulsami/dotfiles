#!/usr/bin/env bash

# Verify required tools exist before running setup scripts.

REQUIRED_CMDS=(
  git wget curl tmux sed ln mkdir xrandr awk
  go make tar gzip sudo systemctl groupadd usermod
  cp rm grep chsh readlink which zsh tlp
  socat jq pactl brightnessctl wl-copy fzf fd bat zoxide dunstctl grim slurp swappy
)

missing=()
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if [ ${#missing[@]} -ne 0 ]; then
  echo "Missing required tools: ${missing[*]}" >&2
  exit 1
fi
