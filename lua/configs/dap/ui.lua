local dap, dapui, dapvt = require("dap"), require("dapui"), require("nvim-dap-virtual-text")

-- open / close ui windows automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

dap.listeners.after.disconnect["virtual_text_cleanup"] = function()
	vim.schedule(function()
		pcall(vim.cmd, "DapVirtualTextForceRefresh")
	end)
end
