# Makefile pour DevOps Portfolio

GREEN := \033[0;32m
RESET := \033[0m

help:
	@echo "📘 Commandes disponibles:"
	@echo "  make setup       → Installer l'environnement DevOps"
	@echo "  make deploy      → Déployer l'application Kubernetes"
	@echo "  make terraform   → Déployer l'infrastructure AWS"
	@echo "  make clean       → Nettoyer les fichiers temporaires"

setup:
	@echo "$(GREEN)🚀 Installation de l'environnement DevOps...$(RESET)"
	chmod +x setup_devops_env.sh && ./setup_devops_env.sh

deploy:
	@echo "$(GREEN)📦 Déploiement Kubernetes...$(RESET)"
	kubectl apply -f k8s/

terraform:
	@echo "$(GREEN)🌍 Déploiement Infrastructure AWS...$(RESET)"
	cd terraform && terraform init && terraform apply -auto-approve

clean:
	@echo "$(GREEN)🧹 Nettoyage...$(RESET)"
	rm -rf *.log .terraform terraform.tfstate*
