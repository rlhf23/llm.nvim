local stub = require('luassert.stub')

describe('prompt_operatorfunc', function()
  local llm = require('llm')
  
  before_each(function()
    -- Stub the required functions
    stub(vim.api, 'nvim_feedkeys')
    stub(vim, 'go') -- This is a trick to handle vim.go table
    vim.go.operatorfunc = ""
  end)
  
  after_each(function()
    vim.api.nvim_feedkeys:revert()
    _G.op_func_llm_prompt = nil
  end)
  
  it('should set up operator function and trigger g@', function()
    -- Call the function with some test options
    local test_opts = { replace = true, service = "test_service" }
    llm.prompt_operatorfunc(test_opts)
    
    -- Check if the global function was set
    assert.is_not_nil(_G.op_func_llm_prompt)
    
    -- Check if operatorfunc was set
    assert.equals("v:lua.op_func_llm_prompt", vim.go.operatorfunc)
    
    -- Check if feedkeys was called with g@
    assert.stub(vim.api.nvim_feedkeys).was_called_with("g@", "n", false)
  end)
  
  it('should preserve original operatorfunc when op_func_llm_prompt is called', function()
    -- Set original operatorfunc to something
    vim.go.operatorfunc = "original_func"
    
    -- Call the function
    llm.prompt_operatorfunc({})
    
    -- Now call the global function that was set
    stub(llm, 'prompt')
    _G.op_func_llm_prompt()
    
    -- Check if original operatorfunc was restored
    assert.equals("original_func", vim.go.operatorfunc)
    
    -- Check if global variable was cleared
    assert.is_nil(_G.op_func_llm_prompt)
    
    -- Clean up
    llm.prompt:revert()
  end)
end)
