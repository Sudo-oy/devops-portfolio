# Architecture

## Delivery flow

```mermaid
sequenceDiagram
  autonumber
  actor Dev as Developer
  participant GH as GitHub
  participant CI as GitHub Actions
  participant Reg as Container registry
  participant K8s as Kubernetes (EKS)
  participant Mon as Prometheus / Alertmanager

  Dev->>GH: Open pull request
  GH->>CI: Trigger pipeline
  CI->>CI: ruff + pytest (app)
  CI->>CI: hadolint + docker build
  CI->>CI: kustomize build + kubeconform
  CI->>CI: checkov (Dockerfile, manifests) + gitleaks
  CI-->>GH: Status checks
  Dev->>GH: Merge after review
  Note over CI,Reg: Roadmap: push signed image to GHCR/ECR
  Reg->>K8s: Argo CD syncs k8s/ (roadmap)
  K8s->>Mon: /metrics scraped every 30s
  Mon-->>Dev: Alert (error rate, crash loop)
  Dev->>K8s: k8s-sre-agent diagnose (read-only)
```

## Runtime view

| Component | Choice | Why |
|---|---|---|
| Workload | `Deployment` with 2 replicas, `maxUnavailable: 0` | Zero-downtime rolling updates |
| Scaling | `HorizontalPodAutoscaler` on CPU (70 %, 2-5 replicas) | Absorb load peaks without manual action |
| Disruptions | `PodDisruptionBudget` `minAvailable: 1` | Node drains never remove every replica |
| Spreading | `topologySpreadConstraints` on hostname | Survive the loss of one node |
| Security | Restricted Pod Security, non-root UID 10001, read-only root filesystem, all capabilities dropped, no service account token | Minimal attack surface |
| Network | Default-deny `NetworkPolicy`, ingress on 8080, DNS egress only | Contain lateral movement |
| Health | `/readyz` for readiness, `/healthz` for liveness | Traffic only reaches ready pods |
| Observability | RED metrics (`http_requests_total`, `http_request_duration_seconds`) | Error rate and latency SLOs |

## Infrastructure

The AWS foundation (VPC, EKS, ECR, optional RDS) is provisioned with the reusable
[terraform-aws-eks-platform](https://github.com/Sudo-oy/terraform-aws-eks-platform) module:

```hcl
module "platform" {
  source = "github.com/Sudo-oy/terraform-aws-eks-platform?ref=v0.1.0"

  name             = "portfolio"
  ecr_repositories = ["devops-portfolio"]
}
```
