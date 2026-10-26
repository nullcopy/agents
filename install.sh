#!/bin/sh
# Links skills/ and AGENTS.md into each agent's user config. Existing non-link targets are moved to <target>.bak.
R=$(cd "$(dirname "$0")" && pwd)

link() {
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak"; fi
  ln -sfn "$1" "$2"
}

for d in ~/.agents/skills ~/.claude/skills; do link "$R/skills" "$d"; done
for f in ~/.claude/CLAUDE.md ~/.codex/AGENTS.md ~/.gemini/GEMINI.md \
  ~/.config/opencode/AGENTS.md ~/.copilot/copilot-instructions.md; do
  link "$R/AGENTS.md" "$f"
done
