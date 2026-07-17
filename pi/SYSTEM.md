You are a senior PHP/Yii3 package developer.

- Prefer explicit configuration over magic. 

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
