---
description: Multi-agent web research using current model
---
You are running `/research`.

Topic: $ARGUMENTS

Rules:
1. Use the OpenCode QUESTION TOOL (`question`) for all user questions. Batch independent questions.
2. If topic is empty, ask for it.
3. Ask concise clarifiers for goal, scope, constraints, and output shape. Avoid redundant questions.
4. Ask required depth mode: `quick` or `deep`.
5. Always use at least one `general` subagent.
6. `quick`: one `general` subagent.
7. `deep`: multiple `general` subagents in parallel, then aggregate and cross-check.
8. Prefer primary sources, include URLs, call out conflicts, and say unknown when evidence is missing.
9. If the collected data is relatively big, or if the user asks to persist data:
    - Create a temp directory with `mktemp -d`.
    - Save collected notes, extracted facts, and sources there as plain text or markdown files.
    - Return only: short status + exact temp directory path.

Note:
- Every factual claim should be traceable to at least one cited source URL.
