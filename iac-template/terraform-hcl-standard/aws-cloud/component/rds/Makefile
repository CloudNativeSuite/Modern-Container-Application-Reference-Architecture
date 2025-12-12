SHELL := /bin/bash

TF=terraform

render:
	python ../../../utils/render_provider_backend.py \
		--config-dir ../../config \
		--template-dir ../../templates \
		--component-dir .. \
		--component rds

init:
	$(TF) init --upgrade

plan:
	$(TF) plan

apply:
	$(TF) apply -auto-approve

output:
	$(TF) output

destroy:
	$(TF) destroy -auto-approve
