# github-lookup-next-id

Finds the number that the next PR or issue created in the repository will get — the
number that goes into a `CHANGELOG.md` entry (e.g. `Enh #334: ...`).

The tool walks `https://github.com/<owner>/<repo>/issues/<id>/` with HEAD requests and
returns the first `id` for which GitHub responds with `404` — that is the next free
number. The repository is taken from `git remote origin`, so run it from inside the
repository's working tree.

## Usage

1. Find the highest number already used in `CHANGELOG.md`:
   ```bash
   grep -rhoE '#[0-9]+' CHANGELOG.md | tr -d '#' | sort -n | tail -1
   ```
2. Run the tool in the git repository directory, passing that number as the optional
   `startId`:
   ```bash
   github-lookup-next-id [startId]
   ```
3. Read the result. The last line of the output is:
   ```
   Next ID — 334
   ```
   The number after `Next ID —` is the next change number.
