---
description: Upgrading a project to PHPUnit 10 usage
---

# Update to PHPUnit 10

**IMPORTANT**
- Strictly follow the instructions given.
- Perform the final actions with the commands at the very end after everything else is done.

## Prepare composer.json

- Get actual version of PHPUnit 10 by command:
```shell
composer show --all phpunit/phpunit | grep "^versions" | tr ',' '\n' | grep -E '^\s*10\.[0-9]+\.[0-9]+\s*$' | sort -V | tail -1
```
- Use this version in `composer.json`.
- Make sure that `composer.json` contains script `"test": "phpunit --display-deprecations",`

## Configure cache

- Make sure that `/runtime` directory exists and is in it `.gitignore` with content:
```
*
!.gitignore

```

- Cleanup `/.gitignore`. for PHPUnit, there should **only** be:
```
# Local PHPUnit config  
/phpunit.xml
```

- Configure cache in `phpunit.xml.dist` via `cacheDirectory="runtime/.phpunit.cache"`
- Remove `/.phpunit.result.cache` if exist

## Prepare configuration

- Make sure that config contains:
    - `xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"`
    - `xsi:noNamespaceSchemaLocation="vendor/phpunit/phpunit/phpunit.xsd"`
    - `displayDetailsOnPhpunitDeprecations="true"`
- Replace tag `<coverage>` to `<source>`

## Prepare tests

- Replace PHPUnit annotations to attributes, e.g. `#dataProvider` to `#[DataProvider()]`

## Final actions

- Update composer dependencies `composer update -W`
- Check PHPUnit config `vendor/bin/phpunit --configuration phpunit.xml.dist --list-tests 1>/dev/null`
- Run test `composer test`
