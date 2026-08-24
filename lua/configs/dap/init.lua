local dap = require("dap")

-- ui
require("configs.dap.ui")

-- debuggers
local cppdbg = require("configs.dap.adapters.cppdbg")

dap.adapters.cppdbg = cppdbg.adapter

dap.configurations.c = cppdbg.config
dap.configurations.cpp = cppdbg.config
dap.configurations.rust = cppdbg.config
