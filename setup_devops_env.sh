#!/usr/bin/env bash
# Installation automatique de Docker, kubectl, Helm, Terraform, AWS CLI, ArgoCD, etc.

set -e

echo "🚀 Mise à jour du système..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installation des dépendances de base..."
sudo apt install -y curl wget git unzip apt-transport-https ca-certificates gnupg lsb-release jq bash-completion

echo "🐳 Installation Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo usermod -aG docker $USER

echo "☸️ Installation kubectl..."
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/

echo "📦 Installation Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "🌍 Installation Terraform..."
TF_VERSION="1.9.8"
wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip terraform_${TF_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TF_VERSION}_linux_amd64.zip

echo "☁️ Installation AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "⚙️ Installation ArgoCD CLI..."
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

echo "✅ Installation terminée. Déconnectez-vous et reconnectez-vous pour appliquer les changements Docker."
