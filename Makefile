.PHONY: all plan apply destroy k3s-install

all: apply k3s-install

init:
	cd terraform/k3s-cluster && terraform init

plan:
	cd terraform/k3s-cluster && terraform plan

apply:
	@echo "=== Deploying Infrastructure with Terraform ==="
	cd terraform/k3s-cluster && terraform apply -auto-approve

k3s-install:
	@echo "=== ☕ Waiting for SSH to be ready (30s) ==="
	sleep 30
	@echo "=== Bootstrapping Nodes ==="
	cd ansible && ansible-playbook playbooks/bootstrap.yaml
	@echo "=== Installing K3s Cluster ==="
	cd ansible && ansible-playbook playbooks/k3s.yaml

destroy:
	cd terraform/k3s-cluster && terraform destroy -auto-approve
