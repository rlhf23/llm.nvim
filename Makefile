.PHONY: test

# Path to plenary.nvim (change this if needed)
PLENARY_DIR ?= ~/.local/share/nvim/site/pack/vendor/start/plenary.nvim

test:
	@echo "Running tests for llm.nvim..."
	PLENARY_DIR=$(PLENARY_DIR) nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/unit/ { minimal_init = 'tests/minimal_init.lua' }"

test-file:
	@echo "Running tests for file $(FILE)..."
	PLENARY_DIR=$(PLENARY_DIR) nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedFile $(FILE)"

install-deps:
	@echo "Installing test dependencies..."
	mkdir -p ~/.local/share/nvim/site/pack/vendor/start
	[ -d $(PLENARY_DIR) ] || \
		git clone https://github.com/nvim-lua/plenary.nvim.git $(PLENARY_DIR)

clean:
	@echo "Cleaning test artifacts..."
	rm -rf .tests_output.txt
