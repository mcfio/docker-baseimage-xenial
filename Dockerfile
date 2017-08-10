FROM ubuntu:16.04
MAINTAINER nmcfaul

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm" LANGUAGE="en_US.UTF-8" LANG="en_US.UTF-8" LC_ALL="C.UTF-8"

# set version for s6 overlay
ARG S6_OVERLAY_VERSION="v1.19.1.1"

# update distribution install apt-utils and locales
RUN \
  && apt-get update \
  && apt-get install -y \
    apt-utils \
    locales \
    curl \
    tzdata \

  # Generate locale
  && locale-gen en_US.UTF-8 \
  
  # Add user
  && useradd -U -d /config -s /bin/false mcf && \
  && usermod -G users mcf && \
  
  # Fetch and extract S6 overlay
  && curl -J -L -o /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \

  # Setup directories
  && mkdir -p \
    /app \
    /config \
    /defaults \
  
  # Cleanup
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
  
# Add local files
COPY root/ /

ENTRYPOINT ["/init"]