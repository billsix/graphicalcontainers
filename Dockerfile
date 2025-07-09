# Dockerfile for fedora-demos
FROM fedora:42

# Install necessary packages for GTK and Qt demos, and graphics forwarding
RUN dnf update -y && \
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
    libglvnd-gles && \
    dnf clean all

# Set a default command to keep the container running for interaction
CMD ["bash"]