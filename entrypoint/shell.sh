#!/usr/bin/env bash
# Fail-fast setup, then land in the mounted repo. The final `exec bash` is a fresh
# bash not under -e, so interactive/script behaviour is unchanged. `set -e` only.
set -e
cd /graphicsdemo 2>/dev/null || cd /
# No args -> interactive shell. Args (a `-c '...'` payload from `make shell-exec`)
# -> run them after setup, in a fresh bash not under -e. Lets you run a GL/GTK/Qt
# demo headlessly, e.g.  make shell-exec CMD='glxgears'
exec bash "$@"
