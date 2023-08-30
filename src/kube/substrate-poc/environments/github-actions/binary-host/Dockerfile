FROM ubuntu:20.04

LABEL maintainer="skylar.simoncelli@iohk.io"

ENV DEBIAN_FRONTEND=non-interactive

# Install dependencies, including Node.js, npm, and OpenSSH server
RUN apt-get update && \
    apt-get install -y \
    curl \
    ca-certificates \
    openssh-server && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs default-jdk && \
    rm -rf /var/lib/apt/lists/*

# Setup SSHD
RUN mkdir /var/run/sshd
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Set root's SSH key (You should replace this with your public key!)
COPY key.pub /root/.ssh/authorized_keys

# Set correct permissions for the SSH key file
RUN chmod 600 /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys

# Set up the app directory
WORKDIR /tools

# Copy the binary files
COPY cardano-cli /tools/cardano-cli
COPY sc-evm-cli /tools/sc-evm-cli
COPY trustless-sidechain-ctl-cli /tools/trustless-sidechain-ctl-cli

# Make the binary files executable
RUN chmod +x /tools/cardano-cli
RUN chmod +x /tools/sc-evm-cli
RUN chmod +x /tools/trustless-sidechain-ctl-cli

# Run SSH server in the foreground
CMD ["/usr/sbin/sshd", "-D"]