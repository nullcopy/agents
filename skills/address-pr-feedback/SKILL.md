---
name: address-pr-feedback
description: Address review feedback on a pull request by triaging each comment, committing fixes as fixup!/amend! commits, and replying on every thread. Use when asked to address, handle, or respond to PR review comments.
---

1. Read everything first: every review, inline thread, and PR comment, plus the code and any context needed to judge each one.
   ```sh
   gh pr view <n> --json headRefName,reviews,comments
   gh api repos/{owner}/{repo}/pulls/<n>/comments --paginate   # inline; thread root has in_reply_to_id null
   ```
2. Decide, per comment, whether it should be addressed. Decide all of them before changing code.
3. Not addressing: reply on the thread with the reason.
4. Addressing: make one commit per logical change.
   - `git commit --fixup=<sha>` amends the PR commit `<sha>` that introduced the code; `--fixup=amend:<sha>` also replaces its message.
   - A change touching code from several commits gets one fixup per target commit. Work with no target commit gets a normal commit.
   - Push normally; fixups never need a force-push.
   - Reply on each thread with the hash(es) that address it.
5. Reply commands:
   ```sh
   gh api repos/{owner}/{repo}/pulls/<n>/comments/<root-id>/replies -f body='<reply>'   # inline thread
   gh pr comment <n> --body '<reply>'                                                    # review body or PR comment
   ```
6. Report the commits and declined comments, and note that the fixups squash with `git rebase -i --autosquash <base>` before merge.
