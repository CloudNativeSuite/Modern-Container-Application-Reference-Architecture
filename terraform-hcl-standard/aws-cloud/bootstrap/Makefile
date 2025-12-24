# ---------------------------------------------------------
# Bootstrap Makefile - orchestrate bootstrap modules
# ---------------------------------------------------------

ifndef BOOTSTRAP_CONFIG_PATH
$(error BOOTSTRAP_CONFIG_PATH is required)
endif

BOOTSTRAP_CONFIG_ABS := $(abspath $(BOOTSTRAP_CONFIG_PATH))
BOOTSTRAP_ENV        := BOOTSTRAP_CONFIG_PATH="$(BOOTSTRAP_CONFIG_ABS)" TF_VAR_bootstrap_config_path="$(BOOTSTRAP_CONFIG_ABS)"

BOOTSTRAP_S3_DIR       = state
BOOTSTRAP_DYNAMODB_DIR = lock
BOOTSTRAP_IAM_DIR      = identity

# --------------------------------------------
# Bootstrap targets
# --------------------------------------------

bootstrap-init:
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_S3_DIR) init
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_DYNAMODB_DIR) init
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_IAM_DIR) init

bootstrap-apply:
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_S3_DIR) apply
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_DYNAMODB_DIR) apply
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_IAM_DIR) apply
	@echo "🎉 All bootstrap modules completed."

# --------------------------------------------
# Run all bootstraps in order
# --------------------------------------------

bootstrap-plan:
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_S3_DIR) plan
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_DYNAMODB_DIR) plan
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_IAM_DIR) plan

bootstrap-output:
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_S3_DIR) output
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_DYNAMODB_DIR) output
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_IAM_DIR) output

bootstrap-destroy:
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_S3_DIR) destroy
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_DYNAMODB_DIR) destroy
	$(BOOTSTRAP_ENV) make -C $(BOOTSTRAP_IAM_DIR) destroy

bootstrap-reinit: bootstrap-destroy bootstrap
