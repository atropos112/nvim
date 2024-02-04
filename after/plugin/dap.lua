require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")

vim.keymap.set('n', '<leader>dc', function()
	require('dapui').open()
	require('dap').continue()
end)
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end)
vim.keymap.set('n', '<leader>c', function() require('dap').step_over() end)
vim.keymap.set('n', '<leader>dt', function()
	require('dap').terminate()
	require("dapui").close()
end)
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end)

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

--- language specific below 


-- go
require('dap-go').setup {
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
    {
      -- Must be "go" or it will be ignored by the plugin
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  -- delve configurations
  delve = {
    -- the path to the executable dlv which will be used for debugging.
    -- by default, this is the "dlv" executable on your PATH.
    path = "dlv",
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port
    port = "${port}",
    -- additional args to pass to dlv
    args = {},
    -- the build flags that are passed to delve.
    -- defaults to empty string, but can be used to provide flags
    -- such as "-tags=unit" to make sure the test suite is
    -- compiled during debugging, for example.
    -- passing build flags using args is ineffective, as those are
    -- ignored by delve in dap mode.
    build_flags = "",
  },
}
dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
		-- assuming codelldb is in your PATH
        command = "codelldb",
        args = { '--port', '${port}' },
    },
}

dap.configurations.rust = {
    {
        name = 'Debug with codelldb',
        type = 'codelldb',
        request = 'launch',
        program = function()

			-- we build first 
			vim.fn.jobstart('cargo build', {
				on_exit = function(_, code)
					if code == 0 then
						vim.notify('Build successful')
					else
						vim.notify('Build failed')
					end
				end
			})
			local parent = vim.fn.fnamemodify(vim.fn.getcwd(), ':h')
			-- then we run the program
			return parent .. '/target/debug/' .. vim.fn.fnamemodify(parent, ':t')
		end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}


dap.adapters.netcoredbg= {
  type = 'executable',
  command = 'netcoredbg',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "netcoredbg",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
