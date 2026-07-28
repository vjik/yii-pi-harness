## Pi

```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v "$HOME"/.config/yii-harness/pi:/pi \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```

Before first use, run `/opt/pi/prepare.sh` once against the mounted config directory:

```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v "$HOME"/.config/yii-harness/pi:/pi \
  ghcr.io/yiisoft-contrib/pi-harness:latest \
  /opt/pi/prepare.sh
```

## Claude Code

```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v "$HOME"/.config/yii-harness/claude-code:/claude-code \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/claude-code-harness:latest
```

Before first use, run `/opt/claude-code/prepare.sh` once against the mounted config directory:

```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v "$HOME"/.config/yii-harness/claude-code:/claude-code \
  ghcr.io/yiisoft-contrib/claude-code-harness:latest \
  /opt/claude-code/prepare.sh
```

## GitHub CLI

To use `gh` inside the container, mount a file containing a GitHub token at `/opt/ai-harness/github-token`.
This is the same path for every agent image.

```
-v "$HOME"/.config/yii-harness/github-token:/opt/ai-harness/github-token:ro \
```

> [!warning]
> It is recommended to use a token scoped with read-only access to only the repositories the agent needs.

## Proxy

To route the agent's network traffic through a local proxy, add `--add-host` so the container can reach
the host, and pass the proxy URL via `HTTP_PROXY`/`HTTPS_PROXY`:

```
-e HTTP_PROXY=http://host.docker.internal:1080 \
-e HTTPS_PROXY=http://host.docker.internal:1080 \
--add-host=host.docker.internal:host-gateway 
```
