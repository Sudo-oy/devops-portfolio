IMAGE ?= devops-portfolio:dev

.PHONY: help test lint build run manifests validate

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

test: ## Run the service unit tests
	cd app && python -m pytest

lint: ## Lint Python code and the Dockerfile
	cd app && ruff format --check . && ruff check .
	docker run --rm -i hadolint/hadolint < app/Dockerfile

build: ## Build the container image
	docker build -t $(IMAGE) app

run: build ## Run the container on http://localhost:8080
	docker run --rm -p 8080:8080 --read-only --tmpfs /tmp $(IMAGE)

manifests: ## Render the Kubernetes manifests
	kubectl kustomize k8s/base

validate: ## Validate the rendered manifests against the Kubernetes schemas
	kubectl kustomize k8s/base | kubeconform -strict -summary -
