SHELL := /bin/bash
.DEFAULT_GOAL := help

###########################
# VARIABLES
###########################

RECORD_FILE_NAME := demo

###########################
# MAPPINGS
###########################

###########################
# TARGETS
###########################

.PHONY: help
help:  ## help target to show available commands with information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: markdownlint
markdownlint: ## Validate markdown files
	docker-compose run docs markdownlint .github/ --ignore node_modules
	docker-compose run docs markdownlint . --ignore node_modules

.PHONY: zsh
zsh: ## open dev container with build environment
	docker-compose run --service-ports dev /bin/zsh

.PHONY: prune
prune: ## delete the whole environment
	docker-compose down -v --rmi all --remove-orphans

.PHONY: play
play:
	npx terminalizer play ${RECORD_FILE_NAME}

.PHONY: record
record:
	npx terminalizer record ${RECORD_FILE_NAME}

.PHONY: render
render:
	npx terminalizer render ${RECORD_FILE_NAME} -o tmp.gif
