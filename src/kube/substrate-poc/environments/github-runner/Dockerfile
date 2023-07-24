FROM ubuntu:20.04
RUN apt-get update && \
    apt-get install -y curl jq git
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.307.0/actions-runner-linux-x64-2.307.0.tar.gz
RUN mkdir /actions-runner && tar xzf ./actions-runner-linux-x64-2.307.0.tar.gz -C /actions-runner
ENTRYPOINT ["/actions-runner/run.sh"]