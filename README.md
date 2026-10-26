# skills

Skills for every agent. Each skill is `skills/<name>/SKILL.md` in the open [Agent Skills](https://agentskills.io) format.

## Setup

```sh
git clone https://github.com/nullcopy/skills ~/src/skills
# ~/.agents: Codex, Gemini CLI, Copilot, Cursor, OpenCode. ~/.claude: Claude Code.
for d in ~/.agents/skills ~/.claude/skills; do
  mkdir -p "${d%/*}"
  [ -e "$d" ] && [ ! -L "$d" ] && mv "$d" "$d.bak"  # move skills you want to keep into ~/src/skills/skills
  ln -sfn ~/src/skills/skills "$d"
done
```

Update: `git -C ~/src/skills pull`

## Layout

```
skills/<name>/
  SKILL.md       # required: frontmatter + short instructions
  references/    # optional: detail, loaded only when SKILL.md points to it
  scripts/       # optional: code run, not read
```

To add or edit a skill, ask your agent to use the `skill-author` skill.
