FROM ubuntu:20.04

LABEL maintainer="skylar.simoncelli@iohk.io"

ENV DEBIAN_FRONTEND=non-interactive

# Install dependencies, including Node.js and npm
RUN apt-get update && \
    apt-get install -y \
    curl \
    ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Set up the app directory
WORKDIR /app

# Copy the entire trustless-sidechain-ctl directory, including node_modules
COPY ./trustless-sidechain-ctl ./

# Copy the binary files
COPY cardano-cli /bin/cardano-cli
COPY sc-evm-cli /bin/sc-evm-cli

# Make the binary files executable
RUN chmod +x /bin/cardano-cli
RUN chmod +x /bin/sc-evm-cli

CMD ["/bin/bash"]
