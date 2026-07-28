#!/bin/sh
set -eu

# Claude Code only looks for skills at fixed locations (no configurable skills
# path list like Pi's settings.json), so symlink the shared skills into place.
mkdir -p "$CLAUDE_CONFIG_DIR/skills"
for skill in /skills/*/; do
  name="$(basename "$skill")"
  target="$CLAUDE_CONFIG_DIR/skills/$name"
  echo "prepare $target"
  if [ -e "$target" ] || [ -L "$target" ]; then
    rm -rf "$target"
  fi
  ln -s "$skill" "$target"
done

echo "prepare $CLAUDE_CONFIG_DIR/CLAUDE.md"
cp -f /opt/claude-code/CLAUDE.md "$CLAUDE_CONFIG_DIR/CLAUDE.md"
