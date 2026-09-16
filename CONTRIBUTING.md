# Contributing to devops-portfolio

Thanks for taking a look! This repository hosts a reference delivery platform. Improvements to the manifests, the pipeline, the monitoring setup or the documentation are welcome.

## Ground rules

- Follow the [Code of Conduct](CODE_OF_CONDUCT.md).
- Open an issue before large changes.
- Never commit credentials, kubeconfigs, webhook URLs or `.env` files.
- Report security problems privately (see [SECURITY.md](SECURITY.md)).

## Local setup

Requirements: Python 3.12, Docker, `kubectl` (with Kustomize) and optionally [kubeconform](https://github.com/yannh/kubeconform).

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r app/requirements-dev.txt

make test        # pytest
make lint        # ruff + hadolint
make build       # docker build
make validate    # kustomize build | kubeconform
```

## Conventions

- Kubernetes manifests must pass the `restricted` Pod Security profile, kubeconform and checkov (`.checkov.yaml` documents every skipped check).
- New endpoints come with a test in `app/tests/`.
- Commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `ci:`, `chore:`...).
- Fill in the pull request template; CI must be green before review.
