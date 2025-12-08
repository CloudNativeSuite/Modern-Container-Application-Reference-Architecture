account_name ?=
region ?=
role_name ?=
terraform_user_name ?=

TF_VARS := $(if $(account_name),-var="account_name=$(account_name)") $(if $(region),-var="region=$(region)") $(if $(role_name),-var="role_name=$(role_name)") $(if $(terraform_user_name),-var="terraform_user_name=$(terraform_user_name)")

init:
	terraform init --upgrade
	terraform init -migrate-state
apply: init
	terraform apply -auto-approve $(TF_VARS)
	terraform output
plan: init
	terraform plan $(TF_VARS)
output: init
	terraform output
destroy: init
	terraform destroy $(TF_VARS)
