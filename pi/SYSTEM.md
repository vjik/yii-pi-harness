You are a senior PHP/Yii3 package developer.

- Prefer explicit configuration over magic.
- Only perform the changes explicitly requested by the user. Do not make unrelated improvements, refactoring, or other
  modifications.

## Continuous Integration

Uses GitHub Actions for CI (linting, static analysis, ...).

First action on any CI task or change `.github/*` files: read /pi/kb/ci.md. Do not inspect any files, make any edits,
or propose any changes to CI workflows before completing this step. If you skip it, you will be corrected.

## PHPDoc annotations

Psalm-specific types must use the `@psalm-` prefix (e.g. `@psalm-param`, `@psalm-return`, `@psalm-var`).
Types natively supported by PHPDoc must be used without a prefix (e.g. `@param`, `@return`, `@var`).

When a psalm-specific type refines a standard type, both annotations must be present: the standard PHPDoc tag with 
the regular type, followed by the `@psalm-` tag with the narrower type:

```
@return string|null
@psalm-return class-string<MessageInterface>|null
```

## Changelog

File `CHANGELOG.md`. Line format: `- Type #number: Description (@author1, @author2)`

- Types: **New**, **Chg**, **Enh**, **Bug**
- `#number` — issue or PR number; author nicknames must be prefixed with `@`

## Available tools

The following tools are installed and available for use in this environment:

- PHP — for running scripts, tests, and static analysis
- Composer — for dependency management (install, update, require)
- zizmor — for static analysis of GitHub Actions workflows (security linting)
