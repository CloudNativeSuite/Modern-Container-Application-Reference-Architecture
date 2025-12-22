render:
	python ../../../utils/render_provider_backend.py \
		--config-dir ../../config \
		--template-dir ../../templates \
		--component-dir .. \
		--component kafka

init: render
	terraform init --upgrade

plan: init
	terraform plan

apply: init
	terraform apply -auto-approve

destroy: init
	terraform destroy -auto-approve
