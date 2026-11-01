-- Handshake code
local utils = require("dap.utils")

local rpc = require("dap.rpc")

local function send_payload(client, payload)
	local msg = rpc.msg_with_content_length(vim.json.encode(payload))
	client.write(msg)
end

function RunHandshake(self, request_payload)
	local signResult = io.popen("node ../../../../js/sign.js " .. request_payload.arguments.value)
	if signResult == nil then
		utils.notify("error while signing handshake", vim.log.levels.ERROR)
		return
	end
	local signature = signResult:read("*a")
	signature = string.gsub(signature, "\n", "")
	local response = {
		type = "response",
		seq = 0,
		command = "handshake",
		request_seq = request_payload.seq,
		success = true,
		body = {
			signature = signature,
		},
	}
	send_payload(self.client, response)
end

local M = {}

local path_sep = package.config:sub(1, 1)
local is_windows = vim.fn.has("win32") == 1

M.adapter = {
	id = "cppvsdbg",
	type = "executable",
	command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/vsdbg/bin/vsdbg",
	args = {
		"--interpreter=vscode",
	},
	options = {
		externalTerminal = true,
		-- logging = {
		--   moduleLoad = false,
		--   trace = true
		-- }
	},
	runInTerminal = true,
	reverse_request_handlers = {
		handshake = RunHandshake,
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
		type = "cppvsdbg",
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
		cwd = vim.fn.getcwd(),
		clientID = "vscode",
		clientName = "Visual Studio Code",
		externalTerminal = true,
		columnsStartAt1 = true,
		linesStartAt1 = true,
		locale = "en",
		pathFormat = "path",
		externalConsole = true,
	},
}

return M
