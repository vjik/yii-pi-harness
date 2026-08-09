# Changelog

[IMPORTANT] Only add entries for changes affecting production code. This also includes changes to `composer.json`
sections that affect production code (e.g. `require`). Changes to tests, CI, dev tooling, or other non-production files 
must not be recorded in the changelog. 

File `CHANGELOG.md`. Entries are grouped under a version heading:

```
## [Version] - [Date or "under development"]

- Type #number: Description (@author1, @author2)
```

- Types: **New** (novel features), **Chg** (general modifications), **Enh** (improvements to existing
  functionality), **Bug** (defect fixes)
- Within a version section, order entries by type: New, Chg, Enh, Bug
- `#number` — issue or PR number; author nicknames must be prefixed with `@`
- Multiple issue/PR numbers may be listed for one entry, separated by commas (e.g. `#number1, #number2`)
- To find the number for `#number`: first check whether a PR already exists for the current branch
  (e.g. `gh pr view --json number -q .number`); if it does, use that PR's number. Otherwise, find the next free issue/PR
  number by reading /kb/tools/github-lookup-next-id.md
- If the file has no "under development" version section, add a new one at the top (right after the `# Changelog`
  heading, before any existing version sections)
