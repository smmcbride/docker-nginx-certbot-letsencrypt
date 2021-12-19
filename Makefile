.DEFAULT_GOAL := help
include .env
export

http_build: ## Build Nginx with port 80 exposed
	docker-compose -f stage1-docker-compose.yml build 

http_up: ## Run Nginx on port 80 as a sanity check
	docker-compose -f stage1-docker-compose.yml up 

http_down: ## Stop Nginx
	docker-compose -f stage1-docker-compose.yml down

staging_cert: ## Run Nginx on port 80 and request a _staging_ certificate
	docker-compose -f stage1-docker-compose.yml up  -d
	@./stage1-issue-cert-staging.sh

production_cert: ## Run Nginx on port 80 and request a _production_ certificate
	docker-compose -f stage1-docker-compose.yml up  -d
	@./stage1-issue-cert-production.sh

https_build: ## Build Nginx with ports 80 and 443 exposed
	docker-compose -f stage2-docker-compose.yml build 

https_up: ## Runs secure webserver that will use the cert generated from first stage
	docker-compose -f stage2-docker-compose.yml up

httsp_down: ## Stop Nginx
	docker-compose -f stage2-docker-compose.yml down

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' ./Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
