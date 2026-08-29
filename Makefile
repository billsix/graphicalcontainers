.DEFAULT_GOAL := help

CONTAINER_NAME = graphicsdemo
IMAGE_NAME = graphicsdemoimage
PODMAN_CMD = podman

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
	$(PODMAN_CMD) build \
                      -t $(CONTAINER_NAME) \
                      -f Dockerfile \
                      .

# --- shell / shell-exec share ONE container invocation, defined here so the two
# targets can never drift. Scoped to this pair ONLY. See runClaudeInContainer
# tasks/add-shell-exec-target.md. Standardized into the template 2026-08-29: the
# repo is now mounted at REPO_MOUNT and shell.sh (bind-mounted) is the launcher.
SHELL_RUN_FLAGS = \
		--entrypoint /bin/bash \
		-v $(shell pwd):/$(CONTAINER_NAME):Z \
		-v ./entrypoint/shell.sh:/usr/local/bin/shell.sh:Z \
		$(X_FLAGS_FOR_CONTAINER) \
		$(WAYLAND_FLAGS_FOR_CONTAINER)

REPO_MOUNT = /$(CONTAINER_NAME)

SHELL_EXEC_ARGS = -c 'cd $(REPO_MOUNT) && $(if $(CMD),$(CMD),exec bash $(SCRIPT))'

.PHONY: shell
shell: image ## interactive shell in the demo image (repo mounted at /$(CONTAINER_NAME))
	$(PODMAN_CMD) run --rm -it $(SHELL_RUN_FLAGS) $(CONTAINER_NAME) /usr/local/bin/shell.sh

.PHONY: shell-exec
shell-exec: image ## run a script/command in the demo env (no TTY), e.g. make shell-exec CMD='glxgears'
	@[ -n "$(SCRIPT)$(CMD)" ] || { echo 'usage: make shell-exec SCRIPT=<repo-relative path> | CMD="..."'; exit 2; }
	$(PODMAN_CMD) run --rm $(SHELL_RUN_FLAGS) $(CONTAINER_NAME) /usr/local/bin/shell.sh $(SHELL_EXEC_ARGS)

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
