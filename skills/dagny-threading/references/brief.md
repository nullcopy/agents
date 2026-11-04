# Subagent brief

A subagent starts with no context. Include every field; omit none.

- Goal: the one outcome to produce, stated so it can be checked.
- Repo and worktree: the repository, the branch or worktree the subagent owns, and the base to start from.
- Task tracker: project name, the task's `short_id` (and UUID when needed), related notes, and its blockers.
- Linked work: the issue or PR this task maps to, by identifier and URL.
- Toolchain: the commands to build, test, and lint, and the exact verification to run before reporting done.
- Deliverable: the artifact to produce and where (commit, PR against which base, review, report).
- Boundaries: files or areas not to touch, and which other unit owns them.
- Blockers: report red CI, conflicts, unclear requirements, and decisions outside the unit back to the main thread; do not expand scope.

Collect from the subagent, not the raw tool output: the artifact URLs, the status, and any blocker.
