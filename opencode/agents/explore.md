---
description: Finds codebase files, symbols, behavior, tests, and conventions.
mode: subagent
model: opencode-go/muse-spark-1.3-contributor#xhigh
permissions:
  - { action: edit, resource: '*', effect: deny }
  - { action: glob, resource: '*', effect: allow }
  - { action: glob, resource: '~/.ssh/**', effect: deny }
  - { action: glob, resource: '~/.gnupg/**', effect: deny }
  - { action: glob, resource: '~/.aws/**', effect: deny }
  - { action: glob, resource: '~/.azure/**', effect: deny }
  - { action: glob, resource: '~/.kube/**', effect: deny }
  - { action: glob, resource: '~/.docker/**', effect: deny }
  - { action: glob, resource: '~/.config/gcloud/**', effect: deny }
  - { action: glob, resource: '~/.git-credentials', effect: deny }
  - { action: glob, resource: '~/.netrc', effect: deny }
  - { action: glob, resource: '~/.npmrc', effect: deny }
  - { action: glob, resource: '~/.pypirc', effect: deny }
  - { action: glob, resource: '~/.local/share/password-store/**', effect: deny }
  - { action: glob, resource: '~/.password-store/**', effect: deny }
  - { action: glob, resource: '~/.bash_history', effect: deny }
  - { action: glob, resource: '~/.config/zsh/zsh_history', effect: deny }
  - { action: glob, resource: '~/.zsh_history', effect: deny }
  - { action: glob, resource: '.env*', effect: deny }
  - { action: glob, resource: '**/.env*', effect: deny }
  - { action: glob, resource: '*.pem', effect: deny }
  - { action: glob, resource: '**/*.pem', effect: deny }
  - { action: glob, resource: '*.key', effect: deny }
  - { action: glob, resource: '**/*.key', effect: deny }
  - { action: glob, resource: '*.p12', effect: deny }
  - { action: glob, resource: '**/*.p12', effect: deny }
  - { action: glob, resource: '*.jks', effect: deny }
  - { action: glob, resource: '**/*.jks', effect: deny }
  - { action: glob, resource: '*credentials*', effect: deny }
  - { action: glob, resource: '**/*credentials*', effect: deny }
  - { action: grep, resource: '*', effect: allow }
  - { action: grep, resource: '.env*', effect: deny }
  - { action: grep, resource: '**/.env*', effect: deny }
  - { action: grep, resource: '*.pem', effect: deny }
  - { action: grep, resource: '**/*.pem', effect: deny }
  - { action: grep, resource: '*.key', effect: deny }
  - { action: grep, resource: '**/*.key', effect: deny }
  - { action: grep, resource: '*.p12', effect: deny }
  - { action: grep, resource: '**/*.p12', effect: deny }
  - { action: grep, resource: '*.jks', effect: deny }
  - { action: grep, resource: '**/*.jks', effect: deny }
  - { action: grep, resource: '*credentials*', effect: deny }
  - { action: grep, resource: '**/*credentials*', effect: deny }
  - { action: external_directory, resource: '/tmp/opencode', effect: allow }
  - { action: external_directory, resource: '/tmp/opencode/*', effect: allow }
  # Inherit global discovery allowances instead of asking for every shell call.
  # Interpreters have host authority; read-only behavior is an agent instruction.
  - { action: shell, resource: 'cat *', effect: allow }
  - { action: shell, resource: 'head *', effect: allow }
  - { action: shell, resource: 'tail *', effect: allow }
  - { action: shell, resource: 'echo *', effect: allow }
  - { action: shell, resource: 'printf *', effect: allow }
  - { action: shell, resource: 'test *', effect: allow }
  - { action: shell, resource: '[ *', effect: allow }
  - { action: shell, resource: ': *', effect: allow }
  - { action: shell, resource: 'true *', effect: allow }
  - { action: shell, resource: 'set *', effect: allow }
  - { action: shell, resource: 'export *', effect: allow }
  - { action: shell, resource: 'cp *', effect: allow }
  - { action: shell, resource: 'mkdir *', effect: allow }
  - { action: shell, resource: 'pdfinfo *', effect: allow }
  - { action: shell, resource: 'pdftotext *', effect: allow }
  - { action: shell, resource: 'pdftoppm *', effect: allow }
  - { action: shell, resource: 'diff *', effect: allow }
  - { action: shell, resource: 'cmp *', effect: allow }
  - { action: shell, resource: 'python3 *', effect: allow }
  - { action: shell, resource: './scripts/generate-pdf.sh *', effect: allow }
  # Explicit file-only cleanup; recursive rm remains denied by global rules.
  - { action: shell, resource: 'rm -- *', effect: allow }
  - { action: shell, resource: 'rm -f -- *', effect: allow }
  - { action: shell, resource: '*$(*', effect: deny }
  - { action: shell, resource: '*PRODUCTION*', effect: deny }
  - { action: shell, resource: '*PROD*', effect: deny }
  - { action: subagent, resource: '*', effect: deny }
  - { action: webfetch, resource: '*', effect: deny }
  - { action: websearch, resource: '*', effect: deny }
  - { action: skill, resource: '*', effect: allow }
  - { action: question, resource: '*', effect: deny }
---

Collect the codebase information requested by the delegating agent. Search and
trace only as far as needed to establish the relevant facts.

Return concise findings with file and line references. Describe observed
behavior, flow, tests, and missing context. Do not edit, design solutions, or
make recommendations.
