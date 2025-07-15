-- lua/plugins/coc.lua

return {
	"neoclide/coc.nvim",
	-- 使用 release 分支以获得稳定版本
	branch = "release",
	-- coc.nvim 需要这些依赖
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- 使用 init 函数确保在插件加载前设置好全局变量
	init = function()
		-- 在这里定义你的“默认语言服务器”列表
		-- coc.nvim 会在启动时确保它们都已安装
		vim.g.coc_global_extensions = {
			"coc-css",
			"coc-clangd",
			"coc-cmake",
			"coc-diagnostic",
			"coc-docker",
			"coc-eslint",
			"coc-explorer",
			"coc-flutter-tools",
			"coc-gitignore",
			"coc-html",
			"coc-import-cost",
			"coc-java",
			"coc-jest",
			"coc-json",
			"coc-lists",
			"coc-omnisharp",
			"coc-prisma",
			"coc-pyright",
			"coc-snippets",
			"coc-sourcekit",
			"coc-stylelint",
			"coc-syntax",
			"coc-tasks",
			"coc-vimlsp",
			"coc-yaml",
			"coc-yank",
			"coc-sonarlint",
			"coc-prettier",
		}
		-- 设置代码片段的跳转键 (对应 g:coc_snippet_next/prev)
		vim.g.coc_snippet_next = "<C-j>" -- 下一个占位符
		vim.g.coc_snippet_prev = "<C-k>" -- 上一个占位符 (注：<C-J> 在终端中通常和 <C-j> 相同，建议用一个不同的键，如 <C-k>)
	end,
	config = function()
		-- 在这里放置你的 coc.nvim 键位映射和基本设置

		-- Coc.nvim 的一些推荐设置 (可以在 coc-settings.json 中更详细地配置)
		-- 比如，让 coc 在状态栏显示诊断信息
		vim.g.coc_global_extensions = {}

		-- ===================================================================
		-- 外观和高亮 (Appearance and Highlights)
		-- ===================================================================
		local coc_highlight_group = vim.api.nvim_create_augroup("CocHighlights", { clear = true })

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = coc_highlight_group,
			pattern = "*",
			callback = function()
				-- 1. 获取当前主题的核心颜色
				local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
				local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

				-- 提取前景和背景颜色值 (确保它们存在)
				local comment_fg = comment_hl.fg
				local normal_bg = normal_hl.bg

				-- 如果颜色值无效，则提供一个安全的回退值
				if not comment_fg or not normal_bg then
					return
				end

				-- 2. 定义一个新的、柔和的背景色
				--    - 对于深色主题，我们选择一个比背景稍亮的灰色。
				--    - 对于浅色主题，我们选择一个比背景稍暗的灰色。
				--    你可以根据自己的喜好调整这个颜色值。
				--    一些不错的选择: #2d323a, #30353e, #3a3f4a (由浅到深)
				local hint_bg_color = "#30353e" -- 这是一个比较通用的、柔和的深灰色背景

				-- 3. 设置 CocHintText 的高亮
				vim.api.nvim_set_hl(0, "CocHintText", {
					fg = comment_fg, -- 文字颜色使用注释的颜色
					bg = hint_bg_color, -- 背景颜色使用我们定义的柔和底色
				})

				-- 4. 设置 CocHintSign 的高亮 (提示前面的小图标)
				--    通常让它和文字颜色保持一致即可
				vim.api.nvim_set_hl(0, "CocHintSign", {
					fg = comment_fg, -- 图标颜色也使用注释的颜色
					bg = hint_bg_color, -- 背景也使用相同的底色
				})
			end,
		})

		local keyset = vim.keymap.set
		-- ===================================================================
		-- 键位映射 (Keymaps)
		-- ===================================================================
		local keyset = vim.keymap.set
		local expr_opts = { expr = true, silent = true }
		local silent_opts = { noremap = true, silent = true }

		-- 用于检查光标前是否为空白字符的 Lua 函数
		vim.cmd([[
            function! CheckBackspace() abort
              let col = col('.') - 1
              return !col || getline('.')[col - 1]  =~# '\s'
            endfunction
        ]])

		-- --- 补全和代码片段 (Completion and Snippets) ---
		-- 使用 <C-l> 触发代码片段展开
		keyset("i", "<C-l>", "<Plug>(coc-snippets-expand)", silent_opts)
		-- 使用 <C-j> 在可视化模式下选择代码片段的占位符
		keyset("v", "<C-j>", "<Plug>(coc-snippets-select)", silent_opts)
		-- 使用 <C-j> 来展开片段或跳转到下一个占位符 (由 vim.g.coc_snippet_next 定义)
		keyset("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)", silent_opts)

		-- Tab 键: 如果补全菜单可见，则选择下一个；否则，如果光标前是空白，则插入Tab；否则，触发补全
		keyset(
			"i",
			"<TAB>",
			'coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "<Tab>" : coc#refresh()',
			expr_opts
		)

		-- Shift-Tab 键:
		keyset("i", "<S-TAB>", 'coc#pum#visible() ? coc#pum#prev(1) : "<S-Tab>"', expr_opts)

		-- 回车键
		keyset(
			"i",
			"<CR>",
			[[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
			expr_opts
		)

		-- Ctrl-o (你的配置是这个，但通常会和 normal 模式的单命令冲突，这里保留你的设置)
		-- 注意: nvim 默认的 <C-o> 是临时进入 normal 模式，这个映射会覆盖它
		keyset("i", "<c-o>", "coc#refresh()", expr_opts)

		-- LSP 功能相关的快捷键 (类似你之前的 lsp-keymaps.lua)
		local nmap_opts = { noremap = true, silent = true }
		-- 跳转到定义
		keyset("n", "gd", "<Plug>(coc-definition)", nmap_opts)
		-- 跳转到类型定义
		keyset("n", "gy", "<Plug>(coc-type-definition)", nmap_opts)
		-- 跳转到实现
		keyset("n", "gi", "<Plug>(coc-implementation)", nmap_opts)
		-- 显示引用
		keyset("n", "gr", "<Plug>(coc-references)", nmap_opts)
		-- 显示文档或函数签名
		keyset("n", "<leader>k", "<Plug>(coc-hover)", nmap_opts)
		-- 重命名
		keyset("n", "<leader>rn", "<Plug>(coc-rename)", nmap_opts)
		-- 代码格式化
		keyset("n", "<leader>f", "<Plug>(coc-format-selected)", nmap_opts)
		keyset("v", "<leader>f", "<Plug>(coc-format-selected)", nmap_opts)
		-- 代码操作（修复、重构等）
		keyset("n", "<leader>ca", "<Plug>(coc-codeaction)", nmap_opts)
		-- 诊断信息跳转
		keyset("n", "[d", "<Plug>(coc-diagnostic-prev)", nmap_opts)
		keyset("n", "]d", "<Plug>(coc-diagnostic-next)", nmap_opts)
		-- 在浮动窗口中显示光标处的诊断信息
		keyset("n", "<leader>d", function()
			vim.fn.CocAction("diagnosticInfo")
		end, silent_opts)
		-- 在列表中显示所有诊断信息
		--    <leader>lD: 列出整个工作区(项目)的所有诊断
		keyset("n", "<leader>ld", ":CocList diagnostics<CR>", silent_opts)
		--    <leader>ld: 仅列出当前文件的诊断
		keyset("n", "<leader>lD", ":CocList diagnostics --bufnr %<CR>", silent_opts)
	end,
}
