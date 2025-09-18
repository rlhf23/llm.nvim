-- Helper module for mocking nvim APIs in tests

local stub = require('luassert.stub')
local M = {}

-- Mock for vim.api.nvim_get_current_buf
function M.mock_current_buf()
  local buf_id = 1
  return stub(vim.api, 'nvim_get_current_buf', function() 
    return buf_id 
  end)
end

-- Mock for vim.api.nvim_buf_get_name
function M.mock_buf_name(name)
  return stub(vim.api, 'nvim_buf_get_name', function() 
    return name 
  end)
end

-- Mock for vim.fn.getcwd
function M.mock_getcwd(path)
  return stub(vim.fn, 'getcwd', function() 
    return path 
  end)
end

-- Mock for vim.api.nvim_command
function M.mock_command()
  return stub(vim.api, 'nvim_command')
end

-- Setup common mocks for file/buffer operations
function M.setup_buffer_mocks(opts)
  opts = opts or {}
  
  local mocks = {
    get_current_buf = M.mock_current_buf(),
    buf_get_name = M.mock_buf_name(opts.buf_name or "test_buffer"),
    getcwd = M.mock_getcwd(opts.cwd or "/test/cwd"),
    command = M.mock_command()
  }
  
  return mocks
end

-- Clean up mocks
function M.teardown_mocks(mocks)
  for _, mock in pairs(mocks) do
    if mock.revert then
      mock:revert()
    end
  end
end

return M
