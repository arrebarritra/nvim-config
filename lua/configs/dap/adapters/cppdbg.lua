-- This adapter seems to work better with nvim-dap-ui
-- You will need to download and set up the cpptools extension for this to work
-- eg:
-- mkdir -p ~/.local/share/cpptools
-- cd ~/.local/share/cpptools
-- wget https://github.com/microsoft/vscode-cpptools/releases/download/1.25.3/cpptools-linux-X64.vsix
-- unzip cpptools-linux.vsix -d cpptools
-- chmod +x cpptools/extension/debugAdapters/bin/OpenDebugAD7

local M = {}

local home = os.getenv("HOME") or os.getenv("USERPROFILE")

M.adapter = {
  id = 'cppdbg',
  type = 'executable',
  command = home .. '/.vscode/extensions/ms-vscode.cpptools-1.32.2-win32-x64/debugAdapters/bin/OpenDebugAD7.exe',
}

M.config = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      local cmd = vim.fn.input("Launch cmd: ", vim.fn.getcwd() .. "\\", "shellcmdline")
      local parts = vim.split(cmd, "%s+", { trimempty = true })

      cmd_cache = parts
      return parts[1]
    end,

    args = function()
      if not cmd_cache then return {} end

      local args = vim.deepcopy(cmd_cache)
      table.remove(args, 1)
      return args
    end,
    cwd = vim.fn.getcwd(),
    stopOnEntry = true,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'Enable pretty printing',
        ignoreFailures = false
      },
    },
  },
}

return M
