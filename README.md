```shell
docker run --rm -it --init --read-only \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp \
  --tmpfs /pi-sessions \
  -v "$HOME"/.pi/agent/models.json:/pi/models.json:ro \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```

## Overriding the entrypoint

To use a different entrypoint, pass the `--entrypoint` argument to `docker run`. This allows you to pass custom 
parameters to `pi` or to start a bash shell for debugging.

Examples:
```shell
--entrypoint bash
--entrypoint pi --model my-model --provider my-provider
```
