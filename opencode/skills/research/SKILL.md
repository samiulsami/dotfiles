---
name: research
description: Multi-agent research on any topic. Use when the user wants research, investigation, comparison, verification, codebase exploration, or evidence-backed answers.
---

# Research

Use this skill for evidence-backed research on any topic.

Rules:

1. Use the OpenCode `question` tool for all user questions. Batch only independent clarifiers.
2. Ask concise clarifiers for goal, scope, constraints, and output shape. Avoid redundant questions.
3. Infer the right evidence source from context. For codebase questions, inspect the relevant codebase first. For web questions, prefer primary sources.
4. Ask required depth mode: `quick` or `deep`.
5. If `deep`, ask how many subagents to use. Recommend 3 unless scope says otherwise.
6. Always use at least one relevant subagent.
7. `quick`: use one relevant subagent.
8. `deep`: use the requested number of relevant subagents in parallel, then aggregate and cross-check.
9. Include URLs for factual web claims.
10. Ground codebase claims in file paths and line numbers.
11. Call out conflicts between sources plainly.
12. If evidence is missing, say unknown. Do not guess.
