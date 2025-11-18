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

# Python stage: Quarto with Python and UV package manager
FROM base AS python

# Copy Python project configuration and install dependencies
COPY pyproject.toml uv.lock ./

# Add UV to PATH
ENV PATH="/root/.local/bin:${PATH}"

# Install system dependencies and UV
RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    ca-certificates \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && curl -LO https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/* \
    && uv sync --frozen

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
