CONTAINER_NAME = graphicsdemo
IMAGE_NAME = fedora:44
PODMAN_CMD = podman

.PHONY: all
all: build run ## Build the image and run it

.PHONY: build
build: ## Build the image
	$(PODMAN_CMD) build -t $(CONTAINER_NAME) -f Dockerfile .

.PHONY: run
run: build ## run the image
	$(PODMAN_CMD) run \
		--rm \
		-it \
		-e DISPLAY=$(DISPLAY) \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		$(CONTAINCONTAINER_NAME) \
		bash
