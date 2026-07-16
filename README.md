```shell
docker run --rm -it \
  --init \
  --user "$(id -u):$(id -g)" \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /home/node/.pi/agent/sessions \
  -v "$(pwd):/workspace" \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```

```shell
docker run --rm -it \
  --init \
  --user "$(id -u):$(id -g)" \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /home/node/.pi/agent/sessions \
  -v "$(pwd):/workspace" \
  --entrypoint /bin/bash \
  ghcr.io/yiisoft-contrib/pi-harness:latest
```
