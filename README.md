# Universal Engineering Dev Container

Reusable VS Code development environment. Copy `.devcontainer/` into the root of each repository, merging existing settings rather than overwriting them. Keep separate containers and Compose volumes per project. This template does not modify project dependencies or start any trading bot.

## Quick start (Windows, macOS, Linux)

1. Install Docker Desktop (or Docker Engine + Compose v2 on Linux), VS Code and the Dev Containers extension (`ms-vscode-remote.remote-containers`). On Windows use the WSL 2 backend; keeping repositories in the WSL Linux filesystem improves I/O.
2. Open the project root in VS Code. Run **Dev Containers: Reopen in Container** from the command palette.
3. Allow the initial build to finish; the language SDKs and extensions can take considerable time and disk space. Start with 8–16 GB RAM allocated to Docker and 40 GB free disk as a planning estimate, more for large builds.
4. In the container terminal run `bash .devcontainer/check.sh` to verify tools and local services. The script exits nonzero if any check fails.
5. For Python projects create a project-local environment: `python -m venv .venv && source .venv/bin/activate`. Install dependencies using your repository's lockfile or documented workflow. For Node projects use `npm ci` when a package-lock exists. Use Maven/Gradle wrappers where supplied.

## Local service endpoints (inside dev container)

| Service | Endpoint |
|---|---|
| PostgreSQL | `postgresql://dev:local_dev_only@postgres:5432/dev` |
| Valkey | `redis://valkey:6379/0` |
| NATS JetStream | `nats://nats:4222` |
| NATS monitoring | `http://nats:8222` |

Services are not published to host ports by default. VS Code forwards application ports on demand; keep forwarding private. Use only disposable development data. The database password is deliberately local-only and Valkey/NATS are unauthenticated on the isolated Compose network. Never use these settings in production or with untrusted workloads.

## Optional Docker CLI and host daemon access

For trusted DevOps repositories only, add `"ghcr.io/devcontainers/features/docker-outside-of-docker:1": {}` to the `features` object in devcontainer.json and rebuild. This gives the container access to the host Docker daemon, effectively granting host-level control. Do not enable it for untrusted code. For stronger isolation use a separate disposable VM or remote development host. Without this feature, run Docker commands in a host terminal.

## Cloud and trading safety

Cloud CLI tools are installed but no credentials, kubeconfig, SSH private keys, production URLs, or broker keys are included. Use a dedicated sandbox account/context and short-lived credentials. Never copy production secrets into the image or commit them. Keep real trading disabled in application-specific configuration; this template cannot enforce an application's trading mode. Use mocked brokers or paper accounts. Review Terraform plans; do not apply to production from this environment.

## Customize and maintain

Remove unneeded features or extensions for smaller builds. The feature-based SDK installation occurs when using a Dev Containers-compatible client, not plain `docker compose build`. Image tags and feature major versions are not immutable; after a successful build, record resolved image digests and feature lockfiles for reproducibility. Verify project-specific language versions before adoption. Rebuild via **Dev Containers: Rebuild Container** after changes. Source code is bind-mounted; database, cache and event data use named volumes. Back up any valuable development data before cleanup. `docker compose -f .devcontainer/compose.yaml down -v` deletes local service volumes (run only if intentional and using the matching Compose project name).

## Validation status

Configuration syntax and archive structure were checked. Docker image pulls, feature installation, container builds and runtime tests must be performed on a Docker-enabled machine. No production deployment or repository modification is included.
