.DEFAULT_GOAL := help

build: build-pi build-claude-code ## Build all docker images

build-pi: ## Build the Pi docker image
	docker buildx bake -f docker/docker-bake.hcl pi

build-claude-code: ## Build the Claude Code docker image
	docker buildx bake -f docker/docker-bake.hcl claude-code

hadolint: ## Run hadolint on all Dockerfiles
	@find docker -name Dockerfile | while read -r f; do \
		echo "== $$f =="; \
		docker run --rm -i hadolint/hadolint < "$$f"; \
	done

help: ## This help.
	@awk 'BEGIN {FS=":.*?## "} /^# [A-Za-z]/ {printf "%s\033[1;33m[%s]\033[0m\n", (s ? "\n" : ""), substr($$0, 3); s=1} /^[a-zA-Z0-9_-]+:.*## / {printf "\033[32m%-28s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
