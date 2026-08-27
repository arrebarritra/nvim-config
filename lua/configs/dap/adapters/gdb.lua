local M = {}

M.adapter = {
	type = "executable",
	command = "gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

local cmd
local program
local args
local function get_command()
	if not cmd then
		cmd = vim.fn.input("Launch cmd: ", vim.fn.getcwd() .. "/", "shellcmdline")

		local parts = vim.split(cmd, "%s+", { trimempty = true })

		if #parts == 0 then
			return nil, {}
		end

		program = table.remove(parts, 1)
		args = parts
	end

	return program, args
end

M.config = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			local p, a = get_command()
			print("Program: {", p, "} Args: {", table.concat(a), "}")
			return p
		end,
		args = function()
			local _, a = get_command()
			return a
		end,
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = false,
	},
	{
		name = "Select and attach to process",
		type = "gdb",
		request = "attach",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		pid = function()
			local name = vim.fn.input("Executable name (filter): ")
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = "${workspaceFolder}",
	},
	{
		name = "Attach to gdbserver :1234",
		type = "gdb",
		request = "attach",
		target = "localhost:1234",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}

return M
