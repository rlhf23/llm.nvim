local stub = require('luassert.stub')
local mock_helpers = require('tests.unit.mock_helpers')

describe('create_llm_md function', function()
  local llm = require('llm')
  local mocks
  local get_current_buf_stub
  
  before_each(function()
    -- Set up mocks for the buffer and file operations
    mocks = mock_helpers.setup_buffer_mocks({
      buf_name = "/some/other/file.lua",
      cwd = "/test/cwd"
    })
    
    -- Additional stubs
    stub(vim.api, 'nvim_buf_set_option')
    stub(vim.api, 'nvim_win_set_buf')
    
    -- Create a separate stub for get_current_buf that we'll override in tests
    mocks.get_current_buf:revert() -- Remove the one from setup_buffer_mocks
    get_current_buf_stub = stub(vim.api, 'nvim_get_current_buf')
    get_current_buf_stub.returns(5)
  end)
  
  after_each(function()
    mock_helpers.teardown_mocks(mocks)
    vim.api.nvim_buf_set_option:revert()
    vim.api.nvim_win_set_buf:revert()
    get_current_buf_stub:revert()
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
    mocks.buf_get_name:revert()
    stub(vim.api, 'nvim_buf_get_name').returns("/test/cwd/llm.md")
    
    -- Call the function
    llm.create_llm_md()
    
    -- Since we're already in llm.md, it should not call edit
    assert.stub(vim.api.nvim_command).was_not_called()
  end)
end)
