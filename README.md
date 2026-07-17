```shell
docker run --rm -it --init --read-only \
  --user "$(id -u):$(id -g)" \
  --tmpfs /tmp \
  -v ~/.yii-pi:/pi \
  -v "$(pwd)":/workspace \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```
