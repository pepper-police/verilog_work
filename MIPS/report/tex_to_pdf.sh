#!/bin/bash

usage() {
	echo "Usage: $0 <tex-file>"
	exit 1
}

build_image() {
	echo "Building Docker image..."
	docker build -t $CONTAINER_NAME .
}

compile_tex() {
	docker run --rm -v "$(pwd)":/workspace $CONTAINER_NAME sh -c \
    "latexmk -pdfdvi -f -interaction=nonstopmode  $TEX_FILE; \
	latexmk -c"
}

if [[ $# -ne 1 ]]; then
	usage
fi

TEX_FILE=$1
CONTAINER_NAME="tex-env"

if ! docker image inspect $CONTAINER_NAME >/dev/null 2>&1; then
	build_image
else
	echo "Using existing Docker image..."
fi

compile_tex
