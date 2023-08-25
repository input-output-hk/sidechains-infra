FROM ubuntu:20.04

LABEL maintainer="skylar.simoncelli@iohk.io"

ENV DEBIAN_FRONTEND=non-interactive

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user named runneruser and give them sudo access
RUN useradd -m runneruser && echo "runneruser:runneruser" | chpasswd && adduser runneruser sudo

# Set up the GitHub runner directory
WORKDIR /actions-runner

# Download the runner package
RUN curl -o actions-runner-linux-x64-2.308.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz

# Optional: Validate the hash
RUN echo "9f994158d49c5af39f57a65bf1438cbae4968aec1e4fec132dd7992ad57c74fa  actions-runner-linux-x64-2.308.0.tar.gz" | shasum -a 256 -c

# Extract the installer
RUN tar xzf ./actions-runner-linux-x64-2.308.0.tar.gz && rm actions-runner-linux-x64-2.308.0.tar.gz

# Set up the tools directory
WORKDIR /tools

# Copy the binary files
COPY cardano-cli /tools/cardano-cli
COPY sc-evm-cli /tools/sc-evm-cli
COPY trustless-sidechain-ctl-cli /tools/trustless-sidechain-ctl-cli

# Make the binary files executable
RUN chmod +x /tools/cardano-cli
RUN chmod +x /tools/sc-evm-cli
RUN chmod +x /tools/trustless-sidechain-ctl-cli

# Change the owner of the directories to the non-root user
RUN chown -R runneruser:runneruser /actions-runner && chown -R runneruser:runneruser /tools

# Change to the non-root user
USER runneruser

# This ensures that the GitHub runner's run script is the entry point, but also ensures the binaries are available in PATH
ENV PATH="/tools:${PATH}"
ENTRYPOINT [ "/actions-runner/run.sh" ]
