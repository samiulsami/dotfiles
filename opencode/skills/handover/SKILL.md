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
research, delegation, or implementation. If no path is given, search project task
records, including `.opencode/tasks`, before creating one. Reuse the task
identity and path; ask if multiple records could match. Follow project
conventions, including for first creation. Otherwise use
`.opencode/tasks/<short-task-slug>/handover.md`; do not create parallel records
or overwrite unrelated content.

The primary owns the record; delegates return findings rather than editing it.
Respect scope and read-only restrictions. If writes are unavailable, provide an
explicitly unsaved checkpoint in the response; never imply it was persisted or
gain write authority. For a requested pause, save state and stop; otherwise
continue authorized work.

## Checkpoint lifecycle

- Before each substantial batch, save its plan, scopes, owners, dependencies or
  order, acceptance checks, and exact next action. Do not begin the next batch
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
  handling; say none when there is no active job.
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

Mark done only when acceptance is fulfilled and requested follow-ups are
completed or explicitly cancelled. Mark task cancellation separately. Clear next
actions for closed work. A new user request can reopen it; an old checklist
cannot. Keep verification gaps explicit and follow project retention rules
without automatically deleting records or evidence. At handoff, report the
record's path and next action, or state that the checkpoint is unsaved.
