## Runner script

`run.sh` wraps the `docker run` invocations below into a single command:

```shell
# start agents
./run.sh pi              
./run.sh claude

# prepare local configuration of agents
./run.sh pi --prepare

# route traffic through a local proxy on the host
./run.sh pi --local-proxy=1080

# point chrome-devtools-mcp at Chrome running on the host
./run.sh claude --browser-debug-port=9223  
```

It mounts `$HOME/.config/yii-harness/claude` or `$HOME/.config/yii-harness/pi` as the agent's
config directory, and `$HOME/.config/yii-harness/github-token` if it exists (see [GitHub CLI](#github-cli)).

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
  -v "$HOME"/.config/yii-harness/claude:/claude \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/claude-harness:latest
```

Before first use, run `/opt/claude/prepare.sh` once against the mounted config directory:

```shell
docker run --rm -it --init --read-only \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  --tmpfs /tmp \
  -v "$HOME"/.config/yii-harness/claude:/claude \
  ghcr.io/yiisoft-contrib/claude-harness:latest \
  /opt/claude/prepare.sh
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

## Chrome DevTools MCP

The Claude Code image ships `chrome-devtools-mcp`, registered as an MCP server named `chrome-devtools`. Start
Chromium on the host with remote debugging enabled so the agent can drive it:

```shell
chromium \
  --remote-debugging-port=9222 \
  --profile-directory="MCP Profile" \
  --user-data-dir=/tmp/chromium-mcp/
```

To make the port reachable from the container, forward it with [socat](http://www.dest-unreach.org/socat/):

```shell
socat TCP-LISTEN:9223,fork,reuseaddr TCP:127.0.0.1:9222
```

> [!warning]
> This exposes full, unauthenticated control of that browser to anything that can reach the forwarded port,
> so only run it on a trusted network / firewalled host.

Then point the container at the forwarded port:

```shell
./run.sh claude --browser-debug-port=9223
```
