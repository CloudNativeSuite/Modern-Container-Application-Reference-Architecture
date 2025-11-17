init:
	terraform init --upgrade
	terraform init -migrate-state

apply: init
	terraform apply \
		-var="table_name=svc-plus-iac-state-dynamodb-lock" \
		-var="region=ap-northeast-1" \
		-auto-approve
plan: init
	terraform plan -var="table_name=svc-plus-iac-state-dynamodb-lock" -var="region=ap-northeast-1"
output: init
	terraform output
destroy: init
	terraform destroy -var="table_name=svc-plus-iac-state-dynamodb-lock" -var="region=ap-northeast-1"

