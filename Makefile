.DEFAULT_GOAL := help
include .env
export

stage1_up: ## Run nginx on port 80 as a sanity check
	docker-compose -f stage1-docker-compose.yml up 

stage1_staging_cert: ##  Run nginx on port 80 and request a _staging_ certificate
	docker-compose -f stage1-docker-compose.yml up  -d
	@./stage1-issue-cert-staging.sh

stage2_up: ## Runs secure webserver that will forward responses to port 443
	docker-compose -f stage2-docker-compose.yml up

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' ./Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
