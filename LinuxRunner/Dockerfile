# Base image
FROM ubuntu:22.04

#input GitHub runner version argument
ARG RUNNER_VERSION
ENV DEBIAN_FRONTEND=noninteractive

LABEL Author="Manuel Roat"
LABEL Email="roat.manuel@gmail.com"
LABEL GitHub="https://github.com/redek91"
LABEL BaseImage="ubuntu:22.04"
LABEL RunnerVersion=${RUNNER_VERSION}

# Add an executor user
RUN useradd -m executor

# Update packages already installed by default
RUN apt-get update -y && apt-get upgrade -y

# Add dependencies
RUN apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  clang \
  curl \
  jq \
  libicu70 \
  libssl3 \
  libssl-dev \
  liblttng-ust1 \
  libkrb5-3 \
  lld \
  openssl \
  pkg-config \
  zlib1g 

# Download and unpack runner in executor home
RUN \
  cd /home/executor && \
  mkdir actions-runner && \
  cd actions-runner && \
  curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
  tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
  rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install github runner dependencies
RUN chown -R executor ~executor && /home/executor/actions-runner/bin/installdependencies.sh

# Cleanup
RUN apt-get autoremove -y
RUN apt-get clean

# Copy start script
ADD scripts/start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# Fix dos2unix
RUN sed -i 's/\r//' start.sh

# Set run user
USER executor

# Set entry point
ENTRYPOINT ["./start.sh"]
