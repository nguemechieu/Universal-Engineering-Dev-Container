#!/usr/bin/env bash
set -u
fail=0
check() { printf '\n--- %s ---\n' "$1"; "$@" || fail=1; }
check python --version
check node --version
check npm --version
check java -version
check mvn --version
check gradle --version
check dotnet --version
check gcc --version
check clang --version
check cmake --version
check go version
check rustc --version
check cargo --version
check php --version
check composer --version
check terraform version
check aws --version
check kubectl version --client
check helm version --short
check git --version
check psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c 'SELECT 1;'
check python -c 'import socket; s=socket.create_connection(("valkey",6379),5); s.sendall(b"PING\r\n"); assert s.recv(64).startswith(b"+PONG"); s.close()'
check curl --fail --silent --show-error --max-time 5 http://nats:8222/healthz?js-enabled-only=true
printf '\n'; exit "$fail"
