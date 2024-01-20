.DEFAULT_GOAL := help

.PHONY: deploy_1
deploy_1: export PROJECT_NAME ?= deploy_1

.PHONY: edit-compose
edit-compose: ## Edit compose file
	mugo -d '{"COMPOSE_PATH": "$(PWD)/env/$(PROJECT_NAME)"}' -o env/$(PROJECT_NAME)/_compose.yaml env/$(PROJECT_NAME)/compose.yaml

.PHONY: env-swarm
env-swarm: export PROJECT_NAME ?= deploy_1
env-swarm: edit-compose ## Create swarm environment
	docker stack deploy --prune -c env/$(PROJECT_NAME)/_compose.yaml $(PROJECT_NAME)

.PHONY: env
env: export PROJECT_NAME ?= deploy_1
env: edit-compose ## Create environment
	docker compose -p $(PROJECT_NAME) -f env/$(PROJECT_NAME)/compose.yaml up -d

.PHONY: env-down
env-down: export PROJECT_NAME ?= deploy_1
env-down: ## Destroy environment
	docker compose -p $(PROJECT_NAME) down

.PHONY: help
help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
