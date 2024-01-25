.DEFAULT_GOAL := help

.PHONY: stack
stack:
	@if [ -z "$(PROJECT_NAME)" ]; then \
		echo "PROJECT_NAME is not set"; \
		exit 1; \
	fi

.PHONY: edit-compose
edit-compose: stack ## Edit compose file
	mugo -d '{"COMPOSE_PATH": "$(PWD)/env/$(PROJECT_NAME)"}' -o env/$(PROJECT_NAME)/_compose.yaml env/$(PROJECT_NAME)/compose.yaml

.PHONY: env-swarm
env-swarm: stack edit-compose ## Create swarm environment
	docker stack deploy --prune -c env/$(PROJECT_NAME)/_compose.yaml $(PROJECT_NAME)

.PHONY: env-swarm-down
env-swarm-down: stack ## Destroy swarm environment
	docker stack rm $(PROJECT_NAME)

.PHONY: env
env: stack edit-compose ## Create environment
	docker compose -p $(PROJECT_NAME) -f env/$(PROJECT_NAME)/compose.yaml up -d

.PHONY: env-down
env-down: stack ## Destroy environment
	docker compose -p $(PROJECT_NAME) down

.PHONY: help
help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
