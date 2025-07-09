# Dockerfile for fedora-demos
FROM fedora:44

# Install necessary packages for GTK and Qt demos, and graphics forwarding
RUN dnf update -y && \
    dnf install -y \
    gtk3-demos \
    qt5-qtbase-gui \
    qt5-qtbase-examples \
    xorg-x11-server-utils \
    mesa-dri-drivers && \
    dnf clean all

# Set a default command to keep the container running for interaction
CMD ["bash"]