---
name: research
description: Evidence-backed external research, investigation, comparison, or verification using web sources.
---

# Research

MUST delegate all external research and web verification. The primary agent does not use web lookup tools directly.

Routing:

- Use `research-light` for source retrieval and straightforward factual checks.
- Use `research-medium` when the delegated question requires synthesis, comparison, uncertainty analysis, or conflict resolution.
- Launch independent research facets concurrently. Do not split dependent questions or duplicate delegated work.
- The primary agent owns final synthesis, recommendations, and decisions.

Rules:

1. Ask clarifying questions only when needed to avoid researching the wrong question.
2. Start with sources supplied by the user. Prefer official docs, specifications, primary sources, and papers.
3. Delegate local codebase discovery separately to `explore`; research agents handle external evidence.
4. Preserve web citations as `[S#] URL` and identify inference, conflicts, weak evidence, unknowns, and access caveats.
5. Prefer Wigolo for discovery and multi-source retrieval. Use `webfetch` for exact known URLs and `websearch` when Wigolo is unavailable or degraded.
6. Delegate focused verification as another research task rather than using web tools from the primary agent.
7. Stop when evidence answers the question; otherwise say what remains unknown.
