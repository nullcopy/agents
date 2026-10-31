---
name: review
description: Review a pull request by verifying each claimed issue is actually fixed, judging the design against the codebase, checking safety and correctness, and flagging new functions that duplicate existing ones. Use when asked to review a PR.
---

1. Read everything before judging anything:
   ```sh
   gh pr view <n> --json title,body,headRefName,baseRefName
   gh pr diff <n>
   gh pr checkout <n>   # to read code in context
   ```

2. Claimed issues: list every issue the PR claims to address — fixes/closes/resolves references in the body plus anything its commits point to.
   - Read each issue in full, comments included, until you can state why the pre-PR code fails and what a correct fix must change.
   - For each, confirm the diff fixes the root cause and every condition the issue reports, not just the example given. Where feasible, verify with a check that fails on the base and passes on the PR.
   - An unfixed or partially fixed claimed issue is a blocking finding.

3. Design: judge the change as part of the codebase it lands in. Right layer and module; consistent with neighboring patterns and naming; no new API, dependency, or abstraction the codebase doesn't need. If a simpler design fits, suggest it with reasons.

4. Safety and correctness — verify in the code, never take the PR description's word:
   - failure paths: errors surfaced, resources released, nothing silently swallowed
   - edge cases: empty/zero/nil, boundaries, off-by-one, overflow, input encodings
   - concurrency: shared state, ordering, partial failure
   - external input: injection, path traversal, auth and privilege boundaries
   - existing callers and stored data: behavior changes, migrations, compatibility
   - tests: for a bug fix they fail on the base; they cover the failure mode, not only the happy path

5. Duplication: for each new function, search the codebase for an existing equivalent before accepting it.
   - Search by the operation's name and synonyms, by inputs and outputs, and by what its callers needed; also compare within the PR itself.
   - If an existing function fits, or generalizes to fit, the finding is to reuse or extend it instead of rewriting.

6. Report findings in the conversation: each with `file:line`, what is wrong, and the smallest concrete fix. Group blocking (unfixed claim, correctness, safety) above suggestions (design, duplication, tests). Brief and direct.

7. Ask whether to post the review on GitHub. If yes, follow `references/posting.md` — one review, an inline comment per finding, request changes if anything is blocking, approve otherwise.
