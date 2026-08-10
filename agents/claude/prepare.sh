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
cp -f /opt/claude/CLAUDE.md "$CLAUDE_CONFIG_DIR/CLAUDE.md"

# Pre-approve reading /kb/*.md files without asking, whether via the Read
# tool or common shell commands run directly against /kb.
echo "prepare $CLAUDE_CONFIG_DIR/settings.json"
SETTINGS_FILE="$CLAUDE_CONFIG_DIR/settings.json" node -e '
const fs = require("node:fs");
const file = process.env.SETTINGS_FILE;
const settings = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file, "utf-8") || "{}") : {};
settings.permissions ??= {};
const allow = Array.isArray(settings.permissions.allow) ? settings.permissions.allow : [];
const rules = [
  "Read(//kb/**)",
  "Bash(cat /kb/*)",
  "Bash(head /kb/*)",
  "Bash(tail /kb/*)",
  "Bash(find /kb*)",
  "Bash(ls /kb*)",
  "Bash(yamllint *)",
  "Bash(zizmor *)",
  "Bash(github-lookup-next-id *)",
];
for (const rule of rules) {
  if (!allow.includes(rule)) allow.push(rule);
}
settings.permissions.allow = allow;
settings.permissions.defaultMode ??= "auto";
fs.writeFileSync(file, JSON.stringify(settings, null, 2) + "\n");
'

# Register the Chrome DevTools MCP server (installed globally in the image)
# at user scope, so it is available without an interactive `claude mcp add`.
echo "prepare $CLAUDE_CONFIG_DIR/.claude.json"
CONFIG_FILE="$CLAUDE_CONFIG_DIR/.claude.json" node -e '
const fs = require("node:fs");
const file = process.env.CONFIG_FILE;
const config = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file, "utf-8") || "{}") : {};
config.mcpServers ??= {};
config.mcpServers["chrome-devtools"] = {
  type: "stdio",
  command: "chrome-devtools-mcp",
  args: ["--no-usage-statistics", "--browser-url", "${CHROME_DEVTOOLS_MCP_BROWSER_URL:-}"],
};
fs.writeFileSync(file, JSON.stringify(config, null, 2) + "\n");
'
