.DEFAULT_GOAL := help
include .env
export

http_build:
	docker-compose -f http-docker-compose.yml build

http_up:
	docker-compose -f http-docker-compose.yml up -d

http_down:
	docker-compose -f http-docker-compose.yml down

https_build:
	docker-compose -f https-docker-compose.yml build

https_up:
	docker-compose -f https-docker-compose.yml up -d

https_down:
	docker-compose -f https-docker-compose.yml down

http_app_build:
	docker-compose -f http_app-docker-compose.yml build

http_app_up:
	docker-compose -f http_app-docker-compose.yml up -d

http_app_down:
	docker-compose -f http_app-docker-compose.yml down

https_app_build:
	docker-compose -f https_app-docker-compose.yml build

https_app_up:
	docker-compose -f https_app-docker-compose.yml up -d

https_app_down:
	docker-compose -f https_app-docker-compose.yml down

http: https_down http_app_down https_app_down http_build http_up ## Run Nginx on only port 80
https: http_down http_app_down https_app_down https_build https_up ## Run Nginx with the generated certificate

http_app: http_down https_down https_app_down http_app_build http_app_up ## Run Nginx without a certificat and proxy to app containers port
https_app: http_down https_down http_app_down https_app_build https_app_up ## Run Nginx with the generated certificate and proxy to app containers port

staging_cert: down http_up ## Request a _staging_ certificate
	@./http-issue-cert-staging.sh

production_cert: down http_up ## Request a _production_ certificate
	@./http-issue-cert-production.sh

down: http_down https_down http_app_down https_app_down ## stops the server

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' ./Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
