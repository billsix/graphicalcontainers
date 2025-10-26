.DEFAULT_GOAL := help

CONTAINER_NAME = graphicsdemo
IMAGE_NAME = graphicsdemoimage
PODMAN_CMD = podman

PACKAGE_CACHE_ROOT = ~/.cache/packagecache/fedora/42

DNF_CACHE_TO_MOUNT = -v $(PACKAGE_CACHE_ROOT)/var/cache/libdnf5:/var/cache/libdnf5:Z \
	             -v $(PACKAGE_CACHE_ROOT)/var/lib/dnf:/var/lib/dnf:Z



X_FLAGS_FOR_CONTAINER = -e DISPLAY=$(DISPLAY) \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	--security-opt label=type:container_runtime_t

WAYLAND_FLAGS_FOR_CONTAINER = -e "WAYLAND_DISPLAY=${WAYLAND_DISPLAY}" \
                              -e "XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}" \
                              -v "${XDG_RUNTIME_DIR}:${XDG_RUNTIME_DIR}"

.PHONY: all
all: image run ## Build the image and run it

.PHONY: image
image: ## Build the image
	# cache rpm packages
	mkdir -p $(PACKAGE_CACHE_ROOT)/var/cache/libdnf5
	mkdir -p $(PACKAGE_CACHE_ROOT)/var/lib/dnf
	$(PODMAN_CMD) build \
                      -t $(CONTAINER_NAME) \
                      -f Dockerfile \
                      $(DNF_CACHE_TO_MOUNT) \
                      .

.PHONY: shell
shell: image ## run the image
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(X_FLAGS_FOR_CONTAINER) \
		$(WAYLAND_FLAGS_FOR_CONTAINER) \
		$(CONTAINER_NAME) \
		bash

.PHONY: gtk4-demo
gtk4-demo: image ## run the gtk4-demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(X_FLAGS_FOR_CONTAINER) \
		$(WAYLAND_FLAGS_FOR_CONTAINER) \
		$(CONTAINER_NAME) \
		bash -c "gtk4-demo"

.PHONY: qt-demo
qt-demo: image ## run the qt6 demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(X_FLAGS_FOR_CONTAINER) \
		$(WAYLAND_FLAGS_FOR_CONTAINER) \
		$(CONTAINER_NAME) \
		bash -c "/usr/lib64/qt6/examples/widgets/gallery/bin/gallery"


.PHONY: glxgears
glxgears: image ## run the qt6 demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(X_FLAGS_FOR_CONTAINER) \
		$(WAYLAND_FLAGS_FOR_CONTAINER) \
		$(CONTAINER_NAME) \
		bash -c "glxgears"

.PHONY: vkcube
vkcube: image ## run the qt6 demo
	$(PODMAN_CMD) run \
		--rm \
		-it \
		$(X_FLAGS_FOR_CONTAINER) \
		$(WAYLAND_FLAGS_FOR_CONTAINER) \
		$(CONTAINER_NAME) \
		bash -c "vkcube"




.PHONY: help
help:
	@grep --extended-regexp '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
