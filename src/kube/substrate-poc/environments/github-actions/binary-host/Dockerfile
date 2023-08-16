FROM ubuntu:20.04

LABEL maintainer="skylar.simoncelli@iohk.io"

ENV DEBIAN_FRONTEND=non-interactive

RUN apt-get update && \
    apt-get install -y \
    curl \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*


COPY cardano-cli /bin/cardano-cli
COPY sc-evm-cli /bin/sc-evm-cli
COPY trustless-sidechain-ctl /bin/trustless-sidechain-ctl


RUN chmod +x /bin/cardano-cli
RUN chmod +x /bin/sc-evm-cli
RUN chmod +x /bin/trustless-sidechain-ctl

CMD ["/bin/bash"]