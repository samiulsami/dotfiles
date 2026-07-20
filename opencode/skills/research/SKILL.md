---
name: research
description: Evidence-backed research, investigation, comparison, verification, or codebase exploration using local and web sources.
---

# Research

Default to `auto`; ask about mode only when the user requests control. MUST delegate to a research subagent before using research tools unless absolutely certain the entire task needs at most one or two searches.
Use `research-light` freely and in parallel, `research-medium` selectively, and `research-heavy` only when the task demands it or the user requests it.

Modes:

- `auto`: invoke the cheapest adequate agent; escalate only for a concrete evidence gap or unresolved conflict.
- `source-only`: use `research-light` agents for each independent facet.
- `balanced`: use `research-medium` directly; add one or two light agents first only for broad parallel retrieval.
- `heavy`: gather evidence with light or medium agents, then give the collected evidence to one `research-heavy` agent for final audit.
- `adversarial`: gather independent evidence or analyses with light or medium agents, then give both framings to one `research-heavy` agent for reconciliation.

Rules:

1. Ask clarifying questions only when needed to avoid researching the wrong question.
2. Research agents may inspect workspace files and use LSP. Choose local, web, or mixed evidence from the task.
3. Parallelize only independent facets. If heavy research is warranted, use one heavy-agent session per task and stop when evidence answers the question.
4. Pass the heavy agent the exact question plus relevant evidence, citations, conflicts, and gaps; do not ask it to rediscover settled evidence.
5. If the heavy agent requests more information, delegate its specific gaps to light or medium agents, then resume the same heavy-agent task with their findings.
6. Preserve local citations as `[L#] path:line`, web citations as `[S#] URL`, and uncertainty or access caveats.
7. If findings must be persisted, delegate the exact target file and scope; do not permit unrelated code changes.
8. State the selected mode in the final answer.
9. Prefer Wigolo for web discovery, multi-source retrieval, and repeated research. Crawl only when the task requires site-wide evidence. Use `webfetch` for exact content from a known URL and `websearch` when Wigolo is unavailable or degraded.
