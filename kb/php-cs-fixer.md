# PHP CS Fixer

PHP tool that automatically fixes PHP code style to match a defined coding standard.

## Installation

```shell
composer require --dev friendsofphp/php-cs-fixer yiisoft/code-style
```

The cache file is stored in `/runtime` — read /kb/runtime-directory.md and make sure it's set up.

Use this `.php-cs-fixer.dist.php` as example:
```
<?php

declare(strict_types=1);
b 
use PhpCsFixer\Finder;
use PhpCsFixer\Runner\Parallel\ParallelConfigFactory;
use Yiisoft\CodeStyle\ConfigBuilder;

$finder = (new Finder())->in([
    __DIR__ . '/src',
    __DIR__ . '/tests',
]);

return ConfigBuilder::build()
    ->setCacheFile(__DIR__ . '/runtime/.php-cs-fixer.cache')
    ->setRiskyAllowed(true)
    ->setParallelConfig(ParallelConfigFactory::detect())
    ->setRules([
        '@Yiisoft/Core' => true,
        '@Yiisoft/Core:risky' => true,
    ])
    ->setFinder($finder);

```

Be sure to consider this:

- `Finder::in()` must list all PHP code in the package (src, tests, config, etc.)

Ensure `"cs-fix": "php-cs-fixer fix"` is present in composer.json scripts.


## Usage

Run `composer cs-fix` to apply.

CI: PHP CS Fixer runs together with Rector in the `rector-cs.yml` workflow, see /kb/ci.md.
