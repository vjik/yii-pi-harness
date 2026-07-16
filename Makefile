.DEFAULT_GOAL := help

IMAGE := ghcr.io/yiisoft-contrib/pi-harness

build: ## Build the docker image
	docker build -t $(IMAGE) .

hadolint: ## Run hadolint on the Dockerfile
	docker run --rm -i hadolint/hadolint < Dockerfile

help: ## This help.
	@awk 'BEGIN {FS=":.*?## "} /^# [A-Za-z]/ {printf "%s\033[1;33m[%s]\033[0m\n", (s ? "\n" : ""), substr($$0, 3); s=1} /^[a-zA-Z0-9_-]+:.*## / {printf "\033[32m%-28s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
