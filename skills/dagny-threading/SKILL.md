---
name: dagny-threading
description: Thread work from Dagny by keeping the main thread on planning and prioritisation while a background subagent executes each task or independent task-group. Use when working from a Dagny board.
---

1. Plan on the main thread; do not execute there. Read the board and decide what matters:
   - projects and their linked repos (`list_projects`, `list_project_repos`)
   - unblocked, high-value work and its order (`get_priority_tasks`, `list_tasks`)
   - dependencies and blockers to resolve before delegating (`get_task`, `list_transitions`)
   Stop at the point where the next action is real work.

2. Split the plan into units. One unit is a task, or a group of tasks that touch no shared files and can run at the same time.

3. Give every unit its own worktree or branch before spawning it. Two subagents must never share a worktree, branch, or files.

4. Spawn one background subagent per unit with full standalone context. A fresh subagent knows nothing, so the brief carries everything it needs. Use the template in `references/brief.md`.

5. Require subagents to report blockers instead of expanding scope. Red CI, a merge conflict, an unclear brief, or a decision that is not theirs comes back as a blocker; the main thread decides.

6. Stay productive while subagents run. Do next-step planning and non-overlapping work on the main thread; keep its context small by leaving heavy reading, building, and long tool output inside the subagents.

7. Verify each result against its brief before accepting it, and reconcile overlapping or conflicting output yourself.

8. Own the outcome on the main thread:
   - collect the artifacts (PR, review, and issue URLs)
   - update task status and dependencies as work lands (`update_task`, `update_note`)
   - report what shipped, what is still running, and every blocker
