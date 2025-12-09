SHELL := /bin/bash

TF=terraform

render:
	python ../../render_provider_backend.py

init:
	$(TF) init --upgrade

plan:
	$(TF) plan

apply:
	$(TF) apply -auto-approve

destroy:
	$(TF) destroy -auto-approve

