```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v yii-pi-sessions:/pi-sessions \
  -v "$HOME"/.pi/agent/models.json:/pi/models.json:ro \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```

## GitHub CLI

To use `gh` inside the container, mount a file containing a GitHub token at `/pi/github-token`,
e.g. `-v /path/to/token:/pi/github-token:ro`.

> [!warning]
> It is recommended to use a token scoped with read-only access to only the repositories the agent needs.
