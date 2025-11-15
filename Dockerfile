# Dockerfile for fedora-demos
FROM registry.fedoraproject.org/fedora:42

# Install necessary packages for GTK and Qt demos, and graphics forwarding
RUN --mount=type=cache,target=/var/cache/libdnf5 \
    --mount=type=cache,target=/var/lib/dnf \
    echo "keepcache=True" >> /etc/dnf/dnf.conf && \
    dnf upgrade -y && \
    dnf install -y \
    mesa-dri-drivers  \
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
    vulkan-tools



# Set a default command to keep the container running for interaction
CMD ["bash"]
