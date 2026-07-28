const fs = require("node:fs");
const path = require("node:path");

const srcDir = "/prompts";
const dstDir = "/skills";

for (const file of fs.readdirSync(srcDir)) {
  if (!file.endsWith(".md")) continue;

  const name = path.basename(file, ".md");
  const content = fs.readFileSync(path.join(srcDir, file), "utf-8");
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  const frontmatter = match ? match[1] : "";
  const body = match ? match[2] : content;

  const skillDir = path.join(dstDir, name);
  fs.mkdirSync(skillDir, { recursive: true });
  fs.writeFileSync(
    path.join(skillDir, "SKILL.md"),
    `---\n${frontmatter ? `${frontmatter}\n` : ""}disable-model-invocation: true\n---\n${body}`,
  );
}

fs.rmSync(srcDir, { recursive: true });
