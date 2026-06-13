---
description: Multi-agent web research using current model
argument-hint: <topic>
---
You are running `/research`.

Topic: $ARGUMENTS

Rules:
1. Ask concise clarifiers for goal, scope, constraints, and output shape using the `ask question` tool. Avoid redundant questions.
2. Ask required depth mode: `quick` or `deep`.
3. Prefer Exa MCP tools for web discovery and retrieval unless the user specifies otherwise.
4. `quick`: use one research-capable subagent.
5. `deep`: use multiple research-capable subagents in parallel, then aggregate and cross-check.
6. Prefer primary sources, include URLs, call out conflicts, and say unknown when evidence is missing.
