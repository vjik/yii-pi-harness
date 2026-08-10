#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: run <agent> [options]

Agents:
  pi           Pi Coding Agent
  claude       Claude Code

Options:
  --prepare                  Run the agent's prepare script instead of starting it
  --local-proxy PORT         Route traffic through a local proxy on the host at the given port
  --browser-debug-port PORT  Connect chrome-devtools-mcp to a Chrome instance remote-debugging
                             on the host at the given port
  --dry-run                  Print the docker run command instead of executing it
  -h, --help                 Show this help
EOF
}

agent=""
prepare=0
local_proxy_port=""
browser_debug_port=""
dry_run=0

while [ $# -gt 0 ]; do
  case "$1" in
    --prepare)
      prepare=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --local-proxy=*)
      local_proxy_port="${1#*=}"
      shift
      ;;
    --local-proxy)
      if [ $# -lt 2 ]; then
        echo "run: --local-proxy requires a PORT argument" >&2
        exit 1
      fi
      local_proxy_port="$2"
      shift 2
      ;;
    --browser-debug-port=*)
      browser_debug_port="${1#*=}"
      shift
      ;;
    --browser-debug-port)
      if [ $# -lt 2 ]; then
        echo "run: --browser-debug-port requires a PORT argument" >&2
        exit 1
      fi
      browser_debug_port="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "run: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [ -n "$agent" ]; then
        echo "run: unexpected argument: $1" >&2
        exit 1
      fi
      agent="$1"
      shift
      ;;
  esac
done

if [ -z "$agent" ]; then
  echo "run: agent is required" >&2
  usage >&2
  exit 1
fi

case "$agent" in
  pi)
    config_dir="pi"
    mount_target="/pi"
    image="ghcr.io/yiisoft-contrib/pi-harness:latest"
    prepare_cmd="/opt/pi/prepare.sh"
    ;;
  claude)
    config_dir="claude"
    mount_target="/claude"
    image="ghcr.io/yiisoft-contrib/claude-harness:latest"
    prepare_cmd="/opt/claude/prepare.sh"
    ;;
  *)
    echo "run: unknown agent: $agent" >&2
    usage >&2
    exit 1
    ;;
esac

config_root="$HOME/.config/yii-harness"

if [ ! -d "$config_root" ]; then
  echo "run: creating $config_root" >&2
  mkdir -p "$config_root"
fi

if [ ! -d "$config_root/$config_dir" ]; then
  echo "run: creating $config_root/$config_dir" >&2
  mkdir -p "$config_root/$config_dir"
fi

docker_args=(
  --rm -it --init --read-only
  -e PUID="$(id -u)"
  -e PGID="$(id -g)"
  --tmpfs /tmp
  -v "$config_root/$config_dir:$mount_target"
)

if [ "$prepare" -eq 0 ]; then
  docker_args+=(-v "$(pwd):/workspace")

  if [ -f "$config_root/github-token" ]; then
    docker_args+=(-v "$config_root/github-token:/opt/ai-harness/github-token:ro")
  fi
fi

if [ -n "$local_proxy_port" ]; then
  docker_args+=(
    -e "HTTP_PROXY=http://host.docker.internal:$local_proxy_port"
    -e "HTTPS_PROXY=http://host.docker.internal:$local_proxy_port"
    --add-host=host.docker.internal:host-gateway
  )
  need_host_gateway=1
fi

if [ -n "$browser_debug_port" ]; then
  # Chrome's remote-debugging server rejects requests whose Host header isn't
  # an IP or "localhost" (DNS-rebinding protection), so host.docker.internal
  # itself doesn't work here — resolve it to the host-gateway IP up front and
  # use that instead.
  host_gateway_ip="$(docker run --rm --add-host=host.docker.internal:host-gateway --entrypoint getent "$image" hosts host.docker.internal | awk '{print $1}')"
  if [ -z "$host_gateway_ip" ]; then
    echo "run: failed to resolve host.docker.internal to an IP" >&2
    exit 1
  fi
  docker_args+=(-e "CHROME_DEVTOOLS_MCP_BROWSER_URL=http://$host_gateway_ip:$browser_debug_port")
fi

docker_args+=("$image")

if [ "$prepare" -eq 1 ]; then
  docker_args+=("$prepare_cmd")
fi

if [ "$dry_run" -eq 1 ]; then
  printf 'docker run'
  printf ' %q' "${docker_args[@]}"
  printf '\n'
  exit 0
fi

exec docker run "${docker_args[@]}"
