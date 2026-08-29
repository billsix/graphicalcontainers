# Add image-export / image-import Makefile targets (Dockerfile/Makefile contract)

**Status:** proposed — needs go-ahead. Created 2026-08-16 (William Emerison Six <billsix@gmail.com>).
**Priority:** 6
**Difficulty:** 2

## Goal

graphicalcontainer's `Makefile` is missing the standard **`image-export` / `image-import`** target pair
from my container-per-project Makefile contract. Add them, matching the projects that already have them
(geometricalgebra, spimulator, hanoi, texExpToPng, modelviewprojection).

## What to add (per the contract)

- **`image-export`** — `## export the OCI image to a timestamped tar in the repo root`:
  `$(CONTAINER_CMD) save $(IMAGE_NAME) -o $(IMAGE_NAME)-$(shell date +%m-%d-%Y_%H-%M-%S).tar`.
  (graphicalcontainer uses `IMAGE_NAME = graphicsdemoimage` / `CONTAINER_NAME = graphicsdemo`
  — use its **image** name for `save`. Its command variable was renamed
  `PODMAN_CMD` → `CONTAINER_CMD` on 2026-08-29.)
- **`image-import`** — `## import an OCI image tar: make image-import FILE=foo.tar`:
  `$(CONTAINER_CMD) load -i $(FILE)`.
- Both **`.PHONY`**, both `## `-documented (they'll appear in `make help`).
- **Gitignore the artifacts** — add `*.tar` to `.gitignore` (create one if absent); the tars are large
  and must never be committed.

## Note — this project's other contract gaps are mostly N/A

graphicalcontainer is a **demo-runner** (its `shell`/`gtk4-demo`/`qt-demo` targets run distro GTK4/Qt6
demos that come from dnf; there is **no first-party source**). So:

- **No `format` target** — correct/expected: there is no project code to format. Leave it out.
- The self-contained-image convention still applies to the demo image itself (GTK/Qt from dnf are baked),
  and export/import lets that image be archived/reloaded — which is the point of this task.

Reference: the "Makefile contract" in `~/.ai-coding-conventions.personal.md`; copy the target bodies from
`geometricalgebra/Makefile`.
