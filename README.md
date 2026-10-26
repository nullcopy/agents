# agents

Skills and instructions for every agent.

- `skills/<name>/SKILL.md`: skills in the open [Agent Skills](https://agentskills.io) format, loaded on demand.
- `AGENTS.md`: guidelines every agent loads in every session. Keep it short.

## Setup

```sh
git clone https://github.com/nullcopy/agents ~/src/agents
~/src/agents/install.sh
```

`install.sh` symlinks `skills/` into `~/.agents/skills` (Codex, Gemini CLI, Copilot, Cursor, OpenCode) and `~/.claude/skills` (Claude Code), and `AGENTS.md` into each agent's global instructions file. Existing files are moved to `*.bak`; move anything worth keeping into this repo.

Update: `git -C ~/src/agents pull`

## Layout

```
skills/<name>/
  SKILL.md       # required: frontmatter + short instructions
  references/    # optional: detail, loaded only when SKILL.md points to it
  scripts/       # optional: code run, not read
```

To add or edit a skill, ask your agent to use the `skill-author` skill.
