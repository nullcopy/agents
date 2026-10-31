# Posting a review

Post a single review with an inline comment per finding. No standalone comments.

Compose review.json:
- event: "REQUEST_CHANGES" if any blocking finding, otherwise "APPROVE".
- body: verdict, then a scorecard of the claimed issues (each: fixed / partially fixed / not fixed), then any finding that cannot anchor inline.
- comments: one object per finding that can anchor:
  ```json
  {"path": "src/foo.go", "side": "RIGHT", "start_line": 40, "line": 42, "body": "<one finding>"}
  ```
  - line/start_line must lie inside that file's diff hunks: anchor to the nearest changed line, side RIGHT for new code, LEFT for removed code. Omit start_line for a single line.
  - A finding on lines the diff doesn't touch goes in body, not a comment.
  - One finding per comment, same brief style as the report.

Submit, then report the review URL back:
```sh
gh api repos/{owner}/{repo}/pulls/<n>/reviews --input review.json
```
