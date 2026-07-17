```shell
docker run --rm -it --init --read-only \
  --tmpfs /tmp \
  -e PUID="$(id -u)" \
  -e PGID="$(id -g)" \
  -v yii-pi-sessions:/pi-sessions \
  -v "$HOME"/.pi/agent/models.json:/pi/models.json:ro \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```
