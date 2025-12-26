#!/usr/bin/env bash

# Shared utilities for dotfiles setup scripts

set -euo pipefail

sudo -v

# Keep sudo alive in background for unattended installation
(while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done) &
SUDO_REFRESH_PID=$!

# XDG configuration - source from environment.d/xdg.conf
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
while IFS='=' read -r key value; do
  [[ -z "$key" || "$key" =~ ^# ]] && continue
  value="${value//\$HOME/$HOME}"
  export "$key"="$value"
done < "$SCRIPT_DIR/environment.d/xdg.conf"

if [[ "$SCRIPT_DIR" != "$DOTFILES_DIR" ]]; then
  echo "ERROR: $SCRIPT_DIR/environment.d/xdg.conf set DOTFILES_DIR to '$DOTFILES_DIR', but utils.sh is located in '$SCRIPT_DIR'" >&2
  exit 1
fi

source "$DOTFILES_DIR/check_requirements.sh"

# Async job management
declare -a ASYNC_PIDS=()

# Run a command asynchronously and store its PID.
# e.g; run_async some_command arg1 arg2
run_async() {
  "$@" &
  ASYNC_PIDS+=($!)
}

# Wait for all async jobs to complete and check for errors
wait_err() {
  for pid in "${ASYNC_PIDS[@]}"; do
    wait "$pid" || { echo "ERROR: Background job failed" >&2; exit 1; }
  done
  ASYNC_PIDS=()
}

# Retry function for git clones
# Clones to temp dir first, then replaces target only on success
# example usage: retry_git_clone --depth 1 https://github.com/user/repo /path/to/clone/into
retry_git_clone() {
  local max_attempts=3
  local attempt=1
  local last_arg="${!#}"
  local temp_dir=""

  temp_dir=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$temp_dir'" RETURN

  local args=("${@:1:$#-1}" "$temp_dir/clone")

  while [ "$attempt" -le "$max_attempts" ]; do
    rm -rf "$temp_dir/clone"
    echo "Attempt '$attempt': clone ${args[*]}"
    if git clone "${args[@]}" --quiet; then
      echo "Cloned: ${args[*]}"
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

# Ran automatically on script exit to clean up background jobs
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

trap cleanup_background_jobs EXIT INT TERM
