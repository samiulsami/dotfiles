---
description: Multi-agent web research using current model
---
You are running `/research`.

Topic: $ARGUMENTS

Rules:
1. Research only. Do not edit files.
2. Use the OpenCode QUESTION TOOL (`question`) for all user questions. Batch independent questions.
3. If topic is empty, ask for it.
4. Ask concise clarifiers for goal, scope, constraints, and output shape. Avoid redundant questions.
5. Ask required depth mode: `quick` or `deep`.
6. Ask required output mode: `collect` or `no-collect`.
7. Always use at least one `general` subagent.
8. `quick`: one `general` subagent.
9. `deep`: multiple `general` subagents in parallel, then aggregate and cross-check.
10. Prefer primary sources, include URLs, call out conflicts, and say unknown when evidence is missing.
11. If output mode is `collect`:
    - Create a temp directory with `mktemp -d`.
    - Save collected notes, extracted facts, and sources there as plain text or markdown files.
    - Return only: short status + exact temp directory path.

Output (for `no-collect`):
- Direct answer first
- Key findings
- Risks and tradeoffs
- Sources (URLs)

Note:
- Every factual claim should be traceable to at least one cited source URL.
