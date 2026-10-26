---
name: address-pr-feedback
description: Address review feedback on a pull request by triaging each comment, committing fixes as fixup!/amend! commits, replying on every thread, then autosquashing and force-pushing. Use when asked to address, handle, or respond to PR review comments.
---

1. Read everything first: every review, inline thread, and PR comment, plus the code and any context needed to judge each one.
   ```sh
   gh pr view <n> --json headRefName,baseRefName,reviews,comments
   gh api repos/{owner}/{repo}/pulls/<n>/comments --paginate   # inline; thread root has in_reply_to_id null
   ```
2. Decide, per comment, whether it should be addressed. Decide all of them before changing code.
3. Not addressing: reply on the thread with the reason.
4. Addressing: make one commit per logical change.
   - `git commit --fixup=<sha>` amends the PR commit `<sha>` that introduced the code; `--fixup=amend:<sha>` also replaces its message.
   - A change touching code from several commits gets one fixup per target commit. Work with no target commit gets a normal commit.
   - Push normally before replying, so the linked hashes exist on the remote.
   - Reply on each thread with the hash(es) that address it.
5. Reply commands:
   ```sh
   gh api repos/{owner}/{repo}/pulls/<n>/comments/<root-id>/replies -f body='<reply>'   # inline thread
   gh pr comment <n> --body '<reply>'                                                    # review body or PR comment
   ```
6. After every thread has its reply, squash the fixups into their targets without moving the base, then force-push:
   ```sh
   git fetch origin <baseRefName>
   GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "$(git merge-base origin/<baseRefName> HEAD)"
   git push --force-with-lease
   ```
   On a conflict, resolve it and `git rebase --continue`. If it can't be resolved cleanly, run `git rebase --abort` and report instead of pushing.
7. Report the fixup commits linked in replies, the squashed history, and the declined comments.
