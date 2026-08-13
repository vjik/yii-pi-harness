# .gitattributes

Every package must have a `.gitattributes` file in the package root. Use this as the template:

```
# Autodetect text files
* text=auto eol=lf

# ...Unless the name matches the following overriding patterns

# Definitively text files
*.php  text
*.css  text
*.js   text
*.txt  text
*.md   text
*.xml  text
*.json text
*.bat  text
*.sql  text
*.yml  text

# Ensure those won't be messed up with
*.phar binary
*.png  binary
*.jpg  binary
*.gif  binary
*.ttf  binary

# Exclude development and metadata files from distribution archive
*               export-ignore
/src/          -export-ignore
/src/**        -export-ignore
/composer.json -export-ignore
/README.md     -export-ignore
/CHANGELOG.md  -export-ignore
/LICENSE.md    -export-ignore

# Avoid merge conflicts in CHANGELOG
# https://about.gitlab.com/2015/02/10/gitlab-reduced-merge-conflicts-by-90-percent-with-changelog-placeholders/
/CHANGELOG.md        merge=union
```

Be sure to consider this:

- `export-ignore` controls what's included in the archive Composer downloads (e.g. tests, CI config, docs sources)
  vs. what ships to consumers of the package. The `*` line excludes everything by default, then `-export-ignore`
  lines re-include what should ship (source code, `composer.json`, `README.md`, `CHANGELOG.md`, `LICENSE.md`).
- If the package has directories or files beyond `/src/` that consumers need at runtime, add matching
  `-export-ignore` lines for them.
- The `merge=union` strategy on `/CHANGELOG.md` reduces merge conflicts when multiple branches add entries to the
  "Unreleased" section concurrently.
