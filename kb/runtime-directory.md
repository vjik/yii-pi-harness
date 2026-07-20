# Runtime Directory

The `/runtime` directory in the package root is used to store caches and other temporary files (e.g. PHPUnit
cache).

- It must contain `.gitignore` with content:
```
*
!.gitignore

```
- Only create the `/runtime` directory when there is an explicit instruction to do so.
