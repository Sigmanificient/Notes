BUILD_DIR = .build

.PHONY: html

html:
	mkdir -p $(BUILD_DIR)/html
	echo "it works"> $(BUILD_DIR)/html/grass
