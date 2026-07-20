---
description: Replacing StyleCI to PHP CS Fixer
---

# Replace StyleCI to PHP CS Fixer

- Remove `composer.lock` and `.styleci.yml` 
- Read /kb/php-cs-fixer.md and follow it to install and configure PHP CS Fixer.
- Read /kb/rector.md and follow it to configure Rector.
- Read /kb/ci.md and set up `.github/workflows/rector-cs.yml` (remove the old `rector.yml` workflow, if present).
- Run `composer rector` and `composer cs-fix`.
- Warn the user that they need to disable the repository in the StyleCI.
