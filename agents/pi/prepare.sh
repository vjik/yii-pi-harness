#!/bin/sh
set -eu

pi install npm:pi-subagents-lite@1.4.10

SETTINGS_FILE="$PI_CODING_AGENT_DIR/settings.json" node -e '
const fs = require("node:fs");
const file = process.env.SETTINGS_FILE;
const settings = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file, "utf-8") || "{}") : {};
const defaults = {
  prompts: "/prompts",
  extensions: "/opt/pi/extensions",
  skills: "/skills",
};
for (const [key, dir] of Object.entries(defaults)) {
  const list = Array.isArray(settings[key]) ? settings[key] : [];
  if (!list.includes(dir)) list.push(dir);
  settings[key] = list;
}
fs.writeFileSync(file, JSON.stringify(settings, null, 2) + "\n");
'

cp -f /opt/pi/SYSTEM.md "$PI_CODING_AGENT_DIR/SYSTEM.md"
cp -f /opt/pi/trust.json "$PI_CODING_AGENT_DIR/trust.json"
