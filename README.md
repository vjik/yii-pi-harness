```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v "$HOME"/.config/yii-pi-harness:/pi \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```

## Preparing Pi

Before first use (and whenever you want to refresh plugins and default settings), run `/opt/prepare-pi.sh`
once against the mounted config directory:

```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v "$HOME"/.config/yii-pi-harness:/pi \
  ghcr.io/yiisoft-contrib/pi-harness:latest \
  /opt/prepare-pi.sh
```

It installs extensions, copies the default `SYSTEM.md` and `trust.json`, and
merges the default prompts/extensions/skills directories into `settings.json`.

## GitHub CLI

To use `gh` inside the container, mount a file containing a GitHub token at `/pi/github-token`,
e.g. `-v /path/to/token:/pi/github-token:ro`.

> [!warning]
> It is recommended to use a token scoped with read-only access to only the repositories the agent needs.
