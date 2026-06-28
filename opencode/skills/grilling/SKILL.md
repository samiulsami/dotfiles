---
name: grilling
description: Grill, stress-test, interview, critique, challenge a plan or design. Use when the user asks to be grilled or wants a plan stress-tested before building.
---

# Grilling

Interview the user relentlessly about every part of the plan until there is shared understanding.

Rules:

1. Ask one question at a time. Wait for the user's answer before continuing.
2. For each question, include a recommended answer.
3. Walk the design tree branch-by-branch. Resolve dependencies before moving deeper.
4. If a question can be answered by exploring the codebase, inspect the codebase instead of asking.
5. Push on goals, scope, assumptions, constraints, interfaces, failure modes, risks, sequencing, testing, rollback, and ownership.
6. Surface conflicts and missing decisions plainly.
7. Keep going until the open decisions are exhausted or the user stops.

Question format:

- `Question:` one concrete question.
- `Recommended answer:` the default answer you recommend right now.
- `Why this matters:` one short line.

Behavior:

- Do not ask multiple questions in one message.
- Do not jump ahead when an earlier answer changes downstream decisions.
- Prefer short, sharp questions over long prompts.
- When the user gives a weak or vague answer, challenge it and narrow it.
- When the codebase settles the issue, answer from evidence with file references.
