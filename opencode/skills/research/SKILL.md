---
name: research
description: Evidence-backed research, investigation, comparison, verification, or codebase exploration using local and web sources.
---

# Research

Use the fewest agents and passes that can answer reliably. Default to `auto`; ask about mode only when the user requests control.

Modes:

- `auto`: invoke the cheapest adequate agent; escalate only for a concrete evidence gap or unresolved conflict.
- `source-only`: use one `research-light` agent per independent facet, normally one.
- `balanced`: use `research-medium` directly; add one or two light agents first only for broad parallel retrieval.
- `heavy`: use `research-heavy` directly; seed it with two or three light agents only when breadth or conflicting evidence justifies it.
- `adversarial`: run two medium or heavy agents with different framings, then reconcile once.

Rules:

1. Ask clarifying questions only when needed to avoid researching the wrong question.
2. Research agents may inspect workspace files and use LSP. Choose local, web, or mixed evidence from the task.
3. Parallelize only independent facets. Aggregate at most once by default and stop when evidence answers the question.
4. Pass later agents the relevant evidence IDs, conflicts, gaps, and exact question; do not make them rediscover settled evidence.
5. Preserve local citations as `[L#] path:line`, web citations as `[S#] URL`, and uncertainty or access caveats.
6. If findings must be persisted, delegate the exact target file and scope; do not permit unrelated code changes.
7. State the selected mode in the final answer.
