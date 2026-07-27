# Rector

PHP tool that automatically refactors PHP code: upgrades it to a target PHP version and applies configured code
quality rules.

## Installation

```shell
composer require --dev rector/rector yiisoft/code-style
```

- Ensure `"rector": "rector"` is present in composer.json scripts.
- Ensure that minimum `^1.1` version of `yiisoft/code-style` is used.

Use this `rector.php` as example:
```
<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Yiisoft\CodeStyle\Rector\SetList;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ])
    ->withPhpSets(php81: true)
    ->withSets([
        SetList::YII_CORE,
    ]);
```

Be sure to consider this:

- use minimal PHP version supported by the package
- `withPaths()` must list all PHP code in the package (src, tests, config, etc.)

## Usage

Run `composer rector` to apply.

CI: Rector runs together with PHP CS Fixer in the `rector-cs.yml` workflow, see /kb/ci.md.
