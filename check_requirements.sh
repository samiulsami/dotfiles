#!/usr/bin/env bash

# Verify required tools exist before running setup scripts.

REQUIRED_CMDS=(
	git wget tmux sed ln mkdir tar gzip sudo systemctl
	groupadd usermod cp rm chsh readlink which zsh go make
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
