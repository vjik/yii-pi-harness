# Composer dependency analyser

PHP tool that detects unknown, shadow, and unused Composer dependencies.

## Installation

```shell
composer require --dev shipmonk/composer-dependency-analyser
```

Ensure `"dependency-analyser": "composer-dependency-analyser"` is present in composer.json scripts.

## Configuration

Use this `composer-dependency-analyser.php` as example:
```php
<?php

declare(strict_types=1);

use ShipMonk\ComposerDependencyAnalyser\Config\Configuration;

return (new Configuration())
    ->disableComposerAutoloadPathScan()
    ->setFileExtensions(['php'])
    ->addPathToScan(__DIR__ . '/config', isDev: false)
    ->addPathToScan(__DIR__ . '/src', isDev: false)
    ->addPathToScan(__DIR__ . '/tests', isDev: true);
```

Be sure to consider this:

- `addPathToScan()` must list all PHP code in the package (src, tests, config, etc.); mark dev-only paths
  (tests, etc.) with `isDev: true` and production paths with `isDev: false`.

PHP core classes added in a newer PHP version than the package's minimum (e.g. `SensitiveParameter`, PHP 8.2)
show up as "unknown class" when the analyser runs under an older PHP. Ignore them conditionally via
`PHP_VERSION_ID`:

```php
$config = (new Configuration())/* ... */;

if (PHP_VERSION_ID < 80200) {
    $config->ignoreUnknownClasses(['SensitiveParameter']);
}

return $config;
```

Any use of `ignore*` methods (`ignoreUnknownClasses()`, `ignoreErrorsOnPath()`, `ignoreUnknownClassesRegex()`, etc.)
must be accompanied by a comment explaining why the ignore is needed. An ignore without justification is hard to
revisit later and may hide a real problem.

```php
// SensitiveParameter is only available since PHP 8.2, ignore it on older PHP to avoid false "unknown class" errors
if (PHP_VERSION_ID < 80200) {
    $config->ignoreUnknownClasses(['SensitiveParameter']);
}
```

## Usage

Run `composer dependency-analyser` to check.

CI: runs in the `composer-dependency-analyser.yml` workflow, see /kb/ci.md.

## Documentation

Add to "internals" of package:

````markdown
## Dependencies

Use [Composer Dependency Analyser](https://github.com/shipmonk-rnd/composer-dependency-analyser) to detect unknown,
shadow, and unused [Composer](https://getcomposer.org) dependencies:

```shell
./vendor/bin/composer-dependency-analyser
```
````
