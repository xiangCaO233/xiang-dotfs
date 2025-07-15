return {
	"stevearc/conform.nvim",
	opts = {
		-- 定义格式化工具
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			lua = { "stylua" },
			cmake = { "cmake_format" },
			-- 在这里添加其他文件类型的格式化工具
		},
		-- 启用保存时自动格式化
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true, -- 如果 conform 没有配置，则回退到 LSP
		},
	},
}
