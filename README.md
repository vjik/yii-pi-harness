## Runner script

Agents are started with `run.sh`:

```shell
# start agents
./run.sh pi              
./run.sh claude

# prepare local configuration of agents
./run.sh pi --prepare
./run.sh claude --prepare

# route traffic through a local proxy on the host
./run.sh pi --local-proxy=1080

# point chrome-devtools-mcp at Chrome running on the host
./run.sh claude --browser-debug-port=9223  

# override the container timezone (default: Europe/Moscow)
./run.sh claude --timezone=America/New_York
```

It mounts `$HOME/.config/yii-harness/claude` or `$HOME/.config/yii-harness/pi` as the agent's
config directory, and `$HOME/.config/yii-harness/github-token` if it exists (see [GitHub CLI](#github-cli)).

Run `./run.sh --help` for the full list of options.

## GitHub CLI

To use `gh` inside the container, put a file containing a GitHub token at
`$HOME/.config/yii-harness/github-token`; `run.sh` mounts it automatically.

> [!warning]
> It is recommended to use a token scoped with read-only access to only the repositories the agent needs.

## Proxy

To route the agent's network traffic through a local proxy on the host, use `--local-proxy`:

```shell
./run.sh claude --local-proxy=1080
```

## Timezone

The image defaults to the `Europe/Moscow` timezone. To use a different one, pass `--timezone`:

```shell
./run.sh claude --timezone=America/New_York
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
