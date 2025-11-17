init:
	terraform init --upgrade
	terraform init -migrate-state

apply: init
	terraform apply -var="bucket_name=svc-plus-iac-state" -var=region=ap-northeast-1 -auto-approve
	terraform output

plan: init
	terraform plan -var="bucket_name=svc-plus-iac-state" -var=region=ap-northeast-1

output: init
	terraform output
destroy: init
	terraform destroy -var="bucket_name=svc-plus-iac-state" -var=region=ap-northeast-1
