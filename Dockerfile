FROM ghcr.io/actions/actions-runner:2.319.1

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
RUN curl -SL https://github.com/docker/compose/releases/download/v2.28.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
RUN chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
COPY wait_for_docker_then_run.sh /usr/local/bin/wait_for_docker_then_run.sh

USER runner
