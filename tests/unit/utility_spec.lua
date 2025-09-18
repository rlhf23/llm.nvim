local stub = require('luassert.stub')
local mock_helpers = require('tests.unit.mock_helpers')

describe('utility functions', function()
  local llm = require('llm')
  
  -- Test get_selection function
  describe('get_selection', function()
    before_each(function()
      -- Stub vim.fn.mode and vim.fn.getpos
      stub(vim.fn, 'mode')
      stub(vim.fn, 'getpos')
      stub(vim.api, 'nvim_buf_get_lines')
      stub(vim.api, 'nvim_buf_get_text')
    end)
    
    after_each(function()
      vim.fn.mode:revert()
      vim.fn.getpos:revert()
      vim.api.nvim_buf_get_lines:revert()
      vim.api.nvim_buf_get_text:revert()
    end)
    
    it('should handle visual line mode', function()
      -- Setup mocks for visual line mode
      vim.fn.mode.returns('V')
      vim.fn.getpos.on_call_with('v').returns({0, 3, 1, 0})  -- start
      vim.fn.getpos.on_call_with('.').returns({0, 5, 1, 0})  -- end
      
      -- Mock the buffer lines
      vim.api.nvim_buf_get_lines.returns({'line1', 'line2', 'line3'})
      
      -- Call the function
      local result = llm.get_selection()
      
      -- Verify correct function was called
      assert.stub(vim.api.nvim_buf_get_lines).was_called_with(0, 2, 5, true)
      
      -- Verify result
      assert.are.same({'line1', 'line2', 'line3'}, result)
    end)
    
    it('should handle regular visual mode', function()
      -- Setup mocks for regular visual mode
      vim.fn.mode.returns('v')
      vim.fn.getpos.on_call_with('v').returns({0, 3, 5, 0})  -- start
      vim.fn.getpos.on_call_with('.').returns({0, 3, 10, 0}) -- end
      
      -- Mock the buffer text
      vim.api.nvim_buf_get_text.returns({'selected text'})
      
      -- Call the function
      local result = llm.get_selection()
      
      -- Verify correct function was called
      assert.stub(vim.api.nvim_buf_get_text).was_called_with(0, 2, 4, 2, 10, {})
      
      -- Verify result
      assert.are.same({'selected text'}, result)
    end)
  end)
  
  -- Add more utility function tests as needed
end)
