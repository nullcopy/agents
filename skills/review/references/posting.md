# Posting a review

Post a single review. Every finding is an inline comment on the code; the review body carries none.

Compose review.json:
- event: "REQUEST_CHANGES" (NACK) if any blocking finding, otherwise "APPROVE" (ACK).
- body: one line naming the reviewed commit and the verdict, nothing else — e.g. `Reviewed 0aedfa8371c9e1090ea697e5767fa6e830e6355a — ACK`. No scorecard, no summary, no findings.
- comments: one object per finding:
  ```json
  {"path": "src/foo.go", "side": "RIGHT", "start_line": 40, "line": 42, "body": "<one finding>"}
  ```
  - line/start_line must lie inside that file's diff hunks: anchor to the nearest changed line, side RIGHT for new code, LEFT for removed code. Omit start_line for a single line.
  - A finding the diff doesn't touch still gets a comment: anchor it to the nearest changed line and name the line it concerns in the comment body. Findings never go in the review body.
  - One finding per comment, same brief style as the report.

Submit, then report the review URL back:
```sh
gh api repos/{owner}/{repo}/pulls/<n>/reviews --input review.json
```
