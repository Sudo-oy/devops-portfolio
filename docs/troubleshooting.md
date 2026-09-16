# Troubleshooting

## First look

```bash
kubectl -n devops-portfolio get pods,svc,ingress,hpa
k8s-sre-agent diagnose -n devops-portfolio        # automated read-only diagnosis
```

## Pods

| Symptom | Check | Typical fix |
|---|---|---|
| `CrashLoopBackOff` | `kubectl -n devops-portfolio logs deploy/web --previous` | Fix the configuration or the startup error |
| `ImagePullBackOff` | `kubectl -n devops-portfolio describe pod <pod>` | Fix the image tag or the registry credentials |
| `Pending` | Scheduler message in `describe pod` | Lower requests or add capacity |
| Not `Ready` | `kubectl -n devops-portfolio get endpoints web` | Check `/readyz` and the NetworkPolicy |
| Pod rejected at creation | Namespace events | The pod violates the `restricted` Pod Security profile |

## Ingress (AWS Load Balancer Controller)

```bash
kubectl -n devops-portfolio describe ingress web
kubectl -n kube-system logs deploy/aws-load-balancer-controller
```

Public subnets must carry the `kubernetes.io/role/elb=1` tag (set by terraform-aws-eks-platform).

## Monitoring

```bash
kubectl -n monitoring port-forward svc/prometheus-server 9090:80
# then query: sum(rate(http_requests_total{namespace="devops-portfolio"}[5m])) by (status)
```

## Terraform

- Run `terraform plan` before every `apply` and review the diff.
- `AccessDenied`: check the IAM identity with `aws sts get-caller-identity`.
- EKS `Unauthorized` from kubectl: run `aws eks update-kubeconfig --name <cluster>` and check the access entries.
