# Reusable engineering platform

The original .devcontainer configuration remains unchanged and continues to provide PostgreSQL, Valkey and NATS for local integration work. The new profiles are independently buildable images; they do not start supporting databases or cloud resources.

## Profiles

- **universal**: python node npm java mvn gradle dotnet go rustc cargo gcc clang cmake php composer terraform aws kubectl helm doctl ansible
- **python**: python pip gcc
- **java**: java javac mvn gradle
- **web**: node npm
- **cpp**: gcc g++ clang cmake ninja gdb
- **dotnet**: dotnet
- **go**: go
- **rust**: rustc cargo
- **devops**: python terraform aws kubectl helm doctl ansible
- **fintech**: python node npm psql
- **ai**: python plus CPU numerical and ML packages in /opt/ai
- **embedded**: gcc arm-none-eabi-gcc avr-gcc avrdude openocd

Open profiles/<name> in VS Code and reopen in container to build locally, or run:

```bash
npm install -g @devcontainers/cli@0.82.0
devcontainer build --workspace-folder profiles/devops --image-name engineering:devops
docker run --rm -it --user vscode engineering:devops bash -l
```

To use a released image in a different repository, create .devcontainer/devcontainer.json:

```json
{"name":"Engineering workspace","image":"ghcr.io/nguemechieu/universal-engineering-dev-container:devops-1.0.0","remoteUser":"vscode"}
```

Example tag only; requires a successful v1.0.0 release. For FinTech, preserve your project's Compose dependencies and environment. To use a released fintech image with the existing root Compose template, replace the dev service build mapping with the image reference, remove the root configuration's features mapping (already baked into that image), and adjust .devcontainer/check.sh to check only the chosen profile plus services.

## Releases and validation

PRs and weekly scheduled builds validate each profile on native AMD64 and ARM64 GitHub runners. The original Compose workspace has a separate integration job. Release publishing only runs on stable vMAJOR.MINOR.PATCH tags; each architecture image must pass smoke and Trivy gates before it is pushed. A multi-architecture manifest is created only after all matrix builds pass. No latest tag is overwritten. Do not reuse version tags; use a digest for strict immutability. Review release output before adoption. Package access/visibility is managed in GitHub. No cloud deployment or permanent token is required.

Trivy gates on fixable HIGH and CRITICAL findings; unfixed findings require separate assessment. Major action tags and Dev Container feature tags are mutable; pin verified digests/SHAs and commit generated feature locks after the first successful build for stricter reproducibility. Base apt packages and some SDK versions remain floating. Dependabot proposes Docker, Actions and feature updates. Review third-party license terms before distributing images.

AI profile uses /opt/ai/bin/python (CPU only). Add PyTorch/TensorFlow and GPU tooling in project-specific environments. Embedded profile provides ARM and AVR cross-compilers and debugging tools; USB passthrough, vendor SDKs and physical flashing are deliberately not configured. No Docker socket, elevated container permissions, broker secrets or cloud credentials are added by these profiles. Use sandbox cloud credentials and paper/mocked trading only.

## Validation and recovery

Run scripts/smoke.sh inside the corresponding image as vscode. The CI job tests native architecture images and the original Compose environment; this does not establish all project-specific toolchains or hardware compatibility. If a release job fails, keep using the previous known-good digest, investigate the logs and create a new version tag after fixing. Do not promote partially built architecture tags.
