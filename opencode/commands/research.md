---
description: Multi-agent web research
---
You are running `/research`.

Topic: $ARGUMENTS

Rules:
1. Use the OpenCode QUESTION TOOL (`question`) for all user questions. Batch independent questions.
2. Ask only for missing goal, scope, constraints, or depth (`quick` or `deep`).
3. Use `research` for source discovery and verification.
4. `quick`: one `research` subagent.
5. `deep`: multiple `research` subagents in parallel with distinct scopes, then aggregate and cross-check.
6. Use `grunt` for bounded deeper synthesis when needed. The primary agent owns final judgment.
7. Prefer primary sources, include URLs, call out conflicts, and say unknown when evidence is missing.
