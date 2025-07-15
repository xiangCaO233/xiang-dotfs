-- lua/plugins/colorscheme.lua

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- 确保它在所有UI插件之前加载
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- 或者 "latte", "frappe", "mocha"

			-- 这是实现你想要效果的关键！
			transparent_background = true,

			-- 让终端的斜体和粗体生效
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = { "italic" },
				operators = {},
			},
			-- 为各种插件提供无缝的颜色集成
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				telescope = true,
				notify = true,
				mini = true,
			},
		})

		-- 在配置完成后立即加载主题
		vim.cmd.colorscheme("catppuccin")
	end,
}
