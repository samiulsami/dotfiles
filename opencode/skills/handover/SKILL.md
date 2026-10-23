---
name: handover
description: Use only when the user explicitly requests a handover, checkpoint, or handoff workflow; asks to resume from a handover; or asks for continuity across explicitly requested long multi-session work. Complexity, scope growth, costly reconstruction, or an existing handover alone do not trigger use. Requests to edit or discuss this skill do not trigger use.
---

# Handover

Invoke only after an explicit user request for a handover, checkpoint, or handoff
workflow; resumption from a handover; or continuity for explicitly requested
long multi-session work. Inferred complexity, scope growth, costly reconstruction,
or the mere presence of a handover is not a request. Requests to edit or discuss
this skill do not activate it.

## Establish the record

For explicitly requested handover work, create or locate the single canonical
handover, read it, and save a current initial checkpoint before substantive
research, delegation, or implementation. An explicit path or project convention
takes precedence, including for first creation. Otherwise search existing project
task records, such as `tasks/` and `.opencode/tasks/`, before creating one. Reuse
the task identity and path; ask if multiple records could match. Only when no
record or project convention exists, use
`.opencode/tasks/<short-task-slug>/handover.md`. Never create parallel records or
overwrite unrelated content.

The primary owns the record; delegates return findings rather than editing it.
Respect scope and read-only restrictions. If writes are unavailable, provide an
explicitly unsaved checkpoint in the response; never imply it was persisted or
gain write authority. For a requested pause, save state and stop; otherwise
continue authorized work.

## Plan and dispatch useful work

Keep one main-owned handover, not one per agent. Decompose the deliverable, not
the checkpoint. Keep stable architecture in the existing brief and detailed
evidence in its existing task-local home; the handover links directly to these.

Before implementation, settle the end-to-end acceptance path and interfaces at
the depth the task needs. Identify the next dependency-ready deliverables, the
critical path, shared resources, and which work can proceed independently. Do
not replan settled architecture or reread unrelated history at every checkpoint.

Give each worker an outcome, exact read/write scope, input identity, dependencies,
non-goals, allowed commands/resources, acceptance checks and completion owner.
Include real boundary behavior and error cases, not only a list of files. Use
fresh workers for independent tasks and reuse them for coherent corrections.
Workers return concise evidence: changed paths, implemented versus verified,
actual check results, unresolved failures, and any descendant/job identities.
Do not require a new helper, adapter, receipt file or planning document per task
when an existing tool, result message or evidence record is sufficient.

Parallelize independent ownership and useful checks within a primary-set active
worker/resource budget. Avoid both one overloaded worker and tiny delegations
whose coordination costs exceed their work. The primary can inspect and accept
an independent completed result while others run; there is no global batch
barrier. Do not review files another worker is still changing or claim dependent
integration before its prerequisites are accepted. Keep shared-file edits and
shared-environment mutations sequential.

### Optional bounded second-level delegation

Prefer flat primary-managed fan-out. A coordinator is useful only for a sizeable,
cohesive subtree with separable leaf work and enough synthesis to reduce primary
load or critical-path delay. It does not gain architectural or acceptance authority.

Before planning nested work, verify the effective depth limit and each named
agent's own tool permissions; children do not inherit the parent's restrictions.
Prompt scope is not an access-control boundary. Do not change configuration or
permissions implicitly to make a delegation succeed.

The primary assigns the full subtree scope, named leaf scopes, shared interfaces,
allowed tools/resources and output, reserving its share of the global worker
budget for coordinator and leaves before launch. A child launch needs a free
reserved slot; do not let a waiting coordinator consume all capacity for its leaves.
Allow at most two delegation edges: primary → coordinator → leaf. Leaves cannot
delegate; the coordinator and leaves count against the same global active-worker
budget as direct workers. No overlapping ownership, unowned jobs or implicit
expansion. If tools or permissions do not support this, flatten the same work
under the primary; do not bypass denials or claim nesting was exercised.

The coordinator reports child IDs/scopes and completion ownership promptly,
checks leaf evidence and returns an integrated result with remaining gaps. It
does not edit the canonical handover, shared instructions or task authority.
The primary records the subtree lineage, inspects its actual deliverable and
evidence, and alone accepts integration. A pause, cancellation or restart must
account for all descendants; a missing parent reply does not prove they stopped.
Treat unknown-status owners/descendants as potentially live. Do not reassign their
write scopes until quiescence is established; continue only non-overlapping work.

## Verify boundaries before expensive work

Workers run only permitted cheap checks for their scope before returning. Project
execution restrictions take precedence: a syntax/static-check allowance does not
authorize runtime imports, tests, network calls or native mutations. Assign the
real-boundary canary's execution owner before dependent work; where the project
reserves tests/native execution to the primary, that canary is primary-owned.
If commands are prohibited or the environment is unavailable, mark checks unrun
and route the explicit gap to their owner.
Do not treat permissive mocks, a worker's confidence or a file-count proof as
integration acceptance. Keep trust-boundary validation intact.

Run a small real-boundary canary before building a large dependent implementation
or starting a long run when that boundary is new or changed. Then integrate all
accepted prerequisites and run consolidated affected checks. Batch related fixes
by root cause rather than rerunning the expensive workflow after each small edit.
Reuse saved evidence and retained state for diagnosis; replay side effects only
when justified and authorized. Freeze/stage immutable inputs when checks require
them, not after each worker; promote only exact inputs with required acceptance.
Invalidate only evidence affected by changed inputs.

Each long or shared-environment run has one execution/completion owner, input
identity, output path and resource claim. Other workers may prepare or inspect
independent artifacts but must not mutate those inputs or that environment.
Use tool completion events. When an execution tool needs a foreground wait, use
its supported completion mechanism; do not poll progress, sleep-loop, or add a
receipt-file watcher for an agent that already sends completion notifications.

## Checkpoint lifecycle

- Before each substantial batch, save its plan, scopes, owners, dependencies or
  order, acceptance checks, and exact next action. A batch is a cohesive ready
  set, not a barrier across unrelated deliverables. Do not begin the next batch
  while the canonical state is stale.
- After launching a worker or other tracked job, record the returned worker/run
  ID, output location, and who will collect and handle its completion. Record a
  failed launch or say there is no active job when applicable.
- After accepting worker or research results, and after verification, update
  from actual artifacts and evidence. Distinguish what is implemented from what
  is verified; record checked inputs, commands/results where relevant, remaining
  or deferred work, owner, and exact next action.
- Promptly update decisions, scope, blockers, and deferred or one-shot requests
  when they change; retain each request's trigger, state, and review budget.
- Before another batch, a planned pause, final response, or handoff, reconcile
  the record with current files, evidence, and job state and refresh anything
  stale. A final summary does not substitute for a writable durable record.

Save at these meaningful boundaries, not after every tool call. If read-only or
unavailable writes prevent persistence, report the checkpoint as unsaved and
continue only within authorized work.

## Keep current state useful

Reconstruct mid-task state from actual artifacts and evidence. Mark unknowns;
do not invent history or rerun expensive work just to fill the note. Include:

- Goal, acceptance conditions, constraints, and important decisions.
- Updated time and status: active, blocked, paused, cancelled, or done.
- What is implemented versus verified; a dependency-ordered remaining checklist.
  Distinguish completed prerequisites from pending follow-ups.
- Any deferred user requests or one-shot commitments: trigger, state (deferred,
  running, or fulfilled), and review budget already used.
- Concrete blockers and unresolved questions.
- Evidence links identifying which inputs were checked.
- Current owner and any running job's identity, output location, and completion
  handling, including delegated descendants; say none when there is no active job.
- The exact next action.

At checkpoints, replace superseded status and avoid transcripts. Mark
verification stale when relevant inputs change. Resume prompts should point here
without copying current status. External evidence does not authorize work.

## Control growth

At phase boundaries and before handoff, prune duplicate prose and stale status.
Near 200 readable lines, or whenever current state gets buried, reorganize before
adding detail. This is a soft review trigger; never compress prose or remove
essential context to meet it.

Keep the resume-critical state listed above in the handover. Move detailed
design, investigations, completed history, and bulky evidence into focused
task-local files. Reuse existing sources; avoid per-update files and index chains.
Link each source directly with a relative path, its contents, and when to read it:

```markdown
[Verification](evidence/verification.md): checked inputs, commands, and results;
read before repeating acceptance checks.
```

Write and verify the destination and link before pruning unique detail. Keep one
authoritative home for each fact. Supporting files hold detail, not competing
current status. Active blockers stay visible in the handover. Pruning summary
text does not authorize deleting evidence or task artifacts.

## Resume and finish

Read required project instructions and the handover, then only supporting files
needed for the next action or stale assumptions. Reconcile current user intent,
files, checked inputs, results, and job liveness. Preserve partial outputs;
establish what happened before replaying interrupted side effects. Record job
state as unknown when it cannot be checked within your authority.

Consume delivered completion events and inspect the associated artifact before
waiting or launching a replacement. Do not recreate completed work merely
because a shell, parent worker or conversation was interrupted. A resumed session
must be able to identify the current critical path without reconstructing a
transcript or following a chain of historical indexes.

Mark done only when acceptance is fulfilled and requested follow-ups are
completed or explicitly cancelled. Mark task cancellation separately. Clear next
actions for closed work. A new user request can reopen it; an old checklist
cannot. Keep verification gaps explicit and follow project retention rules
without automatically deleting records or evidence. At handoff, report the
record's path and next action, or state that the checkpoint is unsaved.
