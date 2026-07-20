# Rector

PHP tool that automatically refactors PHP code: upgrades it to a target PHP version and applies configured code
quality rules.

## Installation

```shell
composer require --dev rector/rector
```

Ensure `"rector": "rector"` is present in composer.json scripts.

Use this `rector.php` as example (adopt to minimal PHP version supported by the package):
```
<?php

declare(strict_types=1);

use Rector\CodeQuality\Rector\Class_\InlineConstructorDefaultToPropertyRector;
use Rector\Config\RectorConfig;
use Rector\Php74\Rector\Closure\ClosureToArrowFunctionRector;
use Rector\Php81\Rector\Property\ReadOnlyPropertyRector;
use Rector\Php81\Rector\FuncCall\NullToStrictStringFuncCallArgRector;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ])
    ->withPhpSets(php81: true)
    ->withRules([
        InlineConstructorDefaultToPropertyRector::class,
    ])
    ->withSkip([
        ClosureToArrowFunctionRector::class,
        ReadOnlyPropertyRector::class,
        NullToStrictStringFuncCallArgRector::class,
    ]);
```

`withPaths()` must list all PHP code in the package.

## Usage

Run `composer rector` to apply.

CI: Rector runs together with PHP CS Fixer in the `rector-cs.yml` workflow, see /kb/ci.md.
