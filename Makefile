.DEFAULT_GOAL := help

IMAGE_PI := ghcr.io/yiisoft-contrib/pi-harness

build-pi: ## Build the Pi docker image
	docker build --target pi -t $(IMAGE_PI) -f docker/Dockerfile .

hadolint: ## Run hadolint on the Dockerfile
	docker run --rm -i hadolint/hadolint < docker/Dockerfile

help: ## This help.
	@awk 'BEGIN {FS=":.*?## "} /^# [A-Za-z]/ {printf "%s\033[1;33m[%s]\033[0m\n", (s ? "\n" : ""), substr($$0, 3); s=1} /^[a-zA-Z0-9_-]+:.*## / {printf "\033[32m%-28s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
