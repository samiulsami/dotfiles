#!/usr/bin/env sh

tmp=$(mktemp) || exit 1
trap 'rm -f "$tmp"' EXIT

tmux capture-pane -J -S -
tmux save-buffer "$tmp"
tmux display-popup -w 100% -h 100% -S fg=yellow,bg=black -E "nvim -c 'set ft=conf' -c 'lua vim.api.nvim_create_autocmd(\"VimEnter\", { once = true, callback = function() vim.schedule(function() require(\"conform\").format() vim.cmd([[normal Go]]) vim.fn.search([[\\S]], \"bW\") vim.bo.modified = false end) end })' '$tmp'"
