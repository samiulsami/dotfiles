---
name: grilling
description: Grill, stress-test, interview, critique, challenge a plan or design. Use when the user asks to be grilled or wants a plan stress-tested before building.
---

# Grilling

Stress-test a plan until its decisions, assumptions, risks, and acceptance criteria are clear enough to execute.

Rules:

1. Ask one question at a time. Wait for the user's answer before continuing.
2. For each question, include a recommended answer.
3. Walk the design tree branch-by-branch. Resolve dependencies before moving deeper.
4. If the codebase can answer a question, delegate the factual lookup to `explore` instead of asking the user or searching directly.
5. Delegate current external facts to `research-light`; use `research-medium` only for explicitly requested deep research or unavoidable delegated reasoning.
6. Ask only questions that require a user decision; do not ask for discoverable facts.
7. Push on goals, scope, assumptions, constraints, interfaces, failure modes, risks, sequencing, testing, rollback, and ownership.
8. Surface conflicts and missing decisions plainly.
9. Stop when the plan is executable, the user stops, or all remaining uncertainty is explicitly accepted.

Question format:

- `Question:` one concrete question.
- `Recommended answer:` the default answer you recommend right now.
- `Why this matters:` one short line.

Behavior:

- Do not ask multiple questions in one message.
- Do not jump ahead when an earlier answer changes downstream decisions.
- Prefer short, sharp questions over long prompts.
- When the user gives a weak or vague answer, challenge it and narrow it.
- When evidence settles an issue, state the conclusion with file or web references instead of asking.
- At completion, return a concise decision record with settled choices, accepted assumptions, and acceptance criteria.
