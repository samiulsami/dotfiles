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

Note:
- Every factual claim should be traceable to at least one cited source URL.
