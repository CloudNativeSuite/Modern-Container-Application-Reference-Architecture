# ---------------------------------------------------------
# Root Makefile - orchestrate bootstrap modules
# ---------------------------------------------------------

AWS_BOOTSTRAP_DIR       = aws-cloud/bootstrap
BOOTSTRAP_S3_DIR        = $(AWS_BOOTSTRAP_DIR)/state
BOOTSTRAP_DYNAMODB_DIR  = $(AWS_BOOTSTRAP_DIR)/lock
BOOTSTRAP_IAM_DIR       = $(AWS_BOOTSTRAP_DIR)/identity

# --------------------------------------------
# Bootstrap targets
# --------------------------------------------

bootstrap-init:
	make -C $(BOOTSTRAP_S3_DIR) init
	make -C $(BOOTSTRAP_DYNAMODB_DIR) init
	make -C $(BOOTSTRAP_IAM_DIR) init

bootstrap-apply:
	make -C $(BOOTSTRAP_S3_DIR) apply
	make -C $(BOOTSTRAP_DYNAMODB_DIR) apply
	make -C $(BOOTSTRAP_IAM_DIR) apply
	@echo "🎉 All bootstrap modules completed."

# --------------------------------------------
# Run all bootstraps in order
# --------------------------------------------

bootstrap-plan:
	make -C $(BOOTSTRAP_S3_DIR) plan
	make -C $(BOOTSTRAP_DYNAMODB_DIR) plan
	make -C $(BOOTSTRAP_IAM_DIR) plan


bootstrap-output:
	make -C $(BOOTSTRAP_S3_DIR) output
	make -C $(BOOTSTRAP_DYNAMODB_DIR) output
	make -C $(BOOTSTRAP_IAM_DIR) output

bootstrap-destroy:
	make -C $(BOOTSTRAP_S3_DIR) destroy
	make -C $(BOOTSTRAP_DYNAMODB_DIR) destroy
	make -C $(BOOTSTRAP_IAM_DIR) destroy

bootstrap-reinit: bootstrap-destroy bootstrap
