---
description: Finds codebase files, symbols, behavior, tests, and conventions.
mode: subagent
model: opencode-go/deepseek-v4-flash
variant: high
permission:
  edit: deny
  glob:
    "*": allow
    "~/.ssh/**": deny
    "~/.gnupg/**": deny
    "~/.aws/**": deny
    "~/.azure/**": deny
    "~/.kube/**": deny
    "~/.docker/**": deny
    "~/.config/gcloud/**": deny
    "~/.git-credentials": deny
    "~/.netrc": deny
    "~/.npmrc": deny
    "~/.pypirc": deny
    "~/.local/share/password-store/**": deny
    "~/.password-store/**": deny
    "~/.bash_history": deny
    "~/.config/zsh/zsh_history": deny
    "~/.zsh_history": deny
    ".env*": deny
    "**/.env*": deny
    "*.pem": deny
    "**/*.pem": deny
    "*.key": deny
    "**/*.key": deny
    "*.p12": deny
    "**/*.p12": deny
    "*.jks": deny
    "**/*.jks": deny
    "*credentials*": deny
    "**/*credentials*": deny
  grep:
    "*": allow
    ".env*": deny
    "**/.env*": deny
    "*.pem": deny
    "**/*.pem": deny
    "*.key": deny
    "**/*.key": deny
    "*.p12": deny
    "**/*.p12": deny
    "*.jks": deny
    "**/*.jks": deny
    "*credentials*": deny
    "**/*credentials*": deny
  list:
    "*": allow
    "~/.ssh/**": deny
    "~/.gnupg/**": deny
    "~/.aws/**": deny
    "~/.azure/**": deny
    "~/.kube/**": deny
    "~/.docker/**": deny
    "~/.config/gcloud/**": deny
    "~/.git-credentials": deny
    "~/.netrc": deny
    "~/.npmrc": deny
    "~/.pypirc": deny
    "~/.local/share/password-store/**": deny
    "~/.password-store/**": deny
    "~/.bash_history": deny
    "~/.config/zsh/zsh_history": deny
    "~/.zsh_history": deny
    ".env*": deny
    "**/.env*": deny
    "*.pem": deny
    "**/*.pem": deny
    "*.key": deny
    "**/*.key": deny
    "*.p12": deny
    "**/*.p12": deny
    "*.jks": deny
    "**/*.jks": deny
    "*credentials*": deny
    "**/*credentials*": deny
  bash: deny
  task: deny
  webfetch: deny
  websearch: deny
  "wigolo_*": deny
  lsp: allow
  skill: deny
  question: deny
  todowrite: deny
---

Collect the codebase information requested by the delegating agent. Search and
trace only as far as needed to establish the relevant facts.

Return concise findings with file and line references. Describe observed
behavior, flow, tests, and missing context. Do not edit, design solutions, or
make recommendations.
