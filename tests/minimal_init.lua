-- minimal_init.lua for plugin testing

-- Add the plugin source directory to the runtimepath
vim.cmd('set runtimepath+=.')
vim.cmd('set runtimepath+=./tests')
vim.cmd('set runtimepath+=~/.local/share/nvim/site/pack/packer/start/plenary.nvim')
vim.cmd('runtime plugin/plenary.vim')

-- Load the plugin
require('llm')
