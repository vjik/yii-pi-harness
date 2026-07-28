---
description: Removing Scrutinizer from the project
---

# Removing Scrutinizer

- Remove `.scrutinizer.yml`
- Remove `/.scrutinizer.yml export-ignore` from `.gitattributes`
- Remove `Scrutinizer Code Quality` badge from `README.md`
- Replace `Code Coverage` badge in `README.md` and substitute %PACKAGE_NAME% with the actual package name:
```
[![Code Coverage](https://codecov.io/gh/yiisoft/%PACKAGE_NAME%/branch/master/graph/badge.svg)](https://codecov.io/gh/yiisoft/%PACKAGE_NAME%)
```
- Tell the user to remove the Scrutinizer webhook from the repository settings on GitHub.
