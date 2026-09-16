# Tech stack

## Kubernetes

- **Amazon EKS** managed control plane with managed node groups (AL2023).
- **Kustomize** for manifests: plain YAML, no templating, easy to review in pull requests, native to `kubectl`.
- **Pod Security Standards** (`restricted`) enforced at the namespace level instead of a third-party admission controller.
- **NetworkPolicy** default-deny, then explicit allow rules.

## Infrastructure as code

- **Terraform** with community modules pinned to exact versions, wrapped in a typed, tested module ([terraform-aws-eks-platform](https://github.com/Sudo-oy/terraform-aws-eks-platform)).
- **tflint**, **checkov** and **terraform-docs** in CI; `terraform test` with a mocked AWS provider so tests need no cloud account.

## Containers

- Multi-stage build on `python:3.12-slim`, dependencies installed in a builder stage.
- Runs as a non-root UID with a read-only root filesystem; `gunicorn` as the production server.
- **hadolint** and **checkov** scan the Dockerfile in CI.

## CI/CD

- **GitHub Actions** for these public repositories; the same stages translate directly to **GitLab CI**.
- Pipeline order: fast feedback first (lint, unit tests), then build, then policy and security gates.
- **gitleaks** scans the full git history on every pull request.

## Observability

- **Prometheus** scrapes `/metrics` (RED metrics exposed with `prometheus-client`).
- **Alertmanager** routes alerts to Slack; the webhook comes from a Kubernetes Secret.
- **Grafana** dashboard in `monitoring/grafana-dashboard.json` (request rate, p95 latency, CPU, memory).

## AI for operations

- **[k8s-sre-agent](https://github.com/Sudo-oy/k8s-sre-agent)** turns the first minutes of an incident (`kubectl get/describe/logs`) into a structured diagnosis, with an optional LLM root cause analysis and secret redaction.
