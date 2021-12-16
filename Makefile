.DEFAULT_GOAL := help
include .env
export

stage1_up: ## Runs nginx and certbot containers with only port 80
	docker-compose -f stage1-docker-compose.yml up -d

stage1_down: ## Stops initial webserver that will respond on port 80
	docker-compose -f stage1-docker-compose.yml down

stage2_up: ## Runs secure webserver that will forward responses to port 443
	docker-compose -f stage2-docker-compose.yml up

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' ./Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
