local M = {}

local path_sep = package.config:sub(1, 1)
local is_windows = vim.fn.has("win32") == 1

M.adapter = {
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/bin/codelldb" .. (is_windows and ".cmd" or ""),
	options = {
		detached = false,
	},
	env = {
		LLDB_USE_NATIVE_PDB_READER = "1",
	},
}

local cmd
local program
local args
local function get_command()
	if not cmd then
		cmd = vim.fn.input("Launch cmd: ", vim.fn.getcwd() .. path_sep, "shellcmdline")

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
		type = "codelldb",
		request = "launch",
		program = function()
			local p, a = get_command()
			print("Program: { ", p, " } Args: { ", table.concat(a, " "), " }")
			return p
		end,
		args = function()
			local _, a = get_command()
			return a
		end,
		cwd = function()
			return vim.fn.getcwd()
		end,
		stopOnEntry = false,
		terminal = "integrated",
	},
}

return M
