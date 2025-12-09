# envs/dev-ec2/Makefile

render:
	python ../../render_provider_backend.py

init:
	terraform init --upgrade

plan: init
	terraform plan

apply: init
	terraform apply -auto-approve

output:
	terraform output

destroy: init
	terraform destroy -auto-approve

