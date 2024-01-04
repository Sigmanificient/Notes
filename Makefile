SPHINXOPTS = -W
SPHINXBUILD = sphinx-build

BUILD_DIR = .build

.PHONY: html

html:
	$(SPHINXBUILD) src -b html $(BUILD_DIR)/html
