-- minimal_init.lua for plugin testing

-- Set up mock vim environment
vim = vim or {}
vim.api = vim.api or {}
vim.fn = vim.fn or {}
vim.go = vim.go or {}

-- Add the plugin source directory to the runtimepath
vim.cmd = vim.cmd or function() end
vim.cmd('set runtimepath+=.')
vim.cmd('set runtimepath+=./tests')
vim.cmd('set runtimepath+=~/.local/share/nvim/site/pack/vendor/start/plenary.nvim')
vim.cmd('runtime plugin/plenary.vim')

-- Load the plugin
require('llm')
