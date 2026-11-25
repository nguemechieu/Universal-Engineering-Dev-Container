FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
ARG PROFILE=base
ARG DOCTL_VERSION=1.120.0
LABEL org.opencontainers.image.source="https://github.com/nguemechieu/Universal-Engineering-Dev-Container"
USER root
RUN set -eux; apt-get update; apt-get install -y --no-install-recommends \
    build-essential clang clang-format clang-tidy cmake ninja-build gdb pkg-config \
    postgresql-client sqlite3 libpq-dev libssl-dev libffi-dev \
    jq ripgrep shellcheck dnsutils iproute2 iputils-ping netcat-openbsd traceroute \
    openssh-client unzip zip curl ca-certificates; \
    case "$PROFILE" in base|cloud|ai|embedded|universal) ;; *) exit 1;; esac; \
    if [ "$PROFILE" = universal ]; then apt-get install -y --no-install-recommends php-cli php-mbstring php-xml php-curl php-pgsql composer; fi; \
    if [ "$PROFILE" = cloud ] || [ "$PROFILE" = universal ]; then apt-get install -y --no-install-recommends ansible; fi; \
    if [ "$PROFILE" = embedded ]; then apt-get install -y --no-install-recommends gcc-arm-none-eabi binutils-arm-none-eabi gcc-avr avr-libc avrdude openocd; fi; \
    if [ "$PROFILE" = ai ]; then apt-get install -y --no-install-recommends python3-venv; python3 -m venv /opt/ai; /opt/ai/bin/pip install --no-cache-dir numpy==2.2.6 pandas==2.2.3 scipy==1.15.3 scikit-learn==1.6.1; fi; \
    rm -rf /var/lib/apt/lists/*
RUN set -eux; if [ "$PROFILE" = cloud ] || [ "$PROFILE" = universal ]; then \
    arch="$(dpkg --print-architecture)"; case "$arch" in amd64|arm64) ;; *) exit 1;; esac; \
    archive="doctl-$DOCTL_VERSION-linux-$arch.tar.gz"; \
    dir="$(mktemp -d)"; cd "$dir"; \
    url="https://github.com/digitalocean/doctl/releases/download/v$DOCTL_VERSION"; \
    curl -fsSLO "$url/$archive"; curl -fsSLO "$url/doctl-$DOCTL_VERSION-checksums.sha256"; \
    grep -E "[ *]$archive$" "doctl-$DOCTL_VERSION-checksums.sha256" > checksum; sha256sum -c checksum; \
    tar -xzf "$archive" doctl; install -m 0755 doctl /usr/local/bin/doctl; cd /; rm -rf "$dir"; fi
