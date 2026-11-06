---
name: trigger-zallet-integration-tests
description: Trigger zcash/zallet integration tests for a fork-based PR via a same-repo draft throwaway PR, then close and delete it once the tests start.
---

# Trigger integration tests for a zallet fork PR

`zcash/zallet`'s `Trigger integration tests` workflow needs the
`DISPATCH_APP_ID` and `DISPATCH_APP_PRIVATE_KEY` secrets to dispatch a run in
`zcash/integration-tests`. GitHub withholds those secrets from `pull_request`
runs whose head branch is in a fork, so a fork PR cannot dispatch the tests.
Run the same commit from a branch in `zcash/zallet` instead.

Requires write access to `zcash/zallet` and an authenticated `gh`.

## Procedure

Set `PR` to the original PR number:

```sh
PR=913
BRANCH="trigger-integration-tests-$PR"
```

1. Fetch the exact PR head from the base repository. `pull/<PR>/head` resolves
   fork heads too:

   ```sh
   git fetch origin "pull/$PR/head"
   ```

   Confirm it is the commit under review:

   ```sh
   test "$(git rev-parse FETCH_HEAD)" = \
     "$(gh pr view "$PR" -R zcash/zallet --json headRefOid --jq .headRefOid)"
   ```

2. Push that commit to a branch in `zcash/zallet`. Do not rebase, squash, or
   merge it; the throwaway PR must carry the original head.

   ```sh
   git push origin "FETCH_HEAD:refs/heads/$BRANCH"
   ```

   If the branch already exists from an earlier attempt, close and delete that
   attempt first rather than force-pushing.

3. Open a draft PR against the original PR's base branch (normally `main`):

   ```sh
   gh pr create -R zcash/zallet --draft --base main --head "$BRANCH" \
     --title "DNM! integration test trigger PR for #$PR" \
     --body "DO NOT MERGE!
   This PR exists solely to trigger integration tests for #$PR, whose branch lives in a fork and cannot read the dispatch secrets."
   ```

   If the run needs a branch or SHA of `zcash/integration-tests`, add a
   `ZIT-Revision: <ref>` line to the body. Add the same line to the original
   PR's body if you can edit it: the trigger reads the body of the first PR
   matching the head SHA, which need not be the throwaway one.

4. Wait for the trigger job to succeed, then identify the dispatched run:

   ```sh
   gh run list -R zcash/zallet --workflow integration.yml --branch "$BRANCH" --limit 1
   gh run watch <run-id> -R zcash/zallet --exit-status

   gh run list -R zcash/integration-tests --event repository_dispatch --limit 5
   ```

   The dispatched run is named `CI`, has display title `zallet-interop-request`,
   and its head SHA is `zcash/integration-tests` main. Identify it by creation
   time (seconds after the trigger job), not by SHA. The trigger skips diffs
   that touch only docs, other workflows, licensing, or supply-chain tooling.

5. As soon as the dispatched run is `in_progress`, close the draft PR and
   delete its branch. The run is independent of the PR and continues.

   ```sh
   gh run view <run-id> -R zcash/integration-tests --json status,url
   gh pr close <throwaway-PR> -R zcash/zallet --delete-branch
   ```

   Then follow the run to completion and copy its URL to the original PR:

   ```sh
   gh run watch <run-id> -R zcash/integration-tests --exit-status
   ```

6. To test another revision, repeat from step 1 with a new throwaway PR.

Never merge the throwaway PR. That would land the commits without the original
PR's review and merge path.
