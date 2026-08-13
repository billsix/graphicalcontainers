#!/usr/bin/env bash
#
# 01-install-base.sh -- install this project's Fedora packages (GTK/Qt demos and the
# X11/Mesa/Vulkan libraries for graphics forwarding).
#
# Extracted from the Dockerfile so the same packages install on a bare Fedora host or a
# guest with no container runtime, not only during `podman build`. This project has a
# single, unconditional package group and no feature flags, so there is just this one
# script; the Dockerfile runs it.
#
# Two dnf calls (upgrade + install), so accumulate a non-zero exit if either fails.
set -uo pipefail

if ! command -v dnf >/dev/null 2>&1; then
    echo "01-install-base.sh: needs 'dnf' (this installs Fedora packages), not found." >&2
    echo "Run on a Fedora host/guest, or inside the project's Fedora-based image." >&2
    exit 1
fi

status=0

dnf upgrade -y || status=1

dnf install -y \
    mesa-dri-drivers \
    gtk4-demo \
    qt6-qtbase-examples \
    libXScrnSaver \
    libXtst \
    libXcomposite \
    libXcursor \
    libXdamage \
    libXfixes \
    libXft \
    libXi \
    libXinerama \
    libXmu \
    libXrandr \
    libXrender \
    libXres \
    libXv \
    libXxf86vm \
    libglvnd-gles \
    mesa-demos \
    vulkan-tools || status=1

exit $status
