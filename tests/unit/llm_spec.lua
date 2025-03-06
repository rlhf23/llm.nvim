local stub = require('luassert.stub')
local match = require('luassert.match')

describe('llm.nvim', function()
  local llm = require('llm')
  local original_os_getenv

  before_each(function()
    -- Backup original os.getenv
    original_os_getenv = os.getenv
    -- Mock os.getenv to return test API keys
    os.getenv = function(name)
      if name == "GROQ_API_KEY" then
        return "test_groq_key"
      elseif name == "OPENAI_API_KEY" then
        return "test_openai_key"
      elseif name == "ANTHROPIC_API_KEY" then
        return "test_anthropic_key"
      else
        return original_os_getenv(name)
      end
    end
    
    -- Create stubs for the vim API functions we'll use
    stub(vim.api, 'nvim_create_user_command')
    stub(vim.keymap, 'set')
  end)

  after_each(function()
    -- Restore original functions
    os.getenv = original_os_getenv
    vim.api.nvim_create_user_command:revert()
    vim.keymap.set:revert()
  end)

  describe('setup', function()
    it('should register commands and keymaps by default', function()
      llm.setup({})
      
      -- Check if commands were created
      assert.stub(vim.api.nvim_create_user_command).was_called_with('LLMGroq', match._, match._)
      assert.stub(vim.api.nvim_create_user_command).was_called_with('LLMOpenAI', match._, match._)
      assert.stub(vim.api.nvim_create_user_command).was_called_with('LLMClaude', match._, match._)
      assert.stub(vim.api.nvim_create_user_command).was_called_with('LLM', match._, match._)
      
      -- Check if keymaps were set
      assert.stub(vim.keymap.set).was_called()
    end)

    it('should not set keymaps when disabled', function()
      llm.setup({ set_keymaps = false })
      
      -- Commands should still be registered
      assert.stub(vim.api.nvim_create_user_command).was_called()
      
      -- But keymaps should not be set
      assert.stub(vim.keymap.set).was_not_called()
    end)
    
    it('should allow custom service configuration', function()
      local custom_service = {
        url = "https://example.com/api",
        model = "custom-model",
        api_key_name = "CUSTOM_API_KEY"
      }
      
      llm.setup({
        services = {
          custom_service = custom_service
        }
      })
      
      -- We would need access to the internal service_lookup table to test this properly
      -- This is just a placeholder for now
    end)
  end)
end)
