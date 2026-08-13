# Dockerfile for fedora-demos
FROM registry.fedoraproject.org/fedora:44

# Package installation lives in entrypoint/01-install-base.sh so the same packages can be
# installed on a bare Fedora host/guest (no container runtime), not only during this
# build. The dnf cache mount + keepcache stay here (build plumbing that speeds rebuilds);
# the script is runtime-agnostic. 01-install-base.sh does `dnf upgrade` + the install.
COPY entrypoint/01-install-base.sh /usr/local/bin/

RUN --mount=type=cache,target=/var/cache/libdnf5 \
    --mount=type=cache,target=/var/lib/dnf \
    echo "keepcache=True" >> /etc/dnf/dnf.conf && \
    /usr/local/bin/01-install-base.sh



# Set a default command to keep the container running for interaction
CMD ["bash"]
