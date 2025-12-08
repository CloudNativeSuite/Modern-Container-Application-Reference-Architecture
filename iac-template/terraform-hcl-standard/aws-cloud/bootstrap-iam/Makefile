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

destroy:
	@test -n "$(role_name)" || (echo "role_name is required for destroy" && exit 1)
	@test -n "$(terraform_user_name)" || (echo "terraform_user_name is required for destroy" && exit 1)
	aws iam delete-user-policy --user-name "$(terraform_user_name)" --policy-name "$(terraform_user_name)-iac-policy" || true
	aws iam delete-user --user-name "$(terraform_user_name)" || true
	aws iam detach-role-policy --role-name "$(role_name)" --policy-arn arn:aws:iam::aws:policy/AdministratorAccess || true
	aws iam delete-role --role-name "$(role_name)" || true
