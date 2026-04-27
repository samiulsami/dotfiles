---
description: Multi-agent web research using current model
---
You are running `/research`.

Topic: $ARGUMENTS

Rules:
1. Use the OpenCode QUESTION TOOL (`question`) for all user questions. Batch independent questions.
2. Ask concise clarifiers for goal, scope, constraints, and output shape. Avoid redundant questions.
3. Ask required depth mode: `quick` or `deep`.
4. Always use at least one `general` subagent.
5. `quick`: one `general` subagent.
6. `deep`: multiple `general` subagents in parallel, then aggregate and cross-check.
7. Prefer primary sources, include URLs, call out conflicts, and say unknown when evidence is missing.
