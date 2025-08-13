.DEFAULT_GOAL := help

CONTAINER_NAME = graphicsdemo
IMAGE_NAME = graphicsdemoimage
PODMAN_CMD = podman

USE_X = -e DISPLAY=$(DISPLAY) \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	--security-opt label=type:container_runtime_t


.PHONY: all
all: build run ## Build the image and run it

.PHONY: build
build: ## Build the image
	$(PODMAN_CMD) build -t $(CONTAINER_NAME) -f Dockerfile .

.PHONY: shell
shell: build ## run the image
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(USE_X) \
		$(CONTAINER_NAME) \
		bash

.PHONY: gtk4-demo
gtk4-demo: build ## run the gtk4-demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(USE_X) \
		$(CONTAINER_NAME) \
		bash -c "gtk4-demo"

.PHONY: qt-demo
qt-demo: build ## run the qt6 demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(USE_X) \
		$(CONTAINER_NAME) \
		bash -c "/usr/lib64/qt6/examples/widgets/gallery/bin/gallery"


.PHONY: glxgears
glxgears: build ## run the qt6 demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(USE_X) \
		$(CONTAINER_NAME) \
		bash -c "glxgears"

.PHONY: vkcube
vkcube: build ## run the qt6 demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(USE_X) \
		$(CONTAINER_NAME) \
		bash -c "vkcube"




.PHONY: help
help:
	@grep --extended-regexp '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
