# Base stage with common definitions
FROM ubuntu:24.04 AS base

ARG IMAGE_VERSION=0.0.1
ARG QUARTO_VERSION=1.9.8
ENV QUARTO_VERSION=${QUARTO_VERSION}

WORKDIR /workspace

# Minimal stage: Quarto only, no Python or Julia
FROM base AS minimal

RUN apt-get update && apt-get install -y \
    curl \
    && curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

CMD ["quarto", "--help"]

# Python stage: Quarto with Python and Jupyter
FROM base AS python

RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    python3-pip \
    && pip3 install jupyter --break-system-packages \
    && curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

CMD ["quarto", "--help"]

# Julia stage: Quarto with Julia
FROM base AS julia

RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://install.julialang.org | sh -s -- -y \
    && curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/*

CMD ["quarto", "--help"]
