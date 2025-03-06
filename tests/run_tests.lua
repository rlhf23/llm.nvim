-- Simple test runner for llm.nvim tests

local plenary_dir = os.getenv("PLENARY_DIR") or "~/.local/share/nvim/site/pack/vendor/start/plenary.nvim"
local command = string.format(
  "nvim --headless --noplugin -u tests/minimal_init.lua -c 'PlenaryBustedDirectory tests/unit/ { minimal_init = \"tests/minimal_init.lua\" }'"
)

os.execute(command)
