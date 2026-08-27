-- This adapter seems to work better with nvim-dap-ui
-- You will need to download and set up the cpptools extension for this to work
-- eg:
-- mkdir -p ~/.local/share/cpptools
-- cd ~/.local/share/cpptools
-- wget https://github.com/microsoft/vscode-cpptools/releases/download/1.25.3/cpptools-linux-X64.vsix
-- unzip cpptools-linux.vsix -d cpptools
-- chmod +x cpptools/extension/debugAdapters/bin/OpenDebugAD7

local M = {}

local home = os.getenv("HOME")

M.adapter = {
	id = "cppdbg",
	type = "executable",
	command = home .. "/.local/share/cpptools/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
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
	else
		-- Clear cache
		cmd = nil
	end

	return program, args
end

M.config = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			local p, a = get_command()
			print("Program: { ", p, " } Args: { ", table.concat(a), " }")
			return p
		end,
		args = function()
			local _, a = get_command()
			return a
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "Enable pretty printing",
				ignoreFailures = false,
			},
		},
	},
	{
		name = "Attach to gdbserver :1234",
		type = "cppdbg",
		request = "launch",
		args = function()
			local args_string = vim.fn.input("Input arguments: ")
			return vim.split(args_string, " ")
		end,
		program = function()
			return vim.fn.input("Path to local executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		miMode = "gdb",
		miDebuggerServerAddress = "localhost:1234", -- gdbserver address
		miDebuggerPath = "/usr/bin/gdb",
		stopOnEntry = false,
		setupCommands = {
			{
				text = "-enable-pretty-printing",
				description = "Enable pretty printing",
				ignoreFailures = false,
			},
		},
	},
}

return M
