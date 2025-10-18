# Base Image: Ubuntu
FROM ubuntu:24.04

ARG IMAGE_VERSION=0.0.1

# Set quarto version
ARG QUARTO_VERSION=1.9.8
ENV QUARTO_VERSION=${QUARTO_VERSION}

RUN apt-get update && apt-get install -y \
    curl  \
    python3 \
    python3-pip \
    && pip3 install jupyter --break-system-packages \
    && curl -fsSL https://install.julialang.org | sh -s -- -y \
    && curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

WORKDIR /workspace

CMD ["quarto", "--help"]