---
name: skill-author
description: Create or edit a skill in the nullcopy/agents repo. Use when asked to write, add, or improve an agent skill.
---

Write `skills/<name>/SKILL.md` in the nullcopy/agents repo. If its location is unclear, ask.

Rules (token budget matters; every skill's description is loaded into every session):
- Frontmatter: only `name` (kebab-case, matches folder) and `description`. Other fields are dropped by some agents.
- `description`: one sentence, what it does plus when to use it. No filler.
- Body: under ~100 lines. Imperative steps, no background or motivation.
- Detail an agent needs only sometimes goes in `references/<topic>.md`, linked from the body with when to read it.
- Deterministic work goes in `scripts/`; tell the agent to run the script, not read it.
- Agent-neutral: no tool names or paths specific to one agent unless the skill is for that agent.
- One skill per job. Prefer editing an existing skill over adding a near-duplicate.

Commit with a message naming the skill.
