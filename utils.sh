#!/usr/bin/env bash

# Shared utilities for dotfiles setup scripts

set -euo pipefail

# Request sudo credentials upfront
sudo -v

# Keep sudo alive in background for unattended installation
(while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done) &
SUDO_REFRESH_PID=$!

# XDG configuration
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

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
retry_git_clone() {
  local max_attempts=3
  local attempt=1
  local last_arg="${!#}"

  while [ "$attempt" -le "$max_attempts" ]; do
    if git clone "$@"; then
      return 0
    fi
    echo "Git clone failed. Deleting $last_arg and retrying (attempt $attempt of $max_attempts)..." >&2
    if [ -d "$last_arg" ]; then
      # Ensure path is not empty, not root, and is within expected directories
      if [ -n "$last_arg" ] && [ "$last_arg" != "/" ] && [ "$last_arg" != "$HOME" ] && \
        [ "$last_arg" != "$HOME/" ] && [[ "$last_arg" == "$HOME"* || "$last_arg" == "$XDG_CONFIG_HOME"* ]]; then
      echo "Removing directory $last_arg"
      rm -rf "$last_arg"
    else
      echo "Refusing to remove $last_arg - safety check failed" >&2
      return 1
      fi
    fi

    attempt=$((attempt + 1))
    sleep 2
  done
  echo "Git clone failed after $max_attempts attempts" >&2
  return 1
}

# Cleanup function to kill all background jobs
cleanup_background_jobs() {
  sudo kill -9 "$SUDO_REFRESH_PID" || true
  for pid in "${ASYNC_PIDS[@]}"; do
    sudo kill -9 "$pid" || true
  done
}

# Kill all background jobs on script exit or interruption
trap cleanup_background_jobs EXIT INT TERM
