CONFIG_FILES ?=

CONFIG_FILES_JSON := $(shell python - <<'PY'
import json
from pathlib import Path

raw = '''$(CONFIG_FILES)'''
files = [line.strip() for line in raw.splitlines() if line.strip()]
resolved = [str(Path(path).expanduser().resolve()) for path in files]
print(json.dumps(resolved)) if resolved else print("")
PY)

CONFIG_FILES_ENV := $(if $(CONFIG_FILES_JSON),TF_VAR_config_files='$(CONFIG_FILES_JSON)')

render:
        python ../../../utils/render_provider_backend.py \
                --config-dir ../../config \
                --template-dir ../../templates \
                --component-dir .. \
                --component vpc

init: render
        $(CONFIG_FILES_ENV) terraform init --upgrade

plan: init
        $(CONFIG_FILES_ENV) terraform plan

apply: init
        $(CONFIG_FILES_ENV) terraform apply -auto-approve
