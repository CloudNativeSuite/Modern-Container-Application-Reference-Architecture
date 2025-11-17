account_name ?= dev
region ?= ap-northeast-1
role_name ?= TerraformDeployRole-Dev
terraform_user_name ?= sit-ci-runner

init:
	terraform init --upgrade
	terraform init -migrate-state
apply: init
	terraform apply -auto-approve \
		-var="account_name=$(account_name)" \
		-var="region=$(region)" \
		-var="role_name=$(role_name)" \
		-var="terraform_user_name=$(terraform_user_name)"
	terraform output
plan: init
	terraform plan \
		-var="account_name=$(account_name)" \
		-var="region=$(region)" \
		-var="role_name=$(role_name)" \
		-var="terraform_user_name=$(terraform_user_name)"
output: init
	terraform output
destroy: init
	terraform destroy \
		-var="account_name=$(account_name)" \
		-var="region=$(region)" \
		-var="role_name=$(role_name)" \
		-var="terraform_user_name=$(terraform_user_name)"
