---
name: grilling
description: Stress-tests plans and designs when a user asks to be grilled.
---

# Grilling

Stress-test a plan until its decisions, assumptions, risks, and acceptance
criteria are clear enough to execute.

Rules:

1. Batch independent questions in parallel.
2. Ask one question at a time only when its answer changes the next question.
3. For each question, include a recommended answer.
4. Resolve dependencies before descending the design tree branch by branch.
5. Use `explore` for discoverable codebase facts before asking the user.
6. Delegate current external facts to `research`.
7. Use `grunt` only for requested deep research or essential synthesis.
8. Ask only for user decisions, not facts agents can discover.
9. Challenge goals, scope, assumptions, constraints, interfaces, and risks.
10. Challenge failure modes, sequencing, testing, rollback, and ownership.
11. Surface conflicts and missing decisions plainly.
12. Stop when the plan is ready, the user stops, or uncertainty is accepted.

Question format:

- `Question:` one concrete question.
- `Recommended answer:` the default answer you recommend right now.
- `Why this matters:` one short line.

Behavior:

- Group independent questions in one message or question batch.
- Do not jump ahead when an earlier answer changes downstream decisions.
- State when a question is a dependency that needs an answer before the next
  branch.
- Prefer short, sharp questions over long prompts.
- When the user gives a weak or vague answer, challenge it and narrow it.
- When evidence settles an issue, cite the file or web source instead of asking.
- At completion, return settled choices, assumptions, and acceptance criteria.
- Keep related sentences in short paragraphs.
- Start a new paragraph when the topic or action changes.
- Use lists for distinct items.
