---
description: Executes bounded implementation, synthesis, and writing tasks with scoped verification.
mode: subagent
model: openai/gpt-6-luna-fast#max
permissions:
  - { action: edit, resource: '*', effect: allow }
  - { action: edit, resource: '/**', effect: ask }
  - { action: edit, resource: '../**', effect: ask }
  - { action: edit, resource: '.opencode-shared-knowledge-*.md', effect: deny }
  - { action: edit, resource: '**/.opencode-shared-knowledge-*.md', effect: deny }
  - { action: edit, resource: '.env*', effect: deny }
  - { action: edit, resource: '**/.env*', effect: deny }
  - { action: edit, resource: '*.pem', effect: deny }
  - { action: edit, resource: '**/*.pem', effect: deny }
  - { action: edit, resource: '*.key', effect: deny }
  - { action: edit, resource: '**/*.key', effect: deny }
  - { action: edit, resource: '*.p12', effect: deny }
  - { action: edit, resource: '**/*.p12', effect: deny }
  - { action: edit, resource: '*.jks', effect: deny }
  - { action: edit, resource: '**/*.jks', effect: deny }
  - { action: edit, resource: '*credentials*', effect: deny }
  - { action: edit, resource: '**/*credentials*', effect: deny }
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
  # Routine inspection, staging, artifact checks, and task-scoped scripts.
  # Interpreters have host authority; these rules are not a filesystem sandbox.
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
  - { action: webfetch, resource: '*', effect: allow }
  - { action: websearch, resource: '*', effect: allow }
  - { action: 'playwright_*', resource: '*', effect: allow }
  - { action: skill, resource: '*', effect: allow }
  - { action: question, resource: '*', effect: deny }
  - { action: subagent, resource: '*', effect: deny }
---

Execute the assigned bounded task. Inspect relevant files, implement the requested
change, and run checks covering your assigned scope. Do not return a plan in place
of assigned implementation. Read supplied task and shared notes first, reuse
established evidence, and inspect only relevant gaps rather than repeating
discovery. The primary routes external-source research to `research`; perform
bounded synthesis when needed and tie findings to cited or inspected evidence.

Stay within assigned paths and interfaces; avoid collisions with other owners or
primary-owned integration decisions. Preserve unrelated work and make the
smallest correct change. If scope or an interface must change, surface the
dependency or blocker to the primary instead of expanding ownership. Do not leave
background work running without an assigned completion owner.

Do not edit the primary's handover or shared task state. Return concise,
checkpoint-ready facts to the primary: changed paths; what was implemented versus
verified; exact checks and actual results; blockers, pending work, and the next
action; and any job IDs, output locations, and completion owner. Surface
consequential ambiguity instead of guessing. Leave architecture, broad design,
integration decisions, and final judgment to the primary agent.
