# Guide de Troubleshooting

## Kubernetes
- `kubectl get pods -n devops-portfolio`
- `kubectl logs <pod> -n devops-portfolio`

## Terraform
- `terraform plan` avant `apply`
- Vérifier les permissions IAM

## Docker
- `docker images` et `docker ps` pour vérifier les containers
- Problèmes de login Docker → vérifier variables d’environnement

## ArgoCD
- `argocd app list`
- `argocd app sync <app-name>`
