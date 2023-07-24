FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl jq git

# Download the latest version of the runner package
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.307.0/actions-runner-linux-x64-2.307.0.tar.gz

# Create a new directory for the runner and extract the runner package
RUN mkdir /actions-runner && tar xzf ./actions-runner-linux-x64-2.307.0.tar.gz -C /actions-runner

# Set the working directory
WORKDIR /actions-runner

# Create the runsvc.sh script that will configure and run the runner
RUN echo "#!/bin/bash\n\
./config.sh --url https://github.com/yourorg/yourrepo --token ${RUNNER_TOKEN}\n\
./run.sh" > runsvc.sh

# Make the script executable
RUN chmod +x runsvc.sh

# Set the entrypoint as the runner script
ENTRYPOINT ["./runsvc.sh"]
