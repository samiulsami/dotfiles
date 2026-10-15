---
name: council
description: Run the user's three-model opencode-go council only when explicitly requested and its start condition is met. Defer "after pending tasks" requests until that work and its required checks finish. Review independently, adjudicate findings, and fix only within the requested scope.
---

# Council review

An ordinary or adversarial review request alone does not authorize a council.
The user must specifically request this skill or a council review.

## Honor the requested timing

For "after pending tasks," identify the work meant at request time. Finish it
and its required checks before loading this skill or launching reviewers. The
council and its fixes are not prerequisites. Blocked or unverified work is not
done; report the blocker. If loaded early, continue prerequisite work without
starting reviewers. Follow later user changes to scope or timing.

Track the request as deferred, running, or fulfilled in the existing task plan
or handover when writable; otherwise use the conversation. Record reviewer
session IDs while running and reconcile them on resume before launching more.
Run one wave per request unless the user authorizes more. After that wave,
adjudicate, make authorized fixes, run relevant checks, and mark the request
fulfilled so it is not replayed. "Once and fix" does not authorize another wave.

## Set the scope and roster

Identify the target, requirements, acceptance checks, and whether fixes are
authorized. Reference projects are context, not edit targets.

Use these three reviewers through `opencode-go`, unless the user overrides them:

- MiMo 2.6 Flash: `opencode-go/mimo-v2.6-flash`.
- DeepSeek 4.1 Flash: `opencode-go/deepseek-v4.1-flash#max`.
- Muse Spark 1.3 Contributor: `opencode-go/muse-spark-1.3-contributor#xhigh`.

Verify IDs and the highest supported effort with the models tool, filtering to
`opencode-go` and using `all: true` for these pinned versions. The default catalog
can omit an available pinned model. Never guess effort suffixes. MiMo currently
exposes no selector: preserve default thinking and report that limitation.
Honor user effort overrides. Do not substitute providers or models without
authorization; report unavailable reviewers and reduced coverage. Additional
reviewers require authorization, not merely a desire for more opinions.

## Run independent reviews

Prepare a small shared packet: exact paths and content hashes, or an immutable
snapshot; requirements; permitted read/tool scope; relevant context; checks run;
known limitations. Each reviewer gets the same baseline, without others' findings
or a preferred verdict. Keep reviewed files stable during the wave. Reviewers
identify the baseline they read; check for changed inputs before accepting
live-file findings.

Launch one fresh `grunt` per model in parallel, using the verified selectors.
Reviewers stay within the supplied read/tool scope: no edits, project workflow
execution, nested delegation, or extra model calls. They inspect relevant files
and suggest checks; the primary owns executing checks with side effects.

Ask for actual correctness, regression, recovery, scope, verification, and
unnecessary-complexity issues. Vary review emphasis without restricting what
real defects each reviewer may report. Each finding needs a location, failing
scenario, evidence, impact, and smallest fix. Separate unknowns from findings;
reject invented requirements, speculative features, and style-only churn.
If there are no findings, say `No findings.`

## Adjudicate and verify

Wait for completion notifications; do not poll. Check resolved model/variant
metadata after completion when available; distinguish observed selection from
unverified requests. Report failures and mismatches.

The primary deduplicates findings and inspects the relevant files and evidence.
Accept, reject, or leave each material finding unresolved with a concrete reason;
reproduce when feasible. Agreement is not proof; one supported finding outweighs
a majority opinion.

Apply only supported, authorized fixes. Keep overlapping edits sequential, review
actual changes, and run focused checks. Stay within the requested review budget;
do not repeat reviews to seek consensus. Report completed reviewers and observed
settings, findings and fixes, verification, and unresolved gaps.
