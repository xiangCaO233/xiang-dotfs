return {
	"mason-org/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mason-org/mason-lspconfig",
	},
	opts = {},
	config = function(_, opts)
		require("mason").setup(opts)
		local registry = require("mason-registry")
		local success, package = pcall(registry.get_package, "lua-language-server")
		if success and not package:is_installed() then
			package:install()
		end
		local lua_lsp = require("mason-lspconfig").get_mappings().package_to_lspconfig["lua-language-server"]
		vim.lsp.enable("lua_ls")
		require("lspconfig")[lua_lsp].setup({
			settings = {
				Lua = {
					diagnostics = {},
				},
			},
		})
		-- print(vim.inspect(lua_lsp))
		vim.diagnostic.config({
			-- 后置虚拟文本提示
			virtual_text = true,
			-- 虚拟行文本提示
			-- virtual_lines = true,
			update_in_insert = true,
		})
	end,
}
