FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential clang clang-format clang-tidy cmake ninja-build gdb pkg-config \
    php-cli php-mbstring php-xml php-curl php-pgsql composer \
    postgresql-client sqlite3 libpq-dev libssl-dev libffi-dev \
    jq ripgrep shellcheck dnsutils iproute2 iputils-ping netcat-openbsd traceroute \
    openssh-client unzip zip && rm -rf /var/lib/apt/lists/*
