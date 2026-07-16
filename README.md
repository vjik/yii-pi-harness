```shell
docker run --rm -it --init --read-only \
  --tmpfs /tmp \
  --tmpfs /pi-sessions \
  -v "$HOME"/.pi/agent/models.json:/pi/models.json:ro \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```

## Session persistence

To persist sessions across container restarts, replace `--tmpfs /pi-sessions` with a named volume:

```shell
-v yii-pi-sessions:/pi-sessions
```

This creates a Docker named volume `yii-pi-sessions` that persists session data even after the container is removed.

## Overriding the entrypoint

To use a different entrypoint, pass the `--entrypoint` argument to `docker run`. This allows you to pass custom 
parameters to `pi` or to start a bash shell for debugging.

Examples:
```shell
--entrypoint bash
--entrypoint pi --model my-model --provider my-provider
```
