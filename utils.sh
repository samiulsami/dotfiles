#!/usr/bin/env bash

# Shared utilities for dotfiles setup scripts

set -euo pipefail

# Request sudo credentials upfront
sudo -v

# Keep sudo alive in background for unattended installation
(while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done) &
SUDO_REFRESH_PID=$!

# XDG configuration - source from environment.d/xdg.conf
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR
while IFS='=' read -r key value; do
  [[ -z "$key" || "$key" =~ ^# ]] && continue
  value="${value//\$HOME/$HOME}"
  export "$key"="$value"
done < "$DOTFILES_DIR/environment.d/xdg.conf"

# Ensure required tools are available before proceeding
source "$DOTFILES_DIR/check_requirements.sh"

# Async job management
declare -a ASYNC_PIDS=()

run_async() {
  "$@" &
  ASYNC_PIDS+=($!)
}

wait_err() {
  for pid in "${ASYNC_PIDS[@]}"; do
    wait "$pid" || { echo "ERROR: Background job failed" >&2; exit 1; }
  done
  ASYNC_PIDS=()
}

# Retry function for git clones
# Clones to temp dir first, then replaces target only on success
retry_git_clone() {
  local max_attempts=3
  local attempt=1
  local last_arg="${!#}"
  local temp_dir=""

  temp_dir=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$temp_dir'" RETURN

  # Build args with temp destination instead of original
  local args=("${@:1:$#-1}" "$temp_dir/clone")

  while [ "$attempt" -le "$max_attempts" ]; do
    rm -rf "$temp_dir/clone"
    if git clone "${args[@]}"; then
      # Clone succeeded - now safe to replace target
      if [ -e "$last_arg" ]; then
        if [ -n "$last_arg" ] && [ "$last_arg" != "/" ] && [ "$last_arg" != "$HOME" ] && \
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
    echo "Git clone failed (attempt $attempt of $max_attempts), retrying..." >&2
    attempt=$((attempt + 1))
    sleep 2
  done

  echo "Git clone failed after $max_attempts attempts" >&2
  return 1
}

# Cleanup function to kill all background jobs
cleanup_background_jobs() {
  for pid in "${ASYNC_PIDS[@]}"; do
    # Kill all descendants (children, grandchildren, etc.) recursively
    pkill -9 -P "$pid" 2>/dev/null || true
    # Kill the entire process group
    kill -9 -"$pid" 2>/dev/null || true
    # Kill the process itself in case it's not in a group
    kill -9 "$pid" 2>/dev/null || true
  done
  kill -9 "$SUDO_REFRESH_PID" 2>/dev/null || true
}

# Kill all background jobs on script exit or interruption
trap cleanup_background_jobs EXIT INT TERM
