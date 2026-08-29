# Makefile conformance fixes — broken `all`, `PODMAN_CMD` naming, stale help text

**Status:** complete — all three fixes applied 2026-08-29 with maintainer approval: `all`
deleted (maintainer: "there shouldn't be a make all"), a `run` target added launching
`gtk4-demo` (maintainer's pick), `PODMAN_CMD` renamed to `CONTAINER_CMD` (8 sites), help
texts fixed. Verified: `make -n` byte-identical for every pre-existing target; `make all`
now correctly absent; `make -n run` expands to image build + gtk4-demo.
**Completed:** 2026-08-29
**Priority:** 6
**Difficulty:** 1
**Found:** 2026-08-29 (William Emerison Six <billsix@gmail.com>), during the fleet-wide
`PODMAN_RUN_FLAGS` fan-out — work record: runClaudeInContainer
(github.com/billsix/runClaudeInContainer)
`tasks/archive/2026/08/29/nested-podman-run-flags-passthrough.md`.

## BLUF

Three pre-existing Makefile defects, all trivial and independent:

1. **`make all` always fails** — `all: image run` (`Makefile:25`) depends on a `run` target
   that does not exist anywhere in the Makefile (`make: *** No rule to make target 'run',
   needed by 'all'`).
2. **The container command variable is named `PODMAN_CMD`** (`Makefile:5`) instead of the
   container-template standard `CONTAINER_CMD` — a naming drift from every sibling project.
3. **Stale `##` help text** — `glxgears` (`Makefile:80`) and `vkcube` (`Makefile:90`) both say
   "run the qt6 demo" (copy-pasted from `qt-demo`, `Makefile:69`).

Done = `make all` succeeds, the variable matches the template name, help text names the right
demos, and before/after `make -n <target>` output is byte-identical for every target except
the deliberate `all` change.

## Context

Found while threading `$(PODMAN_RUN_FLAGS)` into the run lines (that change is already staged,
2026-08-29); these defects predate it and were deliberately left out of that mechanical pass.
No conversation context is needed — everything is visible in the `Makefile`:

- `PODMAN_CMD` is set at `Makefile:5` and used at lines 29 (`build`), 51, 56, 60, 70, 81, 91
  (`run`). Renaming to `CONTAINER_CMD` is mechanical (`sed s/PODMAN_CMD/CONTAINER_CMD/g`);
  verify with a before/after `make -n` capture of every target — expect byte-identical output.
  **Leave `PODMAN_RUN_FLAGS` alone** — that name is the fleet convention (see the work record
  above), unrelated to this rename despite the similar spelling.
- For `all` — **decided (William Emerison Six <billsix@gmail.com>, 2026-08-29): there should
  be no `all` target at all; delete it** (`Makefile:25` and its `.PHONY` entry if present).
  `make image` already exists and stays. A `make run` target is a *maybe* (maintainer's word)
  — the repo has four runnable demos (`gtk4-demo`, `qt-demo`, `glxgears`, `vkcube`) and no
  canonical one, so adding `run` needs a choice of which demo it launches (open question 1
  below). If `all` was the default goal, check `.DEFAULT_GOAL` (`Makefile:1` is
  `.DEFAULT_GOAL := help`, so deleting `all` is safe).
- Help-text fix: change lines 80 and 90 to "run glxgears" / "run vkcube" (wording per taste).

## Open questions

None — the maintainer resolved both 2026-08-29: no `all` target, and `run` launches
`gtk4-demo`.
