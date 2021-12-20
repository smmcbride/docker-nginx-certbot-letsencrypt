.DEFAULT_GOAL := help
include .env
export

http_build:
	docker-compose -f stage1-docker-compose.yml build 

http_up:
	docker-compose -f stage1-docker-compose.yml up -d

http_down:
	docker-compose -f stage1-docker-compose.yml down

https_build:
	docker-compose -f stage2-docker-compose.yml build

https_up:
	docker-compose -f stage2-docker-compose.yml up -d

https_down:
	docker-compose -f stage2-docker-compose.yml down

http: https_down http_build http_up ## Run Nginx on only port 80

https: http_down https_build https_up ## Run Nginx with the generated certificate

staging_cert: ## Request a _staging_ certificate
	@./stage1-issue-cert-staging.sh

production_cert: ## Request a _production_ certificate
	@./stage1-issue-cert-production.sh

down: http_down https_down ## stops the server

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' ./Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
