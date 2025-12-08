bucket_name ?=
region ?=

TF_VARS := $(if $(bucket_name),-var="bucket_name=$(bucket_name)") $(if $(region),-var="region=$(region)")

init:
	terraform init --upgrade
	terraform init -migrate-state

apply: init
	terraform apply $(TF_VARS) -auto-approve
	terraform output

plan: init
	terraform plan $(TF_VARS)

output: init
	terraform output

destroy:
	@test -n "$(bucket_name)" || (echo "bucket_name is required for destroy" && exit 1)
	aws s3 rb "s3://$(bucket_name)" --force $(if $(region),--region $(region),)
