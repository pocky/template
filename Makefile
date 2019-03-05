DOCKER_COMPOSE?=docker-compose

.DEFAULT_GOAL := help
.PHONY: help start stop reset clear
.PHONY: build up
.PHONY: rm-docker-dev.lock

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

##
## Project setup
##---------------------------------------------------------------------------

start: build up ## Install and start the project

stop: ## Remove docker containers
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) rm -v --force

reset: stop rm-docker-dev.lock start

clear: rm-docker-dev.lock

# Internal rules

build: docker-dev.lock

docker-dev.lock:
	$(DOCKER_COMPOSE) pull --ignore-pull-failures
	$(DOCKER_COMPOSE) build --force-rm --pull
	touch docker-dev.lock

rm-docker-dev.lock:
	rm -f docker-dev.lock

up:
	$(DOCKER_COMPOSE) up -d --remove-orphans
