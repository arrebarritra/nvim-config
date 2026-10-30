local dap = require("dap")
dap.set_log_level("TRACE")

-- ui
require("configs.dap.ui")

local is_windows = vim.fn.has("win32") == 1

-- debuggers
local gdb
if not is_windows then
	gdb = require("configs.dap.adapters.gdb")
	dap.adapters.gdb = gdb.adapter
end
local cppdbg = require("configs.dap.adapters.cppdbg")
local codelldb = require("configs.dap.adapters.codelldb")
require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/bin/debugpy" .. (is_windows and ".cmd" or ""))

dap.adapters.cppdbg = cppdbg.adapter
dap.adapters.codelldb = codelldb.adapter

dap.configurations.c = is_windows and cppdbg.config or gdb.config
dap.configurations.cpp = is_windows and codelldb.config or cppdbg.config
dap.configurations.rust = cppdbg.config
