FROM ghcr.io/actions/actions-runner:2.311.0

USER root

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  zstd \
  gzip \
  tar \
  jq \
  git \
  zip \
  unzip \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

USER runner
