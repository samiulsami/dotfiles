#!/usr/bin/env bash

# Shared utilities for dotfiles setup scripts

set -euo pipefail

sudo -v

# Keep sudo alive in background for unattended installation
(while true; do
	sudo -n true
	sleep 50
	kill -0 "$$" || exit
done) &

# XDG configuration - source from environment.d/xdg.conf
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while IFS='=' read -r key value; do
	[[ -z "$key" || "$key" =~ ^# ]] && continue
	value="${value//\$HOME/$HOME}"
	export "$key"="$value"
done <"$SCRIPT_DIR/environment.d/xdg.conf"

if [[ "$SCRIPT_DIR" != "$DOTFILES_DIR" ]]; then
	echo "ERROR: $SCRIPT_DIR/environment.d/xdg.conf set DOTFILES_DIR to '$DOTFILES_DIR', but utils.sh is located in '$SCRIPT_DIR'" >&2
	exit 1
fi

source "$DOTFILES_DIR/check_requirements.sh"

# Async job management with FIFO-based worker pool
MAX_WORKERS=${MAX_WORKERS:-30}
MAX_RETRIES=${MAX_RETRIES:-10}
FAIL_LOG=$(mktemp)
declare -a ASYNC_PIDS=()

# Create anonymous FIFO for worker pool semaphore
FIFO=$(mktemp -u)
mkfifo "$FIFO"
exec 3<>"$FIFO"
rm "$FIFO"

# Seed the token bucket with MAX_WORKERS tokens
for ((i = 0; i < MAX_WORKERS; i++)); do echo >&3; done

# Nuke all child processes and clean up temp files
cleanup() {
	trap - EXIT INT TERM
	exec 3>&- 2>/dev/null || true
	kill 0 2>/dev/null || true
	rm -f "$FAIL_LOG"
}

trap cleanup EXIT INT TERM

# Run a command asynchronously with retry and FIFO-based worker pool
# Usage: run_async "description" command [args...]
run_async() {
	local desc="$1"
	shift

	read -r -u 3 # Acquire token (blocks if pool is full)

	(
		# Return token on any exit (signals trigger exit, which triggers this trap)
		trap 'echo >&3' EXIT

		local out exit_code attempt=1
		while [[ $attempt -le $MAX_RETRIES ]]; do
			out=$("$@" 2>&1) && {
				printf '\033[32m✓ %s\033[0m\n' "$desc" >&2
				exit 0
			}
			exit_code=$?
			((attempt++))
			[[ $attempt -gt $MAX_RETRIES ]] && break
			printf '\033[38;5;208m⚠ %s (attempt %d/%d, exit %d)\n%s\033[0m\n' "$desc" "$attempt" "$MAX_RETRIES" "$exit_code" "$out" >&2
			sleep $((attempt * 2 + RANDOM % (3 + attempt * 2)))
		done
		printf '\033[31m✗ %s (failed, exit %d)\n%s\033[0m\n' "$desc" "$exit_code" "$out" >&2
		{
			flock 200
			printf '%s\nexit=%d\n%s\n---\n' "$desc" "$exit_code" "$out" >&200
		} 200>>"$FAIL_LOG"
		exit 1
	) &
	ASYNC_PIDS+=($!)
}

# Wait for all async jobs, print summary, return 1 if any failed
wait_all() {
	local pid
	for pid in "${ASYNC_PIDS[@]}"; do
		wait "$pid" || true
	done
	ASYNC_PIDS=()
	echo "---" >&2
	if [[ -s "$FAIL_LOG" ]]; then
		printf '\033[31mFailed tasks:\033[0m\n' >&2
		cat "$FAIL_LOG" >&2
		return 1
	fi
	printf '\033[32mAll tasks completed successfully\033[0m\n' >&2
}

# Git clone with safety checks for target directory
# Clones to temp dir first, then replaces target only on success
# Usage: run_async "clone repo" git_clone [git args...] /path/to/target
git_clone() {
	local last_arg="${!#}"
	local temp_dir=""

	temp_dir=$(mktemp -d)
	# shellcheck disable=SC2064
	trap "rm -rf '$temp_dir'" RETURN

	local args=("${@:1:$#-1}" "$temp_dir/clone")

	if git clone "${args[@]}" --quiet; then
		if [ -e "$last_arg" ]; then
			if [ -n "$last_arg" ] && [ "$last_arg" != "/" ] && [ "$last_arg" != "$HOME" ] &&
				[ "$last_arg" != "$HOME/" ] && [[ "$last_arg" == "$HOME"* || "$last_arg" == "$XDG_CONFIG_HOME"* ]]; then
				rm -rf "$last_arg"
			else
				echo "Refusing to remove $last_arg - safety check failed" >&2
				return 1
			fi
		fi
		mv "$temp_dir/clone" "$last_arg"
		return 0
	fi
	return 1
}
