FROM ubuntu:20.04

LABEL maintainer="skylar.simoncelli@iohk.io"

ENV DEBIAN_FRONTEND=non-interactive

# Install dependencies, including Node.js and npm
RUN apt-get update && \
    apt-get install -y \
    curl \
    ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs default-jdk && \
    rm -rf /var/lib/apt/lists/*

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

CMD ["/bin/bash"]