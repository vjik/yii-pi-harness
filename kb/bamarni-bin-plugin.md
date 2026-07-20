# Bamarni Bin Plugin

`bamarni/composer-bin-plugin` isolates dev-only PHP tools (psalm, infection, phpstan, rector, ...) into their own
`tools/<name>/composer.json`, so their dependency constraints don't conflict with the root `composer.json`. Typical
reason: a tool's constraints block raising the project's PHP version range, or the tool ships a plugin
(`infection/extension-installer`, ...) that shouldn't pollute the root `composer.json`.

[IMPORTANT] Only extract a tool into its own `tools/<name>/` folder when there is a direct instruction to do so.

## Setup (if not already present)

Check the root `composer.json` for `bamarni/composer-bin-plugin` in `require-dev`, an `extra.bamarni-bin` block,
and a `tools/` folder with `tools/.gitignore`. If any is missing, add them.

- install:
```shell
composer require --dev bamarni/composer-bin-plugin
```
- `extra`:
```json
"bamarni-bin": {
    "bin-links": true,
    "target-directory": "tools",
    "forward-command": true
}
```
- `config.allow-plugins`:
```json
"bamarni/composer-bin-plugin": true
```
- `tools/.gitignore`:
```
/*/vendor
/*/composer.lock
```

## Adding or extracting a tool

- One folder per tool: `tools/<name>/` (e.g. `tools/psalm/`, `tools/infection/`), each with its own
  `composer.json` containing the tool in `require-dev` and any of its plugin allowances under
  `config.allow-plugins`.
- If the tool currently lives in the root `composer.json`, remove it — and its plugin allowances — from there.
- If the user hasn't named the tool(s) explicitly, ask before proceeding.

Example `tools/infection/composer.json`:
```json
{
    "require-dev": {
        "infection/infection": "^0.29.8 || ^0.31.9"
    },
    "config": {
        "allow-plugins": {
            "infection/extension-installer": true
        }
    }
}
```

## Verify

- Run `composer update` in the root — it installs each `tools/*/` subfolder. To re-sync one tool only, run
  `composer bin <name> update`.
- Confirm the binary works: `vendor/bin/<tool> --version`.

## Don't

- Don't extract `phpunit` — it's tightly coupled to the project.
- Don't leave a tool's plugin allowance (e.g. `infection/extension-installer`) in the root `composer.json` after
  moving the tool out.
- Don't bundle multiple unrelated tools into the same `tools/<name>/composer.json`.
