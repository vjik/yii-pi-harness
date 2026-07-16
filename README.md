```shell
docker run --rm -it \
  --init \
  --user "$(id -u):$(id -g)" \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /home/node/.pi/agent/sessions \
  -v "$(pwd):/workspace" \
  -v "$HOME/.pi/agent/models.json:/home/node/.pi/agent/models.json:ro" \
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
