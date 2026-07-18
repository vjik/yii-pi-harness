---
description: Replacing StyleCI to PHP CS Fixer
---

# Replace StyleCI to PHP CS Fixer

- Install PHP CS Fixer and Yii Code Style:
```shell
rm composer.lock && composer require --dev friendsofphp/php-cs-fixer yiisoft/code-style
```
- Remove `.styleci.yml`.
- Add to end of `.gitignore` (don't forget empty line before and after): 
```
# PHP CS Fixer  
/.php-cs-fixer.cache
```
- Add `.php-cs-fixer.dist.php` to root:
```
<?php

declare(strict_types=1);

use PhpCsFixer\Finder;
use PhpCsFixer\Runner\Parallel\ParallelConfigFactory;
use Yiisoft\CodeStyle\ConfigBuilder;

$finder = (new Finder())->in([
    __DIR__ . '/src',
    __DIR__ . '/tests',
]);

return ConfigBuilder::build()
    ->setRiskyAllowed(true)
    ->setParallelConfig(ParallelConfigFactory::detect())
    ->setRules([
        '@Yiisoft/Core' => true,
        '@Yiisoft/Core:risky' => true,
    ])
    ->setFinder($finder);

```
- Remove `rector.yml`.
- Add `rector-cs.yml` with reusable action:
```
uses: yiisoft/actions/.github/workflows/rector-cs.yml@master
with:
	php: '8.1'
```
- Ensure `"cs-fix": "php-cs-fixer fix"` and `"rector": "rector"` in composer.json scripts.
- Use this `rector.php` as example (adopt to minimal PHP version in package):
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
- Run `composer rector` and `composer cs-fix`.
- Warn the user that they need to disable the repository in the StyleCI.
