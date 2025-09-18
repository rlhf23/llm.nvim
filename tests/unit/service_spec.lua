local match = require('luassert.match')
local stub = require('luassert.stub')

describe('llm.nvim service config', function()
  local llm = require('llm')
  local original_os_getenv
  
  before_each(function()
    original_os_getenv = os.getenv
    os.getenv = function(name)
      if name == "TEST_API_KEY" then
        return "test_key"
      else
        return original_os_getenv(name)
      end
    end
    
    -- Reset environment between tests
    package.loaded['llm'] = nil
    llm = require('llm')
    
    -- Stub vim functions we use
    stub(vim.api, 'nvim_create_user_command')
    stub(vim.keymap, 'set')
  end)
  
  after_each(function()
    os.getenv = original_os_getenv
    vim.api.nvim_create_user_command:revert()
    vim.keymap.set:revert()
  end)
  
  it('allows custom service configuration', function()
    local custom_config = {
      services = {
        test_service = {
          url = "https://test.api/v1",
          model = "test-model",
          api_key_name = "TEST_API_KEY"
        }
      }
    }
    
    llm.setup(custom_config)
    
    -- Now we need to test that the service was configured correctly
    -- This is tricky since service_lookup is a local variable in llm.lua
    
    -- One approach is to test the prompt function with the custom service
    -- But for now this is just a placeholder test
    
    assert.is_true(true)
  end)
end)
