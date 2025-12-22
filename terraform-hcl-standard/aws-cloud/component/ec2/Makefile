# instance/ec2/Makefile

render:
	python ../../../utils/render_provider_backend.py \
		--config-dir ../../config \
		--template-dir ../../templates \
		--component-dir .. \
		--component ec2

init: render
	terraform init --upgrade

plan: init
	terraform plan

apply: init
	terraform apply -auto-approve

output:
	terraform output

destroy: init
	terraform destroy -auto-approve
