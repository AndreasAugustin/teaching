SHELL := /bin/bash
.DEFAULT_GOAL := help

###########################
# VARIABLES
###########################

RECORD_FILE_NAME := demo.cast
GIF_FILE_NAME := out.gif

###########################
# MAPPINGS
###########################

###########################
# TARGETS
###########################

.PHONY: help
help:  ## help target to show available commands with information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: record
record:
	asciinema rec records/${RECORD_FILE_NAME}

.PHONY: play
play:
	asciinema play records/${RECORD_FILE_NAME}

.PHONY: render
render:
	./asciinema/target/release/agg records/${RECORD_FILE_NAME} outputs/${GIF_FILE_NAME}
