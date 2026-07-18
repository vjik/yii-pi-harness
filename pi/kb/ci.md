# Package GitHub Workflows

- Do not look for examples in other packages, just follow these instructions
- Use `zizmor --persona auditor` to check workflows, ignore the `unpinned-uses` error for `yiisoft/*` actions.
  This rule is already enforced centrally in `yiisoft/actions/.github/workflows/zizmor.yml`, so
  flagging it again here is redundant.

## Common to all

- Paths must be specified for triggers.
- Whitelists must be used for paths.
- Path must contain workflow file
- Paths must include only paths that are tracked by git and that actually exist.
- If a workflow contains multiple triggers with the same paths, YAML anchors should be used.
- If there is a `push` trigger, it should only run on the `master` branch.
- `permissions` must be specified.
- `concurrency` must be specified:
```
concurrency:
	group: ${{ github.workflow }}-${{ github.ref }}
	cancel-in-progress: true
```
- Order of directives: name, on, permissions, concurrency

## bc.yml

- Must be present for released packages
- Triggers: pull_request, push
- Paths: production code, bc-check config, composer.json
- Use maximum PHP version supported by the package

If your package has BC violations that should be ignored, create .roave-backward-compatibility-check.xml in the project
root. Otherwise, the file is not needed. Format:

```xml
<roave-bc-check xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="vendor/roave/backward-compatibility-check/Resources/schema.xsd">
    <baseline>
        <ignored-regex>#regex pattern here#</ignored-regex>
    </baseline>
</roave-bc-check>
```


## build.yml

- Triggers: pull_request, push
- Paths: production code, tests, phpunit config, composer.json
- If reusable workflow "yiisoft/actions/.github/workflows/phpunit.yml" is used, CodeCov token must be passed via secrets.
```
secrets:
    CODECOV_TOKEN: ${{ secrets.CODECOV_TOKEN }}
```

## composer-require-checker.yml

- Triggers: pull_request, push
- Paths: production code, tests, composer.json, composer-require-checker.json

## mutation.yml

- Triggers: pull_request, push
- Paths: production code, tests, phpunit and infection configs, composer.json

## rector-cs.yml

- Triggers: pull_request
- Paths: production code, tests, rector and PHP CS Fixer configs, composer.json
- Job permission "contents: write" must be added, if "yiisoft/actions/.github/workflows/rector-cs.yml" used

## static.yml

- Triggers: pull_request, push
- Paths: production code, psalm config, composer.json

## zizmor.yml

- Must be present.
- Content must be:
```
name: GitHub Actions Security Analysis with zizmor 🌈  
  
on:  
  pull_request:  
    paths: &paths  
      - '.github/**.yml'  
      - '.github/**.yaml'  
  push:  
    branches: ['master']  
    paths: *paths  
  
permissions:  
  actions: read # Required by zizmor when reading workflow metadata through the API  
  contents: read # Required to read workflow files  
  
concurrency:  
  group: ${{ github.workflow }}-${{ github.ref }}  
  cancel-in-progress: true  
  
jobs:  
  zizmor:  
    uses: yiisoft/actions/.github/workflows/zizmor.yml@master
```
