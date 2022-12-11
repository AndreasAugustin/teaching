SHELL := /bin/bash
.DEFAULT_GOAL := help

###########################
# VARIABLES
###########################

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))

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
record:  ## Record the terminal
	asciinema rec ${MKFILE_DIR}/records/${RECORD_FILE_NAME}

.PHONY: play
play:  ## play the record
	asciinema play ${MKFILE_DIR}/records/${RECORD_FILE_NAME}

.PHONY: render
render:  ## render the record to GIF
	${MKFILE_DIR}/asciinema/target/release/agg \
		--font-size 20 \
		${MKFILE_DIR}/records/${RECORD_FILE_NAME} \
		${MKFILE_DIR}/outputs/${GIF_FILE_NAME}
