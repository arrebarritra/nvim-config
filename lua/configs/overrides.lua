local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"typescript",
		"c",
		"cmake",
		"cpp",
		"make",
		"python",
		"yaml",
		"json",
		"make",
		"bash",
		"markdown",
	},
	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",

		-- C / C++
		"clangd",
		"clang-format",
		"cmake-language-server",
		"cpplint",
		"cpptools",

		-- shell
		"shellcheck",
		"shellharden",
		"bash-language-server",
		"bash-debug-adapter",
		"awk-language-server",

		-- python
		"pyright",
		"pylint",
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
			glyphs = {
				git = {
					unstaged = "-",
					staged = "+",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
}

M.ui = {
	tabufline = {
		lazyload = false,
		overriden_modules = nil,
	},
}

M.cmp = {
	formatting = {
		format = function(entry, vim_item)
			local icons = require("nvchad.icons.lspkind")
			vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ({
				luasnip = "[Luasnip]",
				nvim_lsp = "[Nvim LSP]",
				buffer = "[Buffer]",
				nvim_lua = "[Nvim Lua]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
}

M.telescope = {
	defaults = {
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},
		mappings = {
			i = {
				["<esc>"] = function(...)
					require("telescope.actions").close(...)
				end,
			},
		},
	},
	pickers = {
		live_grep = {
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
			additional_args = function(_)
				return { "--hidden" }
			end,
		},
		find_files = {
			file_ignore_patterns = { "node_modules", ".git", ".venv" },
			hidden = true,
		},
	},
}

M.conform = {
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		go = { "gofumpt", "goimports-reviser", "golines" },
		python = { "isort", "black" },
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return M
