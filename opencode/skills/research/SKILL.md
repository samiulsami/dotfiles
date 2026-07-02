---
name: research
description: Multi-agent research on any topic. Use when the user wants research, investigation, comparison, verification, codebase exploration, or evidence-backed answers.
---

# Research

Use this skill for evidence-backed research on any topic.

Rules:

1. Ask concise clarifiers for goal, scope, constraints, and output shape. Avoid redundant questions.
2. Ask required research mode unless the user already specified one: `auto`, `source-only`, `balanced`, `heavy`, or `adversarial`. Recommend `auto`.
3. Infer the right evidence source from context. For codebase questions, inspect relevant files using multiple `explore` agents in batches until you have the necessary information, then pass only necessary excerpts, paths, line numbers, conflicts, and questions into research agents. Research agents are web-only and must not be used for filesystem/codebase discovery. For web questions, prefer primary sources.
4. Always use at least one relevant subagent for research work.
5. `auto`: choose the cheapest adequate mode and state the chosen mode in the final answer.
6. `source-only`: run one or more `research-light` agents. Split independent facets across agents when useful. The main agent does the thinking from their source packs.
7. `balanced`: run two or three `research-light` agents in parallel, then seed one `research-medium` agent with the source packs for synthesis.
8. `heavy`: for broad, ambiguous, or high-stakes work, break the topic into narrower subquestions and research them in batches. Default pattern: three to five `research-light` agents, aggregate, then a targeted second batch such as two `research-light`, two `research-medium`, and one `research-heavy`, aggregate again, then one final `research-heavy` synthesis pass.
9. In `heavy`, the main agent owns aggregation between batches and carries forward source IDs, conflicts, and open gaps before spawning the next batch.
10. `adversarial`: run separate `research-medium` or `research-heavy` agents with explicitly different framings, then reconcile conflicts in the main answer.
11. Ask agent count only when the user requests manual control or the scope makes the default count unsafe. Recommend 3 light agents for `balanced`. Recommend 5 light agents as the first batch for `heavy` when the topic is broad enough to justify it.
12. When seeding a later agent, include source packs, conflicts, gaps, and the exact question to resolve.
13. Source-quality discipline is mandatory. Classify each source or claim as one of: official/primary, paper/spec, reputable reporting, review aggregate, candidate anecdote, SEO/prep content, snippet-only, inaccessible/gated/JS-limited, or user-provided context.
14. Do not let SEO/prep pages, anonymous summaries, review snippets, or search snippets carry a factual claim alone. Use them as leads or weak risk signals unless corroborated by official, primary, or repeated independent evidence.
15. For gated, JS-heavy, paywalled, auth-only, or inaccessible pages, say exactly what was inaccessible and what was actually observed: full page, excerpt, cached text, search snippet, title only, or third-party mirror.
16. Distinguish `not publicly found` from `false`. If a fact may exist only in a logged-in portal, email, screenshot, or private document, mark it as portal-only/user-provided pending evidence instead of guessing.
17. When consolidating, preserve uncertainty labels: safe fact, candidate-report-only, weak/speculative, conflict, and unknown.
18. Include URLs for factual web claims.
19. Ground codebase claims in file paths and line numbers.
20. Call out conflicts between sources plainly.
21. If evidence is missing, say unknown. Do not guess.
