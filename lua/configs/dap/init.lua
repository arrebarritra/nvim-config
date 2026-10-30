local dap = require("dap")

-- ui
require("configs.dap.ui")

local path_sep = package.config:sub(1, 1)
local is_windows = path_sep == "\\"

-- debuggers
local gdb
if not is_windows then
	gdb = require("configs.dap.adapters.gdb")
	dap.adapters.gdb = gdb.adapter
end
local cppdbg = require("configs.dap.adapters.cppdbg")
require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/bin/debugpy" .. (is_windows and ".cmd" or ""))

dap.adapters.cppdbg = cppdbg.adapter

dap.configurations.c = is_windows and cppdbg.config or gdb.config
dap.configurations.cpp = cppdbg.config
dap.configurations.rust = cppdbg.config
