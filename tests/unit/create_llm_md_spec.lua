local stub = require('luassert.stub')
local mock_helpers = require('tests.unit.mock_helpers')

describe('create_llm_md function', function()
  local llm = require('llm')
  local mocks
  
  before_each(function()
    -- Set up mocks for the buffer and file operations
    mocks = mock_helpers.setup_buffer_mocks({
      buf_name = "/some/other/file.lua",
      cwd = "/test/cwd"
    })
    
    -- Additional stub for set_option
    stub(vim.api, 'nvim_buf_set_option')
    stub(vim.api, 'nvim_win_set_buf')
    stub(vim.api, 'nvim_get_current_buf', function() return 5 end)
  end)
  
  after_each(function()
    mock_helpers.teardown_mocks(mocks)
    vim.api.nvim_buf_set_option:revert()
    vim.api.nvim_win_set_buf:revert()
    vim.api.nvim_get_current_buf:revert()
  end)
  
  it('should create and edit an llm.md file', function()
    -- Call the function
    llm.create_llm_md()
    
    -- Check if the edit command was called with the correct path
    assert.stub(vim.api.nvim_command).was_called_with("edit /test/cwd/llm.md")
    
    -- Check if filetype was set to markdown
    assert.stub(vim.api.nvim_buf_set_option).was_called()
    
    -- Check if window buffer was set
    assert.stub(vim.api.nvim_win_set_buf).was_called()
  end)
  
  it('should not edit if already in llm.md', function()
    -- Change the mocked buffer name to llm.md
    vim.api.nvim_buf_get_name:revert()
    stub(vim.api, 'nvim_buf_get_name', function() return "/test/cwd/llm.md" end)
    
    -- Call the function
    llm.create_llm_md()
    
    -- Since we're already in llm.md, it should not call edit
    assert.stub(vim.api.nvim_command).was_not_called()
  end)
end)
