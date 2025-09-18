# Testing llm.nvim

This directory contains tests for the llm.nvim plugin.

## Setup

The tests rely on [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for the test framework. You can install it using your plugin manager or directly:

```bash
# Using make
make install-deps

# Or manually
mkdir -p ~/.local/share/nvim/site/pack/vendor/start
git clone https://github.com/nvim-lua/plenary.nvim.git ~/.local/share/nvim/site/pack/vendor/start/plenary.nvim
```

## Running Tests

You can run all tests using:

```bash
# Using make
make test

# Or directly
nvim --headless --noplugin -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/unit/ { minimal_init = 'tests/minimal_init.lua' }"
```

To run a specific test file:

```bash
# Using make
make test-file FILE=tests/unit/llm_spec.lua

# Or directly
nvim --headless --noplugin -u tests/minimal_init.lua -c "PlenaryBustedFile tests/unit/llm_spec.lua"
```

## Test Structure

- `minimal_init.lua`: Minimal Neovim configuration for testing
- `unit/`: Unit tests for each component of the plugin
  - `llm_spec.lua`: Tests for the main llm module
  - `service_spec.lua`: Tests for service configuration
- `mock_helpers.lua`: Helpers for mocking Neovim APIs
