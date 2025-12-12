SHELL := /bin/bash

TF=terraform

render:
	python ../../../utils/render_provider_backend.py \
		--config-dir ../../config \
		--template-dir ../../templates \
		--component-dir .. \
		--component role

init:
	$(TF) init --upgrade

plan:
	$(TF) plan

apply:
	$(TF) apply -auto-approve

destroy:
	$(TF) destroy -auto-approve
