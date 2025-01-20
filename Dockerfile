# Use an official Ubuntu as base image
FROM ubuntu:20.04

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies (Java, Maven, Git, etc.)
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    git \
    openjdk-11-jdk \
    maven \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy the IPSL installation script to the container
COPY install.sh /usr/local/bin/install.sh

# Make the installation script executable
RUN chmod +x /usr/local/bin/install.sh

# Expose any necessary ports (Replace 8080 with the correct one if needed)
EXPOSE 8080

# Set default command to run the installation script
CMD ["bash", "/usr/local/bin/install.sh"]
